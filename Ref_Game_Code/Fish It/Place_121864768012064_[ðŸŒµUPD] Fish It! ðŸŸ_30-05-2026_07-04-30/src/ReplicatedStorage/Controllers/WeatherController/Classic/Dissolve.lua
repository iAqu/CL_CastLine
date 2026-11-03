-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Scheduler = require(script.Parent.Scheduler)
local PartPool = require(script.Parent.PartPool)
local t = {
	part = function(p1, p2, p3) --[[ part | Line: 8 | Upvalues: Scheduler (copy), PartPool (copy) ]]
		if p1.Parent then
			local v1 = p3 or Vector3.new(1, 1, 1)
			local Size = p1.Size
			local Transparency = p1.Transparency
			local v2 = p1.CFrame
			local v6 = Vector3.new(Size.X * v1.X, Size.Y * v1.Y, Size.Z * v1.Z)
			Scheduler.add(p2, function(p12) --[[ Line: 24 | Upvalues: p1 (copy), Size (copy), v6 (copy), v2 (copy), Transparency (copy) ]]
				if p1.Parent then
					local v1 = p12 * p12
					local v22 = Size - v6 * v1
					p1.Size = Vector3.new(math.max(v22.X, 0.001), math.max(v22.Y, 0.001), (math.max(v22.Z, 0.001)))
					p1.CFrame = v2
					p1.Transparency = Transparency + (1 - Transparency) * v1
					return nil
				else
					return true
				end
			end, function() --[[ Line: 44 | Upvalues: PartPool (ref), p1 (copy) ]]
				PartPool.returnOrDestroy(p1)
			end)
		end
	end
}
function t.container(p1, p2) --[[ container | Line: 49 | Upvalues: t (copy) ]]
	for v1, v2 in p1:GetDescendants() do
		if v2:IsA("BasePart") then
			t.part(v2, p2)
		end
	end
end
return t