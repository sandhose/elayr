local Object = require "classic"
local Sorter = Object:extend()
local border = 10

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

function Sorter:sort()
	local t = {}
	objectQuicksort(self.shapes, "getArea")

	local maxx, maxy = love.graphics.getDimensions()
	local yoffset = 0
	maxx, maxy = maxx-2*border, maxy-2*border

	local last = {x=0, y=border, width=0}
	for i=#self.shapes, 1, -1 do
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
		shape:moveTo(current.x, current.y, 2)
		last = current
	end
end

local function findBottomRight(sorted)
	local match
	local max = 0
	local height = love.graphics.getHeight()
	local width  = love.graphics.getWidth()
	for i,v in pairs(sorted) do
		local add = v.newx + v.newy
		if add > max then
			match = v
			max = add
		end
	end
	return match
end

local function findBottomLeft(sorted)
	local match
	local max = -math.huge
	local height = love.graphics.getHeight()
	local width  = love.graphics.getWidth()
	for i,v in pairs(sorted) do
		local add = -v.newx + v.newy
		if add > max then
			match = v
			max = add
		end
	end
	return match
end

local function findSpotNextTo(neighbor, shape)
	local width, height = love.graphics.getDimensions()
	
	if neighbor.newx + neighbor.width + border + shape.width < width then
		return (neighbor.newx + neighbor.width + border), neighbor.newy
	else
		return nil
	end
end

local function findSpotUnder(neighbor, shape)
	return neighbor.newx, (neighbor.newy + neighbor.height + border)
end

local function findSpot(sorted, shape)
	local width, height = love.graphics.getDimensions()
	local neighbor = findBottomRight(sorted)

	local x, y
	for i,v in pairs(sorted) do
		x, y = findSpotNextTo(v, shape)
		if x and y then 
			shape:move(x, y)
			if not shape:collide(sorted) then
				return x,y 
			end
		end
	end

	local bottomLeft = findBottomLeft(sorted, shape)
	return findSpotUnder(bottomLeft)
end

function Sorter:compact()
	objectQuicksort(self.shapes, "getArea")
	
	local sorted = {}
	self.shapes[#self.shapes]:moveTo(border, border)
	table.insert(sorted, self.shapes[#self.shapes])

	for i=#self.shapes-1, 1, -1 do
		local shape = self.shapes[i]
		local x, y = findSpot(sorted, shape)
		shape:moveTo(x, y)
		table.insert(sorted, shape)
	end
end

return Sorter