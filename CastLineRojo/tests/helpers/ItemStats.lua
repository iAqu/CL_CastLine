local function read(name)
	local file = assert(io.open("src/ReplicatedStorage/Modules/" .. name .. ".lua", "r"))
	local source = file:read("*a")
	file:close()
	return source
end

return require("./helpers/RarityHarness")({
	RarityConfig = read("RarityConfig"),
	ItemStatUtil = read("ItemStatUtil"),
	WeightFormat = read("WeightFormat"),
}).load("ItemStatUtil")
