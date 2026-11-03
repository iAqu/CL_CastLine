-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local ConfirmationUI = require(ReplicatedStorage.Modules.UILoader.ConfirmationUI)
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local Tags = require(ReplicatedStorage.Shared.Data.Tags)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local EntitiesData = require(ReplicatedStorage.Shared.Data.EntitiesData)
local t = {}
local v1 = Trove.new()
local v2 = Trove.new()
local GiftPrompt = script:WaitForChild("GiftPrompt")
local v3 = nil
function IsGiftable(p1) --[[ IsGiftable | Line: 29 | Upvalues: Tags (copy), EntitiesData (copy) ]]
	return p1:HasTag(Tags.EntityTool) and not table.find(EntitiesData.TradeLocked, p1.Name)
end
function OnChildAdded(p1) --[[ OnChildAdded | Line: 33 | Upvalues: v3 (ref) ]]
	if not v3 and (p1:IsA("Tool") and IsGiftable(p1)) then
		v3 = true
		StartGifting()
	end
end
function OnChildRemoved() --[[ OnChildRemoved | Line: 44 | Upvalues: v3 (ref), LocalPlayer (copy), v2 (copy) ]]
	if v3 then
		local v1 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
		if not (v1 and IsGiftable(v1)) then
			v3 = false
			v2:Clean()
		end
	end
end
function HandlePrompt(p1, p2) --[[ HandlePrompt | Line: 56 | Upvalues: v3 (ref), LocalPlayer (copy), ConfirmationUI (copy), Network (copy) ]]
	local v1 = nil
	v1 = p1.Triggered:Connect(function() --[[ Line: 59 | Upvalues: v3 (ref), v1 (ref), LocalPlayer (ref), ConfirmationUI (ref), Network (ref), p2 (copy) ]]
		if v3 then
			local v12 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
			if v12 and IsGiftable(v12) and ConfirmationUI:GetResult(nil, (("Gift %*?"):format(v12.Name))) == "Yes" then
				Network.FireServer("GiftRequest", p2.UserId)
			end
		else
			v1:Disconnect()
		end
	end)
	return v1
end
function StartGifting() --[[ StartGifting | Line: 79 | Upvalues: Players (copy), LocalPlayer (copy), v2 (copy), GiftPrompt (copy) ]]
	for v1, v22 in Players:GetPlayers() do
		if v22 ~= LocalPlayer then
			if v22.Character then
				local v3 = v22.Character:FindFirstChild("HumanoidRootPart") or v22.Character:WaitForChild("HumanoidRootPart", 3)
				if not v3 then
					return
				end
				local v4 = v2:Clone(GiftPrompt)
				v4.Parent = v3
				v2:Add(HandlePrompt(v4, v22))
			end
			v2:Add(v22.CharacterAdded:Connect(function(p1) --[[ Line: 97 | Upvalues: v2 (ref), GiftPrompt (ref), v22 (copy) ]]
				local v1 = v2:Clone(GiftPrompt)
				v1.Parent = p1:WaitForChild("HumanoidRootPart")
				v2:Add(HandlePrompt(v1, v22))
			end))
		end
	end
	v2:Add(Players.PlayerAdded:Connect(function(p1) --[[ Line: 104 | Upvalues: v2 (ref), GiftPrompt (ref) ]]
		if p1.Character then
			local v1 = v2:Clone(GiftPrompt)
			v1.Parent = p1.Character.HumanoidRootPart
			v2:Add(HandlePrompt(v1, p1))
		end
		v2:Add(p1.CharacterAdded:Connect(function(p12) --[[ Line: 111 | Upvalues: v2 (ref), GiftPrompt (ref), p1 (copy) ]]
			local HumanoidRootPart = p12:WaitForChild("HumanoidRootPart", 5)
			if HumanoidRootPart then
				local v1 = v2:Clone(GiftPrompt)
				v1.Parent = HumanoidRootPart
				v2:Add(HandlePrompt(v1, p1))
			end
		end))
	end))
end
function HandleCharacter(p1) --[[ HandleCharacter | Line: 124 | Upvalues: v1 (copy) ]]
	if p1 then
		v1:Clean()
		v1:Add(p1.ChildAdded:Connect(OnChildAdded))
		v1:Add(p1.ChildRemoved:Connect(OnChildRemoved))
	end
end
function OnNewGift(p1) --[[ OnNewGift | Line: 135 | Upvalues: ConfirmationUI (copy), Network (copy) ]]
	if ConfirmationUI:GetResult(nil, ("You received a gift \'%*\', Accept?"):format(p1), 10) == "Yes" then
		Network.FireServer("SendGift", true)
	else
		Network.FireServer("SendGift", false)
	end
end
function t._init() --[[ _init | Line: 144 | Upvalues: LocalPlayer (copy), Network (copy) ]]
	HandleCharacter(LocalPlayer.Character)
	LocalPlayer.CharacterAdded:Connect(HandleCharacter)
	Network.OnClientEvent("SendGift"):Connect(OnNewGift)
end
return t