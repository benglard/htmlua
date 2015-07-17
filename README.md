# htmlua - Lua HTML templater

One of my favorite features in the Lua language is a piece of syntactic sugar: Lua lets you remove parentheses when calling functions with a single table or string argument, e.g.

```lua
require 'torch'
print{1, 2, 3}
```

I have used this elegant feature to build libraries such as [luaclass](https://github.com/benglard/luaclass) and [luaimport](https://github.com/benglard/luaimport).

htmlua takes advantage of this syntactic sugar to build a pure-lua HMTL templating engine. This project is now integrated into [waffle](https://github.com/benglard/waffle).

## Example Usage

```lua
local html = require 'htmlua'
return html.html {
   html.head {
      html.title "Title"
   },
   html.body {
      html.p "yo",
      html.img {
         src="https://www.google.com/images/srpr/logo11w.png"
      }
   }
}
```

renders as

```html
<html><head><title>Title</title></head><body><p>yo</p><img src="https://www.google.com/images/srpr/logo11w.png"></body></html>
```

Amazingly, there is no compiler, no 3rd-party language, that's pure lua! That means that all of your typical lua language structure, libraries, variables, etc. can be used seamlessly. But I've built some helpers in too:

## Conditionals

```lua
local x = 5
IF {
   x == 5,
   THEN(h.p "x == 5"),
   ELSE(h.p "x ~= 5")
}
```

```html
<p>x == 5</p>
```

## Loops

Option 1

```lua
DO(function()
   local rv = ''
   for _, name in pairs(names) do
      rv = rv .. h.li(name)
   end
   return h.ul(rv)
end)
```

Option 2

```lua
local names = {'lua', 'python', 'javascript'}
h.ul(each(names, h.li))
```

Both render as:

```html
<ul><li>lua</li><li>python</li><li>javascript</li></ul>
```

Option 3

```lua
h.ul(
   loop{1, 2, 3, 'test', key=5}(function(k, v)
      return h.li(v)
   end)
)
```

```html
<ul><li>1</li><li>2</li><li>3</li><li>test</li><li>5</li></ul>
```

## Comments

```lua
comment "test comment",
comment {
   h.p "p",
   h.div {
      h.h3 "h3"
   }
}
```

```html
<!--test comment--><!--<p>p</p><div><h3>h3</h3></div>-->
```

Note that traditional lua comments can also be put inside an htmlua template, since it's executing pure-lua.

## Blocks

Blocks allow for template inheritance

```lua
-- base.html
return h.html {
   h.head {
      h.title 'Base'
   },
   h.body {
      defblock 'content',
      defblock 'content2',
      h.p 'base'
   }
}
```

```lua
-- ext.lua
h = require 'htmlua'
base = extends 'examples/base.lua'
base = block(base, 'content')(h.h1 'content')
base = block(base, 'content2'){
   h.div {
      h.p 'content2'
   }
}
```

```html
<html><head><title>Base</title></head><body><h1>content</h1><div><p>content2</p></div><p>base</p></body></html>
```

## HTML Entities

HTML entities display reserved characters in HTML, e.g. the non-breaking space, less than, greather than, etc.

```lua
h.div {
   h.span "hello", h.lt, h.nbsp, h.gt, h.span "hello2"
}
```

```html
<div><span>hello</span>&lt;&nbsp;&gt;<span>hello2</span></div>
```

## String Interpolation

```lua
h.p '${name} is cool' % {name='htmlua'}
```

```html
<p>htmlua is cool</p>
```

## Async Rendering (with a larger example)

```lua
-- basetemp.lua
return h.html {
   h.head {
      h.title 'Base'
   },
   h.body {
      defblock 'content',
      h.p '${msg}'
   }
}
```

```lua
-- midtemp.lua
local base = extends 'examples/basetemp.lua'
return block(base, 'content'){
   h.ul(each([[${users}]], h.li)),
   defblock 'content2'
}
```

```lua
-- temp.lua
local base = extends 'examples/midtemp.lua'
return block(base, 'content2'){
   h.div {
      h.p {
         h.b 'Time: ',
         h.i '${time}'
      }
   }
}
```

```lua
local args = {
   msg = 'Hello World',
   users = {'lua', 'python', 'javascript'},
   time = os.time()
}

render('examples/temp.lua', args, print)
```

```html
<html><head><title>Base</title></head><body><ul><li>lua</li><li>python</li><li>javascript</li></ul><div><p><b>Time: </b><i>1437167130</i></p></div><p>Hello World</p></body></html>
```

## htmlua (executable)

The htmlua executable lets you compile and save lua source as html.

```
> htmlua -f examples/test.lua -o out.html
```

## Inspirations

This project takes inspiration from:
* [jade](http://jade-lang.com/)
* [HTMLisp](https://github.com/benglard/HTMLisp)
* [Lapis](http://leafo.net/lapis/reference/html_generation.html)
* [jinja2](http://jinja.pocoo.org/docs/dev/)