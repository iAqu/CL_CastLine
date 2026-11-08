-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Shared.Modules.TreadmillMediaIdentity.Types.Interface)

local t = require(ReplicatedStorage.Packages.t)

require(ReplicatedStorage.Shared.TreadmillVideoController.Types.Interface)

local t1 = {}

local function extractAssetId(p1) -- line: 23
    local v1 = string.match(p1, "%d+")

    assert(v1 ~= nil and v1 ~= "", (("Invalid treadmill media asset id \"%*\""):format(p1)))

    return v1
end

function t1.GetMediaKey(p2) -- line: 33
    -- upvalues: t (copy)
    t.strict(t.table)(p2)

    if p2.Kind == "Video" then
        local Video = p2.Video
        local v4 = string.match(Video, "%d+")

        assert(v4 ~= nil and v4 ~= "", (("Invalid treadmill media asset id \"%*\""):format(Video)))

        return (("Video:%*"):format(v4))
    end

    local Image = p2.Image
    local v7 = string.match(Image, "%d+")

    assert(v7 ~= nil and v7 ~= "", (("Invalid treadmill media asset id \"%*\""):format(Image)))

    return (("Image:%*"):format(v7))
end

function t1.BuildMediaKeys(p3) -- line: 43
    -- upvalues: t (copy), t1 (copy)
    t.strict(t.table)(p3)

    local t2 = {}
    local t3 = {}

    for _, v10 in ipairs(p3) do
        local v11 = t1.GetMediaKey(v10)

        if not t3[v11] then
            t3[v11] = true
            table.insert(t2, v11)
        end
    end

    return t2, t3
end

function t1.GetMediaKeyShardIndex(p4, p5) -- line: 64
    -- upvalues: t (copy)
    t.strict(t.string)(p4)
    t.strict(t.intersection(t.integer, t.numberPositive))(p5)

    local n1 = 0

    for i = 1, #p4 do
        n1 = (n1 * 33 + string.byte(p4, i)) % p5
    end

    return n1
end

return t1
