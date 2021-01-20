set nocompatible
let g:mapleader = "\<Space>"

if empty(glob('~/.vim/autoload/plug.vim'))
   silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
   autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

  "Plug 'Valloric/YouCompleteMe'

  "Plug 'davidhalter/jedi-vim'
  "Plug 'SirVer/ultisnips'
  "Plug 'honza/vim-snippets'

  Plug 'scrooloose/nerdtree'
  Plug 'preservim/nerdcommenter'
  Plug 'bling/vim-airline'
  "Plug 'kien/ctrlp.vim'
  Plug 'flazz/vim-colorschemes'
  "Plug 'dense-analysis/ale' " requires vim8

  set rtp+=/home/georgek/.vim/fzf
  Plug 'junegunn/fzf', { 'dir': '~/.vim/fzf', 'do': './install -all' }
  Plug 'junegunn/fzf.vim'

  Plug 'tpope/vim-fugitive'
  Plug 'Vimjas/vim-python-pep8-indent'
  "Plug 'vim-syntastic/syntastic'
  Plug 'Chiel92/vim-autoformat'
  Plug 'airblade/vim-gitgutter'

call plug#end()
filetype plugin indent on    " required

""""""""""""""""""""BASE CONFIG"""""""""""""""""""""""
"Status bar configuration
set laststatus=2

" Open syntax highlighting
syntax enable

" Turn on grammar detection
syntax on

"vimrc file modified automatically loaded
autocmd! bufwritepost .vimrc source %

" After the file is modified automatically loaded
set autoread

" Highlight search hit text
set hlsearch

" As you type in an instant search
set incsearch

" Ignored case when searching
set ignorecase

" One or more uppercase letters are still case sensitive
set smartcase

" set guifont=Menlo:h14

" colorscheme Tomorrow-Night-Bright
" Use comes with color
"colorscheme elflord
"set background=dark

" The status bar shows the command being input
set showcmd

" autocomplete is getting much better :e <tab>...
set wildchar=<Tab> wildmenu wildmode=full
set wildignore=*.o,*.obj,*.bak,*.exe,*.swp,*.pyc

" redraw only when we need to.
set lazyredraw

" Shows the pairing of brackets
set showmatch

" :next,: make command is automatically saved before
set autowrite

" Allowed to use the mouse
set mouse=a

" Set the line number
set number

" Set relative numbering
set relativenumber

" Backspace available
set backspace=2

" Backspace once deleted 4 spaces
set smarttab

" Indent
set autoindent
set smartindent

" Save the file automatically delete the end of the line space or Tab
autocmd BufWritePre * :%s/\s\+$//e

"The empty line at the end is automatically deleted when saving the file
autocmd BufWritePre * :%s/^$\n\+\%$//ge

" The code collapse cursor collapses or expands with the za command when indented below
set fdm=indent
" Expand by default
set foldlevel=99
" Add column for viewing fold information
set foldcolumn=2

" Highlight the current row, column
set cursorline
" set cursorcolumn

" Shared Clipboard
set clipboard=unnamed,unnamedplus

" After setting exit vim, the content is displayed on the terminal screen and
" can be used for viewing and copying
" set t_ti= t_te=

" Always jump to the last cursor position when opening a file
autocmd BufReadPost *
      \ if ! exists("g:leave_my_cursor_position_alone") |
      \     if line("'\"") > 0 && line ("'\"") <= line("$") |
      \         exe "normal g'\"" |
      \     endif |
      \ endif

" Allow saving of files as sudo when I forgot to start vim using sudo.
cnoremap w!! execute 'silent! write !sudo tee % > /dev/null' <bar> edit!

"mapping C-w to C-e because of terminator conflict
:nnoremap <C-e> <C-w>

"set colorscheme for 256
:set t_Co=256

" Persistent folds between vim sessions
augroup AutoSaveFolds
  autocmd!
  autocmd BufWinLeave Work_status.org mkview
  autocmd BufWinEnter Work_status.org silent loadview
augroup END
""""""""""""""""""""""""""""""PLUGIN CONFIG""""""""""""""""""""""""""
" NERDTREE
map <F2> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.pyc$', '\~$']
" show nerdtree when starts up
" autocmd vimenter * NERDTree
 autocmd bufenter * if (winnr("$") == 1 && exists('b:NERDTreeType') && b:NERDTreeType == 'primary') | q | endif

" CtrlP
"let g:ctrlp_show_hidden = 1
"let g:ctrlp_cmd = 'CtrlPMixed'

" FZF map to CtrlP
":nnoremap <C-p> :Files<CR>
let g:fzf_preview_window = ['up:40%:hidden', 'ctrl-/']
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }
"let g:fzf_preview_window = 'right:60%'
"let g:fzf_layout = { 'window': 'enew' }
nnoremap <c-p> :Files<cr>
augroup fzf
  autocmd!
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END

" {{{
  let g:fzf_nvim_statusline = 0 " disable statusline overwriting

  nnoremap <silent> <leader><space> :Files<CR>
  nnoremap <silent> <leader>a :Buffers<CR>
  nnoremap <silent> <leader>A :Windows<CR>
  nnoremap <silent> <leader>; :BLines<CR>
  nnoremap <silent> <leader>o :BTags<CR>
  nnoremap <silent> <leader>O :Tags<CR>
  nnoremap <silent> <leader>? :History<CR>
  nnoremap <silent> <leader>/ :execute 'Ag ' . input('Ag/')<CR>
  nnoremap <silent> <leader>. :AgIn

  nnoremap <silent> K :call SearchWordWithAg()<CR>
  vnoremap <silent> K :call SearchVisualSelectionWithAg()<CR>
  nnoremap <silent> <leader>gl :Commits<CR>
  nnoremap <silent> <leader>ga :BCommits<CR>
  nnoremap <silent> <leader>ft :Filetypes<CR>

  imap <C-x><C-f> <plug>(fzf-complete-file-ag)
  imap <C-x><C-l> <plug>(fzf-complete-line)

  function! SearchWordWithAg()
    execute 'Ag' expand('<cword>')
  endfunction

  function! SearchVisualSelectionWithAg() range
    let old_reg = getreg('"')
    let old_regtype = getregtype('"')
    let old_clipboard = &clipboard
    set clipboard&
    normal! ""gvy
    let selection = getreg('"')
    call setreg('"', old_reg, old_regtype)
    let &clipboard = old_clipboard
    execute 'Ag' selection
  endfunction

  function! SearchWithAgInDirectory(...)
    call fzf#vim#ag(join(a:000[1:], ' '), extend({'dir': a:1}, g:fzf#vim#default_layout))
  endfunction
  command! -nargs=+ -complete=dir AgIn call SearchWithAgInDirectory(<f-args>)
" }}}


" {{{
  " Fix broken syntax highlight in gitcommit files
  " (https://github.com/tpope/vim-git/issues/12)
  let g:fugitive_git_executable = 'LANG=en_US.UTF-8 git'

  nnoremap <silent> <leader>gs :Gstatus<CR>
  nnoremap <silent> <leader>gd :Gdiff<CR>
  nnoremap <silent> <leader>gc :Gcommit<CR>
  nnoremap <silent> <leader>gb :Gblame<CR>
  nnoremap <silent> <leader>ge :Gedit<CR>
  nnoremap <silent> <leader>gE :Gedit<space>
  nnoremap <silent> <leader>gr :Gread<CR>
  nnoremap <silent> <leader>gR :Gread<space>
  nnoremap <silent> <leader>gw :Gwrite<CR>
  nnoremap <silent> <leader>gW :Gwrite!<CR>
  nnoremap <silent> <leader>gq :Gwq<CR>
  nnoremap <silent> <leader>gQ :Gwq!<CR>

  function! ReviewLastCommit()
    if exists('b:git_dir')
      Gtabedit HEAD^{}
      nnoremap <buffer> <silent> q :<C-U>bdelete<CR>
    else
      echo 'No git a git repository:' expand('%:p')
    endif
  endfunction
  nnoremap <silent> <leader>g` :call ReviewLastCommit()<CR>

  augroup fugitiveSettings
    autocmd!
    autocmd FileType gitcommit setlocal nolist
    autocmd BufReadPost fugitive://* setlocal bufhidden=delete
  augroup END
" }}}

Plug 'airblade/vim-gitgutter'
" {{{
  let g:gitgutter_map_keys = 0
  let g:gitgutter_max_signs = 200
  let g:gitgutter_realtime = 1
  let g:gitgutter_eager = 1
  let g:gitgutter_sign_removed = '–'
  let g:gitgutter_diff_args = '--ignore-space-at-eol'
  nmap <silent> ]h :GitGutterNextHunk<CR>
  nmap <silent> [h :GitGutterPrevHunk<CR>
  nnoremap <silent> <Leader>gu :GitGutterRevertHunk<CR>
  nnoremap <silent> <Leader>gp :GitGutterPreviewHunk<CR><c-w>j
  nnoremap cog :GitGutterToggle<CR>
  nnoremap <Leader>gt :GitGutterAll<CR>
" }}}


" jedi
autocmd FileType python setlocal completeopt-=preview
let g:jedi#completions_command = "<C-n>"

" ultisnips
"let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsJumpForwardTrigger="<tab>"
"let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

"--------------------------------------------
" Default settings from before copying the personal vimrc
if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=ucs-bom,utf-8,latin1
endif

"set nocompatible	" Use Vim defaults (much better!)
set bs=indent,eol,start		" allow backspacing over everything in insert mode
"set ai			" always set autoindenting on
"set backup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup redhat
  " autocmd!
  " In text files, always limit the width of text to 78 characters
  " autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > -1 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  " don't write swapfile on most commonly used directories for NFS mounts or USB sticks
  autocmd BufNewFile,BufReadPre /media/*,/run/media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp
  " start with spec file template
  autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec
  augroup END
endif

if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add $PWD/cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

filetype plugin on

if &term=="xterm"
     set t_Co=8
     set t_Sb=[4%dm
     set t_Sf=[3%dm
endif

" Don't wake up system with blinking cursor:
" http://www.linuxpowertop.org/known.php
let &guicursor = &guicursor . ",a:blinkon0"

"----------------------------------------------------------------------------------------------
" More setting for syntastic
"----------------------------------------------------------------------------------------------
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"let g:syntastic_aggregate_errors = 1

"let g:syntastic_mode_map = { 'mode': 'passive',
                          "\ 'active_filetypes': [],
                          "\ 'passive_filetypes': [] }
"let g:syntastic_auto_loc_list=1
"nnoremap <silent> <F5> :SyntasticCheck<CR>

"let g:syntastic_python_checkers = ['flak8', 'pylint']

" Load all plugins now.
" " All messages and errors will be ignored.
"silent! helptags ALL

"----------------------------------------------------------------------------------------------
" ALE Settings
"----------------------------------------------------------------------------------------------
"let g:ale_linters = {
      "\   'python': ['flake8', 'pylint'],
      "\   'ruby': ['standardrb', 'rubocop'],
      "\   'javascript': ['eslint'],
      "\}
"let g:ale_fixers = {
      "\    'python': ['autopep8', 'yapf'],
      "\}
"nmap <F10> :ALEFix<CR>
"let g:ale_fix_on_save = 1

"let g:airline#extensions#ale#enabled = 1

"function! LinterStatus() abort
  "let l:counts = ale#statusline#Count(bufnr(''))

  "let l:all_errors = l:counts.error + l:counts.style_error
  "let l:all_non_errors = l:counts.total - l:all_errors

  "return l:counts.total == 0 ? '✨ all good ✨' : printf(
        "\   '😞 %dW %dE',
        "\   all_non_errors,
        "\   all_errors
        "\)
"endfunction

"set statusline=
"set statusline+=%m
"set statusline+=\ %f
"set statusline+=%=
"set statusline+=\ %{LinterStatus()}

" Autoformat Settings
"----------------------------------------------------------------------------------------------
" set :Autoformat command to <F3>
noremap <F3> :Autoformat<CR>

"au BufWrite * :Autoformat

" au FileType vim,tex call autoformat_options()
" function autoformat_options()
"    let b:autoformat_autoindent=0
"    let g:autoformat_retab = 0
"    let g:autoformat_remove_trailing_spaces = 0
" endfunction

" Disable fallback to vim's default indent
" let g:autoformat_autoindent = 0
" let g:autoformat_retab = 0
" let g:autoformat_remove_trailing_spaces = 0

