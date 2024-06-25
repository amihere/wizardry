command! -nargs=? -complete=file Accio call s:Accio(<f-args>)
command! -nargs=? -complete=file DisableWizardry call s:DisableWizardry()

let s:letters = split('abcdefghijklmnopqrstuvwxyz1234567890-=;,.:<>?"{}[]/''', '\zs')

function! s:Accio(...)
    setlocal noautoindent
    setlocal nosmartindent
    setlocal nosmarttab
    setlocal indentexpr=
    setlocal indentkeys=
    setlocal comments=
    filetype indent off
    let b:wizardry_counter = 0
    if a:0 > 0
        let l:fname = a:1
    else
        let l:fname = "/tmp/wizardry.txt"
    endif
    let b:wizardry_text = s:ReadFile(l:fname)
    call <SID>MapWizard()
endfunction

function! s:MapWizard()
    for l:letter in s:letters
        execute "inoremap <expr> <buffer> " .  l:letter . " <SID>NextCharacter()"
        execute "inoremap <expr> <buffer> " .  toupper(l:letter) . " <SID>NextCharacter()"
    endfor
    inoremap <expr> <buffer> <space> <SID>NextCharacter()
    inoremap <expr> <buffer> <BS> <SID>GoBackWizard()
endfunction

function! s:NextCharacter()
    let l:char = strpart(b:wizardry_text, b:wizardry_counter, 1)
    let b:wizardry_counter += 1
    return l:char
endfunction

function! s:GoBackWizard()
    let b:wizardry_counter -= 1
    return "\b"
endfunction

function! s:DisableWizardry()
    for l:letter in s:letters
        execute "inoremap <buffer>" l:letter l:letter
        execute "inoremap <buffer>" toupper(l:letter) toupper(l:letter)
    endfor
    inoremap <buffer> <space> <space>
    inoremap <buffer> <bs> <bs>
endfunction

function! s:ReadFile(fname)
    let l:lines = readfile(a:fname)
    let l:text = join(l:lines, "\r")
    return l:text
endfunction
