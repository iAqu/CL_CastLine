-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local Tags = require(ReplicatedStorage.Shared.Data.Tags)
local Products = require(ReplicatedStorage.Shared.Data.Products)
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local LocalPlayer = Players.LocalPlayer
local t = {
	Tag = ({
		Tag = Tags.ProductButton
	}).Tag
}
t.__index = t
local t2 = {}
function t.new(p1) --[[ new | Line: 28 | Upvalues: t (copy) ]]
	if p1:IsA("GuiButton") then
		local v2 = setmetatable({
			PriceInRobux = nil,
			ActivatedCon = nil,
			Button = p1
		}, t)
		v2:_init()
		return v2
	end
end
function t.UpdateLabels(p1) --[[ UpdateLabels | Line: 43 ]]
	local v1 = p1.Button:FindFirstChild("Label") or p1.Button:WaitForChild("Label", 1)
	if v1 then
		v1.Text = ("%*%*"):format(utf8.char(57346), p1.PriceInRobux)
	end
end
function t.GetPrice(p1, p2) --[[ GetPrice | Line: 50 | Upvalues: t2 (copy), MarketplaceService (copy) ]]
	if t2[p2] then
		return t2[p2]
	else
		task.spawn(function() --[[ Line: 55 | Upvalues: MarketplaceService (ref), p2 (copy), t2 (ref), p1 (copy) ]]
			local v1, v2 = pcall(function() --[[ Line: 56 | Upvalues: MarketplaceService (ref), p2 (ref) ]]
				return MarketplaceService:GetProductInfoAsync(p2, Enum.InfoType.Product)
			end)
			if v1 then
				t2[p2] = v2.PriceInRobux
				p1.PriceInRobux = v2.PriceInRobux
				p1:UpdateLabels()
			end
		end)
	end
end
function t.PromptOnActivated(p1, p2) --[[ PromptOnActivated | Line: 68 | Upvalues: LocalPlayer (copy), Players (copy), Network (copy), MarketplaceService (copy) ]]
	if p1.ActivatedCon then
		p1.ActivatedCon:Disconnect()
	end
	p1.ActivatedCon = p1.Button.Activated:Connect(function() --[[ Line: 72 | Upvalues: LocalPlayer (ref), Players (ref), Network (ref), p2 (copy), MarketplaceService (ref) ]]
		local v1 = LocalPlayer:GetAttribute("GiftTargetId")
		if v1 then
			local v2 = Players:GetPlayerByUserId(v1)
			if v2 then
				Network.FireServer("myMarket_gift", p2, v2)
				print("fired")
				return
			end
		end
		MarketplaceService:PromptProductPurchase(LocalPlayer, p2)
	end)
end
function t.InitializeButton(p1) --[[ InitializeButton | Line: 86 | Upvalues: Products (copy) ]]
	local v1 = p1.Button:GetAttribute("Key")
	if v1 then
		local v2 = Products.Products[v1]
		if v2 then
			p1:PromptOnActivated(v2)
			p1:GetPrice(v2)
		end
	end
end
function t._init(p1) --[[ _init | Line: 101 ]]
	p1:InitializeButton()
	p1.Button:GetAttributeChangedSignal("Key"):Connect(function() --[[ Line: 103 | Upvalues: p1 (copy) ]]
		p1:InitializeButton()
	end)
end
function t.Destroy(p1) --[[ Destroy | Line: 108 ]] end
return t