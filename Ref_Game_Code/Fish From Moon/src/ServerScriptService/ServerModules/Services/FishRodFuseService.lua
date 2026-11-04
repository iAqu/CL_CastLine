--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
--获取模组
local Knit = require(ReplicatedStorage.Packages.Knit)
local FishRodDataDAO = require(ServerScriptService.Source.DAO.FishRodDataDAO)

local PlayerResourceService

local FishRodFuseService = Knit.CreateService {
	Name = "FishRodFuseService",
	Client = {},
}
----合成成功率
local function GetRandom(successGaiLv)

	local randomNum=math.random(0,100)
	print("randomNum:")
	print(randomNum)
	if randomNum>=0 and randomNum<=successGaiLv then
		return true
	else
		return false
	end
end

---切割
local function Sub1StringSplit(strings)
	local values = strings:split("%")
	return values
end

---点击合成
function FishRodFuseService.Client:ClickFuse(player,selectArray,successGaiLv) 
	return self.Server:ClickFuse(player,selectArray,successGaiLv)
end
function FishRodFuseService:ClickFuse(player,selectArray,successGaiLv)
	local pet={}

	local fishRodData = FishRodDataDAO.GetFishRodData(player)
	if #(selectArray)==0 then
		return false,"Please select the Rod you want to synthesize !"
	end
	if #(selectArray)==1 then
		return false,"Please select at least two Rods to combine !"
	end
	local playerResourceData = PlayerResourceService:GetPlayerResourceData(player)
	if fishRodData.ownFishRodList[tostring(selectArray[1])].fuse == 1 then
		if playerResourceData.gems < 500 then
			return false,"Diamonds are insufficient"
		end
		PlayerResourceService:ChangeGems(player,(-500))
	elseif fishRodData.ownFishRodList[tostring(selectArray[1])].fuse ==2 then	
		if playerResourceData.gems < 2000 then
			return false,"Diamonds are insufficient"
		end
		PlayerResourceService:ChangeGems(player,(-2000))
	end
	---删除合成选择
	if fishRodData then
		pet = fishRodData.ownFishRodList[tostring(selectArray[1])]
	end
	local levelMax = 0
	for k,v in ipairs(selectArray) do
		if fishRodData.ownFishRodList[tostring(v)].level >= levelMax then
			levelMax = fishRodData.ownFishRodList[tostring(v)].level
		end
	end
	----随机成功失败
	local value=Sub1StringSplit(successGaiLv)
	if GetRandom(tonumber(value[1])) then
		if pet==nil or pet=="" then				
			return false,"Please try again"
		end
		pet.fuse += 1
		pet.level = levelMax
		fishRodData.fishRodNum += 1
		fishRodData.ownFishRodList[tostring(fishRodData.fishRodNum)] = pet

		FishRodDataDAO.UpdateFishRodData(player,fishRodData)

		--保存装备宠物至数据库sa
		for k,v in ipairs(selectArray) do
			fishRodData.ownFishRodList[tostring(v)]=nil
		end
		FishRodDataDAO.UpdateFishRodData(player,fishRodData)

		return true,"Fuse Success !!!"
	else
		--保存装备宠物至数据库sa
		for k,v in ipairs(selectArray) do
			fishRodData.ownFishRodList[tostring(v)]=nil
		end
		FishRodDataDAO.UpdateFishRodData(player,fishRodData)

		return false,"Fuse Fail !"
	end
end

function FishRodFuseService:KnitInit()
	PlayerResourceService = Knit.GetService("PlayerResourceService")
end

function FishRodFuseService:KnitStart()
end

return FishRodFuseService
