----获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer      

local FrameTrigger=require(player.PlayerGui:WaitForChild("MainMenu",5).FrameTrigger)
local Knit = require(ReplicatedStorage.Packages.Knit) 

----新世界修改点
repeat
	task.wait()
until player.Character

local hatch1Holder = false
local hatch2Holder = false
local hatch3Holder = false
local hatch4Holder = false
local hatch5Holder = false

local upgradesHolder = false
--传送
local TeleportHolder = false
--鱼竿图鉴
local fishRodIndexHolder = false
--鱼竿银行
local fishRodBankHolder = false
--鱼竿闪耀
local fishRodShinyHolder = false
--鱼竿彩虹
local fishRodRainbowHolder = false
--加入群组
local JoinGroupHolder = false
--VIP
local VIPHolder = false
--Enchant
local EnchantHolder = false

local function PlayerHatch1Check(otherPart,player)
	while task.wait(0.1) do
		local flag = true
		for _,v in ipairs(otherPart:GetTouchingParts()) do
			if	v.Parent.Name == player.Name then
				flag = false
			end		
		end
		if flag then
			hatch1Holder= false
			if player.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.FishRodLuckEgg.Visible == true then
				player:SetAttribute("BuyFishRod",false)
				local frameName="FishRodLuckEgg"
				FrameTrigger.CloseFram(frameName)
			end
			return
		end
	end
end
player.Character:WaitForChild("HumanoidRootPart").Touched:Connect(function(otherPart)
	if otherPart.Name == "hatch1" then
		if hatch1Holder==false then
			hatch1Holder = true
			local FishRodLuckController = Knit.GetController("FishRodLuckController")
			local PlayerResourceService = Knit.GetService("PlayerResourceService")
			local function getData(playerResourceData)
				if playerResourceData.maxWorld >= 1 then
					FishRodLuckController:OpenFishRodDedault(1)
					local frameName="FishRodLuckEgg"
					FrameTrigger.OpenFram(frameName)
				end
			end
			PlayerResourceService:GetPlayerResourceData(player):andThen(getData)
			PlayerHatch1Check(otherPart,player)
		end
	end
end)
local function PlayerHatch2Check(otherPart,player)
	while task.wait(0.1) do
		local flag = true
		for _,v in ipairs(otherPart:GetTouchingParts()) do
			if	v.Parent.Name == player.Name then
				flag = false
			end		
		end
		if flag then
			hatch2Holder= false
			if player.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.FishRodLuckEgg.Visible == true then
				player:SetAttribute("BuyFishRod",false)
				local frameName="FishRodLuckEgg"
				FrameTrigger.CloseFram(frameName)
			end
			return
		end
	end
end
player.Character:WaitForChild("HumanoidRootPart").Touched:Connect(function(otherPart)
	if otherPart.Name == "hatch2" then
		if hatch2Holder==false then
			hatch2Holder = true
			local FishRodLuckController = Knit.GetController("FishRodLuckController")
			local PlayerResourceService = Knit.GetService("PlayerResourceService")
			local function getData(playerResourceData)
				if playerResourceData.maxWorld >= 2 then
					FishRodLuckController:OpenFishRodDedault(2)
					local frameName="FishRodLuckEgg"
					FrameTrigger.OpenFram(frameName)
				else
					local MainGuiController = Knit.GetController("MainGuiController")
					MainGuiController:ShowMessageEffect("warning",nil,"Forest World needs to be unlocked!")
				end
			end
			PlayerResourceService:GetPlayerResourceData(player):andThen(getData)
			PlayerHatch2Check(otherPart,player)
		end
	end
end)
local function PlayerHatch3Check(otherPart,player)
	while task.wait(0.1) do
		local flag = true
		for _,v in ipairs(otherPart:GetTouchingParts()) do
			if	v.Parent.Name == player.Name then
				flag = false
			end		
		end
		if flag then
			hatch3Holder= false
			if player.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.FishRodLuckEgg.Visible == true then
				player:SetAttribute("BuyFishRod",false)
				local frameName="FishRodLuckEgg"
				FrameTrigger.CloseFram(frameName)
			end
			return
		end
	end
