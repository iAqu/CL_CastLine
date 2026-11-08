-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TreadmillFlags = require(ReplicatedStorage.Shared.Flags.TreadmillFlags)

require(ReplicatedStorage.Shared.Globals.Constants)

local TreadmillMediaComments = require(ReplicatedStorage.Shared.Types.TreadmillMediaComments)
local Log = require(ReplicatedStorage.Packages.Log)
local RecommendationSignals = require(ReplicatedStorage.Shared.TreadmillVideoController.RecommendationSignals)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Signal = require(ReplicatedStorage.Packages.Signal)
local TreadmillMediaCommentsConfig = require(ReplicatedStorage.Shared.Modules.TreadmillMediaCommentsConfig)
local t = require(ReplicatedStorage.Packages.t)
local TryCall = require(ReplicatedStorage.Shared.Utils.TryCall)
local Schema = TreadmillMediaComments.Schema

require(script.Types.Interface)

local v1 = Log.new()
local t1 = {}
local t2 = {}
local v2 = false
local v3 = false
local t3 = {}
local t4 = {
    CommentCountChanged = Signal.new()
}

local function getInvokeError(p1) -- line: 49
    if typeof(p1) == "string" then
        return p1
    end

    return "RequestFailed"
end

local function setCachedCommentCount(p2, p3) -- line: 57
    -- upvalues: t1 (copy), t4 (copy)
    local v5 = math.max(0, (math.floor(p3)))
    local v6 = t1[p2]

    if v6 ~= nil then
        v5 = math.max(v6, v5)
    end

    if v6 ~= v5 then
        t1[p2] = v5
        t4.CommentCountChanged:Fire(p2, v5)
    end
end

local function refreshCommentCountCache() -- line: 71
    -- upvalues: t1 (copy), t2 (copy), t3 (copy), t4 (copy)
    for _, v7 in t2 do
        local t5 = {}

        for _, v8 in v7 do
            t5[v8] = t3[v8] or 0
        end

        local v9 = t4.RequestCommentCounts(v7)

        if not v9.Ok then
            return "failed"
        end

        if not v9.Loaded then
            return "unloaded"
        end

        for v10, v11 in v9.CountsByMediaKey do
            if (t3[v10] or 0) == t5[v10] then
                local v13 = math.max(0, (math.floor(v11)))
                local v14 = t1[v10]

                if v14 ~= nil then
                    v13 = math.max(v14, v13)
                end

                if v14 ~= v13 then
                    t1[v10] = v13
                    t4.CommentCountChanged:Fire(v10, v13)
                end
            end
        end
    end

    return "loaded"
end

local function startCommentCountRefreshLoop() -- line: 100
    -- upvalues: TreadmillFlags (copy), v2 (ref), v3 (ref), refreshCommentCountCache (copy)
    task.spawn(function() -- line: 101
        -- upvalues: TreadmillFlags (copy), v2 (ref), v3 (ref), refreshCommentCountCache (copy)
        while v3 do
            if TreadmillFlags.CommentsDisabled:Get() then
                task.wait(5)
            else
                if refreshCommentCountCache() == "loaded" then
                    v2 = true
                end

                local v15 = v2 and 180 or 2

                task.wait(v15)
            end
        end
    end)
end

function t4.StartCommentCountCache(p4) -- line: 123
    -- upvalues: TreadmillFlags (copy), TreadmillMediaCommentsConfig (copy), t (copy), t2 (copy), v2 (ref), v3 (ref), refreshCommentCountCache (copy)
    t.strict(t.table)(p4)

    if v3 then
        return
    end

    v3 = true

    local t6 = {}
    local t7 = {}

    for _, v16 in p4 do
        t.strict(t.string)(v16)

        if not t6[v16] then
            t6[v16] = true
            table.insert(t7, v16)

            if #t7 >= TreadmillMediaCommentsConfig.COMMENT_COUNT_KEYS_PER_REQUEST then
                table.insert(t2, t7)
                t7 = {}
            end
        end
    end

    if #t7 > 0 then
        table.insert(t2, t7)
    end

    task.spawn(function() -- line: 101
        -- upvalues: TreadmillFlags (copy), v2 (ref), v3 (ref), refreshCommentCountCache (copy)
        while v3 do
            if TreadmillFlags.CommentsDisabled:Get() then
                task.wait(5)
            else
                if refreshCommentCountCache() == "loaded" then
                    v2 = true
                end

                local v17 = v2 and 180 or 2

                task.wait(v17)
            end
        end
    end)
