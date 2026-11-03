-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local ContextActionService = game:GetService("ContextActionService")
local TweenService = game:GetService("TweenService")
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Trove = require(ReplicatedStorage.Packages.Trove)
local MarketplaceService = require(ReplicatedStorage.Packages.MarketplaceService)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local TierUtility = require(ReplicatedStorage.Shared.TierUtility)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local AbilitySpinProducts = require(ReplicatedStorage.Shared.Products.AbilitySpinProducts)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local AbilityPreviewController = require(ReplicatedStorage.Controllers.AbilityPreviewController)
local AbilityVFXController = require(ReplicatedStorage.Controllers.AbilityVFXController)
local GiftingController = require(ReplicatedStorage.Controllers.GiftingController)
local Abilities = require(ReplicatedStorage.Abilities)
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local v1 = Net:RemoteFunction("RequestAbilityRoll")
local v2 = Net:RemoteFunction("ConvertAbilityShards")
local v3 = Net:RemoteFunction("GetAbilityRewardProgress")
local v4 = Net:RemoteFunction("ClaimAbilityRewardProgress")
local v5 = Net:RemoteEvent("UnequipToolFromHotbar")
local t = {}
local v6 = nil
Trove.new()
local v7 = CFrame.new(0, -10000, 0) * CFrame.Angles(0, math.pi, 0)
local v8 = nil
local v9 = nil
local v10 = nil
local v11 = nil
local v12 = false
local v13 = false
local v14 = false
local v15 = false
local v16 = false
local v17 = 0
local t2 = {}
local v18 = nil
local v19 = nil
local v20 = false
local v21 = ""
local v22 = 0
local v23 = nil
local v24 = nil
local v25 = nil
local v26 = nil
local v27 = nil
local v28 = nil
local v29 = nil
local v30 = nil
local v31 = nil
local v32 = nil
local v33 = nil
local t3 = {}
local t4 = {}
local function getAbilityGui() --[[ getAbilityGui | Line: 92 | Upvalues: v8 (ref), v9 (ref), PlayerGui (copy) ]]
	if v8 and v9 then
		return v8, v9
	end
	local v1 = PlayerGui:WaitForChild("!!!! AbilityUI", 30)
	if not (v1 and v1:IsA("ScreenGui")) then
		return nil, nil
	end
	local AbilityUI = v1:WaitForChild("AbilityUI", 30)
	if AbilityUI and AbilityUI:IsA("Frame") then
		v8 = v1
		v9 = AbilityUI
		return v1, AbilityUI
	else
		return nil, nil
	end
end
local function getBuySpinsGui() --[[ getBuySpinsGui | Line: 113 | Upvalues: v10 (ref), PlayerGui (copy) ]]
	if v10 then
		return v10
	end
	local v1 = PlayerGui:FindFirstChild("!!!! BUY SPINS")
	if v1 and v1:IsA("ScreenGui") then
		v10 = v1
		return v1
	else
		return nil
	end
end
local function getRewardProgressGui() --[[ getRewardProgressGui | Line: 127 | Upvalues: v11 (ref), PlayerGui (copy) ]]
	if v11 then
		return v11
	end
	local v1 = PlayerGui:FindFirstChild("!!!! RewardProgress")
	if v1 and v1:IsA("ScreenGui") then
		v11 = v1
		return v1
	else
		return nil
	end
end
local function getTextNotificationsFrame() --[[ getTextNotificationsFrame | Line: 141 | Upvalues: PlayerGui (copy) ]]
	local v1 = PlayerGui:FindFirstChild("Text Notifications")
	if not v1 then
		return nil
	end
	local Frame = v1:FindFirstChild("Frame")
	if Frame and Frame:IsA("Frame") then
		return Frame
	else
		return nil
	end
end
local function applyTextNotificationsPosition() --[[ applyTextNotificationsPosition | Line: 155 | Upvalues: PlayerGui (copy), v30 (ref) ]]
	local v1 = PlayerGui:FindFirstChild("Text Notifications")
	local v2
	if v1 then
		local Frame = v1:FindFirstChild("Frame")
		v2 = if Frame and Frame:IsA("Frame") then Frame else nil
	else
		v2 = nil
	end
	if not v2 then
		return
	end
	if not v30 then
		v30 = v2.Position
	end
	v2.Position = UDim2.new(0.5, 0, 0, 168)
end
local function restoreTextNotificationsPosition() --[[ restoreTextNotificationsPosition | Line: 168 | Upvalues: PlayerGui (copy), v30 (ref) ]]
	local v1 = PlayerGui:FindFirstChild("Text Notifications")
	local v2
	if v1 then
		local Frame = v1:FindFirstChild("Frame")
		v2 = if Frame and Frame:IsA("Frame") then Frame else nil
	else
		v2 = nil
	end
	if not (v2 and v30) then
		v30 = nil
		return
	end
	v2.Position = v30
	v30 = nil
end
local function getTextLabel(p1, p2) --[[ getTextLabel | Line: 177 ]]
	if not p1 then
		return nil
	end
	local v1 = p1:FindFirstChild(p2, true)
	if v1 and v1:IsA("TextLabel") then
		return v1
	else
		return nil
	end
end
local function setButtonText(p1, p2) --[[ setButtonText | Line: 190 ]]
	if not p1 then
		return
	end
	local v1 = p1.Name
	local v2
	if p1 then
		local v3 = p1:FindFirstChild(v1, true)
		v2 = if v3 and v3:IsA("TextLabel") then v3 else nil
	else
		v2 = nil
	end
	if not v2 and p1 then
		local Label = p1:FindFirstChild("Label", true)
		v2 = if Label and Label:IsA("TextLabel") then Label else nil
	elseif not v2 then
		v2 = nil
	end
	if not v2 then
		return
	end
	v2.Text = p2
end
local function getShardCount() --[[ getShardCount | Line: 201 | Upvalues: ItemUtility (copy), v6 (ref) ]]
	local v1 = ItemUtility:GetItemData("Ability Shard")
	if not v1 then
		return 0
	end
	local v2 = v6:Get({ "Inventory", "Items" })
	if typeof(v2) ~= "table" then
		return 0
	end
	local sum = 0
	for i, v in ipairs(v2) do
		if v.Id == v1.Data.Id then
			sum = sum + (v.Quantity or 1)
		end
	end
	return sum
end
local function setLabelText(p1, p2, p3) --[[ setLabelText | Line: 222 ]]
	local v1 = if p1 then p1:FindFirstChild(p2, true) else p1
	if not (v1 and v1:IsA("TextLabel")) then
		return
	end
	v1.Text = p3
end
local function setImage(p1, p2, p3) --[[ setImage | Line: 229 ]]
	local v1 = if p1 then p1:FindFirstChild(p2, true) else p1
	if not (v1 and (v1:IsA("ImageLabel") or v1:IsA("ImageButton"))) then
		return
	end
	v1.Image = p3
end
local function setProgressNotificationVisible(p1) --[[ setProgressNotificationVisible | Line: 236 | Upvalues: v20 (ref), v27 (ref) ]]
	v20 = p1
	v27.Visible = p1
end
local function updateProgressButtonVisuals(p1) --[[ updateProgressButtonVisuals | Line: 241 | Upvalues: v21 (ref), v23 (ref), v26 (ref), v20 (ref), v27 (ref) ]]
	if p1 and typeof(p1.RewardIcon) == "string" then
		v21 = p1.RewardIcon
	end
	if v23 ~= nil then
		local v1
		v26.Image = v21
		v1 = v20
		v27.Visible = v20
		return
	end
	v23 = v26.Rotation
	v26.Image = v21
	v27.Visible = v20
end
local function tweenRodIconRotation(p1, p2) --[[ tweenRodIconRotation | Line: 254 | Upvalues: TweenService (copy), v26 (ref), v24 (ref) ]]
	local v1 = TweenService:Create(v26, TweenInfo.new(p2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Rotation = p1
	})
	v24 = v1
	v1:Play()
	v1.Completed:Wait()
	if v24 == v1 then
		v24 = nil
	end
	v1:Destroy()
end
local function resetProgressRodIcon() --[[ resetProgressRodIcon | Line: 267 | Upvalues: v22 (ref), v24 (ref), v23 (ref), v26 (ref) ]]
	v22 = v22 + 1
	if v24 then
		v24:Cancel()
		v24:Destroy()
		v24 = nil
	end
	if not v23 then
		return
	end
	v26.Rotation = v23
