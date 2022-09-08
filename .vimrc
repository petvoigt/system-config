"
" $HOME/.vimrc
"
" Last changes - Dr. Peter Voigt - 2022-08-11
"
let color="true"
syntax on
set ruler
set nowrap
set textwidth=80
set swapfile
set dir=$HOME/tmp
" set nonumber
set number relativenumber
set cursorline
set cursorcolumn
:hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
:hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
" Use \c to toggle cursorline/cursorcolumn on and off.
:nnoremap <Leader>c :set cursorline! cursorcolumn!
" Use \c to toggle linenumbers/relativenumber on and off.
:nnoremap <Leader>d :set number! relativenumber!
set colorcolumn=80
" set list
set tabstop=4
set expandtab
" Use :retab to convert pre-existing tabs to spaces.
set laststatus=2
set nobackup
set nowritebackup
set noundofile
if has("multi_byte")
    if &encoding !~? '^u'
        if &termencoding == ""
            let &termencoding = &encoding " Used by keyboard.
        endif
        set encoding=utf-8 " Used by vim internally.
    endif
    setglobal fileencoding=utf-8 " Used when writing file.
    " Uncomment to have 'bomb' on by default for new files.
    " Note, this will not apply to the first, empty buffer created at Vim startup.
    " setglobal bomb
    set fileencodings=ucs-bom,utf-8,latin1,cp1252
endif
set fileformat=unix
" Statusline parameters, type :help statusline for detailed list:
if has("statusline")
    set statusline=%<%f " Tail of the file
    set statusline+=\ %h%m%r " Help tag, modified flag, read-only flag
    set statusline+=%= " Left/right separator
    set statusline+=\ %y " File type like e.g. [vim]
    set statusline+=\ [%{&ff}] " File format like e.g. [unix]
    " Next line: Fileencoding like e.g. [utf-8,B]
    set statusline+=\ %{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\"}
    set statusline+=\ \%LL " Total lines
    set statusline+=\ %-14.(%l,%c%V%) " Cursor line, cursor column, virtual column as -{num}
    set statusline+=\ %p%% " Percentage through file in lines
endif
set printdevice=laser
set printoptions+=paper:a4,duplex:off
" Enable pasting from clipboard, requiring a clipboard enabled vim:
" vim --version |grep clipboard
set mouse=r
