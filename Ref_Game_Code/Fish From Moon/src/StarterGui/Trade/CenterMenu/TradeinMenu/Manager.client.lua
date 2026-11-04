--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players=game:GetService("Players")
--获取模组
local Knit = require(ReplicatedStorage.Packages.Knit)

local Remotes=ReplicatedStorage:WaitForChild("Remotes")

local Tool = require(ReplicatedStorage.Source.Utils.Tool)
local FishRodHelper = require(ReplicatedStorage.Config.FishRodHelper)
local NumberFormat = require(ReplicatedStorage.Source.Utils.NumberFormat)
local FishRodLevelHelper = require(ReplicatedStorage.Config.FishRodLevelHelper)

local TradeFishRodFolder = ReplicatedStorage.Assets.Gui.TradeFishRod

local screenGui = script.Parent
local frame = screenGui.Menu.Menu
local container = frame.L.pet.ScrollingFrame.Frame
local accept = frame.L.Accept
local decline = frame.L.Decline
local close = screenGui.Menu.Exit.TextButton

local waiting = frame.L.UnAccept
local ourAccepted = frame.L.Frame

local theirLabel = frame.R.name
local theirOffer = frame.R.pet.ScrollingFrame.Frame
local theirAccepted = frame.R.Frame

local coundown = frame.Countdown

local array={}

local function UnacceptTrade()
	Remotes.TradeUnaccept:FireServer()
	ourAccepted.Visible=false
	coundown.Visible=false
	accept.Frame.TextLabel.Text="Ready"
	theirAccepted.Visible=false
	task.spawn(function()
		waiting.Visible=true
		task.wait(1.5)
		waiting.Visible=false
	end)
end