end
local function backflipProgressRodIcon() --[[ backflipProgressRodIcon | Line: 280 | Upvalues: v23 (ref), v26 (ref), tweenRodIconRotation (copy), PlayerGui (copy) ]]
	task.spawn(function() --[[ Line: 281 | Upvalues: v23 (ref), v26 (ref), tweenRodIconRotation (ref), PlayerGui (ref) ]]
		local v1 = v23 or v26.Rotation
		v23 = v1
		v26.Rotation = v1
		tweenRodIconRotation(v1 + 360, 0.45)
		if not v26:IsDescendantOf(PlayerGui) then
			return
		end
		v26.Rotation = v1
	end)
end
local function wiggleProgressRodIcon() --[[ wiggleProgressRodIcon | Line: 292 | Upvalues: v23 (ref), v26 (ref), tweenRodIconRotation (copy) ]]
	local v1 = v23 or v26.Rotation
	v23 = v1
	tweenRodIconRotation(v1 - 12, 0.08)
	tweenRodIconRotation(v1 + 12, 0.12)
	tweenRodIconRotation(v1 - 8, 0.1)
	tweenRodIconRotation(v1, 0.1)
end
local function startProgressRodWiggleLoop() --[[ startProgressRodWiggleLoop | Line: 301 | Upvalues: v22 (ref), v8 (ref), v23 (ref), v26 (ref), tweenRodIconRotation (copy) ]]
	v22 = v22 + 1
	local v1 = v22
	task.spawn(function() --[[ Line: 305 | Upvalues: v1 (copy), v22 (ref), v8 (ref), v23 (ref), v26 (ref), tweenRodIconRotation (ref) ]]
		task.wait(3)
		while v1 == v22 do
			local v12 = v8
			if not (v12 and v12.Enabled) then
				break
			end
			local v2 = v23 or v26.Rotation
			v23 = v2
			tweenRodIconRotation(v2 - 12, 0.08)
			tweenRodIconRotation(v2 + 12, 0.12)
			tweenRodIconRotation(v2 - 8, 0.1)
			tweenRodIconRotation(v2, 0.1)
			task.wait(15)
		end
	end)
end
local function getTextLabelTemplates(p1) --[[ getTextLabelTemplates | Line: 319 ]]
	local t = {}
	if not p1 then
		return t
	end
	for i, v in ipairs(p1:GetChildren()) do
		if v:IsA("TextLabel") then
			table.insert(t, v)
		end
	end
	table.sort(t, function(p1, p2) --[[ Line: 331 ]]
		return p1.LayoutOrder < p2.LayoutOrder
	end)
	return t
end
local function getAbilityRarityColor(p1) --[[ getAbilityRarityColor | Line: 338 | Upvalues: Abilities (copy), TierUtility (copy) ]]
	local v1 = Abilities[p1]
	if v1 then
		return TierUtility:GetTier(v1.Data.Tier or 1).TierColor.Keypoints[1].Value
	else
		return Color3.fromRGB(255, 255, 255)
	end
end
local function renderNameList(p1, p2) --[[ renderNameList | Line: 348 | Upvalues: getTextLabelTemplates (copy), Abilities (copy), TierUtility (copy) ]]
	local v1 = getTextLabelTemplates(p1)
	if #v1 == 0 then
		return
	end
	local v2 = v1[1]
	for i, v in ipairs(p2) do
		local v3
		local v4 = v1[i]
		if not v4 then
			local v5 = v2:Clone()
			v5.Parent = p1
			v1[i] = v5
			v4 = v5
		end
		v4.LayoutOrder = i
		v4.Visible = true
		v4.Text = v
		local v6 = Abilities[v]
		v3 = if v6 then TierUtility:GetTier(v6.Data.Tier or 1).TierColor.Keypoints[1].Value else Color3.fromRGB(255, 255, 255)
		v4.TextColor3 = v3
	end
	for i = #p2 + 1, #v1 do
		v1[i].Visible = false
	end
end
local function renderAbilitiesCollect(p1) --[[ renderAbilitiesCollect | Line: 374 | Upvalues: v11 (ref), PlayerGui (copy), t2 (copy), Abilities (copy), TierUtility (copy) ]]
	local v1
	if v11 then
		v1 = v11
	else
		local v2 = PlayerGui:FindFirstChild("!!!! RewardProgress")
		if v2 and v2:IsA("ScreenGui") then
			v11 = v2
			v1 = v2
		else
			v1 = nil
		end
	end
	local v3 = if v1 then v1:FindFirstChild("Main") else v1
	if not v3 then
		return
	end
	local AbilitiesCollect = v3:FindFirstChild("AbilitiesCollect")
	local v4 = if AbilitiesCollect then AbilitiesCollect:FindFirstChild("Items") else AbilitiesCollect
	local v5 = if v4 then v4:FindFirstChildOfClass("UIListLayout") else v4
	local v6 = if v5 then v5:FindFirstChild("AbilityCase") else v5
	if not (v4 and v6) then
		return
	end
	local t = {}
	for v7, v8 in v4:GetChildren() do
		if v8:IsA("Frame") and v8.Name == "AbilityCase" then
			table.insert(t, v8)
		end
	end
	table.sort(t, function(p1, p2) --[[ Line: 396 ]]
		return p1.LayoutOrder < p2.LayoutOrder
	end)
	for v10, v112 in t2 do
		local v9
		local v12 = t[v10]
		if not v12 then
			local v13 = v6:Clone()
			v13.Parent = v4
			t[v10] = v13
			v12 = v13
		end
		local Title = v12:FindFirstChild("Title")
		if Title and Title:IsA("TextLabel") then
			Title.Text = v112
			local v14 = Abilities[v112]
			v9 = if v14 then TierUtility:GetTier(v14.Data.Tier or 1).TierColor.Keypoints[1].Value else Color3.fromRGB(255, 255, 255)
			Title.TextColor3 = v9
		end
		local CheckBox = v12:FindFirstChild("CheckBox")
		local v16 = if CheckBox then CheckBox:FindFirstChild("ImageLabel") else CheckBox
		if v16 and v16:IsA("ImageLabel") then
			v16.Visible = p1[v112] == true
		end
		v12.LayoutOrder = v10
		v12.Visible = true
	end
	for i = #t2 + 1, #t do
		t[i].Visible = false
	end
end
local function renderRewardProgress(p1) --[[ renderRewardProgress | Line: 429 | Upvalues: v11 (ref), PlayerGui (copy), getAbilityGui (copy), v21 (ref), v23 (ref), v26 (ref), v20 (ref), v27 (ref), renderNameList (copy), renderAbilitiesCollect (copy) ]]
	local v1
	if v11 then
		v1 = v11
	else
		local v2 = PlayerGui:FindFirstChild("!!!! RewardProgress")
		if v2 and v2:IsA("ScreenGui") then
			v11 = v2
			v1 = v2
		else
			v1 = nil
		end
	end
	local v3 = getAbilityGui()
	local v4 = if v1 then v1:FindFirstChild("Main") else v1
	if not (v4 and v3) then
		return
	end
	local v6 = tonumber(if p1 then p1.Current else p1) or 0
	local v9 = math.max(tonumber(if p1 then p1.Total else p1) or 0, 1)
	local v10 = if p1 then if p1.Completed == true then true else false else p1
	local v112 = if p1 then if p1.Claimed == true then true else false else p1
	local v13 = p1 and p1.RewardIcon or ""
	if p1 and typeof(p1.RewardIcon) == "string" then
		v21 = p1.RewardIcon
	end
	if v23 == nil then
		v23 = v26.Rotation
	end
	v26.Image = v21
	v27.Visible = v20
	local v15 = if v4 then v4:FindFirstChild("Label", true) else v4
	if v15 and v15:IsA("TextLabel") then
		v15.Text = "Ability Progress"
	end
	local v16 = ("Collect every ability to unlock %*."):format(p1 and p1.RewardName or "Reward")
	local v17 = if v4 then v4:FindFirstChild("Description", true) else v4
	if v17 and v17:IsA("TextLabel") then
		v17.Text = v16
	end
	local v18 = ("%*%% Completed"):format((math.round(v6 / v9 * 100)))
	local v19 = if v4 then v4:FindFirstChild("CurrentProgress", true) else v4
	if v19 and v19:IsA("TextLabel") then
		v19.Text = v18
	end
	local v202 = if v112 then "Claimed" elseif v10 then "Complete" else ("%* Left"):format(v9 - v6)
	local v22 = if v4 then v4:FindFirstChild("ClaimCount", true) else v4
	if v22 and v22:IsA("TextLabel") then
		v22.Text = v202
	end
	local v232 = if v4 then v4:FindFirstChild("Rod", true) else v4
	if v232 and (v232:IsA("ImageLabel") or v232:IsA("ImageButton")) then
		v232.Image = v13
	end
	local v24 = if v4 then v4:FindFirstChild("FishingRodVector", true) else v4
	if v24 and (v24:IsA("ImageLabel") or v24:IsA("ImageButton")) then
		v24.Image = v13
	end
	local ImageLabel = v4.Collected.Items.ImageLabel
	local v25 = if ImageLabel then ImageLabel:FindFirstChild("Rod", true) else ImageLabel
	if v25 and (v25:IsA("ImageLabel") or v25:IsA("ImageButton")) then
		v25.Image = v13
	end
	v3.AbilityUI.LeftUI.Progress.Notif.Visible = if v10 then not v112 else v10
	local BarBG = v4:FindFirstChild("BarBG")
	local v272 = if BarBG then BarBG:FindFirstChild("Bar") else BarBG
	if v272 and v272:IsA("Frame") then
		v272.Size = UDim2.new(math.clamp(v6 / v9, 0, 1), 0, v272.Size.Y.Scale, v272.Size.Y.Offset)
	end
	local Collected = v4:FindFirstChild("Collected", true)
	local v28 = if Collected then Collected:FindFirstChild("Items") else Collected
	local v30, v31
	if p1 then
		v30 = p1.Collected
		if v30 then
			v31 = v28
		else
			v31 = v28
			v30 = {}
		end
	else
		v31 = v28
		v30 = {}
	end
	renderNameList(v31, v30)
	local NotCollected = v4:FindFirstChild("NotCollected", true)
	local v32 = if NotCollected then NotCollected:FindFirstChild("Items") else NotCollected
	local v34, v35
	if p1 then
		v34 = p1.NotCollected
		if v34 then
			v35 = v32
		else
			v35 = v32
			v34 = {}
		end
	else
		v35 = v32
		v34 = {}
	end
	renderNameList(v35, v34)
	local t = {}
	for v38, v39 in ipairs(if p1 then p1.Collected or {} else {}) do
		t[v39] = true
	end
	renderAbilitiesCollect(t)
