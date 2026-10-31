local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local ragdoll = read("src/ReplicatedStorage/Libs/Ragdoll.lua")
local swingService = read("src/ServerScriptService/Services/SwingService.lua")
local waterDrownService = read("src/ServerScriptService/Services/WaterDrownService.lua")

assert(ragdoll:find("local COLLIDER_SCALE = 0.75", 1, true), "ragdoll colliders must use the GAG2 scale")
assert(ragdoll:find('local COLLIDER_NAME = "RagdollCollider"', 1, true), "ragdoll colliders need a stable name")
assert(ragdoll:find('local PLAYER_COLLISION_GROUP = "Player"', 1, true), "ragdoll colliders must avoid self-collision")
assert(ragdoll:find("collider.Size = part.Size * COLLIDER_SCALE", 1, true), "colliders must follow body-part size")
assert(ragdoll:find("collider.CanCollide = true", 1, true), "ragdoll proxies must collide with the world")
assert(ragdoll:find("collider.Massless = true", 1, true), "ragdoll proxies must not change knockback mass")
assert(
	ragdoll:find("collider.CollisionGroup = PLAYER_COLLISION_GROUP", 1, true),
	"ragdoll proxies must use the non-self-colliding player group"
)
assert(ragdoll:find("part:FindFirstChild(COLLIDER_NAME)", 1, true), "collider creation must be idempotent")
assert(ragdoll:find("local MIN_BALL_SOCKET_ANGLE = 60", 1, true), "ragdoll sockets must bend by at least 60 degrees")
assert(ragdoll:find("local MIN_TWIST_ANGLE = 45", 1, true), "ragdoll socket twist must reach at least 45 degrees")
assert(ragdoll:find("loosenBallSocketConstraints(character)", 1, true), "ragdoll creation must loosen ball sockets")
assert(ragdoll:find("restoreBallSocketConstraints(character)", 1, true), "ragdoll cleanup must restore socket limits")

assert(
	ragdoll:find("local function hasCreatedJoints(character: Model): boolean", 1, true),
	"ragdoll joint creation needs an idempotency guard"
)
assert(
	ragdoll:find("if not hasCreatedJoints(character) then", 1, true),
	"existing physical ragdoll constraints must not be recreated"
)
assert(
	ragdoll:find(
		"createCollisionProxies(character)",
		ragdoll:find("if not hasCreatedJoints(character) then", 1, true),
		true
	),
	"idempotent ragdoll setup must still ensure collision proxies"
)
assert(
	ragdoll:find("return joints", ragdoll:find("createCollisionProxies(character)", 1, true), true),
	"idempotent joint creation must return the original joint set"
)

assert(
	waterDrownService:find('local DROWNING_ATTRIBUTE = "WaterDrowning"', 1, true),
	"drowning must expose a stable character-state attribute"
)
assert(
	waterDrownService:find("Ragdoll.CreateJoints(character)", 1, true),
	"drowning must reuse the same idempotent ragdoll setup"
)
assert(
	swingService:find('local DROWNING_ATTRIBUTE = "WaterDrowning"', 1, true),
	"swing recovery must observe drowning state"
)
local restoreFunction = assert(swingService:find("function SwingService:_restoreRagdoll", 1, true))
local checksDrowning =
	assert(swingService:find("if character:GetAttribute(DROWNING_ATTRIBUTE) == true then", restoreFunction, true))
local rechecksDrowning = assert(swingService:find("task.delay(DROWNING_RECHECK_DELAY", checksDrowning, true))
local restoresJoints = assert(swingService:find("Ragdoll.SetMotorsEnabled(state.joints, true)", checksDrowning, true))
assert(checksDrowning < restoresJoints, "drowning takeover must be checked before any swing ragdoll restoration")
assert(rechecksDrowning < restoresJoints, "an escaped drowning attempt must resume the pending ragdoll recovery")

print("SwingRagdollLifecycle.test.lua passed")
