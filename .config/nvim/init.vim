call plug#begin('~/.local/share/nvim/plugged')
Plug 'junegunn/fzf'
Plug 'terryma/vim-multiple-cursors' " ctrl-n
Plug 'godlygeek/tabular' " required for vim-markdown
Plug 'airblade/vim-gitgutter' " see icons for changed lines in gutter
Plug 'easymotion/vim-easymotion' " type ,, before a motion for a visual selection rather than a count
Plug 'editorconfig/editorconfig-vim' " honor editorconfig files
Plug 'isRuslan/vim-es6' " es6 syntax
Plug 'jlanzarotta/bufexplorer' " type :Buf<tab><cr> to see all your buffers (open files)
Plug 'ludovicchabant/vim-gutentags' " automatically look for keywords for autocomplete
Plug 'luochen1990/rainbow' " rainbow parentheses
Plug 'mattn/emmet-vim' " html speedwriter. type div.section<ctrl-y><comma> 
Plug 'google/vim-searchindex' " show 'n of m'
Plug 'mbbill/undotree' " track a tree of edits
Plug 'mileszs/ack.vim' " search in project
Plug 'sheerun/vim-polyglot'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript', { 'do': './install.sh', 'for': 'typescript' }
Plug 'Shougo/deoplete.nvim'
let g:deoplete#enable_at_startup=1
Plug 'Shougo/denite.nvim'

Plug 'plasticboy/vim-markdown' " markdown syntax
Plug 'dag/vim-fish' " fish shell syntax
Plug 'scrooloose/syntastic' " linter
Plug 'stefandtw/quickfix-reflector.vim' " project-wide find and replace
Plug 'svermeulen/vim-easyclip' " ctrl-f and ctrl-d after paste to cycle through clipboard history
" Plug 'tpope/vim-commentary' " gc<motion> to comment
Plug 'tomtom/tcomment_vim' " like commentary but supports contextual JSX
Plug 'flazz/vim-colorschemes' " type :color<tab><tab><tab>... to see options
Plug 'tpope/vim-eunuch' " :Mkdir :Remove :SudoWrite
Plug 'tpope/vim-fugitive' " :Gblame ':Gdiff dev' :Glog ':Gedit origin master' :Gstatus
Plug 'tpope/vim-repeat' " support repeating more things with .
Plug 'tpope/vim-rsi' " regular bash movement bindings in commandline and insert modes (ctrl-a to go to the beginning of a line, etc)
Plug 'AndrewRadev/splitjoin.vim' " gJ and gS to split and join multi-row forms
Plug 'tpope/vim-speeddating' " increment dates intelligently with ctrl-a and ctrl-x in normal mode
Plug 'tpope/vim-surround' " ys<movement><surround> to add surround, cs<movement><surround> to change surround, ds<surround> to delete surround, 
			  " for example, ysiw<em> surrounds the current word in an <em> tag
Plug 'tpope/vim-unimpaired' " handy pairs of commands, like [b for previous-buffer and ]b for next buffer.
			    " see https://github.com/tpope/vim-unimpaired/blob/master/doc/unimpaired.txt
Plug 'tpope/vim-vinegar' " press - to go up a directory
Plug 'vim-airline/vim-airline' " status bar
Plug 'vim-airline/vim-airline-themes' 

call plug#end()

" I think this has to come before any mappings that use leader
" the leader is a prefix-modifier key used for lots of stuff.
" the default leader is backslash but comma is more common for some reason
" <leader><leader>j means 'press comma twice then pres j'
let mapleader = ","

" no shift to enter command mode, just use the semicolon key
nnoremap ; :
vnoremap ; :

" allow editing multiple files at once
set hidden

" enable syntax highlighting
syntax enable

" " show files as a tree (press dash in normal mode). You can press i in the
" " file browser to switch views. ':help netrw' for more.
" let g:netrw_liststyle=3

" enable scrolling
set mouse=a

" search while typing, not just after pressing enter
set incsearch

" use escape in normal mode to clear the highlighting from the last search
nnoremap <space> :let @/ = ""<return><esc>

" ctrl-dash to see a list of open files
map <C--> :BufExplorer<CR>

" highlight search results
set hlsearch

" use better autoindent
set cindent

" make backspace normal
set backspace=indent,eol,start

" save swp in ~/.vim-tmp
set backup
set swapfile
set backupdir=~/.vim-tmp
set directory=~/.vim-tmp

" highlight the selected line
set cursorline

" show line numbers
set number

" be more verbose about stuff generally
set showcmd

" briefly highlight matching brackets on close/open
set showmatch

" Allow scrolling past the bottom of the document
set scrolloff=1

" make vim use bash for it's scripting stuff, fish isn't compatible
" the fish conditional in this file
" https://github.com/tpope/vim-sensible/blob/master/plugin/sensible.vim#L64
" looks tempting but doesn't seem to work for me :shrug:
set shell=/bin/bash

" use spaces for tab indentation if editorconfig isn't set
set shiftwidth=2
set softtabstop=2

" don't break mid word
set linebreak


" TITLEIZE COMMANDS (case)
" titleize line
:command TitleizeLine s/\<\(\w\)\(\S*\)/\u\1\L\2/g
" titleize all markdown headers
:command TitleizeHeader g/^#\+\s.*/TitleizeLine

" JAVASCRIPT IMPORT TO REQUIRE
:command ImportToRequire %s/^import \(\S\{-}\) from '\(\S\{-}\)'$/const \1 = require('\2')/
:command RequireToImport %s/^const \(\S\{-}\) = require('\(\S\{-}\)')$/import \1 from '\2'/
nnoremap [i :ImportToRequire<CR>
nnoremap ]i :RequireToImport<CR>


" CTAGS
" only make tags for files in git
let g:gutentags_file_list_command = 'git ls-files'


" AIRLINE
" use powerline
let g:airline_powerline_fonts = 1
" show buffers
let g:airline#extensions#tabline#enabled = 1

" EASYCLIP CLIPBOARD MANAGER
" remap
let g:EasyClipUsePasteToggleDefaults = 0
nmap <c-f> <plug>EasyClipSwapPasteForward 
nmap <c-d> <plug>EasyClipSwapPasteBackwards
" use 'Reg' to show the clipboard history
" (more like regular vim)
:command Reg Yanks
" " or use "X"
" nnoremap X :Yanks<CR>
" " allow paste outside normal mode
" " nope, the default c-v to enter a literal is super useful
" imap <c-v> <plug>EasyClipInsertModePaste
" cmap <c-v> <plug>EasyClipCommandModePaste


" RAINBOW PARENTHESES
" TODO set this automatically based on language.
let g:rainbow_active = 1
" Colors I got off the internet somewhere
let g:rainbow_conf = { 'ctermfgs': ['cyan', 'magenta', 'yellow', 'grey', 'red', 'green', 'blue'], 'guifgs': ['#FF0000', '#FF00FF', '#FFFF00', '#000000', '#FF0000', '#00FF00', '#0000FF'] }


" ACK
" use `ag` if it's installed
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif


" MARKDOWN
" disable annoying code folding with vim-markdown
let g:vim_markdown_folding_disabled=1
" enable yaml front matter highlighting in vim-markdown
let g:vim_markdown_frontmatter=1


" COLOR SCHEME
let g:airline_theme = 'base16_monokai'
set background=dark
colorscheme Benokai

