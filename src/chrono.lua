local chrono_mt = {}
local chrono = {}

tile.id = {
	wall = 1,
	floor = 0,
	enter = 2,
	exit = 3
}

function chrono.new( x, y, time )
	local self = setmetatable({},{__index=chrono_mt})

	self.x = x
	self.y = y 
	self.index = index or 100
	self.time = time

	return self
end

return chrono