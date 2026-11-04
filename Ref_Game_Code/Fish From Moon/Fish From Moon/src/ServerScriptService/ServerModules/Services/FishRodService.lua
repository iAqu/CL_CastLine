local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- 获取数据服务
local Knit = require(ReplicatedStorage.Packages.Knit)
local FishRodHelper = require(ReplicatedStorage.Config.FishRodHelper)
local FishRodDataDAO = require(ServerScriptService.Source.DAO.FishRodDataDAO)

local FishRodService =Knit.CreateService {
	Name = "FishRodService",
	Client = {
		ChangeBagData=Knit.CreateSignal(),
	}
}

local function unEquipWeapon(player)
	if player.Character then
		local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:UnequipTools()
		end
	end	
end

local function equipWeapon(player)
	--生成玩家武器
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		--取消装备武器
		unEquipWeapon(player)
		--装备新武器
		local fishRodData = FishRodDataDAO.GetFishRodData(player)
		local fishRodId = fishRodData["ownFishRodList"][fishRodData["usingFishRodList"][1]].name
		local tool = ReplicatedStorage.Assets.FishRod:WaitForChild(fishRodId):Clone()
		tool.Name = "Tool_"..player.Name
		tool.Parent=player.Backpack
		if tool then
			task.defer(function()
				player.Character.Humanoid:EquipTool(tool)
			end)
		end
	end	
end

--装备宠物
function FishRodService.Client:ChangeFishRod(player,fishRodId)
	return self.Server:ChangeFishRod(player,fishRodId)
end
function FishRodService:ChangeFishRod(player,fishRodId)
	local fishRodData = FishRodDataDAO.GetFishRodData(player)
	if fishRodData["ownFishRodList"][fishRodId] ~= nil then
		fishRodData["usingFishRodList"][1] = fishRodId
		FishRodDataDAO.UpdateFishRodData(player,fishRodData)
		equipWeapon(player)
		return true
	else
		print("没有这个")
	end
end
--装备最好宠物
function FishRodService.Client:EquipBestFishRod(player)
	return self.Server:EquipBestFishRod(player)
end
function FishRodService:EquipBestFishRod(player)
	local rods = {}

	local fishRodData = FishRodDataDAO.GetFishRodData(player)

	for k,v in pairs(fishRodData["ownFishRodList"]) do
		local fishRodInfo = FishRodHelper.GetFishRod(v.name)
		local fuseUp = 1
		if v["fuse"] == 2 then
			fuseUp += 3
		elseif v["fuse"] == 3 then
			fuseUp += 10
		elseif v["fuse"] == 4 then
			fuseUp += 20
		end
		local levelUp = 1
		levelUp =  1 + (v.level * 0.05)
		table.insert(rods, {
			fishRodId = k,
			power = fishRodInfo.baseMultiplier * fuseUp * levelUp
		})
	end
	table.sort(rods, function(a, b)
		return a.power > b.power
	end)
	fishRodData["usingFishRodList"][1] = rods[1].fishRodId
	FishRodDataDAO.UpdateFishRodData(player,fishRodData)
	equipWeapon(player)
	return true
end
--锁定选中宠物
function FishRodService.Client:LockSelectFishRod(player,lockArrary)
	return self.Server:LockSelectFishRod(player,lockArrary)
end
function FishRodService:LockSelectFishRod(player,lockArrary)

	local fishRodData = FishRodDataDAO.GetFishRodData(player)

	for k,v in pairs(fishRodData["ownFishRodList"]) do
		v.lock = false
	end
	for k,v in ipairs(lockArrary) do
		fishRodData["ownFishRodList"][tostring(v)].lock = true
	end
	FishRodDataDAO.UpdateFishRodData(player,fishRodData)
	return true
end
--删除全部选中宠物
function FishRodService.Client:DeleteSelectFishRod(player,deleteArrary)
	return self.Server:DeleteSelectFishRod(player,deleteArrary)
end
function FishRodService:DeleteSelectFishRod(player,deleteArrary)
	local fishRodData = FishRodDataDAO.GetFishRodData(player)
	for k,v in ipairs(deleteArrary) do
		fishRodData["ownFishRodList"][tostring(v)]=nil
		if table.find(fishRodData["usingFishRodList"],v) then
			table.remove(fishRodData["usingFishRodList"],table.find(fishRodData["usingFishRodList"],v))
		end
	end
	FishRodDataDAO.UpdateFishRodData(player,fishRodData)
	return true
end

---增加背包数量
function FishRodService:BuyBagStorage(player,addNum)
	local fishRodData = FishRodDataDAO.GetFishRodData(player)
	fishRodData.fishRodbag = fishRodData.fishRodbag + addNum
	FishRodDataDAO.UpdateFishRodData(player,fishRodData)
	FishRodService:ChangeBagData(player)
end

---购买背包容量
function FishRodService.Client:BuyBagStorage(player,addNum)
	FishRodService:BuyBagStorage(player,addNum)
end

local function onPlayerAdded(player)
	player.CharacterAdded:Connect(function(character)
		equipWeapon(player)
	end)
end

--修改背包数据
function FishRodService:ChangeBagData(player)
	self.Client.ChangeBagData:Fire(player)
end

--获取玩家资源数据
function FishRodService:GetFishRodData(player)
	local fishRodData = FishRodDataDAO.GetFishRodData(player)
	return fishRodData
end

--获取玩家资源数据
function FishRodService.Client:GetFishRodData(player)
	local fishRodData = FishRodDataDAO.GetFishRodData(player)
	return fishRodData
end

--更新玩家资源数据
function FishRodService:UpdateFishRodData(player,fishRodData)
	FishRodDataDAO.UpdateFishRodData(player,fishRodData)
end

function FishRodService:KnitInit()
end

function FishRodService:KnitStart()
	Players.PlayerAdded:Connect(onPlayerAdded)
end

return FishRodService