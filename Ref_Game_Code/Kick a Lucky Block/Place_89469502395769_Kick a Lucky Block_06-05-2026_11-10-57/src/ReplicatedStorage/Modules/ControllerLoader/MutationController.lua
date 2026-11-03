-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MutationService = require(ReplicatedStorage.Shared.Services.MutationService)
local Observers = require(ReplicatedStorage.Shared.Packages.Observers)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local Tags = require(ReplicatedStorage.Shared.Data.Tags)
local MutationData = require(ReplicatedStorage.Shared.Data.MutationData)
local t = {}
function LoadMutation(p1) --[[ LoadMutation | Line: 16 | Upvalues: MutationService (copy), Trove (copy), MutationData (copy), Tags (copy), ReplicatedStorage (copy) ]]
	local v1 = MutationService:GetMutationsFromInstance(p1)
	if v1 and (typeof(v1) == "table" and #v1 ~= 0) then
		local v2 = Trove.new()
		local v3 = v1[1]
		local t = {}
		local v4 = MutationData.Properties[v3]
		if v4 then
			for i, v in ipairs(p1:GetChildren()) do
				if (v:IsA("MeshPart") or (v:IsA("BasePart") or v:IsA("Part"))) and not v:HasTag(Tags._CP) then
					t[v] = {}
					for k, v5 in pairs(v4) do
						t[v][k] = v[k]
						v[k] = v5
					end
					local v5 = v:FindFirstChildWhichIsA("SurfaceAppearance")
					if v5 then
						local v6 = MutationData.SurfaceApearances[v3]
						if v6 then
							t[v]._SurfaceAppearanceColor = v5.Color
							v5.Color = v6
						end
					end
				end
			end
		end
		local v7 = ReplicatedStorage.Objects.VFX.MutationVFX:FindFirstChild(v3)
		if v7 and p1.PrimaryPart then
			local v8 = v2:Clone(v7)
			local PrimaryPart = p1.PrimaryPart
			v8.Size = PrimaryPart.Size
			local v9 = v2:Add(Instance.new("Weld"))
			v9.Part0 = PrimaryPart
			v9.Part1 = v8
			v9.Parent = v8
			v8.Parent = p1
		end
		local v10 = MutationData.SpecialFunctions[v3]
		if v10 then
			v2:Add(v10(p1))
		end
		return function() --[[ Line: 69 | Upvalues: v2 (copy), p1 (copy), t (copy) ]]
			v2:Clean()
			if p1 then
				for k, v in pairs(t) do
					for k2, v3 in pairs(v) do
						if k2 == "_SurfaceAppearanceColor" then
							local v1 = k:FindFirstChildWhichIsA("SurfaceAppearance")
							if v1 then
								v1.Color = v3
							end
							continue
						end
						k[k2] = v3
					end
				end
			end
		end
	end
end
function t._init() --[[ _init | Line: 89 | Upvalues: MutationData (copy), Observers (copy) ]]
	for i, v in ipairs(MutationData.ValidMutations) do
		Observers.observeTag(v, LoadMutation)
	end
end
return t