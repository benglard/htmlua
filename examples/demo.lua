local h = require '..'

local x = 5
local names = {'lua', 'python', 'javascript'}

print(
   doctype 'html' ..
   h.html {
      lang="en",
      h.head {
         h.link { href="" },
         h.script { type="text/javascript", src="" },
      },
      h.body {
         h.h1 "HELLO",
         h.div {
            h.p "Hey",
            h.img {
               src="",
               width="100",
               height="100"
            },
            h.br, h.br, h.nbsp, h.copy,
            h.p {
               id="words",
               class="words",
               "blah blah blah"  
            },
            h.h6 "yo"
         },

         h.script {
            type="text/javascript",
            [[(function() {
               var i = 10;
               console.log(i);
            })();]]
         },
         h.script [[console.log('yo');]],
         
         render(function()
            local rv = ''
            for _, name in pairs(names) do
               rv = rv .. h.li(name)
            end
            return h.ul(rv)
         end),
         h.ul(each(names, h.li)),
         h.ul(
            loop{1, 2, 3, 'test', key=5}(function(k, v)
               return h.li(v)
            end)
         ),

         -- Lua comments work
         --[[
            Multi-line
            too
         ]]

         h.p[[LONG,
            LONG,
            LONG,
            STRING]],
         h.p(x),
         h.p(true),
         h.p{1, 2, 3, true},
         h.p '${name} is cool' % {name='htmlua'},
         h.div '<p>yo</p>',
         
         comment "test comment",
         comment {
            h.p "p",
            h.div {
               h.h3 "h3"
            }
         },

         IF {
            x == 5,
            THEN(h.p "x == 5"),
            ELSE(function() return h.p "x ~= 5" end)
         },

         h.div {
            h.span "hello", h.lt, h.nbsp, h.gt, h.span "hello2"
         }
      }
   }
)