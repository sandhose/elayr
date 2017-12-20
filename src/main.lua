io.stdout:setvbuf("no")
local Point     = require "point"
local Line      = require "line"
local Rectangle = require "rectangle"
local Polygon   = require "polygon"

function love.load()
	local white = {255,255,255,255}
	local red = {255,0,0,255}
	local black = {0,0,0,255}
	love.graphics.setBackgroundColor(white)
	love.graphics.setLineWidth(0.5)
	love.keyboard.setKeyRepeat("up")
	love.keyboard.setKeyRepeat("down")
	love.keyboard.setKeyRepeat("left")
	love.keyboard.setKeyRepeat("right")

	p1 = Point(27.50, 25)
	p2 = Point(27.50, 125)
	p3 = Point(177.5, 25)
	p4 = Point(177.5, 75)
	p5 = Point(77.50, 75)
	p6 = Point(77.50, 125)
	seg1 = Line(p1, p2)
	seg2 = Line(p2, p6)
	seg3 = Line(p6, p5)
	seg4 = Line(p5, p4)
	seg5 = Line(p4, p3)
	seg6 = Line(p3, p1)
	p7 = Point(120.0*5, 30.0*5)
	p8 = Point(110.0*5, 10.0*5)
	p9 = Point(130.0*5, 10.0*5)
	seg7 = Line(p7, p8)
	seg8 = Line(p7, p9)
	seg9 = Line(p8, p9)
	poly = Polygon(100, 100, 200, 100, 150, 200)

	r1 = Rectangle(400, 400, 200, 100)
	print(r1)

	return true
end

function love.draw()
	love.graphics.setColor(0,0,0,255)
	seg1:draw()
	seg2:draw()
	seg3:draw()
	seg4:draw()
	seg5:draw()
	seg6:draw()
	seg7:draw()
	seg8:draw()
	seg9:draw()
	poly:draw()

	r1:draw()
	print(r1.x)
end

function love.keypressed(key, scancode, isrepeat)
	print(key, scancode, isrepeat)
	if type(r1[scancode]) == "function" then
		r1[scancode](r1, 5)
	end
end