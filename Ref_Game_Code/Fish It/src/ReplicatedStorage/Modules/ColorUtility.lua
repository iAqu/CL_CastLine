-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	AddStripes = function(p1, p2) --[[ AddStripes | Line: 5 ]]
		local t = {}
		for i = 0, 7 do
			local v1 = ColorSequenceKeypoint.new
			table.insert(t, v1(i / 7, p2[i % 2 + 1]))
		end
		return ColorSequence.new(t)
	end,
	BlendColors = function(p1, p2) --[[ BlendColors | Line: 18 ]]
		if #p2 == 0 then
			return ColorSequence.new(Color3.new(255/255, 255/255, 255/255))
		end
		if #p2 == 1 then
			return p2[1]
		end
		local t = {}
		for i, v in ipairs(p2) do
			local v1 = (i - 1) / #p2
			local v2 = if i == #p2 then 1 else i / #p2 - 0.05
			for i2, v3 in ipairs(v.Keypoints) do
				local v4 = ColorSequenceKeypoint.new
				local v5 = math.min(v1 + v3.Time / #p2, v2)
				table.insert(t, v4(v5, v3.Value))
			end
		end
		return ColorSequence.new(t)
	end
}