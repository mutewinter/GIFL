nnoremap <silent><leader>gifl :set operatorfunc=<SID>LuckyOperator<cr>g@
vnoremap <silent><leader>gifl :<c-u>call <SID>LuckyOperator(visualmode())<cr>

function! s:GetLuckyFormat(term) " {{{1
  let l:url = s:GetLuckyUrl(a:term, 0)
  if g:LuckyOutputFormat ==# 'markdown'
    return '[' . a:term . '](' . l:url . ')'
  elseif g:LuckyOutputFormat ==# 'html'
    return '<a href=' . l:url . '>' . a:term . '</a>'
  else
    return '[' . a:term . '](' . l:url . ')'
  endif
endfunction
" }}}1

function! s:LuckyOperator(type) " {{{1
  if !has('ruby')
    echo("GIFL is not operational since it was not compiled with a Ruby interpreter (+ruby)")
    return 0
  endif

  let l:saved_unnamed_register = @@

  " {{{ 2
  if a:type ==# 'v'
      normal! `<v`>y
  elseif a:type ==# 'char'
      normal! `[v`]y
  else
      return
  endif
  " }}}2

  let l:searchTerm = @@
  let l:formattedResult = s:GetLuckyFormat(l:searchTerm)

  " {{{ 2
  if a:type ==# 'v'
      normal! `<v`>c
  elseif a:type ==# 'char'
      normal! `[v`]c
  else
      return
  endif
  let @@ = l:formattedResult
  normal! p
  let @@ = l:saved_unnamed_register
endfunction
" }}} 2
" }}} 1

function! s:GetLuckyUrl(...) " {{{1
  let l:term = a:1
  let l:debug = a:2

  if l:debug
    echo l:term . ' and ' . l:debug . ' were passed in.'
  endif

  " ZOMG, we can embed ruby in vimscript, so excite
ruby<<EOF
 require 'net/http'
 require 'open-uri'
  module GIFL
    def self.getURL
      term = VIM::evaluate("l:term")
      url  = "http://www.google.com/search?q=#{term}&btnI=I'm+Feeling+Lucky"
      result = Net::HTTP.get_response(
                URI.parse(
                  URI.escape(
                    url
               ))).response.to_hash['location'].to_a.first
      if ( VIM::evaluate("l:debug") > 0 )
        VIM::command("echo \"hi world we're curious about: #{term} with #{result}\"")
      end
      return result
    end
  end
  VIM::command("let l:result = \"#{GIFL::getURL}\"")
EOF
  if l:debug
    echo l:result . ' was the result.'
  endif
  return l:result
endfunction
" }}}1
