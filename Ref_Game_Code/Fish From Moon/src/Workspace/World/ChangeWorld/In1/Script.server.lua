--获取服务
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game:GetService("Players")
--获取模组
local Knit = require(ReplicatedStorage.Packages.Knit)
local Zone = require(ReplicatedStorage.Plugin.Zone)

local MapService

local localPlayer=Player.LocalPlayer

local TouchPart = script.Parent
local zone = Zone.new(TouchPart)

zone.playerEntered:Connect(function(player)
	if localPlayer==player then
		MapService = Knit.GetService("MapService")
		local id=script.Parent.Value.Value
		MapService:ChangeMapWorld(id)
	end
end)
