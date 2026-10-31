local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local moundEffect = read("src/ReplicatedStorage/Modules/DigMoundEffect.lua")

assert(
	moundEffect:find('local soundFolder = ReplicatedStorage:WaitForChild("Sound")', 1, true)
		and moundEffect:find('local digSoundFolder = soundFolder:WaitForChild("Dig")', 1, true)
		and moundEffect:find('local diggingSounds = digSoundFolder:WaitForChild("Shovel")', 1, true),
	"Dig sounds must load from ReplicatedStorage.Sound.Dig.Shovel"
)
assert(
	not moundEffect:find("digAssets.Sounds.Shovel", 1, true),
	"Dig sounds must not use the legacy DigAssets.Sounds.Shovel hierarchy"
)
assert(
	moundEffect:find("for _, candidate in diggingSounds:GetChildren() do", 1, true)
		and moundEffect:find('candidate:IsA("Sound")', 1, true)
		and moundEffect:find("math.random(1, #soundTemplates)", 1, true),
	"Each dig hit must randomly choose from Shovel's direct Sound children"
)
assert(
	moundEffect:find('local landTemplate = digSoundFolder:FindFirstChild("Land")', 1, true)
		and moundEffect:find('local shineTemplate = digSoundFolder:FindFirstChild("Shine")', 1, true),
	"Reveal sounds must load from ReplicatedStorage.Sound.Dig.Land and Shine"
)
assert(
	not moundEffect:find("shine.Volume", 1, true),
	"Shine must retain its Studio-configured volume"
)

print("DigMoundSoundRouting.test.lua passed")
