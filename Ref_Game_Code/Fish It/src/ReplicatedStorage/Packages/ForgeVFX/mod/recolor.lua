-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local t = {
	Single = {
		Color3 = { "Decal", "Texture" },
		Color = { "Part", "Union", "MeshPart", "SpotLight", "PointLight", "SurfaceLight", "SurfaceAppearance" }
	},
	Sequence = {
		Color = { "Beam", "Trail", "ParticleEmitter" }
	}
}
local function warp(p1) --[[ warp | Line: 30 ]]
	return (p1 % 1 + 1) % 1
end
local function multiplyHue(p1, p2) --[[ multiplyHue | Line: 34 ]]
	return ((p1 + (p2 - 0.5) * 1) % 1 + 1) % 1
end
local function multiplyChannel(p1, p2) --[[ multiplyChannel | Line: 39 ]]
	local v1 = p2 * 2 - 1
	if v1 >= 0 then
		return math.clamp(p1 + (1 - p1) * v1, 0, 1)
	else
		return math.clamp(p1 - p1 * math.abs(v1), 0, 1)
	end
end
local function normalizeColor(p1) --[[ normalizeColor | Line: 49 ]]
	local R = p1.R
	local G = p1.G
	local B = p1.B
	local v1 = math.max(1, R, G, B)
	return v1, Color3.new(R / v1, G / v1, B / v1)
end
local function multiplyRGB(p1, p2) --[[ multiplyRGB | Line: 55 ]]
	return Color3.new(p1.R * p2, p1.G * p2, p1.B * p2)
end
local function recolorObj(p1, p2, p3, p4) --[[ recolorObj | Line: 59 | Upvalues: t (copy), multiplyRGB (copy) ]]
	if not p4 and p1:IsA("BasePart") then
		return
	end
	local v1, v2, v3 = p2:ToHSV()
	for v4, v5 in t do
		for v9, v10 in v5 do
			local v6, v7, v8
			if table.find(v10, p1.ClassName) then
				local v11 = p1[v9]
				if p3 == "multiply" then
					if typeof(v11) == "Color3" then
						local R = v11.R
						local G = v11.G
						local B = v11.B
						local v12 = math.max(1, R, G, B)
						local v13, v14, v15 = Color3.new(R / v12, G / v12, B / v12):ToHSV()
						local v17 = v2 * 2 - 1
						v6 = if v17 >= 0 then math.clamp(v14 + (1 - v14) * v17, 0, 1) else math.clamp(v14 - v14 * math.abs(v17), 0, 1)
						local v21 = v3 * 2 - 1
						if v21 >= 0 then
							v7, v8 = math.clamp(v15 + (1 - v15) * v21, 0, 1), v12
						else
							v7, v8 = math.clamp(v15 - v15 * math.abs(v21), 0, 1), v12
						end
						local v25 = Color3.fromHSV(((v13 + (v1 - 0.5) * 1) % 1 + 1) % 1, v6, v7)
						p1[v9] = Color3.new(v25.R * v8, v25.G * v8, v25.B * v8)
						continue
					end
					if typeof(v11) == "ColorSequence" then
						local t2 = {}
						for v29, v30 in v11.Keypoints do
							local v26, v27, v28
							local v31 = v30.Value
							local R = v31.R
							local G = v31.G
							local B = v31.B
							local v32 = math.max(1, R, G, B)
							local v33, v34, v35 = Color3.new(R / v32, G / v32, B / v32):ToHSV()
							local v37 = v2 * 2 - 1
							v26 = if v37 >= 0 then math.clamp(v34 + (1 - v34) * v37, 0, 1) else math.clamp(v34 - v34 * math.abs(v37), 0, 1)
							local v41 = v3 * 2 - 1
							if v41 >= 0 then
								v27, v28 = math.clamp(v35 + (1 - v35) * v41, 0, 1), v32
							else
								v27, v28 = math.clamp(v35 - v35 * math.abs(v41), 0, 1), v32
							end
							table.insert(t2, ColorSequenceKeypoint.new(v30.Time, multiplyRGB(Color3.fromHSV(((v33 + (v1 - 0.5) * 1) % 1 + 1) % 1, v26, v27), v28)))
						end
						p1[v9] = ColorSequence.new(t2)
					end
					continue
				end
				if typeof(v11) == "Color3" then
					local R = v11.R
					local G = v11.G
					local B = v11.B
					local v48 = math.max(1, R, G, B)
					Color3.new(R / v48, G / v48, B / v48)
					p1[v9] = Color3.new(p2.R * v48, p2.G * v48, p2.B * v48)
					continue
				end
				if typeof(v11) == "ColorSequence" then
					p1[v9] = ColorSequence.new(p2)
				end
			end
		end
	end
end
return function(p1, p2, ...) --[[ recolor | Line: 112 | Upvalues: recolorObj (copy) ]]
	for v1, v2 in { ... } do
		recolorObj(v2, p1, p2, true)
		for v3, v4 in v2:GetDescendants() do
			recolorObj(v4, p1, p2, false)
		end
	end
end