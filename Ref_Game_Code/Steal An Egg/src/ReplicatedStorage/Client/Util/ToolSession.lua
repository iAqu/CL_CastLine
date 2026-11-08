-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ToolCooldown = require(ReplicatedStorage.Shared.Util.ToolCooldown)
local ToolGameplayGuard = require(ReplicatedStorage.Client.ToolGameplayGuard)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t1 = {}
local LocalPlayer = Players.LocalPlayer

local function accepted(p1, p2) -- line: 31
    return p2:IsA("Tool") and table.find(p1.accepts, (p2:GetAttribute("GearName"))) ~= nil
end

local function loosen(p3) -- line: 36
    local grip = p3.grip

    if grip then
        grip:Clean()
    end
end

local function stow(p4) -- line: 43
    local grip = p4.grip

    if grip then
        grip:Clean()
    end

    p4.grip = nil

    local onUnequipped = p4.hooks.onUnequipped

    if onUnequipped then
        onUnequipped()
    end

    p4.held = nil
end

local function wield(p5, p6) -- line: 55
    -- upvalues: ToolCooldown (copy), ToolGameplayGuard (copy), Trove (copy), LocalPlayer (copy)
    local grip = p5.grip

    if grip then
        grip:Clean()
    end

    p5.grip = Trove.new()
    p5.held = p6
    ToolCooldown.PrimeTool(p6)

    local onEquipped = p5.hooks.onEquipped

    if onEquipped then
        onEquipped(p6)
    end

    local grip2 = p5.grip

    if not grip2 then
        return
    end

    if p5.hooks.onActivated then
        grip2:Add(p6.Activated:Connect(function() -- line: 71
            -- upvalues: p5 (copy), p6 (copy), ToolGameplayGuard (copy)
            local onActivated = p5.hooks.onActivated

            if onActivated and ToolGameplayGuard.AllowsLocalUse(p6) then
                onActivated(p6)
            end
        end))
    end

    grip2:Add(LocalPlayer.CharacterRemoving:Connect(function() -- line: 79
        -- upvalues: p5 (copy)
        local grip = p5.grip

        if grip then
            grip:Clean()
        end
    end))
end

local function onGearChange(p7, p8, p9) -- line: 83
    if p8:IsA("Tool") and table.find(p7.accepts, (p8:GetAttribute("GearName"))) ~= nil then
        p9(p7, p8)
    end
end

function t1.GearNameOf(p10) -- line: 89
    return if p10 then p10:GetAttribute("GearName") else nil
end

function t1.Follow(p11, p12) -- line: 95
    -- upvalues: wield (copy)
    p12.ChildAdded:Connect(function(p13) -- line: 96
        -- upvalues: p11 (copy), wield (copy)
        if p13:IsA("Tool") and table.find(p11.accepts, (p13:GetAttribute("GearName"))) ~= nil then
            wield(p11, p13)
        end
    end)
    p12.ChildRemoved:Connect(function(p14) -- line: 97
        -- upvalues: p11 (copy)
        if not p14:IsA("Tool") or table.find(p11.accepts, (p14:GetAttribute("GearName"))) == nil then
            return
        end

        local grip = p11.grip

        if grip then
            grip:Clean()
        end

        p11.grip = nil

        local onUnequipped = p11.hooks.onUnequipped

        if onUnequipped then
            onUnequipped()
        end

        p11.held = nil
    end)

    local Tool = p12:FindFirstChildWhichIsA("Tool")

    if Tool and Tool:IsA("Tool") and table.find(p11.accepts, (Tool:GetAttribute("GearName"))) ~= nil then
        wield(p11, Tool)
    end
end

function t1.Shut(p15) -- line: 105
    p15.spawns:Clean()

    local grip = p15.grip

    if grip then
        grip:Clean()
    end
end

return t1
