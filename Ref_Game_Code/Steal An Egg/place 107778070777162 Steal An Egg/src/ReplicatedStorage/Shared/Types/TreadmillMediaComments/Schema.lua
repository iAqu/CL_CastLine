-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    MediaKey = t.string,
    CommentId = t.string
}

t1.ClientCommentRecord = t.strictInterface({
    Id = t1.CommentId,
    UserId = t.number,
    CreatedAt = t.number,
    Message = t.string,
    ImageAssetId = t.optional(t.number),
    LikeCount = t.number,
    LikedByViewer = t.boolean
})
t1.PersistedCommentRecord = t.strictInterface({
    I = t1.CommentId,
    U = t.number,
    T = t.number,
    M = t.string,
    A = t.optional(t.number),
    L = t.number
})
t1.PersistedCommentPayload = t.strictInterface({
    V = t.number,
    U = t.number,
    N = t.number,
    C = t.array(t1.PersistedCommentRecord)
})
t1.CommentCountPayload = t.strictInterface({
    V = t.number,
    U = t.number,
    C = t.map(t1.MediaKey, t.number)
})
t1.CommentCountEnvelope = t.interface({
    V = t.number,
    U = t.number,
    C = t.table
})
t1.CommentPageRequest = t.strictInterface({
    MediaKey = t1.MediaKey,
    Cursor = t.optional(t.number),
    PageSize = t.optional(t.number)
})
t1.CommentPageResult = t.strictInterface({
    Ok = t.boolean,
    TotalCreatedCount = t.optional(t.number),
    Comments = t.optional(t.array(t1.ClientCommentRecord)),
    NextCursor = t.optional(t.number),
    Error = t.optional(t.string)
})
t1.CommentCountsRequest = t.strictInterface({
    MediaKeys = t.array(t1.MediaKey)
})
t1.CommentCountsResult = t.strictInterface({
    Ok = t.boolean,
    CountsByMediaKey = t.optional(t.map(t1.MediaKey, t.number)),
    Loaded = t.optional(t.boolean),
    Stale = t.optional(t.boolean),
    Error = t.optional(t.string)
})
t1.PostCommentRequest = t.strictInterface({
    MediaKey = t1.MediaKey,
    Message = t.optional(t.string),
    ImageAssetId = t.optional(t.number)
})
t1.PostCommentResult = t.strictInterface({
    Ok = t.boolean,
    Comment = t.optional(t1.ClientCommentRecord),
    Pending = t.optional(t.boolean),
    Error = t.optional(t.string)
})
t1.SetCommentLikeRequest = t.strictInterface({
    MediaKey = t1.MediaKey,
    CommentId = t1.CommentId,
    Liked = t.boolean
})
t1.SetCommentLikeResult = t.strictInterface({
    Ok = t.boolean,
    CommentId = t.optional(t1.CommentId),
    LikeCount = t.optional(t.number),
    Liked = t.optional(t.boolean),
    Delta = t.optional(t.number),
    Error = t.optional(t.string)
})

return t1
