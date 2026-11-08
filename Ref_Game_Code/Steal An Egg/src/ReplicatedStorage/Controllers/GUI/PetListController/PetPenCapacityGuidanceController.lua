-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local AssetRoster = require(ReplicatedStorage.Client.AssetRoster)
local GUI = require(ReplicatedStorage.Client.GUI)
local Hud = require(ReplicatedStorage.Client.Hud)
local EnsureUIScale = require(ReplicatedStorage.Shared.Utils.EnsureUIScale)
local Save = require(ReplicatedStorage.Shared.Save)
local TryCall = require(ReplicatedStorage.Shared.Utils.TryCall)
local v1 = TweenInfo.new(0.7, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, -1, true)
local LocalPlayer = Players.LocalPlayer
local v2 = GUI.ActivePets()
local PetsButton = Hud.Find("PetsButton")
local EquipBest = v2.Frame.EquipBest
local Badge = if PetsButton == nil then nil else PetsButton:FindFirstChild("Badge")
local Badge2 = EquipBest:FindFirstChild("Badge")
local v3, v4

assert(v2:IsA("ScreenGui"), "PlayerGui.ActivePets must be a ScreenGui")
assert(EquipBest:IsA("GuiButton"), "ActivePets.Frame.EquipBest must be a GuiButton")

local t1 = {}

local function stopBadgePulse(p1, p2) -- line: 55
    -- upvalues: EnsureUIScale (copy)
    if p2 ~= nil then
        p2:Cancel()
        p2:Destroy()
    end

    if p1 ~= nil then
        EnsureUIScale(p1).Scale = 1
        p1.Visible = false
    end

    return nil
end

local function startBadgePulse(p3, p4) -- line: 68
    -- upvalues: TweenService (copy), EnsureUIScale (copy), v1 (copy)
    if p3 == nil then
        return nil
    end

    p3.Visible = true

    if p4 ~= nil then
        return p4
    end

    local v5 = EnsureUIScale(p3)

    v5.Scale = 0.8

    local tween = TweenService:Create(v5, v1, {
        Scale = 1.2
    })

    tween:Play()

    return tween
end

local function refresh() -- line: 84
    -- upvalues: EnsureUIScale (copy), Save (copy), LocalPlayer (copy), Badge2 (copy), v3 (ref), v4 (ref), startBadgePulse (copy), Badge (copy)
    local v6 = Save.Await(LocalPlayer)
    local PetPenCapacityGuidance = if v6 == nil then nil else v6.PetPenCapacityGuidance
    local v7 = PetPenCapacityGuidance ~= nil and PetPenCapacityGuidance.Triggered and not PetPenCapacityGuidance.PetsTabAcknowledged
    local v8 = PetPenCapacityGuidance ~= nil and PetPenCapacityGuidance.Triggered and not PetPenCapacityGuidance.EquipBestAcknowledged

    if v7 then
        v3 = startBadgePulse(Badge, v3)
    else
        local v9 = v3

        if v9 ~= nil then
            v9:Cancel()
            v9:Destroy()
        end

        if Badge ~= nil then
            EnsureUIScale(Badge).Scale = 1
            Badge.Visible = false
        end

        v3 = nil
    end

    if v8 then
        v4 = startBadgePulse(Badge2, v4)
    else
        local v10 = v4

        if v10 ~= nil then
            v10:Cancel()
            v10:Destroy()
        end

        if Badge2 ~= nil then
            EnsureUIScale(Badge2).Scale = 1
            Badge2.Visible = false
        end

        v4 = nil
    end
end

function t1.AcknowledgePetsBadge() -- line: 108
    -- upvalues: AssetRoster (copy), EnsureUIScale (copy), TryCall (copy), v3 (ref), refresh (copy), Badge (copy)
    local Badge2, v11

    if Badge ~= nil then
        if Badge.Visible then
            Badge2 = Badge

            local v12 = v3

            if v12 ~= nil then
                v12:Cancel()
                v12:Destroy()
            end

            v11 = false
        else
            v11 = true
        end
    else
        v11 = true
    end

    if v11 then
        return
    end

    if Badge2 ~= nil then
        EnsureUIScale(Badge2).Scale = 1
        Badge2.Visible = false
    end

    v3 = nil
    task.spawn(function() -- line: 113
        -- upvalues: AssetRoster (copy), TryCall (copy), refresh (copy)
        local v13, v14 = TryCall(AssetRoster.AckPetsBadge)

        if not v13 or v14 ~= true then
            refresh()
        end
    end)
end

function t1.AcknowledgeEquipBestBadge() -- line: 121
    -- upvalues: AssetRoster (copy), EnsureUIScale (copy), TryCall (copy), Badge2 (copy), v4 (ref), refresh (copy)
    local Badge, v15

    if Badge2 ~= nil then
        if Badge2.Visible then
            Badge = Badge2

            local v16 = v4

            if v16 ~= nil then
                v16:Cancel()
                v16:Destroy()
            end

            v15 = false
        else
            v15 = true
        end
    else
        v15 = true
    end

    if v15 then
        return
    end

    if Badge ~= nil then
        EnsureUIScale(Badge).Scale = 1
        Badge.Visible = false
    end

    v4 = nil
    task.spawn(function() -- line: 126
        -- upvalues: AssetRoster (copy), TryCall (copy), refresh (copy)
        local v17, v18 = TryCall(AssetRoster.AckEquipBestBadge)

        if not v17 or v18 ~= true then
            refresh()
        end
    end)
end

function t1.Initialize() -- line: 134
    -- upvalues: Save (copy), refresh (copy)
    Save.Watch("PetPenCapacityGuidance"):Connect(refresh)
    task.spawn(refresh)
end

return t1
