local dungeon_mt = {}
local dungeon = {}
tile = require("tile")

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
	local x = x or love.round(rand * (self.w - 1), 0) + 1
	self:clean()
	self:generatePath(x, 1)
	self:generateBranches()
	--self:cleanOne()
end

function dungeon_mt:generateBranches()

	for i=1,d.w do
		for j=1,d.h do
			if self:getTile(i,j).id == tile.id.floor then
				local rand = math.random() * 100
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
	local rand = math.random() * 100

	if rand > 90 then
		nx = x - xy.y
		ny = y + xy.x
	elseif rand < 10 then
		nx = x + xy.y
		ny = y + xy.x
	end

	if nx == 0 then
		nx = 2
	elseif nx == self.w + 1 then
		nx = self.w - 1
	end

	if nx > 0 and nx <= self.w and ny > 0 and ny <= self.h and self:getTile(nx,ny).id == tile.id.wall then
		self:generatePath(nx,ny)
	elseif self:getTile(nx,ny).id ~= tile.id.wall and y + 1 <= self.h then
	    self:generatePath(x,y)
	end
end

function dungeon_mt:generateBranch(x, y)

	self:setTile(x,y,tile.new(tile.id.floor, 1))

	local xy = {x = 1, y = 0}
	local nx = x + xy.x
	local ny = y + xy.y
	if(self:getTile(nx,ny).id == tile.id.floor) then
		nx = nx - 2 * xy.x
	end
	local rand = math.random() * 100

	if rand > 90 then
		nx = x + xy.y
		ny = y - xy.x
	elseif rand < 10 then
		nx = x + xy.y
		ny = y + xy.x
	end

	if nx > 0 and nx <= self.w and ny > 0 and ny <= self.h and self:getTile(nx,ny).id == tile.id.wall then
		self:generateBranch(nx,ny)
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

return dungeon