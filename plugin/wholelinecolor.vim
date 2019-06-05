" The starting point of this plugin was the numsign plugin created by Jinjing He
" (https://github.com/vim-scripts/numsign.vim). Some of the original code remains.

" {{{variables
if !exists("g:wholelinecolor_leader")
    let g:wholelinecolor_leader='<Space>'
endif

if !exists("g:wholelinecolor_next")
    let g:wholelinecolor_next='<space><c-n>'
endif

if !exists("g:wholelinecolor_prev")
    let g:wholelinecolor_prev='<space><c-p>'
endif

" starting sign id (change if conflicting with other signs)
if !exists("g:wholelinecolor_sign_num")
    let g:wholelinecolor_sign_num = 373700
endif
" }}}
" {{{mappings
execute 'nnoremap <silent> ' . g:wholelinecolor_next . ' :call <sid>GotoNextSign()<cr>'
execute 'nnoremap <silent> ' . g:wholelinecolor_prev . ' :call <sid>GotoPrevSign()<cr>'

nnoremap          <Plug>WholeLineColorBlack  :call <sid>ExecuteWholeLineColor("Black")<cr>
vnoremap          <Plug>WholeLineColorBlack  :call <sid>ExecuteWholeLineColor("Black")<cr>
nnoremap <silent> <Plug>WholeLineColorRed    :call <sid>ExecuteWholeLineColor("Red")<cr>
vnoremap <silent> <Plug>WholeLineColorRed    :call <sid>ExecuteWholeLineColor("Red")<cr>
nnoremap <silent> <Plug>WholeLineColorPurple :call <sid>ExecuteWholeLineColor("Purple")<cr>
vnoremap <silent> <Plug>WholeLineColorPurple :call <sid>ExecuteWholeLineColor("Purple")<cr>
nnoremap <silent> <Plug>WholeLineColorBlue   :call <sid>ExecuteWholeLineColor("Blue")<cr>
vnoremap <silent> <Plug>WholeLineColorBlue   :call <sid>ExecuteWholeLineColor("Blue")<cr>
nnoremap <silent> <Plug>WholeLineColorGrey   :call <sid>ExecuteWholeLineColor("Grey")<cr>
vnoremap <silent> <Plug>WholeLineColorGrey   :call <sid>ExecuteWholeLineColor("Grey")<cr>
nnoremap <silent> <Plug>WholeLineColorGreen  :call <sid>ExecuteWholeLineColor("Green")<cr>
vnoremap <silent> <Plug>WholeLineColorGreen  :call <sid>ExecuteWholeLineColor("Green")<cr>

execute 'nmap ' . g:wholelinecolor_leader . 'bb <Plug>WholeLineColorBlack'
execute 'vmap ' . g:wholelinecolor_leader . 'bb <Plug>WholeLineColorBlack'
execute 'nmap ' . g:wholelinecolor_leader . 'br <Plug>WholeLineColorRed'
execute 'vmap ' . g:wholelinecolor_leader . 'br <Plug>WholeLineColorRed'
execute 'nmap ' . g:wholelinecolor_leader . 'bp <Plug>WholeLineColorPurple'
execute 'vmap ' . g:wholelinecolor_leader . 'bp <Plug>WholeLineColorPurple'
execute 'nmap ' . g:wholelinecolor_leader . 'bl <Plug>WholeLineColorBlue'
execute 'vmap ' . g:wholelinecolor_leader . 'bl <Plug>WholeLineColorBlue'
execute 'nmap ' . g:wholelinecolor_leader . 'bg <Plug>WholeLineColorGrey'
execute 'vmap ' . g:wholelinecolor_leader . 'bg <Plug>WholeLineColorGrey'
execute 'nmap ' . g:wholelinecolor_leader . 'bn <Plug>WholeLineColorGreen'
execute 'vmap ' . g:wholelinecolor_leader . 'bn <Plug>WholeLineColorGreen'

nnoremap <silent> <Plug>WholeLineColorSignUnplace :call <sid>ExecuteWholeLineColorSignUnplace()<cr>
vnoremap <silent> <Plug>WholeLineColorSignUnplace :call <sid>ExecuteWholeLineColorSignUnplace()<cr>
execute 'nmap ' . g:wholelinecolor_leader . 'bu <Plug>WholeLineColorSignUnplace'
execute 'vmap ' . g:wholelinecolor_leader . 'bu <Plug>WholeLineColorSignUnplace'

