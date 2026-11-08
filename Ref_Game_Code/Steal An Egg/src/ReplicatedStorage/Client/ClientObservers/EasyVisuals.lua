-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EasyVisuals = require(ReplicatedStorage.Client.UI.VFX.EasyVisuals)
local ObserveUITag = require(ReplicatedStorage.Client.ObserveUITag)

require(ReplicatedStorage.Packages.Trove)

local t1 = {}

local function GetTintGradient(p1) -- line: 20
    local Gradient = p1:FindFirstChild("Gradient")

    return if Gradient ~= nil and Gradient:IsA("UIGradient") then Gradient else nil
end

local function StartEffect(p2, p3) -- line: 29
    -- upvalues: EasyVisuals (copy), t1 (copy)
    if t1[p2] then
        return
    end

    local EasyVisualsPreset = p2:GetAttribute("EasyVisualsPreset")

    if type(EasyVisualsPreset) ~= "string" then
        warn((("%* needs an EasyVisualsPreset attribute"):format((p2:GetFullName()))))

        return
    end

    t1[p2] = true

    local EasyVisualsDrift = p2:GetAttribute("EasyVisualsDrift")
    local Gradient = p2:FindFirstChild("Gradient")

    if Gradient == nil or not Gradient:IsA("UIGradient") then
        Gradient = nil
    end

    local v1 = EasyVisuals.new(p2, EasyVisualsPreset, if type(EasyVisualsDrift) ~= "number" then nil else EasyVisualsDrift, nil, nil, if Gradient == nil then nil else Gradient.Color)

    if Gradient ~= nil then
        for _, v2 in v1.EffectObjects do
            if v2.__class == "Gradient" then
                v2:SetRotation(Gradient.Rotation, Gradient.Rotation)
            end
        end
    end

    p3:Add(function() -- line: 56
        -- upvalues: p2 (copy), v1 (copy), t1 (copy)
        t1[p2] = nil
        v1:Destroy()
    end)
end

ObserveUITag("EasyVisuals", function(p4, _, p6) -- PlayEffect | line: 62
    -- upvalues: StartEffect (copy)
    if p4:IsA("GuiObject") then
        StartEffect(p4, p6)
    else
        warn((("EasyVisuals tag on %* needs a GuiObject"):format((p4:GetFullName()))))
    end
end)

return nil
