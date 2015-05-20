function love.load(args)
	math.randomseed(os.time())
	dungeon = require("dungeon")
	tile = require("tile")

	tileSize = 40

	--player = thePlayer.new()
	--player.img = love.graphics.newImage("image/kingflanyoda.png")
	
	love.generate()
end

function love.update(dt)
	timer = timer + dt
end

function love.generate()
	timer = 0
	d = dungeon.new()
	d:generate()
end

function love.draw()
	for i=1,d.w do
		for j=1,d.h do
			--if d:getTile(i,j).id==tile.id.wall then
				love.graphics.setColor(125, 255, 125)
				love.graphics.rectangle("fill", i*tileSize, j*tileSize, tileSize, tileSize)
			--end
		end
	end
	for i=1,d.w do
		for j=1,d.h do
			if d:getTile(i,j).id==tile.id.floor then
				--[[
				love.graphics.setColor(95, 7, 7)
				love.graphics.rectangle("fill", i*tileSize - 2, j*tileSize, 2, tileSize)
				love.graphics.rectangle("fill", i*tileSize- 2 , j*tileSize, 2, tileSize)
				--]]--
				love.graphics.setColor(150, 150, 150)
				love.graphics.rectangle("fill", i*tileSize, j*tileSize, tileSize, tileSize)
				love.graphics.setColor(255, 0, 0)
				--love.graphics.print(i .. " " .. j, i*tileSize, j*tileSize)
			end
		end
	end
	love.graphics.setColor(255, 0, 0)
	love.graphics.print(love.round(timer, 2), d.xsize*tileSize, d.ysize*tileSize)
	--love.graphics.setColor(255, 255, 255)
	--love.graphics.draw(player.img, player.x*tileSize, player.y*tileSize)
end

function love.round(number, amount)
	local num = number * math.pow( 10, amount )
	num = math.floor(num)
	num = num / math.pow( 10, amount )
	return num
end

function love.keypressed(key)
	if key == "escape" then
		love.event.push("quit")
	elseif key == " " then
		love.generate()
	elseif key == "left" then
	elseif key == "right" then
	elseif key == "up" then
	elseif key == "down" then
	end
end