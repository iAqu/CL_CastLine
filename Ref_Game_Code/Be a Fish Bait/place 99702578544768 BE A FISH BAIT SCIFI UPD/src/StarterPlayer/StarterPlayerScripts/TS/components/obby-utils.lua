-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local services = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, Players = services.CollectionService, services.Players
local elapsed

return {
    getObbyStartCFrame = function() -- getObbyStartCFrame | line: 13
        -- upvalues: CollectionService (copy)
        local v1 = CollectionService:GetTagged("ObbyStart")[1]

        return if if v1 == nil then v1 else v1:IsA("BasePart") then v1.CFrame + Vector3.new(0, v1.Size.Y / 2 + 3, 0) else nil
    end,
    teleportLocalPlayerToObbyStart = function() -- teleportLocalPlayerToObbyStart | line: 27
        -- upvalues: CollectionService (copy), Players (copy)
        local v3 = CollectionService:GetTagged("ObbyStart")[1]
        local v5 = if if v3 == nil then v3 else v3:IsA("BasePart") then v3.CFrame + Vector3.new(0, v3.Size.Y / 2 + 3, 0) else nil
        local Character = Players.LocalPlayer.Character

        if v5 and Character then
            Character:PivotTo(v5)
        end
    end,
    handleLocalObbyHazardTouched = function(p1) -- handleLocalObbyHazardTouched | line: 43
        -- upvalues: CollectionService (copy), Players (copy), elapsed (ref)
        if p1.Parent ~= Players.LocalPlayer.Character then
            return nil
        end

        local elapsed2 = os.clock()

        if elapsed ~= nil and elapsed2 - elapsed < 1 then
            return nil
        end

        elapsed = elapsed2

        local v7 = CollectionService:GetTagged("ObbyStart")[1]
        local v9 = if if v7 == nil then v7 else v7:IsA("BasePart") then v7.CFrame + Vector3.new(0, v7.Size.Y / 2 + 3, 0) else nil
        local Character = Players.LocalPlayer.Character

        if v9 and Character then
            Character:PivotTo(v9)
        end
    end
}
