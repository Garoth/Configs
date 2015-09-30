function! s:debug()
	let spaces = matchstr(getline("."),'\s*')
	if matchstr(getline("."),".*DEBUG.*") != ""
		let linenum = ": ". line("."). ":"
		let newline = substitute(getline("."),'\: [0-9]*\:',linenum,"")
		normal dd
		-put =newline
	else
		let line = spaces.'print "DEBUG: '. bufname("%"). ': '. line("."). ': "'
		-put =line
	endif
	normal $
endfunction

:command! Debug :call s:debug()
