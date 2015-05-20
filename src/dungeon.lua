local dungeon_mt = {}
local dungeon = {}
tile = require("tile")
anychrono = require("chrono")

-- melange le tableau --
local shuffle = function(array)
	local s_array = {}
	while #array>0 do
		local i = math.random(1, #array)
		table.insert(s_array, array[i])
		table.remove(array, i)
	end
	return s_array
end

-- CONSTRUCTEUR --
function dungeon.new(options)
	options = options or {}
	local self = setmetatable({}, {__index=dungeon_mt})
	
	self.data = {}

	self.chronos = {}
	self.xsize = options.xsize or 10
	self.ysize = options.ysize or 10
	self.w = self.xsize * 2 +1
	self.h = self.ysize * 2 +1
	
	return self
end

function dungeon_mt:clean()
	for i=1,self.xsize do
		for j=1,self.ysize do
			self:setTile(i, j, tile.new(tile.id.wall, 0))
		end
	end
end

function dungeon_mt:cleanOne()
	local n_list = {
		{x = 1, y = 0},
		{x = -1, y = 0},
		{x = 0, y = 1},
		{x = 0, y = -1}
	}
	for i=1,self.xsize do
		for j=1,self.ysize do
			local isNotAlone = false
			if self:getTile(i,j).id == tile.id.floor then
				for _,v in ipairs(n_list) do
					if self:getTile(i + v.x, j + v.y).id == tile.id.floor then
						isNotAlone = true
					end
				end
			end
			if not isNotAlone then
			    self:setTile(i,j,tile.new(tile.id.wall, 1))
			end
		end
	end
end

-- genere les salles, place les chemins, raccorde les salles, supprime les cul-de-sac --
function dungeon_mt:generate(x)
	local rand = love.math.random()
	local x = x or love.round(rand * (self.w - 2), 0) + 2
	self:clean()

	self:generatePath(x, 2)
	self:setTile(x,2,tile.new(tile.id.enter, 1))
	self:generateBranches()
	local exit = { x = 2, y = 2}
	for i=2,d.w - 1 do
		for j=2,d.h - 1 do
			if self:getTile(i,j).id == tile.id.floor then
				exit.x = i
				exit.y = j
			end
		end
	end
	self:setTile(exit.x,exit.y,tile.new(tile.id.exit, 1))
	--self:cleanOne()
	return {x = x, y = 2}
end

function dungeon_mt:generateBranches()

	for i=2,d.w - 1 do
		for j=2,d.h - 1 do
			if self:getTile(i,j).id == tile.id.floor then
				local rand = math.random(100)
				if rand <= 20 then
					self:generateBranch(i - 1, j)
				elseif rand >= 80 then
					self:generateBranch(i + 1, j)
				end
			end
		end
	end

end

function dungeon_mt:generatePath(x,y)

	self:setTile(x,y,tile.new(tile.id.floor, 1))

	local xy = {x = 0, y = 1}
	local nx = x + xy.x
	local ny = y + xy.y
	local rand = math.random(100)

	if rand > 90 then
		nx = x - xy.y
		ny = y + xy.x
	elseif rand < 10 then
		nx = x + xy.y
		ny = y + xy.x
	end

	if nx == 1 then
		nx = 3
	elseif nx == self.w then
		nx = self.w - 2
	end

	if nx > 1 and nx <= self.w - 1 and ny > 1 and ny <= self.h - 1 and self:getTile(nx,ny).id == tile.id.wall then
		self:generatePath(nx,ny)
	elseif self:getTile(nx,ny).id ~= tile.id.wall and y + 2 <= self.h then
	    self:generatePath(x,y)
	end
end

function dungeon_mt:generateBranch(x, y)

	self:setTile(x,y,tile.new(tile.id.floor, 1))

	local xy = {x = 1, y = 0}
	local nx = x + xy.x
	local ny = y + xy.y
	--[[if(self:getTile(nx,ny).id == tile.id.floor) then
		nx = nx - 2 * xy.x
	end]]
	local rand = math.random() * 100

	if rand > 90 then
		nx = x + xy.y
		ny = y - xy.x
	elseif rand < 10 then
		nx = x + xy.y
		ny = y + xy.x
	end

	if nx > 1 and nx <= self.w - 1 and ny > 1 and ny <= self.h - 1 and self:getTile(nx,ny).id == tile.id.wall then
		self:generateBranch(nx,ny)
	else
	    table.insert( self.chronos, anychrono.new(x, y, math.random( 10 )) )
	end

end

-- place une tile dans le jeu -- 
function dungeon_mt:setTile(x, y, tile)
	x = ((x-1)%self.w)+1
	y = ((y-1)%self.h)+1
	self.data[ (x-1) + (y-1) * self.w + 1  ] = tile
end

-- recupere une tile avec ses coordonnees--
function dungeon_mt:getTile(x, y)
	x = ((x-1)%self.w)+1
	y = ((y-1)%self.h)+1
	return self.data[ (x-1) + (y-1) * self.w + 1  ] or tile.new(tile.id.wall, -1)
end

-- recupere une tile avec ses coordonnees--
function dungeon_mt:getChronos()
	return self.chronos
end

return dungeon