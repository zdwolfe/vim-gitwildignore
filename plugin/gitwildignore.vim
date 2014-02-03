" gitwildignore - Vundle plugin for appendng files in .gitignore to wildignore
" Maintainer: Zach Wolfe <zdwolfe.github.io>
" Version 0.0.1
" Inspired by Adam Bellaire's gitignore script

if exists('g:loaded_gitwildignore')
  finish
endif
let g:loaded_gitwildignnore = 1
let importants = []

" Return a list of file patterns we want to ignore in the gitignore
" file parameter
function! Get_file_patterns(gitignore)
  let l:gitignore = fnamemodify(a:gitignore, ':p')
  let l:path = fnamemodify( a:gitignore, ':p:h')

  let l:file_patterns = []
  if filereadable(l:gitignore)
    " Parse each line according to http://git-scm.com/docs/gitignore
    " See PATTERN FORMAT
    for line in readfile(l:gitignore)
      let l:file_pattern = ''
      if or(line =~ '^#', line == '')
        continue
      elseif line =~ '^!'
        " lines beginning with '!' are 'important' files and should be
        " included even if they were previously ignored
        " currently unimplemented
        let importants += l:path . '/' . line
      elseif (line =~ '/$')
        let l:directory = substitute(line, '/$', '', '')
        let l:file_pattern = '*/' . l:directory . '/*'
      else 
        let l:file_pattern = line
      endif
      let l:file_patterns += [ l:file_pattern ]
    endfor
  endif
  return l:file_patterns
endfunction


let gitignore_files = split(globpath('**', '\.gitignore'), '\n')

let wildignore_file_patterns = []
for gitignore_file in gitignore_files
  let wildignore_file_patterns += Get_file_patterns(gitignore_file)
endfor

let execthis = "set wildignore+=" . join(wildignore_file_patterns, ',')
execute execthis
