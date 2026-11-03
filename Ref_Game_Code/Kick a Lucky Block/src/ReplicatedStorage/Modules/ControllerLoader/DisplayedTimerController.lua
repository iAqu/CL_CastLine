-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TimerService = require(ReplicatedStorage.Modules.ServicesLoader.TimerService)
local PlayerGui = game:GetService("Players").LocalPlayer.PlayerGui
local TimersGui = script:WaitForChild("TimersGui")
local InfoFrame = TimersGui.InfoFrame
local TimedUpgrades = TimersGui.TimedUpgrades
local UpgradeFrame = TimedUpgrades.UpgradeFrame
local t = {
	Timers = {}
}
local v1 = nil
function UpdateFrame(p1) --[[ UpdateFrame | Line: 40 | Upvalues: t (copy), TimerService (copy) ]]
	local v1 = t.Timers[p1.Name]
	if v1 then
		if p1.EndTime then
			if v1.Timer then
				v1.Timer:UpdateEndTime(p1.EndTime)
			else
				v1.Frame.TimeLabel.Visible = true
				v1.Timer = TimerService.AddTimer(v1.Frame.TimeLabel, p1.EndTime, nil, function() --[[ Line: 52 | Upvalues: t (ref), p1 (copy) ]]
					t:RemoveTimer(p1.Name)
				end)
			end
		elseif v1.Timer then
			v1.Frame.TimeLabel.Visible = false
			v1.Timer:Destroy(true)
		end
		v1.Info = p1.Description
	else
		CreateFrame(p1)
	end
end
function SetupInfo(p1, p2) --[[ SetupInfo | Line: 66 | Upvalues: v1 (ref), InfoFrame (copy) ]]
	v1 = p1
	InfoFrame.NameLabel.Text = p1
	InfoFrame.InfoLabel.Text = p2
end
function CreateFrame(p1) --[[ CreateFrame | Line: 72 | Upvalues: UpgradeFrame (copy), TimerService (copy), t (copy), InfoFrame (copy), TimedUpgrades (copy) ]]
	local v1 = UpgradeFrame:Clone()
	local Icon = v1:WaitForChild("Icon")
	local TimeLabel = v1:WaitForChild("TimeLabel")
	v1.Name = p1.Name
	v1.Visible = true
	Icon.Image = p1.ImageId or ""
	local v2 = nil
	if p1.EndTime then
		v2 = TimerService.AddTimer(TimeLabel, p1.EndTime, nil, function() --[[ Line: 87 | Upvalues: t (ref), p1 (copy) ]]
			t:RemoveTimer(p1.Name)
		end)
	else
		TimeLabel.Visible = false
	end
	t.Timers[p1.Name] = {
		Timer = v2,
		Frame = v1,
		Info = p1.Description
	}
	local t2 = {
		[Enum.UserInputType.MouseMovement] = true,
		[Enum.UserInputType.Touch] = true
	}
	v1.InputBegan:Connect(function(p12) --[[ Line: 109 | Upvalues: t2 (copy), p1 (copy), t (ref), InfoFrame (ref) ]]
		if t2[p12.UserInputType] then
			SetupInfo(p1.Name, t.Timers[p1.Name].Info)
			InfoFrame.Visible = true
		end
	end)
	v1.InputEnded:Connect(function(p1) --[[ Line: 120 | Upvalues: t2 (copy), InfoFrame (ref) ]]
		if t2[p1.UserInputType] then
			InfoFrame.Visible = false
		end
	end)
	local Size = v1.Size
	v1.Size = UDim2.fromScale(0, 0)
	v1.Parent = TimedUpgrades
	v1:TweenSize(Size, Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.66, true)
end
function InitializeGui() --[[ InitializeGui | Line: 137 | Upvalues: TimersGui (copy), PlayerGui (copy) ]]
	TimersGui.Parent = PlayerGui
end
function t.AddTimer(p1, p2) --[[ AddTimer | Line: 143 | Upvalues: t (copy) ]]
	if t.Timers[p2.Name] then
		UpdateFrame(p2)
	else
		CreateFrame(p2)
	end
end
function t.RemoveTimer(p1, p2) --[[ RemoveTimer | Line: 151 | Upvalues: t (copy), v1 (ref), InfoFrame (copy) ]]
	local v12 = t.Timers[p2]
	if v12 then
		if v12.Timer then
			v12.Timer:Destroy(true)
		end
		v12.Frame:TweenSize(UDim2.fromScale(0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 0.5, true, function() --[[ Line: 161 | Upvalues: v12 (copy), v1 (ref), p2 (copy), InfoFrame (ref) ]]
			v12.Frame:Destroy()
			if v1 == p2 then
				InfoFrame.Visible = false
			end
		end)
		t.Timers[p2] = nil
	end
end
function t._init(p1) --[[ _init | Line: 174 ]]
	InitializeGui()
end
return t