-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Tags = require(ReplicatedStorage.Shared.Data.Tags)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local t = {
	LastFrame = nil,
	Tag = Tags.Frame
}
local t2 = {
	Tag = t.Tag
}
t2.__index = t2
function t2.new(p1) --[[ new | Line: 24 | Upvalues: t2 (copy) ]]
	local v2 = setmetatable({
		Object = p1,
		Initialized = false
	}, t2)
	v2:_init()
	return v2
end
function t2.PopUp(p1) --[[ PopUp | Line: 35 | Upvalues: TweenService (copy) ]]
	p1.Object.UIScale.Scale = 0.8
	TweenService:Create(p1.Object.UIScale, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Scale = 1
	}):Play()
end
function t2.InitAnimations(p1) --[[ InitAnimations | Line: 40 | Upvalues: t (copy) ]]
	local Object = p1.Object
	Instance.new("UIScale").Parent = Object
	p1.Trove:Add(Object:GetPropertyChangedSignal("Visible"):Connect(function() --[[ Line: 47 | Upvalues: Object (copy), t (ref), p1 (copy) ]]
		if Object.Visible then
			if t.LastFrame and t.LastFrame ~= Object then
				t.LastFrame.Visible = false
			end
			t.LastFrame = Object
			p1:PopUp()
		end
	end))
end
function t2._init(p1) --[[ _init | Line: 61 | Upvalues: Trove (copy) ]]
	if not p1.Initialized then
		p1.Initialized = true
		p1.Trove = Trove.new()
		p1:InitAnimations()
	end
end
function t2.Destroy(p1) --[[ Destroy | Line: 70 ]]
	p1.Trove:Destroy()
end
return t2