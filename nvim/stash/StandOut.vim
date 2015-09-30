" A small plugin to make some lines of text into a comment header
" Written by Andrei Thorp w/ help from Tim Pope

function! s:commentdash(line)
    let spaces = matchstr(a:line,'\s*')
    let comment = "#"
    let dashcount = strlen(a:line) - strlen(spaces) - strlen(comment)
    return spaces . comment . repeat("-",dashcount)
endfunction

"spaces.printf(&commentstring,repeat("-",dashcount))
"11:13 < tpope> options can be accessed with &option
"11:14 < tpope> that will work except you also need to recalculate dashcount
"11:14 < tpope> - strlen(&commentstring) + 2 (for %s) rather than - 2
"11:15 < tpope> I'll leave this as an exercise to the reader

function! s:standout() range
    let before = s:commentdash(getline(a:firstline))
    let after = s:commentdash(getline(a:lastline))
    exe a:firstline
    -put =before
    exe a:lastline
    +put =after
    exe "let x = 1"
endfunction

:command! -bar -range StandOut :<line1>,<line2>call s:standout()
