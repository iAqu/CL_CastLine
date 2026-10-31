local constantsPath = "src/ReplicatedStorage/Modules/Constants.lua"

local file = assert(io.open(constantsPath, "r"))
local source = file:read("*a")
file:close()

local soundResStart = source:find("Constants%.SoundRes%s*=")
assert(soundResStart, "Constants.SoundRes should exist")

local waitForSound = source:find(":WaitForChild%([\"']Sound[\"']%)")
assert(waitForSound and waitForSound < soundResStart, "Constants should wait for ReplicatedStorage.Sound before building SoundRes")

local soundResSource = source:sub(soundResStart)
assert(not soundResSource:find("ReplicatedStorage%.Sound"), "Constants.SoundRes should not directly index ReplicatedStorage.Sound")

print("ConstantsSoundLoadOrder.test.lua passed")
