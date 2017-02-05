function Main()
    set hidden             "allow hidden buffers with unsaved changes
    set hlsearch           "highlight all search pattern matches
    set showcmd            "show partially entered commands on last line
    set colorcolumn=80,120 "highlight conventional line length limits

    set list                     "enable list mode
    set listchars=tab:!.,trail:_ "show tab characters and trailing spaces
    set display=uhex             "show unprintable characters as e.g. <80>

    set expandtab     "add spaces when tab key is pressed (not tab characters)
    set tabstop=8     "tab key alignment and tab character alignment (columns)
    set shiftwidth=4  "column count per single level of indentation
    set softtabstop=0 "this is an evil variable which should always be zero
    set smarttab      "use shiftwidth as tab key alignment at start of line

    set showtabline=2              "always show tabline
    set tabline=%!MyTabLine()      "use custom tabline
    set laststatus=2               "always show statusline
    let &statusline=MyStatusLine() "use custom statusline

    "check for non-ascii characters when opening a buffer
    autocmd BufEnter * global/[^\x00-\x7F]/echo 'Unexpected character found!'

    nmap <Space> <Leader>
    nnoremap <Leader>a :%s/[^\x00-\x7F]/<Char-127>/gc<CR>
    nnoremap <leader>w :%s/\s\+$//gc<CR>
    nnoremap <Left> <Nop>
    nnoremap <Down> <Nop>
    nnoremap <Up> <Nop>
    nnoremap <Right> <Nop>
    nnoremap n nzz
    nnoremap N Nzz
endfunction

function MyStatusLine()
    "relative path to file in buffer
    let s = '%f'
    "separation point between left and right aligned items
    let s .= '%='
    "display a warning if file format is not unix
    let s .= '%{&ff!=''unix''?''[''.&ff.'']'':''''}'
    "display a warning if file encoding is not utf-8
    let s .='%{(&fenc!=''utf-8''&&&fenc!='''')?''[''.&fenc.'']'':''''}'
    "help file? preview window? read only?
    let s .= '%h%w%r'
    "line number/number of lines, column number
    let s .= '|%l/%L, %c'
    "character under cursor @ position in file
    let s .= '|0x%02B @ 0x%08O'
    return s
endfunction

function MyTabLine()
    let s = ''
    for i in range(1, bufnr('$'))
        "buf number
        let bn = bufnr('$') - i + 1
        if bn + winbufnr(0) > bufnr('$')
            let bn += winbufnr(0) - bufnr('$')
        else
            let bn += winbufnr(0)
        endif
        if buflisted(bn) == 0
            continue
        endif
        "buf name
        let n = ''
        if getbufvar(bn, '&buftype') == 'help'
            let n .= '[H]'
        elseif getbufvar(bn, '&buftype') == 'quickfix'
            let n .= '[Q]'
        else
            let n .= fnamemodify(bufname(bn), ':t')
            if n == ''
                let n .= '[New]'
            endif
        endif
        "buf flag
        let f = ''
        if getbufvar(bn, '&modified')
            let f .= '+'
        endif
        "final string
        if bn == winbufnr(0)
            let s .= '/' . ' ' . bn . f . ' ' . n . ' ' . '\'
        else
            let s .= ' ' . ' ' . bn . f . ' ' . n . ' ' . '\'
        endif
    endfor
    "after the last tab fill with TabLineFill and reset tab page nr
    let s .= '%#TabLineFill#%T'
    " right-align the label to close the current tab page
    if tabpagenr('$') > 1
        let s .= '%=%#TabLineFill#%999Xclose'
    endif
    return s
endfunction

call Main()
