require '..'

local x = 5
local names = {'lua', 'python', 'javascript'}

print(
   doctype 'html' ..
   html {
      lang="en",
      head {
         link { href="" },
         script { type="text/javascript", src="" },
      },
      body {
         h1 "HELLO",
         div {
            p "Hey",
            img {
               src="",
               width="100",
               height="100"
            },
            br, br, nbsp, copy,
            p {
               id="words",
               class="words",
               "blah blah blah"  
            },
            h6 "yo"
         },

         script {
            type="text/javascript",
            [[(function() {
               var i = 10;
               console.log(i);
            })();]]
         },
         script [[console.log('yo');]],
         
         render(function()
            local rv = ''
            for _, name in pairs(names) do
               rv = rv .. li(name)
            end
            return ul(rv)
         end),
         ul(map(names, li)),
         ul(
            loop{1, 2, 3, 'test', key=5}(function(k, v)
               return li(v)
            end)
         ),

         -- Lua comments work
         --[[
            Multi-line
            too
         ]]

         p[[LONG,
            LONG,
            LONG,
            STRING]],
         p(x),
         p(true),
         p{1, 2, 3, true},
         p '${name} is cool' % {name='htmlua'},
         div '<p>yo</p>',
         
         comment "test comment",
         comment {
            p "p",
            div {
               h3 "h3"
            }
         },

         IF {
            x == 5,
            THEN(p "x == 5"),
            ELSE(function() return p "x ~= 5" end)
         },

         div {
            span "hello", lt, nbsp, gt, span "hello2"
         }
      }
   }
)