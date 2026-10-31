-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").CollectionService
local t1 = {}

local function trackWaterSwimZone(p1) -- line: 5
    -- upvalues: t1 (copy)
    if p1:IsA("BasePart") then
        t1[p1] = true
    end
end

for _, v1 in CollectionService:GetTagged("WaterSwimZone") do
    if v1:IsA("BasePart") then
        t1[v1] = true
    end
end

CollectionService:GetInstanceAddedSignal("WaterSwimZone"):Connect(trackWaterSwimZone)
CollectionService:GetInstanceRemovedSignal("WaterSwimZone"):Connect(function(p2) -- line: 15
    -- upvalues: t1 (copy)
    if p2:IsA("BasePart") then
        t1[p2] = nil
    end
end)

return {
    isPointInsideWaterSwimZone = function(p3, p4) -- isPointInsideWaterSwimZone | line: 22
        -- upvalues: t1 (copy)
        local v2 = if p4 == nil then 0 else p4

        for v3 in t1 do
            local v4 = v3.CFrame:PointToObjectSpace(p3)
            local v5 = v3.Size / 2

            if math.abs(v4.X) <= v5.X and math.abs(v4.Y) <= v5.Y + v2 and math.abs(v4.Z) <= v5.Z then
                return true
            end
        end

        return false
    end
}
