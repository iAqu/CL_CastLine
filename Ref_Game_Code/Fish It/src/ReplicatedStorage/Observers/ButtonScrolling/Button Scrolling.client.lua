-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local spr = require(ReplicatedStorage.Packages.spr)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local Main = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Exclusive Store"):WaitForChild("Main")
local Items = script.Parent:WaitForChild("Items")
local Above = script.Parent:WaitForChild("Top"):WaitForChild("Above")
local function OpenCurrency() --[[ OpenCurrency | Line: 24 | Upvalues: spr (copy), Items (copy), GuiControl (copy) ]]
	spr.stop(Items)
	spr.target(Items, 1, 2, {
		CanvasPosition = Vector2.new(0, Items.UIListLayout.AbsoluteContentSize.Y * 0.6 + 10)
	})
	if GuiControl:IsOpen("Exclusive Store") then
		return
	end
	GuiControl:Open("Exclusive Store")
end
local Coins = Above:WaitForChild("Coins")
if Coins then
	GuiControl:Hook("Hold Button", Coins).Clicked:Connect(OpenCurrency)
end
Observers.observeTag("ExclusiveCurrencyButton", function(p1) --[[ Line: 42 | Upvalues: GuiControl (copy), OpenCurrency (copy) ]]
	local v1 = GuiControl:Hook("Hold Button", p1)
	v1.Clicked:Connect(OpenCurrency)
	return function() --[[ Line: 46 | Upvalues: v1 (copy) ]]
		v1:Destroy()
	end
end)
if not (Replion.Client:WaitReplion("Data") and workspace.CurrentCamera.ViewportSize.Y <= 500) then
	return
end
Main.Size = UDim2.fromScale(0.9, 0.9)