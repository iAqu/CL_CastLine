-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ConsoleSignals = require(ReplicatedStorage.Client.ConsoleSignals)

require(ReplicatedStorage.Client.Types.GUI)
require(ReplicatedStorage.Packages.Signal)

local v1 = if RunService:IsStudio() then 20 else nil
local t1 = {
    ActivePets = true,
    ApplyStarPopupConfirmationScreen = true,
    AreaGui = true,
    AssetEggData = true,
    AssetHoverData = true,
    AutoSell = true,
    Backpack = "BackpackGui",
    BeanstalkEventUI = true,
    BossMastery = true,
    BossShop = true,
    ButterflyMachine = true,
    SoulsTradeInMachine = true,
    EnchantedMutationShrine = true,
    WispCompanion = "GrowWispProgressUI",
    CaptureTheEggUI = true,
    DrScrambleEvent = "DrScrambleEventUI",
    DropHeldEgg = true,
    Fade = true,
    GetMoreSpeedOnHit = true,
    GreatBloomBanner = true,
    GroupReward = "FreeGift",
    GrowingEggs = true,
    HalloweenBossMastery = true,
    HalloweenDimensionEggUI = true,
    HalloweenEventTutorialFrame = true,
    HeadlessHorsemanBattlepass = true,
    HUD = true,
    Index = true,
    LightVsDarknessUI = true,
    Message = true,
    MonsterCharge = "MonsterChargeUI",
    MonsterChestRewards = true,
    MonsterEventTutorialFrame = true,
    MountRaceBoardUI = true,
    MountRaceUI = true,
    Notifications = true,
    OfflineMoneyInPlot = true,
    PetFuse = true,
    PopupPrompt = true,
    RaceRally = "RaceRallyUI",
    RescueDragonFTUEQuest = true,
    ResetStartTimer = true,
    RiftTradeIn = true,
    DrScrambleTradeIn = true,
    DogsMemoriesFrame = true,
    RollbackReward = "RollbackRewardUI",
    SakuraCrystalCounter = true,
    SakuraEggCharge = true,
    SakuraEventTutorialFrame = true,
    SammyEventUI = true,
    ScrambleBossMastery = true,
    SellPrompt = true,
    Settings = true,
    Shop = "RobuxShop",
    SpeedGainAnimation = true,
    StarBundles = true,
    StaticTreadmillImageSurfaceGui = true,
    StolenVaultEvent = "StolenVaultEventUI",
    TheHollow = "TheHollowEventUI",
    TopBarStandard = "TopbarStandard",
    TrailShop = true,
    TreadmillScreenButtonShare = true,
    TreadmillScreenButtonSwapLeft = true,
    TreadmillScreenButtonSwapRight = true,
    TreadmillScreenComments = true,
    TreadmillScreenFriendLikes = true,
    TreadmillScreenSideButtons = true,
    TreadmillVideoSurfaceGui = true,
    TutorialInstructions = true
}
local t2 = {
    AssetHoverData = "ScreenGui",
    GetMoreSpeedOnHit = "ScreenGui",
    MonsterCharge = "ScreenGui"
}

local function shape(p1, p2) -- line: 103
    return {
        class = p1,
        children = p2
    }
end

