local function read(path: string): string
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local moundEffect = read("src/ReplicatedStorage/Modules/DigMoundEffect.lua")

assert(
	moundEffect:find('local vfxFolder = ReplicatedStorage:WaitForChild("VFX")', 1, true)
		and moundEffect:find('local diggingParticles = vfxFolder:WaitForChild("Dig")', 1, true),
	"Dig particles must load from ReplicatedStorage.VFX.Dig"
)
assert(
	moundEffect:find('cloneParticle("Smoke", center, ground.color)', 1, true)
		and moundEffect:find('cloneParticle("SmokeLine", center, ground.color)', 1, true)
		and moundEffect:find('cloneParticle("Specs", center, ground.color)', 1, true)
		and moundEffect:find('diggingParticles:FindFirstChild("FinishSparkles")', 1, true),
	"Dig particles must use the VFX.Dig PascalCase resource names"
)
assert(
	not moundEffect:find("DigAssets", 1, true)
		and not moundEffect:find("_Smoke", 1, true)
		and not moundEffect:find("_SmokeLine", 1, true)
		and not moundEffect:find("_Specs", 1, true)
		and not moundEffect:find("_Finish_Sparkles", 1, true),
	"Dig mound effects must not retain legacy DigAssets resource paths or names"
)

print("DigVFXResourceRouting.test.lua passed")
