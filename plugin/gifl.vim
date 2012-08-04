nnoremap <silent><leader>ggl :set operatorfunc=<SID>LuckyOperator<cr>g@
vnoremap <silent><leader>ggl :<c-u>call <SID>LuckyOperator(visualmode())<cr>

function! s:GetLuckyFormat(query) " {{{1
  let l:url = s:GetLuckyUrl(a:query, 0)
  if g:LuckyOutputFormat ==# 'markdown'
    return '[' . a:query . '](' . l:url . ')'
  elseif g:LuckyOutputFormat ==# 'html'
    return '<a href=' . l:url . '>' . a:query . '</a>'
  else
    return '[' . a:query . '](' . l:url . ')'
  endif
endfunction
" }}}1

function! s:LuckyOperator(type) " {{{1
  if !has('ruby')
    echo("GIFL is not operational since it was not compiled with a Ruby interpreter (+ruby)")
    return 0
  endif

  let l:saved_register = @p

  " {{{ 2
  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  else
    return
  endif
  " }}}2

  let l:searchQuery = @@
  let l:formattedResult = s:GetLuckyFormat(l:searchQuery)

  " {{{ 2
  if a:type ==# 'v'
    normal! `<v`>c
  elseif a:type ==# 'char'
    normal! `[v`]c
  else
    return
  endif
  let @p = l:formattedResult
  normal! "pp
  let @p = l:saved_register
endfunction
" }}} 2
" }}} 1

function! s:GetLuckyUrl(...) " {{{1
  let l:query = a:1
  let l:debug = a:2

  if l:debug
    echo l:query . ' and ' . l:debug . ' were passed in.'
  endif

  let l:result = s:LuckyUrl(l:query)

  return l:result
endfunction

" Ruby code for querying Google for the I'm Feeling Lucky url of a given
" search query.
ruby<<EOF
  require 'net/http'
  require 'open-uri'

  module GIFL
    def self.get_url(query)
      search_url = "http://www.google.com/search?q=#{query}&btnI=I'm+Feeling+Lucky"
      response = Net::HTTP.get_response URI.parse URI.escape search_url
      url = response.to_hash['location'].first
      VIM::command("let g:lucky_url = '#{url.gsub("'", "\\'")}'")
    end
  end
EOF

" Define the vim function for calling the above Ruby code.
if !exists("*s:LuckyUrl")
  function! s:LuckyUrl(query)
    :ruby GIFL::get_url(VIM::evaluate('a:query'))

    return g:lucky_url
  endfunction
endif