end
player.Character:WaitForChild("HumanoidRootPart").Touched:Connect(function(otherPart)
	if otherPart.Name == "hatch3" then
		if hatch3Holder==false then
			hatch3Holder = true
			local FishRodLuckController = Knit.GetController("FishRodLuckController")
			local PlayerResourceService = Knit.GetService("PlayerResourceService")
			local function getData(playerResourceData)
				if playerResourceData.maxWorld >= 3 then
					FishRodLuckController:OpenFishRodDedault(3)
					local frameName="FishRodLuckEgg"
					FrameTrigger.OpenFram(frameName)
				else
					local MainGuiController = Knit.GetController("MainGuiController")
					MainGuiController:ShowMessageEffect("warning",nil,"Snow World needs to be unlocked!")
				end
			end
			PlayerResourceService:GetPlayerResourceData(player):andThen(getData)
			PlayerHatch3Check(otherPart,player)
		end
	end
end)
local function PlayerHatch4Check(otherPart,player)
	while task.wait(0.1) do
		local flag = true
		for _,v in ipairs(otherPart:GetTouchingParts()) do
			if	v.Parent.Name == player.Name then
				flag = false
			end		
		end
		if flag then
			hatch4Holder= false
			if player.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.FishRodLuckEgg.Visible == true then
				player:SetAttribute("BuyFishRod",false)
				local frameName="FishRodLuckEgg"
				FrameTrigger.CloseFram(frameName)
			end
			return
		end
	end
end
player.Character:WaitForChild("HumanoidRootPart").Touched:Connect(function(otherPart)
	if otherPart.Name == "hatch4" then
		if hatch4Holder==false then
			hatch4Holder = true
			local FishRodLuckController = Knit.GetController("FishRodLuckController")
			local PlayerResourceService = Knit.GetService("PlayerResourceService")
			local function getData(playerResourceData)
				if playerResourceData.maxWorld >= 4 then
					FishRodLuckController:OpenFishRodDedault(4)
					local frameName="FishRodLuckEgg"
					FrameTrigger.OpenFram(frameName)
				else
					local MainGuiController = Knit.GetController("MainGuiController")
					MainGuiController:ShowMessageEffect("warning",nil,"Farm World needs to be unlocked!")
				end
			end
			PlayerResourceService:GetPlayerResourceData(player):andThen(getData)
			PlayerHatch4Check(otherPart,player)
		end
	end
end)
local function PlayerHatch5Check(otherPart,player)
	while task.wait(0.1) do
		local flag = true
		for _,v in ipairs(otherPart:GetTouchingParts()) do
			if	v.Parent.Name == player.Name then
				flag = false
			end		
		end
		if flag then
			hatch5Holder= false
			if player.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.FishRodRbLuckEgg.Visible == true then
				player:SetAttribute("BuyFishRod",false)
				local frameName="FishRodRbLuckEgg"
				FrameTrigger.CloseFram(frameName)
			end
			return
		end
	end
end
player.Character:WaitForChild("HumanoidRootPart").Touched:Connect(function(otherPart)
	if otherPart.Name == "hatch5" then
		if hatch5Holder==false then
			hatch5Holder = true
			local FishRodRBLuckController = Knit.GetController("FishRodRBLuckController")
			FishRodRBLuckController:OpenFishRodDedault(5)
			local frameName="FishRodRbLuckEgg"
			FrameTrigger.OpenFram(frameName)
			PlayerHatch5Check(otherPart,player)
		end
	end
end)

local function PlayerUpgradesCheck(otherPart,player)
	while task.wait(0.1) do
		local flag = true
		for _,v in ipairs(otherPart:GetTouchingParts()) do
			if	v.Parent.Name == player.Name then
				flag = false
			end		
		end
		if flag then
			upgradesHolder= false
			local frameName="Upgrades"
			FrameTrigger.CloseFram(frameName)
			return
		end
	end
