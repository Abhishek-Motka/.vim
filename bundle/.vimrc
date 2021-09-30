set nomodeline
set nocompatible
set cpo-=aA

" Enter numbers for each line
set number

" Make sure backspace works as intended in Visual mode
set backspace=indent,eol,start

" Disable audio bells
set visualbell

" Reload buffers when file changes on disk
set autoread

" Use UTF-8 encoding
set encoding=utf-8
scriptencoding utf-8

" Disable line wrap
set nowrap
set linebreak

" Show naughty white spaces
set lcs=tab:>~,trail:$,nbsp:#
set list
highlight InvisibleSpaces ctermfg=Black ctermbg=Black
call matchadd('InvisibleSpaces', '\S\@<=\s\+\%#\ze\s*$')

" Improve search in vim
set hlsearch
set incsearch
set ignorecase
set smartcase
" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Configure tabs
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

" Remal leader
let mapleader = ";"

execute pathogen#infect()
call pathogen#helptags()

syntax on
filetype plugin indent on

" Autoreload vim on changing .vimrc
augroup VimReload
autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END
nmap <silent>  ;v   :next $MYVIMRC<CR>

" Infer filetype
" augroup FiletypeInference
"    autocmd!
"    autocmd BufNewFile,BufRead  *.t      set filetype=perl
"    autocmd BufNewFile,BufRead  *.pod    set filetype=pod
"    autocmd BufNewFile,BufRead  *.itn    set filetype=itn
"    autocmd BufNewFile,BufRead  *.pm     set filetype=perl
"    autocmd BufNewFile,BufRead  *.go     set filetype=go
"    autocmd BufNewFile,BufRead  *        call s:infer_filetype()
" augroup END

" function! s:infer_filetype ()
"    for line in getline(1,20)
"        if line =~ '^\s*use\s*v\?5\.\S\+\s*;\s*$'
"            set filetype=perl
"            return
"        elseif line =~ '^\s*use\s*v\?6\s*;\s*$'
"            set filetype=perl6
"            return
"        endif
"    endfor
" endfunction

" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowb
set noswapfile

" Configure persistent undo
if has('persistent_undo')
    set undodir=$HOME/.vim/.undofiles
    set undolevels=5000
    set undofile
endif