execute 'nnoremap <silent> ' . g:wholelinecolor_leader . 'bU :1,$ call <sid>ExecuteWholeLineColorSignUnplace()<cr>'
execute 'nnoremap <silent> ' . g:wholelinecolor_leader . 'bD zR:call <sid>WholeLineColorDeleteLines()<cr>'
execute 'nnoremap <silent> ' . g:wholelinecolor_leader . 'bK zR:call <sid>WholeLineColorKeepLines()<cr>'
" }}}
" {{{highlights
if !hlexists('WLCBlackBackground')
    highlight WLCBlackBackground  ctermbg=233 guibg=#121212
endif
if !hlexists('WLCRedBackground')
    highlight WLCRedBackground    ctermbg=52  guibg=#882323
endif
if !hlexists('WLCBlueBackground')
    highlight WLCBlueBackground   ctermbg=17  guibg=#003366
endif
if !hlexists('WLCPurpleBackground')
    highlight WLCPurpleBackground ctermbg=53  guibg=#732c7b
endif
if !hlexists('WLCGreyBackground')
    highlight WLCGreyBackground   ctermbg=238 guibg=#464646
endif
if !hlexists('WLCGreenBackground')
    highlight WLCGreenBackground  ctermbg=22  guibg=#005500
endif
" }}}
" {{{signs
sign define wholelinecolor_Black  linehl=WLCBlackBackground
sign define wholelinecolor_Red    linehl=WLCRedBackground
sign define wholelinecolor_Blue   linehl=WLCBlueBackground
sign define wholelinecolor_Purple linehl=WLCPurpleBackground
sign define wholelinecolor_Grey   linehl=WLCGreyBackground
sign define wholelinecolor_Green  linehl=WLCGreenBackground
" }}}
" {{{ExecuteWholeLineColor()
function! <sid>ExecuteWholeLineColor(color) range
    execute a:firstline . ',' . a:lastline . 'call <sid>ExecuteWholeLineColorSignUnplace()'
    for linenr in range(a:firstline, a:lastline)
        let g:wholelinecolor_sign_num += 1
        exe "sign place " . g:wholelinecolor_sign_num . " name=wholelinecolor_" . a:color . " line=" . linenr . " buffer=" . winbufnr(0)
    endfor
    try
        execute 'call repeat#set("\<Plug>WholeLineColor' . a:color . '", v:count)'
    catch
    endtry
endfunction
" }}}
" {{{ExecuteWholeLineColorSignUnplace()
function! <sid>ExecuteWholeLineColorSignUnplace() range
    call s:GetAllSigns()
    let signId = 0
    for linenr in range(a:firstline, a:lastline)
        for item in b:allSigns
            if item[0] == linenr
                let signId = item[1]
                break
            endif
        endfor
        if signId != 0
            exe "silent! sign unplace " . signId . " buffer=" . winbufnr(0)
        endif
    endfor
    try
        call repeat#set("\<Plug>WholeLineColorSignUnplace", v:count)
    catch
    endtry
endfunction
" }}}
" {{{GetVimCmdOutput()
function! s:GetVimCmdOutput(cmd)
    " Save the original locale setting for the messages
    let old_lang = v:lang
    " Set the language to English
    if(has("win32"))
        exe ":lan mes en_US"
    else
        exe ":lan POSIX"
    endif
    let output = ''
    try
        redir => output
        silent exe a:cmd
    catch /.*/
        let v:errmsg = substitute(v:exception, '^[^:]\+:', '', '')
    endtry
    redir END
    " Restore the original locale
    exe ":lan mes " . old_lang
    return output
endfunction
" }}}
" {{{GetAllSigns()
function! s:GetAllSigns()
    let signStr = s:GetVimCmdOutput('sign place buffer=' . winbufnr(0))
    let b:topSignsInSections = []
    let b:allSigns = []
    let start_from  = 0
    let last_lineno = -1
    let last_name   = "dummy_name"
    while 1
        let begin = matchend(signStr, "line=", start_from)
        if begin <= 0
            break
        endif
        let end    = match(signStr, " ", begin)
        let lineno = strpart(signStr, begin, end - begin)
        let begin  = matchend(signStr, "id=", end)
        let end    = match(signStr, " ", begin)
        let id     = strpart(signStr, begin, end - begin)
        let begin  = matchend(signStr, "name=", end)
        let end    = match(signStr, "\n", begin)
        let name   = strpart(signStr, begin, end - begin)
        if id >= 373700 && id < 400000 && (lineno > last_lineno + 1 || name != last_name)
            call add(b:topSignsInSections, [lineno, id])
        endif
        let start_from  = end
        if id >= 373700 && id < 400000
            call add(b:allSigns, [lineno, id])
            let last_lineno = lineno
            let last_name   = name
        endif
    endwhile
