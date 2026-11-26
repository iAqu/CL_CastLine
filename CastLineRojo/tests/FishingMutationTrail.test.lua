--# selene: allow(undefined_variable)
local function read(path)
	local f = assert(io.open(path, "r"))
	local source = f:read("*a")
	f:close()
	return source
end
local h = require("./helpers/ReelSpringHarness").new()
local vec = h.vec
local Config = assert(loadstring(read("src/ReplicatedStorage/Modules/FishingConfig.lua")))()
local function frame(position, yaw)
	local result = { Position = position, angle = yaw or 0 }
	function result:PointToWorldSpace(p)
		local c, s = math.cos(self.angle), math.sin(self.angle)
		return self.Position + vec(c * p.X + s * p.Z, p.Y, -s * p.X + c * p.Z)
	end
	function result:ToObjectSpace(other)
		local p = other.Position - self.Position
		local c, s = math.cos(self.angle), math.sin(self.angle)
		return frame(vec(c * p.X - s * p.Z, p.Y, s * p.X + c * p.Z), other.angle - self.angle)
	end
	return result
end
local replicatedStorage = {}
local colors = { Golden = { R = 1, G = 170 / 255, B = 0 }, Diamond = { R = 37 / 255, G = 204 / 255, B = 1 } }
local camera = { CFrame = { name = "current camera" } }
local modules =
	{ FishingConfig = Config, MutationDataUtil = {
		GetLabelColor = function(id)
			return colors[id]
		end,
	}, RainbowCastTrail = {} }
function modules.RainbowCastTrail.new(parent, settings, palette)
	local ribbon = { parent = parent, settings = settings, colors = palette, starts = 0, stops = 0, destroys = 0 }
	function ribbon:Start(position, view, now)
		self.starts += 1
		self.position, self.view, self.startedAt = position, view, now
	end
	function ribbon:Update(position, view, now)
		self.position, self.view = position, view
		return not self.stopAt or now < self.stopAt + self.settings.Lifetime
	end
	function ribbon:Stop(now)
		if self.stopAt then
			return
		end
		self.stopAt = now
		self.stops += 1
	end
	function ribbon:Destroy()
		if self.destroys == 0 then
			self.destroys = 1
		end
	end
	return ribbon
end
local env = setmetatable({
	Vector3 = h.env.Vector3,
	script = { Parent = modules },
	require = function(v)
		return v or {}
	end,
	game = {
		GetService = function(_, name)
			return if name == "Workspace" then { CurrentCamera = camera } else replicatedStorage
		end,
	},
	warn = function() end,
}, { __index = getfenv() })
local Mutation =
	assert(load(read("src/ReplicatedStorage/Modules/FishingMutationTrail.lua"), "MutationTrail", "t", env))()
local function near(a, b)
	assert(math.abs(a - b) < 1e-6, tostring(a) .. " ~= " .. tostring(b))
end
local function same(a, b)
	near(a.X, b.X)
	near(a.Y, b.Y)
	near(a.Z, b.Z)
end
local function fish(mutation, scale)
	local body = { CFrame = frame(vec(10, 3, 20), math.pi / 2), Position = vec(10, 3, 20), Size = vec(2, 2, 2) * scale }
	local extra = { Size = vec(2, 2, 4) * scale, CFrame = frame(
		body.CFrame:PointToWorldSpace(vec(2, 0, 0) * scale),
		math.pi / 2
	) }
	local model = {
		PrimaryPart = body,
		Parent = true,
		Destroy = function(self)
			self.Parent = nil
		end,
	}
	return { mutationId = mutation, scale = scale, originals = { [body] = {}, [extra] = {} }, fish = model, owner = {
		folder = {},
	} },
		body