local function Cleanup()
	---清空数据
	for index, object in ipairs(container:GetChildren()) do 
		if object.ClassName == "TextButton" then
			object:Destroy()
		end
	end
	for _,child in pairs(theirOffer:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
end

local function GeneratePet(v,parent:Instance,k)
	local pet=TradeFishRodFolder:WaitForChild(FishRodHelper.GetFishRod(v["name"]).quality):Clone()
	pet.Name = v["uuid"]
	pet.Frame.imgPet.Image=FishRodHelper.GetFishRod(v["name"]).img
	--合成
	if v["fuse"]==1 then
		pet.Frame.Fuse.Visible=false
	elseif v["fuse"]==2 then
		pet.Frame.Fuse.Image="rbxassetid://12808209251"
		pet.Frame.Fuse.Visible=true
	elseif v["fuse"]==3 then
		pet.Frame.Fuse.Image="rbxassetid://12808210752"
		pet.Frame.Fuse.Visible=true
	end
	--锁定
	if v["lock"] then
		pet.Frame.Lock.Visible=true
	else
		pet.Frame.Lock.Visible=false
	end
	pet.Frame.imgEquip.Visible=false
	pet.LayoutOrder=k
	pet.Parent=parent
	return pet
end

local function SelectPet(button:ImageButton)
	button:SetAttribute("Selected",true)
	button.Frame.imgEquip.Visible=true
	button.LayoutOrder=0
	Remotes.TradeSelectPet:FireServer(button.Name)
end

local function DeselectPet(button:ImageButton,k)
	button:SetAttribute("Selected",false)
	button.Frame.imgEquip.Visible=false
	button.LayoutOrder=k
	Remotes.TradeDeselectPet:FireServer(button.Name)
end

local function GenerateOurPets()
	local FishRodService = Knit.GetService("FishRodService")
	FishRodService:GetFishRodData():andThen(function(fishRodData)
		array=fishRodData.ownFishRodList
		local AllPetUUIDAndAtk = {}
		for k, v in pairs(fishRodData.ownFishRodList) do
			local fuseUp=1
			if v.fuse==2 then
				fuseUp+=3
			elseif v.fuse==3 then
				fuseUp+=10
			elseif v.fuse==4 then
				fuseUp+=20
			end
			table.insert(AllPetUUIDAndAtk,{atk = FishRodHelper.GetFishRod(v.name).baseMultiplier * fuseUp,["uuid"]=k,["name"]=v.name,["fuse"]=v.fuse,["level"]=v.level,["exp"]=v.exp,["enchant"]=v.enchant,["enchantNum"]=v.enchantNum,["lock"]=v.lock,})
		end
		local sroted =Tool.topAtk(AllPetUUIDAndAtk)
		local sro2=Tool.topAtk(sroted)
		for k,v in ipairs(sro2) do
			if v["uuid"] == fishRodData.usingFishRodList[1] then
				continue
			end
			local pet=GeneratePet(v,container,k)
			pet:SetAttribute("Selected",false)
			pet.MouseButton1Click:Connect(function()
				if v["lock"] then
					return
				end
				UnacceptTrade()
				if pet:GetAttribute("Selected") then
					DeselectPet(pet,k)
				else
					SelectPet(pet)
				end
			end)
		end
	end)
end

local function TradeSelectPet(petTable)
	GeneratePet(petTable,theirOffer,1)
end
local function TradeDeselectPet(uuid)
	local instance=theirOffer:FindFirstChild(uuid)
	if instance then
		instance:Destroy()
	end
end

local function UpdateLabels(target:Player)
	theirLabel.Text=target.DisplayName
	theirAccepted.Visible=false
	coundown.Visible=false
end

local function BeginTrade(traderId:Player)
	local target=Players:GetPlayerByUserId(traderId)
	if not target then
		return
	end
	GenerateOurPets()
	UpdateLabels(target)
	screenGui.Visible=true
end

local function WaitTimeFive()
	coundown.Visible=true
	for i=5,1,-1 do
		coundown.TextLabel.Text=i
		task.wait(1)
	end
end

local function Decline()
	Cleanup()
	ourAccepted.Visible=false
	coundown.Visible=false
	theirAccepted.Visible=false
	accept.Frame.TextLabel.Text="Ready"
	task.spawn(function()
		waiting.Visible=true
		task.wait(1.5)
		waiting.Visible=false
	end)
	screenGui.Visible=false
end

local function TraderAccepts()
	theirAccepted.Visible = true
	coundown.Visible=false
end

local function TraderUnaccepts()
	ourAccepted.Visible=false
	coundown.Visible=false
	accept.Frame.TextLabel.Text="Ready"
	theirAccepted.Visible = false
	print(ourAccepted.Visible)
	print(theirAccepted.Visible)
	task.spawn(function()
		waiting.Visible=true
		task.wait(1.5)
		waiting.Visible=false
	end)
end

accept.MouseButton1Click:Connect(function()
	if accept.Frame.TextLabel.Text=="Ready" then
		Remotes.TradeAccept:FireServer()
		ourAccepted.Visible=true
		coundown.Visible=false
		accept.Frame.TextLabel.Text="Cancel"
	else
		UnacceptTrade()
	end
end)

decline.MouseButton1Click:Connect(function()
	Remotes.TradeDeclined:FireServer()
	Decline()
end)

close.MouseButton1Click:Connect(function()
	Remotes.TradeDeclined:FireServer()
	Decline()
end)

Remotes.TradeBegan.OnClientEvent:Connect(BeginTrade)
Remotes.TradeDeclined.OnClientEvent:Connect(Decline)
Remotes.TradeSelectPet.OnClientEvent:Connect(TradeSelectPet)
Remotes.TradeDeselectPet.OnClientEvent:Connect(TradeDeselectPet)
Remotes.TradeAccept.OnClientEvent:Connect(TraderAccepts)
Remotes.TradeUnaccept.OnClientEvent:Connect(TraderUnaccepts)
Remotes.TradeCompleted.OnClientEvent:Connect(Decline)
Remotes.WaitTimeFive.OnClientEvent:Connect(WaitTimeFive)