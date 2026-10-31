-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SocialService = game:GetService("SocialService")
local ReleaseConfig = require(ReplicatedStorage.Config.ReleaseConfig)
local AreasConfig = require(ReplicatedStorage.Config.AreasConfig)
local ReleaseReach = require(ReplicatedStorage.Shared.ReleaseReach)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Parent = script.Parent
local ClientState = require(Parent.ClientState)
local DataController = require(Parent.DataController)
local t1 = {}
local v1 = ReleaseConfig.EventFollow or {}
local v2 = (v1.AskAfterMinutes or 20) * 60
local v3 = (v1.AskGapMinutes or 20) * 60
local v4 = v1.MaxAsks or 2
local v5 = v1.TrainingSeconds or 4
local v6 = v1.IdleSeconds or 12
local t2 = {
    "ShopOpen",
    "ExclusiveShopOpen",
    "IndexOpen",
    "AnimalsOpen",
    "SellOpen",
    "InventoryOpen",
    "OfflineOpen",
    "ProtectedSellOpen",
    "UpgradePopupShowing",
    "PackOfferShowing",
    "ReleaseShow",
    "TutorialActive",
    "Spotlight"
}
local LocalPlayer = Players.LocalPlayer
local elapsed = os.clock()
local t3 = {}
local v7 = false
local elapsed2
local t4 = {}

local function openEvent() -- line: 64
    -- upvalues: ReleaseConfig (copy)
    local ServerTimeNow = workspace:GetServerTimeNow()

    for v8, v9 in pairs(ReleaseConfig.Show) do
        local v10 = v9.EventId and ReleaseConfig.ScheduledTime(v8)

        if v10 and v10 - ServerTimeNow > 60 and not ReleaseConfig.IsUnlocked(v8) then
            return v8, v9.EventId
        end
    end

    return nil
end

local function eventFor(p1) -- line: 75
    -- upvalues: ReleaseConfig (copy)
    local v11 = p1 and ReleaseConfig.Show[p1]

    if v11 and v11.EventId then
        local v12 = ReleaseConfig.ScheduledTime(p1)

        return if v12 and not (v12 - workspace:GetServerTimeNow() <= 0) and not ReleaseConfig.IsUnlocked(p1) then v11.EventId else nil
    end

    return nil
end

local function refreshBoardPrompts() -- line: 83
    -- upvalues: t3 (copy), v7 (ref), t4 (copy), eventFor (copy)
    for v13, v14 in pairs(t4) do
        if v13.Parent then
            v13.Enabled = not t3[v14] and not v7 and eventFor(v14) ~= nil
        else
            t4[v13] = nil
        end
    end
end

local function setFollowing(p2) -- line: 93
    -- upvalues: t3 (copy), refreshBoardPrompts (copy)
    t3[p2] = true
    refreshBoardPrompts()
end

local function promptFollow(p3, p4) -- line: 100
    -- upvalues: SocialService (copy), t3 (copy), v7 (ref), elapsed2 (ref), refreshBoardPrompts (copy)
    if v7 or t3[p3] then
        return false, false
    end

    v7 = true
    elapsed2 = os.clock()
    refreshBoardPrompts()

    local function v15() -- line: 105
        -- upvalues: p4 (copy), SocialService (copy)
        return SocialService:PromptRsvpToEventAsync(p4)
    end

    local ok, result = pcall(v15)

    v7 = false

    if not ok or result ~= Enum.RsvpStatus.Going then
        if not ok then
            warn("[EventFollow] follow prompt failed: " .. tostring(result))
        end

        refreshBoardPrompts()

        return false, ok
    end

    t3[p3] = true
    refreshBoardPrompts()

    return true, true
end

local function checkFollowing(p5, p6) -- line: 119
    -- upvalues: SocialService (copy), t3 (copy), refreshBoardPrompts (copy)
    if t3[p5] then
        return true
    end

    local function v16() -- line: 121
        -- upvalues: p6 (copy), SocialService (copy)
        return SocialService:GetEventRsvpStatusAsync(p6)
    end

    local ok, result = pcall(v16)

    if not ok or result ~= Enum.RsvpStatus.Going then
        return nil
    end

    t3[p5] = true
    refreshBoardPrompts()

    return true
