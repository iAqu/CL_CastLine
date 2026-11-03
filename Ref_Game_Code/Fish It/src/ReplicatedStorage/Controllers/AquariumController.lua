-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local AquariumConfig = require(ReplicatedStorage.Shared.AquariumConfig)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
require(ReplicatedStorage.Shared.TierUtility)
local StringLibrary = require(ReplicatedStorage.Shared.StringLibrary)
local PromptController = require(ReplicatedStorage.Controllers.PromptController)
local TextNotificationController = require(ReplicatedStorage.Controllers.TextNotificationController)
local FishSwimRuntime = require(ReplicatedStorage.Modules.FishSwimRuntime)
local ModelProvider = require(ReplicatedStorage.ModelProvider)
local ModelDownloader = require(ReplicatedStorage.Modules.ModelDownloader)
local InventoryPagination = require(ReplicatedStorage.Controllers.InventoryController.InventoryPagination)
local Renderer = require(ReplicatedStorage.Controllers.Trading.TradeController.Renderer)
local Welder = require(ReplicatedStorage.Shared.Welder)
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local v1 = Net:RemoteEvent("AquariumLoadVisit")
local v2 = Net:RemoteEvent("AquariumStateUpdated")
local v3 = Net:RemoteEvent("AquariumVisitEnded")
local v4 = Net:RemoteFunction("AquariumGetState")
local v5 = Net:RemoteFunction("AquariumGetDirectory")
local v6 = Net:RemoteFunction("AquariumSetPublic")
local v7 = Net:RemoteFunction("AquariumLike")
local v8 = Net:RemoteFunction("AquariumRequestVisit")
local v9 = Net:RemoteFunction("AquariumVisitLoaded")
local v10 = Net:RemoteFunction("AquariumUnlockZone")
local v11 = Net:RemoteFunction("AquariumUnlockTank")
local v12 = Net:RemoteFunction("AquariumSetTankFish")
local v13 = Net:RemoteFunction("AquariumRemoveTankFish")
local v14 = Net:RemoteFunction("AquariumPinShelfItem")
local v15 = Net:RemoteFunction("AquariumLeaveVisit")
local t = {}
local v16 = nil
local v17 = nil
local v18 = nil
local v19 = nil
local t2 = {}
local v20 = nil
local v21 = nil
local v22 = nil
local v23 = false
local v24 = nil
local v25 = nil
local v26 = 1
local v27 = 0
local v28 = false
local v29 = false
local v30 = 0
local v31 = false
local v32 = 0
local v33 = false
local v34 = nil
local t3 = {}
local v35 = Color3.fromRGB(44, 70, 124)
local t4 = { "Tier", "Weight", "Name" }
local v36 = 1
local t5 = {
	Name = function(p1, p2) --[[ Name | Line: 72 ]]
		if p1.Name == p2.Name then
			return p1.UUID < p2.UUID
		else
			return p1.Name < p2.Name
		end
	end,
	Weight = function(p1, p2) --[[ Weight | Line: 80 ]]
		if p1.Weight == p2.Weight then
			return p1.Name < p2.Name
		else
			return p1.Weight > p2.Weight
		end
	end,
	Tier = function(p1, p2) --[[ Tier | Line: 88 ]]
		if p1.Weight == p2.Weight then
			return p1.Name < p2.Name
		else
			return p1.Weight > p2.Weight
		end
	end,
	Default = function(p1, p2) --[[ Default | Line: 96 ]]
		return p1.Tier > p2.Tier
	end
}
local function notify(p1, p2) --[[ notify | Line: 101 | Upvalues: TextNotificationController (copy) ]]
	local t = {
		Type = "Text",
		Text = p1
	}
	t.TextColor = if p2 == false then {
	R = 255,
	G = 80,
	B = 80
} else {
	R = 120,
	G = 255,
	B = 120
}
	TextNotificationController:DeliverNotification(t)
end
local function normalize(p1) --[[ normalize | Line: 109 ]]
	return string.lower((tostring(p1 or ""))):gsub("[^%w]", "")
end
local function requestVisit(p1) --[[ requestVisit | Line: 113 | Upvalues: v8 (copy), notify (copy), GuiControl (copy) ]]
	local v1 = v8:InvokeServer(p1)
	if typeof(v1) == "table" and v1.Success then
		notify("Loading Aquarium...", true)
		GuiControl:Close(true)
		return
	end
	notify(if typeof(v1) == "table" and v1.Message then v1.Message else "Unable to load Aquarium", false)
end
local function refreshGuiState() --[[ refreshGuiState | Line: 124 | Upvalues: v4 (copy), v34 (ref), v5 (copy), t3 (ref) ]]
	local v1 = v4:InvokeServer()
	v34 = if typeof(v1) == "table" and v1.Success then v1.Data else nil
	local v2 = v5:InvokeServer()
	if typeof(v2) ~= "table" or not v2.Success then
		t3 = {}
		return
	end
	t3 = if typeof(v2.Data) == "table" then v2.Data else {}
end
local function setButtonBound(p1) --[[ setButtonBound | Line: 140 ]]
	if p1:GetAttribute("AquariumBound") then
		return false
	else
		p1:SetAttribute("AquariumBound", true)
		return true
	end
end
local v37 = nil
local v38 = nil
local v39 = nil
local v40 = nil
local function bindVisitButton(p1, p2) --[[ bindVisitButton | Line: 154 | Upvalues: GuiControl (copy), requestVisit (copy) ]]
	local v1
	if p1:GetAttribute("AquariumBound") then
		v1 = false
	else
		p1:SetAttribute("AquariumBound", true)
		v1 = true
	end
	if v1 then
		GuiControl:Hook("Hold Button", p1).Clicked:Connect(function() --[[ Line: 159 | Upvalues: requestVisit (ref), p2 (copy) ]]
			requestVisit(p2)
		end)
	end
end
local function bindPublicButton(p1, p2) --[[ bindPublicButton | Line: 164 | Upvalues: GuiControl (copy), v6 (copy), refreshGuiState (copy), v37 (ref), PlayerGui (copy), notify (copy) ]]
	local v1
	if p1:GetAttribute("AquariumBound") then
		v1 = false
	else
		p1:SetAttribute("AquariumBound", true)
		v1 = true
	end
	if v1 then
		GuiControl:Hook("Hold Button", p1).Clicked:Connect(function() --[[ Line: 169 | Upvalues: v6 (ref), p2 (copy), refreshGuiState (ref), v37 (ref), PlayerGui (ref), notify (ref) ]]
			local v1 = v6:InvokeServer(p2)
			if typeof(v1) == "table" and v1.Success then
				refreshGuiState()
				v37((PlayerGui:WaitForChild("Aquarium")))
				notify(v1.Message or "Aquarium updated", true)
				return
			end
			notify(if typeof(v1) == "table" and v1.Message then v1.Message else "Unable to update Aquarium", false)
		end)
	end
end
local function bindLikeButton(p1, p2) --[[ bindLikeButton | Line: 181 | Upvalues: GuiControl (copy), v7 (copy), refreshGuiState (copy), v37 (ref), PlayerGui (copy), notify (copy) ]]
	local v1
	if p1:GetAttribute("AquariumBound") then
		v1 = false
	else
		p1:SetAttribute("AquariumBound", true)
		v1 = true
	end
	if v1 then
		GuiControl:Hook("Hold Button", p1).Clicked:Connect(function() --[[ Line: 186 | Upvalues: v7 (ref), p2 (copy), refreshGuiState (ref), v37 (ref), PlayerGui (ref), notify (ref) ]]
			local v1 = v7:InvokeServer(p2)
			if typeof(v1) == "table" and v1.Success then
				refreshGuiState()
				v37((PlayerGui:WaitForChild("Aquarium")))
				notify(v1.Message or "Aquarium liked", true)
				return
			end
			notify(if typeof(v1) == "table" and v1.Message then v1.Message else "Unable to like Aquarium", false)
		end)
	end
