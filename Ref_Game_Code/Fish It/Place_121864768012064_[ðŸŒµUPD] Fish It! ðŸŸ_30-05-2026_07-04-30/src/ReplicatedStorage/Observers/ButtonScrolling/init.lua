-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("ReplicatedStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local spr = require(ReplicatedStorage.Packages.spr)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local PlayerGui = Players.LocalPlayer.PlayerGui
Replion.Client:AwaitReplion("Data", function(p1) --[[ Line: 20 | Upvalues: Observers (copy), spr (copy), GuiControl (copy), PlayerGui (copy) ]]
	Observers.observeTag("ButtonScrolling", function(p1) --[[ Line: 22 | Upvalues: spr (ref), GuiControl (ref), Observers (ref) ]]
		local Main = p1:WaitForChild("Main")
		if workspace.CurrentCamera.ViewportSize.Y <= 500 then
			Main.Size = UDim2.fromScale(0.9, 0.9)
		end
		local v1 = p1:WaitForChild("Main"):WaitForChild("Content")
		if not v1 then
			return
		end
		local Items = v1:WaitForChild("Items")
		local Above = v1:WaitForChild("Top"):WaitForChild("Above")
		local function OpenCurrency() --[[ OpenCurrency | Line: 34 | Upvalues: spr (ref), Items (copy), GuiControl (ref) ]]
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
		Observers.observeTag("ExclusiveCurrencyButton", function(p1) --[[ Line: 50 | Upvalues: GuiControl (ref), OpenCurrency (copy) ]]
			local v1 = GuiControl:Hook("Hold Button", p1)
			v1.Clicked:Connect(OpenCurrency)
			return function() --[[ Line: 54 | Upvalues: v1 (copy) ]]
				v1:Destroy()
			end
		end)
	end, { PlayerGui })
end)
return {}