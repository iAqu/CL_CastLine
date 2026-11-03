-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local Observers = require(ReplicatedStorage.Packages.Observers)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Net = require(ReplicatedStorage.Packages.Net)
local spr = require(ReplicatedStorage.Packages.spr)
local Constants = require(ReplicatedStorage.Shared.Constants)
local Device = require(ReplicatedStorage.Modules.Device)
local GuiControl = require(ReplicatedStorage.Modules.GuiControl)
local ToolTip = require(ReplicatedStorage.Modules.ToolTip)
local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
local v1 = nil
local v2 = Net:RemoteEvent("ClaimNotification")
local CurrentCamera = workspace.CurrentCamera
local v3 = nil
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
PlayerGui:WaitForChild("HUD")
local BlurEffect = Lighting:FindFirstChildOfClass("BlurEffect")
if not BlurEffect then
	local BlurEffect_2 = Instance.new("BlurEffect")
	BlurEffect_2.Size = 0
	BlurEffect_2.Enabled = false
	BlurEffect_2.Parent = Lighting
	BlurEffect = BlurEffect_2
end
local v4 = PlayerGui:WaitForChild("Exclusive Store")
PlayerGui:WaitForChild("Inventory")
local v5 = PlayerGui:WaitForChild("Boat Shop")
local t = {}
function t.Init(p1) --[[ Init | Line: 53 | Upvalues: v1 (ref), ReplicatedStorage (copy), GuiControl (copy), v5 (copy), v2 (copy), v4 (copy), v3 (ref), Constants (copy), t (copy), BlurEffect (ref), LocalPlayer (copy), ToolTip (copy), PlayerGui (copy), Soundbook (copy) ]]
	v1 = require(ReplicatedStorage.Controllers.MainlineQuestController)
	GuiControl.GuiFocusedSignal:Connect(function(p1) --[[ Line: 57 | Upvalues: v5 (ref), v2 (ref), v4 (ref), v3 (ref), Constants (ref) ]]
		if p1 == v5 then
			v2:FireServer("Boats")
			return
		end
		if p1 ~= v4 then
			return
		end
		local v1 = v3:Get("StoreNotification")
		if not v1 then
			return
		end
		if not (v1 < Constants.StoreNotification) then
			return
		end
		v2:FireServer("Store")
	end)
	GuiControl.GuiFocusedSignal:Connect(function(p1) --[[ Line: 73 | Upvalues: v1 (ref), t (ref), BlurEffect (ref), GuiControl (ref) ]]
		local v12 = p1:HasTag("FullscreenBlur")
		local v2 = p1:HasTag("Fullscreen")
		local v3 = p1:HasTag("IgnoreHUDVisibility")
		if v2 then
			v1:Suppress((("Fullscreen:%*"):format(p1.Name)))
			t.Fullscreen(false, v12, v3)
			return
		end
		if v3 then
			return
		end
		if BlurEffect and not p1:HasTag("IgnoreBlur") then
			t.SetBlurSize(18)
			t.SetCameraFOV(75)
		end
		if p1 ~= GuiControl.Gui then
			return
		end
		GuiControl:SetHUDVisibility(false)
	end)
	GuiControl.GuiUnfocusedSignal:Connect(function(p1) --[[ Line: 99 | Upvalues: v1 (ref), t (ref), GuiControl (ref), BlurEffect (ref), LocalPlayer (ref) ]]
		local v12 = p1:HasTag("FullscreenBlur")
		local v2 = p1:HasTag("Fullscreen")
		local v3 = p1:HasTag("IgnoreHUDVisibility")
		if v2 then
			v1:Unsuppress((("Fullscreen:%*"):format(p1.Name)))
			t.Fullscreen(true, v12, v3)
		elseif BlurEffect and not p1:HasTag("IgnoreBlur") then
			t.SetBlurSize(0)
			if not (LocalPlayer:GetAttribute("IgnoreFOV") or LocalPlayer:GetAttribute("InCutscene")) then
				t.ResetCamera()
			end
		end
		GuiControl:SetHUDVisibility(true)
	end)
	GuiControl.GuiHiddenSignal:Connect(function() --[[ Line: 126 | Upvalues: ToolTip (ref) ]]
		ToolTip.destroyAll()
	end)
	GuiControl.GuiUnfocusedSignal:Connect(function() --[[ Line: 130 | Upvalues: ToolTip (ref) ]]
		ToolTip.destroyAll()
	end)
	GuiControl.GuiFocusedSignal:Connect(function(p1) --[[ Line: 134 | Upvalues: PlayerGui (ref), Soundbook (ref) ]]
		if p1 ~= PlayerGui["Exclusive Store"] then
			return
		end
		Soundbook.Sounds.ItemShopJingle:Play()
	end)
