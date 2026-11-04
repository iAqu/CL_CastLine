--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

--获取模组
local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerBoostDataDAO = require(ServerScriptService.Source.DAO.PlayerBoostDataDAO)

local StoreGuiService

local PlayerBoostService =Knit.CreateService{
	Name = "PlayerBoostService",
	Client = {
		ChangeBoostData = Knit.CreateSignal(),
	}
}

--缓存玩家PlayerBoostData数据
local PlayerBoostData

---效果剩余时间
function PlayerBoostService:GetPlayerBoostLessTime(player, boostname)
	local Boost = PlayerBoostDataDAO.GetPlayerBoostData(player)
	if Boost[boostname] then
		if (Boost[boostname] - os.time()) < 0 then
			return 0
		else
			return Boost[boostname] - os.time()
		end
	else
		return 0
	end
end

---判断是否有效果，时间是不是到了
function PlayerBoostService:IsPlayerHaveBoost(player, boostname)
	local Boost = PlayerBoostDataDAO.GetPlayerBoostData(player)
	if Boost[boostname] then
		if (Boost[boostname] - os.time()) < 0 then
			return false
		else
			return true
		end
	else
		return false
	end
end

---加时
function PlayerBoostService:GivePlayerBoostTime(player, boostname, addtime)
	local Boost = PlayerBoostDataDAO.GetPlayerBoostData(player)
	if Boost[boostname] then
		if (os.time() - Boost[boostname]) > 0 then
			Boost[boostname] = os.time() + addtime
		else
			Boost[boostname] = Boost[boostname] + addtime
		end
	else
		Boost[boostname] = os.time() + addtime
	end
	PlayerBoostDataDAO.UpdatePlayerBoostData(player, Boost)
end

----效果去掉
function PlayerBoostService:RemovePlayerBoost(player, boostname, addtime)
	local Boost = PlayerBoostDataDAO.GetPlayerBoostData(player)
	if Boost[boostname] then
		Boost[boostname] = nil
	end
	PlayerBoostDataDAO.UpdatePlayerBoostData(player, Boost)
end

----获取玩家PlayerBoost数据
function PlayerBoostService.Client:GetPlayerBoostData(player)
	return PlayerBoostDataDAO.GetPlayerBoostData(player)
end
--改变Boost数据
function PlayerBoostService:ChangeBoostData(player)
	self.Client.ChangeBoostData:Fire(player)
end

----增加Boost使用次数
function PlayerBoostService:AddPlayerBoostUseCount(player, boostname, count)
	local Boost = PlayerBoostDataDAO.GetPlayerBoostData(player)
	local useCount = Boost.useCount
	if useCount[boostname] then
		useCount[boostname] = useCount[boostname] + count
	else
		useCount[boostname] = count
	end
	PlayerBoostDataDAO.UpdatePlayerBoostData(player, Boost)
	--更新商店BoostUI数据
	StoreGuiService:ChangeBoostData(player)
	--更新药水背包BoostUI数据
	PlayerBoostService:ChangeBoostData(player)
end

--使用Boost使用次数
function PlayerBoostService.Client:UsePlayerBoostData(player, boostname)
	local Boost = PlayerBoostDataDAO.GetPlayerBoostData(player)
	local useCount = Boost.useCount
	--校验玩家boost数量
	if useCount[boostname] >= 1 then
		useCount[boostname] = useCount[boostname] - 1
		Boost.useCount = useCount
	else
		print("玩家boost数量不足，使用失败")
		return
	end
	PlayerBoostDataDAO.UpdatePlayerBoostData(player, Boost)
	--添加Boost
	if boostname == "LuckPotion" then
		PlayerBoostService:GivePlayerBoostTime(player,"LuckPotion",15*60)
	elseif boostname == "SuperLuckPotion" then
		PlayerBoostService:GivePlayerBoostTime(player,"SuperLuckPotion",15*60)
	elseif boostname == "MoneyPotion" then
		PlayerBoostService:GivePlayerBoostTime(player,"MoneyPotion",15*60)
	end
	--更新商店BoostUI数据
	StoreGuiService:ChangeBoostData(player)
	--更新药水背包BoostUI数据
	PlayerBoostService:ChangeBoostData(player)
end

function PlayerBoostService:KnitInit()
	StoreGuiService = Knit.GetService("StoreGuiService")
end

function PlayerBoostService:KnitStart()

end

return PlayerBoostService