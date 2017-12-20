local Object = require "classic"
local Point  = require "point"
local Line   = require "line"

local Polygon = Object:extend()

function Polygon:new(...)
	local args = {...}
	local j = 1
	self.vertices = {}
	for i=1, #args, 2 do
		self.vertices[j] = Point(args[i], args[i+1])
		j = j+1
	end

	j = 1
	self.edges = {}
	for i=1, #self.vertices-1 do
		self.edges[j] = Line(self.vertices[i], self.vertices[i+1])
		j = j+1
	end
	local i = #self.edges+1
	self.edges[i] = Line(self.vertices[i], self.vertices[1])

	return self
end

function Polygon:draw()
	for i,v in pairs(self.edges) do
		v:draw()
	end
end

return Polygon