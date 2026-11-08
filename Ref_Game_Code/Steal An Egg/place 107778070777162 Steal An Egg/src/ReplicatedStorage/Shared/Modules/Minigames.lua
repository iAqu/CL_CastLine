-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = require(ReplicatedStorage.Data.Assets)
local Log = require(ReplicatedStorage.Packages.Log)
local Mutations = require(ReplicatedStorage.Shared.Modules.Mutations)
local v1 = table.freeze({ "CaptureTheEgg", "RedLightGreenLight", "TrexRun" })
local v2 = Log.new()
local t1 = {
    Names = v1,
    IsMinigame = function(p1) -- IsMinigame | line: 37
        -- upvalues: v1 (copy)
        return table.find(v1, p1) ~= nil
    end,
    ResolveEgg = function(p2, p3, p4) -- ResolveEgg | line: 41
        -- upvalues: Assets (copy), Mutations (copy), v2 (copy)
        local t2 = {
            Mutation = nil,
            Carry = p3,
            Reward = p4
        }
        local v3 = if type(p2) == "table" then p2 else {}
        local EggCategory = v3.EggCategory

        if type(EggCategory) == "string" and EggCategory ~= "" then
            local v4, v5 = Assets.AssetNameExists(EggCategory)

            if v4 then
                t2.Carry = EggCategory
                t2.Reward = EggCategory
            else
                v2:AtWarning():Log((("[Minigames] %*"):format(v5)))
            end
        end

        local Mutation = v3.Mutation

        if type(Mutation) == "string" and Mutation ~= "" and Mutations.Get(Mutation) ~= nil then
            t2.Mutation = Mutation
        end

        return t2
    end,
    EggIcon = function(p5, p6) -- EggIcon | line: 79
        -- upvalues: Assets (copy)
        local v6 = Assets.Directory[p5]
        local Icon = if v6 == nil then nil else v6.Egg.Icon

        if Icon == nil or Icon == "" then
            return p6
        end

        return Icon
    end,
    EggLabel = function(p7, p8, p9) -- EggLabel | line: 90
        -- upvalues: Assets (copy), Mutations (copy)
        local v7 = Assets.Directory[p7]

        if v7 == nil then
            return p9
        end

        local v8 = ("<font color=\"#%*\">%*</font>"):format(v7.Rarity.Color:ToHex(), v7.Egg.DisplayName)

        if p8 ~= nil then
            local v9 = Mutations.Get(p8)

            if v9 ~= nil then
                v8 = ("<font color=\"#%*\">%*</font> %*"):format(v9.Tint:ToHex(), v9.Label, v8)
            end
        end

        return v8
    end,
    EscapeRichText = function(p10) -- EscapeRichText | line: 112
        return (p10:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
    end
}

return table.freeze(t1)
