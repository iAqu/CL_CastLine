-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TimerService = require(ReplicatedStorage.Modules.ServicesLoader.TimerService)
local ServerLuckClient = require(ReplicatedStorage.Modules.ServicesLoader.ServerLuckClient)
local HUD = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("HUD")
local ServerLuck = HUD.BottomLeft.ServerLuck
local GlobalLuck = HUD.BottomLeft.GlobalLuck
local v1 = nil
local v2 = nil
local t = {}
function loadServerLuck(p1, p2) --[[ loadServerLuck | Line: 24 | Upvalues: ServerLuck (copy), v1 (ref), TimerService (copy) ]]
	if p2 then
		ServerLuck.Visible = true
		if v1 then
			v1:ChangeFormat((("Server Luck: x%* | %%s"):format(p1)))
			v1:UpdateEndTime(p2)
		else
			v1 = TimerService.AddTimer(ServerLuck.TimerLabel, p2, ("Server Luck: x%* | %%s"):format(p1), function() --[[ Line: 36 | Upvalues: ServerLuck (ref), v1 (ref) ]]
				ServerLuck.Visible = false
				v1 = nil
			end)
		end
	else
		ServerLuck.Visible = false
	end
end
function loadlGlobalLuck(p1, p2) --[[ loadlGlobalLuck | Line: 44 | Upvalues: GlobalLuck (copy), v2 (ref), TimerService (copy) ]]
	if p2 then
		GlobalLuck.Visible = true
		if v2 then
			v2:ChangeFormat((("Global Luck: x%* | %%s"):format(p1)))
			v2:UpdateEndTime(p2)
		else
			v2 = TimerService.AddTimer(GlobalLuck.TimerLabel, p2, ("Global Luck: x%* | %%s"):format(p1), function() --[[ Line: 56 | Upvalues: GlobalLuck (ref), v2 (ref) ]]
				GlobalLuck.Visible = false
				v2 = nil
			end)
		end
	else
		GlobalLuck.Visible = false
	end
end
function OnTimersUpdate(p1, p2, p3, p4) --[[ OnTimersUpdate | Line: 64 ]]
	loadServerLuck(p1, p2)
	loadlGlobalLuck(p3, p4)
end
function t._init() --[[ _init | Line: 70 | Upvalues: ServerLuckClient (copy) ]]
	OnTimersUpdate(ServerLuckClient.Luck, ServerLuckClient.EndTime, ServerLuckClient.GlobalLuck, ServerLuckClient.GlobalEndTime)
	ServerLuckClient.Changed:Connect(OnTimersUpdate)
end
return t