end
local function setEffectEnabled(p1, p2) --[[ setEffectEnabled | Line: 477 | Upvalues: Lighting (copy) ]]
	local v1 = Lighting:FindFirstChild(p1)
	if not (v1 and (v1:IsA("BlurEffect") or v1:IsA("DepthOfFieldEffect"))) then
		return nil
	end
	local Enabled = v1.Enabled
	v1.Enabled = p2
	return Enabled
end
local function applyAbilityCamera() --[[ applyAbilityCamera | Line: 488 | Upvalues: LocalPlayer (copy), AbilityPreviewController (copy), v31 (ref), v7 (copy), v32 (ref), Lighting (copy) ]]
	local CurrentCamera = workspace.CurrentCamera
	local Character = LocalPlayer.Character
	local v1 = AbilityPreviewController:GetRig() or Character
	if not (CurrentCamera and v1) then
		return
	end
	local HumanoidRootPart = v1:FindFirstChild("HumanoidRootPart")
	if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
		return
	end
	if v31 and v31._TargetPart then
		v31._TargetPart:Destroy()
		v31._TargetPart = nil
	end
	if not v31 then
		local Part = Instance.new("Part")
		Part.Anchored = true
		Part.Size = Vector3.new(1, 1, 1)
		Part.Transparency = 0
		Part.CanCollide = false
		Part.CanQuery = false
		Part.CFrame = v7
		v31 = {
			CameraType = CurrentCamera.CameraType,
			CameraSubject = CurrentCamera.CameraSubject,
			CFrame = CurrentCamera.CFrame,
			Focus = CurrentCamera.Focus,
			FieldOfView = CurrentCamera.FieldOfView,
			_TargetPart = Part
		}
	end
	if v32 then
		local Blur = Lighting:FindFirstChild("Blur")
		if Blur and (Blur:IsA("BlurEffect") or Blur:IsA("DepthOfFieldEffect")) then
			local Enabled = Blur.Enabled
			Blur.Enabled = false
		end
		local AbilityDepthOfField = Lighting:FindFirstChild("AbilityDepthOfField")
		if AbilityDepthOfField and (AbilityDepthOfField:IsA("BlurEffect") or AbilityDepthOfField:IsA("DepthOfFieldEffect")) then
			local Enabled = AbilityDepthOfField.Enabled
			AbilityDepthOfField.Enabled = true
		end
	else
		local t = {}
		local Blur = Lighting:FindFirstChild("Blur")
		local v2
		if Blur and (Blur:IsA("BlurEffect") or Blur:IsA("DepthOfFieldEffect")) then
			local Enabled = Blur.Enabled
			Blur.Enabled = false
			v2 = Enabled
		else
			v2 = nil
		end
		t.BlurEnabled = v2
		local AbilityDepthOfField = Lighting:FindFirstChild("AbilityDepthOfField")
		local v3
		if AbilityDepthOfField and (AbilityDepthOfField:IsA("BlurEffect") or AbilityDepthOfField:IsA("DepthOfFieldEffect")) then
			local Enabled = AbilityDepthOfField.Enabled
			AbilityDepthOfField.Enabled = true
			v3 = Enabled
		else
			v3 = nil
		end
		t.AbilityDepthOfFieldEnabled = v3
		v32 = t
	end
	task.defer(function() --[[ Line: 536 | Upvalues: Lighting (ref) ]]
		local Blur = Lighting:FindFirstChild("Blur")
		if Blur and (Blur:IsA("BlurEffect") or Blur:IsA("DepthOfFieldEffect")) then
			local Enabled = Blur.Enabled
			Blur.Enabled = false
		end
		local AbilityDepthOfField = Lighting:FindFirstChild("AbilityDepthOfField")
		if not (AbilityDepthOfField and (AbilityDepthOfField:IsA("BlurEffect") or AbilityDepthOfField:IsA("DepthOfFieldEffect"))) then
			return
		end
		local Enabled = AbilityDepthOfField.Enabled
		AbilityDepthOfField.Enabled = true
	end)
	local v4 = v1:GetExtentsSize()
	local Position = HumanoidRootPart.Position
	local v72 = math.max(v4.Y * 0.5, 2)
	local Position_2 = (HumanoidRootPart.CFrame * CFrame.new(0, 0, -math.max(v72 / math.tan(math.rad(CurrentCamera.FieldOfView) * 0.5) + v4.Z, 4))).Position
	pcall(function() --[[ Line: 552 | Upvalues: LocalPlayer (ref), v7 (ref) ]]
		LocalPlayer:RequestStreamAroundAsync(v7.Position)
	end)
	if not (v31 and v31._TargetPart) then
		CurrentCamera.CameraType = Enum.CameraType.Scriptable
		CurrentCamera.CFrame = CFrame.lookAt(Position_2, Position)
		CurrentCamera.Focus = CFrame.new(Position)
		return
	end
	LocalPlayer.ReplicationFocus = v31._TargetPart
	CurrentCamera.CameraType = Enum.CameraType.Scriptable
	CurrentCamera.CFrame = CFrame.lookAt(Position_2, Position)
	CurrentCamera.Focus = CFrame.new(Position)
end
local function restoreAbilityCamera() --[[ restoreAbilityCamera | Line: 567 | Upvalues: v31 (ref), LocalPlayer (copy), v32 (ref), Lighting (copy) ]]
	if v31 then
		pcall(function() --[[ Line: 570 | Upvalues: LocalPlayer (ref), v31 (ref) ]]
			LocalPlayer:RequestStreamAroundAsync(v31.CFrame.Position)
		end)
		if v31._TargetPart then
			v31._TargetPart:Destroy()
			v31._TargetPart = nil
		end
	end
	LocalPlayer.ReplicationFocus = nil
	local CurrentCamera = workspace.CurrentCamera
	if v31 and CurrentCamera then
		CurrentCamera.CameraType = v31.CameraType
		CurrentCamera.CameraSubject = v31.CameraSubject
		CurrentCamera.CFrame = v31.CFrame
		CurrentCamera.Focus = v31.Focus
		CurrentCamera.FieldOfView = v31.FieldOfView
		v31 = nil
	end
	if not v32 then
		return
	end
	if v32.BlurEnabled ~= nil then
		local BlurEnabled = v32.BlurEnabled
		local Blur = Lighting:FindFirstChild("Blur")
		if Blur and (Blur:IsA("BlurEffect") or Blur:IsA("DepthOfFieldEffect")) then
			local Enabled = Blur.Enabled
			Blur.Enabled = BlurEnabled
		end
	end
	if v32.AbilityDepthOfFieldEnabled ~= nil then
		local AbilityDepthOfFieldEnabled = v32.AbilityDepthOfFieldEnabled
		local AbilityDepthOfField = Lighting:FindFirstChild("AbilityDepthOfField")
		if AbilityDepthOfField and (AbilityDepthOfField:IsA("BlurEffect") or AbilityDepthOfField:IsA("DepthOfFieldEffect")) then
			local Enabled = AbilityDepthOfField.Enabled
			AbilityDepthOfField.Enabled = AbilityDepthOfFieldEnabled
		end
	end
	v32 = nil