endfunction
" }}}
" {{{GetWholeLineSignsLineNumberList()
function! s:GetWholeLineSignsLineNumberList()
    let signStr = s:GetVimCmdOutput('sign place buffer=' . winbufnr(0))
    let line_numbers = []
    let start_from  = 0
    while 1
        let begin = matchend(signStr, "line=", start_from)
        if begin <= 0
            break
        endif
        let end    = match(signStr, " ", begin)
        let lineno = strpart(signStr, begin, end - begin)
        let begin  = matchend(signStr, "id=", end)
        let end    = match(signStr, " ", begin)
        let id     = strpart(signStr, begin, end - begin)
        let begin  = matchend(signStr, "name=", end)
        let end    = match(signStr, "\n", begin)
        let name   = strpart(signStr, begin, end - begin)
        if id >= 373700 && id < 400000
            call add(line_numbers, lineno)
        endif
        let start_from  = end
    endwhile
    return line_numbers
endfunction
" }}}
" {{{WholeLineColorDeleteLines()
function! <sid>WholeLineColorDeleteLines()
    let del_list = s:GetWholeLineSignsLineNumberList()
    1,$call ExecuteWholeLineColorSignUnplace()
    let accumulated_register = ""
    let @" = ""
    for item in reverse(del_list)
        let accumulated_register = @" . accumulated_register
        exe item . 'd'
    endfor
    let accumulated_register = @" . accumulated_register
    let @" = accumulated_register
    let clipboard_list = split(&clipboard, ',')
    if match(clipboard_list, "unnamed") != -1
        let @* = @"
    endif
    if match(clipboard_list, "unnamedplus") != -1
        let @+ = @"
    endif
endfunction
" }}}
" {{{WholeLineColorKeepLines()
function! <sid>WholeLineColorKeepLines()
    let del_list = s:GetWholeLineSignsLineNumberList()
    let accumulated_register = ""
    let @" = ""
    for item in reverse(range(1, line('$')))
        if index(del_list, string(item)) == -1
            let accumulated_register = @" . accumulated_register
            exe item . 'd'
        endif
    endfor
    let accumulated_register = @" . accumulated_register
    let @" = accumulated_register
    let clipboard_list = split(&clipboard, ',')
    if match(clipboard_list, "unnamed") != -1
        let @* = @"
    endif
    if match(clipboard_list, "unnamedplus") != -1
        let @+ = @"
    endif
endfunction
" }}}
" {{{GetNextSignLine_ByLineNo()
function! s:GetNextSignLine_ByLineNo(curLineNo)
    let size = len(b:topSignsInSections)
    if size == 0
        return -1
    endif
    let signLine = -1
    for item in b:topSignsInSections
        if item[0] > a:curLineNo
            let signLine = item[0]
            break
        endif
    endfor
    if signLine == -1
        let signLine = b:topSignsInSections[0][0]
    endif
    return signLine
endfunction
" }}}
" {{{GetPrevSignLine_ByLineNo()
function! s:GetPrevSignLine_ByLineNo(curLineNo)
    let size = len(b:topSignsInSections)
    if size == 0
        return -1
    endif
    if size == 1
        return b:topSignsInSections[0][0]
    endif
    let signLine = -1
    let i = 0
    while i < size-1
        if b:topSignsInSections[i][0] < a:curLineNo
            if b:topSignsInSections[i+1][0] >= a:curLineNo
                let signLine = b:topSignsInSections[i][0]
                break
            endif
        endif
        let i = i + 1
    endwhile
    if signLine == -1
        let signLine = b:topSignsInSections[size-1][0]
    endif
    return signLine
endfunction
" }}}
" {{{GotoNextSign()
function! <sid>GotoNextSign()
    call s:GetAllSigns()  " solve when add or remove lines ,sign pos moved
    let curLineNo = line(".")
    let next_sign_line_number = s:GetNextSignLine_ByLineNo(curLineNo)
    if next_sign_line_number >= 0
        exe ":" . next_sign_line_number
    endif
endfunction
" }}}
" {{{GotoPrevSign()
function! <sid>GotoPrevSign()
    call s:GetAllSigns()  " solve when add or remove lines ,sign pos moved
    let curLineNo = line(".")
    let prev_sign_line_number = s:GetPrevSignLine_ByLineNo(curLineNo)
    if prev_sign_line_number >= 0
        exe ":". prev_sign_line_number
    endif
endfunction
" }}}

" vim:fdm=marker:ts=4:sw=4
