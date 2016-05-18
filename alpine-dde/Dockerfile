FROM elifarley/docker-dev-env:alpine-sshd
MAINTAINER Elifarley Cruz <elifarley@gmail.com>

ENV RM_ITEMS '/tmp/* /var/tmp/* /var/backups/* /usr/share/man /usr/share/doc'

RUN apk --update add --no-cache tar sed vim less findutils git build-base && \
  curl -fsSL http://prdownloads.sourceforge.net/ctags/ctags-5.8.tar.gz | tar -zxC /tmp && \
  (cd /tmp/ctags-5.8 && ./configure && make && make install && cd && apk del build-base && rm -rf /tmp/*) && \
  rm -rf /var/cache/apk/*

RUN curl -fsSL https://github.com/elifarley/shellbase/archive/1.0.5.tar.gz \
  | tar --exclude README.md --exclude LICENSE --strip=1 --overwrite -zxvC "$HOME" && \
  sed -i '/^set listchars=tab/d' "$HOME"/.vimrc && \
  curl -fsSL https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.ansi-dark > "$HOME"/.dircolors && \
  printf "PATH=$PATH\n" >> "$HOME"/.ssh/environment && \
  printf ". '$HOME'/.ssh/environment\npwd" \
    >> "$HOME"/.bashrc

# Install Pathogen - https://github.com/tpope/vim-pathogen
RUN mkdir -p "$HOME"/.vim/autoload "$HOME"/.vim/bundle "$HOME"/.vim/colors && \
curl -fsSL https://raw.githubusercontent.com/sjl/badwolf/master/colors/badwolf.vim > "$HOME"/.vim/colors/badwolf.vim && \
curl -fsSL https://raw.githubusercontent.com/jnurmine/Zenburn/master/colors/zenburn.vim > "$HOME"/.vim/colors/zenburn.vim && \
curl -fsSL https://tpo.pe/pathogen.vim > "$HOME"/.vim/autoload/pathogen.vim && \
sed -i '1 i\execute pathogen#infect()\ncall pathogen#helptags()\n' "$HOME"/.vimrc && \
( cd ~/.vim/bundle && mkdir -p csapprox && curl -fsSL https://github.com/godlygeek/csapprox/archive/4.00.tar.gz \
  | tar --strip 1 -zxC csapprox && \
  git clone git://github.com/tpope/vim-eunuch.git && \
  git clone git://github.com/altercation/vim-colors-solarized.git && \
  git clone https://github.com/tpope/vim-obsession && \
  git clone https://github.com/justinmk/vim-dirvish.git && \
  git clone git://github.com/tpope/vim-vinegar.git vim-vinegar~ && \
  git clone https://github.com/ervandew/supertab && \
  git clone https://github.com/ctrlpvim/ctrlp.vim.git && \
  git clone https://github.com/majutsushi/tagbar && \
  git clone git://github.com/tpope/vim-fugitive.git && \
  git clone git://github.com/tpope/vim-rails.git && \
  git clone git://github.com/tpope/vim-bundler.git \
)

RUN chown -R $_USER:$_USER "$HOME" && updatedb