end
player.Character:WaitForChild("HumanoidRootPart").Touched:Connect(function(otherPart)
	if otherPart.Name == "Upgrades" then
		if upgradesHolder==false then
			upgradesHolder = true
			local UpgradesController = Knit.GetController("UpgradesController")
			UpgradesController:OpenDedault()
			PlayerUpgradesCheck(otherPart,player)
		end
	end
end)

local function PlayerTeleportCheck(otherPart,player)
	while task.wait(1) do
		local flag = true
		for _,v in ipairs(otherPart:GetTouchingParts()) do
			if	v.Parent.Name == player.Name then
				flag = false
			end		
		end
		if flag then
			TeleportHolder= false
			if player.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.MapMenu.Visible == true then
				local frameName="MapMenu"
				FrameTrigger.CloseFram(frameName)
			end
			return
		end
	end
end
player.Character:WaitForChild("HumanoidRootPart").Touched:Connect(function(otherPart)
	if otherPart.Name == "Teleport" then
		if TeleportHolder==false then
			TeleportHolder = true
			local MapController = Knit.GetController("MapController")
			MapController:OpenDedault()
			local frameName="MapMenu"
			FrameTrigger.OpenFram(frameName)
			PlayerTeleportCheck(otherPart,player)
		end
	end
end)

----图鉴
local function PlayerFishRodIndexCheck(otherPart,player)
	while task.wait(1) do
		local flag = true
		for _,v in ipairs(otherPart:GetTouchingParts()) do
			if	v.Parent.Name == player.Name then
				flag = false
			end		
		end
		if flag then
			fishRodIndexHolder= false
			if player.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.IndexMenu.Visible == true then
				local frameName="IndexMenu"
				FrameTrigger.CloseFram(frameName)
			end
			return
		end
	end
end
player.Character:WaitForChild("HumanoidRootPart").Touched:Connect(function(otherPart)
	if otherPart.Name == "fishRodIndex" then
		if fishRodIndexHolder==false then
			fishRodIndexHolder = true

			local FishRodIndexController = Knit.GetController("FishRodIndexController")
			FishRodIndexController:OpenDedault()

			local frameName="IndexMenu"
			FrameTrigger.OpenFram(frameName)

			PlayerFishRodIndexCheck(otherPart,player)
		end
	end
end)

----银行
local function PlayerFishRodBankCheck(otherPart,player)
	while task.wait(1) do
		local flag = true
		for _,v in ipairs(otherPart:GetTouchingParts()) do
			if	v.Parent.Name == player.Name then
				flag = false
			end		
		end
		if flag then
			fishRodBankHolder= false
			if player.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.BankMenu.Visible == true then
				local frameName="BankMenu"
				FrameTrigger.CloseFram(frameName)
			end
			return
		end
	end
end
player.Character:WaitForChild("HumanoidRootPart").Touched:Connect(function(otherPart)
	if otherPart.Name == "FishRodBank" then
		if fishRodBankHolder==false then
			fishRodBankHolder = true

			local FishRodBankController = Knit.GetController("FishRodBankController")
			FishRodBankController:OpenDedault()

			local frameName="BankMenu"
			FrameTrigger.OpenFram(frameName)

			PlayerFishRodBankCheck(otherPart,player)
		end
	end
end)

----闪耀
local function PlayerFishRodShinyCheck(otherPart,player)
	while task.wait(1) do
		local flag = true
		for _,v in ipairs(otherPart:GetTouchingParts()) do
			if	v.Parent.Name == player.Name then
				flag = false
			end		
		end
		if flag then
			fishRodShinyHolder= false
			if player.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.FuseShinyMenu.Visible == true then
				local frameName="FuseShinyMenu"
				FrameTrigger.CloseFram(frameName)
			end
			return
		end
	end
