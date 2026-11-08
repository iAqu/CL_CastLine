-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Environment = require(ReplicatedStorage.Shared.Modules.Environment)
local LimitedEgg = require(ReplicatedStorage.Data.LimitedEgg)
local HalloweenEggSettings = require(ReplicatedStorage.Data.HalloweenEggSettings)
local Signal = require(ReplicatedStorage.Packages.Signal)
local v1 = "off"
local t1 = {
    Changed = Signal.new()
}

function t1.IsActive() -- line: 12
    -- upvalues: v1 (ref)
    return v1 ~= "off"
end

function t1.Mode() -- line: 16
    -- upvalues: v1 (ref)
    return v1
end

function t1.Config() -- line: 20
    -- upvalues: LimitedEgg (copy), v1 (ref)
    local v2 = LimitedEgg.Active()

    if v1 == "before" then
        return LimitedEgg.Extinction
    end

    if v1 == "after" then
        return LimitedEgg.Halloween
    end

    return v2
end

function t1.Time() -- line: 30
    -- upvalues: Workspace (copy), HalloweenEggSettings (copy), v1 (ref)
    if v1 == "before" then
        return HalloweenEggSettings.StartsAt - 1
    end

    if v1 == "after" then
        return HalloweenEggSettings.StartsAt
    end

    return Workspace:GetServerTimeNow()
end

function t1.IsHalloween() -- line: 39
    -- upvalues: LimitedEgg (copy), t1 (copy)
    return t1.Config() == LimitedEgg.Halloween
end

function t1.Set(p1) -- line: 43
    -- upvalues: RunService (copy), Environment (copy), HalloweenEggSettings (copy), v1 (ref), t1 (copy)
    if not RunService:IsStudio() and not Environment.IsDevPlace() and not Environment.IsTestPlace() then
        return false, "Shop preview is available only in DEV, TEST or Studio."
    end

    local v3 = string.lower(p1)
    local v4 = ({
        old = "before",
        new = "after",
        live = "off"
    })[v3] or v3

    if v4 ~= "before" and v4 ~= "after" and v4 ~= "off" then
        return false, "Use shopPreview before, after or off."
    end

    if v4 ~= v1 then
        v1 = v4
        t1.Changed:Fire()
    end

    if v1 == "off" then
        return true, "Normal automatic shop restored."
    end

    local v5 = DateTime.fromUnixTimestamp(HalloweenEggSettings.StartsAt):FormatUniversalTime("YYYY-MM-DD HH:mm", "en-us")

    return true, string.format("%s preview (%s the %s UTC switch). Egg purchases disabled. Close the shop or use shopPreview off to restore.", t1.Config().DisplayName, v1, v5)
end

return t1
