local function read(path)
	local file = assert(io.open(path, "r"))
	local content = file:read("*a")
	file:close()
	return content
end

local service = read("src/ServerScriptService/Services/SwingService.lua")
assert(service:find("local ATTACK_COOLDOWN = 0.65", 1, true), "server swing cooldown must be 0.65 seconds")
assert(service:find("local HIT_WINDOW_DURATION = 0.4", 1, true), "server hit window must last 0.4 seconds")
assert(service:find("local TARGET_HIT_COOLDOWN = 0.5", 1, true), "per-target cooldown must last 0.5 seconds")
assert(service:find("local HIT_RANGE = 12", 1, true), "server hit validation range must be 12 studs")
assert(service:find("local MIN_FORWARD_DOT = 0.3", 1, true), "server facing threshold must match Garden2")
assert(service:find("BeginSwing = Knit.CreateSignal()", 1, true), "swing windows need a dedicated remote")
assert(service:find("HitPlayer = Knit.CreateSignal()", 1, true), "contact reports need a target remote")
assert(not service:find("RequestSwing", 1, true), "the old targetless swing remote must be removed")
assert(service:find("expiresAt = now + HIT_WINDOW_DURATION", 1, true), "begin swing must open a bounded hit window")
assert(service:find("now > swingState.expiresAt", 1, true), "late hit reports must be rejected")
assert(service:find("ShovelToolUtil.FindShovelTool(character)", 1, true), "server must require an equipped shovel")
assert(service:find("targetUserId % 1 ~= 0", 1, true), "malformed target user ids must be rejected")
assert(not service:find("targetUserId <= 0", 1, true), "negative Studio test user ids must remain valid")
assert(service:find("Players:GetPlayerByUserId(targetUserId)", 1, true), "server must resolve the reported target")
assert(service:find("targetPlayer == player", 1, true), "server must reject self hits")
assert(service:find("swingState.hitTargets[targetPlayer]", 1, true), "each swing must deduplicate each target")
assert(service:find("distance > HIT_RANGE", 1, true), "server must reject distant contacts")
assert(
	service:find("attackerRoot.CFrame.LookVector:Dot(offset.Unit) < MIN_FORWARD_DOT", 1, true),
	"server must reject contacts behind the attacker"
)
assert(service:find("now - lastHitAt < TARGET_HIT_COOLDOWN", 1, true), "server must enforce target hit cooldown")
assert(service:find("self._RagdollStates[targetPlayer]", 1, true), "ragdolled targets must reject repeated knockback")
assert(service:find("local HORIZONTAL_KNOCKBACK_SPEED = 45", 1, true), "horizontal knockback must remain 45")
assert(service:find("local UPWARD_KNOCKBACK_SPEED = 18", 1, true), "vertical knockback must remain 18")
assert(service:find('local HIT_HIGHLIGHT_NAME = "SwingHitHighlight"', 1, true), "hits need a stable highlight name")
assert(service:find("local HIT_HIGHLIGHT_DURATION = 0.5", 1, true), "the red hit flash must last 0.5 seconds")
assert(service:find("highlight.FillColor = Color3.fromRGB(255, 0, 0)", 1, true), "hit fill must be red")
assert(service:find("highlight.FillTransparency = 0", 1, true), "hit fill must begin opaque")
assert(service:find("highlight.OutlineTransparency = 1", 1, true), "hit flash must have no outline")
assert(
	service:find("highlight.DepthMode = Enum.HighlightDepthMode.Occluded", 1, true),
	"hit flash must respect occlusion"
)
assert(service:find("TweenService:Create", 1, true), "hit highlight must fade with a tween")
assert(service:find("FillTransparency = 1", 1, true), "hit highlight must fade to transparent")
assert(service:find("Debris:AddItem(highlight, HIT_HIGHLIGHT_DURATION)", 1, true), "hit highlight must be cleaned up")
assert(service:find("root:ApplyImpulse", 1, true), "server must apply mass-compensated knockback")
local capturesWholeCharacterMass = assert(
	service:find("local characterAssemblyMass = root.AssemblyMass", 1, true),
	"knockback must capture the intact character assembly mass"
)
local releasesCharacterJoints = assert(service:find("Ragdoll.SetMotorsEnabled(joints, false)", 1, true))
assert(
	capturesWholeCharacterMass < releasesCharacterJoints,
	"character mass must be captured before Avatar Joint Upgrade splits the ragdoll into assemblies"
)
assert(
	service:find("velocityChange * characterAssemblyMass", 1, true),
	"knockback impulse must compensate for the intact character mass"
)
assert(service:find("Ragdoll.CreateJoints(character)", 1, true), "knockback must create ragdoll joints")
assert(service:find("Ragdoll.SetMotorsEnabled(joints, false)", 1, true), "knockback must release character joints")
assert(service:find("humanoid.PlatformStand = true", 1, true), "knockback must disable normal character control")
assert(
	service:find("setServerNetworkOwners(networkParts)", releasesCharacterJoints, true),
	"server must take ownership after the ragdoll assemblies split"
)
assert(
	service:find('descendant:IsA("BasePart") and not descendant.Anchored', 1, true),
	"network ownership must cover every unanchored character assembly"
)
assert(service:find("local RAGDOLL_DURATION = 1.5", 1, true), "ragdoll must last 1.5 seconds")
assert(service:find("task.delay(RAGDOLL_DURATION", 1, true), "ragdoll recovery must be delayed")
assert(service:find("token = {}", 1, true), "ragdoll recovery must use a session token")
assert(
	service:find("character:GetAttribute(DROWNING_ATTRIBUTE) == true", 1, true),
	"drowning must take ownership instead of being restored"
)
assert(
	service:find("task.delay(DROWNING_RECHECK_DELAY", 1, true),
	"an interrupted drowning attempt must eventually resume normal recovery"
)
assert(
	service:find("Ragdoll.SetMotorsEnabled(state.joints, true)", 1, true),
	"normal recovery must restore character joints"
)
assert(
	service:find("restoreAutomaticNetworkOwnership(state.networkParts)", 1, true),
	"normal recovery must restore automatic network ownership"
)
assert(
	service:find("MovementSpeedService:RefreshPlayer(player)", 1, true),
	"recovery must restore the current calculated movement speed"
)
assert(service:find("player.CharacterAdded:Connect", 1, true), "respawn must invalidate old ragdoll state")
assert(service:find("self.Client.DigInterrupted:Fire(targetPlayer)", 1, true), "server must interrupt a hit target")

