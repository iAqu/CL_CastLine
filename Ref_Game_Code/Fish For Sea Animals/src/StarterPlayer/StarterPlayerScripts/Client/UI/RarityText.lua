-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage.Shared.Config)
local t2 = {}
local t1 = {}

function t1.paint(p1, p2) -- line: 17
    -- upvalues: CollectionService (copy), Config (copy)
    local v1 = p1:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")

    v1.Color = Config.rarityGradient(p2)
    v1.Rotation = 90
    v1.Parent = p1

    if p2.Shine then
        CollectionService:AddTag(v1, "RarityShine")
    else
        CollectionService:RemoveTag(v1, "RarityShine")
    end

    return v1
end

function t1.apply(p3, p4) -- line: 30
    -- upvalues: t1 (copy)
    p3.TextColor3 = Color3.new(1, 1, 1)

    return t1.paint(p3, p4)
end

function t1.init() -- line: 35
    -- upvalues: CollectionService (copy), RunService (copy), t2 (copy)
    CollectionService:GetInstanceAddedSignal("RarityShine"):Connect(function(p5) -- line: 36
        -- upvalues: t2 (copy)
        t2[p5] = true
    end)
    CollectionService:GetInstanceRemovedSignal("RarityShine"):Connect(function(p6) -- line: 39
        -- upvalues: t2 (copy)
        t2[p6] = nil

        if p6:IsA("UIGradient") then
            p6.Rotation = 90
        end
    end)

    for _, v2 in CollectionService:GetTagged("RarityShine") do
        t2[v2] = true
    end

    RunService.RenderStepped:Connect(function() -- line: 48
        -- upvalues: t2 (copy)
        local v3 = os.clock() * 70 % 360

        for v4 in t2 do
            if v4.Parent then
                v4.Rotation = v3
            end
        end
    end)
end

return t1
