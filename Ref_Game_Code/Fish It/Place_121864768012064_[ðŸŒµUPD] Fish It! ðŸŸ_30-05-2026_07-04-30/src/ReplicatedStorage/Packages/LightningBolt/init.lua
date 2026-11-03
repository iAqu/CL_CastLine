-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TweenService = game:GetService("TweenService")
local v1 = require(script.Class)()
local Part = Instance.new("Part")
Part.Anchored = true
Part.CanCollide = false
Part.CanQuery = false
Part.CanTouch = false
function v1.init(p1, p2, p3, p4) --[[ init | Line: 45 ]]
	if typeof(p2) ~= "Vector3" then
		error("LightningBolt: `from` must be a Vector3")
	end
	if typeof(p3) ~= "Vector3" then
		error("LightningBolt: `to` must be a Vector3")
	end
	p1.options = if p4 then p4 else {}
	if p1.options.seed then
		p1.random = Random.new(p1.options.seed)
	else
		p1.random = Random.new()
	end
	p1.depth = p1.options.depth or 0
	p1.origin = p2
	p1.goal = p3
	p1.rep = p1.options.bends or 6
	if p1.options.color then
		if typeof(p1.options.color) == "Color3" then
			p1.color = p1.options.color
		elseif typeof(p1.options.color) == "BrickColor" then
			p1.color = p1.options.color.Color
		else
			error("LightningBolt: `Options.color` must be a Color3 or BrickColor")
		end
	else
		p1.color = BrickColor.new("White").Color
	end
	p1.material = p1.options.material or Enum.Material.Neon
	p1.branches = {}
	p1.lines = {
		{
			origin = p2,
			goal = p3,
			transparency = p1.options.transparency or 0.4,
			thickness = p1.options.thickness or 1,
			depth = p1.depth
		}
	}
	p1:generateBolt()
end
function v1.GetOptions(p1) --[[ GetOptions | Line: 95 ]]
	local t = {}
	for k, v in pairs(p1.options) do
		t[k] = v
	end
	return t
end
function v1.GetLines(p1) --[[ GetLines | Line: 103 ]]
	local t = {}
	for i = 1, #p1.lines do
		t[i] = p1.lines[i]
	end
	for j = 1, #p1.branches do
		local v1 = p1.branches[j]:GetLines()
		for k = 1, #v1 do
			t[#t + 1] = v1[k]
		end
	end
	return t
end
function v1.IsDestroyed(p1) --[[ IsDestroyed | Line: 117 ]]
	return p1.destroyed or false
end
function v1.IsDrawn(p1) --[[ IsDrawn | Line: 121 ]]
	return p1.drew or false
end
function v1.generateBolt(p1) --[[ generateBolt | Line: 125 ]]
	for i = 1, p1.rep do
		p1:bend()
	end
end
function v1.displace(p1, p2, p3, p4, p5) --[[ displace | Line: 131 ]]
	return (CFrame.new(p2, p3) * CFrame.new(math.sin(math.pi * p5 * 2) * p4, math.cos(math.pi * p5 * 2) * p4, 0)).p
end
function v1.bend(p1) --[[ bend | Line: 135 | Upvalues: v1 (copy) ]]
	for i = 1, #p1.lines do
		local v12 = p1.lines[i]
		local goal = v12.goal
		v12.goal = p1:displace(v12.origin + (v12.goal - v12.origin).unit * (v12.goal - v12.origin).magnitude * p1.random:NextInteger(40, 60) / 100, v12.goal, p1.random:NextInteger(-530, 530) / 100, p1.random:NextNumber())
		p1.lines[#p1.lines + 1] = {
			origin = v12.goal,
			goal = goal,
			transparency = v12.transparency,
			thickness = v12.thickness,
			depth = v12.depth
		}
		if v12.depth <= (p1.options.max_depth or 3) and p1.random:NextInteger(1, 100) < (p1.options.fork_chance or 50) * ((p1.origin - v12.goal).magnitude / (p1.origin - p1.goal).magnitude) then
			local v3 = p1:GetOptions()
			v3.depth = v12.depth + 1
			v3.bends = v3.fork_bends or 2
			p1.branches[#p1.branches + 1] = v1(v12.goal, v12.goal + (v12.goal - v12.origin).unit * p1.random:NextInteger(20, 40), v3)
		end
	end
end
function v1.Draw(p1, p2) --[[ Draw | Line: 163 | Upvalues: Part (copy), TweenService (copy) ]]
	p1.drew = true
	local LightningBolt = Instance.new("Model")
	p1.model = LightningBolt
	LightningBolt.Name = "LightningBolt"
	local v1 = Part:Clone()
	v1.Material = p1.material
	v1.Color = p1.color
	local v2 = p1:GetLines()
	for i = 1, #v2 do
		local v3 = v2[i]
		local v4 = v1:Clone()
		v4.Size = Vector3.new(v3.thickness, v3.thickness, (v3.origin - v3.goal).magnitude + 0.1)
		v4.CFrame = CFrame.new((v3.goal + v3.origin) / 2, v3.goal)
		v4.Transparency = v3.transparency
		v4.Parent = LightningBolt
	end
	LightningBolt.Parent = if p2 then p2 else workspace
	if not p1.options.decay then
		return
	end
	task.delay(p1.options.decay, function() --[[ Line: 188 | Upvalues: LightningBolt (copy), TweenService (ref), p1 (copy) ]]
		local list = {}
		for i, v in ipairs(LightningBolt:GetChildren()) do
			local v1 = TweenService:Create(v, TweenInfo.new(0.24, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				Transparency = 1
			})
			table.insert(list, v1)
			v1:Play()
		end
		list[1].Completed:Wait()
		LightningBolt:Destroy()
		for i, v in ipairs(list) do
			v:Cancel()
			v:Destroy()
		end
		table.clear(list)
		p1.destroyed = true
	end)
end
function v1.Destroy(p1) --[[ Destroy | Line: 213 ]]
	if not p1.model then
		return
	end
	p1.model:Destroy()
	p1.destroyed = true
end
return setmetatable({
	new = v1
}, {
	__call = function(p1, ...) --[[ __call | Line: 224 | Upvalues: v1 (copy) ]]
		return v1(...)
	end
})