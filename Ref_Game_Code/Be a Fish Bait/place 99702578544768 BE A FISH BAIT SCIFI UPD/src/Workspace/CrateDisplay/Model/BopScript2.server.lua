-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Parent = script.Parent
local _CFrame = Parent:WaitForChild("Crate2Preview"):WaitForChild("RootPart2").CFrame
local RunService = game:GetService("RunService")
local n1 = 0

RunService.Heartbeat:Connect(function(p1) -- line: 16
    -- upvalues: Parent (copy), _CFrame (copy), n1 (ref)
    n1 += p1

    local v2 = math.sin(n1 * 1) * 2
    local v4 = math.sin(n1 * 1) * 0.017453292519943295

    Parent:PivotTo(_CFrame * (CFrame.new(0, v2, 0) * CFrame.Angles(0, v4, 0)))
end)
