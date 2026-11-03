-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local t = {
	Tag = ({
		Tag = "ShonGradient"
	}).Tag
}
t.__index = t
local t2 = {}
function t.new(p1) --[[ new | Line: 19 | Upvalues: t (copy) ]]
	local v2 = setmetatable({
		Gradient = p1,
		Initialized = false
	}, t)
	v2:_init()
	return v2
end
function t.Tick(p1, p2) --[[ Tick | Line: 30 ]]
	p1.Ticked = p1.Ticked + p2
	p1.Ticked = p1.Ticked % 3
	p1.Gradient.Offset = Vector2.new(math.lerp(p1.Start, p1.End, (math.clamp(p1.Ticked / 3, 0, 1))), 0)
end
function t._init(p1) --[[ _init | Line: 38 | Upvalues: Trove (copy), t2 (copy) ]]
	if not p1.Initialized then
		p1.Initialized = true
		p1.Trove = Trove.new()
		local Gradient = p1.Gradient
		local v1 = Gradient:FindFirstAncestorOfClass("BillboardGui")
		if v1 then
			local function UpdateGUI() --[[ UpdateGUI | Line: 50 | Upvalues: p1 (copy), v1 (copy) ]]
				p1.Enabled = v1.Enabled
			end
			p1.Enabled = v1.Enabled
			p1.Trove:Connect(v1:GetPropertyChangedSignal("Enabled"), UpdateGUI)
		end
		p1.Enabled = true
		p1.Start = -0.18
		p1.End = 0.32
		p1.Ticked = 0
		Gradient.Offset = Vector2.new(-0.18, 0)
		t2[p1.Gradient] = p1
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 70 | Upvalues: t2 (copy) ]]
	t2[p1.Gradient] = nil
	p1.Trove:Destroy()
end
RunService.PreRender:Connect(function(p1) --[[ Line: 76 | Upvalues: t2 (copy) ]]
	for k, v in pairs(t2) do
		if v.Enabled then
			v:Tick(p1)
		end
	end
end)
return t