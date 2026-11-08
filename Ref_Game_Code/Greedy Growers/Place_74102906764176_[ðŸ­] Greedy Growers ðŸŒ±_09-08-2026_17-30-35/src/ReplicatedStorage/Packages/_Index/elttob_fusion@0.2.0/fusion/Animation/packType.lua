-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- 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

-- https://lua.expert/
local v1 = script.Parent.Parent

require(v1.PubTypes)

local Oklab = require(v1.Colour.Oklab)

return function(p1, p2) --[[ packType | Line: 16 | Upvalues: Oklab (copy) ]]
	if p2 == "number" then
		return p1[1]
	end

	if p2 == "CFrame" then
		local v1 = CFrame.new(p1[1], p1[2], p1[3])

		return v1 * CFrame.fromAxisAngle(Vector3.new(p1[4], p1[5], p1[6]).Unit, p1[7])
	end

	if p2 == "Color3" then
		return Oklab.from(Vector3.new(p1[1], p1[2], p1[3]), false)
	end

	if p2 == "ColorSequenceKeypoint" then
		return ColorSequenceKeypoint.new(p1[4], Oklab.from(Vector3.new(p1[1], p1[2], p1[3]), false))
	end

	if p2 == "DateTime" then
		return DateTime.fromUnixTimestampMillis(p1[1])
	end

	if p2 == "NumberRange" then
		return NumberRange.new(p1[1], p1[2])
	end

	if p2 == "NumberSequenceKeypoint" then
		return NumberSequenceKeypoint.new(p1[2], p1[1], p1[3])
	end

	if p2 == "PhysicalProperties" then
		return PhysicalProperties.new(p1[1], p1[2], p1[3], p1[4], p1[5])
	end

	if p2 == "Ray" then
		return Ray.new(Vector3.new(p1[1], p1[2], p1[3]), (Vector3.new(p1[4], p1[5], p1[6])))
	end

	if p2 == "Rect" then
		return Rect.new(p1[1], p1[2], p1[3], p1[4])
	end

	if p2 == "Region3" then
		local v24 = Vector3.new(p1[1], p1[2], p1[3])
		local v28 = Vector3.new(p1[4] / 2, p1[5] / 2, p1[6] / 2)

		return Region3.new(v24 - v28, v24 + v28)
	end

	if p2 == "Region3int16" then
		return Region3int16.new(Vector3int16.new(p1[1], p1[2], p1[3]), Vector3int16.new(p1[4], p1[5], p1[6]))
	end

	if p2 == "UDim" then
		return UDim.new(p1[1], p1[2])
	end

	if p2 == "UDim2" then
		return UDim2.new(p1[1], p1[2], p1[3], p1[4])
	end

	if p2 == "Vector2" then
		return Vector2.new(p1[1], p1[2])
	end

	if p2 == "Vector2int16" then
		return Vector2int16.new(p1[1], p1[2])
	end

	if p2 == "Vector3" then
		return Vector3.new(p1[1], p1[2], p1[3])
	end

	if p2 == "Vector3int16" then
		return Vector3int16.new(p1[1], p1[2], p1[3])
	end

	return nil
end