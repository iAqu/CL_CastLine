-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

require(ReplicatedStorage.Packages.Trove)

local t1 = {}

local function colorsAt(p1) -- line: 32
    local v1 = table.create(9)

    for i = 0, 8 do
        local v2 = i / 8
        local v3 = (p1 - v2 * 1) % 1

        v1[i + 1] = ColorSequenceKeypoint.new(v2, Color3.fromHSV(v3, 1, 1))
    end

    return ColorSequence.new(v1)
end

local function glowOf(p2) -- line: 42
    local Parent = p2.Parent
    local EggGlow = if Parent == nil then nil else Parent:FindFirstChild("EggGlow")

    return if EggGlow ~= nil and EggGlow:IsA("PointLight") then EggGlow else nil
end

function t1.Start(p3) -- line: 52
    -- upvalues: CollectionService (copy), GuiService (copy), RunService (copy), colorsAt (copy)
    local t2 = {}
    local v4

    local function step() -- line: 56
        -- upvalues: t2 (copy), GuiService (copy), colorsAt (copy)
        if GuiService.ReducedMotionEnabled then
            return
        end

        local v5 = os.clock() / 3.5 % 1
        local v6 = colorsAt(v5)
        local v7 = Color3.fromHSV(v5, 1, 1)

        for _, v8 in t2 do
            if v8.Beam.Enabled then
                v8.Beam.Color = v6
            end

            local Glow = v8.Glow

            if Glow ~= nil then
                Glow.Color = v7
            end
        end
    end

    local function track(p4) -- line: 75
        -- upvalues: p3 (copy), t2 (copy), v4 (ref), step (copy), RunService (copy)
        if not p4:IsA("Beam") or t2[p4] ~= nil then
            return
        end

        local t3 = {
            Beam = p4
        }
        local Parent = p4.Parent
        local EggGlow = if Parent == nil then nil else Parent:FindFirstChild("EggGlow")

        t3.Glow = if EggGlow == nil or not EggGlow:IsA("PointLight") then nil else EggGlow
        t2[p4] = t3

        if v4 ~= nil then
            return
        end

        local v9 = p3:Extend()

        v9:Connect(RunService.RenderStepped, step)
        v4 = v9
    end

    local function untrack(p5) -- line: 91
        -- upvalues: p3 (copy), t2 (copy), v4 (ref)
        if t2[p5] == nil then
            return
        end

        t2[p5] = nil

        local v10 = v4

        if v10 ~= nil and next(t2) == nil then
            v4 = nil
            p3:Remove(v10)
        end
    end

    p3:Connect(CollectionService:GetInstanceAddedSignal("HalloweenChromaBeacon"), track)
    p3:Connect(CollectionService:GetInstanceRemovedSignal("HalloweenChromaBeacon"), untrack)
    p3:Add(function() -- line: 106
        -- upvalues: t2 (copy), v4 (ref)
        table.clear(t2)
        v4 = nil
    end)

    for _, v11 in CollectionService:GetTagged("HalloweenChromaBeacon") do
        track(v11)
    end
end

return t1
