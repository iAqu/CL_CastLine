-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    MediaKey = t.string,
    CountsByMediaLikeKey = t.map(t.string, t.number),
    LikerUserIds = t.array(t.integer)
}

t1.LikerUserIdsByMediaLikeKey = t.map(t.string, t1.LikerUserIds)
t1.MemberUserIdSet = t.map(t.string, t.boolean)
t1.MembersByMediaLikeKey = t.map(t.string, t1.MemberUserIdSet)
t1.MemberBucketsByMediaLikeKey = t.map(t.string, t.map(t.string, t1.MemberUserIdSet))
t1.MemberCountsByMediaLikeKey = t.map(t.string, t.number)
t1.OldestMemberBucketByMediaLikeKey = t.map(t.string, t.number)
t1.LikedTreadmillMedia = t.map(t.string, t.boolean)
t1.LikeSnapshot = t.strictInterface({
    CountsByMediaLikeKey = t1.CountsByMediaLikeKey,
    LikedTreadmillMedia = t1.LikedTreadmillMedia
})
t1.FriendLikeSnapshot = t.strictInterface({
    FriendLikeUserIdsByMediaLikeKey = t1.LikerUserIdsByMediaLikeKey
})
t1.FriendLikeSnapshotRequest = t.strictInterface({
    MediaKeys = t.optional(t.array(t1.MediaKey))
})
t1.LikeToggleResult = t.strictInterface({
    Ok = t.boolean,
    Liked = t.optional(t.boolean),
    Delta = t.optional(t.number),
    Count = t.optional(t.number),
    Error = t.optional(t.string)
})
t1.LikeToggleRequest = t.strictInterface({
    MediaKey = t1.MediaKey,
    Liked = t.boolean
})
t1.AggregateShardPayload = t.strictInterface({
    Version = t.number,
    UpdatedAt = t.number,
    Counts = t1.CountsByMediaLikeKey
})
t1.MemberShardPayload = t.strictInterface({
    Version = t.number,
    UpdatedAt = t.number,
    MembersByMediaLikeKey = t.optional(t1.MembersByMediaLikeKey),
    MemberBucketsByMediaLikeKey = t.optional(t1.MemberBucketsByMediaLikeKey),
    MemberCountsByMediaLikeKey = t.optional(t1.MemberCountsByMediaLikeKey),
    OldestMemberBucketByMediaLikeKey = t.optional(t1.OldestMemberBucketByMediaLikeKey)
})

return t1