local t3 = {
    class = "Frame",
    children = {
        Icon = {
            class = "ImageButton",
            children = nil
        },
        Timer = {
            class = "TextLabel",
            children = nil
        }
    }
}
local t4 = {
    class = "ScreenGui",
    children = {
        BottomFrame = {
            class = "Frame",
            children = {
                Holder = {
                    class = "Frame",
                    children = {
                        List = {
                            class = "Frame",
                            children = {
                                Luck = {
                                    class = "Frame",
                                    children = {
                                        Button = {
                                            class = "ImageButton",
                                            children = {
                                                Content = {
                                                    class = "Frame",
                                                    children = {
                                                        Value = {
                                                            class = "Frame",
                                                            children = {
                                                                TextLabel = {
                                                                    class = "TextLabel",
                                                                    children = nil
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                },
                                x2Growth = t3,
                                x2Luck = t3
                            }
                        }
                    }
                }
            }
        }
    }
}

local function awaitChild(p3, p4) -- line: 129
    -- upvalues: v1 (copy)
    return (if v1 == nil then p3:WaitForChild(p4) else p3:WaitForChild(p4, v1)) or error(("%* has no child named %*"):format(p3:GetFullName(), p4), 2)
end

local LocalPlayer = Players.LocalPlayer
local v2 = (if v1 == nil then LocalPlayer:WaitForChild("PlayerGui") else LocalPlayer:WaitForChild("PlayerGui", v1)) or error(("%* has no child named PlayerGui"):format((LocalPlayer:GetFullName())), 2)

local function descend(p5, p6) -- line: 138
    -- upvalues: v1 (copy)
    for _, v4 in p6 do
        p5 = (if v1 == nil then p5:WaitForChild(v4) else p5:WaitForChild(v4, v1)) or error(("%* has no child named %*"):format(p5:GetFullName(), v4), 2)
    end

    return p5
end

local function conform(p7, p8, p9) -- line: 146
    -- upvalues: v1 (copy), conform (copy)
    assert(p7:IsA(p8.class), (("%* is a %*, not the expected %*"):format(p9, p7.ClassName, p8.class)))

    for v7, v8 in p8.children or {} do
        conform((if v1 == nil then p7:WaitForChild(v7) else p7:WaitForChild(v7, v1)) or error(("%* has no child named %*"):format(p7:GetFullName(), v7), 2), v8, (("%*.%*"):format(p9, v7)))
    end
end

local function screenNamed(p10) -- line: 153
    -- upvalues: t1 (copy), t2 (copy), v1 (copy), v2 (copy)
    local v9 = t1[p10]

    if v9 == true then
        v9 = p10
    end

    local v10 = (if v1 == nil then v2:WaitForChild(v9) else v2:WaitForChild(v9, v1)) or error(("%* has no child named %*"):format(v2:GetFullName(), v9), 2)
    local v11 = t2[p10]

    if v11 ~= nil then
        assert(v10:IsA(v11), (("%* is a %*, not the %* that GUI.%* promises"):format(v9, v10.ClassName, v11, p10)))
    end

    return v10
end

local function adoptScale(p11) -- line: 167
    local UIScale = p11:FindFirstChildOfClass("UIScale")

    if UIScale ~= nil then
        return UIScale
    end

    local UIScale2 = Instance.new("UIScale")

    UIScale2.Scale = 0
    UIScale2.Parent = p11

    return UIScale2
end

local function resetTimerLabel() -- line: 178
    -- upvalues: t1 (copy), t2 (copy), v1 (copy), v2 (copy)
    local ResetStartTimer = t1.ResetStartTimer

    if ResetStartTimer == true then
        ResetStartTimer = "ResetStartTimer"
    end

    local v14 = (if v1 == nil then v2:WaitForChild(ResetStartTimer) else v2:WaitForChild(ResetStartTimer, v1)) or error(("%* has no child named %*"):format(v2:GetFullName(), ResetStartTimer), 2)
    local ResetStartTimer2 = t2.ResetStartTimer

    if ResetStartTimer2 ~= nil then
        assert(v14:IsA(ResetStartTimer2), (("%* is a %*, not the %* that GUI.ResetStartTimer promises"):format(ResetStartTimer, v14.ClassName, ResetStartTimer2)))
    end

    for _, v17 in { "Frame", "TextLabel" } do
        v14 = (if v1 == nil then v14:WaitForChild(v17) else v14:WaitForChild(v17, v1)) or error(("%* has no child named %*"):format(v14:GetFullName(), v17), 2)
    end

    return v14
end

local t5 = {
    BottomUI = function() -- BottomUI | line: 184
        -- upvalues: t4 (copy), v1 (copy), conform (copy), v2 (copy)
        local v18 = (if v1 == nil then v2:WaitForChild("BottomUI") else v2:WaitForChild("BottomUI", v1)) or error(("%* has no child named BottomUI"):format((v2:GetFullName())), 2)

        conform(v18, t4, "BottomUI")

        return v18
    end,
    FadeFrame = function() -- FadeFrame | line: 189
        -- upvalues: t1 (copy), t2 (copy), v1 (copy), v2 (copy)
        local Fade = t1.Fade

        if Fade == true then
            Fade = "Fade"
        end

        local v19 = (if v1 == nil then v2:WaitForChild(Fade) else v2:WaitForChild(Fade, v1)) or error(("%* has no child named %*"):format(v2:GetFullName(), Fade), 2)
        local Fade2 = t2.Fade

        if Fade2 ~= nil then
            assert(v19:IsA(Fade2), (("%* is a %*, not the %* that GUI.Fade promises"):format(Fade, v19.ClassName, Fade2)))
        end

        for _, v22 in { "Fade" } do
            v19 = (if v1 == nil then v19:WaitForChild(v22) else v19:WaitForChild(v22, v1)) or error(("%* has no child named %*"):format(v19:GetFullName(), v22), 2)
        end

        return v19
    end,
    PlayerGui = function() -- PlayerGui | line: 192
        -- upvalues: v2 (copy)
        return v2
    end,
    ResetStartTimerLabel = resetTimerLabel,
    ResetStartTimerLabelScale = function() -- ResetStartTimerLabelScale | line: 196
        -- upvalues: t1 (copy), t2 (copy), v1 (copy), v2 (copy)
        local ResetStartTimer = t1.ResetStartTimer

        if ResetStartTimer == true then
            ResetStartTimer = "ResetStartTimer"
        end

        local v23 = (if v1 == nil then v2:WaitForChild(ResetStartTimer) else v2:WaitForChild(ResetStartTimer, v1)) or error(("%* has no child named %*"):format(v2:GetFullName(), ResetStartTimer), 2)
        local ResetStartTimer2 = t2.ResetStartTimer

        if ResetStartTimer2 ~= nil then
            assert(v23:IsA(ResetStartTimer2), (("%* is a %*, not the %* that GUI.ResetStartTimer promises"):format(ResetStartTimer, v23.ClassName, ResetStartTimer2)))
        end

        for _, v26 in { "Frame", "TextLabel" } do
            v23 = (if v1 == nil then v23:WaitForChild(v26) else v23:WaitForChild(v26, v1)) or error(("%* has no child named %*"):format(v23:GetFullName(), v26), 2)
        end

        local UIScale = v23:FindFirstChildOfClass("UIScale")

        if UIScale ~= nil then
            return UIScale
        end

        local UIScale2 = Instance.new("UIScale")

        UIScale2.Scale = 0
        UIScale2.Parent = v23

        return UIScale2
    end
}
local t6 = {}

local function accessorNamed(p12) -- line: 203
    -- upvalues: t1 (copy), t2 (copy), v1 (copy), v2 (copy), t5 (copy), t6 (copy)
    local v27 = t6[p12]

    if v27 ~= nil then
        return v27
    end

    local v28 = t5[p12]

    if v28 == nil and t1[p12] ~= nil then
        v28 = function() -- line: 211
            -- upvalues: p12 (copy), t1 (copy), t2 (copy), v1 (copy), v2 (copy)
            local v29 = t1[p12]

            if v29 == true then
                v29 = p12
            end

            local v30 = (if v1 == nil then v2:WaitForChild(v29) else v2:WaitForChild(v29, v1)) or error(("%* has no child named %*"):format(v2:GetFullName(), v29), 2)
            local v31 = t2[p12]

            if v31 ~= nil then
                assert(v30:IsA(v31), (("%* is a %*, not the %* that GUI.%* promises"):format(v29, v30.ClassName, v31, p12)))
            end

            return v30
        end
    end

    t6[p12] = v28

    return v28
end

local t7 = {}

t7.__index = t7

local t8 = {}
local t9 = {}

function t7.Disconnect(p13) -- line: 237
    -- upvalues: t8 (copy)
    for _, v34 in p13.links do
        v34:Disconnect()
    end

    table.clear(p13.links)

    if t8[p13.button] == p13 then
        t8[p13.button] = nil
    end
end

return (setmetatable({
    OnActivated = function(p14, p15) -- OnActivated | line: 251
        -- upvalues: ConsoleSignals (copy), t7 (copy), t8 (copy)
        local v35 = t8[p14]

        if v35 ~= nil then
            v35:Disconnect()
        end

        local v36 = setmetatable({
            button = p14,
            links = {}
        }, t7)

        table.insert(v36.links, p14.Activated:Connect(p15))
        table.insert(v36.links, ConsoleSignals.ButtonUp:Connect(function(p16) -- line: 264
            -- upvalues: p14 (copy), p15 (copy)
            if p16 == p14 then
                p15()
            end
        end))
        t8[p14] = v36
        p14.Destroying:Once(function() -- line: 271
            -- upvalues: p14 (copy), v36 (copy), t8 (copy)
            if t8[p14] == v36 then
                v36:Disconnect()
            end
        end)

        return v36
    end,
    Get = function(p17) -- Get | line: 279
        -- upvalues: t1 (copy), t2 (copy), v1 (copy), v2 (copy), t5 (copy), t6 (copy), t9 (copy)
        local v38 = t9[p17]

        if v38 ~= nil and v38.Parent ~= nil then
            return v38
        end

        local v39 = t6[p17]

        if v39 == nil then
            local v40 = t5[p17]

            if v40 == nil and t1[p17] ~= nil then
                v40 = function() -- line: 211
                    -- upvalues: p17 (copy), t1 (copy), t2 (copy), v1 (copy), v2 (copy)
                    local v41 = t1[p17]

                    if v41 == true then
                        v41 = p17
                    end

                    local v42 = (if v1 == nil then v2:WaitForChild(v41) else v2:WaitForChild(v41, v1)) or error(("%* has no child named %*"):format(v2:GetFullName(), v41), 2)
                    local v43 = t2[p17]

                    if v43 ~= nil then
                        assert(v42:IsA(v43), (("%* is a %*, not the %* that GUI.%* promises"):format(v41, v42.ClassName, v43, p17)))
                    end

                    return v42
                end
            end

            v39 = v40
            t6[p17] = v40
        end

        if v39 == nil then
            error(("GUI.Get: nothing is registered under %*"):format(p17), 2)
        end

        local v46 = v39()

        t9[p17] = v46

        return v46
    end
}, {
    __index = function(_, p19) -- __index | line: 296
        -- upvalues: t1 (copy), t2 (copy), v1 (copy), v2 (copy), t5 (copy), t6 (copy)
        local v47 = t6[p19]

        if v47 == nil then
            local v48 = t5[p19]

            if v48 == nil and t1[p19] ~= nil then
                v48 = function() -- line: 211
                    -- upvalues: p19 (copy), t1 (copy), t2 (copy), v1 (copy), v2 (copy)
                    local v49 = t1[p19]

                    if v49 == true then
                        v49 = p19
                    end

                    local v50 = (if v1 == nil then v2:WaitForChild(v49) else v2:WaitForChild(v49, v1)) or error(("%* has no child named %*"):format(v2:GetFullName(), v49), 2)
                    local v51 = t2[p19]

                    if v51 ~= nil then
                        assert(v50:IsA(v51), (("%* is a %*, not the %* that GUI.%* promises"):format(v49, v50.ClassName, v51, p19)))
                    end

                    return v50
                end
            end

            v47 = v48
            t6[p19] = v48
        end

        return v47 or error(("GUI has no accessor named %*"):format(p19), 2)
    end
}))