end
local function sinkMovement() --[[ sinkMovement | Line: 608 ]]
	return Enum.ContextActionResult.Sink
end
local function lockMovement() --[[ lockMovement | Line: 612 | Upvalues: LocalPlayer (copy), v33 (ref), ContextActionService (copy), sinkMovement (copy) ]]
	local Character = LocalPlayer.Character
	if not Character then
		return
	end
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	if not Humanoid then
		return
	end
	if not v33 then
		v33 = {
			Humanoid = Humanoid,
			WalkSpeed = Humanoid.WalkSpeed,
			JumpPower = Humanoid.JumpPower,
			JumpHeight = Humanoid.JumpHeight,
			AutoRotate = Humanoid.AutoRotate,
			UseJumpPower = Humanoid.UseJumpPower
		}
	end
	Humanoid.WalkSpeed = 0
	Humanoid.JumpPower = 0
	Humanoid.JumpHeight = 0
	Humanoid.AutoRotate = false
	Humanoid:Move(Vector3.new(0, 0, 0), false)
	ContextActionService:BindActionAtPriority("AbilityUILockMovement", sinkMovement, false, Enum.ContextActionPriority.High.Value + 10, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.KeyCode.Left, Enum.KeyCode.Right, Enum.KeyCode.Space, Enum.KeyCode.ButtonA, Enum.KeyCode.Thumbstick1)
end
local function unlockMovement() --[[ unlockMovement | Line: 659 | Upvalues: ContextActionService (copy), v33 (ref) ]]
	ContextActionService:UnbindAction("AbilityUILockMovement")
	if not v33 then
		return
	end
	local Humanoid = v33.Humanoid
	if Humanoid and Humanoid:IsDescendantOf(game) then
		Humanoid.WalkSpeed = v33.WalkSpeed
		Humanoid.JumpPower = v33.JumpPower
		Humanoid.JumpHeight = v33.JumpHeight
		Humanoid.AutoRotate = v33.AutoRotate
		Humanoid.UseJumpPower = v33.UseJumpPower
	end
	v33 = nil
end
local function hideInstance(p1) --[[ hideInstance | Line: 676 | Upvalues: t3 (copy) ]]
	if t3[p1] ~= nil then
		return
	end
	if p1:IsA("BasePart") then
		t3[p1] = p1.LocalTransparencyModifier
		p1.LocalTransparencyModifier = 1
		return
	end
	if p1:IsA("Decal") or p1:IsA("Texture") then
		t3[p1] = p1.Transparency
		p1.Transparency = 1
	else
		if not p1:IsA("BillboardGui") then
			return
		end
		t3[p1] = p1.Enabled
		p1.Enabled = false
	end
end
local function hideOtherCharacter(p1) --[[ hideOtherCharacter | Line: 693 | Upvalues: hideInstance (copy) ]]
	if not p1 then
		return
	end
	for i, v in ipairs(p1:GetDescendants()) do
		hideInstance(v)
	end
end
local function watchOtherPlayer(p1) --[[ watchOtherPlayer | Line: 703 | Upvalues: LocalPlayer (copy), hideInstance (copy), t4 (copy), hideOtherCharacter (copy) ]]
	if p1 == LocalPlayer then
		return
	end
	local Character = p1.Character
	if Character then
		for i, v in ipairs(Character:GetDescendants()) do
			hideInstance(v)
		end
	end
	local function f2(p1_2) --[[ Line: 709 | Upvalues: hideOtherCharacter (ref) ]]
		task.defer(hideOtherCharacter, p1_2)
	end
	table.insert(t4, p1.CharacterAdded:Connect(f2))
end
local function hideOtherPlayers() --[[ hideOtherPlayers | Line: 714 | Upvalues: t4 (copy), Players (copy), LocalPlayer (copy), hideInstance (copy), hideOtherCharacter (copy), watchOtherPlayer (copy) ]]
	for i, v in ipairs(t4) do
		v:Disconnect()
	end
	table.clear(t4)
	for i, v in ipairs(Players:GetPlayers()) do
		if v ~= LocalPlayer then
			local Character = v.Character
			if Character then
				for i2, v2 in ipairs(Character:GetDescendants()) do
					hideInstance(v2)
				end
			end
			local function f2(p1_2) --[[ Line: 709 | Upvalues: hideOtherCharacter (ref) ]]
				task.defer(hideOtherCharacter, p1_2)
			end
			table.insert(t4, v.CharacterAdded:Connect(f2))
		end
	end
	table.insert(t4, Players.PlayerAdded:Connect(watchOtherPlayer))
end
local function restoreOtherPlayers() --[[ restoreOtherPlayers | Line: 727 | Upvalues: t4 (copy), t3 (copy) ]]
	for i, v in ipairs(t4) do
		v:Disconnect()
	end
	table.clear(t4)
	for v1, v2 in t3 do
		if v1:IsDescendantOf(game) then
			if v1:IsA("BasePart") then
				v1.LocalTransparencyModifier = v2
				continue
			end
			if v1:IsA("Decal") or v1:IsA("Texture") then
				v1.Transparency = v2
				continue
			end
			if v1:IsA("BillboardGui") then
				v1.Enabled = v2
			end
		end
	end
	table.clear(t3)
end
local function getOwnedLookup() --[[ getOwnedLookup | Line: 748 | Upvalues: v6 (ref) ]]
	local t = {}
	local v1 = v6:Get({ "Abilities", "Inventory" })
	if typeof(v1) ~= "table" then
		return t
	end
	for i, v in ipairs(v1) do
		t[v.Name] = true
	end
	return t
end
local function getOwnedAbilityCount() --[[ getOwnedAbilityCount | Line: 762 | Upvalues: getOwnedLookup (copy), Abilities (copy) ]]
	local count = 0
	for v1 in getOwnedLookup() do
		if Abilities[v1] then
			count = count + 1
		end
	end
	return count
end
local function getEquippedAbilityName() --[[ getEquippedAbilityName | Line: 774 | Upvalues: v6 (ref), Abilities (copy) ]]
	local v1 = v6:Get({ "Abilities", "Equipped" })
	if not v1 or v1 == "" then
		return nil
	end
	local v2 = v6:Get({ "Abilities", "Inventory" })
	if typeof(v2) == "table" then
		for i, v in ipairs(v2) do
			if (v.UUID == v1 or v.Name == v1) and Abilities[v.Name] then
				return v.Name
			end
		end
	end
	if Abilities[v1] then
		return v1
	else
		return nil
	end
end
local function showEquippedPreviewAura() --[[ showEquippedPreviewAura | Line: 794 | Upvalues: getEquippedAbilityName (copy), AbilityVFXController (copy), LocalPlayer (copy) ]]
	local v1 = getEquippedAbilityName()
	if not v1 then
		return
	end
	AbilityVFXController:ShowPreviewAura(v1, LocalPlayer)
end
local function getOddsText(p1) --[[ getOddsText | Line: 801 | Upvalues: v17 (ref) ]]
	if v17 <= 0 then
		return "0%"
	end
	local v1 = p1.Weight / v17 * 100
	if v1 < 1 then
		return ("%*%%"):format(math.round(v1 * 100) / 100)
	else
		return ("%*%%"):format(math.round(v1 * 10) / 10)
	end
end
local t5 = {
	Mythic = "Mythical",
	SECRET = "Secret",
	FORGOTTEN = "Forgotten"
}
local function getTierDisplayName(p1) --[[ getTierDisplayName | Line: 820 | Upvalues: t5 (copy) ]]
	return t5[p1] or p1
end
local function getAbilityColor(p1) --[[ getAbilityColor | Line: 824 ]]
	return p1.Color.Keypoints[1].Value
