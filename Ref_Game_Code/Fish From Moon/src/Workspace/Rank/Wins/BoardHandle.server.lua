local sg = script.Parent --Surface GUI
local sample = script:WaitForChild("Sample") --Our Sample frame
local sf1 = sg:WaitForChild("SurfaceGui").Frame.Frame.Mid.Player --The scrolling frame
local UI1 = sf1:WaitForChild("UI") --The UI list layout
--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--获取模组
local Knit = require(ReplicatedStorage.Packages.Knit)

local NumberFormat= require(ReplicatedStorage.Source.Utils.NumberFormat)
--local MyConfig = require(game:GetService("ReplicatedStorage").Config.MyConfig)

local dataStoreService = game:GetService("DataStoreService")

local DATA_STORE_NAME = "PlayerWinsRank_FlyFish"
local dataStore = dataStoreService:GetOrderedDataStore(DATA_STORE_NAME)

local smallestFirst = false--false = 2 before 1, true = 1 before 2
local numberToShow = 100--Any number between 1-100, how many will be shown
local minValue = 1--Any numbers lower than this will be excluded
local maxValue = 10e30--(10^30), any numbers higher than this will be excluded

local Top100Players = {}

while task.wait(10) do
	local success, err = pcall(function()
		while true do
			local pages = dataStore:GetSortedAsync(smallestFirst, numberToShow, minValue, maxValue)
			local page = pages:GetCurrentPage()--Get the first page
			local data = {}--Store new data
			for a,b in ipairs(page) do--Loop through data
				local userid = b.key--User id
				local points = b.value--Points
				local username = "[Failed To Load]"--If it fails, we let them know
				pcall(function()
					wait(1)
					username = game.Players:GetNameFromUserIdAsync(userid)--Get username
				end)
				local thumbType = Enum.ThumbnailType.HeadShot
				local thumbSize = Enum.ThumbnailSize.Size60x60
				local success, ret = pcall(function()
					return game:GetService("Players"):GetUserThumbnailAsync(userid, thumbType, thumbSize)
				end)

				local image = (success and ret) or ""
				table.insert(data, {username,points,image,userid})--Put new data in new table
			end
			UI1.Parent = script
			sf1:ClearAllChildren()--Remove old frames
			UI1.Parent = sf1
			Top100Players = {}

			for number, d in pairs(data) do--Loop through our new data
				local name = d[1]
				local val = d[2]
				local image = d[3]
				local color = Color3.new(0, 0, 0)--Default color
				if number == 1 then
					color = Color3.fromRGB(205, 165, 0)--1st place color
				elseif number == 2 then
					color = Color3.fromRGB(173, 227, 255) --2nd place color
					--script.Parent.Parent.ID2.Value = d[4]
				elseif number == 3 then
					color = Color3.fromRGB(208, 124, 0)--3rd place color
					--script.Parent.Parent.ID3.Value = d[4]
				end
				local new = sample:Clone()--Make a clone of the sample frame
				new.Name = name--Set name for better recognition and debugging
				new.LayoutOrder = number--UIListLayout uses this to sort in the correct order
				new.PlaceLabel.Text = number--Set the place
				new.BackgroundColor3 = color--Set the place color (Gold = 1st)
				new.PlayerNme.Text = "@"..name--Set the 
				local valText = NumberFormat.AbbreviateNumber(math.exp(val/1000000))
				new.Val.Text = valText --Set the amount of pointsusername
				new.Player.Image =image
				--local new1 = new:Clone()
				new.Parent = sf1
				Top100Players[number] = d[1]

			end

			wait(350)

			for i, v in pairs(game:GetService("Players"):GetPlayers()) do
				if not v.Parent then
					continue
				end
				local success, err = pcall(function()
					local base = dataStoreService:GetOrderedDataStore("PlayerWinsRank_FlyFish")
					local player = v
					local PlayerResourceService = Knit.GetService("PlayerResourceService")
					local playerResourceData = PlayerResourceService:GetPlayerResourceData(player)
					if playerResourceData.sumMoneys ~= 0 then
						base:SetAsync(v.UserId,math.ceil(1000000 * math.log(playerResourceData.sumMoneys)))
						task.wait()
					end
				end)
				if not success then
					warn(err)
				end
			end
		end
	end)
	if not success then
		warn(err)
	end
end
