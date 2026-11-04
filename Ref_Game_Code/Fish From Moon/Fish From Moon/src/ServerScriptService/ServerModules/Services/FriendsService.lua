local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local FriendsDAO = require(ServerScriptService.Source.DAO.FriendsDAO)

local MainGuiService
local PlayerBoostService
local PlayerResourceService

local Knit = require(ReplicatedStorage.Packages.Knit)

local FriendsService =Knit.CreateService {
	Name = "FriendsService",
	Client = {
		ChangeFriendBonus = Knit.CreateSignal(),
		ChangeMenuData = Knit.CreateSignal(),
	}
}

--修改数据
function FriendsService:ChangeMenuData(player)
	self.Client.ChangeMenuData:Fire(player)
end

local function PlayerAdded(player)
	local friendsData = FriendsDAO.GetFriendsData(player)
	for index, anyPlayer in ipairs(Players:GetPlayers()) do
		if tonumber(player.UserId)  == tonumber(anyPlayer.UserId) then
			continue
		end
		if player and player:IsFriendsWith(anyPlayer.UserId) then
			if table.find(friendsData.friendList,anyPlayer.UserId) then
			else
				table.insert(friendsData.friendList,anyPlayer.UserId)
				FriendsDAO.UpdateFriendsData(player,friendsData)
			end
		end
	end
	FriendsService:ChangeFriendBonus()
end

--领取奖励
function FriendsService.Client:GetRewards(player,rewardId)
	local function Rewards(rewardId)
		if rewardId == 1 then
			PlayerResourceService:ChangeGems(player,2000)
			local message = "Friend : You get Reward!"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId==3 then
			PlayerResourceService:ChangeGems(player,4000)
			local message = "Friend : You get Reward!"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId==5 then
			PlayerResourceService:ChangeGems(player,10000)
			PlayerBoostService:AddPlayerBoostUseCount(player,"LuckPotion",2)
			local message = "Friend : You get Reward!"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId==10 then
			PlayerResourceService:ChangeGems(player,20000)
			PlayerBoostService:AddPlayerBoostUseCount(player,"LuckPotion",2)
			PlayerBoostService:AddPlayerBoostUseCount(player,"MoneyPotion",2)
			local message = "Friend : You get Reward!"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId==20 then
			PlayerResourceService:ChangeGems(player,40000)
			PlayerBoostService:AddPlayerBoostUseCount(player,"LuckPotion",3)
			PlayerBoostService:AddPlayerBoostUseCount(player,"MoneyPotion",4)
			local message = "Friend : You get Reward!"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId==40 then
			PlayerResourceService:ChangeGems(player,80000)
			PlayerBoostService:AddPlayerBoostUseCount(player,"LuckPotion",3)
			PlayerBoostService:AddPlayerBoostUseCount(player,"MoneyPotion",5)
			local message = "Friend : You get Reward!"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId==60 then
			PlayerResourceService:ChangeGems(player,120000)
			PlayerBoostService:AddPlayerBoostUseCount(player,"LuckPotion",6)
			PlayerBoostService:AddPlayerBoostUseCount(player,"MoneyPotion",7)
			local message = "Friend : You get Reward!"
			MainGuiService:ShowMessage(player,message)
		elseif rewardId==100 then
			PlayerResourceService:ChangeGems(player,300000)
			PlayerBoostService:AddPlayerBoostUseCount(player,"LuckPotion",10)
			PlayerBoostService:AddPlayerBoostUseCount(player,"MoneyPotion",12)
			local message = "Friend : You get Reward!"
			MainGuiService:ShowMessage(player,message)
		end
	end
	local friendsData = FriendsService:GetFriendsData(player)
	if table.find(friendsData.getRewardList,rewardId) then
		--TODO 提示已经领取信息
		MainGuiService:ShowMessage(player,"The reward has already been claimed")
	else
		--给与玩家奖励
		Rewards(rewardId)
		table.insert(friendsData.getRewardList,rewardId)
		FriendsService:UpdateFriendsData(player,friendsData)
	end
	FriendsService:ChangeMenuData(player)
end

--检测玩家好友变化
function FriendsService:ChangeFriendBonus()
	for i,player in pairs(Players:GetPlayers()) do
		self.Client.ChangeFriendBonus:Fire(player)	
	end
end

--获取玩家数据
function FriendsService:GetFriendsData(player)
	local friendsData = FriendsDAO.GetFriendsData(player)
	return friendsData
end

--获取玩家数据 客户端
function FriendsService.Client:GetFriendsData(player)
	local friendsData = FriendsDAO.GetFriendsData(player)
	return friendsData
end

--更新玩家数据
function FriendsService:UpdateFriendsData(player,friendsData)
	FriendsDAO.UpdateFriendsData(player,friendsData)
end

function FriendsService:KnitInit()
	PlayerResourceService = Knit.GetService("PlayerResourceService")
	PlayerBoostService = Knit.GetService("PlayerBoostService")
	MainGuiService = Knit.GetService("MainGuiService")
end

function FriendsService:KnitStart()
	Players.PlayerAdded:Connect(function(player)
		PlayerAdded(player)
	end)
end

return FriendsService
