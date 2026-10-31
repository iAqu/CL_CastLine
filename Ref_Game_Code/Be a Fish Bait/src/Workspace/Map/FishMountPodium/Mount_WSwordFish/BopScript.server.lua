-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Parent = script.Parent
local PrimaryPart = Parent.PrimaryPart

if not PrimaryPart then
    error("Please set a PrimaryPart for the fish model!")
end

local _CFrame = PrimaryPart.CFrame
local RunService = game:GetService("RunService")
local n1 = 0

RunService.Heartbeat:Connect(function(p1) -- line: 18
    -- upvalues: Parent (copy), _CFrame (copy), n1 (ref)
    n1 += p1

    local v2 = math.sin(n1 * 2) * 1.25
    local v4 = math.sin(n1 * 2) * 0.17453292519943295

    Parent:PivotTo(_CFrame * (CFrame.new(0, v2, 0) * CFrame.Angles(0, v4, 0)))
end)