end
function t.Start(p1) --[[ Start | Line: 141 | Upvalues: v3 (ref), Replion (copy), Device (copy), Observers (copy), PlayerGui (copy) ]]
	v3 = Replion.Client:WaitReplion("Data")
	local function observeMobile(p1, p2) --[[ observeMobile | Line: 145 | Upvalues: Device (ref) ]]
		local function visible() --[[ visible | Line: 146 | Upvalues: Device (ref), p1 (copy), p2 (copy) ]]
			if not Device:IsMobile() then
				return
			end
			p1.Visible = p2
		end
		if Device:IsMobile() then
			p1.Visible = p2
		end
		local v1 = Device:RegisterDeviceChanged(function() --[[ Line: 154 | Upvalues: Device (ref), p1 (copy), p2 (copy) ]]
			if not Device:IsMobile() then
				return
			end
			p1.Visible = p2
		end)
		return function() --[[ Line: 158 | Upvalues: Device (ref), v1 (copy) ]]
			Device:Remove(v1)
		end
	end
	Observers.observeTag("HideOnMobile", function(p1) --[[ Line: 163 | Upvalues: observeMobile (copy) ]]
		return observeMobile(p1, true)
	end, { PlayerGui })
	local function observeConsole(p1, p2) --[[ observeConsole | Line: 168 | Upvalues: Device (ref), v3 (ref) ]]
		local v1 = p1:GetAttribute("EquipShow")
		local v2 = nil
		local function visible() --[[ visible | Line: 173 | Upvalues: Device (ref), v1 (copy), v3 (ref), p1 (copy), p2 (copy) ]]
			local v12 = Device:_getDevice() == "Console"
			if v12 and v1 then
				v12 = string.len(v3.Data.EquippedId) > 0
			end
			if v12 then
				p1.Visible = p2
			else
				p1.Visible = not p2
			end
		end
		local v32 = Device:_getDevice() == "Console"
		if v32 and v1 then
			v32 = string.len(v3.Data.EquippedId) > 0
		end
		if v32 then
			p1.Visible = p2
		else
			p1.Visible = not p2
		end
		local v5 = Device:RegisterDeviceChanged(function() --[[ Line: 189 | Upvalues: Device (ref), v1 (copy), v3 (ref), p1 (copy), p2 (copy) ]]
			local v12 = Device:_getDevice() == "Console"
			if v12 and v1 then
				v12 = string.len(v3.Data.EquippedId) > 0
			end
			if v12 then
				p1.Visible = p2
			else
				p1.Visible = not p2
			end
		end)
		if v1 then
			v2 = v3:OnChange("EquippedId", function() --[[ Line: 194 | Upvalues: Device (ref), v1 (copy), v3 (ref), p1 (copy), p2 (copy) ]]
				local v12 = Device:_getDevice() == "Console"
				if v12 and v1 then
					v12 = string.len(v3.Data.EquippedId) > 0
				end
				if v12 then
					p1.Visible = p2
				else
					p1.Visible = not p2
				end
			end)
		end
		return function() --[[ Line: 199 | Upvalues: Device (ref), v5 (copy), v2 (ref) ]]
			Device:Remove(v5)
			if not v2 then
				return
			end
			v2:Disconnect()
		end
	end
	Observers.observeTag("HideOnConsole", function(p1) --[[ Line: 208 | Upvalues: observeConsole (copy) ]]
		return observeConsole(p1, false)
	end, { PlayerGui })
	Observers.observeTag("ShowOnConsole", function(p1) --[[ Line: 212 | Upvalues: observeConsole (copy) ]]
		return observeConsole(p1, true)
	end, { PlayerGui })
