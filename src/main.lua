function love.load(args)
	math.randomseed(os.time())
	--dungeon = require("dungeon")

	--player = thePlayer.new()
	--player.img = love.graphics.newImage("image/kingflanyoda.png")
	
	love.generate()
end

function love.update(dt)
end

function love.generate()
end

function love.draw()
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