end
player.Character:WaitForChild("HumanoidRootPart").Touched:Connect(function(otherPart)
	if otherPart.Name == "fishRodShiny" then
		if fishRodShinyHolder==false then
			fishRodShinyHolder = true

			local FishRodFuseController = Knit.GetController("FishRodFuseController")
			FishRodFuseController:OpenFishRodShinyDedault()

			local frameName="FuseShinyMenu"
			FrameTrigger.OpenFram(frameName)

			PlayerFishRodShinyCheck(otherPart,player)
		end
	end
end)

----彩虹
local function PlayerFishRodRainbowCheck(otherPart,player)
	while task.wait(1) do
		local flag = true
		for _,v in ipairs(otherPart:GetTouchingParts()) do
			if	v.Parent.Name == player.Name then
				flag = false
			end		
		end
		if flag then
			fishRodRainbowHolder= false
			if player.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.FuseRainbowMenu.Visible == true then
				local frameName="FuseRainbowMenu"
				FrameTrigger.CloseFram(frameName)
			end
			return
		end
	end
end
player.Character:WaitForChild("HumanoidRootPart").Touched:Connect(function(otherPart)
	if otherPart.Name == "fishRodRainbow" then
		if fishRodRainbowHolder==false then
			fishRodRainbowHolder = true

			local FishRodFuseController = Knit.GetController("FishRodFuseController")
			FishRodFuseController:OpenFishRodRainbowDedault()

			local frameName="FuseRainbowMenu"
			FrameTrigger.OpenFram(frameName)

			PlayerFishRodRainbowCheck(otherPart,player)
		end
	end
end)

----加入群组界面
local function PlayerJoinGroupCheck(otherPart,player)
	while task.wait(1) do
		local flag = true
		for _,v in ipairs(otherPart:GetTouchingParts()) do
			if	v.Parent.Name == player.Name then
				flag = false
			end		
		end
		if flag then
			JoinGroupHolder= false
			if player.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.JoinGroupMenu.Visible == true then
				local frameName="JoinGroupMenu"
				FrameTrigger.CloseFram(frameName)
			end
			return
		end
	end
end
player.Character:WaitForChild("HumanoidRootPart").Touched:Connect(function(otherPart)
	if otherPart.Name == "JoinTouchPart" then
		if JoinGroupHolder==false then
			JoinGroupHolder = true

			local JoinGroupController = Knit.GetController("JoinGroupController")
			JoinGroupController:OpenJoinGroupDedault()

			PlayerJoinGroupCheck(otherPart,player)
		end
	end
end)

----VIP
local function PlayerVIPCheck(otherPart,player)
	while task.wait(1) do
		local flag = true
		for _,v in ipairs(otherPart:GetTouchingParts()) do
			if	v.Parent.Name == player.Name then
				flag = false
			end		
		end
		if flag then
			VIPHolder= false
			return
		end
	end
end
player.Character:WaitForChild("HumanoidRootPart").Touched:Connect(function(otherPart)
	if otherPart.Name == "VIP" then
		if VIPHolder==false then
			VIPHolder = true
			local VIPController = Knit.GetController("VIPController")
			VIPController:OpenVIPDedault()
			PlayerVIPCheck(otherPart,player)
		end
	end
end)

----EnchantHolder
local function PlayerEnchantCheck(otherPart,player)
	while task.wait(1) do
		local flag = true
		for _,v in ipairs(otherPart:GetTouchingParts()) do
			if	v.Parent.Name == player.Name then
				flag = false
			end		
		end
		if flag then
			EnchantHolder= false
			if player.PlayerGui:WaitForChild("MainMenu",5).CenterMenu.EnchantMenu.Visible == true then
				local frameName="EnchantMenu"
				FrameTrigger.CloseFram(frameName)
			end
			return
		end
	end
end
player.Character:WaitForChild("HumanoidRootPart").Touched:Connect(function(otherPart)
	if otherPart.Name == "fishRodEnchant" then
		if EnchantHolder == false then
			EnchantHolder = true

			local EnchantController = Knit.GetController("EnchantController")
			EnchantController:OpenDedault()

			local frameName="EnchantMenu"
			FrameTrigger.OpenFram(frameName)

			PlayerEnchantCheck(otherPart,player)
		end
	end
end)