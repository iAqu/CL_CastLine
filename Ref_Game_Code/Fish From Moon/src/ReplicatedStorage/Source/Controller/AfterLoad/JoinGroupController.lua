local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

local Knit = require(ReplicatedStorage.Packages.Knit)
local Promise = require(Knit.Util.Promise) 
local FrameTrigger=require(player.PlayerGui:WaitForChild("MainMenu",5).FrameTrigger)

local PlayerService
local JoinGroupService

local MainGuiController

---GUI
local JoinGroupMenu=player.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.JoinGroupMenu

local BtnClose=JoinGroupMenu.Menu.Exit.TextButton

local BtnGet=JoinGroupMenu.Menu.Container.Right.Bottom.TextButton

local frameName="JoinGroupMenu"

local JoinGroupController = Knit.CreateController { Name = "JoinGroupController" }

local function isPlayerInGroup(player, groupId)
	return Promise.new(function(resolve)
		resolve(player:IsInGroup(groupId))
	end)
end

--打开加入群组默认界面
function JoinGroupController:OpenJoinGroupDedault()

	local function getData(data)
		local isJoinGroup = data.joinGroup

		if isJoinGroup then
			---领过宠物了，刷新时间领取奖励
			JoinGroupService:JoinGameGroupTime():andThen(function(result)
				if result then
					MainGuiController:ShowMessage("You get Gems!")
				else
					MainGuiController:ShowMessage("Time is insufficient!")
				end
			end)
		else
			----没有领取，打开界面
			FrameTrigger.OpenFram(frameName)
			
			isPlayerInGroup(player,35434419):andThen(function(result)
				if result then
					JoinGroupMenu.Menu.Container.Right.mid.count2.Completed.Visible=true
					JoinGroupMenu.Menu.Container.Right.mid.count2.notComplete.Visible=false
				else
					JoinGroupMenu.Menu.Container.Right.mid.count2.Completed.Visible=false
					JoinGroupMenu.Menu.Container.Right.mid.count2.notComplete.Visible=true
				end
			end)
		end 
	end
	PlayerService:GetPlayerData(player):andThen(getData)
end


local function ClickJoinFGropBtn()
	isPlayerInGroup(player,35434419):andThen(function(result)
		if result then
			JoinGroupService:JoinGameGroup():andThen(function(result)
				if result then
					game.Workspace.Lobby.LuckArea.CheckArea:WaitForChild("JoinTouchPart").JoinTouchPart.BillboardGui.Frame.Time.Visible=true
				end
				FrameTrigger.CloseFram(frameName)
				
				MainGuiController:ShowMessage("You get this reward!!!")
			end)
		else
			--TODO 提示玩家需要先加入群组
			MainGuiController:ShowMessage("Like the game and Join the group to get this reward!!!")
		end	 
	end)
end

function JoinGroupController:KnitInit()
	MainGuiController =Knit.GetController("MainGuiController")
	
	PlayerService = Knit.GetService("PlayerService")
	JoinGroupService = Knit.GetService("JoinGroupService")
end

function JoinGroupController:KnitStart()
	BtnClose.MouseButton1Click:Connect(function()
		FrameTrigger.CloseFram(frameName)
		
	end)
	BtnGet.MouseButton1Click:Connect(function()
		ClickJoinFGropBtn()
	end)
end

return JoinGroupController
