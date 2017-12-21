local Shape = require "shape"
local Point  = require "point"
local Line   = require "line"

local Rectangle = Shape:extend()

function Rectangle:new(x, y, width, height)
	self.shape = "Rectangle"
	self.x = x
	self.y = y
	self.width  = width
	self.height = height

	return self
end

function Rectangle:getVertices()
	self.vertices = {}
	self.vertices[1] = Point(self.x, self.y)
	self.vertices[2] = Point(self.x + self.width, self.y)
	self.vertices[3] = Point(self.x + self.width, self.y+self.height)
	self.vertices[4] = Point(self.x, self.y+self.height)
	return self.vertices
end

function Rectangle:getEdges()
	local vertice = self:getVertices()
	self.edges = {}
	self.edges[1] = Line(vertice[1], vertice[2])
	self.edges[2] = Line(vertice[2], vertice[3])
	self.edges[3] = Line(vertice[3], vertice[4])
	self.edges[4] = Line(vertice[4], vertice[1])
	return self.edges
end

function Rectangle:move(x, y)
	self.x = x
	self.y = y
end

function Rectangle:left(val)
	self.x = self.x - val
end
function Rectangle:right(val)
	self.x = self.x + val
end
function Rectangle:up(val)
	self.y = self.y - val
end
function Rectangle:down(val)
	self.y = self.y + val
end

function Rectangle:draw()
	local edges = self:getEdges()
	for i,v in pairs(edges) do
		v:draw()
	end
end

function Rectangle:getArea()
	return self.width*self.height
end

function Rectangle:collide(shapes, x, y)
	local rect1 = self
	if not shapes then
		print("???")
		return false
	end
	if type(shapes) == "object" then
		shapes = {shapes}
	end

	if not x or not y then
		x = self.x
		y = self.y
	end

	for _,rect2 in pairs(shapes) do
		if (x < rect2.x + rect2.width and
			x + rect1.width > rect2.x and
			y < rect2.y + rect2.height and
			rect1.height + y > rect2.y) then
			return true
		end
	end

	return false
end

return Rectangle