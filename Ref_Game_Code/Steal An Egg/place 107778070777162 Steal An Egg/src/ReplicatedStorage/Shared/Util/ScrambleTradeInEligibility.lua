-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local GuardEscapeRequirement = require(ReplicatedStorage.Shared.Modules.GuardAreas.GuardEscapeRequirement)
local ScrambleTradeInFlags = require(ReplicatedStorage.Shared.Flags.ScrambleTradeInFlags)
local t1 = {
    Changed = require(ReplicatedStorage.Packages.Signal).new()
}

local function cosmicArea() -- line: 10
    -- upvalues: Workspace (copy)
    local World = Workspace:FindFirstChild("World")
    local Areas = World and World:FindFirstChild("Areas")
    local GuardAreas = Areas and Areas:FindFirstChild("GuardAreas")
    local Cosmic = GuardAreas and GuardAreas:FindFirstChild("Cosmic")

    return if Cosmic and Cosmic:IsA("Model") then Cosmic else nil
end

function t1.RequiredSpeedPower() -- line: 18
    -- upvalues: GuardEscapeRequirement (copy), ScrambleTradeInFlags (copy), cosmicArea (copy)
    local v1 = cosmicArea()
    local v2 = v1 and v1:GetAttribute(GuardEscapeRequirement.SIGN_SPEEDS_ATTRIBUTE)

    return if typeof(v2) == "Vector2" and not (v2.X <= 0) and not (v2.X >= 1e999) and v2.X == v2.X then math.max(v2.X, ScrambleTradeInFlags.SpeedPowerRequirement:Get()) else nil
end

function t1.IsEligible(p1) -- line: 27
    -- upvalues: t1 (copy)
    local v3 = t1.RequiredSpeedPower()

    return v3 ~= nil and v3 <= p1
end

task.spawn(function() -- line: 32
    -- upvalues: Workspace (copy), GuardEscapeRequirement (copy), t1 (copy), cosmicArea (copy)
    local GuardAreas = Workspace:WaitForChild("World"):WaitForChild("Areas"):WaitForChild("GuardAreas")
    local v4, connection

    local function bind() -- line: 36
        -- upvalues: v4 (ref), connection (ref), GuardEscapeRequirement (copy), t1 (copy), cosmicArea (copy)
        local v5 = cosmicArea()

        if v5 == v4 then
            return
        end

        if connection then
            connection:Disconnect()
            connection = nil
        end

        v4 = v5

        if v5 then
            connection = v5:GetAttributeChangedSignal(GuardEscapeRequirement.SIGN_SPEEDS_ATTRIBUTE):Connect(function() -- line: 47
                -- upvalues: t1 (copy)
                t1.Changed:Fire()
            end)
        end

        t1.Changed:Fire()
    end

    GuardAreas.ChildAdded:Connect(function(p2) -- line: 53
        -- upvalues: bind (copy)
        if p2.Name == "Cosmic" then
            bind()
        end
    end)
    GuardAreas.ChildRemoved:Connect(function(p3) -- line: 58
        -- upvalues: bind (copy)
        if p3.Name == "Cosmic" then
            bind()
        end
    end)
    bind()
end)

return table.freeze(t1)
