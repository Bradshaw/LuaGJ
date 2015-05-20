function love.load(args)
	math.randomseed(os.time())
	dungeon = require("dungeon")
	useful = require("useful")
	player = require("player")
	tile = require("tile")

	tileSize = 32
	coolDownMove = 0
	coolDownMoveMax = 0.1
	delta = 0

	floor = love.graphics.newImage("asset/graph/floor.png")
	wall = love.graphics.newImage("asset/graph/castlewall.jpg")
	enter = love.graphics.newImage("asset/graph/green-flag.png")
	exit = love.graphics.newImage("asset/graph/flag_red.png")
	chronoBoost = love.graphics.newImage("asset/graph/chronoBoost.png")

	--player = thePlayer.new()
	src1 = love.audio.newSource("asset/sound/BGM.mp3")

	src1:setVolume(1)

	src1:play()
	
	love.generate()
end

function love.update(dt)
	timer.time = timer.time + dt

	if coolDownMove > 0 then
		coolDownMove = coolDownMove - dt
	else
	    coolDownMove = 0
	end

	left = love.keyboard.isDown( "left", "q" )
	up = love.keyboard.isDown( "up", "z" )
	right = love.keyboard.isDown( "right", "d" )
	down = love.keyboard.isDown( "down", "s" )


	if coolDownMove == 0 then
	    if left and d:getTile(p.x - 1, p.y).id ~= tile.id.wall then
			p.x = p.x - 1
			coolDownMove = coolDownMoveMax
		elseif right and d:getTile(p.x + 1, p.y).id ~= tile.id.wall then
			p.x = p.x + 1
			coolDownMove = coolDownMoveMax
		elseif up and d:getTile(p.x, p.y - 1).id ~= tile.id.wall then
			p.y = p.y - 1
			coolDownMove = coolDownMoveMax
		elseif down and d:getTile(p.x, p.y + 1).id ~= tile.id.wall then
			p.y = p.y + 1
			coolDownMove = coolDownMoveMax
			print( "bas" )
		end
	end

	if love.onChrono() then
		chrono = love.getChrono(p.x, p.y)
		timer.time = timer.time - chrono.time
		love.removeChrono(chrono)
	end

	if d:getTile(p.x, p.y).id == tile.id.exit then
	    love.win()
	end

end

function love.generate(x)
	if x then
		timer.color = {r = timer.color.r + 15, g = timer.color.g + 15, b = timer.color.b + 15}
	else
		timer = { time = 0, color = {r = 15, g = 105, b = 230}}
	end

	d = dungeon.new()
	pos = d:generate(x)
	chrono = d:getChronos()
	player.img = love.graphics.newImage("asset/graph/Player.png")
	p = player.new(pos.x, pos.y, 5)
end

function love.draw()
	love.graphics.reset( )
	for i=1,d.w do
		for j=1,d.h do
			if d:getTile(i,j).id==tile.id.floor then
				love.graphics.draw(floor, i*tileSize, j*tileSize)
			elseif d:getTile(i,j).id==tile.id.wall then
				love.graphics.draw(wall, i*tileSize, j*tileSize)
			elseif d:getTile(i,j).id==tile.id.enter then
				love.graphics.draw(floor, i*tileSize, j*tileSize)
				love.graphics.draw(enter, i*tileSize, j*tileSize)
			elseif d:getTile(i,j).id==tile.id.exit then
				love.graphics.draw(floor, i*tileSize, j*tileSize)
				love.graphics.draw(exit, i*tileSize, j*tileSize)
			end
		end
	end
	for _,v in ipairs(chrono) do
		love.graphics.draw(chronoBoost, v.x * tileSize, v.y * tileSize)
	end
	love.graphics.draw(player.img, p.x * tileSize + player.img:getWidth() / 2, p.y * tileSize + player.img:getHeight() / 2)
	love.graphics.setColor(timer.color.r, timer.color.g, timer.color.b)
	love.graphics.print(love.round(timer.time, 2), d.xsize*tileSize, d.ysize*tileSize, 0, 5, 5)
end

function love.round(number, amount)
	local num = number * math.pow( 10, amount )
	num = math.floor(num)
	num = num / math.pow( 10, amount )
	return num
end

function love.win()
	love.generate(p.x)
end

function love.onChrono()
	for _,v in ipairs(chrono) do
		if v.x == p.x and v.y == p.y then
			return true
		end
	end
	return false
end

function love.getChrono(x, y)
	for _,v in ipairs(chrono) do
		if v.x == x and v.y == y then
			return v
		end
	end
end

function love.removeChrono(chro)
	table.remove( chrono, chro.index )
end

function love.keypressed(key)
	if key == "escape" then
		love.event.push("quit")
	elseif key == " " then
		love.generate()
	--[[elseif key == "left" and d:getTile(love.round(p.x - p.speed * delta, 0),love.round(p.y, 0)).id ~= tile.id.wall then
		p.x = p.x - p.speed * delta
	elseif key == "right" and d:getTile(love.round(p.x + player.img:getWidth() + p.speed * delta, 0),love.round(p.y, 0)).id ~= tile.id.wall then
		p.x = p.x + p.speed * delta
	elseif key == "up" and d:getTile(love.round(p.x, 0),love.round(p.y - p.speed * delta, 0)).id ~= tile.id.wall then
		p.y = p.y - p.speed * delta
	elseif key == "down" and d:getTile(love.round(p.x, 0),love.round(p.y + player.img:getHeight() + p.speed * delta, 0)).id ~= tile.id.wall then
		p.y = p.y + p.speed * delta]]
	end
end

function love.tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end