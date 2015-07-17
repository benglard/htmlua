local base = extends 'examples/basetemp.lua'
return block(base, 'content'){
   h.ul(each([[${users}]], h.li)),
   defblock 'content2'
}
