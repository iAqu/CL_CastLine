-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WheelSpinServiceClient = require(ReplicatedStorage.Modules.ServicesLoader.WheelSpinServiceClient)
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
require(ReplicatedStorage.Modules.ServicesLoader.TimerService)
local MessagesService = require(ReplicatedStorage.Modules.ServicesLoader.MessagesService)
local WheelData = require(ReplicatedStorage.Shared.Data.WheelData)
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local v1 = PlayerGui:FindFirstChild("WheelSpin") or PlayerGui:WaitForChild("WheelSpin")
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local Spring = require(ReplicatedStorage.Shared.Packages.Spring)
local FormatTime = require(ReplicatedStorage.Functional.FormatTime)
local v2 = Trove.new()
local v3 = Trove.new()
local v4 = nil
local t = {}
local v5 = Random.new()
local t2 = {}
function InitButton() --[[ InitButton | Line: 53 | Upvalues: v1 (copy), WheelSpinServiceClient (copy) ]]
	v1.Buttons.SpinButton.Activated:Connect(function() --[[ Line: 54 | Upvalues: WheelSpinServiceClient (ref) ]]
		WheelSpinServiceClient:RequestSpin()
	end)
end
function OnSpinsChanged(p1) --[[ OnSpinsChanged | Line: 59 | Upvalues: v1 (copy) ]]
	v1.Buttons.SpinButton.SpinsLabel.Text = ("Spins: %*"):format(p1)
end
function InitFreeTimer() --[[ InitFreeTimer | Line: 63 | Upvalues: v1 (copy), RunService (copy), FormatTime (copy) ]]
	local v12 = nil
	local function ToggleTimer() --[[ ToggleTimer | Line: 66 | Upvalues: v1 (ref), v12 (ref), RunService (ref), FormatTime (ref) ]]
		if v1.Enabled then
			if not (v12 and v12.Connected) then
				local v13 = 0
				v12 = RunService.PreRender:Connect(function() --[[ Line: 76 | Upvalues: v13 (ref), v1 (ref), FormatTime (ref) ]]
					local v12 = tick()
					if not (v12 - v13 < 0.33) then
						v13 = v12
						v1.FreeSpinLabel.Text = ("Next Free Spin: %*"):format((FormatTime(7200 - workspace:GetServerTimeNow() % 7200)))
					end
				end)
			end
		elseif v12 and v12.Connected then
			v12:Disconnect()
		end
	end
	if v1.Enabled then
		if not (v12 and v12.Connected) then
			local v2 = 0
			v12 = RunService.PreRender:Connect(function() --[[ Line: 76 | Upvalues: v2 (ref), v1 (ref), FormatTime (ref) ]]
				local v12 = tick()
				if not (v12 - v2 < 0.33) then
					v2 = v12
					v1.FreeSpinLabel.Text = ("Next Free Spin: %*"):format((FormatTime(7200 - workspace:GetServerTimeNow() % 7200)))
				end
			end)
		end
	elseif v12 and v12.Connected then
		v12:Disconnect()
	end
	v1:GetPropertyChangedSignal("Enabled"):Connect(ToggleTimer)
end
function DestroyFreeSpinLabel() --[[ DestroyFreeSpinLabel | Line: 98 | Upvalues: v3 (copy) ]]
	v3:Clean()
