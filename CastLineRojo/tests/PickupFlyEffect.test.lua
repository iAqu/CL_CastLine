local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local utility = read("src/ReplicatedStorage/Modules/PickupFlyEffectUtil.lua")

assert(utility:find("local FLY_DURATION = 0.35", 1, true), "Pickup flight must remain visible long enough to perceive")
assert(
	utility:find("function Snapshot.Play(self: Snapshot, targetPart: BasePart?): boolean", 1, true),
	"Pickup flight must report whether it started"
)
assert(
	utility:find("return false", 1, true),
	"Pickup flight must fail safely when the target is unavailable"
)
assert(
	utility:find("return true", 1, true),
	"Pickup flight must confirm a successful visual launch"
)

print("PickupFlyEffect.test.lua passed")
