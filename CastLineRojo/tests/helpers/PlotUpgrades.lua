local function read(path)
	local f = assert(io.open(path, "r"))
	local text = f:read("*a")
	f:close()
	return text
end
local rows = assert(loadstring(read("src/ReplicatedFirst/Data/ZonesData.lua")))()
local replicatedFirst = {
	WaitForChild = function()
		return {
			WaitForChild = function()
				return rows
			end,
		}
	end,
}
local data =
	assert(load(
		read("src/ReplicatedStorage/Modules/PlotUpgradeData.lua"),
		"PlotUpgradeData",
		"t",
		setmetatable({
			game = {
				GetService = function()
					return replicatedFirst
				end,
			},
			require = function(value)
				return value
			end,
		}, { __index = getfenv() })
	))()
return {
	data = data,
	environment = {
		script = { Parent = { PlotUpgradeData = data } },
		require = function(value)
			return value
		end,
	},
}
