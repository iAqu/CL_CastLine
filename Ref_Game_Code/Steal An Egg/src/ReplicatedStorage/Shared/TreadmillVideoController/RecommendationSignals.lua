-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RecommendationService = game:GetService("RecommendationService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Log = require(ReplicatedStorage.Packages.Log)

require(script.Parent.RecommendationFeedSource)

local RecommendationFlags = require(script.Parent.RecommendationFlags)
local v1 = Log.new()
local t1
local t2 = {}

local function resolveDepartureIntent(p1, p2, p3) -- line: 30
    if p1.Ended or p1.Engaged or p3 ~= nil and p3 >= 0.8 then
        return Enum.RecommendationDepartureIntent.Positive
    end

    if not (p2 < 3) and (p3 == nil or not (p3 < 0.25)) then
        return Enum.RecommendationDepartureIntent.Neutral
    end

    return Enum.RecommendationDepartureIntent.Negative
end

local function logAction(p4, p5, p6) -- line: 50
    -- upvalues: RecommendationService (copy), RecommendationFlags (copy), v1 (copy)
    if not RecommendationFlags.Enabled:Get() then
        return
    end

    local function v2() -- line: 60
        -- upvalues: p4 (copy), p5 (copy), p6 (copy), RecommendationService (copy)
        RecommendationService:LogActionEvent(p5, p4.ItemId, p4.TracingId, p6)
    end

    local ok, result = pcall(v2)

    if not ok then
        v1:AtWarning():Log((("Failed to log treadmill recommendation action: %*"):format(result)))
    end
end

function t2.HasActiveView() -- line: 69
    -- upvalues: t1 (ref)
    return t1 ~= nil
end

function t2.EndView(p7) -- line: 71
    -- upvalues: RecommendationService (copy), RecommendationFlags (copy), v1 (copy), t1 (ref), resolveDepartureIntent (copy)
    local t3 = t1

    t1 = nil

    if t3 == nil or not RecommendationFlags.Enabled:Get() then
        return
    end

    local v3 = os.clock() - t3.StartedAt
    local v4 = resolveDepartureIntent(t3, v3, p7)

    local function v5() -- line: 85
        -- upvalues: t3 (copy), v3 (copy), v4 (copy), RecommendationService (copy)
        RecommendationService:LogImpressionEvent(Enum.RecommendationImpressionType.View, t3.Item.ItemId, t3.Item.TracingId, {
            Weight = 1,
            Duration = v3,
            ItemPosition = t3.Item.ItemPosition,
            DepartureIntent = v4
        })
    end

    local ok, result = pcall(v5)

    if not ok then
        v1:AtWarning():Log((("Failed to log treadmill recommendation impression: %*"):format(result)))
    end
end

function t2.BeginView(p8) -- line: 104
    -- upvalues: t1 (ref), t2 (copy)
    t2.EndView(nil)
    t1 = {
        Ended = false,
        Engaged = false,
        Item = p8,
        StartedAt = os.clock()
    }
end

function t2.MarkEnded() -- line: 114
    -- upvalues: t1 (ref)
    local t4 = t1

    if t4 ~= nil then
        t4.Ended = true
    end
end

function t2.NotifyLikeResult(p9, p10) -- line: 121
    -- upvalues: t1 (ref), logAction (copy)
    local t5 = t1
    local v6 = true

    if t5 ~= nil then
        if t5.Item.MediaKey == p9 then
            if p10 then
                t5.Engaged = true
            end

            v6 = false
        end
    end

    if v6 then
        return
    end

    logAction(t5.Item, if p10 then Enum.RecommendationActionType.AddReaction else Enum.RecommendationActionType.RemoveReaction, {
        ReactionType = "Like"
    })
end

function t2.NotifyCommentPosted(p11) -- line: 139
    -- upvalues: t1 (ref), logAction (copy)
    local t6 = t1

    if t6 ~= nil and t6.Item.MediaKey == p11 then
        t6.Engaged = true
        logAction(t6.Item, Enum.RecommendationActionType.Comment, nil)
    end
end

function t2.NotifyShared() -- line: 149
    -- upvalues: t1 (ref), logAction (copy)
    local t7 = t1

    if t7 ~= nil then
        t7.Engaged = true
        logAction(t7.Item, Enum.RecommendationActionType.Share, nil)
    end
end

return t2
