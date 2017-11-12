#!/bin/sh
sudo apt-get update && apt-get --assume-yes upgrade
sudo apt-get --assume-yes install tmux build-essential gcc g++ make binutils
sudo apt-get --assume-yes install software-properties-common

sudo apt-get install nvidia-modprobe 
sudo apt-get install nvidia-384-dev
nvidia-smi

wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
sudo apt-get update
sudo apt-get install cuda-8-0

mkdir downloads
cd downloads
wget https://repo.continuum.io/archive/Anaconda2-4.2.0-Linux-x86_64.sh
bash Anaconda2-4.2.0-Linux-x86_64.sh -b
echo 'export PATH="/home/ubuntu/anaconda2/bin:$PATH"' >> ~/.bashrc
export PATH="/home/ubuntu/anaconda2/bin:$PATH"
conda install -y bcolz
conda upgrade -y --all

pip install theano-8.2
echo "[global]
device = gpu
floatX = float32" > ~/.theanorc

pip install keras==1.2.2
mkdir ~/.keras
echo '{
    "image_dim_ordering": "th",
    "epsilon": 1e-07,
    "floatx": "float32",
    "backend": "theano"
}' > ~/.keras/keras.json

wget http://files.fast.ai/files/cudnn.tgz
tar -zxf cudnn.tgz
cd cuda
sudo cp lib64/* /usr/local/cuda/lib64/
sudo cp include/* /usr/local/cuda/include/

jupyter notebook --generate-config
jupass=`python -c "from notebook.auth import passwd; print(passwd())"`
echo "c.NotebookApp.password = u'"$jupass"'" >> .jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = False" >> .jupyter/jupyter_notebook_config.py
mkdir nbs

##################################################################################
# personal settings
######################
# vim
echo "
set number
syntax enable
set background=dark
colorscheme gruvbox

if &term =~ '256color'
  # disable Background Color Erase (BCE) so that color schemes
  # render properly when inside 256-color tmux and GNU screen.
  # see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif
" > ~/.vimrc

mkdir ~/.vim/colors
cd ~/.vim/colors
curl -O https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim

# shell
cd ~/
wget https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.ansi-light
mv dircolors.ansi-light .dircolors

# set tmux config
echo "#remap prefix from 'C-b' to 'C-a'
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# split panes using | and -
bind | split-window -h
bind _ split-window -v
unbind '\"'
unbind %
bind k confirm kill-window
bind K confirm kill-server
bind < resize-pane -L 1
bind > resize-pane -R 1
bind - resize-pane -D 1
bind + resize-pane -U 1
bind r source-file ~/.tmux.conf

# switch panes using Alt-arrow without prefix
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# Enable mouse control (clickable windows, panes, resizable panes)
set -g mouse on
set -g default-terminal 'screen-256color'
" > ~/.tmuxconf

