## Requisitos de sistema

> En Ubuntu 18.10

#### Instalación en una VM desde cero

```console
# Las URLs de apt en la instalación por defecto de Ubuntu 18 están desactualizadas
sudo sed -i 's/us.archive/old-releases/g' /etc/apt/sources.list
# Se usa `;` en vez de `&&` ya que el repositorio `cosmic-security` fallará
# al ser una versión tan antigua de Ubuntu
sudo apt update ; sudo apt upgrade -y
```

#### Dependencias necesarias

```console
sudo apt install -y build-essential git
# Véase https://wiki.ubuntu.com/Kernel/BuildYourOwnKernel#Build_Environment
sudo apt install -y libncurses-dev gawk flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf llvm
```

#### Otras versiones de Ubuntu

```console
# La última major-release de gcc creada antes de 2019 es la 8,
# y como Linux 4.17 se creó en 2018 se deberá usar esta versión
# Estos comandos seguramente no son necesarios en Ubuntu 18 ya que
# la versión de gcc instalada con `build-essential` es la 8, pero
# en Ubuntu 20 sí será necesario.
# En versiones más modernas, ni siquiera el repositorio `universe`
# contiene dicha versión, por lo que se recomienda instalarlo de source
sudo add-apt-repository universe
sudo apt update
sudo apt install -y gcc-8
```

## Parches del código

Debido a que el código fuente original es tan grande, resulta
contraproducente crear un fork, puesto que tardaría mucho en clonarse
el repositorio (incluso con un shallow-clone o un blobless-clone). Es
por ello que se obtiene el código fuente con wget, y se aplican
patches al propio código (véase el apartado << Modificación del kernel >>
para obtener detalles de cómo crear dichos parches).\
De esta forma, el script `./configure.sh` no solo se encarga de
descargar y configurar el proyecto, sino de llamar a `git apply` con
el archivo `./changes-linux-kernel.patch`, en el cual se encuentran
los propios cambios al código original.

Dichos cambios consisten actualmente en:
- La adición de la carpeta `practica_lab` a la sección `core-y` del
Makefile, para marcarla como fuente de código. En esta carpeta es
donde se encuentra la implementación de la syscall (el propio archivo
fuente se referencia en el Makefile de dicha carpeta).
- La modificación del archivo `arch/x86/entry/syscalls/syscall_64.tbl`
para registrar la nueva syscall (de número 333), donde se incluye el
nombre de la función encargada de la implementación de la syscall.
- La modificación de la cabecera `include/linux/syscalls.h` para
añadir la definición de la función que implementa la propia syscall.

## Compilación del proyecto

```console
git clone https://github.com/hgluah/ssoo-custom-syscall.git
cd ssoo-custom-syscall

# Descarga con wget la version adecuada del codigo
# fuente de linux, y la descomprime con tar xz.
# Ademas, ejecuta `make menuconfig` para abrir el
# menu de configuracion de la compilacion del kernel,
# en el cual se debera de seleccionar el file-system
# correcto (ext4 en la mayoria de casos) 
./configure.sh

# Ejecuta el comando make con la cantidad de
# nucleos disponibles en el sistema.
# Tarda al rededor de 25 minutos en mi R9 5900X,
# limitado por RAM (usando por tanto el swapfile)
# y velocidad de HDD, compilando con 16/24 cores
./compile.sh

# Guarda los resultados de la compilacion y los
# prepara para ser utilizados la proxima vez que
# se reinicie la maquina virtual
./install.sh
```

#### Uso de la nueva syscall

Una vez realizada la instalación, tras hacer `reboot` se puede elegir
el kernel compilado presionando _Shift_ para acceder al menú de grub.

En el nuevo sistema, se podrán compilar programas como el que se
encuentra en [ejemplo_uso](ejemplo_uso/).

<details><summary>strace ejemplo_uso/example</summary>
  
```console
hgl@ubuntu:~/Desktop/ssoo-custom-syscall$ make -C ejemplo_uso/ && strace ejemplo_uso/example
make: Entering directory '/home/hgl/Desktop/ssoo-custom-syscall/ejemplo_uso'
gcc example.c -o example
make: Leaving directory '/home/hgl/Desktop/ssoo-custom-syscall/ejemplo_uso'
execve("ejemplo_uso/example", ["ejemplo_uso/example"], 0x7fff5078bed0 /* 53 vars */) = 0
brk(NULL)                               = 0x55dab760c000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=70157, ...}) = 0
mmap(NULL, 70157, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f9003451000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\260A\2\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1996592, ...}) = 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f900344f000
mmap(NULL, 2004992, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f9003265000
mprotect(0x7f9003287000, 1826816, PROT_NONE) = 0
mmap(0x7f9003287000, 1511424, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x22000) = 0x7f9003287000
mmap(0x7f90033f8000, 311296, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x193000) = 0x7f90033f8000
mmap(0x7f9003445000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1df000) = 0x7f9003445000
mmap(0x7f900344b000, 14336, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f900344b000
close(3)                                = 0
arch_prctl(ARCH_SET_FS, 0x7f9003450500) = 0
mprotect(0x7f9003445000, 16384, PROT_READ) = 0
mprotect(0x55dab6065000, 4096, PROT_READ) = 0
mprotect(0x7f900348c000, 4096, PROT_READ) = 0
munmap(0x7f9003451000, 70157)           = 0
syscall_0x14d(0x22, 0x23, 0x55dab6063190, 0x7f900344ad80, 0x7f900344ad80, 0x7ffd7168d690) = 0
fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), ...}) = 0
brk(NULL)                               = 0x55dab760c000
brk(0x55dab762d000)                     = 0x55dab762d000
write(1, "Resultado de la syscall: 0\n", 27Resultado de la syscall: 0
) = 27
exit_group(0)                           = ?
+++ exited with 0 +++
```  
</details>

Como observamos, el resultado de la llamada al sistema es 0, lo que
significa que se ha ejecutado correctamente. Sin embargo, no
encontramos el mensaje en el stdout, debido a que el mensaje impreso
con _printk_ se considera un mensaje de diagnóstico. Es por ello
que utilizaremos la herramienta _dmesg_ (diagnostic message), la
cual, al ejecutarla en una shell, nos permite ver el mensaje al final
de la consola:

```console
hgl@ubuntu:~/Desktop/ssoo-custom-syscall$ sudo dmesg | tail -1
[  320.111284] El resultado de sumar 34 y 35 es 69
```

## Modificación del kernel

Cada vez que se modifiquen archivos dentro del submódulo del kernel,
será necesario ejecutar `./generate_patch.sh` antes de hacer commit.

