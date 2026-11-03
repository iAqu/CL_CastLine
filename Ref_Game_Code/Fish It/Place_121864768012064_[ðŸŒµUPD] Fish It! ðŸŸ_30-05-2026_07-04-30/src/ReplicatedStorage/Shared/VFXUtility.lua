-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ForgeVFX = require(ReplicatedStorage.Packages.ForgeVFX)
ForgeVFX.init()
local VFX = ReplicatedStorage:WaitForChild("VFX")
return {
	IsSpecialVFX = function(p1, p2) --[[ IsSpecialVFX | Line: 22 | Upvalues: ReplicatedStorage (copy) ]]
		return ReplicatedStorage.Controllers.VFXController.Effects:FindFirstChild(p2) and true or false
	end,
	Contains = function(p1, p2) --[[ Contains | Line: 32 | Upvalues: VFX (copy) ]]
		return VFX:FindFirstChild(p2) and true or false
	end,
	NewContainer = function(p1, p2) --[[ NewContainer | Line: 41 | Upvalues: VFX (copy) ]]
		local v1 = VFX:FindFirstChild(p2)
		if not v1 then
			return
		end
		local v2 = v1:Clone()
		if v2:IsA("BasePart") then
			v2.Anchored = true
			v2.CanQuery = false
			return v2
		end
		if v2:IsA("PVInstance") then
			for i, v in ipairs(v2:GetDescendants()) do
				if v:IsA("BasePart") then
					v.Anchored = true
					v.CanQuery = false
				end
			end
		end
		return v2
	end,
	CreateContainer = function(p1, p2) --[[ CreateContainer | Line: 67 | Upvalues: VFX (copy) ]]
		local v1 = VFX:FindFirstChild(p2)
		if not v1 then
			return
		end
		local v2 = 0
		local t = {}
		local v3 = v1:Clone()
		if v3:IsA("BasePart") then
			v3.Anchored = true
			v3.CanQuery = false
		elseif v3:IsA("PVInstance") then
			for i, v in ipairs(v3:GetDescendants()) do
				if v:IsA("BasePart") then
					v.Anchored = true
					v.CanQuery = false
				end
			end
		end
		for i, v in ipairs(v3:GetDescendants()) do
			if v:IsA("ParticleEmitter") then
				local v4 = math.max(v.Lifetime.Max, v2)
				v.Enabled = false
				table.insert(t, v)
				v2 = v4
			end
		end
		return {
			Container = v3,
			MaxLifetime = v2,
			ParticleEmitters = t
		}
	end,
	Emit = function(p1) --[[ Emit | Line: 110 | Upvalues: ForgeVFX (copy) ]]
		ForgeVFX.emit(p1)
	end
}