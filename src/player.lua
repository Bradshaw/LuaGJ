local player_mt = {}
local player = {}

function player.new(x, y, speed)
	self = setmetatable({}, {__index = player_mt})
	
	self.x = x or 0
	self.y = y or 0
	self.speed = speed or 10
	
	return self
end

return player
