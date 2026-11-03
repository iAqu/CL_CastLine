-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("Players")
game:GetService("RunService")
game:GetService("TextChatService")
require(ReplicatedStorage.Packages.Net)
local Replion = require(ReplicatedStorage.Packages.Replion)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Trove = require(ReplicatedStorage.Packages.Trove)
local spr = require(ReplicatedStorage.Packages.spr)
local FormatUtil = require(ReplicatedStorage.Modules.Util.FormatUtil)
local function GetCurrentTimestamp() --[[ GetCurrentTimestamp | Line: 24 ]]
	local v1 = os.time() + -18000
	local sum = v1 - v1 % 14400 + 3600
	if v1 < sum then
		sum = sum - 14400
	end
	return sum - -18000
end
local function GetNextTimestamp() --[[ GetNextTimestamp | Line: 35 ]]
	local v1 = os.time() + -18000
	local sum = v1 - v1 % 14400 + 3600
	if v1 < sum then
		sum = sum - 14400
	end
	return sum - -18000 + 14400
end
local function IsEventActive() --[[ IsEventActive | Line: 39 ]]
	local v1 = os.time() + -18000
	local sum = v1 - v1 % 14400 + 3600
	if v1 < sum then
		sum = sum - 14400
	end
	local v2 = os.time() - (sum - -18000)
	if v2 < 3600 then
		return true, 3600 - v2, v2 / 3600
	else
		local v3 = v2 - 3600
		return false, 10800 - v3, v3 / 10800
	end
end
Replion.Client:AwaitReplion("Data", function(p1) --[[ Line: 58 | Upvalues: ReplicatedStorage (copy), Observers (copy), Trove (copy), FormatUtil (copy), spr (copy) ]]
	require(ReplicatedStorage.Controllers.TextNotificationController)
	require(ReplicatedStorage.Shared.Soundbook)
	Observers.observeTag("EasterEventBoard", function(p1) --[[ Line: 66 | Upvalues: Trove (ref), FormatUtil (ref), spr (ref) ]]
		local v1 = Trove.new()
		local Gui = p1:WaitForChild("Gui", 30)
		if not Gui then
			return
		end
		local Frame = Gui:WaitForChild("Frame", 30)
		if not Frame then
			return
		end
		local NewLabel = Frame:WaitForChild("NewLabel", 30)
		if not NewLabel then
			return
		end
		local StatusLabel = Frame:WaitForChild("StatusLabel", 30)
		if not StatusLabel then
			return
		end
		local v2 = p1.Parent
		if not v2 then
			return
		end
		local Arrow = v2:WaitForChild("Arrow")
		if not Arrow:GetAttribute("OriginCF") then
			Arrow:SetAttribute("OriginCF", Arrow:GetPivot())
		end
		local v3 = Arrow:GetPivot()
		v1:Add(task.spawn(function() --[[ Line: 103 | Upvalues: StatusLabel (copy), NewLabel (copy), FormatUtil (ref), spr (ref), Arrow (copy), v3 (copy) ]]
			while true do
				local v1, v2, v32
				local v4 = os.time() + -18000
				local sum = v4 - v4 % 14400 + 3600
				if v4 < sum then
					sum = sum - 14400
				end
				local v5 = os.time() - (sum - -18000)
				if v5 < 3600 then
					v1 = true
					v2 = 3600 - v5
					v32 = v5 / 3600
				else
					local v6 = v5 - 3600
					v1 = false
					v2 = 10800 - v6
					v32 = v6 / 10800
				end
				StatusLabel.Text = if v1 then "Event Ends In:" else "Next Event In:"
				NewLabel.Text = FormatUtil.toHMS(v2, true)
				spr.stop(Arrow)
				spr.target(Arrow, 0.5, 10, {
					Pivot = v3 * CFrame.Angles(0, 0, (math.rad(90 - v32 * 180)))
				})
				task.wait(1)
			end
		end))
		return function() --[[ Line: 123 | Upvalues: v1 (ref) ]]
			if not v1 then
				return
			end
			v1:Destroy()
			v1 = nil
		end
	end)
end)
return {}