-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SchemaFields = require(ReplicatedStorage.Shared.Modules.ProfileDefaults.Types.SchemaFields)
local t = require(ReplicatedStorage.Packages.t)
local t1 = {
    TreadmillMediaBucketType = t.union(t.literal("Brainrot"), t.literal("Funny"), t.literal("Satisfying"), t.literal("WeirdOrHorror"), t.literal("Music")),
    VideoBackgroundMusic = t.strictInterface({
        SoundId = t.string,
        Volume = t.number
    })
}

t1.VideoMediaEntry = t.strictInterface({
    Kind = t.literal("Video"),
    ReleaseVersion = t.number,
    BucketType = t1.TreadmillMediaBucketType,
    Video = t.string,
    CoverImage = t.optional(t.string),
    Music = t.optional(t1.VideoBackgroundMusic),
    Size = t.optional(t.UDim2),
    Volume = t.optional(t.number),
    Duration = t.optional(t.number),
    Disabled = t.optional(t.boolean)
})
t1.MusicImageMediaEntry = t.strictInterface({
    Kind = t.literal("MusicImage"),
    ReleaseVersion = t.number,
    BucketType = t1.TreadmillMediaBucketType,
    Image = t.string,
    SoundId = t.string,
    Volume = t.number,
    Duration = t.optional(t.number),
    Disabled = t.optional(t.boolean)
})
t1.TreadmillMediaEntry = t.union(t1.VideoMediaEntry, t1.MusicImageMediaEntry)
t1.TreadmillMediaEntries = t.array(t1.TreadmillMediaEntry)
t1.TreadmillMediaFeedState = SchemaFields.TreadmillMediaFeedState

return t1
