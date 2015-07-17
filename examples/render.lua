h = require '..'

local args = {
   msg = 'Hello World',
   users = {'lua', 'python', 'javascript'},
   time = os.time()
}

render('examples/temp.lua', args, print)