end

local function hookPrompt(p7) -- line: 131
    -- upvalues: LocalPlayer (copy), t4 (copy), eventFor (copy), refreshBoardPrompts (copy), promptFollow (copy)
    if p7:IsA("ProximityPrompt") and not t4[p7] then
        local ReleaseKey = p7:GetAttribute("ReleaseKey")

        if type(ReleaseKey) == "string" then
            t4[p7] = ReleaseKey
            refreshBoardPrompts()
            p7.Triggered:Connect(function(p8) -- line: 137
                -- upvalues: ReleaseKey (copy), LocalPlayer (copy), eventFor (copy), refreshBoardPrompts (copy), promptFollow (copy)
                if p8 == LocalPlayer then
                    local v17 = eventFor(ReleaseKey)

                    if v17 then
                        task.spawn(promptFollow, ReleaseKey, v17)
                    else
                        refreshBoardPrompts()
                    end
                end
            end)
            p7.AncestryChanged:Connect(function() -- line: 143
                -- upvalues: p7 (copy), t4 (copy)
                if not p7:IsDescendantOf(game) then
                    t4[p7] = nil
                end
            end)
        end
    end
end

local function askFromDistance() -- line: 150
    -- upvalues: AreasConfig (copy), v1 (copy)
    local v18 = v1.AskFrom or {}
    local v19 = AreasConfig.ByKey[v18.Area or "AncientRuins"]

    return if v19 and v19.StartDistance and v19.Length then v19.StartDistance + v19.Length * (v18.Part or 0.75) else nil
end

local function windowOpen() -- line: 157
    -- upvalues: GuiService (copy), ClientState (copy), t2 (copy)
    for _, v20 in ipairs(t2) do
        if ClientState[v20] then
            return true
        end
    end

    return GuiService.MenuIsOpen
end

local function tapBonusShowing() -- line: 164
    -- upvalues: LocalPlayer (copy)
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")

    if PlayerGui then
        return (PlayerGui:FindFirstChild("TrainingGui") or PlayerGui):FindFirstChild("TapBonus", true) ~= nil
    end

    return false
end

local function standingStill() -- line: 171
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local v21 = Character

    if Character then
        v21 = Character:FindFirstChildOfClass("Humanoid")
        Character = Character:FindFirstChild("HumanoidRootPart")
    end

    if v21 and Character and not (v21.Health <= 0) then
        return v21.MoveDirection.Magnitude < 0.05 and Character.AssemblyLinearVelocity.Magnitude < 1
    end

    return false
end

local function askedCount(p9) -- line: 179
    -- upvalues: DataController (copy)
    local EventAsks = DataController:Get("EventAsks")
    local v23 = type(EventAsks) == "table"
    local v24 = if v23 then tonumber(EventAsks[p9]) else nil

    if v23 and v24 or not v23 then
        if not v23 then
            v24 = 0
        end

        return v24
    end

    return 0
end

