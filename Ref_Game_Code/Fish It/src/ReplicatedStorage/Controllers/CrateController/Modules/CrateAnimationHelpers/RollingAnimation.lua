-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	new = function(p1) --[[ new | Line: 7 ]]
		local RenderStepped = p1.RenderStepped
		local Easing = p1.Easing
		local getItemToShow = p1.getItemToShow
		local normalizeItemModel = p1.normalizeItemModel
		local ensurePrimaryPart = p1.ensurePrimaryPart
		local setModelBaseParts = p1.setModelBaseParts
		return {
			performRollingAnimation = function(p1, p2, p3, p4, p5) --[[ performRollingAnimation | Line: 15 | Upvalues: getItemToShow (copy), normalizeItemModel (copy), ensurePrimaryPart (copy), setModelBaseParts (copy), RenderStepped (copy), Easing (copy) ]]
				local crateItems = p1.crateItems
				if #crateItems < 2 then
					return
				end
				local list = {}
				for i = 1, 15 do
					local v1 = crateItems[math.random(1, #crateItems)]
					if i == 15 then
						v1 = {
							chance = 0,
							itemType = p1.itemType,
							itemName = p1.itemName
						}
					end
					table.insert(list, v1)
				end
				local v2 = nil
				local v3 = nil
				local v4 = nil
				local v5 = if p5 <= 0 or p5 ~= p5 then 6 else p5
				local v6 = p2.Position.Y + v5 / 2
				local v7 = -math.clamp(v5 * 0.35, 1, 6)
				local v8 = math.clamp(v5 * 0.45, 2, 6)
				local v9 = v6 + v7
				for i, v in ipairs(list) do
					local v10 = (i - 1) / 14
					local v11 = v10 * v10 * v10 * 0.32 + 0.08
					local v12 = v10 * v10
					local v13 = if i == 15 then true else false
					if v2 then
						v2:Destroy()
						v2 = nil
					end
					local v14 = getItemToShow(v.itemType, v.itemName, v.itemName, p1.caseId, p4)
					if v14 then
						local v15 = normalizeItemModel(v14)
						ensurePrimaryPart(v15)
						setModelBaseParts(v15)
						v15.Parent = workspace
						if not v13 then
							local Highlight = Instance.new("Highlight")
							Highlight.FillColor = Color3.fromRGB(0, 0, 0)
							Highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
							Highlight.FillTransparency = 0
							Highlight.OutlineTransparency = 1
							Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
							Highlight.Parent = v15
						end
						for i2, v16 in ipairs(v15:GetDescendants()) do
							if v16:IsA("BasePart") then
								v16.Anchored = true
							end
						end
						if v13 then
							v15:ScaleTo(1)
						else
							v15:ScaleTo(0.001)
						end
						local v16 = v15
						local v17 = v9
						local v18 = v6 + (v7 + (v8 - v7) * v12) + v16:GetExtentsSize().Y / 2
						if v13 then
							v18 = v17
						end
						local v19 = math.max(v18, v17)
						if v13 then
							v4 = v16
							v3 = v19
						end
						RenderStepped(function(p1, p22) --[[ Line: 109 | Upvalues: Easing (ref), v17 (copy), v19 (copy), p2 (copy), p3 (copy), v16 (copy), v13 (copy) ]]
							local v1 = math.clamp(p22, 0, 1)
							local v3 = Vector3.new(p2.Position.X, v17 + (v19 - v17) * Easing.ExpoInOut(v1), p2.Position.Z)
							local v4 = Vector3.new(p3.X, v3.Y, p3.Z)
							v16:PivotTo((v3 - v4).Magnitude < 0.001 and CFrame.new(v3) or CFrame.lookAt(v3, v4))
							if v13 then
								return
							end
							v16:ScaleTo((Easing.ExpoInOut((math.min(v1 * 3.33, 1)))))
						end, v11, true):Wait()
						v9 = v19
						v2 = v15
						continue
					end
					task.wait(v11)
				end
				if v2 and v2 ~= v4 then
					v2:Destroy()
				end
				return v4, v3
			end
		}
	end
}