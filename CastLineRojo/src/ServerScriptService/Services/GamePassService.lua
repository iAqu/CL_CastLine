local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataService = require(ServerScriptService.Services.PlayerDataService)
local Constants = require(ReplicatedStorage.Modules.Constants)
local PurchaseDataHelper = require(ReplicatedFirst.DataHelpers.PurchaseDataHelper)

local GamePassService = Knit.CreateService {
    Name = "GamePassService",
    Client = {
        GiveGamePass = Knit.CreateSignal(),
    },
}

function GamePassService:GiveGamePass(player: Player, gamePassId: string)
    if PurchaseDataHelper.IsRetired(gamePassId) then return end
    local profile = PlayerDataService:GetProfile(player)
    if not profile then return end

    -- if profile.Data.GamePasses[gamePassId] == true then return end

    profile.Data.GamePasses[gamePassId] = true
	if gamePassId == "VIP" then player:SetAttribute("HasVIP", true) end
	if gamePassId == Constants.GAMEPASS.SUPER_LUCK or gamePassId == Constants.GAMEPASS.MEGA_LUCK then
		Knit.GetService("PlayerLuckService"):RefreshPlayerLuck(player)
	end

    self.Client.GiveGamePass:Fire(player, gamePassId)
end

function GamePassService:KnitInit()

end

function GamePassService:KnitStart()

end

return GamePassService