end
local function setProfileImage(p1, p2) --[[ setProfileImage | Line: 198 | Upvalues: Players (copy) ]]
	task.spawn(function() --[[ Line: 199 | Upvalues: Players (ref), p2 (copy), p1 (copy) ]]
		local v1, v2 = pcall(function() --[[ Line: 200 | Upvalues: Players (ref), p2 (ref) ]]
			return Players:GetUserThumbnailAsync(p2, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
		end)
		if v1 then
			p1.Image = v2
		end
	end)
end
local function getSearchQuery(p1) --[[ getSearchQuery | Line: 211 | Upvalues: normalize (copy) ]]
	return normalize(p1.Main.Search.TextBox.Text)
end
v37 = function(p1) --[[ renderAquariumBrowser | Line: 215 | Upvalues: v34 (ref), GuiControl (copy), v6 (copy), refreshGuiState (copy), v37 (ref), PlayerGui (copy), notify (copy), LocalPlayer (copy), requestVisit (copy), t3 (ref), Players (copy), v7 (copy) ]]
	local Index = p1.Main.AquariumsCase.Index
	for i, v in ipairs(Index:GetChildren()) do
		if v:GetAttribute("AquariumGenerated") then
			v:Destroy()
		end
	end
	local MyAquariumTemplate = Index.MyAquariumTemplate
	local OpenedPlayerAquarium = Index.OpenedPlayerAquarium
	local ClosedPlayerAquariumTemplate = Index.ClosedPlayerAquariumTemplate
	Index.UnderwaterCity.Visible = false
	OpenedPlayerAquarium:SetAttribute("AquariumTemplate", true)
	ClosedPlayerAquariumTemplate:SetAttribute("AquariumTemplate", true)
	OpenedPlayerAquarium.Visible = false
	ClosedPlayerAquariumTemplate.Visible = false
	MyAquariumTemplate.Visible = true
	MyAquariumTemplate.LayoutOrder = 0
	local v1 = v34 and v34.State
	MyAquariumTemplate.MyAquarium.Text = "My Aquarium"
	MyAquariumTemplate.OnlinePlayers.Text = tostring(v34 and v34.VisitorCount or 0)
	MyAquariumTemplate.Likes.Text = tostring(v1 and v1.Likes or 0)
	local v4 = if v1 then v1.IsPublic == true else v1
	MyAquariumTemplate.LockedButton.Visible = not v4
	MyAquariumTemplate.UnlokedButton.Visible = v4
	local LockedButton = MyAquariumTemplate.LockedButton
	local v5
	if LockedButton:GetAttribute("AquariumBound") then
		v5 = false
	else
		LockedButton:SetAttribute("AquariumBound", true)
		v5 = true
	end
	if v5 then
		local v62 = true
		GuiControl:Hook("Hold Button", LockedButton).Clicked:Connect(function() --[[ Line: 169 | Upvalues: v6 (ref), v62 (copy), refreshGuiState (ref), v37 (ref), PlayerGui (ref), notify (ref) ]]
			local v1 = v6:InvokeServer(v62)
			if typeof(v1) == "table" and v1.Success then
				refreshGuiState()
				v37((PlayerGui:WaitForChild("Aquarium")))
				notify(v1.Message or "Aquarium updated", true)
				return
			end
			notify(if typeof(v1) == "table" and v1.Message then v1.Message else "Unable to update Aquarium", false)
		end)
	end
	local UnlokedButton = MyAquariumTemplate.UnlokedButton
	local v72
	if UnlokedButton:GetAttribute("AquariumBound") then
		v72 = false
	else
		UnlokedButton:SetAttribute("AquariumBound", true)
		v72 = true
	end
	if v72 then
		local v8 = false
		GuiControl:Hook("Hold Button", UnlokedButton).Clicked:Connect(function() --[[ Line: 169 | Upvalues: v6 (ref), v8 (copy), refreshGuiState (ref), v37 (ref), PlayerGui (ref), notify (ref) ]]
			local v1 = v6:InvokeServer(v8)
			if typeof(v1) == "table" and v1.Success then
				refreshGuiState()
				v37((PlayerGui:WaitForChild("Aquarium")))
				notify(v1.Message or "Aquarium updated", true)
				return
			end
			notify(if typeof(v1) == "table" and v1.Message then v1.Message else "Unable to update Aquarium", false)
		end)
	end
	local VisitButton = MyAquariumTemplate.VisitButton
	local UserId = LocalPlayer.UserId
	local v9
	if VisitButton:GetAttribute("AquariumBound") then
		v9 = false
	else
		VisitButton:SetAttribute("AquariumBound", true)
		v9 = true
	end
	if v9 then
		GuiControl:Hook("Hold Button", VisitButton).Clicked:Connect(function() --[[ Line: 159 | Upvalues: requestVisit (ref), UserId (copy) ]]
			requestVisit(UserId)
		end)
	end
	local v11, count = string.lower((tostring(p1.Main.Search.TextBox.Text or ""))):gsub("[^%w]", ""), 10
	for i, v in ipairs(t3) do
		local v12, v13
		if typeof(v) == "table" and v.UserId ~= LocalPlayer.UserId and (v11 == "" or (string.lower((tostring(v.Name or ""))):gsub("[^%w]", ""):find(v11, 1, true) or string.lower((tostring(v.DisplayName or ""))):gsub("[^%w]", ""):find(v11, 1, true))) then
			local v14, v15, v16, v17, v18, v19, v20, v21, v22, v23, v24, v25
			v14 = if v.IsPublic == true then OpenedPlayerAquarium else ClosedPlayerAquariumTemplate
			v15 = v14:Clone()
			v15.Name = ("PlayerAquarium_%*"):format(v.UserId)
			v15:SetAttribute("AquariumTemplate", nil)
			v15:SetAttribute("AquariumGenerated", true)
			v15:SetAttribute("TargetUserId", v.UserId)
			v15.Visible = true
			v15.LayoutOrder = count
			count = count + 1
			v15.Nickname.Text = v.DisplayName
			v15.Username.Text = ("@%*"):format(v.Name)
			v16 = v15.OnlinePlayers
			v17 = v.VisitorCount or 0
			v16.Text = tostring(v17)
			v18 = v15.Likes
			v19 = v.Likes or 0
			v18.Text = tostring(v19)
			v20 = v15.PFP.PFP
			v21 = v.UserId
			task.spawn(function() --[[ Line: 199 | Upvalues: Players (ref), v21 (copy), v20 (copy) ]]
				local v1, v2 = pcall(function() --[[ Line: 200 | Upvalues: Players (ref), v21 (ref) ]]
					return Players:GetUserThumbnailAsync(p2, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
				end)
				if v1 then
					v20.Image = v2
				end
			end)
			if v.IsPublic == true then
				v15.VisitButton:SetAttribute("AquariumBound", nil)
				v22 = v15.VisitButton
				v23 = v.UserId
				if v22:GetAttribute("AquariumBound") then
					v12 = false
				else
					v22:SetAttribute("AquariumBound", true)
					v12 = true
				end
				if v12 then
					GuiControl:Hook("Hold Button", v22).Clicked:Connect(function() --[[ Line: 159 | Upvalues: requestVisit (ref), v23 (copy) ]]
						requestVisit(v23)
					end)
				end
				v15.LikeButtonOn:SetAttribute("AquariumBound", nil)
				v24 = v15.LikeButtonOn
				v25 = v.UserId
				if v24:GetAttribute("AquariumBound") then
					v13 = false
				else
					v24:SetAttribute("AquariumBound", true)
					v13 = true
				end
				if v13 then
					GuiControl:Hook("Hold Button", v24).Clicked:Connect(function() --[[ Line: 186 | Upvalues: v7 (ref), v25 (copy), refreshGuiState (ref), v37 (ref), PlayerGui (ref), notify (ref) ]]
						local v1 = v7:InvokeServer(v25)
						if typeof(v1) == "table" and v1.Success then
							refreshGuiState()
							v37((PlayerGui:WaitForChild("Aquarium")))
							notify(v1.Message or "Aquarium liked", true)
							return
						end
						notify(if typeof(v1) == "table" and v1.Message then v1.Message else "Unable to like Aquarium", false)
					end)
				end
			else
				v15.VisitButtonDisabled.Active = false
				v15.VisitButtonDisabled:SetAttribute("AquariumBound", true)
				v15.LikeButtonDisabled.Active = false
				v15.LikeButtonDisabled:SetAttribute("AquariumBound", true)
			end
			v15.Parent = Index
		end
	end
end
local function bindAquariumGui() --[[ bindAquariumGui | Line: 289 | Upvalues: PlayerGui (copy), v37 (ref), GuiControl (copy) ]]
	local Aquarium = PlayerGui:WaitForChild("Aquarium")
	v37(Aquarium)
	local Close = Aquarium.Main.Close
	local v1
	if Close:GetAttribute("AquariumBound") then
		v1 = false
	else
		Close:SetAttribute("AquariumBound", true)
		v1 = true
	end
	if v1 then
		GuiControl:Hook("Hold Button", Aquarium.Main.Close).Clicked:Connect(function() --[[ Line: 294 | Upvalues: GuiControl (ref) ]]
			GuiControl:Close(true)
		end)
	end
	local TextBox = Aquarium.Main.Search.TextBox
	if TextBox:GetAttribute("AquariumBound") then
		return
	end
	TextBox:SetAttribute("AquariumBound", true)
	TextBox:GetPropertyChangedSignal("Text"):Connect(function() --[[ Line: 302 | Upvalues: v37 (ref), Aquarium (copy) ]]
		v37(Aquarium)
	end)
end
local function getTankManagementGui() --[[ getTankManagementGui | Line: 309 | Upvalues: PlayerGui (copy) ]]
	return PlayerGui:WaitForChild("TankManagement")
end
local function getActiveTankState() --[[ getActiveTankState | Line: 313 | Upvalues: v18 (ref), v25 (ref) ]]
	if v18 and (v18.Tanks and v25) then
		return v18.Tanks[v25]
	else
		return nil
	end
end
local function getFirstOpenManagementSlot() --[[ getFirstOpenManagementSlot | Line: 321 | Upvalues: v18 (ref), v25 (ref), AquariumConfig (copy) ]]
	local v1 = if v18 and (v18.Tanks and v25) then v18.Tanks[v25] else nil
	local v2 = v25 and AquariumConfig.Tanks[v25]
	if not (v1 and v2) then
		return 1
	end
	for i = 1, v2.Capacity do
		if v1.Fish[i] == nil then
			return i
		end
	end
	return 1
end
local function getTankFishCount(p1) --[[ getTankFishCount | Line: 337 ]]
	local count = 0
	if not (p1 and p1.Fish) then
		return count
	end
	for k, v in pairs(p1.Fish) do
		if v then
			count = count + 1
		end
	end
	return count
end
local function getFishWeight(p1, p2) --[[ getFishWeight | Line: 352 ]]
	if p1 and typeof(p1.Weight) == "number" then
		return p1.Weight
	end
	local v1 = if p2 then p2.Weight else p2
	local v2 = if v1 then v1.Default else v1
	if v2 then
		return (v2.Min + v2.Max) * 0.5
	else
		return 0
	end
end
local function clearGeneratedTiles(p1, p2) --[[ clearGeneratedTiles | Line: 366 ]]
	for i, v in ipairs(p1:GetChildren()) do
		if v:GetAttribute(p2) then
			v:Destroy()
		end
	end
end
local function cleanupTankInventory() --[[ cleanupTankInventory | Line: 374 | Upvalues: v21 (ref), v20 (ref), v22 (ref) ]]
	if v21 then
		v21:Destroy()
		v21 = nil
	end
	if not v20 then
		v22 = nil
		return
	end
	v20:Destroy()
	v20 = nil
	v22 = nil
end
local function cleanupTankManagementGui(p1) --[[ cleanupTankManagementGui | Line: 388 | Upvalues: v27 (ref), clearGeneratedTiles (copy), v21 (ref), v20 (ref), v22 (ref), v25 (ref), v26 (ref), v18 (ref), AquariumConfig (copy) ]]
	v27 = v27 + 1
	clearGeneratedTiles(p1.Main.Aquarium.FishCase.Index, "AquariumGenerated")
	if v21 then
		v21:Destroy()
		v21 = nil
	end
	if v20 then
		v20:Destroy()
		v20 = nil
	end
	v22 = nil
	v25 = nil
	local v1 = if v18 and (v18.Tanks and v25) then v18.Tanks[v25] else nil
	local v2 = v25 and AquariumConfig.Tanks[v25]
	local v3
	if v1 and v2 then
		for i = 1, v2.Capacity do
			if v1.Fish[i] == nil then
				v3 = i
				v26 = i
				return
			end
		end
	end
	v3 = 1
	v26 = v3
end
local function hideTemplateTiles(p1, p2) --[[ hideTemplateTiles | Line: 397 ]]
	for i, v in ipairs(p1:GetChildren()) do
		if v:IsA("ImageButton") and (v.Name ~= p2 and not (v:GetAttribute("AquariumGenerated") or v:GetAttribute("AquariumInventoryGenerated"))) then
			v:SetAttribute("AquariumTemplate", true)
			v.Visible = false
		end
	end
end
local function displayedFishUUIDs() --[[ displayedFishUUIDs | Line: 406 | Upvalues: v18 (ref) ]]
	local t = {}
	if not (v18 and v18.Tanks) then
		return t
	end
	for k, v in pairs(v18.Tanks) do
		if typeof(v) == "table" and typeof(v.Fish) == "table" then
			for k2, v2 in pairs(v.Fish) do
				if typeof(v2) == "table" and typeof(v2.UUID) == "string" then
					t[v2.UUID] = true
				end
			end
		end
	end
	return t
end
local function bindTankManagementFishTile(p1, p2, p3) --[[ bindTankManagementFishTile | Line: 427 | Upvalues: GuiControl (copy), v26 (ref), notify (copy), v38 (ref), PlayerGui (copy) ]]
	p1:SetAttribute("AquariumBound", nil)
	local v1
	if p1:GetAttribute("AquariumBound") then
		v1 = false
	else
		p1:SetAttribute("AquariumBound", true)
		v1 = true
	end
	if v1 then
		GuiControl:Hook("Hold Button", p1).Clicked:Connect(function() --[[ Line: 433 | Upvalues: v26 (ref), p2 (copy), notify (ref), v38 (ref), PlayerGui (ref) ]]
			v26 = p2
			notify(("Selected slot %*"):format(p2), true)
			v38((PlayerGui:WaitForChild("TankManagement")))
		end)
	end
end
local function bindTankInventoryTile(p1, p2) --[[ bindTankInventoryTile | Line: 440 | Upvalues: GuiControl (copy), v25 (ref), v18 (ref), v12 (copy), v26 (ref), AquariumConfig (copy), v30 (ref), notify (copy), v39 (ref), v40 (ref), PlayerGui (copy) ]]
	p1:SetAttribute("AquariumBound", nil)
	local v1
	if p1:GetAttribute("AquariumBound") then
		v1 = false
	else
		p1:SetAttribute("AquariumBound", true)
		v1 = true
	end
	if v1 then
		GuiControl:Hook("Hold Button", p1).Clicked:Connect(function() --[[ Line: 446 | Upvalues: v25 (ref), v18 (ref), v12 (ref), v26 (ref), p2 (copy), AquariumConfig (ref), v30 (ref), notify (ref), v39 (ref), v40 (ref), PlayerGui (ref) ]]
			if not v25 then
				return
			end
			local v1 = v18
			local v2 = v12:InvokeServer(v25, v26, p2)
			if typeof(v2) == "table" and v2.Success then
				v18 = v2.Data or v18
				local v4 = AquariumConfig.Tanks[v25]
				local v5 = if v18 and (v18.Tanks and v25) then v18.Tanks[v25] else nil
				if v4 and v5 then
					local count = 0
					if v5 and v5.Fish then
						for k, v in pairs(v5.Fish) do
							if v then
								count = count + 1
							end
						end
					end
					if count < v4.Capacity then
						local v7 = if v18 and (v18.Tanks and v25) then v18.Tanks[v25] else nil
						local v8 = v25 and AquariumConfig.Tanks[v25]
						local v9
						if v7 and v8 then
							for i = 1, v8.Capacity do
								if v7.Fish[i] == nil then
									v9 = i
									v26 = i
									v30 = 0
									notify("Fish added", true)
									v39()
									v40(PlayerGui:WaitForChild("TankManagement"), v1, v18)
									return
								end
							end
						end
						v9 = 1
						v26 = v9
					end
				end
				v30 = 0
				notify("Fish added", true)
				v39()
				v40(PlayerGui:WaitForChild("TankManagement"), v1, v18)
			else
				notify(if typeof(v2) == "table" and v2.Message then v2.Message else "Unable to add fish", false)
			end
		end)
	end
end
local function getTankStateFrom(p1, p2) --[[ getTankStateFrom | Line: 470 ]]
	return if p1 then p1.Tanks and p1.Tanks[p2] else p1
end
local function getTankInventorySortMode() --[[ getTankInventorySortMode | Line: 474 | Upvalues: t4 (copy), v36 (ref) ]]
	return t4[v36]
end
local function getTankInventorySortText() --[[ getTankInventorySortText | Line: 478 | Upvalues: t4 (copy), v36 (ref) ]]
	return ("Sort by: %*"):format(t4[v36])
end
local function compareTankInventoryEntries() --[[ compareTankInventoryEntries | Line: 482 | Upvalues: t4 (copy), v36 (ref), t5 (copy) ]]
	return t5[t4[v36]] or t5.Default
end
local function createTankFishTile(p1, p2, p3, p4) --[[ createTankFishTile | Line: 488 | Upvalues: ItemUtility (copy), AquariumConfig (copy), Renderer (copy), StringLibrary (copy), v26 (ref), bindTankManagementFishTile (copy) ]]
	local v1 = ItemUtility:GetItemData(p3.Id)
	if not v1 then
		return nil
	end
	local v2 = p3.Size or AquariumConfig.GetFishSize(v1, p3.Metadata)
	local Metadata = p3.Metadata
	local v3
	if Metadata and typeof(Metadata.Weight) == "number" then
		v3 = Metadata.Weight
	else
		local v4, v5
		v4 = if v1 then v1.Weight else v1
		v5 = if v4 then v4.Default else v4
		v3 = if v5 then (v5.Min + v5.Max) * 0.5 else 0
	end
	local v6 = Renderer.getTierData(v1)
	local v7 = p1.Template:Clone()
	v7.Name = ("Slot_%*"):format(p2)
	v7:SetAttribute("AquariumTemplate", nil)
	v7:SetAttribute("AquariumGenerated", true)
	v7.Visible = true
	v7.LayoutOrder = p4
	v7.Label.Text = p3.Name or v1.Data.Name or "Fish"
	v7.FishIcon.Image = v1.Data.Icon or ""
	v7.Configuration.Shiny.Visible = false
	v7.Configuration.Big.Visible = if v2 == "Large" then true else false
	v7.Configuration.Big.Text = "Large"
	v7.Configuration.Huge.Visible = if v2 == "Huge" then true else false
	v7.Configuration.Huge.Text = "Huge"
	if v3 then
		v7.Configuration.Weight.Text = StringLibrary:AddWeight(v3)
		v7.Configuration.Weight.Visible = true
	else
		v7.Configuration.Weight.Visible = false
	end
	v7.UIGradient.Color = v6.TierColor
	v7.Coloured.Color = if v26 == p2 then Color3.new(255/255, 255/255, 255/255) else v6.TierColor.Keypoints[1].Value
	v7.Shadow.UIGradient.Color = v6.TierColor
	bindTankManagementFishTile(v7, p2, p3.UUID)
	v7.Parent = p1
	return v7
end
local function drawTankInventoryEntry(p1, p2) --[[ drawTankInventoryEntry | Line: 529 | Upvalues: v20 (ref), Renderer (copy), bindTankInventoryTile (copy) ]]
	if not v20 then
		return
	end
	local Item = p1.Item
	local v2 = v20.Tiles[Renderer.getTileId(p1.ItemData, Item.UUID)]
	if v2 then
		v2.Tile.LayoutOrder = p1.LayoutOrder or p2
		v2.Tile.Visible = true
		return
	end
	local v3
	if Item.Metadata and Item.Metadata.TradeLock then
		local v4 = table.clone(Item)
		v4.Metadata = table.clone(Item.Metadata)
		v4.Metadata.TradeLock = nil
		v3 = v4
	else
		v3 = Item
	end
	local v5 = v20:Draw("Fish", Item.Id, v3, p1.LayoutOrder or p2)
	if not v5 then
		return
	end
	v5.Tile:SetAttribute("AquariumInventoryGenerated", true)
	bindTankInventoryTile(v5.Tile, Item.UUID)
end
local function refreshTankInventoryOptions(p1, p2) --[[ refreshTankInventoryOptions | Line: 558 | Upvalues: v25 (ref), AquariumConfig (copy), v22 (ref), v21 (ref), v20 (ref), Renderer (copy), LocalPlayer (copy), displayedFishUUIDs (copy), v16 (ref), ItemUtility (copy), t4 (copy), v36 (ref), t5 (copy), InventoryPagination (copy), drawTankInventoryEntry (copy) ]]
	if not v25 then
		return
	end
	local v1 = AquariumConfig.Tanks[v25]
	if not v1 then
		return
	end
	local Index = p1.Main.Inventory.AquariumsCase.Index
	if p2 or v22 ~= v25 then
		if v21 then
			v21:Destroy()
			v21 = nil
		end
		if v20 then
			v20:Destroy()
			v20 = nil
		end
		v22 = nil
	end
	if not v20 then
		v20 = Renderer.new(LocalPlayer, nil, Index, true, true)
	end
	v22 = v25
	local v2 = displayedFishUUIDs()
	local v3 = v16 and v16:Get({ "Inventory", "Items" }) or {}
	local v5, v6, v7 = string.lower((tostring(p1.Main.Inventory.Search.TextBox.Text or ""))):gsub("[^%w]", ""), {}, {}
	for k, v in pairs(v3) do
		local v8
		if typeof(v) == "table" and (typeof(v.UUID) == "string" and not v2[v.UUID]) then
			local v9 = ItemUtility.GetItemDataFromItemType("Fish", v.Id)
			if v9 and v9.Data.Type == "Fish" then
				local v11 = string.lower((tostring(v9.Data.Name or ""))):gsub("[^%w]", "")
				if v5 == "" or v11:find(v5, 1, true) then
					local v12 = v11
					if AquariumConfig.TankSupportsSize(v1, (AquariumConfig.GetFishSize(v9, v.Metadata))) then
						v6[v.UUID] = true
						local t = {
							Category = "Fish",
							Item = v,
							ItemData = v9,
							UUID = v.UUID,
							Name = v12,
							Tier = v9.Data.Tier or 1
						}
						local Metadata = v.Metadata
						if Metadata and typeof(Metadata.Weight) == "number" then
							v8 = Metadata.Weight
						else
							local v14, v15
							v14 = if v9 then v9.Weight else v9
							v15 = if v14 then v14.Default else v14
							v8 = if v15 then (v15.Min + v15.Max) * 0.5 else 0
						end
						t.Weight = v8
						table.insert(v7, t)
					end
				end
			end
		end
	end
	table.sort(v7, t5[t4[v36]] or t5.Default)
	for i, v in ipairs(v7) do
		v.LayoutOrder = i
	end
	local list = {}
	for k, v in pairs(v20.Tiles) do
		local Item = v.Item
		if Item and v6[Item.UUID] then
			v.Tile.Visible = false
			continue
		end
		table.insert(list, v.Tile)
	end
	for i, v in ipairs(list) do
		v20:DestroyTileFromTile(v)
	end
	local v17 = if v21 then v21:GetLoadedCount() else 24
	if v21 then
		v21:Destroy()
		v21 = nil
	end
	v21 = InventoryPagination.new(Index, {
		ItemsPerPage = 24,
		OnPageLoaded = function() --[[ OnPageLoaded | Line: 651 | Upvalues: Index (copy) ]]
			local v1 = Index:FindFirstChildWhichIsA("UIGridLayout")
			if not v1 then
				return
			end
			Index.CanvasSize = UDim2.new(0, 0, 0, v1.AbsoluteContentSize.Y)
		end
	})
	v21:SetItems(v7)
	if v21:GetTotalItems() == 0 then
		return
	end
	for i = 1, math.max(1, (math.ceil(math.min(v17, v21:GetTotalItems()) / 24))) do
		v21:LoadNextPage(drawTankInventoryEntry)
	end
	v21:StartScrollMonitoring(drawTankInventoryEntry)
end
v40 = function(p1, p2, p3) --[[ Line: 672 | Upvalues: v25 (ref), AquariumConfig (copy), createTankFishTile (copy), v26 (ref), v35 (copy), refreshTankInventoryOptions (copy) ]]
	if not v25 then
		return
	end
	local v1 = AquariumConfig.Tanks[v25]
	local v3 = if p3 then p3.Tanks and p3.Tanks[v25] else p3
	if not (v1 and v3) then
		return
	end
	local v5 = if p2 then p2.Tanks and p2.Tanks[v25] else p2
	local Aquarium = p1.Main.Aquarium
	local Index = Aquarium.FishCase.Index
	local AddMore = Index:WaitForChild("AddMore")
	local count = 0
	if v3 and v3.Fish then
		for k, v in pairs(v3.Fish) do
			if v then
				count = count + 1
			end
		end
	end
	Aquarium.StatsCase.CapacityValue.Text = ("%*/%*"):format(count, v1.Capacity)
	for i = 1, v1.Capacity do
		local v8 = if v5 then v5.Fish and v5.Fish[i] else v5
		local v9 = v3.Fish[i]
		local v10 = if typeof(v8) == "table" then v8.UUID else nil
		if v10 ~= (if typeof(v9) == "table" then v9.UUID else nil) then
			local v12 = Index:FindFirstChild((("Slot_%*"):format(i)))
			if v12 then
				v12:Destroy()
			end
			if typeof(v9) == "table" then
				createTankFishTile(Index, i, v9, i + 10)
			end
		end
	end
	AddMore.LayoutOrder = 10 + v1.Capacity + 1
	local count_2 = 0
	if v3 and v3.Fish then
		for k, v in pairs(v3.Fish) do
			if v then
				count_2 = count_2 + 1
			end
		end
	end
	AddMore.Visible = if count_2 < v1.Capacity then true else false
	AddMore.Coloured.Color = if AddMore.Visible and v3.Fish[v26] == nil then Color3.new(255/255, 255/255, 255/255) else v35
	refreshTankInventoryOptions(p1, false)
end
v38 = function(p1, p2) --[[ renderTankManagement | Line: 716 | Upvalues: v25 (ref), v27 (ref), AquariumConfig (copy), v18 (ref), clearGeneratedTiles (copy), hideTemplateTiles (copy), ItemUtility (copy), Renderer (copy), StringLibrary (copy), v26 (ref), bindTankManagementFishTile (copy), v35 (copy), refreshTankInventoryOptions (copy) ]]
	if not v25 then
		return
	end
	v27 = v27 + 1
	local v1 = v27
	local v2 = AquariumConfig.Tanks[v25]
	local v3 = if v18 and (v18.Tanks and v25) then v18.Tanks[v25] else nil
	if not (v2 and v3) then
		return
	end
	local Main = p1.Main
	local Aquarium = Main.Aquarium
	local Index_2 = Aquarium.FishCase.Index
	local AddMore = Index_2:WaitForChild("AddMore")
	clearGeneratedTiles(Index_2, "AquariumGenerated")
	hideTemplateTiles(Main.Inventory.AquariumsCase.Index)
	hideTemplateTiles(Index_2, "AddMore")
	Aquarium.TankContainer.TankName.Text = v25
	local count = 0
	if v3 and v3.Fish then
		for k, v in pairs(v3.Fish) do
			if v then
				count = count + 1
			end
		end
	end
	Aquarium.StatsCase.CapacityValue.Text = ("%*/%*"):format(count, v2.Capacity)
	Aquarium.StatsCase.TankSize.Text = table.concat(v2.SupportedSizes, ", ")
	Aquarium.DescriptionCase.Label.Text = ("Managing %*"):format(v25)
	local Template = Index_2.Template
	local count_2 = 10
	for i = 1, v2.Capacity do
		local v6
		if v1 ~= v27 then
			return
		end
		local v7 = v3.Fish[i]
		if typeof(v7) == "table" then
			local v8 = ItemUtility:GetItemData(v7.Id)
			local v9 = v7.Size or AquariumConfig.GetFishSize(v8, v7.Metadata)
			local Metadata = v7.Metadata
			if Metadata and typeof(Metadata.Weight) == "number" then
				v6 = Metadata.Weight
			else
				local v10, v11
				v10 = if v8 then v8.Weight else v8
				v11 = if v10 then v10.Default else v10
				v6 = if v11 then (v11.Min + v11.Max) * 0.5 else 0
			end
			local v12 = Renderer.getTierData(v8)
			local v13 = Template:Clone()
			v13.Name = ("Slot_%*"):format(i)
			v13:SetAttribute("AquariumTemplate", nil)
			v13:SetAttribute("AquariumGenerated", true)
			v13.Visible = true
			v13.LayoutOrder = count_2
			count_2 = count_2 + 1
			v13.Label.Text = v7.Name or v8 and v8.Data.Name or "Fish"
			v13.FishIcon.Image = v8 and v8.Data.Icon or ""
			v13.Configuration.Shiny.Visible = false
			v13.Configuration.Big.Visible = if v9 == "Large" then true else false
			v13.Configuration.Big.Text = "Large"
			v13.Configuration.Huge.Visible = if v9 == "Huge" then true else false
			v13.Configuration.Huge.Text = "Huge"
			if v6 then
				v13.Configuration.Weight.Text = StringLibrary:AddWeight(v6)
				v13.Configuration.Weight.Visible = true
			else
				v13.Configuration.Weight.Visible = false
			end
			v13.UIGradient.Color = v12.TierColor
			v13.Coloured.Color = if v26 == i then Color3.new(255/255, 255/255, 255/255) else v12.TierColor.Keypoints[1].Value
			v13.Shadow.UIGradient.Color = v12.TierColor
			bindTankManagementFishTile(v13, i, v7.UUID)
			v13.Parent = Index_2
		end
	end
	task.wait(0)
	if v1 ~= v27 then
		return
	end
	AddMore.LayoutOrder = count_2
	local count_3 = 0
	if v3 and v3.Fish then
		for k, v in pairs(v3.Fish) do
			if v then
				count_3 = count_3 + 1
			end
		end
	end
	AddMore.Visible = if count_3 < v2.Capacity then true else false
	AddMore.Coloured.Color = if AddMore.Visible and v3.Fish[v26] == nil then Color3.new(255/255, 255/255, 255/255) else v35
	refreshTankInventoryOptions(p1, p2 == true)
end
local function bindTankManagementGui() --[[ bindTankManagementGui | Line: 806 | Upvalues: PlayerGui (copy), t4 (copy), v36 (ref), GuiControl (copy), refreshTankInventoryOptions (copy), notify (copy), v26 (ref), v18 (ref), v25 (ref), AquariumConfig (copy), v38 (ref), v13 (copy), v30 (ref), v39 (ref), v40 (ref) ]]
	local TankManagement = PlayerGui:WaitForChild("TankManagement")
	local SortBy = TankManagement.Main.Inventory.SortBy
	SortBy.Label.Text = ("Sort by: %*"):format(t4[v36])
	local v1
	if SortBy:GetAttribute("AquariumBound") then
		v1 = false
	else
		SortBy:SetAttribute("AquariumBound", true)
		v1 = true
	end
	if v1 then
		GuiControl:Hook("Hold Button", SortBy).Clicked:Connect(function() --[[ Line: 812 | Upvalues: v36 (ref), t4 (ref), SortBy (copy), refreshTankInventoryOptions (ref), TankManagement (copy), notify (ref) ]]
			v36 = v36 % #t4 + 1
			SortBy.Label.Text = ("Sort by: %*"):format(t4[v36])
			refreshTankInventoryOptions(TankManagement, false)
			notify(("Sorted by %*"):format(t4[v36]), true)
		end)
	end
	local TextBox = TankManagement.Main.Inventory.Search.TextBox
	if not TextBox:GetAttribute("AquariumBound") then
		TextBox:SetAttribute("AquariumBound", true)
		TextBox:GetPropertyChangedSignal("Text"):Connect(function() --[[ Line: 823 | Upvalues: refreshTankInventoryOptions (ref), TankManagement (copy) ]]
			refreshTankInventoryOptions(TankManagement, false)
		end)
	end
	local Aquarium = TankManagement.Main.Aquarium
	local AddMore = Aquarium.FishCase.Index:WaitForChild("AddMore")
	local v2
	if AddMore:GetAttribute("AquariumBound") then
		v2 = false
	else
		AddMore:SetAttribute("AquariumBound", true)
		v2 = true
	end
	if v2 then
		GuiControl:Hook("Hold Button", AddMore).Clicked:Connect(function() --[[ Line: 831 | Upvalues: v26 (ref), v18 (ref), v25 (ref), AquariumConfig (ref), notify (ref), v38 (ref), TankManagement (copy) ]]
			local v1 = if v18 and (v18.Tanks and v25) then v18.Tanks[v25] else nil
			local v2 = v25 and AquariumConfig.Tanks[v25]
			local v3
			if v1 and v2 then
				for i = 1, v2.Capacity do
					if v1.Fish[i] == nil then
						v3 = i
						v26 = i
						notify(("Selected slot %*"):format(i), true)
						v38(TankManagement)
						return
					end
				end
			end
			v3 = 1
			v26 = v3
			notify(("Selected slot %*"):format(v3), true)
			v38(TankManagement)
		end)
	end
	local Remove = Aquarium:WaitForChild("Remove")
	local v3
	if Remove:GetAttribute("AquariumBound") then
		v3 = false
	else
		Remove:SetAttribute("AquariumBound", true)
		v3 = true
	end
	if not v3 then
		return
	end
	GuiControl:Hook("Hold Button", Remove).Clicked:Connect(function() --[[ Line: 840 | Upvalues: v25 (ref), v18 (ref), v13 (ref), v26 (ref), v30 (ref), notify (ref), v39 (ref), v40 (ref), TankManagement (copy) ]]
		if not v25 then
			return
		end
		local v1 = v18
		local v2 = v13:InvokeServer(v25, v26)
		if typeof(v2) == "table" and v2.Success then
			v18 = v2.Data or v18
			v30 = 0
			notify("Fish removed", true)
			v39()
			v40(TankManagement, v1, v18)
		else
			notify(if typeof(v2) == "table" and v2.Message then v2.Message else "Unable to remove fish", false)
		end
	end)
end
local function openTankManagement(p1) --[[ openTankManagement | Line: 860 | Upvalues: GuiControl (copy), v25 (ref), v26 (ref), v18 (ref), AquariumConfig (copy), v38 (ref), PlayerGui (copy) ]]
	GuiControl:Open("TankManagement", true, p1)
	v25 = p1
	local v1 = if v18 and (v18.Tanks and p1) then v18.Tanks[p1] else nil
	local v2 = p1 and AquariumConfig.Tanks[p1]
	local v3
	if v1 and v2 then
		for i = 1, v2.Capacity do
			if v1.Fish[i] == nil then
				v3 = i
				v26 = i
				v38(PlayerGui:WaitForChild("TankManagement"), true)
				return
			end
		end
	end
	v3 = 1
	v26 = v3
	v38(PlayerGui:WaitForChild("TankManagement"), true)
end
local function queueTankManagementRender() --[[ queueTankManagementRender | Line: 867 | Upvalues: v28 (ref), GuiControl (copy), v38 (ref), PlayerGui (copy) ]]
	if not v28 then
		v28 = true
		task.defer(function() --[[ Line: 873 | Upvalues: v28 (ref), GuiControl (ref), v38 (ref), PlayerGui (ref) ]]
			v28 = false
			if not GuiControl:IsOpen("TankManagement") then
				return
			end
			v38((PlayerGui:WaitForChild("TankManagement")))
		end)
	end
end
local function clearActiveAquarium() --[[ clearActiveAquarium | Line: 881 | Upvalues: v17 (ref), v19 (ref), t2 (copy), v18 (ref), v23 (ref), v24 (ref), v25 (ref), v26 (ref), v29 (ref), v30 (ref), v31 (ref), v32 (ref), v33 (ref) ]]
	if v17 then
		v17:Destroy()
		v17 = nil
	end
	if v19 then
		v19:Destroy()
		v19 = nil
	end
	table.clear(t2)
	v18 = nil
	v23 = false
	v24 = nil
	v25 = nil
	v26 = 1
	v29 = false
	v30 = 0
	v31 = false
	v32 = 0
	v33 = false
end
local function getAquariumTemplate() --[[ getAquariumTemplate | Line: 905 | Upvalues: ReplicatedStorage (copy), AquariumConfig (copy) ]]
	return ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Aquariums"):WaitForChild(AquariumConfig.AssetName)
end
local function getConfig(p1) --[[ getConfig | Line: 909 ]]
	local Config = p1:FindFirstChild("Config")
	if Config and Config:IsA("Folder") then
		return Config
	else
		return nil
	end
end
local function findPromptParent(p1) --[[ findPromptParent | Line: 918 ]]
	if p1:IsA("Attachment") then
		return p1
	end
	local Prompt = p1:FindFirstChild("Prompt", true)
	if Prompt and Prompt:IsA("Attachment") then
		return Prompt
	end
	if p1:IsA("BasePart") then
		return p1
	end
	if p1:IsA("Model") then
		local PrimaryPart = p1.PrimaryPart
		if PrimaryPart then
			return PrimaryPart
		end
	end
	return p1:FindFirstChildWhichIsA("BasePart", true)
end
local function destroyPromptParentPrompts(p1) --[[ destroyPromptParentPrompts | Line: 942 ]]
	for i, v in ipairs(p1:GetChildren()) do
		if v:IsA("ProximityPrompt") and v.Name == "AquariumPrompt" then
			v:Destroy()
		end
	end
end
local function createPrompt(p1, p2, p3) --[[ createPrompt | Line: 950 | Upvalues: findPromptParent (copy), destroyPromptParentPrompts (copy) ]]
	local v1 = findPromptParent(p1)
	if v1 then
		destroyPromptParentPrompts(v1)
		local AquariumPrompt = Instance.new("ProximityPrompt")
		AquariumPrompt.Name = "AquariumPrompt"
		AquariumPrompt.ActionText = p2
		AquariumPrompt.ObjectText = p3
		AquariumPrompt.KeyboardKeyCode = Enum.KeyCode.E
		AquariumPrompt.Style = Enum.ProximityPromptStyle.Custom
		AquariumPrompt.HoldDuration = 0.35
		AquariumPrompt.RequiresLineOfSight = false
		AquariumPrompt.MaxActivationDistance = 12
		AquariumPrompt.Parent = v1
		return AquariumPrompt
	else
		return nil
	end
end
local function getContainerParts(p1) --[[ getContainerParts | Line: 972 ]]
	local FishContainer = p1:FindFirstChild("FishContainer")
	if not FishContainer then
		return {}
	end
	local t = {}
	for i, v in ipairs(FishContainer:GetDescendants()) do
		if v:IsA("BasePart") then
			table.insert(t, v)
		end
	end
	if FishContainer:IsA("BasePart") then
		table.insert(t, FishContainer)
	end
	return t
end
local function fishRenderKey(p1, p2) --[[ fishRenderKey | Line: 992 ]]
	return ("%*:%*"):format(p1, p2)
end
local function refreshFish(p1) --[[ refreshFish | Line: 996 | Upvalues: v17 (ref), v19 (ref), FishSwimRuntime (copy), v18 (ref), t2 (copy), getContainerParts (copy), ModelDownloader (copy), ModelProvider (copy), LocalPlayer (copy), v30 (ref), v31 (ref), v39 (ref) ]]
	if not v17 then
		return
	end
	if not v19 then
		v19 = FishSwimRuntime.new(v17, FishSwimRuntime.Priorty.Extreme)
	end
	local Tanks = p1:FindFirstChild("Tanks")
	if Tanks and v18 and typeof(v18.Tanks) == "table" then
		local t = {}
		local v1 = false
		for k, v in pairs(v18.Tanks) do
			if typeof(v) == "table" and v.Unlocked == true and typeof(v.Fish) == "table" then
				local v2 = Tanks:FindFirstChild(k)
				if v2 then
					local v3 = getContainerParts(v2)
					if #v3 ~= 0 then
						for k2, v4 in pairs(v.Fish) do
							if typeof(v4) == "table" and typeof(v4.Id) == "number" then
								local v42 = ("%*:%*"):format(k, k2)
								local v5 = ("%*:%*"):format(v4.UUID or "", v4.Id)
								t[v42] = true
								if t2[v42] ~= v5 then
									v19:RemoveFish(v42)
									t2[v42] = nil
									if ModelDownloader:GetModel("Fish", v4.Id, false) then
										local v6 = ModelProvider:GetModel(LocalPlayer, "Fish", {
											Quantity = 1,
											Timestamp = 0,
											Id = v4.Id,
											UUID = v4.UUID or "",
											Metadata = v4.Metadata
										}, false)
										if v6 then
											v19:AddFish(v6, v3, v42)
											t2[v42] = v5
											continue
										end
										v1 = true
										continue
									end
									v1 = true
								end
							end
						end
					end
				end
			end
		end
		for k in pairs(t2) do
			if not t[k] then
				v19:RemoveFish(k)
				t2[k] = nil
			end
		end
		if not v1 or (not (v30 < 6) or v31) then
			return
		end
		v30 = v30 + 1
		v31 = true
		task.delay(0.5, function() --[[ Line: 1078 | Upvalues: v31 (ref), v17 (ref), v39 (ref) ]]
			v31 = false
			if not v17 then
				return
			end
			v39()
		end)
		return
	end
	for k in pairs(t2) do
		v19:RemoveFish(k)
		t2[k] = nil
	end
end
v39 = function() --[[ refreshActiveFish | Line: 1087 | Upvalues: v17 (ref), refreshFish (copy) ]]
	if not v17 then
		return
	end
	local Config = v17:FindFirstChild("Config")
	local v1 = if Config and Config:IsA("Folder") then Config else nil
	if not v1 then
		return
	end
	refreshFish(v1)
end
local function clearShelfAttach(p1) --[[ clearShelfAttach | Line: 1098 ]]
	for i, v in ipairs(p1:GetChildren()) do
		if v:GetAttribute("AquariumShelfItem") then
			v:Destroy()
		end
	end
end
local function ensureShelfModelPrimaryPart(p1) --[[ ensureShelfModelPrimaryPart | Line: 1106 ]]
	if p1.PrimaryPart then
		return
	end
	local Handle = p1:FindFirstChild("Handle")
	if Handle and Handle:IsA("BasePart") then
		p1.PrimaryPart = Handle
		return
	end
	local Main = p1:FindFirstChild("Main")
	if Main and Main:IsA("BasePart") then
		p1.PrimaryPart = Main
	else
		p1.PrimaryPart = p1:FindFirstChildWhichIsA("BasePart", true)
	end
end
local function prepareShelfModel(p1, p2) --[[ prepareShelfModel | Line: 1126 | Upvalues: ensureShelfModelPrimaryPart (copy) ]]
	p1.Name = "AquariumShelfItem"
	p1:SetAttribute("AquariumShelfItem", true)
	ensureShelfModelPrimaryPart(p1)
	for i, v in ipairs(p1:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Anchored = true
			v.CanCollide = false
			v.CanTouch = false
			v.CanQuery = false
		end
	end
	p1:PivotTo(p2.WorldCFrame)
	p1.Parent = p2
end
local function refreshShelves(p1) --[[ refreshShelves | Line: 1144 | Upvalues: clearShelfAttach (copy), v18 (ref), ItemUtility (copy), Renderer (copy), ModelDownloader (copy), Welder (copy), v23 (ref), createPrompt (copy), LocalPlayer (copy), v14 (copy), v32 (ref), notify (copy), t (copy), v33 (ref), v17 (ref) ]]
	local Shelves = p1:FindFirstChild("Shelves")
	if not Shelves then
		return
	end
	local v1 = false
	for i, v in ipairs(Shelves:GetChildren()) do
		local Attach = v.Root.Attach
		local Template = v.Display.SurfaceGui.Template
		local Vector = Template.Vector
		clearShelfAttach(Attach)
		Vector.Image = ""
		Template.Label.Text = ""
		Template.UIStroke.UIGradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
		Template.Shadow.UIGradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
		Template.UIGradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
		Template.Configuration.WeightFrame.Visible = false
		local v2 = v18 and v18.Shelves and v18.Shelves[v.Name]
		if typeof(v2) == "table" and (typeof(v2.Id) == "number" and typeof(v2.ItemType) == "string") then
			local v3 = ItemUtility.GetItemDataFromItemType(v2.ItemType, v2.Id)
			if v3 then
				local v4 = Renderer.getTierData(v3)
				Vector.Image = v3.Data.Icon or ""
				Template.Label.Text = v3.Data.Name or v2.Name or ""
				Template.UIStroke.UIGradient.Color = v4.TierColor
				Template.Shadow.UIGradient.Color = v4.TierColor
				Template.UIGradient.Color = v4.TierColor
				if ModelDownloader:GetModel(v2.ItemType, v2.Name or v2.Id, false) then
					local AquariumShelfItem = Welder.placeModel(v3, {
						backGrip = true,
						addRotation = true,
						applyCharacterEffects = false,
						weight = nil,
						selectedItem = v2,
						parent = Attach,
						attachTo = v.Root
					})
					if AquariumShelfItem then
						AquariumShelfItem.Name = "AquariumShelfItem"
						AquariumShelfItem:SetAttribute("AquariumShelfItem", true)
					end
				else
					v1 = true
				end
			end
		end
		if v23 then
			local v11 = createPrompt(Attach, if v2 then "Replace Pin" else "Pin Item", v.Name)
			if v11 then
				local v12 = v11.Triggered:Connect(function(p1) --[[ Line: 1202 | Upvalues: LocalPlayer (ref), v14 (ref), v (copy), v18 (ref), v32 (ref), notify (ref), t (ref) ]]
					if p1 ~= LocalPlayer then
						return
					end
					local v1 = v14:InvokeServer(v.Name)
					if typeof(v1) == "table" and v1.Success then
						v18 = v1.Data or v18
						v32 = 0
						notify(v1.Message or "Item pinned", true)
						t:Refresh()
					else
						notify(if typeof(v1) == "table" and v1.Message then v1.Message else "Unable to pin item", false)
					end
				end)
				v11.Destroying:Once(function() --[[ Line: 1218 | Upvalues: v12 (copy) ]]
					v12:Disconnect()
				end)
			end
		end
	end
	if not v1 or (not (v32 < 6) or v33) then
		return
	end
	v32 = v32 + 1
	v33 = true
	task.delay(0.5, function() --[[ Line: 1228 | Upvalues: v33 (ref), v17 (ref), t (ref) ]]
		v33 = false
		if not v17 then
			return
		end
		t:Refresh()
	end)
end
local function invokePurchase(p1, p2) --[[ invokePurchase | Line: 1237 | Upvalues: v29 (ref), PromptController (copy), notify (copy), v18 (ref), v30 (ref), t (copy) ]]
	if not v29 then
		v29 = true
		PromptController:FirePrompt(p1, true):andThen(function(p1) --[[ Line: 1243 | Upvalues: p2 (copy), notify (ref), v18 (ref), v30 (ref), t (ref) ]]
			if not p1 then
				return
			end
			local v1 = p2()
			if typeof(v1) ~= "table" then
				notify("Purchase failed", false)
				return
			end
			if not v1.Success then
				notify(v1.Message or "Purchase failed", false)
				return
			end
			v18 = v1.Data or v18
			v30 = 0
			notify(v1.Message or "Purchased", true)
			t:Refresh()
		end):finally(function() --[[ Line: 1262 | Upvalues: v29 (ref) ]]
			v29 = false
		end)
	end
end
local function refreshLeavePrompt(p1) --[[ refreshLeavePrompt | Line: 1267 | Upvalues: createPrompt (copy), LocalPlayer (copy), v15 (copy), GuiControl (copy), clearActiveAquarium (copy), notify (copy) ]]
	local v1 = createPrompt(p1.Leave, "Leave Aquarium", "Aquarium Lobby")
	if not v1 then
		return
	end
	v1.Triggered:Connect(function(p1_2) --[[ Line: 1270 | Upvalues: LocalPlayer (ref), v15 (ref), GuiControl (ref), clearActiveAquarium (ref), notify (ref) ]]
		if p1_2 ~= LocalPlayer then
			return
		end
		local v1 = v15:InvokeServer()
		if typeof(v1) == "table" and v1.Success then
			GuiControl:Close(true)
			clearActiveAquarium()
			return
		end
		notify(if typeof(v1) == "table" and v1.Message then v1.Message else "Unable to leave Aquarium", false)
	end)
end
local function collectZoneDoors(p1) --[[ collectZoneDoors | Line: 1286 ]]
	local t = {}
	for i, v in ipairs(p1:GetChildren()) do
		if v.Name == "Door" then
			table.insert(t, v)
		end
	end
	return t
end
local function updateZoneDoorDisplay(p1, p2, p3) --[[ updateZoneDoorDisplay | Line: 1297 | Upvalues: StringLibrary (copy) ]]
	local Display = p1:FindFirstChild("Display")
	if Display then
		local AreaTitle = Display.SurfaceGui.AreaTitle
		AreaTitle.Label.Text = p2
		AreaTitle.CurrencyPrice.Currency.Text = StringLibrary:AddCommas(p3)
	end
end
local function createDoorPrompt(p1, p2, p3) --[[ createDoorPrompt | Line: 1308 | Upvalues: destroyPromptParentPrompts (copy) ]]
	local v1 = if p1:IsA("Model") then p1.PrimaryPart else p1
	if v1 and v1:IsA("BasePart") then
		destroyPromptParentPrompts(v1)
		local AquariumPrompt = Instance.new("ProximityPrompt")
		AquariumPrompt.Name = "AquariumPrompt"
		AquariumPrompt.ActionText = p2
		AquariumPrompt.ObjectText = p3
		AquariumPrompt.KeyboardKeyCode = Enum.KeyCode.E
		AquariumPrompt.Style = Enum.ProximityPromptStyle.Custom
		AquariumPrompt.HoldDuration = 0.35
		AquariumPrompt.RequiresLineOfSight = false
		AquariumPrompt.MaxActivationDistance = 12
		AquariumPrompt.Parent = v1
		return AquariumPrompt
	else
		return nil
	end
end
local function refreshZones(p1) --[[ refreshZones | Line: 1330 | Upvalues: AquariumConfig (copy), v18 (ref), collectZoneDoors (copy), v23 (ref), StringLibrary (copy), createDoorPrompt (copy), LocalPlayer (copy), invokePurchase (copy), v10 (copy) ]]
	local Zones = p1:FindFirstChild("Zones")
	if not Zones then
		return
	end
	for k, v in pairs(AquariumConfig.Zones) do
		local v1 = Zones:FindFirstChild(k)
		local v2 = v18 and v18.UnlockedZones
		local v3 = if v2 then if v2[k] == true then true else false else v2
		if v1 then
			local v4 = collectZoneDoors(v1)
			if #v4 ~= 0 then
				if v3 then
					for i, v5 in ipairs(v4) do
						v5:Destroy()
					end
					continue
				end
				if v23 then
					for i, v5 in ipairs(v4) do
						local UnlockCost = v.UnlockCost
						local Display = v5:FindFirstChild("Display")
						if Display then
							local AreaTitle = Display.SurfaceGui.AreaTitle
							AreaTitle.Label.Text = k
							AreaTitle.CurrencyPrice.Currency.Text = StringLibrary:AddCommas(UnlockCost)
						end
						local v52 = createDoorPrompt(v5, ("Unlock %*"):format(k), (("%* Coins"):format(v.UnlockCost)))
						if v52 then
							v52.Triggered:Connect(function(p1) --[[ Line: 1358 | Upvalues: LocalPlayer (ref), invokePurchase (ref), v (copy), k (copy), v10 (ref) ]]
								if p1 ~= LocalPlayer then
									return
								end
								invokePurchase(("Spend %* Coins to unlock %*?"):format(v.UnlockCost, k), function() --[[ Line: 1360 | Upvalues: v10 (ref), k (ref) ]]
									return v10:InvokeServer(k)
								end)
							end)
						end
					end
					continue
				end
				for i, v5 in ipairs(v4) do
					local UnlockCost = v.UnlockCost
					local Display = v5:FindFirstChild("Display")
					if Display then
						local AreaTitle = Display.SurfaceGui.AreaTitle
						AreaTitle.Label.Text = k
						AreaTitle.CurrencyPrice.Currency.Text = StringLibrary:AddCommas(UnlockCost)
					end
				end
			end
		end
	end
end
local function refreshTanks(p1) --[[ refreshTanks | Line: 1375 | Upvalues: AquariumConfig (copy), v18 (ref), v23 (ref), createPrompt (copy), LocalPlayer (copy), GuiControl (copy), v25 (ref), v26 (ref), v38 (ref), PlayerGui (copy), invokePurchase (copy), v11 (copy) ]]
	local Tanks = p1:FindFirstChild("Tanks")
	if not Tanks then
		return
	end
	for k, v in pairs(AquariumConfig.Tanks) do
		local v1, v2
		local v3 = Tanks:FindFirstChild(k)
		local v4 = v18 and v18.Tanks and v18.Tanks[k]
		local v5 = AquariumConfig.TankRequiredZonesUnlocked(v, v18)
		local v6 = v4 and v4.Unlocked == true
		if v3 then
			local Podium = v3:FindFirstChild("Podium")
			if Podium then
				if v6 then
					local v7 = Podium.Podium:FindFirstChild("Podium Lock")
					if v7 then
						v7:Destroy()
					end
				end
				if v23 and v5 then
					v1 = if v6 then "Add Fish" else ("Unlock %*"):format(k)
					v2 = if v6 then k else ("%* Coins"):format(v.UnlockCost)
					local v10 = createPrompt(Podium, v1, v2)
					if v10 then
						v10.Triggered:Connect(function(p1) --[[ Line: 1413 | Upvalues: LocalPlayer (ref), v6 (copy), k (copy), GuiControl (ref), v25 (ref), v26 (ref), v18 (ref), AquariumConfig (ref), v38 (ref), PlayerGui (ref), invokePurchase (ref), v (copy), v11 (ref) ]]
							if p1 ~= LocalPlayer then
								return
							end
							if not v6 then
								invokePurchase(("Spend %* Coins to unlock %*?"):format(v.UnlockCost, k), function() --[[ Line: 1421 | Upvalues: v11 (ref), k (ref) ]]
									return v11:InvokeServer(k)
								end)
								return
							end
							local v1 = k
							GuiControl:Open("TankManagement", true, v1)
							v25 = v1
							local v2 = if v18 and (v18.Tanks and v1) then v18.Tanks[v1] else nil
							local v3 = v1 and AquariumConfig.Tanks[v1]
							local v4
							if v2 and v3 then
								for i = 1, v3.Capacity do
									if v2.Fish[i] == nil then
										v4 = i
										v26 = i
										v38(PlayerGui:WaitForChild("TankManagement"), true)
										return
									end
								end
							end
							v4 = 1
							v26 = v4
							v38(PlayerGui:WaitForChild("TankManagement"), true)
						end)
					end
				end
			end
		end
	end
end
function t.Refresh(p1) --[[ Refresh | Line: 1429 | Upvalues: v17 (ref), refreshZones (copy), refreshTanks (copy), createPrompt (copy), LocalPlayer (copy), v15 (copy), GuiControl (copy), clearActiveAquarium (copy), notify (copy), refreshFish (copy), refreshShelves (copy) ]]
	if not v17 then
		return
	end
	local Config = v17:FindFirstChild("Config")
	local v1 = if Config and Config:IsA("Folder") then Config else nil
	if not v1 then
		return
	end
	refreshZones(v1)
	refreshTanks(v1)
	local v2 = createPrompt(v1.Leave, "Leave Aquarium", "Aquarium Lobby")
	if v2 then
		v2.Triggered:Connect(function(p1_2) --[[ Line: 1270 | Upvalues: LocalPlayer (ref), v15 (ref), GuiControl (ref), clearActiveAquarium (ref), notify (ref) ]]
			if p1_2 ~= LocalPlayer then
				return
			end
			local v1 = v15:InvokeServer()
			if typeof(v1) == "table" and v1.Success then
				GuiControl:Close(true)
				clearActiveAquarium()
				return
			end
			notify(if typeof(v1) == "table" and v1.Message then v1.Message else "Unable to leave Aquarium", false)
		end)
	end
	refreshFish(v1)
	refreshShelves(v1)
end
local function loadAquarium(p1) --[[ loadAquarium | Line: 1446 | Upvalues: clearActiveAquarium (copy), ReplicatedStorage (copy), AquariumConfig (copy), v17 (ref), v18 (ref), v23 (ref), v24 (ref), v30 (ref), v32 (ref), t (copy) ]]
	clearActiveAquarium()
	local ClientAquarium = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Aquariums"):WaitForChild(AquariumConfig.AssetName):Clone()
	ClientAquarium.Name = "ClientAquarium"
	if typeof(p1.VisitOffset) == "Vector3" then
		ClientAquarium:PivotTo(ClientAquarium:GetPivot() + p1.VisitOffset)
	end
	ClientAquarium.Parent = workspace
	v17 = ClientAquarium
	v18 = p1.State
	v23 = p1.IsOwner == true
	v24 = p1.OwnerUserId
	v30 = 0
	v32 = 0
	t:Refresh()
end
local function syncAquariumState(p1) --[[ syncAquariumState | Line: 1467 | Upvalues: v17 (ref), v24 (ref), v18 (ref), v30 (ref), v32 (ref), t (copy), v25 (ref), GuiControl (copy), v38 (ref), PlayerGui (copy) ]]
	if not v17 or (typeof(p1) ~= "table" or p1.OwnerUserId ~= v24) then
		return
	end
	v18 = p1.State
	v30 = 0
	v32 = 0
	t:Refresh()
	if not (v25 and GuiControl:IsOpen("TankManagement")) then
		return
	end
	v38((PlayerGui:WaitForChild("TankManagement")))
end
local function endAquariumVisit(p1) --[[ endAquariumVisit | Line: 1481 | Upvalues: clearActiveAquarium (copy), notify (copy) ]]
	clearActiveAquarium()
	if p1 == "OwnerLeft" then
		notify("Aquarium owner left", false)
		return
	end
	if p1 ~= "OwnerLocked" then
		return
	end
	notify("Aquarium closed", false)
end
function t.Start(p1) --[[ Start | Line: 1490 | Upvalues: v16 (ref), Replion (copy), v1 (copy), loadAquarium (copy), v9 (copy), v2 (copy), syncAquariumState (copy), v3 (copy), endAquariumVisit (copy), bindAquariumGui (copy), GuiControl (copy), refreshGuiState (copy), v28 (ref), v38 (ref), PlayerGui (copy), bindTankManagementGui (copy), v27 (ref), clearGeneratedTiles (copy), v21 (ref), v20 (ref), v22 (ref), v25 (ref), v26 (ref), v18 (ref), AquariumConfig (copy), Players (copy), v37 (ref) ]]
	v16 = Replion.Client:WaitReplion("Data")
	v1.OnClientEvent:Connect(function(p1) --[[ Line: 1492 | Upvalues: loadAquarium (ref), v9 (ref) ]]
		if typeof(p1) == "table" then
			loadAquarium(p1)
			v9:InvokeServer(p1.VisitId)
		end
	end)
	v2.OnClientEvent:Connect(syncAquariumState)
	v3.OnClientEvent:Connect(endAquariumVisit)
	bindAquariumGui()
	GuiControl:BeforeHook("Aquarium", function() --[[ Line: 1505 | Upvalues: refreshGuiState (ref), bindAquariumGui (ref) ]]
		refreshGuiState()
		bindAquariumGui()
	end)
	v16:OnChange({ "Inventory", "Items" }, function() --[[ Line: 1510 | Upvalues: v28 (ref), GuiControl (ref), v38 (ref), PlayerGui (ref) ]]
		if not v28 then
			v28 = true
			task.defer(function() --[[ Line: 873 | Upvalues: v28 (ref), GuiControl (ref), v38 (ref), PlayerGui (ref) ]]
				v28 = false
				if not GuiControl:IsOpen("TankManagement") then
					return
				end
				v38((PlayerGui:WaitForChild("TankManagement")))
			end)
		end
	end)
	GuiControl:BeforeHook("TankManagement", function() --[[ Line: 1514 | Upvalues: bindTankManagementGui (ref) ]]
		bindTankManagementGui()
	end)
	GuiControl.GuiFocusedSignal:Connect(function(p1) --[[ Line: 1518 | Upvalues: bindTankManagementGui (ref), v38 (ref) ]]
		if p1.Name ~= "TankManagement" then
			return
		end
		bindTankManagementGui()
		v38(p1, true)
	end)
	GuiControl.GuiUnfocusedSignal:Connect(function(p1) --[[ Line: 1525 | Upvalues: v27 (ref), clearGeneratedTiles (ref), v21 (ref), v20 (ref), v22 (ref), v25 (ref), v26 (ref), v18 (ref), AquariumConfig (ref) ]]
		if p1.Name ~= "TankManagement" then
			return
		end
		v27 = v27 + 1
		clearGeneratedTiles(p1.Main.Aquarium.FishCase.Index, "AquariumGenerated")
		if v21 then
			v21:Destroy()
			v21 = nil
		end
		if v20 then
			v20:Destroy()
			v20 = nil
		end
		v22 = nil
		v25 = nil
		local v1 = if v18 and (v18.Tanks and v25) then v18.Tanks[v25] else nil
		local v2 = v25 and AquariumConfig.Tanks[v25]
		local v3
		if v1 and v2 then
			for i = 1, v2.Capacity do
				if v1.Fish[i] == nil then
					v3 = i
					v26 = i
					return
				end
			end
		end
		v3 = 1
		v26 = v3
	end)
	Players.PlayerAdded:Connect(function() --[[ Line: 1531 | Upvalues: refreshGuiState (ref), v37 (ref), PlayerGui (ref) ]]
		refreshGuiState()
		v37((PlayerGui:WaitForChild("Aquarium")))
	end)
	Players.PlayerRemoving:Connect(function() --[[ Line: 1536 | Upvalues: refreshGuiState (ref), v37 (ref), PlayerGui (ref) ]]
		task.defer(function() --[[ Line: 1537 | Upvalues: refreshGuiState (ref), v37 (ref), PlayerGui (ref) ]]
			refreshGuiState()
			v37((PlayerGui:WaitForChild("Aquarium")))
		end)
	end)
end
return t