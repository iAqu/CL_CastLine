local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local StarterPlayer = game:GetService("StarterPlayer")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)
local Constants = require(ReplicatedStorage.Modules.Constants)
local LogHelper = require(ReplicatedStorage.Modules.LogHelper)

local GameController = Knit.CreateController {
    Name = "GameController",
}

-- function GameController:PromptAddFavorite()
--     game:GetService("AvatarEditorService"):PromptSetFavorite(16806007215, Enum.AvatarItemType.Asset, true)
-- end

function GameController:KnitInit()
end

function GameController:KnitStart()
end

return GameController