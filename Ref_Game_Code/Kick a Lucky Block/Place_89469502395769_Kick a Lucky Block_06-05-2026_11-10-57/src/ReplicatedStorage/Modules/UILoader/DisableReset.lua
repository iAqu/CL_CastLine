-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local StarterGui = game:GetService("StarterGui")
local t = {}
function InitDisable() --[[ InitDisable | Line: 9 | Upvalues: StarterGui (copy) ]]
	repeat
		local v1 = pcall(function() --[[ Line: 11 | Upvalues: StarterGui (ref) ]]
			StarterGui:SetCore("ResetButtonCallback", false)
		end)
		task.wait(1)
	until v1
end
function t._init(p1) --[[ _init | Line: 20 ]]
	task.spawn(InitDisable)
end
return t