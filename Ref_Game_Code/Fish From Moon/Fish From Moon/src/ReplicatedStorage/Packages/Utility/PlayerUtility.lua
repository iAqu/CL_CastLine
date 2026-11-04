-- Server
-- ItsKolapo
-- September 25, 2022

-- Documentation
--[[

]]

-- Module requires
local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

-- Service refs
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local PolicyService = game:GetService("PolicyService")

-- Constants

-- Module definition
local PlayerUtility = {}

function PlayerUtility.GetSign()
	if math.random() > 0.5 then
		return -1
	end
	
	return 1
end	

local cache = {}
function PlayerUtility.GetUserIdFromUsername(name)
	-- First, check if the cache contains the name
	if cache[name] then return cache[name] end
	-- Second, check if the user is already connected to the server
	local player = Players:FindFirstChild(name)
	if player then
		cache[name] = player.UserId
		return player.UserId
	end 
	-- If all else fails, send a request
	local id
	pcall(function ()
		id = Players:GetUserIdFromNameAsync(name)
	end)
	cache[name] = id
	return id
end

local cache2 = {}
function PlayerUtility.GetUsernameFromUserId(userId)
	-- First, check if the cache contains the name
	if cache2[userId] then return cache2[userId] end
	-- Second, check if the user is already connected to the server
	local player = Players:GetPlayerByUserId(userId)
	if player then
		cache2[userId] = player.Name
		return player.Name
	end 
	-- If all else fails, send a request
	local name
	pcall(function ()
		name = Players:GetNameFromUserIdAsync(userId)
	end)
	cache2[userId] = name
	return name
end

local cache3 = {}
function PlayerUtility.GetPolicyInfoForPlayerAsync(player)
	if cache3[player] then return cache3[player] end
	
	local info
	pcall(function ()
		info = PolicyService:GetPolicyInfoForPlayerAsync(player)
	end)
	cache3[player]= info
	return info
end

function PlayerUtility.CheckGroup(player, groupId)
	local success, groupRank  = pcall(function()
		return player:GetRankInGroup(groupId)
	end)

	if success and groupRank then
		if groupRank > 0 then
			return true
		end
	end

	return false
end

function PlayerUtility:KnitInit()
	
end

return PlayerUtility
