-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Areas = require(ReplicatedStorage.Data.Areas)
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local GuardEscapeRequirement = require(ReplicatedStorage.Shared.Modules.GuardAreas.GuardEscapeRequirement)
local Log = require(ReplicatedStorage.Packages.Log)
local RiftFlags = require(ReplicatedStorage.Shared.Flags.RiftFlags)
local t = require(ReplicatedStorage.Packages.t)
local v1 = Log.new()
local v2

local function resolveSpeed(p1, p2) -- line: 28
    -- upvalues: GuardEscapeRequirement (copy), v1 (copy)
    local Guard = p1:FindFirstChild("Guard")
    local HumanoidRootPart = if Guard == nil then nil else Guard:FindFirstChild("HumanoidRootPart")

    if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then
        local ResolveSpeedPower = GuardEscapeRequirement.ResolveSpeedPower
        local Position = HumanoidRootPart.Position
        local ok, result = pcall(ResolveSpeedPower, p1, Position, p2)

        if ok then
            return result
        end

        v1:AtWarning():Log((("Zone ladder could not resolve %*: %*"):format(p1.Name, result)))
    end

    return nil
end

local function computeSpeeds() -- line: 47
    -- upvalues: Workspace (copy), Areas (copy), Constants (copy), v1 (copy), resolveSpeed (copy)
    local v3 = Workspace:WaitForChild("World", 30)
    local v4 = if v3 == nil then nil else v3:WaitForChild("Areas", 30)

    assert(v4 ~= nil, "Workspace.World.Areas is required for the zone ladder")

    local v6 = v4:WaitForChild("GuardAreas", 30)
    local v7 = v4:WaitForChild("SeparationLine", 30)

    assert(v6 ~= nil, "Workspace.World.Areas.GuardAreas is required for the zone ladder")
    assert(v7 ~= nil and v7:IsA("BasePart"), "Workspace.World.Areas.SeparationLine must be a BasePart")

    local t1 = {}

    for v10 in Areas.Directory do
        local v11 = if Constants.IS_CLIENT then v6:WaitForChild(v10, 30) else v6:FindFirstChild(v10)

        if v11 ~= nil then
            if v11:IsA("Model") then
                local v12 = resolveSpeed(v11, v7)

                if v12 ~= nil then
                    t1[v10] = v12
                end
            else
                v1:AtWarning():Log((("Zone ladder skipped %*: no guard area model"):format(v10)))
            end
        else
            v1:AtWarning():Log((("Zone ladder skipped %*: no guard area model"):format(v10)))
        end
    end

    return t1
end

local function speeds() -- line: 76
    -- upvalues: v2 (ref), computeSpeeds (copy)
    local v13 = v2

    if v13 == nil then
        v13 = computeSpeeds()
        v2 = v13
    end

    return v13
end

local t2 = {}

function t2.Get() -- line: 87
    -- upvalues: Areas (copy), RiftFlags (copy), v2 (ref), computeSpeeds (copy)
    local v14 = v2

    if v14 == nil then
        v14 = computeSpeeds()
        v2 = v14
    end

    local t3 = {}
    local v15 = RiftFlags.ZoneLadderOverride:Get()

    if #v15 > 0 then
        for _, v16 in v15 do
            if Areas.Directory[v16] ~= nil then
                table.insert(t3, {
                    Id = v16,
                    SpeedPower = v14[v16] or 0
                })
            end
        end
    else
        for v17, v18 in v14 do
            table.insert(t3, {
                Id = v17,
                SpeedPower = v18
            })
        end

        table.sort(t3, function(p3, p4) -- line: 104
            if p3.SpeedPower == p4.SpeedPower then
                return p3.Id < p4.Id
            end

            return p3.SpeedPower < p4.SpeedPower
        end)
    end

    return t3
end

function t2.IndexOf(p5) -- line: 113
    -- upvalues: t (copy), t2 (copy)
    t.strict(t.string)(p5)

    for v19, v20 in t2.Get() do
        if v20.Id == p5 then
            return v19
        end
    end

    return nil
end

function t2.SpeedPowerFor(p6) -- line: 123
    -- upvalues: t (copy), v2 (ref), computeSpeeds (copy)
    t.strict(t.string)(p6)

    local v21 = v2

    if v21 == nil then
        v21 = computeSpeeds()
        v2 = v21
    end

    return v21[p6]
end

function t2.Invalidate() -- line: 128
    -- upvalues: v2 (ref)
    v2 = nil
end

return t2
