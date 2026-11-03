-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local Tags = require(ReplicatedStorage.Shared.Data.Tags)
local Gamepasses = require(ReplicatedStorage.Shared.Data.Gamepasses)
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local LocalPlayer = Players.LocalPlayer
local t = {
	Tag = ({
		Tag = Tags.GamepassButton
	}).Tag
}
t.__index = t
function t.new(p1) --[[ new | Line: 24 | Upvalues: t (copy) ]]
	if p1:IsA("GuiButton") then
		local v2 = setmetatable({
			Owned = nil,
			PriceInRobux = nil,
			ActivatedCon = nil,
			Key = nil,
			Button = p1
		}, t)
		v2:_init()
		return v2
	end
end
function t.UpdateLabels(p1) --[[ UpdateLabels | Line: 41 ]]
	local v1 = p1.Button:FindFirstChild("Label") or p1.Button:WaitForChild("Label", 1)
	if v1 then
		v1.Text = if p1.Owned then "Owned" else ("%*%*"):format(utf8.char(57346), p1.PriceInRobux)
	end
end
function t.GetPrice(p1, p2) --[[ GetPrice | Line: 48 | Upvalues: MarketplaceService (copy) ]]
	task.spawn(function() --[[ Line: 49 | Upvalues: MarketplaceService (ref), p2 (copy), p1 (copy) ]]
		local v1, v2 = pcall(function() --[[ Line: 50 | Upvalues: MarketplaceService (ref), p2 (ref) ]]
			return MarketplaceService:GetProductInfoAsync(p2, Enum.InfoType.GamePass)
		end)
		if v1 then
			p1.PriceInRobux = v2.PriceInRobux
			p1:UpdateLabels()
		end
		p1:CheckUserOwns()
	end)
end
function t.GetCheckPlayer(p1) --[[ GetCheckPlayer | Line: 63 | Upvalues: LocalPlayer (copy), Players (copy) ]]
	local v1 = LocalPlayer:GetAttribute("GiftTargetId")
	if v1 then
		local v2 = Players:GetPlayerByUserId(v1)
		if v2 then
			return v2
		end
	end
	return LocalPlayer
end
function t.CheckUserOwns(p1) --[[ CheckUserOwns | Line: 74 ]]
	p1.Owned = p1:GetCheckPlayer():GetAttribute(p1.Key)
	p1:UpdateLabels()
end
function t.PromptOnActivated(p1, p2) --[[ PromptOnActivated | Line: 81 | Upvalues: LocalPlayer (copy), Players (copy), Network (copy), MarketplaceService (copy) ]]
	if p1.ActivatedCon then
		p1.ActivatedCon:Disconnect()
	end
	p1.ActivatedCon = p1.Button.Activated:Connect(function() --[[ Line: 86 | Upvalues: p1 (copy), LocalPlayer (ref), Players (ref), Network (ref), p2 (copy), MarketplaceService (ref) ]]
		if not p1.Owned then
			local v1 = LocalPlayer:GetAttribute("GiftTargetId")
			if v1 then
				local v2 = Players:GetPlayerByUserId(v1)
				if v2 then
					Network.FireServer("myMarket_gift", p2, v2)
					print("fired")
					return
				end
			end
			MarketplaceService:PromptGamePassPurchase(LocalPlayer, p2)
		end
	end)
end
function t.InitializeButton(p1) --[[ InitializeButton | Line: 105 | Upvalues: Gamepasses (copy), LocalPlayer (copy), Players (copy) ]]
	local v1 = p1.Button:GetAttribute("Key")
	if v1 then
		p1.Key = v1
		local v2 = Gamepasses.Gamepasses[v1]
		if v2 then
			p1:PromptOnActivated(v2)
			p1:GetPrice(v2)
			LocalPlayer:GetAttributeChangedSignal(v1):Connect(function() --[[ Line: 117 | Upvalues: p1 (copy) ]]
				p1:CheckUserOwns()
			end)
			LocalPlayer:GetAttributeChangedSignal("GiftTargetId"):Connect(function() --[[ Line: 120 | Upvalues: p1 (copy), LocalPlayer (ref), Players (ref), v1 (copy) ]]
				if p1.TargetCon then
					p1.TargetCon:Disconnect()
					p1.TargetCon = nil
				end
				local v12 = LocalPlayer:GetAttribute("GiftTargetId")
				if v12 then
					local v2 = Players:GetPlayerByUserId(v12)
					if not v2 then
						p1:CheckUserOwns()
						return
					end
					p1.TargetCon = v2:GetAttributeChangedSignal(v1):Connect(function() --[[ Line: 130 | Upvalues: p1 (ref) ]]
						p1:CheckUserOwns()
					end)
				end
				p1:CheckUserOwns()
			end)
		end
	end
end
function t._init(p1) --[[ _init | Line: 139 ]]
	p1:InitializeButton()
end
function t.Destroy(p1) --[[ Destroy | Line: 143 ]]
	if p1.ActivatedCon then
		p1.ActivatedCon:Disconnect()
	end
end
return t