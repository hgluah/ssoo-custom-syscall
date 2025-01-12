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

## Compilación del proyecto

```console
# Si no se clona de forma recursiva al inicio,
# el script configure.sh se encargará de ello
git clone --recursive --jobs 16 https://github.com/hgluah/ssoo-custom-syscall.git
cd ssoo-custom-syscall
./configure.sh
./compile.sh
```

## Modificación del kernel

Cada vez que se modifiquen archivos dentro del submódulo del kernel,
será necesario ejecutar `./generate_patch.sh` antes de hacer commit.