local function autoLoop() -- line: 184
    -- upvalues: GuiService (copy), ReleaseReach (copy), Remotes (copy), ClientState (copy), DataController (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), t2 (copy), LocalPlayer (copy), elapsed (copy), t3 (copy), v7 (ref), elapsed2 (ref), openEvent (copy), refreshBoardPrompts (copy), promptFollow (copy), checkFollowing (copy), askFromDistance (copy)
    DataController:WaitForReady()

    local v26 = askFromDistance()

    if not v26 then
        return
    end

    local t5 = {}
    local v27, v28

    while true do
        task.wait(1)

        local v29, v30 = openEvent()
        local v31, v32

        if not v29 then
            refreshBoardPrompts()
            task.wait(4)
            v31 = v27
            v32 = v28
            continue
        end

        local elapsed3 = os.clock()
        local v33 = if ClientState.Busy == "Training" then v27 or elapsed3 else nil
        local elapsed4, elapsed5, EventAsks, v34, v35, MenuIsOpen, PlayerGui, v36, v37, v38, v39

        if ClientState.Busy == nil then
            local v40 = false
            local v41

            for _, v42 in ipairs(t2) do
                if ClientState[v42] then
                    v41 = true
                    v40 = true
                    break
                end
            end

            if not v40 then
                v41 = GuiService.MenuIsOpen
            end

            if not v41 then
                local Character = LocalPlayer.Character
                local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
                local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

                if Humanoid and HumanoidRootPart and not (Humanoid.Health <= 0) and Humanoid.MoveDirection.Magnitude < 0.05 and HumanoidRootPart.AssemblyLinearVelocity.Magnitude < 1 then
                    v39 = v28 or elapsed3

                    local v43 = false

                    if t3[v29] or v7 or elapsed3 - elapsed < v2 then
                        v31 = v33
                        v32 = v39
                        v43 = true
                    else
                        elapsed4 = elapsed2

                        if elapsed4 then
                            elapsed5 = elapsed2

                            if elapsed3 - elapsed5 < v3 then
                                v31 = v33
                                v32 = v39
                                v43 = true
                            end
                        end
                    end

                    if not v43 then
                        EventAsks = DataController:Get("EventAsks")

                        if type(EventAsks) == "table" then
                            v34 = EventAsks[v29]
                            v35 = tonumber(v34) or 0
                        else
                            v35 = 0
                        end

                        if v4 <= v35 or ReleaseReach.Distance(DataController:Get("Level") or 1) < v26 then
                            v32 = v39
                            v31 = v33
                        elseif v33 and elapsed3 - v33 >= v5 then
                            local v44 = false

                            for _, v45 in ipairs(t2) do
                                if ClientState[v45] then
                                    MenuIsOpen = true
                                    v44 = true
                                    break
                                end
                            end

                            if not v44 then
                                MenuIsOpen = GuiService.MenuIsOpen
                            end

                            if MenuIsOpen then
                                local v46 = true

                                if v39 and elapsed3 - v39 >= v6 then
                                    if t5[v29] then
                                        v46 = false
                                    else
                                        t5[v29] = true

                                        if checkFollowing(v29, v30) then
                                            v31 = v33
                                            v32 = v39
                                        else
                                            v46 = false
                                        end
                                    end
                                else
                                    v31 = v33
                                    v32 = v39
                                end

                                if not v46 then
                                    v37, v38 = promptFollow(v29, v30)

                                    if v38 then
                                        Remotes.Event("Event_Asked"):FireServer(v29)
                                    end

                                    v31 = nil
                                    v32 = nil
                                end
                            else
                                PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
                                v36 = if PlayerGui then (PlayerGui:FindFirstChild("TrainingGui") or PlayerGui):FindFirstChild("TapBonus", true) ~= nil else false
                                v31 = v33
                                v32 = v39

                                if not v36 or v39 and elapsed3 - v39 >= v6 then
                                    if t5[v29] then
                                        v37, v38 = promptFollow(v29, v30)

                                        if v38 then
                                            Remotes.Event("Event_Asked"):FireServer(v29)
                                        end

                                        v31 = nil
                                        v32 = nil
                                    else
                                        t5[v29] = true

                                        if not checkFollowing(v29, v30) then
                                            v37, v38 = promptFollow(v29, v30)

                                            if v38 then
                                                Remotes.Event("Event_Asked"):FireServer(v29)
                                            end

                                            v31 = nil
                                            v32 = nil
                                        end
                                    end
                                end
                            end
                        else
                            v31 = v33
                            v32 = v39

                            if v39 and elapsed3 - v39 >= v6 then
                                if t5[v29] then
                                    v37, v38 = promptFollow(v29, v30)

                                    if v38 then
                                        Remotes.Event("Event_Asked"):FireServer(v29)
                                    end

                                    v31 = nil
                                    v32 = nil
                                else
                                    t5[v29] = true

                                    if not checkFollowing(v29, v30) then
                                        v37, v38 = promptFollow(v29, v30)

                                        if v38 then
                                            Remotes.Event("Event_Asked"):FireServer(v29)
                                        end

                                        v31 = nil
                                        v32 = nil
                                    end
                                end
                            end
                        end
                    end

                    v27 = v31
                    v28 = v32
                    continue
                end
            end
        end

        v39 = nil

        if t3[v29] or v7 or elapsed3 - elapsed < v2 then
            v32 = v39
            v31 = v33
        else
            elapsed4 = elapsed2

            if elapsed4 then
                elapsed5 = elapsed2

                if elapsed3 - elapsed5 < v3 then
                    v32 = v39
                    v31 = v33
                else
                    EventAsks = DataController:Get("EventAsks")

                    if type(EventAsks) == "table" then
                        v34 = EventAsks[v29]
                        v35 = tonumber(v34) or 0
                    else
                        v35 = 0
                    end

                    if v4 <= v35 or ReleaseReach.Distance(DataController:Get("Level") or 1) < v26 then
                        v32 = v39
                        v31 = v33
                    elseif v33 and elapsed3 - v33 >= v5 then
                        local v47 = false

                        for _, v48 in ipairs(t2) do
                            if ClientState[v48] then
                                MenuIsOpen = true
                                v47 = true
                                break
                            end
                        end

                        if not v47 then
                            MenuIsOpen = GuiService.MenuIsOpen
                        end

                        v31 = v33
                        v32 = v39

                        if not MenuIsOpen then
                            PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
                            v36 = if PlayerGui then (PlayerGui:FindFirstChild("TrainingGui") or PlayerGui):FindFirstChild("TapBonus", true) ~= nil else false

                            if not v36 or v39 then
                                if t5[v29] then
                                    v37, v38 = promptFollow(v29, v30)

                                    if v38 then
                                        Remotes.Event("Event_Asked"):FireServer(v29)
                                    end

                                    v31 = nil
                                    v32 = nil
                                else
                                    t5[v29] = true

                                    if not checkFollowing(v29, v30) then
                                        v37, v38 = promptFollow(v29, v30)

                                        if v38 then
                                            Remotes.Event("Event_Asked"):FireServer(v29)
                                        end

                                        v31 = nil
                                        v32 = nil
                                    end
                                end
                            end
                        end
                    else
                        v32 = v39
                        v31 = v33
                    end
                end
            else
                EventAsks = DataController:Get("EventAsks")

                if type(EventAsks) == "table" then
                    v34 = EventAsks[v29]
                    v35 = tonumber(v34) or 0
                else
                    v35 = 0
                end

                if v4 <= v35 or ReleaseReach.Distance(DataController:Get("Level") or 1) < v26 then
                    v32 = v39
                    v31 = v33
                elseif v33 and elapsed3 - v33 >= v5 then
                    local v49 = false

                    for _, v50 in ipairs(t2) do
                        if ClientState[v50] then
                            MenuIsOpen = true
                            v49 = true
                            break
                        end
                    end

                    if not v49 then
                        MenuIsOpen = GuiService.MenuIsOpen
                    end

                    v31 = v33
                    v32 = v39

                    if not MenuIsOpen then
                        PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
                        v36 = if PlayerGui then (PlayerGui:FindFirstChild("TrainingGui") or PlayerGui):FindFirstChild("TapBonus", true) ~= nil else false

                        if not v36 or v39 then
                            if t5[v29] then
                                v37, v38 = promptFollow(v29, v30)

                                if v38 then
                                    Remotes.Event("Event_Asked"):FireServer(v29)
                                end

                                v31 = nil
                                v32 = nil
                            else
                                t5[v29] = true

                                if not checkFollowing(v29, v30) then
                                    v37, v38 = promptFollow(v29, v30)

                                    if v38 then
                                        Remotes.Event("Event_Asked"):FireServer(v29)
                                    end

                                    v31 = nil
                                    v32 = nil
                                end
                            end
                        end
                    end
                else
                    v32 = v39
                    v31 = v33
                end
            end
        end

        v28 = v32
        v27 = v31
    end
end

function t1.Init() -- line: 232
    -- upvalues: CollectionService (copy), openEvent (copy), checkFollowing (copy), hookPrompt (copy), autoLoop (copy)
    for _, v51 in ipairs(CollectionService:GetTagged("FollowEventPrompt")) do
        hookPrompt(v51)
    end

    CollectionService:GetInstanceAddedSignal("FollowEventPrompt"):Connect(hookPrompt)
    task.spawn(function() -- line: 236
        -- upvalues: openEvent (copy), checkFollowing (copy)
        local v52, v53 = openEvent()

        if v52 then
            checkFollowing(v52, v53)
        end
    end)
    task.spawn(autoLoop)
end

return t1
