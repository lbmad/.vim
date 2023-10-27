" Vim config

" Automatic install of vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins managed by vim-plug
call plug#begin('~/.vim/plugged')                                               " Starts loading plugins
  Plug 'catppuccin/vim',{'as':'catppuccin'}                                     " Catppuccin colour themes
  Plug 'dracula/vim',{'as':'dracula'}                                           " Dracula colour theme
  Plug 'itchyny/lightline.vim'                                                  " Lightweight status line
  Plug 'JuliaEditorSupport/julia-vim'                                           " Support for Julia
  Plug 'justinmk/vim-dirvish'                                                   " File explorer
  "Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }                           " Fuzzy search
  "Plug 'junegunn/fzf.vim'                                                       " Fuzzy search
  Plug 'natebosch/vim-lsc'                                                      " Language server client
  Plug 'mechatroner/rainbow_csv'                                                " Syntax highlighting for .csv files
  Plug 'morhetz/gruvbox'                                                        " Gruvbox colour theme 
  Plug 'ryanoasis/vim-devicons'                                                 " Developer icons for plugins using utf-8 nerd font (vim-airline)
  Plug 'tpope/vim-sleuth'                                                       " Adjusts shiftwidth and expand tab based on current or nearby files
call plug#end()                                                                 " Ends loading plugins. Remember to use :PlugInstall after adding any new packages to install them

" General settings
set background=dark                                                             " Dark background
set breakindent                                                                 " Keeps indent when wrapping
set cursorline                                                                  " Highlights current line
set encoding=utf8                                                               " Sets encoding to utf8 for vim-devicons to show glyphs
set ignorecase                                                                  " case-insensitive search 
set laststatus=2                                                                " Required if using lightline to display status line correctly
set nowrap                                                                      " No wrapping of lines that exceed window width
set noshowmode                                                                  " Removes notification of current mode in command line 
set number                                                                      " Shows line numbers
set relativenumber                                                              " Sets line numbers to be relative to current line number
set scrolloff=5                                                                 " Keeps 5 lines above/below cursor when scrolling files
set showtabline=1                                                               " Shows tabline if > 1 tab
set smartcase                                                                   " Case-sensitive search if upper case character is present 
set termguicolors                                                               " Allows 24-bit colour
set wildmenu                                                                    " Allows use of wildmenu replacing status line for autocomplete of commands
set wildmode=longest:full,full                                                  " Wildmenu settings

" Filetype associations
au BufRead,BufNewFile .fortls set filetype=jsonc                                " Interpret files of extension .fortls (fortls config files) as .jsonc files
au BufRead,BufNewFile *.h set filetype=fortran                                  " Interpret files of extension .h as Fortran files
au BufRead,BufNewFile *.jl set filetype=julia                                   " Interpret files of extension .jl as Julia files

" Code formatting
set matchpairs+=<:>                                                             " Allow pair matching of arrow brackets
set nofoldenable                                                                " Code is unfolded on start
setlocal foldmethod=syntax                                                      " Code folding is automated via syntax

" Visual styling
"colorscheme catppuccin_macchiato                                                " Use catppuccin macchiato colour theme
colorscheme dracula                                                             " Use dracula colour theme
"colorscheme gruvbox                                                             " Use gruvbox colour theme
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {}                  " Required to use setting
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['fortran'] = '󱈚'      " Sets symbol for Fortran filetype
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['f'] = '󱈚'            " Sets symbol for Fortran filetype
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['f90'] = '󱈚'          " Sets symbol for Fortran filetype
set fillchars+=vert:\                                                           " Removes \| character from vertical window split

" Applies icons to Dirvish
"call dirvish#add_icon_fn({p -> p[-1:]=='/'?'📂':'📄'})
"call dirvish#add_icon_fn({p -> WebDevIconsGetFileTypeSymbol(p)})
let g:DevIconsAppendArtifactFix=1
call dirvish#add_icon_fn({p -> WebDevIconsGetFileTypeSymbol(p,p[-1:]=='/'?1:0)})  " Uses vim-devicons to add icons to vim-dirvish

" Sets cursor for WSL via windows terminal
if &term =~ '^xterm'                                                            " Detects whether terminal is xterm 
  let &t_ti .= "\<Esc>[3 q"                                                     " Behaviour upon starting Vim
  let &t_EI .= "\<Esc>[3 q"                                                     " Normal mode
  let &t_SI .= "\<Esc>[5 q"                                                     " Insert mode
  let &t_te .= "\<Esc>[5 q"                                                     " Behaviour upon exiting Vim (possible improvement - set to same cursor as before)
endif

" Language server
let g:lsc_auto_map = v:true                                                     " Automatically maps open files using associate language server
let g:lsc_server_commands = {'fortran': 'fortls --config .fortls.jsonc'}        " Starts fortran-lang/fortls language server for Fortran files

" Fortran
let fortran_do_enddo=1                                                          " Allows auto-indent of do enddo loops within Fortran files
let fortran_fold=1                                                              " Allows syntax folding within Fortran files
let fortran_fold_conditionals=1                                                 " Allows syntax folding of conditional statements within Fortran files
let fortran_fold_multilinecomments=1                                            " Allows syntax folding of comments > 3 lines within Fortran files
au FileType fortran setlocal shiftwidth=2 softtabstop=4 tabstop=2               " Sets size of whitespace for indent and tabs
au Filetype fortran setlocal formatprg=fprettify\ --silent                      " Sets Fortran formatter to fprettify (go to top of file, type gqG to autoformat)
au FileType fortran compiler gfortran                                           " Sets Fortran compiler for linting

" Lightline
let g:lightline = { 'colorscheme': 'dracula',
                 \  'separator': { 'left': '', 'right': ''},
		 \  'subseparator': {'left': '', 'right': ''},
                 \  'component': {'percent': ' %3p%%', 'lineinfo': '%3l:%-3c'}, 
                 \  'component_function': { 'filetype' : 'MyFiletype',
                 \                          'fileformat' : 'MyFileformat'}}
                 "\  'separator': { 'left': '', 'right': ''},
		 "\  'subseparator': {'left': '', 'right': ''},
function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction
function! MyFileformat()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

