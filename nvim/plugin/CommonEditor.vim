"                         Common-Editor Settings
"                         ----------------------
function! CommonEditor()
  " General setting changes
  " syntax match Ignore /.*editor-fold.*/     " Makes line nearly invisible
  " Adds a semicolon after the current line; moves cursor back
  nnoremap a; mxA;<Esc>`x;

  let s:inEditorFold = 0

  " Returns 1 if in an <editor-fold>, otherwise 0
  function! CEInEditorFold(currentLineNum)
    return s:inEditorFold
  endfunction

  " Returns the next line that has a function declaration (only = syntax)
  function! CEFindNextFunction(currentLineNum)
    let numlines = line('$')
    let current = a:currentLineNum

    while current <= numlines
      if match(getline(current), '= function(') >= 0
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

    if match(thisline, '<\/editor-fold') >= 0
      let s:inEditorFold = 0
    endif

    if match(thisline, '<editor-fold') >= 0
      let s:inEditorFold = 1
      return ">1"
    elseif match(thisline, '^    \/\*\*$') >= 0
      return CEInEditorFold(v:lnum) ? ">2" : ">1"
    elseif match(thisline, '= function(') >= 0 && match(prevline, '^\s*\*\/$') < 0
      return CEInEditorFold(v:lnum) ? ">2" : ">1"
    elseif match(thisline, 'commands\[[''"].* =') >= 0
      return CEInEditorFold(v:lnum) ? ">2" : ">1"
    else
      return "="
    endif
  endfunction

  " Fold text function for common-editor
  function! CEFoldText()
    let foldsize = v:foldend - v:foldstart
    let foldtext = getline(v:foldstart)

    if match(foldtext, '<editor-fold') >= 0
      let foldtext = '  Section: ' . substitute(foldtext, '^.*desc="\(.*\)".*', '\1', '')
    elseif match(foldtext, '^    \/\*\*') >= 0
      let nextfn = CEFindNextFunction(v:foldstart)
      let foldtext = '    Function: ' . substitute(nextfn, '^\s*\([^=]*\).*', '\1', '')
    elseif match(foldtext, '= function(') >= 0
      let foldtext = '    Function: ' . substitute(foldtext, '^\s*\([^=]*\).*', '\1', '')
    elseif match(foldtext, 'commands\[[''"].* =') >= 0
      let foldtext = '    Command: ' . substitute(foldtext, '^\s*commands\[[''"]\(.*\)[''"]\] =.*', '\1', '')
    endif

    let linecount = ' (' . foldsize .' lines)'
    let spaceamount = 80 - strlen(foldtext) - strlen(linecount)

    return foldtext . repeat(' ', spaceamount) . linecount . repeat(' ', 100)
  endfunction

  " Set the foldmethod to the custom one above
  setlocal foldmethod=expr
  setlocal foldexpr=CEFolds()
  setlocal foldtext=CEFoldText()

endfunction
autocmd BufNewFile,BufRead $HOME/Programs/common-editor/*.js call CommonEditor()

" Is this hacky? Can we be sure textobj loaded first?
if exists('*textobj#user#plugin')
  " FIXME: don't use the a action for both a and i
  call textobj#user#plugin('ceunittest', {
  \   '-': {
  \     'select-a-function': 'UnitTestA',
  \     'select-a': 'an',
  \     'select-i-function': 'UnitTestA',
  \     'select-i': 'in',
  \   },
  \ })

  function! UnitTestA()
    let testStartString = 'en.test.testWithRTE'

    let linenum = line('.')
    while matchstr(getline(linenum), testStartString) == ''
      let linenum -= 1
      if (linenum <= 1)
        break
      endif
    endwhile

    let startline = linenum
    call setpos('.', [0, startline, 1, 0])
    normal! t(%
    let endline = line('.')
    let endlinelen = strlen(getline(endline))

    return ['V', [0, startline, 1, 0], [0, endline, endlinelen, 0]]
  endfunction
endif

" vim: set ts=2 sw=2 tw=78:
