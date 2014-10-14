" don't be vi-compatible
set nocompatible
let mapleader=" "

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" git-driven install of plugins and auto integration
if filereadable(expand("$HOME/.vim/autoload/pathogen.vim"))
   silent! call pathogen#infect()
endif

if has("autocmd")
   " clear any existing autocmd
   autocmd!

   " auto insertion of comment leaders
   autocmd FileType c,cpp set formatoptions+=ro

   " left aligned c,cpp comment starting with /**, middle **, ending with **/
   autocmd FileType c,cpp set comments-=s1:/*,mb:*,ex:*/
   autocmd FileType c,cpp set comments+=s1:/*!,mb:**,ex:*/,sr:/**,mb:**,ex:*/ 

   " autocompletion
   autocmd FileType c,cpp iab /*** /******************************************************************************

   " Treat .ssl files as XML
   autocmd BufNewFile,BufRead *.ssl setfiletype xml
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" show filename
set statusline+=%F
set laststatus=2

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" color scheme

"if ! has("gui_running")
"   set t_Co=256
"endif

"set background=light
"colors peaksea


"""""""""""""""""""""""""""""""""""""""
" terminal settings
"
" syntax highlighting
if has('syntax') && (&t_Co > 1)
   syntax enable
endif

" history buffer
set history=50

" rehighlight off
"set viminfo='10,f1,<500,h

" displays in status line
set showmode
set showcmd

" don't have files override this .vimrc
set nomodeline

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" filetype detection
filetype plugin indent on


""""""""""""""""""""""""""""""""""""""""""""""""""""""
" text formatting
"
" syntax highlighting

syntax on

" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>
set list

" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

" wrapping
set nowrap
set formatoptions-=t " no auto-wrap, except for comments
set textwidth=128

" line numbers
set number
set nuw=6

" indents
set shiftwidth=3
set expandtab
set autoindent


""""""""""""""""""""""""""""""""""""""""""""""""""""""
" help

" goto next help bookmark in the current buffer
nmap <s-b> /<bar>:\?\(\S\+-\?\)\+<bar><cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Replace visual selection using ctrl+r
" Escape special characters in a string for exact matching.
" This is useful to copying strings from the file to the search tool
" Based on this - http://peterodding.com/code/vim/profile/autoload/xolox/escape.vim
function! EscapeString (string)
   let string=a:string
   " Escape regex characters
   let string = escape(string, '^$.*\/~[]')
   " Escape the line endings
   let string = substitute(string, '\n', '\\n', 'g')
   return string
endfunction

" Get the current visual block for search and replaces
" This function passed the visual block through a string escape function
" Based on this - http://stackoverflow.com/questions/676600/vim-replace-selected-text/677918#677918
function! GetVisual() range
   " Save the current register and clipboard
   let reg_save = getreg('"')
   let regtype_save = getregtype('"')
   let cb_save = &clipboard
   set clipboard&

   " Put the current visual selection in the " register
   normal! ""gvy
   let selection = getreg('"')

   " Put the saved registers and clipboards back
   call setreg('"', reg_save, regtype_save)
   let &clipboard = cb_save

   "Escape any special characters in the selection
   let escaped_selection = EscapeString(selection)

   return escaped_selection
endfunction

" Start the find and replace command across the entire file
"vmap <leader>z <Esc>:%s/<c-r>=GetVisual()<cr>/
"vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
vnoremap <C-r> <Esc>:%s/<c-r>=GetVisual()<cr>//gc<left><left><left>


""""""""""""""""""""""""""""""""""""""""""""""""""""""
" moving
nmap <s-h> <c-w><
nmap <s-j> <c-w>-
nmap <s-k> <c-w>+
nmap <s-l> <c-w>>

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" inserting newline
nmap <S-Enter> O<Esc>j
nmap <CR> o<Esc>k

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree
let NERDTreeDirArrows=0
let NERDTreeIgnore=['\.swp$', '^\.git', '\~$']
nmap <s-q> :NERDTreeFind<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" taglist: http://sourceforge.net/projects/vim-taglist
nmap <s-w> :TlistToggle<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" conque term
" let g:ConqueTerm_ReadUnfocused = 1
" nmap <s-a> :ConqueTermSplit bash<cr>


" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
   let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
   if l:tabstop > 0
      let &l:sts = l:tabstop
      let &l:ts = l:tabstop
      let &l:sw = l:tabstop
   endif
   call SummarizeTabs()
endfunction

function! SummarizeTabs()
   try
      echohl ModeMsg
      echon 'tabstop='.&l:ts
      echon ' shiftwidth='.&l:sw
      echon ' softtabstop='.&l:sts
      if &l:et
         echon ' expandtab'
      else
         echon ' noexpandtab'
      endif
   finally
      echohl None
   endtry
endfunction