end
function SpinWheel(p1) --[[ SpinWheel | Line: 102 | Upvalues: WheelData (copy), MessagesService (copy), Trove (copy), WheelSpinServiceClient (copy), v1 (copy), v4 (ref), Spring (copy), RunService (copy), SoundService (copy), v5 (copy), TweenService (copy) ]]
	local v12 = WheelData.WheelOrder[p1]
	if v12 then
		local v2 = 360 / #WheelData.WheelOrder
		local v3 = Trove.new()
		WheelSpinServiceClient.IsSpinning = true
		local Rotation = v1.WheelSpin.Wheel.Rotation
		if v4 then
			v4:Cancel()
		end
		local function GetSegmentFromRotation() --[[ GetSegmentFromRotation | Line: 127 | Upvalues: v1 (ref), v2 (copy) ]]
			return math.floor(v1.WheelSpin.Wheel.Rotation % 360 / v2) + 1
		end
		v1.WheelSpin.Wheel.Rotation = Rotation
		local v6 = Spring.new(0, 0.3, 18)
		local v7 = v1.WheelSpin.Wheel.Rotation % 360 / v2
		local v8 = math.floor(v7) + 1
		v3:Add(RunService.PreRender:Connect(function() --[[ Line: 138 | Upvalues: v1 (ref), v2 (copy), v8 (ref), v6 (copy), SoundService (ref) ]]
			local v22 = math.floor(v1.WheelSpin.Wheel.Rotation % 360 / v2) + 1
			if v22 ~= v8 then
				v8 = v22
				v6:Impulse(30)
				if v1.Enabled then
					SoundService.Wheel.Tick:Play()
				end
			end
			v1.WheelSpin.Ticker.Rotation = v6.Position * -15
		end))
		local v9 = 1440 + (360 - (360 + Rotation) % 360) + v5:NextNumber((v12 - 1) * v2 + 10, v12 * v2 - 10)
		TweenService:Create(v1.WheelSpin.UIScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, true), {
			Scale = 1.15
		}):Play()
		task.wait(0.2)
		local v10 = TweenService:Create(v1.WheelSpin.Wheel, TweenInfo.new(5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Rotation = Rotation + v9
		})
		v10:Play()
		task.delay(4.2, function() --[[ Line: 160 | Upvalues: v1 (ref), SoundService (ref) ]]
			if v1.Enabled then
				SoundService.Wheel.Reward:Play()
			end
		end)
		v10.Completed:Wait()
		task.wait(1)
		v3:Clean()
		v1.WheelSpin.Ticker.Rotation = 0
		WheelSpinServiceClient.IsSpinning = false
		CreateWheelTween()
	else
		MessagesService:PlayMessage("Wheel Spin Error! | Reward still received!", "Error")
	end
end
function CreateWheelTween() --[[ CreateWheelTween | Line: 174 | Upvalues: v4 (ref), TweenService (copy), v1 (copy) ]]
	if v4 then
		v4:Cancel()
	end
	v4 = TweenService:Create(v1.WheelSpin.Wheel, TweenInfo.new(60, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1), {
		Rotation = v1.WheelSpin.Wheel.Rotation + 360
	})
	v4:Play()
end
function Cleanup() --[[ Cleanup | Line: 183 | Upvalues: v4 (ref), t (ref) ]]
	if v4 then
		v4:Cancel()
	end
	for i, v in ipairs(t) do
		if v.PlaybackState == Enum.PlaybackState.Playing then
			v:Cancel()
		end
	end
	t = {}
end
function t2.StartAnimating(p1) --[[ StartAnimating | Line: 196 | Upvalues: TweenService (copy), v1 (copy), t (ref), WheelSpinServiceClient (copy), v2 (copy) ]]
	local v12 = TweenService:Create(v1.WheelSpin.Sunburst, TweenInfo.new(20, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1), {
		Rotation = v1.WheelSpin.Sunburst.Rotation + 360
	})
	local v22 = t
	table.insert(v22, v12)
	v12:Play()
	if not WheelSpinServiceClient.IsSpinning then
		CreateWheelTween()
	end
	local t2 = {}
	for i, v in ipairs(v1.WheelSpin.Sparks:GetChildren()) do
		t2[v] = v.Position
		v2:Add(task.delay(i * 0.25, function() --[[ Line: 210 | Upvalues: TweenService (ref), v (copy), t (ref) ]]
			local v1 = TweenService:Create(v, TweenInfo.new(1.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
				Position = v.Position - UDim2.fromScale(0, 0.033)
			})
			table.insert(t, v1)
			v1:Play()
		end))
	end
	v2:Add(Cleanup)
	v2:Add(function() --[[ Line: 218 | Upvalues: t2 (copy) ]]
		for k, v in pairs(t2) do
			k.Position = v
		end
	end)
end
function t2.Enable(p1) --[[ Enable | Line: 225 | Upvalues: PlayerGui (copy), v2 (copy), v1 (copy) ]]
	p1:StartAnimating()
	for i, v in ipairs(PlayerGui:GetChildren()) do
		if v.Enabled then
			v.Enabled = false
			v2:Add(function() --[[ Line: 231 | Upvalues: v (copy) ]]
				v.Enabled = true
			end)
		end
	end
	v1.Enabled = true
end
function t2.Disable(p1) --[[ Disable | Line: 239 | Upvalues: v1 (copy), v2 (copy) ]]
	v1.Enabled = false
	v2:Clean()
end
return t2