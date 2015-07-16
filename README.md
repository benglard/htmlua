# htmlua - Lua HTML templater

One of my favorite features in the Lua language is a piece of syntactic sugar: Lua lets you remove parentheses when calling functions with a single table or string argument, e.g.

```lua
require 'torch'
print{1, 2, 3}
```

I have used this elegant feature to build libraries such as [luaclass](https://github.com/benglard/luaclass) and [luaimport](https://github.com/benglard/luaimport).

htmlua takes advantage of this syntactic sugar to build a pure-lua HMTL templating engine. This project will likely soon be integrated into [waffle](https://github.com/benglard/waffle). Note that all of the examples below first require 'htmlua'.

## Example Usage

```lua
return html {
   head {
      title "Title"
   },
   body {
      p "yo",
      img {
         src="https://www.google.com/images/srpr/logo11w.png",
         width="100",
         height="100"
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
   THEN(p "x == 5"),
   ELSE(p "x ~= 5")
}
```

```html
<p>x == 5</p>
```

## Loops

Option 1

```lua
render(function()
   local rv = ''
   for _, name in pairs(names) do
      rv = rv .. li(name)
   end
   return ul(rv)
end)
```

Option 2

```lua
local names = {'lua', 'python', 'javascript'}
ul(map(names, li))
```

Option 3

```lua
ul(
   loop{1, 2, 3, 'test'}(function(item)
      return li(item)
   end)
)
```

All options output:

```html
<ul><li>lua</li><li>python</li><li>javascript</li></ul>
```

## Comments

```lua
comment "test comment",
comment {
   p "p",
   div {
      h3 "h3"
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
return html {
   head {
      title 'Base'
   },
   body {
      defblock 'content',
      defblock 'content2',
      p 'base'
   }
}
```

```lua
-- ext.lua
require 'htmlua'
base = extends 'examples/base.lua'
base = block(base, 'content')(h1 'content')
base = block(base, 'content2'){
   div {
      p 'content2'
   }
}
```

```html
<html><head><title>Base</title></head><body><h1>content</h1><div><p>content2</p></div><p>base</p></body></html>
```

## HTML Entities

HTML entities display reserved characters in HTML, e.g. the non-breaking space, less than, greather than, etc.

```lua
div {
   span "hello", lt, nbsp, gt, span "hello2"
}
```

```html
<div><span>hello</span>&lt;&nbsp;&gt;<span>hello2</span></div>
```

## htmlua (executable)

The htmlua executable lets you compile and save lua source as html. Unfortunately, although htmlua the library does not, htmlua the executable requires [torch](https://github.com/torch/torch7). This dependency should eventually be removed.

```
> htmlua -f examples/test.lua -o out.html
```

## Inspirations

This project takes inspiration from:
* [jade](http://jade-lang.com/)
* [HTMLisp](https://github.com/benglard/HTMLisp)
* [Lapis](http://leafo.net/lapis/reference/html_generation.html)
* [jinja2](http://jinja.pocoo.org/docs/dev/)