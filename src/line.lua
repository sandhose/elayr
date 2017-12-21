local Shape = require "shape"

local Line = Shape:extend()

function Line:new(p1, p2)
	self.shape = "Line"
	self.p1 = p1
	self.p2 = p2

	return self
end

function Line:draw()
	return love.graphics.line(self.p1.x, self.p1.y, self.p2.x, self.p2.y)
end

return Line