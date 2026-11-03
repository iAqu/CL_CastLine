-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
require(ReplicatedStorage.Packages.Net)
require(ReplicatedStorage.Packages.Signal)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local v1 = require("@game/ReplicatedStorage/Packages/Trove")
local v2 = require("@game/ReplicatedStorage/Packages/Replion")
require("@game/ReplicatedStorage/Packages/Promise")
local v3 = require("../TextNotificationController")
local v4 = require("../PromptController")
local v5 = require("@game/ReplicatedStorage/Shared/Trading/TradeData")
local v6 = LocalPlayer.PlayerGui:WaitForChild("! Trade Menu")
local SendTradeOffer = v5.Remotes.SendTradeOffer
local AcceptTradeOffer = v5.Remotes.AcceptTradeOffer
local TradeOfferReceived = v5.Remotes.TradeOfferReceived
local DeclineTradeOffer = v5.Remotes.DeclineTradeOffer
local Scrolling = v6.Frame.Scrolling
local v7 = LocalPlayer:GetAttribute("IsTrading") or false
local v8 = nil
local v9 = nil
local v10 = nil
local t = {}
local t2 = {}
local t3 = {
	_createPlayerFrame = function(p1, p2) --[[ _createPlayerFrame | Line: 44 | Upvalues: LocalPlayer (copy), t (copy), v1 (copy), GuiControl (copy), SendTradeOffer (copy), Scrolling (copy) ]]
		if p2 ~= LocalPlayer and not t[p2] then
			local v12 = v1.new()
			t[p2] = v12
			local v2 = script.Template:Clone()
			v2.Name = p2.UserId
			v12:Add(function() --[[ Line: 55 | Upvalues: v2 (copy) ]]
				v2:Destroy()
			end)
			v2.Nickname.Text = p2.DisplayName
			v2.Username.Text = ("@%*"):format(p2.Name)
			v2.PFP.PFP.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=150&h=150"):format(p2.UserId)
			local v3 = true
			local function updateTradeStatus() --[[ updateTradeStatus | Line: 65 | Upvalues: p2 (copy), v3 (ref), v2 (copy) ]]
				v3 = not p2:GetAttribute("IsTrading") and true
				v2.Trade.Active = v3
				v2.Trade.UIGradient.Color = if v3 then ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(67, 226, 102)), ColorSequenceKeypoint.new(0.379, Color3.fromRGB(49, 255, 83)), ColorSequenceKeypoint.new(1, Color3.fromRGB(67, 226, 102)) }) else ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 76, 76)), ColorSequenceKeypoint.new(0.379, Color3.fromRGB(255, 107, 107)), ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 75, 75)) })
			end
			v12:Connect(p2:GetAttributeChangedSignal("IsTrading"), updateTradeStatus)
			v12:Connect(p2:GetAttributeChangedSignal("ReceiveTrades"), updateTradeStatus)
			updateTradeStatus()
			local v4 = false
			GuiControl:Hook("Hold Button", v2.Trade).Clicked:Connect(function() --[[ Line: 91 | Upvalues: v4 (ref), v3 (ref), p2 (copy), v2 (copy), SendTradeOffer (ref) ]]
				if v4 then
					messageError("Please wait for sending a new request!")
					return
				end
				if not v3 then
					messageError((("@%* can\'t receive trade requests!"):format(p2.Name)))
					return
				end
				v4 = true
				task.delay(5, function() --[[ Line: 105 | Upvalues: v2 (ref), v4 (ref) ]]
					if not v2.Parent then
						return
					end
					v2.Trade.Label.Text = "Trade"
					v4 = false
				end)
				local v1, v22 = SendTradeOffer:InvokeServer(p2)
				if v1 then
					v2.Trade.Label.Text = "Sent!"
					messageSuccess("Trade sent!")
				else
					messageError(v22)
				end
			end)
			v2.Parent = Scrolling.ScrollingFrame
		end
	end
}
function t3.PopUp(p1, p2) --[[ PopUp | Line: 124 | Upvalues: v10 (ref), v4 (copy), t3 (copy) ]]
	if not v10 then
		v10 = v4:FirePrompt(("Trade request from %* do you want to accept?"):format(p2.DisplayName), true)
		v10:andThen(function(p1) --[[ Line: 131 | Upvalues: v10 (ref), t3 (ref) ]]
			v10 = nil
			if p1 then
				t3:AcceptTrade()
			else
				t3:DeclineTrade()
			end
		end):catch(warn)
	end
end
function t3.AcceptTrade(p1) --[[ AcceptTrade | Line: 143 | Upvalues: t2 (copy), v9 (ref), AcceptTradeOffer (copy) ]]
	table.clear(t2)
	if not v9 then
		return
	end
	local v1, v2 = AcceptTradeOffer:InvokeServer(v9)
	if not v1 then
		messageError(v2)
	end
	v9 = nil
end
function t3.DeclineTrade(p1) --[[ DeclineTrade | Line: 158 | Upvalues: v9 (ref), DeclineTradeOffer (copy), t2 (copy), t3 (copy) ]]
	if not v9 then
		return
	end
	local v1 = DeclineTradeOffer:InvokeServer(v9)
	if v1 then
		warn((("Trade Decline: %*"):format(v1)))
	end
	v9 = table.remove(t2, 1)
	if v9 then
		t3:PopUp(v9)
	end
end
function t3.Start(p1) --[[ Start | Line: 177 | Upvalues: v8 (ref), v2 (copy), TradeOfferReceived (copy), v7 (copy), v9 (ref), t2 (copy), t3 (copy), Players (copy), t (copy) ]]
	v8 = v2.Client:WaitReplion("Data")
	TradeOfferReceived.OnClientEvent:Connect(function(p1) --[[ Line: 180 | Upvalues: v7 (ref), v8 (ref), v9 (ref), t2 (ref), t3 (ref) ]]
		if v7 or not v8:Get({ "Settings", "Receive Trades" }) then
			return
		end
		if v9 then
			table.insert(t2, p1)
		else
			v9 = p1
			t3:PopUp(p1)
		end
	end)
	Players.PlayerRemoving:Connect(function(p1) --[[ Line: 195 | Upvalues: t (ref) ]]
		local v1 = t[p1]
		if not v1 then
			return
		end
		v1:Destroy()
		t[p1] = nil
	end)
	Players.PlayerAdded:Connect(function(p1) --[[ Line: 203 | Upvalues: t3 (ref) ]]
		t3:_createPlayerFrame(p1)
	end)
	for v1, v22 in Players:GetPlayers() do
		t3:_createPlayerFrame(v22)
	end
end
function messageSuccess(p1) --[[ messageSuccess | Line: 212 | Upvalues: v3 (copy) ]]
	v3:DeliverNotification({
		Type = "Text",
		Text = p1,
		TextColor = {
			R = 0,
			G = 255,
			B = 0
		}
	})
end
function messageError(p1) --[[ messageError | Line: 220 | Upvalues: v3 (copy) ]]
	v3:DeliverNotification({
		Type = "Text",
		Text = p1,
		TextColor = {
			R = 255,
			G = 0,
			B = 0
		}
	})
end
return t3