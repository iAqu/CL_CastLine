-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags)
local t = require(ReplicatedStorage.Packages.t)

local function typecheckAssertion(p1) -- line: 14
    return function(p2) -- line: 15
        -- upvalues: p1 (copy)
        local v1, v2 = p1(p2)

        assert(v1, v2)

        return p2
    end
end

local function typecheckChecker(p3) -- line: 21
    return function(p4) -- line: 22
        -- upvalues: p3 (copy)
        local ok, result = pcall(p3, p4)

        if ok then
            return ok, nil
        end

        return ok, (tostring(result))
    end
end

require(ReplicatedStorage.Shared.Globals.Constants)

local Signal = require(ReplicatedStorage.Packages.Signal)
local TreadmillMediaCatalog = require(ReplicatedStorage.Data.TreadmillMediaCatalog)
local TreadmillMediaIdentity = require(ReplicatedStorage.Shared.Modules.TreadmillMediaIdentity)
local Media = require(ReplicatedStorage.Shared.TreadmillVideoController.Media)

require(ReplicatedStorage.Shared.TreadmillVideoController.Types.Interface)

local t1 = {
    Brainrot = true,
    Funny = true,
    Satisfying = true,
    WeirdOrHorror = true,
    Music = true
}
local Replicated = FastFlags.Replicated
local boolean = t.boolean
local v3 = Replicated("Game.TreadmillDynamicMedia.Enabled", function(p5) -- line: 15
    -- upvalues: boolean (copy)
    local v4, v5 = boolean(p5)

    assert(v4, v5)

    return p5
end, true)
local n1 = 0
local v6 = {}
local t2 = {}
local t3 = {}
local t4 = {}
local v7
local t5 = {}

for _, v8 in ipairs(Media) do
    if v8.Disabled == true then
        t5[TreadmillMediaIdentity.GetMediaKey(v8)] = true
    end
end

local t6 = {
    Changed = Signal.new()
}

local function sanitizeAddition(p6) -- line: 94
    -- upvalues: t1 (copy)
    if type(p6) ~= "table" then
        return nil
    end

    local v9 = p6.Kind == "Video"
    local v10 = if v9 then type(p6.Video) == "string" else nil

    if v9 and v10 and type(p6.MediaKey) == "string" and p6.MediaKey ~= "" and type(p6.BucketType) == "string" and t1[p6.BucketType] == true and type(p6.Duration) == "number" and not (p6.Duration <= 0) then
        local v11 = type(p6.AddedAt) == "number"
        local v12 = if v11 then type(p6.AddedBy) == "number" else nil

        if v11 and v12 then
            local v13 = p6.CoverImage == nil
            local v14 = if not v13 then type(p6.CoverImage) == "string" else nil

            if v13 or v14 then
                return {
                    Kind = "Video",
                    MediaKey = p6.MediaKey,
                    Video = p6.Video,
                    CoverImage = p6.CoverImage,
                    BucketType = p6.BucketType,
                    Duration = p6.Duration,
                    AddedAt = p6.AddedAt,
                    AddedBy = p6.AddedBy
                }
            end
        end
    end

    return nil
end

local function compareAdditions(p7, p8) -- line: 129
    if p7.AddedAt == p8.AddedAt then
        return p7.MediaKey < p8.MediaKey
    end

    return p7.AddedAt < p8.AddedAt
end

local function applySanitizedSnapshot(p9) -- line: 136
    -- upvalues: TreadmillMediaCatalog (copy), n1 (ref), v6 (ref), t2 (ref), t3 (ref), t4 (copy), t6 (copy)
    n1 = p9.Revision
    v6 = p9.Additions
    t3 = {}

    for v15 in pairs(p9.Exclusions) do
        local t7 = t3

        t7[v15] = true
    end

    t2 = {}

    for _, v16 in ipairs(v6) do
        local t8 = t2

        t8[v16.MediaKey] = v16
    end

    for v17, v18 in ipairs(v6) do
        local v19 = TreadmillMediaCatalog.CURRENT_RELEASE_VERSION + v17
        local v20 = t4[v18.MediaKey]

        if v20 ~= nil then
            v20.ReleaseVersion = v19
        else
            t4[v18.MediaKey] = {
                Kind = "Video",
                ReleaseVersion = v19,
                BucketType = v18.BucketType,
                Video = v18.Video,
                CoverImage = v18.CoverImage,
                Duration = v18.Duration
            }
        end
    end

    t6.Changed:Fire()
