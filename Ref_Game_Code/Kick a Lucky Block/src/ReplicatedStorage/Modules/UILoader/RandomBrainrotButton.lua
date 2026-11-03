-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MyMarketplaceServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.MyMarketplaceServiceClient)
local PolicyInfoService = require(ReplicatedStorage.Modules.ServicesLoader.PolicyInfoService)
local HUD = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("HUD")
local t = {}
local v1 = nil
local t2 = {
	Discounted = {
		ID = 3571979621,
		Key = "randomBrainrot"
	},
	Default = {
		ID = 3571978707,
		Key = "randomBrainrotReal"
	}
}
function CountChanged() --[[ CountChanged | Line: 35 | Upvalues: MyMarketplaceServiceClient (copy), t2 (copy), v1 (ref), HUD (copy) ]]
	local v12 = MyMarketplaceServiceClient.CountBought[t2.Discounted.ID] or 0
	if v12 >= 3 and v1 ~= t2.Default.ID then
		v1 = t2.Default.ID
		HUD.LeftPanel.RandomBrainrot.RandomButton:SetAttribute("Key", t2.Default.Key)
		HUD.LeftPanel.RandomBrainrot.RandomButton.DiscountLabel.Visible = false
	elseif v12 < 3 and v1 ~= t2.Discounted.ID then
		v1 = t2.Discounted.ID
		HUD.LeftPanel.RandomBrainrot.RandomButton:SetAttribute("Key", t2.Discounted.Key)
		HUD.LeftPanel.RandomBrainrot.RandomButton.DiscountLabel.Visible = true
	end
end
function t._init() --[[ _init | Line: 51 | Upvalues: PolicyInfoService (copy), MyMarketplaceServiceClient (copy) ]]
	if not PolicyInfoService.PolicyInfo.ArePaidRandomItemsRestricted then
		CountChanged()
		MyMarketplaceServiceClient.CountBoughtChanged:Connect(CountChanged)
	end
end
return t