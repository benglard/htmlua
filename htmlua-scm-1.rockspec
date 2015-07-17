package = 'htmlua'
version = 'scm-1'

source = {
   url = 'git://github.com/benglard/htmlua',
}

description = {
   summary = 'Lua HTML templater',
   detailed = [[
Thanks to some fun synatic sugar in the Lua language, htmlua lets
you write HTML in a pure Lua DSL.
]],
   homepage = 'https://github.com/benglard/htmlua'
}

dependencies = {
   'torch >= 7.0',
   'async'
}

build = {
   type = 'builtin',
   modules = {
      ['htmlua.init'] = 'init.lua',
   },
   install = {
      bin = {
         'htmlua'
      }
   }
}