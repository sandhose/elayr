local Object = require "classic"
local Line   = require "line"
local Point  = require "point"

local Rectangle = Object:extend()

function Rectangle:new(x, y, width, height)
	self.x = x
	self.y = y
	self.width  = width
	self.height = height

	return self
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
	self.vertices = {}
	self.vertices[1] = Point(self.x, self.y)
	self.vertices[2] = Point(self.x + self.width, self.y)
	self.vertices[3] = Point(self.x + self.width, self.y+self.height)
	self.vertices[4] = Point(self.x, self.y+self.height)

	self.edges = {}
	self.edges[1] = Line(self.vertices[1], self.vertices[2])
	self.edges[2] = Line(self.vertices[2], self.vertices[3])
	self.edges[3] = Line(self.vertices[3], self.vertices[4])
	self.edges[4] = Line(self.vertices[4], self.vertices[1])

	for i,v in pairs(self.edges) do
		v:draw()
	end
end

return Rectangle