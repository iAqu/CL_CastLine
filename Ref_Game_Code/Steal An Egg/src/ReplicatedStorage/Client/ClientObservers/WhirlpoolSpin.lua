-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Observers = require(ReplicatedStorage.Packages.Observers)
local SewerCave = require(ReplicatedStorage.Shared.Util.SewerCave)
local v1 = table.freeze({
    ["1"] = 90,
    ["2"] = 70,
    ["3"] = 55
})

local function GetRings(p1, p2) -- line: 30
    -- upvalues: v1 (copy)
    local t1 = {}

    for v2, v3 in v1 do
        local v4 = p1:FindFirstChild(v2)

        if v4 ~= nil then
            for _, descendant in v4:GetDescendants() do
                if descendant:IsA("BasePart") then
                    table.insert(t1, {
                        Part = descendant,
                        Offset = p2:ToObjectSpace(descendant.CFrame),
                        Speed = math.rad(v3)
                    })
                end
            end
        else
            warn((("%* is missing ring folder %*"):format(p1:GetFullName(), v2)))
        end
    end

    return t1
end

local function SpinWhirlpool(p3) -- line: 52
    -- upvalues: RunService (copy), GetRings (copy)
    local v5 = CFrame.new(p3:GetBoundingBox().Position)
    local Position = v5.Position
    local v6 = GetRings(p3, v5)

    if #v6 == 0 then
        return nil
    end

    local v7 = table.create(#v6)
    local v8 = table.create(#v6)

    for v9, v10 in v6 do
        v7[v9] = v10.Part
        v8[v9] = v10.Part.CFrame
    end

    local elapsed = os.clock()
    local connection = RunService.PreRender:Connect(function() -- line: 68
        -- upvalues: v5 (copy), Position (copy), v6 (copy), v7 (copy), v8 (copy), elapsed (copy)
        local CurrentCamera = workspace.CurrentCamera

        if CurrentCamera == nil or (CurrentCamera.CFrame.Position - Position).Magnitude > 1000 then
            return
        end

        local v11 = os.clock() - elapsed

        for v12, v13 in v6 do
            v8[v12] = v5 * CFrame.Angles(0, v13.Speed * v11, 0) * v13.Offset
        end

        workspace:BulkMoveTo(v7, v8, Enum.BulkMoveMode.FireCFrameChanged)
    end)

    return function() -- line: 83
        -- upvalues: connection (copy)
        connection:Disconnect()
    end
end

local function ObserveWhirlpool(p4) -- line: 88
    -- upvalues: SewerCave (copy), SpinWhirlpool (copy)
    if p4:IsA("Model") then
        return (SpinWhirlpool(p4))
    end

    warn((("%* tag on %* needs a Model"):format(SewerCave.WhirlpoolTag, (p4:GetFullName()))))

    return nil
end

Observers.observeTag(SewerCave.WhirlpoolTag, ObserveWhirlpool, { workspace })

return nil
