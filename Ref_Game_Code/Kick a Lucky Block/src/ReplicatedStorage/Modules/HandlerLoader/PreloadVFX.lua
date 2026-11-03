-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
return {
	_init = function(p1) --[[ _init | Line: 6 | Upvalues: ContentProvider (copy), ReplicatedStorage (copy) ]]
		task.spawn(function() --[[ Line: 7 | Upvalues: ContentProvider (ref), ReplicatedStorage (ref) ]]
			ContentProvider:PreloadAsync(ReplicatedStorage.Objects.VFX:GetChildren())
		end)
	end
}