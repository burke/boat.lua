local dir = ngx.var.dir

local board = ngx.shared.board

local width = 8
local height = 8

function dfetch(key, default)
  local val = board:get(key)
  if val == nil then
    val = default
    board:set(key, val)
  end
  return val
end

function dput(key, val)
  board:set(key, val)
end

local rows = {
  dfetch("r1", string.rep(".", width)),
  dfetch("r2", string.rep(".", width)),
  dfetch("r3", string.rep(".", width)),
  dfetch("r4", string.rep(".", width)),
  dfetch("r5", string.rep(".", width)),
  dfetch("r6", string.rep(".", width)),
  dfetch("r7", string.rep(".", width)),
  dfetch("r8", string.rep(".", width))
}

local x = dfetch("x", 1)
local y = dfetch("y", 1)

if dir == "right" then
  x = x + 1
  if x > width then
    x = width
  end
end

if dir == "left" then
  x = x - 1
  if x < 1 then
    x = 1
  end
end

if dir == "down" then
  y = y + 1
  if y > height then
    y = height
  end
end

if dir == "up" then
  y = y - 1
  if y < 1 then
    y = 1
  end
end

dput("x", x)
dput("y", y)

rows[y] = string.sub(rows[y],1,x-1) .. '#' .. string.sub(rows[y],x+1,-1)
dput("r"..tostring(y), rows[y])
rows[y] = string.sub(rows[y],1,x-1) .. '@' .. string.sub(rows[y],x+1,-1)

ngx.say("<pre>")
for _, r in ipairs(rows) do
  ngx.say(r)
end
ngx.say("</pre>")

ngx.say([[
<a href="/left">left</a>
<a href="/right">right</a>
<a href="/up">up</a>
<a href="/down">down</a>
]])
