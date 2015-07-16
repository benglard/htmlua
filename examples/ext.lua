require '..'

base = extends 'examples/base.lua'
print(base)

base = block(base, 'content')(h1 'content')
print(base)

base = block(base, 'content2') {
   div {
      p 'content2'
   }
}
print(base)