end

function t6.SanitizeSnapshot(p10) -- line: 175
    -- upvalues: sanitizeAddition (copy), compareAdditions (copy)
    if type(p10) ~= "table" or type(p10.Revision) ~= "number" or p10.Revision < 0 then
        return nil
    end

    local t9 = {}
    local t10 = {}

    if type(p10.Additions) == "table" then
        for _, v21 in ipairs(p10.Additions) do
            local v22 = sanitizeAddition(v21)

            if v22 ~= nil and not t10[v22.MediaKey] then
                t10[v22.MediaKey] = true
                table.insert(t9, v22)
            end
        end
    end

    table.sort(t9, compareAdditions)

    local t11 = {}

    if type(p10.Exclusions) == "table" then
        for v23, v24 in pairs(p10.Exclusions) do
            if type(v23) == "string" and type(v24) == "table" then
                t11[v23] = {
                    At = if type(v24.At) == "number" then v24.At else 0,
                    By = if type(v24.By) == "number" then v24.By else 0
                }
            end
        end
    end

    return {
        Revision = math.floor(p10.Revision),
        Additions = t9,
        Exclusions = t11
    }
end

function t6.ApplySnapshot(p11) -- line: 217
    -- upvalues: v3 (copy), n1 (ref), v7 (ref), t6 (copy), applySanitizedSnapshot (copy)
    local v25 = t6.SanitizeSnapshot(p11)

    if v25 ~= nil then
        v7 = v25

        if v3:Get() and v25.Revision ~= n1 then
            applySanitizedSnapshot(v25)
        end
    end
end

function t6.ApplyTo(p12) -- line: 236
    -- upvalues: TreadmillMediaIdentity (copy), v6 (ref), t4 (copy)
    if #v6 == 0 then
        return 0
    end

    local t14 = {}

    for _, v26 in ipairs(p12) do
        t14[TreadmillMediaIdentity.GetMediaKey(v26)] = true
    end

    local n2 = 0

    for _, v27 in ipairs(v6) do
        if not t14[v27.MediaKey] then
            t14[v27.MediaKey] = true
            table.insert(p12, t4[v27.MediaKey])
            n2 += 1
        end
    end

    return n2
end

function t6.IsExcluded(p13) -- line: 258
    -- upvalues: v3 (copy), t3 (ref), t5 (copy)
    if t5[p13] then
        return true
    end

    if v3:Get() then
        return t3[p13] == true
    end

    return false
end

function t6.GetCurrentReleaseVersion() -- line: 270
    -- upvalues: TreadmillMediaCatalog (copy), v6 (ref)
    return TreadmillMediaCatalog.CURRENT_RELEASE_VERSION + #v6
end

function t6.GetRevision() -- line: 274
    -- upvalues: n1 (ref)
    return n1
end

function t6.GetAdditionByKey(p14) -- line: 276
    -- upvalues: t2 (ref)
    return t2[p14]
end

function t6.GetAdditions() -- line: 280
    -- upvalues: v6 (ref)
    return v6
end

function t6.GetEntryByKey(p15) -- line: 282
    -- upvalues: t4 (copy)
    return t4[p15]
end

function t6.GetReplicationSnapshot() -- line: 286
    -- upvalues: v7 (ref)
    return v7
end

v3.Changed:Connect(function() -- line: 288
    -- upvalues: v3 (copy), n1 (ref), v7 (ref), applySanitizedSnapshot (copy)
    local v29 = v7

    if v3:Get() and v29 ~= nil and v29.Revision ~= n1 then
        applySanitizedSnapshot(v29)
    end
end)

if RunService:IsClient() then
    require(ReplicatedStorage.Shared.Remotes).Treadmill.OverlaySnapshot.OnClientEvent:Connect(function(p16) -- line: 298
        -- upvalues: t6 (copy)
        t6.ApplySnapshot(p16)
    end)
end

return t6