end
for _, id in { "Rainbow", "Golden", "Diamond" } do
	for _, scale in { 0.01, 1, 10 } do
		local bite, body = fish(id, scale)
		local fx = assert(Mutation.new(bite, 100))
		local ribbon = fx.ribbon
		near(ribbon.settings.Width, math.max(0.6, 4 * scale * 0.3))
		near(ribbon.settings.EdgeWidth, ribbon.settings.Width / 28)
		near(ribbon.settings.MaxLength, math.max(10, 4 * scale * 2))
		assert(ribbon.settings.Lifetime == 0.7 and ribbon.parent == bite.owner.folder and ribbon.starts == 1, "Trail must start once under the owner's folder")
		same(fx.center, vec(1, 0, 0))
		same(ribbon.position, body.CFrame:PointToWorldSpace(vec(scale, 0, 0)))
		if id == "Rainbow" then
			assert(ribbon.colors == Config.CastRainbow and #ribbon.colors == 7, "Rainbow must use all seven colors")
		else
			assert(#ribbon.colors == 1, "A single-color mutation must use one color")
			near(ribbon.colors[1][1], colors[id].R * 255)
			near(ribbon.colors[1][2], colors[id].G * 255)
			near(ribbon.colors[1][3], colors[id].B * 255)
		end
		local width = ribbon.settings.Width
		bite.scale = scale * 2
		body.CFrame = frame(vec(15, 9, 30), math.pi)
		assert(fx:Update(100.2, true))
		same(ribbon.position, body.CFrame:PointToWorldSpace(vec(scale * 2, 0, 0)))
		assert(
			ribbon.settings.Width == width and ribbon.view == camera.CFrame,
			"Follow scaling/rotation without resizing the ribbon"
		)
		assert(fx:Update(101, false) and fx:Update(101.2, false) and ribbon.stops == 1, "Emission must stop once")
		assert(fx:Update(101.699, false), "Keep the remaining tail alive")
		assert(not fx:Update(101.701, false) and ribbon.destroys == 1 and not fx.bite, "Release the expired tail")
		fx:Destroy()
		assert(not fx:Update(102, true) and ribbon.destroys == 1, "A destroyed tail cannot restart")
	end
end
for _, id in { "", "Unknown" } do
	local bite = fish(id, 1)
	assert(Mutation.new(bite, 0) == nil, "Unknown mutations use the ordinary trail")
end
do
	local bite = fish("Rainbow", 1)
	bite.isEgg = true
	assert(Mutation.new(bite, 0) == nil, "Eggs must not get a mutation trail")
	bite.isEgg = false
	bite.originals = {}
	assert(Mutation.new(bite, 0) == nil, "Do not create a ribbon without visible fish parts")
end
-- Run the actual bite lifecycle boundary: underwater -> emergence -> apex -> cleanup.
modules.FishingMutationTrail = Mutation
local CatchTrail =
	assert(load(read("src/ReplicatedStorage/Modules/FishingCatchTrail.lua"), "CatchTrail", "t", env))()
modules.FishingCatchTrail = CatchTrail
modules.WaterSurfaceUtil = {
	GetWaterSurfaceY = function()
		return 0
	end,
}
modules.FishShadowAppearance = { Destroy = function() end }
local Bite = assert(load(read("src/ReplicatedStorage/Modules/FishingBiteSequence.lua"), "Bite", "t", env))()
for _, fps in { 15, 30, 60 } do
	local bite, body = fish("Rainbow", 1)
	setmetatable(bite, Bite)
	bite.GetLiftTiming = function()
		return { riseEnd = 1 }
	end
	body.Position = vec(0, -1, 0)
	bite:_updateFishTrail("Lifting", 0, 0)
	assert(not bite.mutationTrail and not bite.fishTrailAttempted, "Do not emit underwater")
	body.Position = vec(0, 1, 0)
	for i = 0, fps - 1 do
		bite:_updateFishTrail("Lifting", i / fps, i / fps)
	end
	local ribbon = assert(bite.mutationTrail).ribbon
	assert(not bite.fishTrail and ribbon.starts == 1, "Replace, rather than stack with, the ordinary trail")
	bite:_updateFishTrail("Lifting", 1, 1)
	assert(ribbon.stops == 1, "Stop emitting at the apex")
	bite:_updateFishTrail("Caught", 0.69, 1.69)
	assert(bite.mutationTrail and ribbon.destroys == 0, "Allow the tail to fade during descent")
	bite:_updateFishTrail("Caught", 0.71, 1.71)
	assert(not bite.mutationTrail and ribbon.destroys == 1, "Clean up after the fade")
	bite:_updateFishTrail("Lifting", 0.5, 2)
	assert(not bite.mutationTrail, "Never restart an already consumed trail")
	bite:Destroy()
	bite:Destroy()
end
do
	local bite = fish("Diamond", 1)
	setmetatable(bite, Bite)
	bite.GetLiftTiming = function()
		return { riseEnd = 1 }
	end
	bite:_updateFishTrail("Lifting", 0.1, 0.1)
	local ribbon = bite.mutationTrail.ribbon
	bite:Destroy()
	bite:Destroy()
	assert(ribbon.destroys == 1 and not bite.mutationTrail, "Destroy a canceled tail once")
	local egg = fish("Rainbow", 1)
	egg.isEgg = true
	setmetatable(egg, Bite)
	egg:_updateFishTrail("Lifting", 0.1, 0.1)
	assert(not egg.mutationTrail and not egg.fishTrailAttempted, "Eggs skip the catch trail")
end

-- A late observer can start during the visible rise, but never replays an ended rise.
do
	local missed = fish("Rainbow", 1)
	CatchTrail.Update(missed, 4, false, true)
	assert(not missed.fishTrailAttempted and not missed.mutationTrail, "Do not replay a missed rise")

	local observer = fish("Golden", 2)
	CatchTrail.Update(observer, 4.2, true, true)
	local ribbon = assert(observer.mutationTrail).ribbon
	assert(ribbon.startedAt == 4.2, "A late tail starts at the current time")
	CatchTrail.Update(observer, 4.6, false, true)
	assert(ribbon.stopAt == 4.6 and ribbon.destroys == 0, "Preserve the existing tail past the apex")
	CatchTrail.Destroy(observer)
	CatchTrail.Destroy(observer)
	assert(ribbon.destroys == 1 and not observer.mutationTrail, "Clear the observer's tail once")
end

do
	local function asset(class, fields)
		fields.Archivable = true
		function fields:IsA(expected)
			return expected == class
		end
		function fields:FindFirstChild(name)
			return self[name]
		end
		function fields:Clone()
			local clone = table.clone(self)
			clone.Trail = self.Trail and table.clone(self.Trail)
			return clone
		end
		function fields:Destroy()
			self.Parent = nil
		end
		return fields
	end
	local trail = asset("Trail", {
		Clear = function(self)
			self.cleared = (self.cleared or 0) + 1
		end,
	})
	local att0 = asset("Attachment", { Trail = trail })
	local att1 = asset("Attachment", {})
	replicatedStorage.VFX = asset("Folder", { Fish = asset("Folder", { FishTrail = asset("Folder", {
		Att0 = att0, Att1 = att1,
	}) }) })
	replicatedStorage.FindFirstChild = replicatedStorage.VFX.FindFirstChild

	local observer, body = fish(nil, 2)
	CatchTrail.Update(observer, 1, true, false)
	assert(not observer.fishTrail, "No ordinary trail before emergence")
	CatchTrail.Update(observer, 1.1, true, true)
	local effect = assert(observer.fishTrail, "Ordinary trail missing")
	assert(effect.trail.Enabled and effect.trail.cleared == 1, "Start the ordinary trail once")
	assert(effect.att0.Parent == body and effect.att1.Parent == body, "Attach both trail edges to the fish")
	CatchTrail.Update(observer, 1.2, true, true)
	assert(observer.fishTrail == effect, "Keep the same trail throughout the rise")
	CatchTrail.Update(observer, 1.6, false, true)
	assert(not effect.trail.Enabled and effect.trail.cleared == 1, "Let the existing trail fade at the apex")
	CatchTrail.Destroy(observer)
	CatchTrail.Destroy(observer)
	assert(not observer.fishTrail and not effect.att0.Parent and not effect.att1.Parent and effect.trail.cleared == 2,
		"Clean up both attachments once")
end