end
local function setSelectedAbility(p1) --[[ setSelectedAbility | Line: 828 | Upvalues: getAbilityGui (copy), Abilities (copy), v18 (ref), TierUtility (copy), v17 (ref) ]]
	local _, v1 = getAbilityGui()
	if not v1 then
		return
	end
	local v2 = Abilities[p1]
	if not v2 then
		return
	end
	v18 = p1
	local TopUI = v1:FindFirstChild("TopUI")
	if TopUI and TopUI:IsA("GuiObject") then
		TopUI.Visible = true
	end
	local v3
	if TopUI then
		local Title = TopUI:FindFirstChild("Title", true)
		v3 = if Title and Title:IsA("TextLabel") then Title else nil
	else
		v3 = nil
	end
	local v4
	if TopUI then
		local Description = TopUI:FindFirstChild("Description", true)
		v4 = if Description and Description:IsA("TextLabel") then Description else nil
	else
		v4 = nil
	end
	local v5
	if TopUI then
		local Odds = TopUI:FindFirstChild("Odds", true)
		v5 = if Odds and Odds:IsA("TextLabel") then Odds else nil
	else
		v5 = nil
	end
	local v6 = TierUtility:GetTier(v2.Data.Tier or 1)
	if v3 then
		v3.Text = v2.Name
		local UIGradient = v3:FindFirstChildOfClass("UIGradient")
		if UIGradient then
			UIGradient.Color = v6.TierColor
		end
	end
	if v4 then
		v4.Text = v2.Description
	end
	if not v5 then
		return
	end
	local v8 = string.upper(v6.Name)
	local v9
	if v17 <= 0 then
		v9 = "0%"
	else
		local v10 = v2.Weight / v17 * 100
		v9 = if v10 < 1 then ("%*%%"):format(math.round(v10 * 100) / 100) else ("%*%%"):format(math.round(v10 * 10) / 10)
	end
	v5.Text = ("%* | %*"):format(v8, v9)
end
local function hideSelectedAbility() --[[ hideSelectedAbility | Line: 868 | Upvalues: getAbilityGui (copy), v18 (ref) ]]
	local _, v1 = getAbilityGui()
	if not v1 then
		return
	end
	v18 = nil
	local TopUI = v1:FindFirstChild("TopUI")
	if not (TopUI and TopUI:IsA("GuiObject")) then
		return
	end
	TopUI.Visible = false
end
local function rebuildAbilityList() --[[ rebuildAbilityList | Line: 882 | Upvalues: t2 (copy), v17 (ref), Abilities (copy) ]]
	table.clear(t2)
	v17 = 0
	for v1, v2 in Abilities do
		v17 = v17 + v2.Weight
		table.insert(t2, v1)
	end
	table.sort(t2, function(p1, p2) --[[ Line: 891 | Upvalues: Abilities (ref) ]]
		return Abilities[p1].Weight > Abilities[p2].Weight
	end)
end
local function renderOdds() --[[ renderOdds | Line: 896 | Upvalues: getAbilityGui (copy), t2 (copy), Abilities (copy), TierUtility (copy), t5 (copy), v17 (ref) ]]
	local _, v1 = getAbilityGui()
	if not v1 then
		return
	end
	local TopRight = v1:FindFirstChild("TopRight")
	if not TopRight then
		return
	end
	local t = {}
	for i, v in ipairs(t2) do
		local v2 = Abilities[v]
		local v3 = TierUtility:GetTier(v2.Data.Tier or 1).Name
		local v4 = t5[v3] or v3
		t[v4] = (t[v4] or 0) + v2.Weight
	end
	for i, v in ipairs(TopRight:GetChildren()) do
		local v5
		if v:IsA("Frame") then
			if v then
				local Rarity = v:FindFirstChild("Rarity", true)
				v5 = if Rarity and Rarity:IsA("TextLabel") then Rarity else nil
			else
				v5 = nil
			end
			if v5 then
				v5.Text = ("%*: %*%%"):format(v.Name, math.round((if v17 > 0 then (t[v.Name] or 0) / v17 * 100 else 0) * 10) / 10)
			end
		end
	end
