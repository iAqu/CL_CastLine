-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Promise = require(ReplicatedStorage.Packages.Promise)
return function(p1, p2, p3) --[[ TweenAsync | Line: 9 | Upvalues: Promise (copy), TweenService (copy) ]]
	return Promise.new(function(p12, p22, p32) --[[ Line: 10 | Upvalues: TweenService (ref), p1 (copy), p2 (copy), p3 (copy) ]]
		local v1 = TweenService:Create(p1, p2, p3)
		if not p32(function() --[[ Line: 13 | Upvalues: v1 (copy) ]]
			v1:Cancel()
		end) then
			v1.Completed:Connect(p12)
			v1:Play()
		end
	end)
end