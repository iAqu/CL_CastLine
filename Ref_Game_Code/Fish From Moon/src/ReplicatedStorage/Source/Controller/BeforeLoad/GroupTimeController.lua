local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local Knit = require(ReplicatedStorage.Packages.Knit)

local TimeFormat = require(ReplicatedStorage.Source.Utils.TimeFormat)
--加载UI处理
local FrameTrigger

local PlayerService
local JoinGroupService

local BillboardGui=game.Workspace.Lobby.LuckArea.CheckArea:WaitForChild("JoinTouchPart").JoinTouchPart.BillboardGui
local timeCd=BillboardGui.Frame.Time

local CD

local GroupTimeController = Knit.CreateController { Name = "GroupTimeController" }

function GroupTimeController:InitjoinGroupTime()
	local function getData(data)
		local isJoinGroup = data.joinGroup
		local Time = data.joinGroupTime

		if isJoinGroup then
			---领过宠物了，刷新时间领取奖励
			timeCd.Visible=true
			if game.Workspace:GetServerTimeNow() - Time < 24*60*60 then
				CD =  Time + 24*60*60 - game.Workspace:GetServerTimeNow()
			else
				timeCd.Text = "Claim!"
			end
		else
			----没有领取，打开界面
			timeCd.Visible=false
		end 
	end
	PlayerService:GetPlayerData(player):andThen(getData)
end

function GroupTimeController:KnitInit()

	PlayerService = Knit.GetService("PlayerService")
	JoinGroupService = Knit.GetService("JoinGroupService")
	
	FrameTrigger=require(player.PlayerGui:WaitForChild("MainMenu",5).FrameTrigger)
end

function GroupTimeController:KnitStart()
	self.InitjoinGroupTime()
	task.spawn(function()			  
		while true do
			wait(1)
			if CD then
				if CD > 0 then
					CD = CD - 1
					timeCd.Text = "(" .. TimeFormat.HHMMSS(CD) .. ")"
					if CD <= 0 then
						timeCd.Text = "Claim!"
					end
				else
					timeCd.Text = "Claim!"
				end
			end
		end
	end)
	JoinGroupService.ChangeGroupTime:Connect(self.InitjoinGroupTime)
end

return GroupTimeController