end
local function renderOwned() --[[ renderOwned | Line: 929 | Upvalues: getAbilityGui (copy), getOwnedLookup (copy), t2 (copy), Abilities (copy), v17 (ref) ]]
	local _, v1 = getAbilityGui()
	if not v1 then
		return
	end
	local v2 = getOwnedLookup()
	local LeftUI = v1:FindFirstChild("LeftUI")
	local v3 = if LeftUI then LeftUI:FindFirstChild("OwnedItems") else LeftUI
	if not (v3 and v3:IsA("ScrollingFrame")) then
		return
	end
	local t = {}
	local list = {}
	local list2 = {}
	for i, v in ipairs(v3:GetChildren()) do
		if v:IsA("TextLabel") and v.Name == "ItemOdds" then
			table.insert(t, v)
		end
	end
	table.sort(t, function(p1, p2) --[[ Line: 953 ]]
		return p1.LayoutOrder < p2.LayoutOrder
	end)
	for i, v in ipairs(t2) do
		if v2[v] == true then
			table.insert(list2, v)
			continue
		end
		table.insert(list, v)
	end
	local v4 = #list2
	local Owned = v3:FindFirstChild("Owned")
	local NotOwned = v3:FindFirstChild("NotOwned")
	if Owned and Owned:IsA("GuiObject") then
		Owned.LayoutOrder = 1
	end
	local count = 1
	for i, v in ipairs(list2) do
		local v5
		local v6 = Abilities[v]
		local v7 = t[count]
		if v7 then
			v7.Visible = true
			v7.LayoutOrder = i + 1
			if v17 <= 0 then
				v5 = "0%"
			else
				local v10 = v6.Weight / v17 * 100
				v5 = if v10 < 1 then ("%*%%"):format(math.round(v10 * 100) / 100) else ("%*%%"):format(math.round(v10 * 10) / 10)
			end
			v7.Text = ("%* (%* Odds)"):format(v6.Name, v5)
			v7.TextColor3 = v6.Color.Keypoints[1].Value
		end
		count = count + 1
	end
	local v13 = #list2 + 2
	if NotOwned and NotOwned:IsA("GuiObject") then
		NotOwned.LayoutOrder = v13
	end
	for i, v in ipairs(list) do
		local v14
		local v15 = Abilities[v]
		local v16 = t[count]
		if v16 then
			v16.Visible = true
			v16.LayoutOrder = v13 + i
			if v17 <= 0 then
				v14 = "0%"
			else
				local v19 = v15.Weight / v17 * 100
				v14 = if v19 < 1 then ("%*%%"):format(math.round(v19 * 100) / 100) else ("%*%%"):format(math.round(v19 * 10) / 10)
			end
			v16.Text = ("%* (%* Odds)"):format(v15.Name, v14)
			v16.TextColor3 = Color3.fromRGB(170, 170, 170)
		end
		count = count + 1
	end
	for i = count, #t do
		t[i].Visible = false
	end
	local v22 = ("Owned %*"):format(v4)
	if Owned then
		local v23 = Owned.Name
		local v24, v25
		if Owned then
			local v26 = Owned:FindFirstChild(v23, true)
			if v26 and v26:IsA("TextLabel") then
				v24 = v26
				v25 = v22
			else
				v24 = nil
				v25 = v22
			end
		else
			v24 = nil
			v25 = v22
		end
		if not v24 and Owned then
			local Label = Owned:FindFirstChild("Label", true)
			v24 = if Label and Label:IsA("TextLabel") then Label else nil
		elseif not v24 then
			v24 = nil
		end
		if v24 then
			v24.Text = v25
		end
	end
	local v28 = ("Missing %*"):format((math.max(#t2 - v4, 0)))
	if not NotOwned then
		return
	end
	local v29 = NotOwned.Name
	local v30, v31
	if NotOwned then
		local v32 = NotOwned:FindFirstChild(v29, true)
		if v32 and v32:IsA("TextLabel") then
			v30 = v32
			v31 = v28
		else
			v30 = nil
			v31 = v28
		end
	else
		v30 = nil
		v31 = v28
	end
	if not v30 and NotOwned then
		local Label = NotOwned:FindFirstChild("Label", true)
		v30 = if Label and Label:IsA("TextLabel") then Label else nil
	elseif not v30 then
		v30 = nil
	end
	if not v30 then
		return
	end
	v30.Text = v31
end
local function refresh() --[[ refresh | Line: 1013 | Upvalues: getAbilityGui (copy), v6 (ref), getShardCount (copy), StringLibrary (copy), v15 (ref), v25 (ref), v23 (ref), v26 (ref), v21 (ref), v20 (ref), v27 (ref), renderOdds (copy), renderOwned (copy), renderAbilitiesCollect (copy), getOwnedLookup (copy), v19 (ref), Abilities (copy), setSelectedAbility (copy), getEquippedAbilityName (copy), v18 (ref) ]]
	local _, v1 = getAbilityGui()
	if not v1 then
		return
	end
	local v2 = v6:Get({ "Abilities", "FreeRolls" }) or 0
	local v3 = getShardCount()
	local BottomCenter = v1:FindFirstChild("BottomCenter")
	local BottomRight = v1:FindFirstChild("BottomRight")
	local v4 = if BottomCenter then BottomCenter:FindFirstChild("Spin") else BottomCenter
	local v5 = ("Roll (%*)"):format((StringLibrary:AddCommas(v2)))
	if v4 then
		local v62 = v4.Name
		local v7, v8
		if v4 then
			local v9 = v4:FindFirstChild(v62, true)
			if v9 and v9:IsA("TextLabel") then
				v7 = v9
				v8 = v5
			else
				v7 = nil
				v8 = v5
			end
		else
			v7 = nil
			v8 = v5
		end
		if not v7 and v4 then
			local Label = v4:FindFirstChild("Label", true)
			v7 = if Label and Label:IsA("TextLabel") then Label else nil
		elseif not v7 then
			v7 = nil
		end
		if v7 then
			v7.Text = v8
		end
	end
	local v10 = if BottomCenter then BottomCenter:FindFirstChild("ShardsButton") else BottomCenter
	local v11 = ("Shards %*/%*"):format(math.min(v3, 6), 6)
	if v10 then
		local v12 = v10.Name
		local v13, v14
		if v10 then
			local v152 = v10:FindFirstChild(v12, true)
			if v152 and v152:IsA("TextLabel") then
				v13 = v152
				v14 = v11
			else
				v13 = nil
				v14 = v11
			end
		else
			v13 = nil
			v14 = v11
		end
		if not v13 and v10 then
			local Label = v10:FindFirstChild("Label", true)
			v13 = if Label and Label:IsA("TextLabel") then Label else nil
		elseif not v13 then
			v13 = nil
		end
		if v13 then
			v13.Text = v14
		end
	end
	local v16 = if BottomRight then BottomRight:FindFirstChild("SkipSpins") else BottomRight
	local v17 = if v15 then "Skip: ON" else "Skip: OFF"
	if v16 then
		local v182 = v16.Name
		local v192
		if v16 then
			local v202 = v16:FindFirstChild(v182, true)
			v192 = if v202 and v202:IsA("TextLabel") then v202 else nil
		else
			v192 = nil
		end
		if not v192 and v16 then
			local Label = v16:FindFirstChild("Label", true)
			v192 = if Label and Label:IsA("TextLabel") then Label else nil
		elseif not v192 then
			v192 = nil
		end
		if v192 then
			v192.Text = v17
		end
	end
	local v212 = v25
	if v212 then
		local v22 = v212.Name
		local v232
		if v212 then
			local v24 = v212:FindFirstChild(v22, true)
			v232 = if v24 and v24:IsA("TextLabel") then v24 else nil
		else
			v232 = nil
		end
		if not v232 and v212 then
			local Label = v212:FindFirstChild("Label", true)
			v232 = if Label and Label:IsA("TextLabel") then Label else nil
		elseif not v232 then
			v232 = nil
		end
		if v232 then
			v232.Text = "Progress"
		end
	end
	if v23 == nil then
		v23 = v26.Rotation
	end
	v26.Image = v21
	v27.Visible = v20
	renderOdds()
	renderOwned()
	renderAbilitiesCollect((getOwnedLookup()))
	if v19 and Abilities[v19] then
		setSelectedAbility(v19)
		return
	end
	local v262 = getEquippedAbilityName()
	if v262 then
		setSelectedAbility(v262)
		return
	end
	local _2, v272 = getAbilityGui()
	if not v272 then
		return
	end
	v18 = nil
	local TopUI = v272:FindFirstChild("TopUI")
	if not (TopUI and TopUI:IsA("GuiObject")) then
		return
	end
	TopUI.Visible = false
end
local function notify(p1, p2) --[[ notify | Line: 1048 | Upvalues: TextNotificationController (copy) ]]
	local t = {
		Type = "Text",
		Text = p1
	}
	local t2 = {}
	t2.R = math.floor((if p2 then p2 else Color3.fromRGB(255, 203, 16)).R * 255)
	t2.G = math.floor((if p2 then p2 else Color3.fromRGB(255, 203, 16)).G * 255)
	t2.B = math.floor((if p2 then p2 else Color3.fromRGB(255, 203, 16)).B * 255)
	t.TextColor = t2
	TextNotificationController:DeliverNotification(t)
end
local function playSound(p1) --[[ playSound | Line: 1060 | Upvalues: Soundbook (copy) ]]
	local v1 = Soundbook.Sounds[p1]
	if not v1 then
		return
	end
	v1:Play()
end
local function playAbilityRollResultSound(p1) --[[ playAbilityRollResultSound | Line: 1067 | Upvalues: Abilities (copy), Soundbook (copy), TierUtility (copy) ]]
	local v1 = Abilities[p1]
	if v1 then
		local v2 = TierUtility:GetTier(v1.Data.Tier or 1)
		if v2.Name == "Mythic" then
			local v3 = Soundbook.Sounds["Ability Mythic Roll"]
			if v3 then
				v3:Play()
			end
		elseif v2.Name == "SECRET" then
			local v4 = Soundbook.Sounds["Ability Secret Roll"]
			if v4 then
				v4:Play()
			end
		else
			local v5 = Soundbook.Sounds["Ability Other Rarity Roll"]
			if not v5 then
				return
			end
			v5:Play()
		end
	else
		local v6 = Soundbook.Sounds["Ability Other Rarity Roll"]
		if not v6 then
			return
		end
		v6:Play()
	end
end
local function rollVisual(p1) --[[ rollVisual | Line: 1084 | Upvalues: v14 (ref), v15 (ref), refresh (copy), t2 (copy), setSelectedAbility (copy), Soundbook (copy), v19 (ref), playAbilityRollResultSound (copy) ]]
	v14 = v15
	refresh()
	local v1 = os.clock()
	local count = 1
	while os.clock() - v1 < 1.35 and not v15 do
		local v2 = t2[count]
		if v2 then
			setSelectedAbility(v2)
			local v3 = Soundbook.Sounds["Ability Roll Tick"]
			if v3 then
				v3:Play()
			end
		end
		count = count + 1
		if #t2 < count then
			count = 1
		end
		task.wait(0.075)
	end
	setSelectedAbility(p1)
	v19 = p1
	playAbilityRollResultSound(p1)
	v14 = false
	refresh()
end
local function requestRoll() --[[ requestRoll | Line: 1117 | Upvalues: v12 (ref), v13 (ref), refresh (copy), v1 (copy), v19 (ref), v14 (ref), notify (copy), rollVisual (copy), AbilityVFXController (copy), LocalPlayer (copy), Abilities (copy), v20 (ref), v27 (ref), v23 (ref), v26 (ref), tweenRodIconRotation (copy), PlayerGui (copy) ]]
	if v12 or v13 then
		return
	end
	v12 = true
	v13 = true
	refresh()
	local v15, v2, v3, v4 = v1:InvokeServer()
	v13 = false
	if not (v15 and v2) then
		v19 = nil
		v12 = false
		v14 = false
		refresh()
		notify("You do not have any ability rolls left")
		return
	end
	rollVisual(v2)
	if not AbilityVFXController:PlayForPlayer(v2, LocalPlayer) then
		task.wait()
		AbilityVFXController:PlayForPlayer(v2, LocalPlayer)
	end
	task.wait(0.25)
	v12 = false
	refresh()
	local v5 = Abilities[v2]
	if v3 then
		local v7 = ("Duplicate %*: +%* shards"):format(v2, v4 or 1)
		local v8, v9
		if v5 then
			v8 = v5.Color.Keypoints[1].Value
			if v8 then
				v9 = v7
			else
				v9 = v7
				v8 = nil
			end
		else
			v9 = v7
			v8 = nil
		end
		notify(v9, v8)
	else
		v20 = true
		v27.Visible = true
		task.spawn(function() --[[ Line: 281 | Upvalues: v23 (ref), v26 (ref), tweenRodIconRotation (ref), PlayerGui (ref) ]]
			local v1 = v23 or v26.Rotation
			v23 = v1
			v26.Rotation = v1
			tweenRodIconRotation(v1 + 360, 0.45)
			if not v26:IsDescendantOf(PlayerGui) then
				return
			end
			v26.Rotation = v1
		end)
		local v11 = ("Unlocked %*"):format(v2)
		local v122, v132
		if v5 then
			v122 = v5.Color.Keypoints[1].Value
			if v122 then
				v132 = v11
			else
				v132 = v11
				v122 = nil
			end
		else
			v132 = v11
			v122 = nil
		end
		notify(v132, v122)
	end
end
local function convertShards() --[[ convertShards | Line: 1158 | Upvalues: v12 (ref), v2 (copy), notify (copy), refresh (copy) ]]
	if v12 then
		return
	end
	if v2:InvokeServer() then
		notify("Converted shards into 1 ability roll")
		refresh()
	else
		notify((("Need %* shards to convert"):format(6)))
	end
end
local function openRewardProgress() --[[ openRewardProgress | Line: 1173 | Upvalues: v12 (ref), v20 (ref), v27 (ref), v3 (copy), renderRewardProgress (copy), v4 (copy), notify (copy), GuiControl (copy) ]]
	if v12 then
		return
	end
	v20 = false
	v27.Visible = false
	local v1 = v3:InvokeServer()
	if not v1 then
		GuiControl:Open("!!!! RewardProgress")
		return
	end
	renderRewardProgress(v1)
	if not v1.Completed or v1.Claimed then
		GuiControl:Open("!!!! RewardProgress")
		return
	end
	local v2, v32 = v4:InvokeServer()
	if v32 then
		renderRewardProgress(v32)
	end
	if not v2 then
		GuiControl:Open("!!!! RewardProgress")
		return
	end
	notify((("Unlocked %*"):format(if v32 then v32.RewardName or "reward" else "reward")))
	GuiControl:Open("!!!! RewardProgress")
end
local function openBuySpins() --[[ openBuySpins | Line: 1198 | Upvalues: v12 (ref), v16 (ref), GuiControl (copy) ]]
	if not v12 then
		v16 = true
		GuiControl:Open("!!!! BUY SPINS")
	end
end
local function getSpinQuantity(p1) --[[ getSpinQuantity | Line: 1207 ]]
	local v1 = p1:match("x(%d+)")
	return if v1 then tonumber(v1) or 0 else 0
end
local function getSpinBox(p1, p2) --[[ getSpinBox | Line: 1212 ]]
	return p1:FindFirstChild(if p2 == 1 then "1Spin" else ("%*Spins"):format(p2))
end
local function getSpinLabelText(p1) --[[ getSpinLabelText | Line: 1217 ]]
	if p1 == 1 then
		return "1x Spin"
	else
		return ("%*x Spins"):format(p1)
	end
end
local function setupBuySpinProducts() --[[ setupBuySpinProducts | Line: 1225 | Upvalues: v10 (ref), PlayerGui (copy), AbilitySpinProducts (copy), MarketplaceService (copy), StringLibrary (copy), GuiControl (copy), LocalPlayer (copy), GiftingController (copy) ]]
	local v1
	if v10 then
		v1 = v10
	else
		local v2 = PlayerGui:FindFirstChild("!!!! BUY SPINS")
		if v2 and v2:IsA("ScreenGui") then
			v10 = v2
			v1 = v2
		else
			v1 = nil
		end
	end
	local v3 = if v1 then v1:FindFirstChild("Container", true) else v1
	if not v3 then
		return
	end
	local list = {}
	for k, v in pairs(AbilitySpinProducts) do
		local v4
		local t = {
			GiftProductId = k,
			ProductData = v
		}
		local v5 = v.product:match("x(%d+)")
		v4 = v5 and tonumber(v5) or 0
		t.Quantity = v4
		table.insert(list, t)
	end
	table.sort(list, function(p1, p2) --[[ Line: 1241 ]]
		return p1.Quantity < p2.Quantity
	end)
	for i, v in ipairs(list) do
		local v7, v8
		local ProductData = v.ProductData
		local Quantity = v.Quantity
		v7 = if Quantity == 1 then "1Spin" else ("%*Spins"):format(Quantity)
		local v102 = v3:FindFirstChild(v7)
		if v102 then
			v102:SetAttribute("DevProductId", ProductData.productId)
			v102:SetAttribute("GiftProductId", v.GiftProductId)
			local Label = v102:FindFirstChild("Label")
			if Label and Label:IsA("TextLabel") then
				local Quantity_2 = v.Quantity
				v8 = if Quantity_2 == 1 then "1x Spin" else ("%*x Spins"):format(Quantity_2)
				Label.Text = v8
			end
			local v12 = v102
			local BuyButton = v12:FindFirstChild("BuyButton")
			if BuyButton and BuyButton:IsA("GuiButton") then
				BuyButton:SetAttribute("DevProductId", ProductData.productId)
				local Label_2 = BuyButton:FindFirstChild("Label")
				if Label_2 and Label_2:IsA("TextLabel") then
					Label_2.Text = "..."
					MarketplaceService:GetProductInfoAsync(ProductData.productId, Enum.InfoType.Product):andThen(function(p1) --[[ Line: 1267 | Upvalues: Label_2 (copy), StringLibrary (ref) ]]
						local v1 = if p1 then p1.PriceInRobux else p1
						Label_2.Text = ("%*"):format(if v1 then StringLibrary:AddCommas(v1) else "???")
					end):catch(function() --[[ Line: 1271 | Upvalues: Label_2 (copy) ]]
						Label_2.Text = "???"
					end)
				end
				GuiControl:Hook("Hold Button", BuyButton).Clicked:Connect(function() --[[ Line: 1276 | Upvalues: MarketplaceService (ref), LocalPlayer (ref), ProductData (copy) ]]
					MarketplaceService:PromptProductPurchase(LocalPlayer, ProductData.productId)
				end)
			end
			local GiftButton = v12:FindFirstChild("GiftButton")
			if GiftButton and GiftButton:IsA("GuiButton") then
				GiftButton:SetAttribute("DevProductId", v.GiftProductId)
				GuiControl:Hook("Hold Button", GiftButton).Clicked:Connect(function() --[[ Line: 1284 | Upvalues: GiftingController (ref), ProductData (copy) ]]
					GiftingController:Open(ProductData.product)
				end)
			end
		end
	end
end
function t.Start(p1) --[[ Start | Line: 1291 | Upvalues: v6 (ref), Replion (copy), rebuildAbilityList (copy), getAbilityGui (copy), v10 (ref), PlayerGui (copy), v11 (ref), setupBuySpinProducts (copy), v25 (ref), v26 (ref), v27 (ref), GuiControl (copy), requestRoll (copy), openBuySpins (copy), openRewardProgress (copy), convertShards (copy), v15 (ref), v12 (ref), v14 (ref), refresh (copy), v29 (ref), v30 (ref), v5 (copy), AbilityPreviewController (copy), getEquippedAbilityName (copy), AbilityVFXController (copy), LocalPlayer (copy), applyAbilityCamera (copy), lockMovement (copy), hideOtherPlayers (copy), v22 (ref), v8 (ref), v23 (ref), tweenRodIconRotation (copy), v3 (copy), v21 (ref), v20 (ref), restoreAbilityCamera (copy), ContextActionService (copy), v33 (ref), restoreOtherPlayers (copy), v24 (ref), v16 (ref), v28 (ref), getOwnedLookup (copy), Abilities (copy) ]]
	v6 = Replion.Client:WaitReplion("Data")
	rebuildAbilityList()
	local v1, v2 = getAbilityGui()
	if not (v1 and v2) then
		return
	end
	v1.Enabled = false
	local v32
	if v10 then
		v32 = v10
	else
		local v4 = PlayerGui:FindFirstChild("!!!! BUY SPINS")
		if v4 and v4:IsA("ScreenGui") then
			v10 = v4
			v32 = v4
		else
			v32 = nil
		end
	end
	local v52
	if v11 then
		v52 = v11
	else
		local v62 = PlayerGui:FindFirstChild("!!!! RewardProgress")
		if v62 and v62:IsA("ScreenGui") then
			v11 = v62
			v52 = v62
		else
			v52 = nil
		end
	end
	setupBuySpinProducts()
	local Back = v2:FindFirstChild("Back")
	local BottomCenter = v2:FindFirstChild("BottomCenter")
	local BottomRight = v2:FindFirstChild("BottomRight")
	local v7 = if BottomCenter then BottomCenter:FindFirstChild("Spin") else BottomCenter
	local v82 = if BottomRight then BottomRight:FindFirstChild("BuySpins") else BottomRight
	local v9 = if BottomRight then BottomRight:FindFirstChild("SkipSpins") else BottomRight
	local Progress = v2.LeftUI.Progress
	v25 = Progress
	v26 = Progress.RodIcon
	v27 = Progress.Notification
	local v102 = if BottomCenter then BottomCenter:FindFirstChild("ShardsButton") else BottomCenter
	local v112 = PlayerGui:WaitForChild("Exclusive Store")
	local v122 = if v112 then v112.Main.Content.Items else v112
	local v13 = if v122 then v122:FindFirstChild("ButtonAbilityUI", true) else v122
	if Back then
		GuiControl:Hook("Hold Button", Back).Clicked:Connect(function() --[[ Line: 1323 | Upvalues: GuiControl (ref) ]]
			GuiControl:Close()
		end)
	end
	if v7 then
		GuiControl:Hook("Hold Button", v7).Clicked:Connect(requestRoll)
	end
	if v82 then
		GuiControl:Hook("Hold Button", v82).Clicked:Connect(openBuySpins)
	end
	GuiControl:Hook("Hold Button", Progress).Clicked:Connect(openRewardProgress)
	if v122 then
		GuiControl:Hook("Hold Button", v13).Clicked:Connect(function() --[[ Line: 1339 | Upvalues: GuiControl (ref) ]]
			GuiControl:Open("!!!! AbilityUI")
		end)
	end
	if v102 then
		GuiControl:Hook("Hold Button", v102).Clicked:Connect(convertShards)
	end
	if v9 then
		GuiControl:Hook("Hold Button", v9).Clicked:Connect(function() --[[ Line: 1349 | Upvalues: v15 (ref), v12 (ref), v14 (ref), refresh (ref) ]]
			v15 = not v15
			if not v12 then
				refresh()
				return
			end
			v14 = v15
			refresh()
		end)
	end
	GuiControl.GuiFocusedSignal:Connect(function(p1) --[[ Line: 1359 | Upvalues: v1 (copy), v29 (ref), GuiControl (ref), PlayerGui (ref), v30 (ref), v5 (ref), AbilityPreviewController (ref), getEquippedAbilityName (ref), AbilityVFXController (ref), LocalPlayer (ref), applyAbilityCamera (ref), lockMovement (ref), hideOtherPlayers (ref), refresh (ref), v22 (ref), v8 (ref), v23 (ref), v26 (ref), tweenRodIconRotation (ref), v3 (ref), v21 (ref), v20 (ref), v27 (ref) ]]
		if p1 ~= v1 then
			return
		end
		if v29 then
			GuiControl:RestoreHUD(v29)
		end
		v29 = GuiControl:HideAllHUD({ "!!!! AbilityUI", "Text Notifications" })
		local v12 = PlayerGui:FindFirstChild("Text Notifications")
		local v2
		if v12 then
			local Frame = v12:FindFirstChild("Frame")
			v2 = if Frame and Frame:IsA("Frame") then Frame else nil
		else
			v2 = nil
		end
		if v2 then
			if not v30 then
				v30 = v2.Position
			end
			v2.Position = UDim2.new(0.5, 0, 0, 168)
		end
		v5:FireServer()
		AbilityPreviewController:Open()
		local v32 = getEquippedAbilityName()
		if v32 then
			AbilityVFXController:ShowPreviewAura(v32, LocalPlayer)
		end
		applyAbilityCamera()
		lockMovement()
		hideOtherPlayers()
		refresh()
		v22 = v22 + 1
		local v4 = v22
		task.spawn(function() --[[ Line: 305 | Upvalues: v4 (copy), v22 (ref), v8 (ref), v23 (ref), v26 (ref), tweenRodIconRotation (ref) ]]
			task.wait(3)
			while v4 == v22 do
				local v12 = v8
				if not (v12 and v12.Enabled) then
					break
				end
				local v2 = v23 or v26.Rotation
				v23 = v2
				tweenRodIconRotation(v2 - 12, 0.08)
				tweenRodIconRotation(v2 + 12, 0.12)
				tweenRodIconRotation(v2 - 8, 0.1)
				tweenRodIconRotation(v2, 0.1)
				task.wait(15)
			end
		end)
		task.spawn(function() --[[ Line: 1375 | Upvalues: v3 (ref), v21 (ref), v23 (ref), v26 (ref), v20 (ref), v27 (ref) ]]
			local v1 = v3:InvokeServer()
			if not v1 then
				return
			end
			if v1 and typeof(v1.RewardIcon) == "string" then
				v21 = v1.RewardIcon
			end
			if v23 == nil then
				v23 = v26.Rotation
			end
			v26.Image = v21
			v27.Visible = v20
		end)
	end)
	GuiControl.GuiUnfocusedSignal:Connect(function(p1) --[[ Line: 1384 | Upvalues: v1 (copy), v29 (ref), GuiControl (ref), restoreAbilityCamera (ref), AbilityPreviewController (ref), ContextActionService (ref), v33 (ref), restoreOtherPlayers (ref), PlayerGui (ref), v30 (ref), v22 (ref), v24 (ref), v23 (ref), v26 (ref), v32 (copy), v16 (ref) ]]
		if p1 == v1 then
			if v29 then
				GuiControl:RestoreHUD(v29)
				v29 = nil
			end
			restoreAbilityCamera()
			AbilityPreviewController:Close()
			ContextActionService:UnbindAction("AbilityUILockMovement")
			if v33 then
				local Humanoid = v33.Humanoid
				if Humanoid and Humanoid:IsDescendantOf(game) then
					Humanoid.WalkSpeed = v33.WalkSpeed
					Humanoid.JumpPower = v33.JumpPower
					Humanoid.JumpHeight = v33.JumpHeight
					Humanoid.AutoRotate = v33.AutoRotate
					Humanoid.UseJumpPower = v33.UseJumpPower
				end
				v33 = nil
			end
			restoreOtherPlayers()
			local v12 = PlayerGui:FindFirstChild("Text Notifications")
			local v2
			if v12 then
				local Frame = v12:FindFirstChild("Frame")
				v2 = if Frame and Frame:IsA("Frame") then Frame else nil
			else
				v2 = nil
			end
			if v2 and v30 then
				v2.Position = v30
			end
			v30 = nil
			v22 = v22 + 1
			if v24 then
				v24:Cancel()
				v24:Destroy()
				v24 = nil
			end
			if v23 then
				v26.Rotation = v23
			end
		else
			if not v32 or (p1 ~= v32 or not v16) then
				return
			end
			v16 = false
			task.defer(function() --[[ Line: 1399 | Upvalues: GuiControl (ref) ]]
				GuiControl:Open("!!!! AbilityUI")
			end)
		end
	end)
	if v32 then
		local Main = v32:FindFirstChild("Main")
		local v142 = if Main then Main:FindFirstChild("Close") else Main
		if v142 then
			GuiControl:Hook("Hold Button", v142).Clicked:Connect(function() --[[ Line: 1409 | Upvalues: GuiControl (ref) ]]
				GuiControl:Close()
			end)
		end
	end
	if v52 then
		local Main = v52:FindFirstChild("Main")
		local v152 = if Main then Main:FindFirstChild("Close") else Main
		if v152 then
			GuiControl:Hook("Hold Button", v152).Clicked:Connect(function() --[[ Line: 1419 | Upvalues: GuiControl (ref) ]]
				GuiControl:Close()
				task.defer(function() --[[ Line: 1421 | Upvalues: GuiControl (ref) ]]
					GuiControl:Open("!!!! AbilityUI")
				end)
			end)
		end
	end
	local count = 0
	for v162 in getOwnedLookup() do
		if Abilities[v162] then
			count = count + 1
		end
	end
	v28 = count
	v6:OnChange({ "Abilities", "FreeRolls" }, refresh)
	v6:OnChange({ "Abilities", "Inventory" }, function() --[[ Line: 1431 | Upvalues: getOwnedLookup (ref), Abilities (ref), v28 (ref), v20 (ref), v27 (ref), v23 (ref), v26 (ref), tweenRodIconRotation (ref), PlayerGui (ref), refresh (ref) ]]
		local count = 0
		for v1 in getOwnedLookup() do
			if Abilities[v1] then
				count = count + 1
			end
		end
		if v28 and v28 < count then
			v20 = true
			v27.Visible = true
			task.spawn(function() --[[ Line: 281 | Upvalues: v23 (ref), v26 (ref), tweenRodIconRotation (ref), PlayerGui (ref) ]]
				local v1 = v23 or v26.Rotation
				v23 = v1
				v26.Rotation = v1
				tweenRodIconRotation(v1 + 360, 0.45)
				if not v26:IsDescendantOf(PlayerGui) then
					return
				end
				v26.Rotation = v1
			end)
		end
		v28 = count
		refresh()
	end)
	v6:OnChange({ "Inventory", "Items" }, refresh)
	refresh()
	task.spawn(function() --[[ Line: 1444 | Upvalues: v3 (ref), v21 (ref), v23 (ref), v26 (ref), v20 (ref), v27 (ref), getAbilityGui (ref) ]]
		local v1 = v3:InvokeServer()
		if not v1 then
			return
		end
		if v1 and typeof(v1.RewardIcon) == "string" then
			v21 = v1.RewardIcon
		end
		if v23 == nil then
			v23 = v26.Rotation
		end
		v26.Image = v21
		v27.Visible = v20
		local v32 = getAbilityGui()
		if not v32 then
			return
		end
		local _ = tonumber(if v1 then v1.Current else v1) or 0
		math.max(tonumber(if v1 then v1.Total else v1) or 0, 1)
		local v7 = if v1 then if v1.Completed == true then true else false else v1
		v32.AbilityUI.LeftUI.Progress.Notif.Visible = if v7 then not (if v1 then v1.Claimed == true else v1) else v7
	end)
end
return t