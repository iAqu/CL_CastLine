-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
return function(p1) --[[ Line: 5 | Upvalues: ReplicatedStorage (copy), TweenService (copy) ]]
	local v1 = ReplicatedStorage.Objects.VFX.SlapVFX:Clone()
	v1.Parent = p1
	local v2 = ReplicatedStorage.Objects.VFX.HitGroundAttach:Clone()
	v2.Parent = p1
	local v3 = ReplicatedStorage.Objects.VFX.HitHighlight:Clone()
	v3.FillTransparency = 0
	v3.Parent = p1
	TweenService:Create(v3, TweenInfo.new(0.4), {
		FillTransparency = 1
	}):Play()
	local function Emit(p1) --[[ Emit | Line: 18 ]]
		for i, v in ipairs(p1:GetDescendants()) do
			if v:IsA("ParticleEmitter") then
				v:Emit(v:GetAttribute("EmitCount") or 1)
			end
		end
	end
	Emit(v2)
	task.delay(1, Emit, v1)
	game.Debris:AddItem(v1, 3)
	game.Debris:AddItem(v2, 3)
	game.Debris:AddItem(v3, 3)
end