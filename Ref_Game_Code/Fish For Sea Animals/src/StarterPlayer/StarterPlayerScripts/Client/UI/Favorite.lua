-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local AvatarEditorService = game:GetService("AvatarEditorService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local t1 = {}

local function v1() -- line: 19
    return false
end

local function v2() -- line: 22
    return true
end

function t1.setBusyCheck(p1) -- line: 26
    -- upvalues: v1 (ref)
    v1 = p1
end

function t1.setStartCheck(p2) -- line: 31
    -- upvalues: v2 (ref)
    v2 = p2
end

local function alreadyFavorited() -- line: 35
    -- upvalues: AvatarEditorService (copy)
    for _, v3 in { "GetFavoriteAsync", "GetFavorite" } do
        local function v4() -- line: 37
            -- upvalues: v3 (copy), AvatarEditorService (copy)
            return AvatarEditorService[v3](AvatarEditorService, game.PlaceId, Enum.AvatarItemType.Asset)
        end

        local ok, result = pcall(v4)

        if ok then
            return result == true
        end
    end

    return false
end

function t1.init() -- line: 47
    -- upvalues: AvatarEditorService (copy), Players (copy), Config (copy), Remotes (copy), v1 (ref), v2 (ref), alreadyFavorited (copy)
    local LocalPlayer = Players.LocalPlayer

    local function tutorialDone() -- line: 49
        -- upvalues: LocalPlayer (copy), Config (copy)
        local Tutorial = LocalPlayer:GetAttribute("Tutorial")

        return Tutorial ~= nil and Config.TutorialDone <= Tutorial
    end

    task.spawn(function() -- line: 53
        -- upvalues: LocalPlayer (copy), AvatarEditorService (copy), Config (copy), Remotes (copy), v1 (ref), v2 (ref), alreadyFavorited (copy)
        while not v2() do
            task.wait(1)
        end

        while true do
            local Tutorial = LocalPlayer:GetAttribute("Tutorial")

            if Tutorial ~= nil and Config.TutorialDone <= Tutorial then
                break
            end

            task.wait(1)
        end

        task.wait(60)

        local n1 = 0

        while v1() and n1 < 60 do
            n1 += task.wait(1)
        end

        if game.PlaceId ~= 0 and LocalPlayer:GetAttribute("FavoritePrompted") == false and not alreadyFavorited() then
            Remotes.Tutorial:FireServer("FavoritePrompted")

            local PromptSetFavorite = AvatarEditorService.PromptSetFavorite
            local PlaceId = game.PlaceId
            local Asset = Enum.AvatarItemType.Asset
            local ok, result = pcall(PromptSetFavorite, AvatarEditorService, PlaceId, Asset, true)

            if not ok then
                warn("Favorite prompt failed: " .. tostring(result))
            end
        end
    end)
end

return t1
