io.stdout:setvbuf("no")
local Point     = require "point"
local Line      = require "line"
local Rectangle = require "rectangle"
local Polygon   = require "polygon"
local Sorter    = require "sorter"
local Movable   = require "movable"
local white = {255,255,255,255}
local black = {0,0,0,255}
local red   = {255,0,0,255}

local rawtype = type
function type(var)
	if rawtype(var) == "table" then
		return var.__type or "table"
	else
		return rawtype(var)
	end
end

local function generate()
	local maxx, maxy = love.graphics.getDimensions()
	local sorter = Sorter()
	for i=1, 100 do
		local width  = math.random(20, maxx*0.10)
		local height = math.random(0.2, 1)*width
		if math.random(1,10) > 5 then
			width, height = height, width
		end
		local x = math.random(0, maxx-width-10)
		local y = math.random(0, maxy-height-10)
		local r,g,b = math.random(0,255),math.random(0,255),math.random(0,255)
		if (r+g+b) > 612 then
			r,g,b = 0.8*r, 0.8*g, 0.8*b
		end
		local color = {r,g,b}
		local shape = Movable(Rectangle(x, y, width, height))
		shape.color = color
		sorter:addShape(shape)
	end

	return sorter
end

function love.load()
	math.randomseed(os.time())
	love.window.setMode(900, 900, {vsync=false, centered=true})
	love.graphics.setBackgroundColor(white)
	love.graphics.setLineWidth(0.5)
	if true then
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
		r2 = Rectangle(50, 400, 150, 100)
	end

	return true
end

function love.update(dt)
	if sorter then
		for i,v in pairs(sorter.shapes) do
			v:updatePos(dt)
		end
	end

	for i,key in pairs({"down", "up", "left", "right"}) do
		if love.keyboard.isDown(key) then
			-- si objet contient une méthode du nom de la clé
			if type(r1[key]) == "function" then
				-- on l'appelle. 
				-- code équivalent à `r1:key(speed*dt)`
				r1[key](r1, 500*dt)
			end
		end
	end
end

local bascule
function love.draw()
	if false then
			love.graphics.setColor(black)
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
			r2:draw()
	end

	local height = love.graphics.getHeight()
	love.graphics.translate(0, height)
	love.graphics.rotate(-math.pi/2)
	if sorter then
		for i,v in pairs(sorter.shapes) do
			love.graphics.setColor(v.color)
			v:draw()
		end
	end

	if r1:collide(r2) and not bascule then
		print("collision")
		bascule = true
	elseif not r1:collide(r2) and bascule then
		print("pas collision")
		bascule = false
	end
end

function love.keypressed(key, scancode, isrepeat)
	if key == "space" then
		if not toggle or toggle == 0 then
			sorter = generate()
			toggle = 1
		elseif toggle == 1 then
			sorter:sort()
			toggle = 2
		elseif toggle == 2 then
			sorter:compact()
			toggle = 0
		end
	elseif key == "k" then
		local v = sorter:findBottomLeft()
		v.color = v.color == black and red or black
	end
end