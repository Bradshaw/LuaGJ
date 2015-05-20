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

	self.xsize = options.xsize or 25
	self.ysize = options.ysize or 25
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

-- genere les salles, place les chemins, raccorde les salles, supprime les cul-de-sac --
function dungeon_mt:generate()
	self:clean()
	self:generatePath(self.xsize, 0)
	self:generateBranch()
end

function dungeon_mt:generatePath(x,y)
	self:setTile(x,y,tile.new(tile.id.floor, 1))
	local xy = {x = 0, y = 1}
	local nx = (x+xy.x) 
	local ny = (y+xy.y)
	if nx>0 and nx<self.w and ny>0 and ny<self.h then
		self:generatePath(nx,ny)
	end
end

function dungeon_mt:generateBranch()

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