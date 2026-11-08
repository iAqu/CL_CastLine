-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local t = require(ReplicatedStorage.Packages.t)

require(ReplicatedStorage.Shared.Modules.ProfileDefaults.Types.Interface)

local TreadmillStaticCover = require(ReplicatedStorage.Client.UI.TreadmillStaticCover)
local TreadmillVideoGate = require(ReplicatedStorage.Client.TreadmillVideoGate)
local TreadmillStaticRateSign = require(ReplicatedStorage.Client.UI.TreadmillStaticRateSign)
local TreadmillUtil = require(ReplicatedStorage.Shared.Util.TreadmillUtil)

require(ReplicatedStorage.Shared.TreadmillVideoController.Types.Interface)

local Treadmills = require(ReplicatedStorage.Data.Treadmills)

require(script.Parent.Types.Interface)

local Treadmills2 = ReplicatedStorage.Assets.Models.Treadmills
local t1 = {}

function t1.SetGroundedScale(p1, p2) -- line: 34
    -- upvalues: t (copy), TreadmillUtil (copy)
    t.strict(t.table)(p1)
    t.strict(t.number)(p2)
    p1.Model:ScaleTo(p2)

    local Root = p1.Model.Root

    assert(Root:IsA("BasePart"), (("Treadmill \"%*\" Root must be a BasePart"):format(p1.TreadmillId)))

    local v2 = p1.Model:GetPivot():ToObjectSpace(Root.CFrame)
    local v3 = TreadmillUtil.ResolveGroundedToolRootCFrameAtLocation(p1.Bottom, p1.Model)

    p1.Model:PivotTo(v3 * v2:Inverse())
end

function t1.Build(p3, p4, p5, p6, p7, p8) -- line: 46
    -- upvalues: Players (copy), Workspace (copy), t (copy), TreadmillStaticCover (copy), TreadmillVideoGate (copy), TreadmillStaticRateSign (copy), TreadmillUtil (copy), Treadmills (copy), Treadmills2 (copy), t1 (copy)
    t.strict(t.number)(p3)
    t.strict(t.number)(p4)
    t.strict(t.table)(p5)
    t.strict(t.number)(p6)
    t.strict(t.boolean)(p7)
    t.strict(t.instanceIsA("Folder"))(p8)

    local Plots = Workspace.Plots

    assert(Plots:IsA("Folder"), "Treadmill rendering requires the plots folder")

    local v4 = Plots[tostring(p3)]

    assert(v4:IsA("Model"), (("Plot \"%*\" must be a Model"):format(p3)))

    local TreadmillBottom = v4.TreadmillBottom

    assert(TreadmillBottom:IsA("BasePart"), (("Plot \"%*\" TreadmillBottom must be a BasePart"):format(p3)))

    local PlayerByUserId = Players:GetPlayerByUserId(p4)
    local v7 = if PlayerByUserId == nil then Treadmills.GetByUpgradeLevel(p5.TreadmillUpgradeLevel) else Treadmills.ResolveForPlayer(PlayerByUserId, p5.TreadmillUpgradeLevel)

    assert(v7 ~= nil, (("Invalid treadmill upgrade level %*"):format(p5.TreadmillUpgradeLevel)))

    local v10 = Treadmills2[v7._id]

    assert(v10:IsA("Tool"), (("Treadmill render template \"%*\" must be a Tool"):format(v7._id)))

    local clone = v10:Clone()

    clone.Name = ("TreadmillRender_%*"):format(p3)

    if TreadmillVideoGate.IsVideoPlayerDisabled() then
        local v12 = TreadmillUtil.FindVideoPlayerFolder(clone)

        if v12 ~= nil then
            v12:Destroy()
        end
    end

    clone.Parent = p8

    for _, descendant in ipairs(clone:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
        elseif descendant:IsA("BaseScript") then
            descendant:Destroy()
        end
    end

    local v13 = TreadmillStaticRateSign.Apply(clone, v7.Rarity.Color, v7.SpeedMultiplier)
    local v14 = TreadmillUtil.FindVideoFeedScreenPart(clone)
    local v15

    if p7 and v14 ~= nil then
        v15 = TreadmillStaticCover.Create(("StaticTreadmillCover_%*"):format(p3), v14)
        TreadmillStaticCover.ApplyFeed(v15, p5.TreadmillMediaFeedState)
    end

    local t2 = {
        Bottom = TreadmillBottom,
        Cover = v15,
        Model = clone,
        OwnerUserId = p4,
        RateSign = v13,
        Slot = p3,
        TreadmillId = v7._id
    }

    t1.SetGroundedScale(t2, clone:GetScale() * p6)

    return t2
end

return t1
