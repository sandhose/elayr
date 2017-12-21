local Object = require "classic"
local Sorter = Object:extend()

function getval(obj, method)
	if type(obj[method]) == "function" then
		return obj[method](obj)
	else
		return obj[method]
	end
end

function objectPartition(t, min, max, key)
	local x = getval(t[max], key)
	local i = min - 1
	for j = min, max - 1 do
		if getval(t[j], key) <= x then
			i = i + 1

			-- Swap
			t[i], t[j] = t[j], t[i]
		end
	end
	
	-- Swap
	t[i+1], t[max] = t[max], t[i+1]

	return i + 1
end

function objectQuicksort_rec(t, min, max, key)
	if min < max then
		q = objectPartition(t, min, max, key)
		objectQuicksort_rec(t, min, q - 1, key)
		objectQuicksort_rec(t, q + 1, max, key)
	end
end

function objectQuicksort(t, sortOnKey)
	return objectQuicksort_rec(t, 1, #t, sortOnKey)
end

function Sorter:new()
	self.shapes = {}
	return self
end

function Sorter:addShape(s)
	table.insert(self.shapes, s)
	return self
end

function Sorter:compact()
	local t = {}
	objectQuicksort(self.shapes, "getArea")

	local maxx, maxy = love.graphics.getDimensions()
	local border = 10
	local yoffset = 0
	maxx, maxy = maxx-2*border, maxy-2*border

	local last = {x=0, y=border, width=0}
	for i=#self.shapes, 1, -1 do
		-- current = self.shapes[i]
		-- last    = self.shapes[i+1] or {newx=0, newy=border, width=0, height=0}
-- 
		-- current.oldx = current.x
		-- current.oldy = current.y
		-- current.newx = last.newx + last.width + border
		-- current.newy = last.newy
		-- yoffset = math.max(yoffset, last.height)
-- 
		-- if current.newx+current.width > maxx then
		-- 	current.newx = border
		-- 	current.newy = current.newy + yoffset + border
		-- 	yoffset = 0
		-- end

		-- current.x = current.newx
		-- current.y = current.newy

		local shape = self.shapes[i]
		local current = {}
		current.x = last.x + last.width + border
		current.y = last.y
		current.width = shape.width

		if current.x + current.width > maxx then
			current.x = border
			current.y = last.y + yoffset + border
			yoffset = 0
		end

		yoffset = math.max(yoffset, shape.height)
		shape:moveTo(current.x, current.y)
		last = current
	end
end

return Sorter