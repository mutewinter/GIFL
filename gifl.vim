nnoremap <silent><leader>gifl :set operatorfunc=<SID>LuckyOperator<cr>g@
vnoremap <silent><leader>gifl :<c-u>call LuckyOperator(visualmode())<cr>

let g:LuckyOutputFormat="markdown"

function! s:GetLuckyFormat(term)
  let l:url = s:GetLuckyUrl(a:term, 0)
  if g:LuckyOutputFormat ==# 'markdown'
    return '[' . a:term . '](' . l:url . ')'
  elseif g:LuckyOutputFormat ==# 'html'
    return '<a href=' . l:url . '>' . a:term . '</a>'
  endif
endfunction

function! s:LuckyOperator(type)
  let saved_unnamed_register = @@

  if a:type ==# 'v'
      normal! `<v`>y
  elseif a:type ==# 'char'
      normal! `[v`]y
  else
      return
  endif

  let l:searchTerm = @@
  let l:formattedResult = s:GetLuckyFormat(l:searchTerm)

  if a:type ==# 'v'
      normal! `<v`>c
  elseif a:type ==# 'char'
      normal! `[v`]c
  else
      return
  endif
  let @@ = l:formattedResult
  echom @@
  normal! p
  let @@ = saved_unnamed_register
endfunction

function! s:GetLuckyUrl(...)
  let l:term = a:1
  let l:debug = a:2

  let   url='%q{' . substitute(join(['http://www.google.com/search?q=',
                            \ term,
                            \ "&btnI=I",
                            \ "'",
                            \ "m+Feeling+Lucky"], ''), ' ', '', 'g') . '}'
  if l:debug
    echom "DEBUG: Url for search is: " . url
  endif

  let rubysline=substitute("Net::HTTP.get_response(URI.parse" .
               \"(URI.escape(" .
               \ url . 
               \"))).response.to_hash['location'].to_a.first", " ", '', 'g')

  if l:debug
    echom "DEBUG: Ruby command is: " .  rubysline
  endif

  let line=join(['ruby ',
                 \ "-r 'net/http' ",
                 \ "-r 'open-uri' ",
                 \ '-e "puts ',
                 \ rubysline,
                 \ '"'],'')
  let result=system(line)

  if l:debug
    echom "DEBUG: Result is: " . rubysline
  endif

  let saved_unnamed_register = @@
  return substitute(result, "\n", '', 'g')
endfunction
