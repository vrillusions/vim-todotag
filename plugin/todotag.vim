" todotag.vim - format TODO tags with date and owner
"
" This formats a todo line in comments so they have a standard format.
" Inspiration for this came from http://www.approxion.com/?p=39 and pretty
" much emulates that format.
"
" Options:
"   g:todotag_owner - Set to the value for owner part of string. If this
"   is an empty string then the owner part will be omitted. If not specified
"   this will try $USER, $USERNAME, 'ChangeMe'. It's highly recommended you
"   set this as you may be logged in as different users in each system.
"
" Provides:
"   b:todotag_owner_tag - After processing this is the result that will
"   be appended to message. Can be overridden at the buffer level if needed
"
"   GetTodoComment() - Function that returns the current date and owner
"
"   iabbr TODO: - Will print the current date and owner
"
" Installation:
"   - Place this file in ~/.vim/plugins/
"   - Add the following line to your ~/.vimrc
"
"       let g:todotag_owner = 'your_name'
"
" Usage:
"   In insert mode typing something like `# TODO: ` will insert the current
"   date followed by the vale of g:todotag_owner_tag.
"
" Author: Todd Eddy <http://toddeddy.com>
" License: The Unlicense <http://unlicense.org/>
" Version: 0.2.0-dev
"

if exists('g:loaded_todotag') || &cp || v:version < 700
    finish
endif
let g:loaded_todotag = 1

" Uncomment this to echo debug lines. Used by s:Debug()
"let s:do_debug = 'true'

" Will echo the given message if s:do_debug exists
"
" Variables:
"   s:do_debug - Checks if this variable is set. If it doesn't exist nothing
"   is echoed.
"
" Example:
"   call s:Debug('test')
"   >> filename.vim: test
"
function! s:Debug (msg)
    if exists("s:do_debug")
        echom @% . ': ' . a:msg
    endif
endfunction


" Returns a concatenation of timestamp and owner.
"
" Variables:
"   b:todotag_owner_tag - Will be appended to date. Should either end
"   with a semicolon or be empty if no owner specified.
"
" Example:
"   let b:todotag_owner_tag = 'jdoe:'
"   echo GetTodoComment()
"   >> 2013-08-09:jdoe:
"
"   let b:todotag_owner_tag = ''
"   echo GetTodoComment()
"   >> 2013-08-09:
"
function! GetTodoComment ()
    return strftime("%F") . ':' . b:todotag_owner_tag
endfunction


" Set the owner tag based on global variable
if !exists("g:todotag_owner")
    call s:Debug('g:todotag_owner not set')
    if exists("$USER")
        call s:Debug('$USER exists')
        let b:todotag_owner_tag = $USER . ':'
    elseif exists("$USERNAME")
        call s:Debug('$USERNAME exists')
        let b:todotag_owner_tag = $USERNAME . ':'
    else
        call s:Debug('Cant find anything')
        let b:todotag_owner_tag = 'ChangeMe:'
    endif
elseif g:todotag_owner == ''
    call s:Debug('g:todotag_owner set to empty string')
    let b:todotag_owner_tag = ''
else
    call s:Debug('g:todotag_owner is ' . g:todotag_owner)
    let b:todotag_owner_tag = g:todotag_owner . ':'
endif

call s:Debug('b:todotag_owner_tag is "' . b:todotag_owner_tag . '"')


" Set the abbreviations
iab TODO: TODO:<c-r>=GetTodoComment()<CR>
iab NOTE: NOTE:<c-r>=GetTodoComment()<CR>


" vim: set et ts=4 sw=4 sts=4: