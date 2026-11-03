-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local Net = require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Signal = require(ReplicatedStorage.Packages.Signal)
require(ReplicatedStorage.Packages.Trove)
require(ReplicatedStorage.Packages.Thread)
local Observers = require(ReplicatedStorage.Packages.Observers)
local spr = require(ReplicatedStorage.Packages.spr)
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local AreaController = require(ReplicatedStorage.Controllers.AreaController)
local v1 = false
local v2 = false
local t = {
	[0] = 2,
	[1] = 2300
}
local v3 = nil
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = workspace.CurrentCamera
local Terrain = workspace:WaitForChild("Terrain")
local Blur = Lighting:WaitForChild("Blur")
local WorldSetup = workspace:WaitForChild("WorldSetup")
local Oxygen = LocalPlayer.PlayerGui:WaitForChild("Oxygen")
local Bar = Oxygen:WaitForChild("Main"):WaitForChild("CanvasGroup"):WaitForChild("Bar")
local v4 = Net:UnreliableRemoteEvent("UpdateOxygen")
local v5 = nil
local v6 = false
local v7 = false
local v8 = Signal.new()
local v9 = 25
local v10 = 25
local v11 = 0
local v12 = 0
local v13 = false
local v14 = Signal.new()
local t2 = {}
function t2.Init(p1) --[[ Init | Line: 71 | Upvalues: v5 (ref), SoundService (copy), v14 (copy), v10 (ref), v9 (ref), v7 (ref), v2 (ref), v8 (copy), spr (copy), LocalPlayer (copy), Observers (copy), t2 (copy) ]]
	v5 = Instance.new("Sound")
	v5.SoundId = "rbxassetid://121936142687913"
	v5.Volume = 0
	v5.Looped = true
	v5.Parent = SoundService
	v14:Connect(function(p1) --[[ Line: 78 | Upvalues: v10 (ref), v9 (ref) ]]
		if p1 then
			v10 = v9
		end
		UpdateOxygenGui()
	end)
	local function refreshBlurState() --[[ refreshBlurState | Line: 86 | Upvalues: v7 (ref), v2 (ref) ]]
		SetBlur(if v7 and not v2 then 12 else 1)
	end
	v8:Connect(function(p1) --[[ Line: 96 | Upvalues: v5 (ref), spr (ref), v7 (ref), v2 (ref) ]]
		if v5 then
			spr.stop(v5)
			if p1 and not v5.Playing then
				v5:Play()
			end
			spr.target(v5, 1, 3, {
				Volume = if p1 then 0.3 else 0
			})
		end
		SetBlur(if v7 and not v2 then 12 else 1)
	end)
	LocalPlayer:GetAttributeChangedSignal("InCutscene"):Connect(function() --[[ Line: 115 | Upvalues: v7 (ref), v2 (ref) ]]
		UpdateBlurSetting()
		SetBlur(if v7 and not v2 then 12 else 1)
	end)
	Observers.observeSpecificCharacter(LocalPlayer, function(p1) --[[ Line: 120 | Upvalues: t2 (ref) ]]
		local Humanoid = p1:WaitForChild("Humanoid")
		local v1 = Humanoid.StateChanged:Connect(function() --[[ Line: 123 | Upvalues: Humanoid (copy), t2 (ref) ]]
			if Humanoid:GetState() == Enum.HumanoidStateType.Swimming then
				t2:BlockOxygenLoss(false)
			else
				t2:BlockOxygenLoss(true)
			end
		end)
		t2:BlockOxygenLoss(true)
		task.delay(1, function() --[[ Line: 132 | Upvalues: t2 (ref) ]]
			t2:BlockOxygenLoss(false)
		end)
		return function() --[[ Line: 136 | Upvalues: v1 (copy) ]]
			v1:Disconnect()
		end
	end)
end
function t2.Start(p1) --[[ Start | Line: 142 | Upvalues: v3 (ref), Replion (copy), v1 (ref), t2 (copy), LocalPlayer (copy), Terrain (copy), v6 (ref) ]]
	v3 = Replion.Client:WaitReplion("Data")
	local function SetOxygenDisabled() --[[ SetOxygenDisabled | Line: 147 | Upvalues: v3 (ref), v1 (ref) ]]
		v1 = v3:GetExpect("LastBoatId") == -1
	end
	v3:OnChange("EquippedOxygenTankId", function(p1) --[[ Line: 156 | Upvalues: t2 (ref) ]]
		t2:UpdateOxygenTank(p1)
	end)
	t2:UpdateOxygenTank(v3:GetExpect("EquippedOxygenTankId"))
	v3:OnChange("LastBoatId", SetOxygenDisabled)
	v1 = if v3:GetExpect("LastBoatId") == -1 then true else false
	task.spawn(function() --[[ Line: 167 | Upvalues: LocalPlayer (ref), t2 (ref), Terrain (ref), v6 (ref) ]]
		while true do
			local v1, v2
			repeat
				local v3
				repeat
					repeat
						task.wait(1 / 60)
						v3 = LocalPlayer.Character
					until v3
					v1 = v3.PrimaryPart
				until v1
				v2 = v3:FindFirstChildWhichIsA("Humanoid")
			until v2 and t2:ShouldTakeDamage(v2)
			local v5 = false
			local v62 = false
			for i, v in ipairs((GetList(v1))) do
				local v7 = Terrain:ReadVoxels(Region3.new(v.Min, v.Max):ExpandToGrid(4), 4)
				if v7 and (v7[1] and (v7[1][1] and (v7[1][1][1] and v7[1][1][1] == Enum.Material.Water))) then
					if v.BlurCamera and not v5 then
						v5 = v.BlurCamera
					end
					if v.TakeDamage and not v62 then
						v62 = v.TakeDamage
					end
				end
			end
			SetUnderwater(v5)
			v6 = v62
		end
	end)
	task.spawn(function() --[[ Line: 224 | Upvalues: v6 (ref) ]]
		while true do
			while true do
				task.wait(0.4)
				if not v6 then
					break
				end
				DepleteOxygen()
			end
			RegenOxygen()
		end
	end)
end
function t2.UpdateOxygenTank(p1, p2) --[[ UpdateOxygenTank | Line: 237 | Upvalues: ItemUtility (copy), v10 (ref), v9 (ref) ]]
	local v1
	if p2 > 0 then
		local v2 = ItemUtility.GetItemDataFromItemType("Gears", p2)
		v1 = if v2 and v2.MaxOxygen then v2.MaxOxygen else 25
	else
		v1 = 25
	end
	UpdateBlurSetting()
	if not v1 then
		return
	end
	if v10 == v9 then
		v9 = v1
		v10 = v1
	else
		v9 = v1
		v10 = math.min(v10, v1)
	end
	UpdateOxygenGui()
end
function t2.BlockOxygenLoss(p1, p2) --[[ BlockOxygenLoss | Line: 265 | Upvalues: v13 (ref), v14 (copy) ]]
	if v13 ~= p2 then
		v13 = p2
		v14:Fire(p2)
	end
end
function t2.ShouldTakeDamage(p1, p2) --[[ ShouldTakeDamage | Line: 274 | Upvalues: v1 (ref) ]]
	if v1 then
		return false
	else
		return p2:GetState() ~= Enum.HumanoidStateType.Dead and not (p2.Health <= 0) and true or false
	end
end
function t2.IsPlayerSubmerged(p1) --[[ IsPlayerSubmerged | Line: 286 | Upvalues: v7 (ref) ]]
	return v7
end
function GetList(p1) --[[ GetList | Line: 291 | Upvalues: CurrentCamera (copy) ]]
	local Position = p1.Position
	local Position_2 = CurrentCamera.CFrame.Position
	return {
		{
			BlurCamera = false,
			TakeDamage = true,
			Min = Position + Vector3.new(0, 2, 0),
			Max = Position + Vector3.new(0, 2.1, 0)
		},
		{
			BlurCamera = true,
			TakeDamage = false,
			Min = Position_2 - Vector3.new(0.01, 0.01, 0.01),
			Max = Position_2 + Vector3.new(0.01, 0.01, 0.01)
		}
	}
end
function UpdateOxygenGui() --[[ UpdateOxygenGui | Line: 311 | Upvalues: v10 (ref), v9 (ref), spr (copy), Bar (copy), Oxygen (copy) ]]
	local v1 = UDim2.fromScale(1, v10 / v9)
	spr.stop(Bar)
	spr.target(Bar, 40, 200, {
		Size = v1
	})
	Oxygen.Enabled = v10 < v9
end
function DealDamage(p1) --[[ DealDamage | Line: 322 | Upvalues: v13 (ref), LocalPlayer (copy), t2 (copy), v12 (ref), v4 (copy) ]]
	if v13 then
		return
	end
	local Character = LocalPlayer.Character
	local v1 = if Character then Character:FindFirstChild("Humanoid") else Character
	if not v1 then
		return
	end
	if t2:ShouldTakeDamage(v1) then
		v12 = p1
		v4:FireServer()
	end
end
function DepleteOxygen() --[[ DepleteOxygen | Line: 342 | Upvalues: v10 (ref), LocalPlayer (copy), WorldSetup (copy), AreaController (copy), v11 (ref), t (copy), v12 (ref) ]]
	if v10 > 0 then
		local v1 = LocalPlayer:GetAttribute("LocationName")
		local v2 = WorldSetup and WorldSetup:FindFirstChild("WaterPressureZones")
		local v3 = if v1 then if v2 then v2:FindFirstChild(v1) else v2 else v1
		if v3 then
			if LocalPlayer.Character and LocalPlayer.Character:GetPivot() then
				local v5 = false
				for i, v in ipairs(v3:GetChildren()) do
					if AreaController:IsPlayerInArea(v.Position, v.Size) then
						v5 = true
						v11 = v:GetAttribute("PressureLevel") or 1
						break
					end
				end
				if not v5 then
					v11 = 0
				end
			end
		else
			v11 = 0
		end
		v10 = math.max(v10 - t[v11], 0)
	else
		if v10 ~= 0 then
			UpdateOxygenGui()
			return
		end
		local v7 = workspace:GetServerTimeNow()
		if not (v12 + 1 < v7) then
			UpdateOxygenGui()
			return
		end
		DealDamage(v7)
	end
	UpdateOxygenGui()
end
function RegenOxygen() --[[ RegenOxygen | Line: 384 | Upvalues: v3 (ref), ItemUtility (copy), v10 (ref), v9 (ref) ]]
	local v1 = 5
	if v3 then
		local v32 = ItemUtility.GetItemDataFromItemType("Gears", (v3:Get("EquippedOxygenTankId")))
		if v32 and v32.RegenOxygen then
			v1 = v32.RegenOxygen
		end
	end
	v10 = math.min(v10 + v1, v9)
	UpdateOxygenGui()
end
function SetUnderwater(p1) --[[ SetUnderwater | Line: 399 | Upvalues: v7 (ref), v8 (copy), LocalPlayer (copy) ]]
	if v7 ~= p1 then
		v7 = p1
		v8:Fire(p1)
		LocalPlayer:SetAttribute("Underwater", p1)
	end
end
function SetBlur(p1) --[[ SetBlur | Line: 409 | Upvalues: v2 (ref), spr (copy), Blur (copy) ]]
	if not v2 then
		spr.stop(Blur)
		spr.target(Blur, 1, 3, {
			Size = p1
		})
		return
	end
	spr.stop(Blur)
	Blur.Size = 0
	spr.stop(Blur)
	spr.target(Blur, 1, 3, {
		Size = p1
	})
end
function UpdateBlurSetting() --[[ UpdateBlurSetting | Line: 421 | Upvalues: LocalPlayer (copy), v2 (ref), v3 (ref) ]]
	if LocalPlayer:GetAttribute("InCutscene") then
		v2 = true
		return
	end
	local v1 = v3:Get("EquippedOxygenTankId")
	v2 = v1 and v1 > 0 and true or false
end
return t2