end

function t4.GetCachedCommentCount(p5) -- line: 153
    -- upvalues: t (copy), t1 (copy)
    t.strict(t.string)(p5)

    return t1[p5]
end

function t4.ReconcileCommentCount(p6, p7) -- line: 158
    -- upvalues: t (copy), t1 (copy), t3 (copy), t4 (copy)
    t.strict(t.string)(p6)
    t.strict(t.number)(p7)
    t3[p6] = (t3[p6] or 0) + 1

    local v19 = math.max(0, (math.floor(p7)))
    local v20 = t1[p6]

    if v20 ~= nil then
        v19 = math.max(v20, v19)
    end

    if v20 ~= v19 then
        t1[p6] = v19
        t4.CommentCountChanged:Fire(p6, v19)
    end
end

function t4.RequestCommentPage(p8, p9, p10) -- line: 167
    -- upvalues: TreadmillFlags (copy), Remotes (copy), t (copy), TryCall (copy), Schema (copy), v1 (copy)
    if TreadmillFlags.CommentsDisabled:Get() then
        return {
            Ok = false,
            Error = "CommentsDisabled"
        }
    end

    t.strict(t.string)(p8)
    t.strict(t.optional(t.number))(p9)
    t.strict(t.optional(t.number))(p10)

    local v21, v22 = TryCall(function() -- line: 180
        -- upvalues: p8 (copy), p9 (copy), p10 (copy), Remotes (copy)
        return Remotes.Treadmill.AskReplyPage:InvokeServer({
            MediaKey = p8,
            Cursor = p9,
            PageSize = p10
        })
    end)

    if v21 then
        if Schema.CommentPageResult(v22) then
            if not v22.Ok then
                return {
                    Ok = false,
                    Error = v22.Error or "RequestFailed"
                }
            end

            return {
                Ok = true,
                TotalCreatedCount = v22.TotalCreatedCount or 0,
                Comments = v22.Comments or {},
                NextCursor = v22.NextCursor
            }
        end

        v1:AtWarning():Log("Rejected invalid treadmill comment page response")

        return {
            Ok = false,
            Error = "InvalidResponse"
        }
    end

    v1:AtWarning():Log((("Failed treadmill comment page request: %*"):format(v22)))

    return {
        Ok = false,
        Error = if typeof(v22) ~= "string" then "RequestFailed" else v22
    }
end

function t4.RequestCommentCounts(p11) -- line: 212
    -- upvalues: TreadmillFlags (copy), Remotes (copy), t (copy), TryCall (copy), Schema (copy), v1 (copy)
    if TreadmillFlags.CommentsDisabled:Get() then
        return {
            Ok = false,
            Error = "CommentsDisabled",
            Loaded = false,
            Stale = true,
            CountsByMediaKey = {}
        }
    end

    t.strict(t.table)(p11)

    local v23, v24 = TryCall(function() -- line: 219
        -- upvalues: p11 (copy), Remotes (copy)
        return Remotes.Treadmill.AskReplyCounts:InvokeServer({
            MediaKeys = p11
        })
    end)

    if v23 then
        if Schema.CommentCountsResult(v24) then
            if not v24.Ok then
                return {
                    Ok = false,
                    CountsByMediaKey = {},
                    Loaded = v24.Loaded == true,
                    Stale = v24.Stale ~= false,
                    Error = v24.Error or "RequestFailed"
                }
            end

            return {
                Ok = true,
                CountsByMediaKey = v24.CountsByMediaKey or {},
                Loaded = v24.Loaded == true,
                Stale = v24.Stale == true
            }
        end

        v1:AtWarning():Log("Rejected invalid treadmill comment counts response")

        return {
            Ok = false,
            Loaded = false,
            Stale = true,
            Error = "InvalidResponse",
            CountsByMediaKey = {}
        }
    end

    v1:AtWarning():Log((("Failed treadmill comment counts request: %*"):format(v24)))

    return {
        Ok = false,
        Loaded = false,
        Stale = true,
        CountsByMediaKey = {},
        Error = if typeof(v24) ~= "string" then "RequestFailed" else v24
    }
