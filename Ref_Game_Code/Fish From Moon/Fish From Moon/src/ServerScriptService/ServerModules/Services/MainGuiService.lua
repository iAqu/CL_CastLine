local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Tool=require(ReplicatedStorage.Source.Utils.Tool)

local PlayerResourceService

local MainGuiService =Knit.CreateService {
	Name = "MainGuiService",
	Client = {
		InitMainGui = Knit.CreateSignal(),
		----改变金币
		ChangeMoneys = Knit.CreateSignal(),
		ChangeGems = Knit.CreateSignal(),

		ShowMoneysEffect = Knit.CreateSignal(),
		ShowGemsEffect = Knit.CreateSignal(),
		ShowMessageEffect = Knit.CreateSignal(),

		ShowMessage = Knit.CreateSignal(),
		
		ScreenSwitching = Knit.CreateSignal(),
	}
}
--改变金币数据
function MainGuiService:ChangeMoneys(player,moneys)
	self.Client.ChangeMoneys:Fire(player,moneys)
end
--改变金币数据
function MainGuiService:ChangeGems(player,gems)
	self.Client.ChangeGems:Fire(player,gems)
end

--展示获得Coins效果
function MainGuiService:ShowMoneysEffect(player,coinType,moneys)
	self.Client.ShowMoneysEffect:Fire(player,coinType,moneys)
end
--展示获得Coins效果
function MainGuiService:ShowGemsEffect(player,gems)
	self.Client.ShowGemsEffect:Fire(player,gems)
end

--展示UI上方
function MainGuiService:ShowMessageEffect(player,meaasgeType,txtNum,txt,img)
	self.Client.ShowMessageEffect:Fire(player,meaasgeType,txtNum,txt,img)
end

--展示消息效果
function MainGuiService:ShowMessage(player,message,defColor)
	self.Client.ShowMessage:Fire(player,message,defColor)
end
--画面过度
function MainGuiService:ScreenSwitching(player,tweenTime)
	self.Client.ScreenSwitching:Fire(player, tweenTime)
end

function MainGuiService:InitMainGui(player)
	local initData = {}

	local BadgeId = 875286385491078
	Tool.AwardBadge(player,BadgeId)
	
	local playerResourceData = PlayerResourceService:GetPlayerResourceData(player)

	initData.playerResource = playerResourceData
	self.Client.InitMainGui:Fire(player,initData)
end

--初始化
local function onCharacterAdded(character)
	MainGuiService:InitMainGui(Players:GetPlayerFromCharacter(character))
end

local function onPlayerAdded(player)
	player.CharacterAdded:Connect(onCharacterAdded)
end

function MainGuiService:KnitInit()
	PlayerResourceService = Knit.GetService("PlayerResourceService")
end

function MainGuiService:KnitStart()
	Players.PlayerAdded:Connect(onPlayerAdded)
end

return MainGuiService
