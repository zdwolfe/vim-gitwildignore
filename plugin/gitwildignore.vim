" gitwildignore - Vundle plugin for appendng files in .gitignore to wildignore
" Maintainer: Zach Wolfe <zdwolfe.github.io>
" Version 0.0.1
" Inspired by Adam Bellaire's gitignore script
"

if exists('g:loaded_gitwildignore')
  finish
endif
let g:loaded_gitwildignnore = 1
let g:gitwildignore_importants = []

let g:gitwildignore_gitignores = split(globpath('**', '\.gitignore'), '\n')

" Return a list of files we wish to ignore
function! s:get_ignores(gitignore)
  let l:path = fnamemodify( a:gitignore, ':p:h')

  if filereadable(a:gitignore)
    let l:ignored_files = []
    " Parse each line according to http://git-scm.com/docs/gitignore
    " See PATTERN FORMAT
    for line in readfile(a:gitignore)
      if or(line =~ '^#', line == '')
        continue
      elseif line =~ '^!'
        " lines beginning with '!' are 'important' files and should be
        " included even if they were previously ignored
        let g:gitwildignore_importants += line
      elseif (line =~ '/$')
        if isdirectory(substitute(line, '/$', ''))
          " stop
        endif
      endif
    endfor
  endif
endfunction
