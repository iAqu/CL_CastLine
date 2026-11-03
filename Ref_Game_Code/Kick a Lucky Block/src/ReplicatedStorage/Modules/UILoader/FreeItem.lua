-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local ClaimFree = Network.ClaimFree
local VFXService = require(ReplicatedStorage.Modules.ServicesLoader.VFXService)
local PlayerGui = Players.LocalPlayer.PlayerGui
local v1 = PlayerGui:FindFirstChild("Frames") or PlayerGui:WaitForChild("Frames")
local v2 = PlayerGui:FindFirstChild("HUD") or PlayerGui:WaitForChild("HUD")
local BuyButton1 = v1.Store.Content.ScrollingFrame.FreeBrainrot.Content.BuyButton1
local Store = v2.LeftPanel.Store
local FreeInfo = Store.FreeInfo
local Info = Store.Info
local v3 = false
return {
	_init = function() --[[ _init | Line: 34 | Upvalues: Network (copy), v3 (ref), BuyButton1 (copy), FreeInfo (copy), Info (copy), VFXService (copy) ]]
		Network.OnClientEvent("CheckFree"):Connect(function(p1) --[[ Line: 35 | Upvalues: v3 (ref), BuyButton1 (ref), FreeInfo (ref), Info (ref) ]]
			if p1 then
				v3 = true
				BuyButton1.Label.Text = "Claimed"
				BuyButton1.Interactable = false
				FreeInfo.Visible = false
				Info.Visible = true
			else
				FreeInfo.Visible = true
				Info.Visible = false
			end
		end)
		Network.FireServer("CheckFree")
		BuyButton1.Activated:Connect(function() --[[ Line: 49 | Upvalues: v3 (ref), BuyButton1 (ref), FreeInfo (ref), Info (ref), Network (ref), VFXService (ref) ]]
			if not v3 then
				v3 = true
				BuyButton1.Label.Text = "Claimed"
				BuyButton1.Interactable = false
				FreeInfo.Visible = false
				Info.Visible = true
				Network.FireServer("ClaimFree")
				VFXService.PlayVFX("PlayConfetti")
			end
		end)
	end
}