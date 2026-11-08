-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = require(ReplicatedStorage.Data.Assets)

require(ReplicatedStorage.Shared.Types.AssetItem)

local t2 = {
    Male = "rbxassetid://88627876961976",
    Female = "rbxassetid://98782480225988"
}
local t1 = {}

function t1.BadgeImage(p1) -- line: 18
    -- upvalues: t2 (copy)
    return t2[p1] or "rbxassetid://98782480225988"
end

function t1.IsTag(p2) -- line: 22
    if p2 == "Male" then
        return true
    end

    return p2 == "Female"
end

function t1.Draw(p3) -- line: 26
    if (p3 or Random.new()):NextInteger(1, 2) == 1 then
        return "Male"
    end

    return "Female"
end

function t1.Settle(p4, p5, p6) -- line: 31
    -- upvalues: Assets (copy), t1 (copy)
    if t1.IsTag(p5) then
        return p5
    end

    local GenderLocked = Assets.Directory[p4].GenderLocked

    if t1.IsTag(GenderLocked) then
        return GenderLocked
    end

    return (t1.Draw(p6))
end

return t1
