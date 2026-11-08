-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    EssencePerStage = 1,
    StageCount = 4,
    CompanionHeights = { 2.1, 2.55, 3, 3.45 },
    RequiredSpeedPower = 5E+10,
    SpawnHoverHeight = 1.5,
    SpawnPromptRadius = 16,
    PromptRadius = 5,
    FollowRadius = 7,
    FollowStartRadius = 20,
    FollowResponse = 4,
    FollowTrailSeconds = 0.1,
    FollowMaxDistance = 40
}

t1.FollowOffset = CFrame.new(0, 1.8, t1.FollowRadius)
t1.LockedIntro = { "I need your help, but you're not powerful enough yet! Reach 50 Billion Speed, then come back to help me regain my power!" }
t1.Intro = { "Hey! You can see me?", "I'm a spirit of the Enchanted Tree... but I've lost my power.", "There's a seal protecting the entrance. I'm too weak to open it like this.", "Help me gather Essence and grow stronger, and I'll open the way for you!" }
t1.Finished = { "I can feel my power again!", "Take me back to the Enchanted Tree.", "I can break the seal now!" }
t1.List = {
    {
        Id = "forest_eggs",
        Title = "Steal 20 Enchanted Forest eggs",
        Event = "EggSecured",
        Target = 20,
        Reward = 1,
        Icon = "rbxassetid://117266037162644",
        Match = {
            AreaId = "Enchanted Forest"
        }
    },
    {
        Id = "forest_fusion",
        Title = "Fuse an Enchanted Forest animal",
        Event = "PetFused",
        Target = 1,
        Reward = 1,
        Icon = "rbxassetid://131076803248042",
        Match = {
            AreaId = "Enchanted Forest"
        }
    },
    {
        Id = "eternal_egg",
        Title = "Steal any Eternal",
        Event = "EggSecured",
        Target = 1,
        Reward = 1,
        Icon = "rbxassetid://110096031428391",
        Match = {
            Rarity = "Eternal"
        }
    }
}

local t2 = {}

assert(#t1.List == t1.StageCount - 1)

for _, v2 in t1.List do
    assert(not t2[v2.Id], "Wisp quest IDs must be unique")
    assert(v2.Target > 0 and v2.Reward == t1.EssencePerStage)
    t2[v2.Id] = true
    table.freeze(v2.Match)
    table.freeze(v2)
end

table.freeze(t1.List)

return table.freeze(t1)
