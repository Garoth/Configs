"                         Common-Editor Settings
"                         ----------------------
function! CommonEditor()
  let s:funcRegex = '^    \<.*= function \?('

  " Returns the next line that has a function declaration (only = syntax)
  function! CEFindNextFunction(currentLineNum)
    let numlines = line('$')
    let current = a:currentLineNum

    while current <= numlines
      if match(getline(current), s:funcRegex) >= 0
        return getline(current)
      endif

      let current += 1
    endwhile

    return "UNKNOWN FUNCTION"
  endfunction

  " Fold function for common-editor
  function! CEFolds()
    let thisline = getline(v:lnum)
    let prevline = getline(v:lnum - 1)

    if match(thisline, '^    \/\*\*$') >= 0
      return ">1"
    elseif match(thisline, s:funcRegex) >= 0 && match(prevline, '^\s*\*\/$') < 0
      return ">1"
    endif

    return "="
  endfunction

  " Fold text function for common-editor
  function! CEFoldText()
    let foldsize = v:foldend - v:foldstart
    let foldtext = getline(v:foldstart)
    let name = 'UNKNOWN'

    " Finds a name for the current or nearby function
    if match(foldtext, '^    \/\*\*') >= 0
      let nextfn = CEFindNextFunction(v:foldstart)
      let name = substitute(nextfn, '^\s*\([^=]*\).*', '\1', '')
    elseif match(foldtext, s:funcRegex) >= 0
      let name = substitute(foldtext, '^\s*\([^=]*\).*', '\1', '')
    endif
    let foldtext = 'Function: ' . name

    " Produces a pretty version of the name
    if match(name, 'execCommand') >= 0
      let foldtext = 'Command:  ' . substitute(name, '.*\(execCommand.*\)', '\1', '')
    elseif match(name, 'queryCommand') >= 0
      let foldtext = 'Command:  ' . substitute(name, '.*\(queryCommand.*\)', '\1', '')
    elseif match(name, '.handle') >= 0
      let foldtext = 'Handler:  ' . substitute(name, '.*\(handle.*\)', '\1', '')
    endif

    " Formats and outputs the result
    let foldtext = '    ' . foldtext
    let linecount = ' (' . foldsize . ' lines)'
    let spaceamount = 80 - strlen(foldtext) - strlen(linecount)
    return foldtext . repeat(' ', spaceamount) . linecount . repeat(' ', 100)
  endfunction

  " Set the foldmethod to the custom one above
  setlocal foldmethod=expr
  setlocal foldexpr=CEFolds()
  setlocal foldtext=CEFoldText()

endfunction
autocmd BufNewFile,BufRead $HOME/Programs/uno/*.js call CommonEditor()
