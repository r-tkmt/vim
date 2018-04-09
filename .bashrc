export DOT_FILES=$XDG_CONFIG_HOME
export MYVIMRC=$DOT_FILES/vimrc.vim
export TERM=xterm-color256

# 個々の環境のbash設定を読み込む
if [ -e "${HOME}/.bashrc_local" ]; then
  source "${HOME}/.bashrc_local"
fi
