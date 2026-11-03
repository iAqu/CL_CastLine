-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Tags = require(ReplicatedStorage.Shared.Data.Tags)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local t2 = {}
t2.__index = t2
t2.Tag = ({
	Tag = Tags.NPCClass
}).Tag
function t2.new(p1) --[[ new | Line: 17 | Upvalues: t2 (copy), Trove (copy) ]]
	local v2 = setmetatable({}, t2)
	v2.Model = p1
	v2.Trove = Trove.new()
	v2.Initialized = false
	task.spawn(function() --[[ Line: 24 | Upvalues: v2 (copy) ]]
		v2:_init()
	end)
	return v2
end
function t2._init(p1) --[[ _init | Line: 31 ]]
	if not p1.Initialized then
		p1.Initialized = true
		local Trove = p1.Trove
		local Animator = p1.Model:WaitForChild("Humanoid"):FindFirstChild("Animator")
		if Animator then
			local Animation = p1.Model:FindFirstChildOfClass("Animation")
			if Animation then
				local v1 = Animator:LoadAnimation(Animation)
				v1.Looped = true
				v1:Play()
				v1.TimePosition = workspace.DistributedGameTime % v1.Length
				Trove:Add(function() --[[ Line: 62 | Upvalues: v1 (copy) ]]
					v1:Destroy()
				end)
			else
				p1:Destroy()
			end
		else
			p1:Destroy()
		end
	end
end
function t2.Destroy(p1) --[[ Destroy | Line: 68 ]]
	p1.Trove:Destroy()
end
return t2