#!/usr/bin/env sh

set -ex

if [ "$EUID" -eq 0 ] ; then
  echo "make a user, run as that user"
  exit 1
fi

user="arch"
if [ "$(uname)" = "FreeBSD" ] ; then
  user="freebsd"
fi


# set up ssh key
if [ ! -f "$HOME/.ssh/id_rsa.pub" ] ; then
  echo "making an ssh key"
  ssh-keygen -t rsa -b 4096 -C "a@monks.co"
  echo "add your key to github, then run this again"
  echo "https://github.com/settings/keys"
  exit 0
fi


# update packages
if [ "$(uname)" = "FreeBSD" ] ; then
        echo "using FreeBSD"
        if [ ! -d /usr/ports ] ; then
    echo "downloading port catalog"
                sudo portsnap fetch extract
        fi
  echo "updating port catalog"
        sudo portsnap fetch update
fi
if [ "$(uname)" = "Linux" ] ; then
        echo "using Linux"
  sudo pacman -Syu
  if ! type yay > /dev/null ; then
    echo "installing yay"
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
  fi
fi


install() {
        local OPTIND opt a p c n s b aur platform category name sentinel from_source
        while getopts ":a:p:c:n:s:b:" opt ; do
                case "${opt}" in
      a)  aur=${OPTARG}    ;;
                        p)      platform=${OPTARG}      ;;
                        c)      category=${OPTARG}      ;;
                        n)      name=${OPTARG}          ;;
                        s)      sentinel=${OPTARG}      ;;
                        b)      from_source=${OPTARG}    ;;
                esac
        done
        if [ -z "$sentinel" ] ; then
                sentinel=$name
        fi
        echo "installing $category/$name [sentinel=$sentinel] [from_source=$from_source]"


        if type "$sentinel" > /dev/null ; then
                echo "$sentinel already installed"
                return 0
        fi


        echo "installing $category/$name, producing $sentinel"

        if [ "$(uname)" = "FreeBSD" ] && [ "$platform" != "Linux" ] ; then
                if [ "$from_source" = "true" ] ; then
      echo "building from source"
                        cd /usr/ports/$category/$name
                        sudo make install clean BATCH=yes > /dev/null
                else
      echo "downloading binary"
                        sudo pkg install $name
                fi
        fi

        if [ "$(uname)" = "Linux" ] && [ "$platform" != "FreeBSD" ] ; then
    if [ "$aur" = "true" ] ; then
      echo "installing from aur"
      yay -S $name
    else
      echo "installing"
      sudo pacman -S $name
    fi
        fi
}



# basics

install -b true -c devel -n git
install -b true -c devel -n hub
install -b true -c sysutils -n tmux
install -a true -b true -c sysutils -n direnv
install -b true -c net -n mosh
install -b true -c editors -n neovim -s nvim
install -b true -c shells -n fish
install -b true -c sysutils -n autojump
install -b true -c sysutils -n tree
install -b true -c math -n sc
install -n python-pip -s pip3
install -n node -p FreeBSD
install -n nodejs -s node -p Linux
install -n yarn
install -n npm




# set up dotfiles repo
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
if [ ! -d $HOME/.dotfiles ] ; then
  git clone --bare amonks/dotfiles $HOME/.dotfiles
fi
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
dotfiles fetch
dotfiles checkout master

# use fish shell
if ! grep fish /etc/shells > /dev/null ; then
  echo `which fish` | sudo tee -a /etc/shells
fi
if [ "$SHELL" != "/usr/local/bin/fish" ] ; then
  sudo chsh -s `which fish` $user
fi


# VIM
sudo pip3 install --upgrade neovim
# set install vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
yarn global add neovim


if [ "$(uname)" = "Linux" ] ; then
  install -n libvirt
  install -n qemu-headless
  install -n ebtables
  install -n dnsmasq
  sudo systemctl start libvirtd.service
  sudo systemctl start virtlogd.service
  sudo systemctl enable libvirtd.service
  sudo systemctl enable virtlogd.service
  sudo usermod --append --groups libvirt $user
  install -n docker-machine
  # install -a true -s minikube -n minikube-bin
  # install -a true -s kubectl -n kubectl-bin
  install -a true -n docker-machine-driver-kvm2
fi
