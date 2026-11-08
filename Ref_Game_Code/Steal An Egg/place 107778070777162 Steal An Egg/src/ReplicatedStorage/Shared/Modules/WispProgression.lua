-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WispQuests = require(ReplicatedStorage.Data.WispQuests)
local WispCompanion = require(ReplicatedStorage.Shared.Types.WispCompanion)
local t1 = {
    IsReady = function(p1) -- IsReady | line: 6
        -- upvalues: WispQuests (copy)
        return p1.Accepted and p1.Stage == WispQuests.StageCount and not p1.Unlocked
    end,
    HasClaimable = function(p2) -- HasClaimable | line: 10
        -- upvalues: WispQuests (copy)
        local v1 = WispQuests.List[p2.Stage]

        return p2.Accepted and not p2.Unlocked and v1 ~= nil and not p2.Claimed[v1.Id] and (p2.Progress[v1.Id] or 0) >= v1.Target
    end,
    Progress = function(p3, p4, p5, p6) -- Progress | line: 16
        -- upvalues: WispQuests (copy), WispCompanion (copy)
        local v2 = WispQuests.List[p3.Stage]

        if not p3.Accepted
            or p3.Unlocked
            or not v2
            or p3.Claimed[v2.Id]
            or v2.Event ~= p4
            or typeof(p5) ~= "table" then
            return nil
        end

        for v3, v4 in v2.Match do
            if p5[v3] ~= v4 then
                return nil
            end
        end

        p6 = p6 or 1

        if typeof(p6) ~= "number" or p6 ~= p6 or p6 == 1e999 or p6 <= 0 then
            return nil
        end

        local v6 = p3.Progress[v2.Id] or 0
        local v8 = math.min(v2.Target, v6 + math.floor(p6))

        if v8 == v6 then
            return nil
        end

        local v9 = WispCompanion.Copy(p3)

        v9.Progress[v2.Id] = v8

        return v9
    end,
    Claim = function(p7, p8) -- Claim | line: 43
        -- upvalues: WispQuests (copy), WispCompanion (copy)
        local v10 = WispQuests.List[p7.Stage]

        if not p7.Accepted or p7.Unlocked or not v10 or v10.Id ~= p8 then
            return nil, "That quest is not active."
        end

        if p7.Claimed[p8] then
            return nil, "You already claimed that reward."
        end

        if (p7.Progress[p8] or 0) < v10.Target then
            return nil, "Finish the quest first."
        end

        local v11 = WispCompanion.Copy(p7)

        v11.Claimed[p8] = true
        v11.Stage += 1
        v11.Essence = 0

        return v11
    end
}

return table.freeze(t1)
