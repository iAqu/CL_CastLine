-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Trove = require(ReplicatedStorage.Shared.Packages.Trove)
local HackedBar = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HackedBar")
local Bar = HackedBar:WaitForChild("Bar")
local Fill = Bar:WaitForChild("Fill")
local TextLabel = Bar:WaitForChild("TextLabel")
local Percent = Bar:WaitForChild("Percent")
local t = {}
local v1 = nil
local v2 = 0
local v3 = 0
local v4 = false
function updatePercentLabel(p1) --[[ updatePercentLabel | Line: 30 | Upvalues: Percent (copy) ]]
	local format = string.format
	Percent.Text = format("%d%%", (math.clamp(math.floor(p1), 0, 100)))
end
function startDotCycle(p1) --[[ startDotCycle | Line: 34 | Upvalues: v1 (ref), RunService (copy), v4 (ref), TextLabel (copy) ]]
	if p1 then
		local v12 = 1
		local v2 = 0
		v1:Connect(RunService.Heartbeat, function(p12) --[[ Line: 45 | Upvalues: v4 (ref), v2 (ref), v12 (ref), TextLabel (ref), p1 (copy) ]]
			if not v4 then
				v2 = v2 + p12
				if v2 >= 0.35 then
					v2 = 0
					v12 = math.max(v12 % 3 + 1, 1)
					local v22 = ""
					for i = 1, v12 do
						v22 = v22 .. "."
					end
					TextLabel.Text = p1 .. v22
				end
			end
		end)
	else
		warn("Missing BaseText param")
	end
end
function startGlitchRainbow() --[[ startGlitchRainbow | Line: 60 | Upvalues: v1 (ref), RunService (copy), Fill (copy) ]]
	local v12 = Color3.fromRGB(0, 0, 0)
	local v2 = Color3.fromRGB(0, 255, 65)
	local v3 = os.clock()
	v1:Connect(RunService.Heartbeat, function() --[[ Line: 65 | Upvalues: v3 (copy), Fill (ref), v12 (copy), v2 (copy) ]]
		Fill.BackgroundColor3 = v12:Lerp(v2, (math.sin((os.clock() - v3) * 6) + 1) / 2)
	end)
end
function t.Show(p1, p2, p3) --[[ Show | Line: 73 | Upvalues: v1 (ref), Trove (copy), v4 (ref), v2 (ref), v3 (ref), Fill (copy), TextLabel (copy), HackedBar (copy), Bar (copy) ]]
	if v1 then
		v1:Clean()
	end
	v1 = Trove.new()
	v4 = false
	v2 = 0
	v3 = 0
	Fill.Size = UDim2.fromScale(0, 1)
	TextLabel.Text = p2
	updatePercentLabel(0)
	HackedBar.Enabled = true
	Bar.Visible = true
	if p3 then
		startDotCycle(p2)
	end
end
function t.SetTarget(p1, p2, p3) --[[ SetTarget | Line: 95 | Upvalues: v4 (ref), v3 (ref), v1 (ref), TweenService (copy), Fill (copy), v2 (ref), RunService (copy) ]]
	if not v4 then
		v3 = math.clamp(p2, 0, 100)
		local v12 = if p2 == 100 then true else false
		v1:Add(TweenService:Create(Fill, TweenInfo.new(p3, Enum.EasingStyle.Linear), {
			Size = UDim2.fromScale(v3 / 100, 1)
		})):Play()
		local v22 = v2
		local v32 = os.clock()
		v1:Connect(RunService.Heartbeat, function() --[[ Line: 110 | Upvalues: v32 (copy), p3 (copy), v22 (copy), v3 (ref), v2 (ref), v12 (copy), p1 (copy) ]]
			local v23 = math.clamp((os.clock() - v32) / p3, 0, 1)
			local v33 = v22 + (v3 - v22) * v23
			v2 = v33
			updatePercentLabel(v33)
			if v23 >= 1 then
				v2 = v3
				if v12 then
					p1:Complete()
					return
				end
				p1:Fail(v3)
			end
		end)
	end
end
function t.Fail(p1, p2) --[[ Fail | Line: 127 | Upvalues: v4 (ref), v1 (ref), Trove (copy), v2 (ref), Fill (copy), TextLabel (copy), SoundService (copy) ]]
	if not v4 then
		v4 = true
		if v1 then
			v1:Clean()
		end
		v1 = Trove.new()
		v2 = p2
		Fill.Size = UDim2.fromScale(p2 / 100, 1)
		Fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		updatePercentLabel(p2)
		TextLabel.Text = "Failed"
		SoundService.Effects.HackFail:Play()
	end
end
function t.Complete(p1) --[[ Complete | Line: 142 | Upvalues: v4 (ref), v1 (ref), Trove (copy), v2 (ref), Fill (copy), TextLabel (copy) ]]
	if not v4 then
		v4 = true
		v1:Clean()
		v1 = Trove.new()
		v2 = 100
		Fill.Size = UDim2.fromScale(1, 1)
		updatePercentLabel(100)
		TextLabel.Text = "Successful"
		startGlitchRainbow()
	end
end
function t.Hide(p1) --[[ Hide | Line: 158 | Upvalues: v1 (ref), v4 (ref), v2 (ref), v3 (ref), HackedBar (copy), Bar (copy), Fill (copy), TextLabel (copy), Percent (copy) ]]
	if v1 then
		v1:Clean()
		v1 = nil
	end
	v4 = false
	v2 = 0
	v3 = 0
	HackedBar.Enabled = false
	Bar.Visible = false
	Fill.Size = UDim2.fromScale(0, 1)
	Fill.BackgroundColor3 = Color3.fromRGB(7, 255, 15)
	TextLabel.Text = ""
	Percent.Text = ""
end
return t