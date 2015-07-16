h = require '..'

base = extends 'examples/base.lua'
print(base)

base = block(base, 'content')(h.h1 'content')
print(base)

base = block(base, 'content2') {
   h.div {
      h.p 'content2'
   }
}
print(base)