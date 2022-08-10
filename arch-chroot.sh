#!/usr/bin/env bash

# Script archlinux chroot
# Franklin Souza
# @FranklinTech

dhcpcd_enable(){
  systemctl enable dhcpcd
}

timezone_config(){
  ln -sf /usr/share/zoneinfo/America/Recife /etc/localtime
  hwclock --systohc
  timedatectl set-ntp true
}

language_system(){
  nvim /etc/locale.gen
  locale-gen
  clear && printf "\nCole a linguagem descomentada abaixo (Ex: en_US.UTF-8):\n\n"
  read LANGUAGE
  echo LANG="$LANGUAGE" > /etc/locale.conf
  export "$LANGUAGE"
}

keymap_config(){
  echo KEYMAP=br-abnt2 > /etc/vconsole.conf
}

hostname_config(){
  clear && printf "Digite abaixo um hostname para a sua maquina:\n\n"
  read HOST_NAME
  echo "$HOST_NAME" > /etc/hostname
}

btrfs_progs_config(){
  pacman -S btrfs-progs --noconfirm
}

kernels_download(){
  clear && printf "Escolha seu kernel de preferência:\n\n[1] - linux (Kernel defautl)\n[2] - linux-hardened (Kernel focado na segurança)\n[3] - linux-lts (Kernel a longo prazo)\n[4] - linux-zen (Kernel focado em desempenho)\n\n"
  read KERNEL_CHOICE
  if [ $KERNEL_CHOICE == '1' ] || [ $KERNEL_CHOICE == '01' ] ; then
    clear && pacman -S linux linux-headers --noconfirm

  elif [ $KERNEL_CHOICE == '2' ] || [ $KERNEL_CHOICE == '02' ] ; then
    clear && pacman -S linux-hardened linux-hardened-headers --noconfirm

  elif [ $KERNEL_CHOICE == '3' ] || [ $KERNEL_CHOICE == '03' ] ; then
    clear && pacman -S linux-lts linux-lts-headers --noconfirm

  elif [ $KERNEL_CHOICE == '4' ] || [ $KERNEL_CHOICE == '04' ] ; then
    clear && pacman -S linux-zen linux-zen-headers --noconfirm

  else
    read -p 'Opção invalida, POR FAVOR ESCOLHA UM KERNEL, PRESSIONE ENTER PARA CONTINUAR...' && kernels_download
  fi
}
pacman_config(){
  nvim /etc/pacman.conf
}

repo_update(){
  pacman -Syy
}

password_root(){
  clear && printf "Digite e confirme sua senha root abaixo (CUIDADO A SENHA NÃO É EXIBIDA):\n\n"
  passwd
}

user_create(){
  clear && printf "Criando usuario, escolha seu shell de preferência:\n\n[1] - bash\n[2] - zsh\n\n"
  read SHELL_CHOICE
  if [ $SHELL_CHOICE == '1' ] || [ $SHELL_CHOICE == '01' ] ; then
    clear && pacman -S bash --noconfirm
    clear && printf "Digite o nome do seu usuario abaixo (COM LETRAS MINUSCULAS SEM ACENTOS E SEM ESPAÇOS):\n\n"
    read USERNAME
    clear && useradd -m -g users -G wheel -s /bin/bash "$USERNAME"

  elif [ $SHELL_CHOICE == '2' ] || [ $SHELL_CHOICE == '02' ] ; then
    clear && pacman -S zsh --noconfirm
    clear && printf "Digite o nome do seu usuario abaixo (COM LETRAS MINUSCULAS SEM ACENTOS E SEM ESPAÇOS):\n\n"
    read USERNAME
    clear && useradd -m -g users -G wheel -s /bin/zsh "$USERNAME"

  else
    read -p 'Opção invalida, por favor tente novamente PRESSIONE ENTER PARA CONTINUAR...' && user_create
  fi
}

password_user(){
  clear && read -p 'Digite e confirme a sua senha de usuario abaixo (CUIDADO A SENHA NÃO É EXIBIDA) PRESSIONE ENTER PARA CONTINUAR...'
  clear && printf "Digite seu nome de usuario abaixo:\n\n"
  read USERNAME1
  passwd "$USERNAME1"
}

edit_sudoers(){
  nvim /etc/sudoers
}

grub_install(){
  pacman -S grub efibootmgr --noconfirm
  grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ArchLinux --recheck
  grub-mkconfig -o /boot/grub/grub.cfg
}

finish_install(){
  clear && read -p 'Instalação finalizada, NÃO ESQUEÇA DE SAIR DO CHROOT E REBOOTAR O PC!!! PRESSIONE ENTER PARA CONTINUAR...' && exit 0
}

dhcpcd_enable
timezone_config
language_system
keymap_config
hostname_config
btrfs_progs_config
kernels_download
pacman_config
repo_update
password_root
user_create
password_user
edit_sudoers
grub_install
finish_install