end

function t4.PostComment(p12, p13, p14) -- line: 267
    -- upvalues: TreadmillFlags (copy), RecommendationSignals (copy), Remotes (copy), t (copy), TryCall (copy), Schema (copy), v1 (copy)
    if TreadmillFlags.CommentsDisabled:Get() then
        return {
            Ok = false,
            Error = "CommentsDisabled"
        }
    end

    t.strict(t.string)(p12)
    t.strict(t.string)(p13)
    t.strict(t.optional(t.number))(p14)

    local v25, v26 = TryCall(function() -- line: 280
        -- upvalues: p12 (copy), p13 (copy), p14 (copy), Remotes (copy)
        return Remotes.Treadmill.AskPostReply:InvokeServer({
            MediaKey = p12,
            Message = p13,
            ImageAssetId = p14
        })
    end)

    if v25 then
        if Schema.PostCommentResult(v26) then
            local t12, v27

            if not v26.Ok or v26.Comment == nil then
                return {
                    Ok = false,
                    Error = v26.Error or "RequestFailed"
                }
            else
                RecommendationSignals.NotifyCommentPosted(p12)
                t12 = {
                    Ok = true,
                    Comment = v26.Comment
                }
                v27 = v26.Pending == true
            end

            t12.Pending = v27

            return t12
        end

        v1:AtWarning():Log("Rejected invalid treadmill post comment response")

        return {
            Ok = false,
            Error = "InvalidResponse"
        }
    end

    v1:AtWarning():Log((("Failed treadmill post comment request: %*"):format(v26)))

    return {
        Ok = false,
        Error = if typeof(v26) ~= "string" then "RequestFailed" else v26
    }
end

function t4.SetCommentLike(p15, p16, p17) -- line: 313
    -- upvalues: TreadmillFlags (copy), Remotes (copy), t (copy), TryCall (copy), Schema (copy), v1 (copy)
    if TreadmillFlags.CommentsDisabled:Get() then
        return {
            Ok = false,
            Error = "CommentsDisabled",
            CommentId = p16
        }
    end

    t.strict(t.string)(p15)
    t.strict(t.string)(p16)
    t.strict(t.boolean)(p17)

    local v29, v30 = TryCall(function() -- line: 326
        -- upvalues: p15 (copy), p16 (copy), p17 (copy), Remotes (copy)
        return Remotes.Treadmill.AskReplyFavour:InvokeServer({
            MediaKey = p15,
            CommentId = p16,
            Liked = p17
        })
    end)

    if v29 then
        if Schema.SetCommentLikeResult(v30) then
            if v30.Ok then
                return {
                    Ok = true,
                    CommentId = v30.CommentId or p16,
                    Liked = v30.Liked == true,
                    Delta = v30.Delta or 0,
                    LikeCount = v30.LikeCount or 0
                }
            end

            return {
                Ok = false,
                Error = v30.Error or "RequestFailed",
                CommentId = v30.CommentId or p16,
                LikeCount = v30.LikeCount
            }
        end

        v1:AtWarning():Log("Rejected invalid treadmill comment like response")

        return {
            Ok = false,
            Error = "InvalidResponse",
            LikeCount = nil,
            CommentId = p16
        }
    end

    v1:AtWarning():Log((("Failed treadmill comment like request: %*"):format(v30)))

    return {
        Ok = false,
        LikeCount = nil,
        Error = if typeof(v30) ~= "string" then "RequestFailed" else v30,
        CommentId = p16
    }
end

return t4
