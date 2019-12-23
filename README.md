# 1weeklinuxpractice
Linux practice

1. Update ubuntu 16.04 to 18.04

sudo apt-get update && sudo apt-get upgrade

sudo apt install update-manager-core

lsb_release -a

2.Installing terraform to ubuntu 18.04


sudo apt-get install unzip

https://www.terraform.io/downloads.html

wget https://releases.hashicorp.com/terraform/0.12.7/terraform_0.12.7_linux_amd64.zip

unzip terraform_0.12.7_linux_amd64.zip

sudo mv terraform /usr/local/bin/

terraform --version 

3. Perform sudo without password

sudo visudo

To sudoers file make changes though nano editor

<username> ALL=NOPASSWD: ALL
  
  4. Create a new user with sudo and wheel rights
  
  adduser username
  
  usermod -aG sudo username
  
  Either for wheel group
  
  First we should create a user 
  
  useradd klaus
  
  passwd klaus
  
  visudo
  
## Allows people in group wheel to run all commands
# %wheel        ALL=(ALL)       ALL
  
  
  5. Insatll zsh to ubuntu 18.04
  
  sudo apt install zsh
  sudo apt-get install powerline fonts-powerline
  
  git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
  
  cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
  
  nano .zshrc
  
  chsh -s /bin/zsh
  
  6. To allow user perfrom only cat commands should also edit with nano sudoers file
  And add 
  
  jasmin    ALL=/usr/bin/cat
  
  7. To create systemd unit
  
  
  
  
