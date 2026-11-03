-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	new = function(p1) --[[ new | Line: 1 ]]
		local TweenService = p1.TweenService
		local billboardTemplate = p1.billboardTemplate
		local function getCrateItemChance(p1, p2, p3) --[[ getCrateItemChance | Line: 5 ]]
			for i, v in ipairs(p1.crateItems) do
				if v.itemType == p2 and v.itemName == p3 then
					return v.chance
				end
			end
			return nil
		end
		local function formatChanceText(p1) --[[ formatChanceText | Line: 14 ]]
			if not p1 then
				return "??%"
			end
			local v1 = math.round(p1 * 10) / 10
			if v1 == math.floor(v1) then
				return ("%*%%"):format(v1)
			else
				return string.format("%.1f%%", v1)
			end
		end
		local function getBillboardAdornee(p1, p2) --[[ getBillboardAdornee | Line: 25 ]]
			if p2 then
				return p2
			end
			local Main = p1:FindFirstChild("Main")
			if Main and Main:IsA("BasePart") then
				return Main
			end
			local HumanoidRootPart = p1:FindFirstChild("HumanoidRootPart")
			if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
				return HumanoidRootPart
			end
			local PrimaryPart = p1.PrimaryPart
			if PrimaryPart then
				return PrimaryPart
			end
			local v1 = p1:FindFirstChildWhichIsA("BasePart")
			if v1 and v1:IsA("BasePart") then
				return v1
			else
				return nil
			end
		end
		return {
			getCrateItemChance = getCrateItemChance,
			formatChanceText = formatChanceText,
			createItemBillboard = function(p1, p2, p3, p4, p5, p6) --[[ createItemBillboard | Line: 48 | Upvalues: billboardTemplate (copy), getBillboardAdornee (copy), TweenService (copy) ]]
				local v1 = billboardTemplate:Clone()
				local Size = v1.Size
				v1.Size = UDim2.new(Size.X.Scale * 0.15, Size.X.Offset * 0.15, Size.Y.Scale * 0.15, Size.Y.Offset * 0.15)
				local v2 = getBillboardAdornee(p1, p6)
				if v2 then
					v1.Adornee = v2
				end
				v1.StudsOffset = Vector3.new(0, p5, 0)
				v1.Parent = p1
				TweenService:Create(v1, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
					Size = Size
				}):Play()
				local Frame = v1:FindFirstChild("Frame")
				if Frame and Frame:IsA("Frame") then
					local ItemName = Frame:FindFirstChild("ItemName")
					if ItemName and ItemName:IsA("TextLabel") then
						ItemName.Text = p2
					end
					local ItemLuck = Frame:FindFirstChild("ItemLuck")
					if ItemLuck and ItemLuck:IsA("TextLabel") then
						ItemLuck.Text = p3
						ItemLuck.TextColor3 = p4
						local v3 = ItemLuck:FindFirstChildWhichIsA("UIGradient")
						if v3 then
							v3.Color = ColorSequence.new(p4)
						end
					end
				end
				return v1
			end
		}
	end
}