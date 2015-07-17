-- Base library
local html = {}

local tags = {
   'a', 'abbr', 'acronym', 'address', 'area', 'b', 'base', 'bdo', 'big',
   'blockquote', 'body', 'br', 'button', 'caption', 'cite', 'code', 'col',
   'colgroup', 'dd', 'del', 'dfn', 'div', 'dl', 'DOCTYPE', 'dt', 'em',
   'fieldset', 'form', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'head',
   'html', 'hr', 'i', 'img', 'input', 'ins', 'kbd', 'label', 'legend',
   'li', 'link', 'map', 'meta', 'noscript', 'object', 'ol', 'optgroup',
   'option', 'p', 'param', 'pre', 'q', 'samp', 'script', 'select',
   'small', 'span', 'strong', 'style', 'sub', 'sup', 'table', 'tbody',
   'td', 'textarea', 'tfoot', 'th', 'thead', 'title', 'tr', 'tt', 'ul', 'var'
}
local only1tags = { img = true, meta = true, link = true, input = true }
local entities = {
   'nbsp', 'lt', 'gt', 'amp', 'cent', 'pound', 'yen', 'euro',
   'copy', 'reg'
}

local function nopt(t)
   local n = 0
   for k, v in pairs(t) do n = n + 1 end
   return n - #t
end

function maketag(tag, options, endtag, comment)
   if endtag == nil then
      endtag = string.format('</%s', tag)
   end
   comment = comment or false
   local cdelim = '>'
   if comment then cdelim = '' end

   if type(options) == 'table' then
      local nops = nopt(options)
      local delim = ' '
      if nops == 0 then delim = '' end
      local rv = string.format('<%s%s', tag, delim)

      delim = ' '
      local n = 1
      local inner = ''
      for name, value in pairs(options) do
         if type(name) == 'string' then
            if n >= nops then delim = '' end
            rv = rv .. string.format('%s="%s"%s', name, value, delim)
            n = n + 1
         elseif type(name) == 'number' then
            inner = inner .. tostring(value)
            n = 1
         else
            error('Invalid argument %s to %s', name, tag)
         end
      end
      if only1tags[tag] then
         return rv .. '>'
      else
         return string.format('%s%s%s%s>', rv, cdelim, inner, endtag)
      end
   elseif type(options) == 'string' then
      return string.format('<%s%s%s%s>', tag, cdelim, options, endtag)
   elseif type(options) == 'number' or type(options) == 'boolean' then
      return maketag(tag, tostring(options))
   else
      local msg = '%s requires input of type table, string, number, or boolean'
      error(string.format(msg, tag))
   end
end

for _, tag in pairs(tags) do
   html[tag] = function(inner)
      return maketag(tag, inner)
   end
end
for _, entity in pairs(entities) do
   html[entity] = '&' .. entity .. ';'
end
html['br'] = '<br>'

function comment(inner)
   return maketag('!--', inner, '--', true)
end

function doctype(inner)
   return string.format('<!DOCTYPE %s>', inner)
end

function render(f)
   assert(type(f) == 'function', 'render requires input of type function')
   return f()
end

-- Loops, conditionals

function each(t, f)
   if type(t) == 'string' then
      t = torch.deserialize(t)
   end

   local rv = {}
   for _, val in pairs(t) do
      table.insert(rv, f(val))
   end
   return rv
end

function loop(t)
   if type(t) == 'string' then
      t = torch.deserialize(t)
   end

   return function(f)
      local rv = {}
      for key, value in pairs(t) do
         table.insert(rv, f(key, value))
      end
      return rv
   end
end

function IF(options)
   local condition = options[1]
   local truth = condition
   if type(condition) == 'function' then
      truth = condition()
   end

   if truth then
      return options[2]
   else
      return options[3]
   end
end

local function _baseconditional(inner)
   if type(inner) == 'function' then
      return inner()
   else
      return inner
   end
end

THEN = _baseconditional
ELSE = _baseconditional

-- Blocks, for building template inheritance

local blocks = {}

function defblock(name)
   assert(type(name) == 'string', 'defblock requires input of type string')
   blocks[name] = true
   return string.format('${block-%s}', name)
end

function block(base, name)
   assert(type(base) == 'string' and type(name) == 'string',
      'block requires input of type string and string')
   if blocks[name] then
      return function(inner)
         if type(inner) == 'table' then
            inner = table.concat(inner, '')
         end
         assert(type(inner) == 'string',
            'block closure requires input of type string or table')
         return base % {
            [string.format('block-%s', name)] = inner
         }
      end
   else
      error(string.format(
         'No Block defined with name "%s". Call defblock first.', name))
   end
end

function extends(path)
   assert(type(path) == 'string', 'extends requires input of type string')
   return dofile(path)
end

-- Override string.__mod for easy variable rendering

getmetatable('').__mod = function(str, tab)
   -- http://lua-users.org/wiki/StringInterpolation
   -- ex: print('${name} is ${value}' % {name='foo', value='bar'})
   return (str:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end))
end

return html