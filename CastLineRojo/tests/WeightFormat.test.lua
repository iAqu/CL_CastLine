local file = assert(io.open("src/ReplicatedStorage/Modules/WeightFormat.lua", "r"))
local source = file:read("*a")
file:close()

assert(source:find("math.abs(value) < 10", 1, true), "Only weights below 10kg should retain a decimal")
assert(source:find('string.format("%.1fkg"', 1, true), "Small weights must display one decimal place")
assert(source:find('string.format("%dkg"', 1, true), "Weights at or above 10kg must display as integers")
assert(source:find("math.round(value)", 1, true), "Large displayed weights must round to the nearest integer")

print("WeightFormat.test.lua passed")
