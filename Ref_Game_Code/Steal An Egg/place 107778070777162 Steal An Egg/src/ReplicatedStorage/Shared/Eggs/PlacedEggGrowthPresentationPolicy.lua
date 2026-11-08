-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ServerClock = require(game:GetService("ReplicatedStorage").Shared.Util.ServerClock)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.intersection(t.numberMinExclusive((-1e999)), t.numberMaxExclusive(1e999))
local ModelBounds = require(ReplicatedStorage.Shared.Utils.ModelBounds)
local EggRecords = require(ReplicatedStorage.Shared.Util.EggRecords)
local EggRenderer = require(script.Parent.EggRenderer)
local EggScaling = require(ReplicatedStorage.Shared.Util.EggScaling)

require(ReplicatedStorage.Shared.Types.Eggs)

local Log = require(ReplicatedStorage.Packages.Log)
local Player = require(ReplicatedStorage.Shared.Player)
local v2 = Log.new()
local t1 = {}

function t1.GetGrowthAlpha(p1, p2) -- line: 42
    -- upvalues: ServerClock (copy), EggRecords (copy)
    return EggRecords.GrowthAlpha(p1, ServerClock.Now(), p1.GrowthSpeedMultiplier, p2)
end

function t1.GetDirectGrowthTweenRemainingSeconds(p3, p4) -- line: 54
    -- upvalues: EggRecords (copy)
    local Placement = p3.Placement

    if Placement == nil or Placement.ReadyAt ~= nil or EggRecords.GrowthDuration(p3) >= 10 then
        return 0
    end

    return EggRecords.WallSecondsRemaining(p3, p4, p3.GrowthSpeedMultiplier)
end

function t1.GetStartScale(p5) -- line: 70
    -- upvalues: EggRenderer (copy), EggScaling (copy)
    return EggScaling.PlacedStart(EggRenderer.GetAuthoredScale(p5), p5.AssetScale, p5.AssetCategory)
end

function t1.GetTargetScale(p6) -- line: 78
    -- upvalues: EggRenderer (copy), EggScaling (copy)
    return EggScaling.PlacedTarget(EggRenderer.GetAuthoredScale(p6), p6.AssetScale, p6.AssetCategory)
end

function t1.GetVisualScale(p7, p8, p9) -- line: 86
    -- upvalues: t1 (copy)
    return p8 + t1.GetGrowthAlpha(p7, nil) * (p9 - p8)
end

function t1.IsReady(p10, p11) -- line: 95
    -- upvalues: t1 (copy)
    return t1.GetGrowthAlpha(p10, p11) >= 1
end

function t1.GetRemainingGrowthSeconds(p12, p13) -- line: 102
    -- upvalues: ServerClock (copy), EggRecords (copy)
    return EggRecords.GrowthSecondsRemaining(p12, ServerClock.Now(), p12.GrowthSpeedMultiplier, p13)
end

function t1.GetSkipReason(p14) -- line: 114
    -- upvalues: Players (copy), Workspace (copy), t (copy), ModelBounds (copy), Player (copy)
    t.strict(t.instanceIsA("Model"))(p14)

    local v3 = Player.FindRootPart(Players.LocalPlayer)

    if v3 == nil then
        return "local player root is unavailable"
    end

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil then
        return "current camera is unavailable"
    end

    local v4 = ModelBounds(p14)
    local Magnitude = (v3.Position - v4.Position).Magnitude

    if Magnitude > 300 then
        return (("distance %* studs exceeds %*"):format(math.round(Magnitude), 300))
    end

    local _, v5 = CurrentCamera:WorldToViewportPoint(v4.Position)

    return if not v5 then "visible bounds center is off-screen" else nil
end

function t1.GetGrowthScaleDeltaSkipReason(p15, p16) -- line: 141
    -- upvalues: t (copy), v1 (copy)
    t.strict(v1)(p15)
    t.strict(v1)(p16)

    local v7 = math.abs(p16 - p15)

    if v7 <= 0.15 then
        return (`scale delta { math.round(v7 * 1000) / 1000 } does not exceed {0.15} presentation threshold`)
    end

    local v10 = v7 / math.max(math.abs(p15), 0.001)

    return if v10 <= 0.03 then ("relative scale delta %*%% does not exceed %*%% presentation threshold"):format(math.round(v10 * 10000) / 100, 3) else nil
end

function t1.GetNaturalGrowthSkipReason(p17, p18) -- line: 163
    -- upvalues: t (copy), v1 (copy), t1 (copy)
    t.strict(t.instanceIsA("Model"))(p17)
    t.strict(v1)(p18)

    local v12 = t1.GetGrowthScaleDeltaSkipReason(p17:GetScale(), p18)

    if v12 == nil then
        return t1.GetSkipReason(p17)
    end

    return v12
end

function t1.LogSkipped(p19, p20, p21) -- line: 179
    -- upvalues: t (copy), v2 (copy)
    t.strict(t.string)(p19)
    t.strict(t.string)(p20)
    t.strict(t.string)(p21)
    v2:AtInfo():Log((("Skipped placed egg %* for %*: %*"):format(p20, p19, p21)))
end

return t1
