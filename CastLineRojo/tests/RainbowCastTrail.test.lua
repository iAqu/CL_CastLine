local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end
local Config = assert(loadstring(read("src/ReplicatedStorage/Modules/FishingConfig.lua")))()
local h = require("./helpers/ReelSpringHarness").new()
local vec = h.vec
local vector = getmetatable(vec(0, 0, 0))
local oldIndex = vector.__index
vector.__index = function(value, key)
	if key == "Unit" then
		return value / value.Magnitude
	end
	return oldIndex(value, key)
end
function vector:Dot(other)
	return self.X * other.X + self.Y * other.Y + self.Z * other.Z
end
function vector:Cross(other)
	return vec(
		self.Y * other.Z - self.Z * other.Y,
		self.Z * other.X - self.X * other.Z,
		self.X * other.Y - self.Y * other.X
	)
end
local instances = require("./helpers/RarityHarness")({})
local function newInstance(class)
	local instance = instances.newInstance(class)
	if class == "Trail" then
		instance.clears = 0
		function instance:Clear()
			self.clears += 1
		end
	end
	local destroy = instance.Destroy
	function instance:Destroy()
		for _, child in self:GetChildren() do
			child:Destroy()
		end
		destroy(self)
	end
	return instance
end
local function numberSequence(keys)
	if type(keys) == "number" then
		keys = { { Time = 0, Value = keys }, { Time = 1, Value = keys } }
	end
	return { Keypoints = keys }
end
local env = setmetatable({
	Instance = { new = newInstance },
	Vector3 = h.env.Vector3,
	Color3 = instances.colors,
	ColorSequence = {
		new = function(color)
			return { Keypoints = { { Time = 0, Value = color }, { Time = 1, Value = color } } }
		end,
	},
	NumberSequence = { new = numberSequence },
	NumberSequenceKeypoint = {
		new = function(time, value)
			return { Time = time, Value = value }
		end,
	},
	CFrame = {
		new = function(position)
			return { Position = position, RightVector = vec(1, 0, 0) }
		end,
	},
}, { __index = getfenv() })
local Trail = assert(load(read("src/ReplicatedStorage/Modules/RainbowCastTrail.lua"), "RainbowCastTrail", "t", env))()
local function near(a, b)
	assert(math.abs(a - b) < 1e-7, tostring(a) .. " ~= " .. tostring(b))
end
local camera = { Position = vec(0, 5, 12), RightVector = vec(1, 0, 0) }
for _, settings in pairs(Config.CastProfiles.Godlike.Trails) do
	for _, fps in { 15, 30, 60 } do
		local parent = newInstance("Folder")
		local trail = Trail.new(parent, settings, Config.CastRainbow)
		assert(#trail.bands == 9 and not trail.enabled)
		trail:Start(vec(0, 0, 0), camera, 0)
		trail:Start(vec(99, 99, 99), camera, 0)
		for i, band in ipairs(trail.bands) do
			assert(band.trail.clears == 1 and band.trail.Enabled and band.trail.FaceCamera)
			assert(band.trail.LightInfluence == 0 and band.trail.MaxLength == settings.MaxLength)
			assert(band.trail.Transparency.Keypoints[2].Time == 0.65)
			assert(band.trail.WidthScale.Keypoints[1].Value == 1 and band.trail.WidthScale.Keypoints[2].Value == 1)
			if not band.edge then
				local color = band.trail.Color.Keypoints[1].Value
				local rgb = Config.CastRainbow[i - 1]
				near(color.R, rgb[1] / 255)
				near(color.G, rgb[2] / 255)
				near(color.B, rgb[3] / 255)
				near((band.b.Position - band.a.Position).Magnitude, settings.Width / 7)
				assert(band.trail.Brightness == 1.3)
			end
		end
		near(
			(trail.bands[#trail.bands].b.Position - trail.bands[1].a.Position).Magnitude,
			settings.Width + 2 * settings.EdgeWidth
		)
		local previous = trail.axis
		for frame = 1, fps * 3 do
			local now = frame / fps
			local angle = now * 5
			local position = vec(math.sin(angle) * 6, math.cos(angle) * 3, now * 2)
			local view = { Position = vec(math.sin(now) * 12, 6, math.cos(now) * 12), RightVector = camera.RightVector }
			assert(trail:Update(position, view, now))
			assert(trail.axis:Dot(previous) > 0, "Lane order must not flip across a turn")
			near(trail.axis.Magnitude, 1)
			previous = trail.axis
			assert(#trail.history <= 32, "History must remain bounded at every frame rate")
		end
		local historySize = #trail.history
		trail:Update(vec(999, 0, 0), camera, 3)
		assert(#trail.history == historySize and trail.position.X ~= 999, "Ignore duplicate-frame updates")
		local points = {}
		trail:AppendBounds(points, 3)
		assert(#points > 2, "Camera fit must include a visible arc, not only the tip")
		trail:Stop(3)
		trail:Stop(3.1)
		assert(not trail.enabled and trail.expiresAt == 3 + settings.Lifetime)
		for _, band in ipairs(trail.bands) do
			assert(not band.trail.Enabled and band.trail.clears == 1, "Stop must preserve the fading tail")
		end
		assert(trail:Update(vec(0, 0, 0), camera, 3 + settings.Lifetime - 0.001))
		assert(not trail:Update(vec(0, 0, 0), camera, 3 + settings.Lifetime + 0.001))
		trail:Destroy()
		assert(not trail.carrier.Parent and #trail.bands == 0 and #trail.history == 0 and not trail.head)
	end
end
-- Straight-on views and stationary tips must never produce a NaN axis.
do
	local trail = Trail.new(newInstance("Folder"), Config.CastProfiles.Godlike.Trails.Rod, Config.CastRainbow)
	trail:Start(vec(0, 0, 0), camera, 0)
	for frame = 1, 60 do
		local point = vec(0, 0, frame * 0.1)
		trail:Update(point, { Position = point + vec(0, 0, 10), RightVector = vec(1, 0, 0) }, frame / 60)
		near(trail.axis.Magnitude, 1)
	end
	trail:Update(trail.position, camera, 2)
	near(trail.axis.Magnitude, 1)
	trail:Destroy()
end

-- Mutation fish reuse the renderer with a single solid-color band plus the two dark edges.
for _, rgb in ipairs({ { 255, 170, 0 }, { 37, 204, 255 } }) do
	local trail = Trail.new(newInstance("Folder"), Config.CastProfiles.Godlike.Trails.Flight, { rgb })
	trail:Start(vec(0, 0, 0), camera, 0)
	assert(#trail.bands == 3 and not trail.bands[2].edge)
	local band = trail.bands[2]
	near((band.b.Position - band.a.Position).Magnitude, 1.2)
	local color = band.trail.Color.Keypoints[1].Value
	near(color.R, rgb[1] / 255)
	near(color.G, rgb[2] / 255)
	near(color.B, rgb[3] / 255)
	trail:Stop(0.1)
	assert(trail:Update(vec(1, 0, 0), camera, 0.79))
	assert(not trail:Update(vec(1, 0, 0), camera, 0.81))
end
