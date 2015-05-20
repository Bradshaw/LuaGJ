local chrono_mt = {}
local chrono = {}

function chrono.new( x, y, time, index)
	local self = setmetatable({},{__index=chrono_mt})

	self.x = x
	self.y = y
	self.index = index or 1
	self.time = time

	return self
end

return chrono