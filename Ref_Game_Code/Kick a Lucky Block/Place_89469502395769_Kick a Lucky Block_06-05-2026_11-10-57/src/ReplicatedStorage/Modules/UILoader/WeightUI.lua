-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local WeightServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.WeightServiceClient)
local ClientBalanceService = require(ReplicatedStorage.Modules.ServicesLoader.ClientBalanceService)
local MessagesService = require(ReplicatedStorage.Modules.ServicesLoader.MessagesService)
local ShopController = require(ReplicatedStorage.Modules.ControllerLoader.ShopController)
local RarityData = require(ReplicatedStorage.Shared.Data.RarityData)
local WeightsData = require(ReplicatedStorage.Shared.Data.WeightsData)
local WeightController = require(ReplicatedStorage.Modules.ControllerLoader.WeightController)
require(ReplicatedStorage.Functional.FormatValue)
local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local WeightUI = (PlayerGui:FindFirstChild("Frames") or PlayerGui:WaitForChild("Frames")).WeightUI
local ScrollingFrame = WeightUI.ScrollingFrame
local Template = ScrollingFrame.Template
local t = {}
function LoadWeight(p1) --[[ LoadWeight | Line: 33 | Upvalues: WeightsData (copy), Template (copy), RarityData (copy), WeightServiceClient (copy), MarketplaceService (copy), WeightController (copy), ClientBalanceService (copy), MessagesService (copy), ShopController (copy), LocalPlayer (copy), ScrollingFrame (copy) ]]
	local v1 = WeightsData.Weights[p1]
	if v1 then
		local v2 = Template:Clone()
		v2.Name = p1
		v2.LayoutOrder = v1.PPS
		local v3 = RarityData.Index[v1.Rarity] and RarityData.Index[v1.Rarity].transform_func
		if v3 then
			v3(v2:WaitForChild("RarityLabel"))
		end
		v2.TitleDown.Text = p1
		v2.TitleUp.Text = p1
		v2.RarityLabel.Text = v1.Rarity
		v2.WeightLabel.Text = v1.Weight .. " lbs"
		v2.ImageLabel.Image = v1.Image
		v2:WaitForChild("PowerLabel").Text = ("Power: %*"):format(v1.PPS)
		local InteractButton = v2.Buttons.InteractButton
		local RobuxButton = v2.Buttons.RobuxButton
		local Equipped = v2.Buttons.Equipped
		local isNotProduct = v1.Product ~= nil
		local v4 = nil
		local function UpdateState() --[[ UpdateState | Line: 61 | Upvalues: WeightServiceClient (ref), p1 (copy), RobuxButton (copy), InteractButton (copy), Equipped (copy), v1 (copy), isNotProduct (copy), v4 (ref) ]]
			local v12 = table.find(WeightServiceClient.Owned, p1)
			local isEquipped = WeightServiceClient.Equipped == p1
			if v12 then
				RobuxButton.Visible = false
				if isEquipped then
					InteractButton.Visible = false
					Equipped.Visible = true
				else
					InteractButton.Visible = true
					Equipped.Visible = false
					InteractButton:WaitForChild("Label").Text = "Equip"
					InteractButton.Interactable = true
				end
			else
				InteractButton.Visible = true
				Equipped.Visible = false
				InteractButton:WaitForChild("Label").Text = ("$%*"):format(v1.Cost)
				InteractButton.Interactable = true
				if isNotProduct then
					RobuxButton.Visible = true
					if v4 then
						RobuxButton:WaitForChild("Label").Text = ("\238\128\130%*"):format(v4)
					else
						RobuxButton:WaitForChild("Label").Text = "R$ ..."
					end
				else
					RobuxButton.Visible = false
				end
			end
		end
		if isNotProduct then
			task.spawn(function() --[[ Line: 97 | Upvalues: MarketplaceService (ref), v1 (copy), v4 (ref), UpdateState (copy) ]]
				local v12, v2 = pcall(function() --[[ Line: 98 | Upvalues: MarketplaceService (ref), v1 (ref) ]]
					return MarketplaceService:GetProductInfoAsync(v1.Product, Enum.InfoType.Product)
				end)
				if v12 then
					v4 = v2.PriceInRobux
					UpdateState()
				end
			end)
		end
		UpdateState()
		WeightServiceClient.Changed:Connect(UpdateState)
		InteractButton.Activated:Connect(function() --[[ Line: 111 | Upvalues: WeightServiceClient (ref), p1 (copy), WeightController (ref), v1 (copy), ClientBalanceService (ref), MessagesService (ref), ShopController (ref) ]]
			local isEquipped = WeightServiceClient.Equipped == p1
			if not isEquipped and table.find(WeightServiceClient.Owned, p1) then
				WeightController:RequestEquip(p1)
			elseif not isEquipped and v1.Cost > ClientBalanceService.Balance then
				MessagesService:PlayMessage("Missing Cash", "Error")
			elseif not isEquipped then
				ShopController:BuyItem("WeightShop", p1)
			end
		end)
		if isNotProduct then
			RobuxButton.Activated:Connect(function() --[[ Line: 130 | Upvalues: MarketplaceService (ref), LocalPlayer (ref), v1 (copy) ]]
				MarketplaceService:PromptProductPurchase(LocalPlayer, v1.Product)
			end)
		end
		v2.Parent = ScrollingFrame
		v2.Visible = true
	end
end
function Initialize() --[[ Initialize | Line: 139 | Upvalues: WeightsData (copy), Template (copy) ]]
	for k in pairs(WeightsData.Weights) do
		LoadWeight(k)
		task.wait()
	end
	Template.Visible = false
end
function InitializeClose() --[[ InitializeClose | Line: 147 | Upvalues: WeightUI (copy) ]]
	WeightUI.Top.Main.Close.Activated:Connect(function() --[[ Line: 148 | Upvalues: WeightUI (ref) ]]
		WeightUI.Visible = false
	end)
end
function t.OpenUI(p1) --[[ OpenUI | Line: 154 | Upvalues: WeightUI (copy) ]]
	if not WeightUI.Visible then
		WeightUI.Visible = true
	end
end
function t._init(p1) --[[ _init | Line: 161 ]]
	Initialize()
	InitializeClose()
end
return t