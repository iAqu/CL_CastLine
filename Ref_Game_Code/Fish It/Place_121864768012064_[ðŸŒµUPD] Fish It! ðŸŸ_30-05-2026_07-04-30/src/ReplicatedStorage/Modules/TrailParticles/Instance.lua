-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("RunService")
local t = {}
t.__index = t
local noise = math.noise
local v1 = Random.new(os.time())
function t.new(p1) --[[ new | Line: 12 | Upvalues: v1 (copy), t (copy) ]]
	local t2 = {
		Element = nil,
		MinSpeedMult = 1,
		MaxSpeedMult = 1,
		FadeIn = 1,
		FadeOut = 1,
		Active = true,
		Resolution = 2,
		Contrast = 1.1,
		TrailLife = 0.5,
		_t = 0,
		Velocity = p1,
		NoiseStrength = function(p1) --[[ NoiseStrength | Line: 20 ]] end,
		VelocityDrag = function(p1) --[[ VelocityDrag | Line: 21 ]] end,
		Seed = os.time()
	}
	local v12 = v1:NextInteger(-1, 1) + 0.01
	local v2 = v1:NextInteger(-1, 1) + 0.01
	t2._rotationDirection = Vector3.new(v12, v2, v1:NextInteger(-1, 1) + 0.01)
	t2._start = os.clock()
	return setmetatable(t2, t)
end
function t.Update(p1, p2) --[[ Update | Line: 40 | Upvalues: noise (copy) ]]
	if not p1.Element then
		error("Particle element missing or nil")
	end
	if os.clock() - p1._start >= p1.Lifetime then
		p1:Destroy()
	end
	local Element = p1.Element
	local v1 = noise(Element.CFrame.Rotation.X / p1.Resolution + 0.1, p1.Seed + p1._t)
	local v3 = math.rad(math.clamp(v1, -1, 1) * p1.NoiseStrength(p1.Contrast + p1._t / 10)) * p1._rotationDirection.X
	local v4 = noise(Element.CFrame.Rotation.Y / p1.Resolution + 0.1, p1.Seed + p1._t)
	local v6 = math.rad(math.clamp(v4, -1, 1) * p1.NoiseStrength(p1.Contrast + p1._t / 10)) * p1._rotationDirection.Y
	local v7 = noise(Element.CFrame.Rotation.Z / p1.Resolution + 0.1, p1.Seed + p1._t)
	local v9 = math.rad(math.clamp(v7, -1, 1) * p1.NoiseStrength(p1.Contrast + p1._t / 10)) * p1._rotationDirection.Z
	Element:UpdateCFrame(Element.CFrame * CFrame.new(-p1.Velocity * p2) * CFrame.Angles(v3, v6, v9))
	p1.Velocity = p1.VelocityDrag(p1.Velocity)
	if p1.Velocity.X < 0 or (p1.Velocity.Y < 0 or p1.Velocity.Z < 0) then
		p1:Destroy()
	end
	p1._t = p1._t + p2 * 60
end
function t.Destroy(p1) --[[ Destroy | Line: 79 ]]
	p1.Active = false
	p1.Velocity = Vector3.new(0, 0, 0)
	p1._rotationDirection = Vector3.new(0, 0, 0)
	task.delay(p1.TrailLife, function() --[[ Line: 83 | Upvalues: p1 (copy) ]]
		p1.Element:Destroy()
		p1.Active = false
	end)
end
setmetatable(t, {
	__index = function(p1, p2) --[[ __index | Line: 90 ]]
		error(string.format("%q is not a valid member of %q", tostring(p2), script.Name), 2)
	end
})
return t