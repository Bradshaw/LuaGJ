function love.load(args)
	math.randomseed(os.time())
	dungeon = require("dungeon")
	tile = require("tile")

	timer = 0

	tileSize = 20

	--player = thePlayer.new()
	--player.img = love.graphics.newImage("image/kingflanyoda.png")
	
	love.generate()
end

function love.update(dt)
	time = love.timer.getDelta()
	timer = timer +time
end

function love.generate()
	d = dungeon.new()
	d:generate()
end

function love.draw()
	for i=1,d.w do
		for j=1,d.h do
			if d:getTile(i,j).id==tile.id.floor then
				love.graphics.setColor(255, 255, 255)
			elseif d:getTile(i,j).id==tile.id.wall then
				love.graphics.setColor(0, 0, 0)
			end
			love.graphics.rectangle("fill", i*tileSize, j*tileSize, tileSize, tileSize)
		end
	end
	--love.graphics.setColor(255, 255, 255)
	--love.graphics.draw(player.img, player.x*tileSize, player.y*tileSize)
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