local controller = read("src/StarterPlayer/StarterPlayerScripts/Controllers/SwingController.lua")
assert(controller:find("local ATTACK_COOLDOWN = 0.65", 1, true), "client swing cooldown must be 0.65 seconds")
assert(controller:find("local HIT_WINDOW_DURATION = 0.4", 1, true), "client contact window must last 0.4 seconds")
assert(
	controller:find("local HITBOX_PADDING = Vector3.new(4, 4, 4)", 1, true),
	"the shovel head hitbox must expand by two studs on every side"
)
assert(controller:find("TOUCH_TAP_MAX_DURATION = 0.5", 1, true), "touch tap duration must match the spec")
assert(controller:find("TOUCH_TAP_MAX_DISTANCE = 10", 1, true), "touch movement threshold must match the spec")
assert(
	controller:find("ReplicatedStorage.Animation.Character.Swing", 1, true),
	"swing animation source must stay documented"
)
assert(controller:find("DigInterrupted:Connect", 1, true), "client must listen for dig interruption")
assert(controller:find('root:FindFirstChild("Jumping")', 1, true), "swing must reuse the character default jump sound")
assert(
	controller:find('DEFAULT_JUMP_SOUND_ID = "rbxasset://sounds/action_jump.mp3"', 1, true),
	"swing needs the default jump-sound fallback"
)
assert(
	controller:find("fallbackSound.SoundId = jumpSound.SoundId", 1, true),
	"swing must copy the default jump sound instead of cloning an unarchivable character sound"
)
assert(controller:find("part.Touched:Connect", 1, true), "the equipped shovel must report real physical contacts")
assert(controller:find('tool:FindFirstChild("ShovelHead", true)', 1, true), "expanded queries must follow ShovelHead")
assert(controller:find("OverlapParams.new()", 1, true), "expanded hit detection must use an overlap query")
assert(
	controller:find("Enum.RaycastFilterType.Include", 1, true),
	"expanded hit detection must include only other player characters"
)
assert(
	controller:find("Workspace:GetPartBoundsInBox(shovelHead.CFrame, shovelHead.Size + HITBOX_PADDING", 1, true),
	"the expanded query must use the live shovel-head transform"
)
assert(controller:find("RunService.Heartbeat:Connect", 1, true), "the expanded hitbox must be sampled during the swing")
assert(controller:find("part.CanTouch = true", 1, true), "shovel contact must be enabled during the hit window")
assert(
	controller:find("part.CanTouch = canTouch", 1, true),
	"each shovel part must restore its original CanTouch value"
)
assert(
	controller:find("connection:Disconnect()", 1, true),
	"contact listeners must be disconnected after the hit window"
)
assert(
	controller:find("reportedPlayers[targetPlayer]", 1, true),
	"the client must report each touched player only once per swing"
)
assert(
	controller:find("swingService.HitPlayer:Fire(targetPlayer.UserId)", 1, true),
	"the client must report the touched player's user id"
)
local swingAnimationPlay = assert(controller:find("playSwingAnimation(humanoid)", 1, true))
local swingSoundPlay = assert(controller:find("playSwingSound(character)", swingAnimationPlay, true))
local beginSwing = assert(controller:find("BeginSwing:Fire()", 1, true))
assert(swingSoundPlay < beginSwing, "swing sound must play with the successful swing before opening the server window")
assert(
	beginSwing < assert(controller:find("beginHitWindow(shovel)", beginSwing, true)),
	"the server window must open before local contact reporting"
)

local digController = read("src/StarterPlayer/StarterPlayerScripts/Controllers/DigController.lua")
assert(digController:find("function DigController:IsDigging()", 1, true), "dig state query must exist")
assert(
	digController:find("function DigController:InterruptDigging()", 1, true),
	"dig interruption entry point must exist"
)

print("SwingBehavior.test.lua passed")
