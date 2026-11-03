-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local SoundService = game:GetService("SoundService")
require(ReplicatedStorage.Shared.Data.Types)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local Network = require(ReplicatedStorage.Shared.Packages.Network)
local VFXService = require(ReplicatedStorage.Modules.ServicesLoader.VFXService)
local LocalPlayer = game:GetService("Players").LocalPlayer
local CollectOffline = SoundService.Effects.CollectOffline
local Frames = LocalPlayer.PlayerGui:WaitForChild("Frames")
local v1 = Trove.new()
local t = {
	Active = false
}
function t.DisplayOffline(p1, p2) --[[ DisplayOffline | Line: 34 | Upvalues: Frames (copy), Network (copy), CollectOffline (copy), VFXService (copy), t (copy), MarketplaceService (copy), LocalPlayer (copy), v1 (copy) ]]
	if not p1.Active then
		p1.Active = true
		local Buttons = Frames.OfflineFrame.Buttons
		Frames.OfflineFrame.Visible = true
		Frames.OfflineFrame.Earned.Amount.Text = ("%*$"):format(p2)
		local function OnFrameChanged() --[[ OnFrameChanged | Line: 50 | Upvalues: Frames (ref) ]]
			Frames.OfflineFrame.Visible = true
		end
		local function OnClickedClaim() --[[ OnClickedClaim | Line: 54 | Upvalues: Network (ref), CollectOffline (ref), VFXService (ref), t (ref) ]]
			Network.FireServer("Offline_Claim")
			CollectOffline:Play()
			VFXService.PlayVFX("PlayCash")
			t:Close()
		end
		local function OnClickedUpgrade() --[[ OnClickedUpgrade | Line: 61 | Upvalues: MarketplaceService (ref), LocalPlayer (ref) ]]
			MarketplaceService:PromptProductPurchase(LocalPlayer, 1234567890)
		end
		v1:Connect(Frames.OfflineFrame:GetPropertyChangedSignal("Visible"), OnFrameChanged)
		v1:Connect(Buttons.Upgrade.Activated, OnClickedUpgrade)
		v1:Connect(Buttons.Claim.Activated, OnClickedClaim)
		v1:Connect(Frames.OfflineFrame.Top.Main.Close.Activated, OnClickedClaim)
	end
end
function t.Close(p1) --[[ Close | Line: 72 | Upvalues: v1 (copy), Frames (copy) ]]
	if p1.Active then
		v1:Destroy()
		Frames.OfflineFrame.Visible = false
		p1.Active = false
	end
end
return t