" Remove trailing whitespace
nnoremap <silent> <BS><BS>  mz:call TrimTrailingWS()<CR>`z
function! TrimTrailingWS ()
    if search('\s\+$', 'cnw')
        :%s/\s\+$//g
    endif
endfunction

" Enable smart indent
set autoindent                              "Retain indentation on next line
set smartindent                             "Turn on autoindenting of blocks
let g:vim_indent_cont = 0                   " No magic shifts on Vim line continuations
"And no shift magic on comments...
nmap <silent>  >>  <Plug>ShiftLine
nnoremap <Plug>ShiftLine :call ShiftLine()<CR>
function! ShiftLine() range
    set nosmartindent
    exec "normal! " . v:count . ">>"
    set smartindent
    silent! call repeat#set( "\<Plug>ShiftLine" )
endfunction

" Visual Block mode is more useful
nnoremap v <C-V>
nnoremap <C-V> v
xnoremap v <C-V>
xnoremap <C-V> v

" Who doesn't love fast search
nmap <space> /
nmap <C-space> ?

" Fast saving
nmap <leader>w :w!<cr>
" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" work with splits easily
set splitbelow
set splitright
nmap <leader>h <C-W><C-H>
nmap <leader>j <C-W><C-J>
nmap <leader>k <C-W><C-K>
nmap <leader>l <C-W><C-L>
nmap <leader>n <C-W><C-W>
nmap <leader>ca <C-W><C-O>

" manage tabs efficiently
map <leader>tn :tabnext<cr>
map <leader>to :tabnew<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove<cr>
map <leader>tp :tabprevious<cr>
" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Array navigation
map <esc>b B
map <S-LEFT> ^
map <esc>f W
map <S-RIGHT> $

" Swap windows
let g:windowswap_map_keys = 0 "prevent default bindings
nnoremap <silent> <leader>yw :call WindowSwap#MarkWindowSwap()<CR>
nnoremap <silent> <leader>pw :call WindowSwap#DoWindowSwap()<CR>
nnoremap <silent> <leader>ww :call WindowSwap#EasyWindowSwap()<CR>

"Square up visual selections...
set virtualedit=block

" Make BS/DEL work as expected in visual modes (i.e. delete the selected text)...
xmap <BS> x

" Make vaa select the entire file...
xmap aa VGo1G

" Move selected visual blocks
xmap <S-UP>    <Plug>SchleppUp
xmap <S-DOWN>  <Plug>SchleppDown
xmap <S-LEFT>  <Plug>SchleppLeft
xmap <S-RIGHT> <Plug>SchleppRight
xmap <S-D>     <Plug>SchleppDupDown
xmap <C-D>     <Plug>SchleppDupUp

" Miscallaneous Configs
set title
set titleold=
set title titlestring=
set nomore
set cpoptions-=a
set viminfo=h,'500,<10000,s1000,/1000,:1000
set fileformats=unix,mac,dos
set wildignorecase
set wildmode=list:longest,full
set infercase
" Keycodes and maps timeout in 3/10 sec...
set timeout timeoutlen=300 ttimeoutlen=300
set scrolloff=2
set matchpairs+=<:>,[:],(:),{:}

" Backup current file
nnoremap <leader>bb :!cp % %.bak<CR><CR>:echomsg "Backed up" expand('%')<CR>

" Use space to jump down a page (like browsers do)...
xnoremap   <Space> <PageDown>

" Take off and nuke the entire buffer contents from space
" (It's the only way to be sure)...
nnoremap <expr> XX ClearBuffer(
function! ClearBuffer ()
    if &filetype =~ 'perl'
        return "1Gj}dGA\<CR>\<CR>\<ESC>"
    else
        return '1GdG'
    endif
endfunction

" configure MRU plugin
let MRU_Max_Entries = 400
map <leader>o :MRU<CR>

" Configure airline plugin
let g:airline#extensions#tabline#enabled = 1

"Enable TRUECOLOR mode
if (empty($TMUX))
  if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  if (has("termguicolors"))
    set termguicolors
  endif
endif


" Color scheme for onedark
let g:onedark_terminal_italics=1
let g:onedark_termcolors=256
let g:airline_theme='onedark'
set background=dark
colorscheme onedark

" Configure Tabline
hi TabLine      ctermfg=Gray  ctermbg=NONE     cterm=NONE
hi TabLineFill  ctermfg=Gray  ctermbg=NONE     cterm=NONE
hi TabLineSel   ctermfg=Black  ctermbg=DarkBlue  cterm=bold

" Configure Nerdtree
let NERDTreeMinimalUI = 1
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeGitStatusShowClean = 1
let g:NERDSpaceDelims = 1
let g:NERDTreeWinPos = 'right'
let g:NERDTreeChDirMode = 2

nnoremap <leader>nf :NERDTreeFocus<CR>
nnoremap <leader>nt :NERDTreeToggle<CR>
nnoremap <leader>nc :NERDTreeClose<CR>
nnoremap <leader>nb :NERDTreeCWD<CR>
nnoremap <leader>ns :NERDTreeFind<SPACE>
nnoremap <leader>no :NERDTree<SPACE>

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Configure undotree
let g:undotree_WindowLayout=3
let g:undotree_SetFocusWhenToggle=1
nnoremap <leader>us :UndotreeShow<CR>
nnoremap <leader>uh :UndotreeHide<CR>

" configure Tagbar
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1
let g:tagbar_compact = 1
let g:tagbar_show_tag_linenumbers = 2
nnoremap <leader>ot :TagbarOpenAutoClose<CR>
nnoremap <leader>oo :TagbarOpen<CR>
nnoremap <leader>oc :TagbarClose<CR>

" add prefix to fzf commands
let g:fzf_command_prefix = 'Fzf'

" Configure ack to not jump to first matched file
cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>

" Configure gitgutter plugin
set updatetime=1000
let g:gitgutter_map_keys = 0
nnoremap <leader>ggt :GitGutterToggle<CR>
nnoremap <leader>gge :GitGutterEnable<CR>
nnoremap <leader>ggd :GitGutterDisable<CR>
nnoremap <leader>ggn :GitGutterNextHunk<CR>
nnoremap <leader>ggp :GitGutterPrevHunk<CR>
nnoremap <leader>ggf :GitGutterFold<CR>
nnoremap <leader>ggg :GitGutterPreviewHunk<CR>
nnoremap <leader>ggu :GitGutterUndoHunk<CR>

" Configure CtrlP
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_root_markers = ['pom.xml']
nnoremap <leader>fs :CtrlP<CR>

" Enable colors for brackets
let g:rainbow_active = 1

" Configure ale linting
highlight AleError    ctermfg=red     cterm=bold
highlight AleWarning  ctermfg=magenta cterm=bold

augroup ALE_Autoconfig
    au!
    autocmd User GVI_Start  silent call Stop_ALE()
    autocmd User PV_Start   silent call Stop_ALE()
    autocmd User PV_End     silent call Start_ALE()
    autocmd User ALELint    silent HierUpdate
augroup END

let g:ale_completion_autoimport = 1
let g:ale_completion_enabled = 1
set omnifunc=ale#completion#OmniFunc
let g:ale_set_loclist          = 0
let g:ale_set_quickfix         = 1
let g:ale_set_signs            = 0
let g:ale_perl_perl_options    = '-cw -Ilib'
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_linters              = { 'perl': ['perl'] }
let g:ale_perl_perl_executable = 'polyperl'

function! Start_ALE ()
    if !expand('./.noale')
        ALEEnable
        HierStart
    endif
endfunction

function! Stop_ALE ()
    silent call s:ChangeProfile(&filetype)
    ALEDisable
    HierStop
    call setqflist([])
    redraw!
endfunction

function! Toggle_ALE ()
    if expand('./.noale')
        call Stop_ALE()
        echo 'Error highlighting disabled (.noale)'
    elseif g:ale_enabled
        call Stop_ALE()
        echo 'Error highlighting off'
    else
        call Start_ALE()
        echo 'Error highlighting on'
    endif
endfunction

" Configure hier for error highlighting
highlight HierError    ctermfg=red     cterm=bold
highlight HierWarning  ctermfg=magenta cterm=bold

let g:hier_highlight_group_qf  = 'HierError'
let g:hier_highlight_group_qfw = 'HierWarning'

let g:hier_highlight_group_loc  = 'Normal'
let g:hier_highlight_group_locw = 'HierWarning'
let g:hier_highlight_group_loci = 'Normal'

" configure vim-snippet
let g:snipMate = {}
let g:snips_no_mappings = 1
let g:snipMate.snippet_version = 1
inoremap <S-Tab> <Plug>snipMateTrigger
snoremap <S-Tab> <Plug>snipMateSNext
snoremap <C-Tab> <Plug>snipMateSBack

" Configure BufExplorer
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerFindActive=1
let g:bufExplorerSortBy='name'
nnoremap <leader>bo :BufExplorer<cr>

" Make perl programming easy

" Execute Perl file (output to pager)...
nmap E :!polyperl -m %<CR>

" Execute Perl file (in debugger)...
nmap Q :!polyperl -d %<SPACE>

" Preview perltidy changes
nmap <leader>p :call Perltidy_diff()<CR>
" Format perl file with perltidy
nmap <leader>pp 1G!Gperltidy<CR>

function! Perltidy_diff ()
    " Work out what the tidied file will be called...
    let perl_file = expand( '%' )
    let tidy_file = perl_file . '.tdy'
    call system( 'perltidy -nst ' . perl_file . ' -o ' . tidy_file)
    " Add the diff to the right of the current window...
    set splitright
    exe ":vertical diffsplit " . tidy_file
    " Clean up the tidied version...
    call delete(tidy_file)
endfunction

" set keyword characters to match Perlish identifiers...
set iskeyword+=$
set iskeyword+=%
set iskeyword+=@-@
set iskeyword+=:
set iskeyword-=,

" Smart completion
runtime plugin/smartcom.vim

" Add extra completions (mainly for Perl programming)...
let ANYTHING = ""
let NOTHING  = ""
let EOL      = '\s*$'

call SmartcomAdd( '?',     ANYTHING,  '?',{'restore':1} )
call SmartcomAdd( '?',     '?',       "\<CR>\<ESC>O\<TAB>")
call SmartcomAdd( '{{',    ANYTHING,  '}}',{'restore':1} )
call SmartcomAdd( '{{',    '}}',      NOTHING,)
call SmartcomAdd( 'qr{',   ANYTHING,  '}xms',{'restore':1} )
call SmartcomAdd( 'qr{',   '}xms',    "\<CR>\<C-D>\<ESC>O\<C-D>\<TAB>")
call SmartcomAdd( 'm{',    ANYTHING,  '}xms',{'restore':1} )
call SmartcomAdd( 'm{',    '}xms',    "\<CR>\<C-D>\<ESC>O\<C-D>\<TAB>",)
call SmartcomAdd( 's{',    ANYTHING,  '}{}xms',{'restore':1} )
call SmartcomAdd( 's{',    '}{}xms',  "\<CR>\<C-D>\<ESC>O\<C-D>\<TAB>",)

function! AlignOnPat (pat)
    return "\<ESC>:call EQAS_Align('nmap',{'pattern':'" . a:pat . "'})\<CR>A"
endfunction

call SmartcomAdd( '=',         ANYTHING,    "\<ESC>:call EQAS_Align('nmap')\<CR>A")
call SmartcomAdd( '=>',        ANYTHING,    AlignOnPat('=>') )
call SmartcomAdd( '\s#',       ANYTHING,    AlignOnPat('\%(\S\s*\)\@<= #') )
call SmartcomAdd( '[''"]\s*:', ANYTHING,    AlignOnPat(':'),{'filetype':'vim'} )
call SmartcomAdd( ':',         ANYTHING,    "\<TAB>",{'filetype':'vim'} )

" Perl keywords...
call SmartcomAdd( '^\s*for', EOL,    " my $… (…) {\n…\n}\n…", {'filetype':'perl'} )
call SmartcomAdd( '^\s*if', EOL,    " (…) {\n…\n}\n…",       {'filetype':'perl'} )
call SmartcomAdd( '^\s*while', EOL,    " (…) {\n…\n}\n…",       {'filetype':'perl'} )
call SmartcomAdd( '^\s*given', EOL,    " (…) {\n…\n}\n…",       {'filetype':'perl'} )
call SmartcomAdd( '^\s*when', EOL,    " (…) {\n…\n}\n…",       {'filetype':'perl'} )
call SmartcomAdd( '^\s*sub', EOL,    " … (…) {\n…\n}\n…",     {'filetype':'perl'})

" Insert various shebang lines...
iab hbc #! /bin/csh
iab hbs #! /bin/sh
iab hbp #! /usr/bin/env perl<CR><CR>use strict;<CR>use warnings;<CR>

" Make diffs less glaringly ugly...
highlight DiffAdd      ctermfg=darkgreen    ctermbg=black
highlight DiffChange   ctermfg=darkyellow   ctermbg=black
highlight DiffDelete   ctermfg=red          ctermbg=black
highlight DiffText     ctermfg=darkblue     ctermbg=black

" configure devicons
set guifont=JetBrains\ Mono\ Regular\ Nerd\ Font\ Complete\ Mono:h11

"=====[ Search folding ]=====================

" Don't start new buffers folded
set foldlevelstart=99

" Highlight folds
highlight Folded  ctermfg=cyan ctermbg=black

" Toggle special folds on and off...
nmap <silent> <expr>  zz  FS_ToggleFoldAroundSearch({'context':1})
nmap <silent> <expr>  zc  FS_ToggleFoldAroundSearch({'hud':1})


" Heads-up on function names (in Vim and Perl)...

let g:HUD_search = {
\   'vim':  { 'list':     [ { 'start': '^\s*fu\%[nction]\>!\?\s*\w\+.*',
\                             'end':   '^\s*endf\%[unction]\>\zs',
\                           },
\                           { 'start': '^\s*aug\%[roup]\>!\?\s*\%(END\>\)\@!\w\+.*',
\                             'end':   '^\s*aug\%[roup]\s\+END\>\zs',
\                           },
\                         ],
\              'default': '"file " . expand("%:~:.")',
\           },
\
\   'perl': { 'list':    [ { 'start': '\_^\s*\zssub\s\+\w\+.\{-}\ze\s*{\|^__\%(DATA\|END\)__$',
\                            'end':   '}\zs',
\                          },
\                          { 'start': '\_^\s*\zspackage\s\+\w\+.\{-}\ze\s*{',
\                            'end':   '}\zs',
\                          },
\                          { 'start': '\_^\s*\zspackage\s\+\w\+.\{-}\ze\s*;',
\                            'end':   '\%$',
\                          },
\                        ],
\             'default': '"package main"',
\          },
\ }

function! HUD ()
    let target = get(g:HUD_search, &filetype, {})
    let name = "'????'"
    if !empty(target)
        let name = eval(target.default)
        for nexttarget in target.list
            let [linestart, colstart] = searchpairpos(nexttarget.start, '', nexttarget.end, 'cbnW')
            if linestart
                let name = matchstr(getline(linestart), nexttarget.start)
                break
            endif
        endfor
    endif

    if line('.') <= b:FS_DATA.context
        return '⎺⎺⎺⎺⎺\ ' . name . ' /⎺⎺⎺⎺⎺' . repeat('⎺',200)
    else
        return '⎽⎽⎽⎽⎽/ ' . name . ' \⎽⎽⎽⎽⎽' . repeat('⎽',200)
    endif
endfunction

nmap <silent> <expr>  zh  FS_ToggleFoldAroundSearch({'hud':1, 'folds':'HUD()', 'context':3})


" Show only sub defns (and maybe comments)...
let perl_sub_pat = '^\s*\%(sub\|func\|method\|package\)\s\+\k\+'
let vim_sub_pat  = '^\s*fu\%[nction!]\s\+\k\+'
augroup FoldSub
    autocmd!
    autocmd BufEnter * nmap <silent> <expr>  zp  FS_FoldAroundTarget(perl_sub_pat,{'context':1})
    autocmd BufEnter * nmap <silent> <expr>  za  FS_FoldAroundTarget(perl_sub_pat.'\zs\\|^\s*#.*',{'context':0, 'folds':'invisible'})
    autocmd BufEnter *.vim,.vimrc nmap <silent> <expr>  zp  FS_FoldAroundTarget(vim_sub_pat,{'context':1})
    autocmd BufEnter *.vim,.vimrc nmap <silent> <expr>  za  FS_FoldAroundTarget(vim_sub_pat.'\\|^\s*".*',{'context':0, 'folds':'invisible'})
    autocmd BufEnter * nmap <silent> <expr>             zv  FS_FoldAroundTarget(vim_sub_pat.'\\|^\s*".*',{'context':0, 'folds':'invisible'})
augroup END

" Show only 'use' statements
nmap <silent> <expr>  zu  FS_FoldAroundTarget('\(^\s*\(use\\|no\)\s\+\S.*;\\|\<require\>\s\+\S\+\)',{'context':1})

" Need to load this early, so we can override its nmapped ++
runtime plugin/eqalignsimple.vim
xnoremap <expr> ++  VMATH_YankAndAnalyse()
nmap            ++  vip++

"=====[ Diff against disk ]==========================================

map <silent> zd :silent call DC_DiffChanges()<CR>

" Change the fold marker to something more useful
function! DC_LineNumberOnly ()
    if v:foldstart == 1 && v:foldend == line('$')
        return '.. ' . v:foldend . '  (No difference)'
    else
        return '.. ' . v:foldend
    endif
endfunction

" Track each buffer's initial state
augroup DC_TrackInitial
    autocmd!
    autocmd BufReadPost,BufNewFile  *   if !exists('b:DC_initial_state')
    autocmd BufReadPost,BufNewFile  *       let b:DC_initial_state = getline(1,'$')
    autocmd BufReadPost,BufNewFile  *   endif
augroup END

highlight DC_DEEMPHASIZED ctermfg=grey

function! DC_DiffChanges ()
    diffthis
    highlight Normal ctermfg=grey
    let initial_state = b:DC_initial_state
    set diffopt=context:2,filler,foldcolumn:0
"    set fillchars=fold:ÃÂ
    set foldcolumn=0
    setlocal foldtext=DC_LineNumberOnly()
    set number

"    aboveleft vnew
    belowright vnew
    normal 0
    silent call setline(1, initial_state)
    diffthis
    set diffopt=context:2,filler,foldcolumn:0
"    set fillchars=fold:ÃÂ
    set foldcolumn=0
    setlocal foldtext=DC_LineNumberOnly()
    set number

    nmap <silent><buffer> zd :diffoff<CR>:q!<CR>:set diffopt& fillchars& number& foldcolumn=0<CR>:set nodiff<CR>:highlight Normal ctermfg=NONE<CR>
endfunction

" Keep long lines from slowing Vim too much
set synmaxcol=200
