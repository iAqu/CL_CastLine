-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GUI = require(ReplicatedStorage.Client.GUI)
local t1 = {
    Game = "GameHUD",
    Treadmill = "TradmilHud"
}
local t2 = {
    EggsButton = { "RightButtons", "EggsButton" },
    HalloweenMasteryButton = { "RightButtons", "HalloweenMasteryButton" },
    ExperimentTimer = { "BottomRight", "ExperimentTimer" },
    ExperimentTimerValue = { "BottomRight", "ExperimentTimer", "Value" },
    IndexButton = { "LeftControls", "IndexBTN" },
    IndexNotificationBadge = { "LeftControls", "IndexBTN", "NotificationBadge" },
    Money = { "BottomLeft", "Money" },
    MoneyIcon = { "BottomLeft", "Money", "Icon" },
    MoneyValue = { "BottomLeft", "Money", "Value" },
    NightTimer = { "BottomRight", "NightTimer" },
    NightTimerIcon = { "BottomRight", "NightTimer", "ImageLabel" },
    NightTimerValue = { "BottomRight", "NightTimer", "Value" },
    PetsButton = { "RightButtons", "PetsButton" },
    QuestlineBadge = { "RightButtons", "QuestlineButton", "Badge" },
    QuestlineButton = { "RightButtons", "QuestlineButton" },
    RaceRallyButton = { "RightButtons", "RaceRallyButton" },
    RaceTimer = { "BottomRight", "RaceTimer" },
    RaceTimerValue = { "BottomRight", "RaceTimer", "Value" },
    RiftButton = { "RightButtons", "RiftButton" },
    ShopButton = { "LeftControls", "ShopBTN" },
    SlowToggle = { "LeftControls", "Slowmode" },
    SlowToggleHitbox = { "LeftControls", "Slowmode", "Hitbox" },
    SlowToggleKnob = { "LeftControls", "Slowmode", "Btn" },
    SlowToggleLabel = { "LeftControls", "Slowmode", "txt" },
    Speed = { "BottomLeft", "Speed" },
    SpeedMultiButton = { "LeftControls", "SpeedMulti" },
    SpeedMultiShine = { "LeftControls", "SpeedMulti", "Glow" },
    SpeedShopButton = { "BottomLeft", "Speed", "ShopBTN" },
    SpeedValue = { "BottomLeft", "Speed", "Value" },
    TheHollowButton = { "RightButtons", "TheHollowButton" },
    WorldEventNotification = { "WorldEventNotification" },
    FriendBoost = { "BottomLeft", "FriendBoost" },
    TemporarySpeedBoost = { "BottomLeft", "TemporarySpeedBoost" }
}
local v1 = GUI.HUD()

v1.ResetOnSpawn = false

local t3 = {}
local t4 = {}
local t5 = {}

local function walk(p1, p2, p3) -- line: 78
    -- upvalues: walk (copy)
    local v2 = p2[p3]

    if v2 == nil then
        return p1
    end

    for _, child in p1:GetChildren() do
        if child.Name == v2 then
            local v3 = walk(child, p2, p3 + 1)

            if v3 ~= nil then
                return v3
            end
        end
    end

    return nil
end

local function variantFrame(p4) -- line: 96
    -- upvalues: t1 (copy), v1 (copy), t3 (copy)
    local v4 = t3[p4]

    if v4 then
        return v4
    end

    local v5 = t1[p4]

    assert(v5 ~= nil, (("no HUD variant named %*"):format(p4)))

    local v8 = v1:FindFirstChild(v5)

    assert(v8 ~= nil and v8:IsA("Frame"), (("HUD.%* must be a Frame"):format(v5)))
    t3[p4] = v8

    return v8
end

local function chainFor(p5) -- line: 111
    -- upvalues: t2 (copy)
    local v11 = t2[p5]

    assert(v11 ~= nil, (("no HUD role is registered under %*"):format(p5)))

    return v11
end

function t5.Screen() -- line: 121
    -- upvalues: v1 (copy)
    return v1
end

function t5.Frame(p6) -- line: 125
    -- upvalues: t1 (copy), v1 (copy), t3 (copy)
    p6 = p6 or "Game"

    local v15 = t3[p6]

    if v15 then
        return v15
    end

    local v16 = t1[p6]

    assert(v16 ~= nil, (("no HUD variant named %*"):format(p6)))

    local v19 = v1:FindFirstChild(v16)

    assert(v19 ~= nil and v19:IsA("Frame"), (("HUD.%* must be a Frame"):format(v16)))
    t3[p6] = v19

    return v19
end

function t5.Find(p7, p8) -- line: 131
    -- upvalues: t1 (copy), t2 (copy), v1 (copy), t3 (copy), t4 (copy), walk (copy)
    p8 = p8 or "Game"

    local v23 = t4[p8]

    if v23 == nil then
        v23 = {}
        t4[p8] = v23
    end

    if v23[p7] == nil then
        local v24 = t3[p8]

        if not v24 then
            local v25 = t1[p8]

            assert(v25 ~= nil, (("no HUD variant named %*"):format(p8)))
            v24 = v1:FindFirstChild(v25)
            assert(v24 ~= nil and v24:IsA("Frame"), (("HUD.%* must be a Frame"):format(v25)))
            t3[p8] = v24
        end

        local v30 = t2[p7]

        assert(v30 ~= nil, (("no HUD role is registered under %*"):format(p7)))
        v23[p7] = walk(v24, v30, 1)
    end

    return v23[p7]
end

function t5.Get(p9, p10) -- line: 146
    -- upvalues: t1 (copy), t2 (copy), t5 (copy)
    local v33 = t5.Find(p9, p10)
    local v34 = v33 ~= nil
    local v35 = t1[p10 or "Game"]
    local concat = table.concat
    local v36 = t2[p9]

    assert(v36 ~= nil, (("no HUD role is registered under %*"):format(p9)))
    assert(v34, (("HUD.%*.%* is missing"):format(v35, (concat(v36, ".")))))

    return v33
end

function t5.Every(p11) -- line: 154
    -- upvalues: t1 (copy), t5 (copy)
    local t6 = {}

    for v40 in t1 do
        local v41 = t5.Find(p11, v40)

        if v41 ~= nil then
            table.insert(t6, v41)
        end
    end

    return t6
end

function t5.SetTreadmillActive(p12) -- line: 165
    -- upvalues: t1 (copy), v1 (copy), t3 (copy)
    local Game = t3.Game

    if not Game then
        local Game2 = t1.Game

        assert(Game2 ~= nil, "no HUD variant named Game")
        Game = v1:FindFirstChild(Game2)
        assert(Game ~= nil and Game:IsA("Frame"), (("HUD.%* must be a Frame"):format(Game2)))
        t3.Game = Game
    end

    Game.Visible = not p12

    local Treadmill = t3.Treadmill

    if not Treadmill then
        local Treadmill2 = t1.Treadmill

        assert(Treadmill2 ~= nil, "no HUD variant named Treadmill")
        Treadmill = v1:FindFirstChild(Treadmill2)
        assert(Treadmill ~= nil and Treadmill:IsA("Frame"), (("HUD.%* must be a Frame"):format(Treadmill2)))
        t3.Treadmill = Treadmill
    end

    Treadmill.Visible = p12
end

return table.freeze(t5)
