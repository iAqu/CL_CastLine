-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- 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

-- https://lua.expert/
local Knit = require(game.ReplicatedStorage.Packages.Knit)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Client = ReplicatedStorage:WaitForChild("Client")
local Info = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Info")
local UI_Manager = require(Client.Controllers.UI_Manager)

require(ReplicatedStorage.Packages.Maid)
require(Info:WaitForChild("CustomEnum"))
require(Info:WaitForChild("GlobalVars"))

local v1 = Knit.CreateController({
	Name = "OpeningPopupQue"
})
local PlayerGui = game.Players.LocalPlayer.PlayerGui

PlayerGui:WaitForChild("Windows")

local t = {}
local v2 = true

function v1.OpenNextInQue(p1) --[[ OpenNextInQue | Line: 31 | Upvalues: t (ref), v2 (ref) ]]
	if #t < 1 then
		v2 = false
	else
		t[1].func()
	end
end
function v1.KnitStart(p1) --[[ KnitStart | Line: 39 | Upvalues: PlayerGui (copy), UI_Manager (copy), t (ref) ]]
	p1.DataClient.EV_FIRST_UPDATE:Connect(function() --[[ Line: 40 | Upvalues: PlayerGui (ref), p1 (copy) ]]
		while PlayerGui:FindFirstChild("LoadScreen") do
			task.wait()
		end

		p1:OpenNextInQue()
	end)
	UI_Manager.WindowClosed:Connect(function(p12, p2, p3, p4) --[[ Line: 62 | Upvalues: t (ref), p1 (copy) ]]
		if #t < 1 then
			return
		end

		if p3 then
			return
		end

		if p12 ~= t[1].window then
			return
		end

		table.remove(t, 1)
		p1:OpenNextInQue()
	end)
	UI_Manager.WindowOpened:Connect(function(p1) --[[ Line: 71 | Upvalues: t (ref) ]]
		if #t < 1 then
			return
		end

		if p1 == t[1].window then
			return
		end

		print("CANCEL ", p1)
		t = {}
	end)
end
function v1.KnitInit(p1) --[[ KnitInit | Line: 81 | Upvalues: Knit (copy) ]]
	p1.DataClient = Knit.GetController("DataClient")
end

return v1