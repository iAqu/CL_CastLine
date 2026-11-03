-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("ServerScriptService")
require(ReplicatedStorage.Modules.ServicesLoader.ClientPlotService)
local SpeedServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.SpeedServiceClient)
local TweenService = game:GetService("TweenService")
local ClientProfile = require(ReplicatedStorage.Modules.ServicesLoader.ClientProfile)
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local v1 = PlayerGui:FindFirstChild("Frames") or PlayerGui:WaitForChild("Frames")
local v2 = PlayerGui:FindFirstChild("HUD") or PlayerGui:WaitForChild("HUD")
local CurrentCamera = workspace.CurrentCamera
local v3 = Trove.new()
local t = {
	Slow = function() --[[ Slow | Line: 27 | Upvalues: LocalPlayer (copy), v2 (copy), TweenService (copy), SpeedServiceClient (copy) ]]
		if LocalPlayer.Character then
			local Slow = v2.LeftPanel.Slow
			local t = {
				[true] = {
					BackgroundColor3 = Color3.fromHex("#26ff00"),
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.fromScale(1, 0.5)
				},
				[false] = {
					BackgroundColor3 = Color3.fromHex("#ff0004"),
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.fromScale(0, 0.5)
				}
			}
			local function SlowUpdated(p1) --[[ SlowUpdated | Line: 48 | Upvalues: t (copy), TweenService (ref), Slow (copy) ]]
				TweenService:Create(Slow.Circle, TweenInfo.new(0.3), t[p1]):Play()
			end
			local function ToggleSlow() --[[ ToggleSlow | Line: 53 | Upvalues: SpeedServiceClient (ref) ]]
				SpeedServiceClient:SlowMode(not SpeedServiceClient.InSlowMode)
			end
			local v1 = t[SpeedServiceClient.InSlowMode]
			TweenService:Create(Slow.Circle, TweenInfo.new(0.3), v1):Play()
			Slow.Activated:Connect(ToggleSlow)
			SpeedServiceClient.SlowChanged:Connect(SlowUpdated)
		end
	end
}
function InitHUDButtons() --[[ InitHUDButtons | Line: 63 | Upvalues: v2 (copy), v1 (copy), t (copy) ]]
	for i, v in ipairs(v2.LeftPanel:GetChildren()) do
		if v:IsA("GuiButton") then
			local v12 = v1:FindFirstChild(v.Name)
			local InputAction = v:FindFirstChildOfClass("InputAction")
			if v12 then
				if InputAction then
					InputAction.Released:Connect(function() --[[ Line: 70 | Upvalues: v12 (copy) ]]
						v12.Visible = not v12.Visible
					end)
				end
				v.Activated:Connect(function() --[[ Line: 74 | Upvalues: v12 (copy) ]]
					v12.Visible = not v12.Visible
				end)
			end
			if t[v.Name] then
				t[v.Name]()
			end
		end
	end
end
function CheckGamepad(p1) --[[ CheckGamepad | Line: 85 | Upvalues: v3 (copy), ClientProfile (copy), v2 (copy) ]]
	v3:Clean()
	if p1 == ClientProfile.DeviceTypes.Console then
		for i, v in ipairs(v2.LeftPanel:GetChildren()) do
			if v:IsA("GuiButton") then
				local GamepadKey = v:FindFirstChild("GamepadKey")
				if GamepadKey then
					GamepadKey.Visible = true
				end
			end
		end
		v3:Add(function() --[[ Line: 100 | Upvalues: v2 (ref) ]]
			for i, v in ipairs(v2.LeftPanel:GetChildren()) do
				if v:IsA("GuiButton") then
					local GamepadKey = v:FindFirstChild("GamepadKey")
					if GamepadKey then
						GamepadKey.Visible = false
					end
				end
			end
		end)
	end
end
function t._init() --[[ _init | Line: 112 | Upvalues: ClientProfile (copy) ]]
	InitHUDButtons()
	CheckGamepad(ClientProfile.Device)
	ClientProfile.DeviceChanged:Connect(CheckGamepad)
end
return t