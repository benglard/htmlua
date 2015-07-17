local base = extends 'examples/midtemp.lua'
return block(base, 'content2'){
   h.div {
      h.p {
         h.b 'Time: ',
         h.i '${time}'
      }
   }
}