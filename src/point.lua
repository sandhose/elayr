local Object = require "classic"

local Point = Object:extend()

function Point:new(x, y)
	if x and y then
		self.x = x
		self.y = y
		return self
	else
		return nil
	end
end

function Point:explode()
	return x, y
end

function Point:draw()
	return love.graphics.circle("fill", self.x, self.y, 3, 4)
end

return Point