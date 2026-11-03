-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
game:GetService("Debris")
local v1 = require(script.Instance)
local Part = require(script.Part)
local t = {}
t.__index = t
math.randomseed(os.time())
local function ReconcileInv(p1, p2) --[[ ReconcileInv | Line: 14 ]]
	for k, v in pairs(p2) do
		if p1[k] then
			p1[k] = v
		end
	end
	return p1
end
local function gaussianRandom(p1, p2) --[[ gaussianRandom | Line: 23 ]]
	local v1, v2
	repeat
		v1 = 2 * math.random() - 1
		local v3 = 2 * math.random() - 1
		v2 = math.pow(v1, 2) + math.pow(v3, 2)
	until v2 ~= 0 and v2 < 1
	return p1 + p2 * v1 * math.sqrt(math.log(v2) * -2 / v2)
end
function randomPointInSphere(p1) --[[ randomPointInSphere | Line: 35 | Upvalues: gaussianRandom (copy) ]]
	local v1 = 6.283185307179586 * math.random()
	local v3 = math.acos(2 * math.random() - 1)
	local v5 = math.min(gaussianRandom(0, p1 / 3), p1)
	return v5 * math.sin(v3) * math.cos(v1), v5 * math.sin(v3) * math.sin(v1), v5 * math.cos(v3)
end
function t.new(p1, p2, p3, p4) --[[ new | Line: 49 | Upvalues: t (copy) ]]
	assert(if type(p1) == "number" then true else false, "amount must be a number")
	assert(if typeof(p2) == "Instance" then true else false, "part must be an instance")
	assert(if typeof(p3) == "Vector3" then true else false, "origin must be a Vector3")
	assert(if typeof(p4) == "Vector3" then true else false, "direction must be a Vector3")
	local t2 = {
		XAngle = 30,
		YAngle = 30,
		ZAngle = 0,
		Radius = 10,
		DirectionRelativeToOrigin = false,
		_running = false,
		RenderPriority = Enum.RenderPriority.Last.Value,
		Origin = p3,
		Direction = p4,
		Amount = p1,
		Part = p2
	}
	t2._renderName = ("WindParticles_%s"):format((tostring(os.clock())))
	t2._instances = {}
	t2._removeInstances = {}
	t2._rng = Random.new(os.clock())
	return setmetatable(t2, t)
end
function t.Start(p1) --[[ Start | Line: 79 | Upvalues: RunService (copy) ]]
	if not p1._running then
		p1._running = true
		RunService:BindToRenderStep(p1._renderName, p1.RenderPriority, function(p12) --[[ Line: 84 | Upvalues: p1 (copy) ]]
			debug.profilebegin("particle simulation")
			p1:Update(p12)
			debug.profileend()
		end)
	end
end
function t.Simulate(p1, p2) --[[ Simulate | Line: 91 | Upvalues: Part (copy), v1 (copy) ]]
	assert(if type(p2) == "table" then true else false, "properties must be of type WindInstance")
	for i = 1, p1.Amount do
		local v2 = Part.new(p1.Part)
		v2:UpdateCFrame(CFrame.new(p1.Origin, p1.Direction))
		if p1.DirectionRelativeToOrigin then
			v2:UpdateCFrame(v2.CFrame * CFrame.new(randomPointInSphere(p1.Radius)))
			v2:UpdateCFrame(CFrame.lookAt(v2.CFrame.Position, p1.Origin) * CFrame.Angles(math.pi, 0, 0))
		else
			local v3 = v2.CFrame * CFrame.new(randomPointInSphere(p1.Radius))
			v2:UpdateCFrame(v3 * CFrame.Angles(math.rad((p1._rng:NextNumber(-p1.XAngle, p1.XAngle))), math.rad((p1._rng:NextNumber(-p1.YAngle, p1.YAngle))), (math.rad(p1.ZAngle))))
		end
		local v8 = v1.new(p2.Velocity)
		for k, v in pairs(p2) do
			if v8[k] then
				v8[k] = v
			end
		end
		v8.Velocity = v8.Velocity * p1._rng:NextNumber(v8.MinSpeedMult, v8.MaxSpeedMult)
		v8.Lifetime = p1._rng:NextNumber(v8.FadeIn, v8.FadeOut)
		v8.Element = v2
		p1._instances[#p1._instances + 1] = v8
	end
end
function t.Update(p1, p2) --[[ Update | Line: 132 ]]
	local _instances = p1._instances
	for i = 1, #_instances do
		local v1 = _instances[i]
		if v1.Active == false then
			p1._removeInstances[#p1._removeInstances + 1] = i
			continue
		end
		v1:Update(p2)
	end
	for j = #p1._removeInstances, 1, -1 do
		table.remove(_instances, p1._removeInstances[j])
		p1._removeInstances[j] = nil
	end
end
function t.Stop(p1) --[[ Stop | Line: 152 | Upvalues: RunService (copy) ]]
	if p1._running then
		RunService:UnbindFromRenderStep(p1._renderName)
		p1._running = false
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 160 ]]
	p1:Stop()
	for v1, v2 in p1._instances do
		v2:Destroy()
	end
	p1._instances = nil
end
setmetatable(t, {
	__index = function(p1, p2) --[[ __index | Line: 169 ]]
		error(string.format("%q is not a valid member of %q", tostring(p2), script.Name), 2)
	end
})
return t