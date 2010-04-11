echo "Loaded syntax file"

syn match markdownBullet "\*" contained

hi def link markdownBullet ErrorMsg

let b:current_syntax = "markdown"
