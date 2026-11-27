-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local AvatarEditorService = game:GetService("AvatarEditorService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Fish = require(Shared.Data.Fish)
local Rarities = require(Shared.Data.Rarities)
local DataClient = require(script.Parent.DataClient)
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local t1 = {}

t1.__index = t1
t1.MIN_ORDER = 5
t1.DELAY = 1.2

function t1.new() -- line: 15
    -- upvalues: AvatarEditorService (copy), t1 (copy)
    local self = setmetatable({}, t1)

    self.Asked = false
    self.Prompts = 0
    self.Mute = false
    self.Favorited = false
    self.Skipped = 0
    AvatarEditorService.PromptSetFavoriteCompleted:Connect(function(p1) -- line: 22
        -- upvalues: self (copy)
        if p1 == Enum.AvatarPromptResult.Success then
            self:Remember()
        end
    end)

    return self
end

function t1:Remember() -- line: 30
    -- upvalues: Remotes (copy)
    self.Favorited = true
    task.spawn(function() -- line: 32
        -- upvalues: Remotes (copy)
        local function v2() -- line: 33
            -- upvalues: Remotes (copy)
            Remotes:WaitForChild("SetSetting"):InvokeServer("Favorited", true)
        end

        pcall(v2)
    end)
end

function t1.Saved(_) -- line: 39
    -- upvalues: DataClient (copy)
    local Settings = DataClient.Get("Settings")

    if type(Settings) == "table" then
        return Settings.Favorited == true
    end

    return false
end

function t1:AlreadyFavorited() -- line: 44
    -- upvalues: AvatarEditorService (copy)
    if self.Favorited or self:Saved() then
        self.Favorited = true
    else
        local function v3() -- line: 49
            -- upvalues: AvatarEditorService (copy)
            return AvatarEditorService:GetFavoriteAsync(game.PlaceId, Enum.AvatarItemType.Asset)
        end

        local ok, result = pcall(v3)

        if not ok or result ~= true then
            return false
        end

        self:Remember()
    end

    return true
end

function t1:Qualifies(p6) -- line: 59
    -- upvalues: Fish (copy), Rarities (copy)
    local v4 = p6 and Fish.ById[p6.fishId]
    local v5 = v4 and Rarities.ById[v4.rarity]

    return v5 ~= nil and v5.order >= self.MIN_ORDER
end

function t1:AfterCatch(p8) -- line: 65
    -- upvalues: AvatarEditorService (copy)
    if self.Asked or not self:Qualifies(p8) then
        return false
    end

    self.Asked = true

    if self:AlreadyFavorited() then
        self.Skipped += 1

        return false
    end

    self.Prompts += 1

    if not self.Mute then
        task.delay(self.DELAY, function() -- line: 76
            -- upvalues: AvatarEditorService (copy)
            local function v6() -- line: 77
                -- upvalues: AvatarEditorService (copy)
                AvatarEditorService:PromptSetFavorite(game.PlaceId, Enum.AvatarItemType.Asset, true)
            end

            pcall(v6)
        end)
    end

    return true
end

t1.Shared = t1.new()

return t1