end
function t.ResetCamera() --[[ ResetCamera | Line: 217 | Upvalues: t (copy) ]]
	t.SetCameraFOV(65)
end
function t.SetCameraFOV(p1) --[[ SetCameraFOV | Line: 222 | Upvalues: spr (copy), CurrentCamera (copy) ]]
	spr.stop(CurrentCamera)
	spr.target(CurrentCamera, 90, 325, {
		FieldOfView = p1
	})
end
function t.SetBlurSize(p1) --[[ SetBlurSize | Line: 229 | Upvalues: BlurEffect (ref), spr (copy) ]]
	if not BlurEffect.Enabled then
		BlurEffect.Enabled = true
	end
	spr.stop(BlurEffect)
	spr.target(BlurEffect, 90, 325, {
		Size = p1
	})
end
function t.Fullscreen(p1, p2, p3) --[[ Fullscreen | Line: 240 | Upvalues: spr (copy), PlayerGui (copy), BlurEffect (ref), t (copy) ]]
	spr.stop(PlayerGui:WaitForChild("XP").Frame)
	spr.stop(PlayerGui:WaitForChild("Backpack").UIPadding)
	spr.stop(PlayerGui:WaitForChild("HUD").Frame)
	spr.stop(PlayerGui:WaitForChild("Compass").UIPadding)
	spr.stop(PlayerGui:WaitForChild("Events").UIPadding)
	spr.stop(PlayerGui:WaitForChild("Active Potions").UIPadding)
	if p1 then
		spr.target(PlayerGui.Backpack.UIPadding, 1, 3, {
			PaddingBottom = UDim.new(0, 6)
		})
		spr.target(PlayerGui.Compass.UIPadding, 1, 3, {
			PaddingTop = UDim.new(0, 10)
		})
		spr.target(PlayerGui.Events.UIPadding, 1, 3, {
			PaddingLeft = UDim.new(0, 5)
		})
		spr.target(PlayerGui["Active Potions"].UIPadding, 1, 3, {
			PaddingRight = UDim.new(0, 5)
		})
		spr.target(PlayerGui.XP.Frame, 1, 3, {
			Position = UDim2.fromScale(0.5, 1)
		})
		spr.target(PlayerGui.Backpack.Display, 1, 3, {
			Position = UDim2.fromScale(0.5, 1)
		})
		spr.target(PlayerGui.HUD.Frame, 1, 3, {
			Position = UDim2.fromScale(0, 0)
		})
		if BlurEffect and BlurEffect.Size > 0 then
			t.SetBlurSize(0)
		end
	else
		if not p3 then
			spr.target(PlayerGui.Backpack.UIPadding, 1, 3, {
				PaddingBottom = UDim.new(-1, 6)
			})
		end
		spr.target(PlayerGui.Compass.UIPadding, 1, 3, {
			PaddingTop = UDim.new(-1, 10)
		})
		spr.target(PlayerGui.XP.Frame, 1, 3, {
			Position = UDim2.fromScale(0.5, 2)
		})
		spr.target(PlayerGui.HUD.Frame, 1, 3, {
			Position = UDim2.fromScale(-1, 0)
		})
		spr.target(PlayerGui.Compass.Inside, 1, 3, {
			Position = UDim2.fromScale(-0.5, 0)
		})
		spr.target(PlayerGui.Events.UIPadding, 1, 3, {
			PaddingLeft = UDim.new(-1, 5)
		})
		spr.target(PlayerGui["Active Potions"].UIPadding, 1, 3, {
			PaddingRight = UDim.new(-1, 5)
		})
		if not p2 then
			return
		end
		t.SetBlurSize(18)
	end
end
return t