-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ObserveUITag = require(ReplicatedStorage.Client.ObserveUITag)

require(ReplicatedStorage.Packages.Trove)

local t1 = {}
local connection

local function StepSpins(p1) -- line: 22
    -- upvalues: t1 (copy)
    for v1, v2 in t1 do
        v1.Rotation = (v1.Rotation + v2 * p1) % 360
    end
end

local function StartSpin(p2, p3) -- line: 28
    -- upvalues: RunService (copy), t1 (copy), connection (ref), StepSpins (copy)
    local SpinSpeed = p2:GetAttribute("SpinSpeed")

    if type(SpinSpeed) ~= "number" then
        SpinSpeed = 20
    end

    t1[p2] = SpinSpeed

    if connection == nil then
        connection = RunService.RenderStepped:Connect(StepSpins)
    end

    p3:Add(function() -- line: 36
        -- upvalues: p2 (copy), t1 (copy), connection (ref)
        t1[p2] = nil

        if next(t1) ~= nil or connection == nil then
            return
        end

        connection:Disconnect()
        connection = nil
    end)
end

ObserveUITag("Spin", function(p4, p5) -- PlaySpin | line: 45
    -- upvalues: StartSpin (copy)
    if p4:IsA("GuiObject") then
        StartSpin(p4, p5)
    else
        warn((("Spin tag on %* needs a GuiObject"):format((p4:GetFullName()))))
    end
end)

return nil
