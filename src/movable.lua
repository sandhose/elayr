local Object = require "classic"
local Movable = Object:extend()

function Movable:new(shape)
	self.shape = shape
	for i,v in pairs(self.shape) do
		if self[i] == nil then
			self[i] = self.shape[i]
		end
	end

	self.timeElapsed = 0
	self.duration = 2
	self.newx  = self.x
	self.oldx  = self.x
	self.newy  = self.y
	self.oldy  = self.y

	self.tween = function(t)
		return math.sin( (t/2)*math.pi )
	end


	return self
end

function Movable:getArea()
	return self.shape:getArea()
end

function Movable:draw()
	self.shape.x = self.x
	self.shape.y = self.y
	return self.shape:draw()
end

function Movable:moveTo(x, y)
	self.oldx = self.x
	self.oldy = self.y
	self.newx = x
	self.newy = y
	self.travelling = true
end

function Movable:updatePos(dt)
	if not self.travelling then
		return
	end

	if self.timeElapsed >= self.duration then
		self.travelling = false
		return
	end
	self.timeElapsed = self.timeElapsed+dt
	self.completion  = self.timeElapsed / self.duration

	local movx = (self.newx - self.oldx) * self.tween(self.completion)
	local movy = (self.newy - self.oldy) * self.tween(self.completion)
	self.x = self.oldx + movx
	self.y = self.oldy + movy
end

return Movable