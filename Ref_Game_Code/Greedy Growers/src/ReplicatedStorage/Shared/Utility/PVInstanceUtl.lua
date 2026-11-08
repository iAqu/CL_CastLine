-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- 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

-- https://lua.expert/
return {
	SetTransparency = function(p1, p2, p3) --[[ SetTransparency | Line: 10 ]]
		local function setTransparency(p1, p2) --[[ setTransparency | Line: 12 ]]
			if p1:IsA("BasePart") then
				p1.Transparency = p2
			end
		end

		if not p1:CheckIfPVInstance(p2) then
			return
		end

		if p2:IsA("BasePart") and p2:IsA("BasePart") then
			p2.Transparency = p3
		end

		for v1, v2 in p2:GetDescendants() do
			if v2:IsA("BasePart") then
				v2.Transparency = p3
			end

			if v2:IsA("ParticleEmitter") or v2:IsA("PointLight") then
				v2.Enabled = if p3 == 0 then true else false
			end
		end
	end,
	GetCFrame = function(p1, p2) --[[ GetCFrame | Line: 31 ]]
		if not p1:CheckIfPVInstance(p2) then
			error("would have errored in PVInstanceUtl:CheckIfPVInstance() already")
		end

		if p2:IsA("BasePart") then
			return p2.CFrame
		end

		if p2:IsA("Model") then
			return p2:GetBoundingBox()
		end

		error("would have errored in PVInstanceUtl:CheckIfPVInstance() already")
	end,
	SetCFrame = function(p1, p2, p3) --[[ SetCFrame | Line: 46 ]]
		if not p1:CheckIfPVInstance(p2) then
			return
		end

		if p2:IsA("BasePart") then
			p2.CFrame = p3

			return
		end

		if not p2:IsA("Model") then
			return
		end

		assert(p2.PrimaryPart, "Models passed to PVInstanceUtl:SetCFrame() require a primary part")
		p2:PivotTo(p3)
	end,
	CheckIfPVInstance = function(p1, p2) --[[ CheckIfPVInstance | Line: 59 ]]
		assert(p2, "PVInstance:CheckIfPVInstance(): Argument nil")

		local v1 = p2:IsA("PVInstance")

		assert(v1, (("PVInstanceUtl:GetCFrame() can only be passed a PVInstance (Model or BasePart), got %*"):format(p2.ClassName)))

		return true
	end
}