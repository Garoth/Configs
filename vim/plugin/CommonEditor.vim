"                         Common-Editor Settings
"                         ----------------------
function! CommonEditor()
  " General setting changes
  " syntax match Ignore /.*editor-fold.*/     " Makes line nearly invisible
  " Adds a semicolon after the current line; moves cursor back
  nnoremap a; mxA;<Esc>`x;
  " Changes which files ctrlp will find; use git for high speed
  let s:git_ls_files_command = 'git ls-files "css/*.less" js tests "*.md" "*.py" "*.sh"'
  let g:ctrlp_user_command = {
      \ 'types': {
          \ 1: ['.git', 'cd %s && ' . s:git_ls_files_command],
          \ 2: ['.hg', 'hg --cwd %s locate -I .'],
          \ },
      \ 'fallback': 'find %s -type f'
      \ }

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

  " Automatic opening and closing of folds based on cursor location
  " setlocal foldopen=all
  " setlocal foldclose=all
endfunction
autocmd BufNewFile,BufRead $HOME/Programs/common-editor/*.js call CommonEditor()

" Takes the result of 'copy html' of the <head> in rte-test-creator and makes
" an exports list suitable for the mac project
function! MakeExportsList()
  " Delete all of the stuff that isn't script tags
  norm 17ddGV22kxgg2dt<
  " Replace ending script tags with newlines
  %s;</script>;\r;g
  " Strip out everything except for the script paths
  %s;<script.*"file\(.*\)">;\1;g
  " Fix up the script paths to be what we expect
  %norm df.xi@"A",
  " Final cleanup of whitespace and stuff
  norm ddddggddG$x
  " Add in a couple more that are always on top
  norm ggO@"/goog/base.js",
  norm o@"/base.js",
endfunction

" vim: set ts=2 sw=2 tw=78:
