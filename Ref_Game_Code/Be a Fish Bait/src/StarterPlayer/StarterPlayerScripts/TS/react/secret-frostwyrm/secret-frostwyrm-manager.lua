-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out")
local useBindingState, useMotion, useViewport = out.useBindingState, out.useMotion, out.useViewport
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, TweenService, UserInputService, Workspace = services.Players, services.TweenService, services.UserInputService, services.Workspace
local network = RuntimeLib.import(script, script.Parent.Parent.Parent, "network")
local events, functions = network.events, network.functions
local useConfig = RuntimeLib.import(script, script.Parent.Parent, "context", "config-context").useConfig
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex").useRootSelector
local secretFrostwyrmActiveAtom = RuntimeLib.import(script, script.Parent.Parent.Parent, "secret-frostwyrm-active-atom").secretFrostwyrmActiveAtom
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils").localPlayerUserId
local playClonedSound = RuntimeLib.import(script, script.Parent.Parent.Parent, "vfx").playClonedSound
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "common", "reward-screen").default
local default3 = RuntimeLib.import(script, script.Parent.Parent, "screen", "fishing", "rare-fish-boss", "boss-skillcheck").default
local useIsUsingGamepad = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-is-using-gamepad").useIsUsingGamepad
local allFishData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "fish").allFishData
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local getTitleData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "titles").getTitleData
local selectPlayerUnlockedTitles = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerUnlockedTitles
local resolveFrostwyrmStoneSkillCheckTuning = RuntimeLib.import(script, script.Parent, "frostwyrm-skillcheck-config").resolveFrostwyrmStoneSkillCheckTuning

local function v1(p1) -- line: 40
    return p1.name == "Frostwyrm"
end

local v2

for v3, v4 in allFishData do
    local _ = v3 - 1

    if v4.name == "Frostwyrm" == true then
        v2 = v4
        break
    end

    v2 = nil
end

local icyFingers = getTitleData("icyFingers")

local function findSecretParts(p2) -- line: 53
    local v5 = p2:WaitForChild("FrostwyrmStone", 10)
    local v6 = if v5 == nil then v5 else v5:WaitForChild("ProximityPrompt", 10)

    if v5 ~= nil then
        v5 = v5:WaitForChild("MinigameCamera", 10)
    end

    if not (if v5 == nil then v5 else v5:IsA("BasePart")) then
        v5 = nil
    end

    return {
        cameraPart = v5,
        promptPart = if not (if v6 == nil then v6 else v6:IsA("BasePart")) then nil else v6
    }
end

local function findPrompt(p3) -- line: 80
    local ProximityPrompt = p3:FindFirstChildOfClass("ProximityPrompt")

    if ProximityPrompt ~= nil then
        return ProximityPrompt
    end

    local v7 = p3:WaitForChild("ProximityPrompt", 10)

    return if if v7 == nil then v7 else v7:IsA("ProximityPrompt") then v7 else nil
end

local function SecretMessage(p4) -- line: 92
    -- upvalues: react (copy), useEffect (copy), useMotion (copy), default (copy)
    local exiting = p4.exiting
    local v8 = exiting

    if exiting == nil then
        v8 = false
    end

    local text = p4.text
    local v9, v10 = useMotion(0)

    useEffect(function() -- line: 99
        -- upvalues: v8 (ref), v10 (copy)
        v10:tween(if v8 then 0 else 1, {
            direction = Enum.EasingDirection.Out,
            style = Enum.EasingStyle.Quad,
            time = v8 and 0.65 or 0.22
        })
    end, { v10, v8 })

    return react.createElement("frame", {
        BorderSizePixel = 0,
        ZIndex = 950,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = v9:map(function(p5) -- line: 108
            return 1 - p5
        end),
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default, {
        anchorPoint = Vector2.new(0.5, 0.5),
        color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 245, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(235, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 120, 255))
        }),
        overrideProps = {
            TextScaled = true,
            ZIndex = 952,
            Size = UDim2.fromScale(0.78, 0.18),
            TextTransparency = v9:map(function(p6) -- line: 120
                return 1 - p6
            end)
        },
        position = UDim2.fromScale(0.5, 0.46),
        strokeProps = {
            Thickness = 0.075,
            Color = Color3.fromRGB(0, 0, 0)
        },
        text = text
    }))
end

return {
    default = function() -- SecretFrostwyrmManager | line: 133
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), useBindingState (copy), useViewport (copy), Players (copy), TweenService (copy), UserInputService (copy), Workspace (copy), events (copy), functions (copy), useConfig (copy), useRootSelector (copy), secretFrostwyrmActiveAtom (copy), localPlayerUserId (copy), playClonedSound (copy), default2 (copy), default3 (copy), useIsUsingGamepad (copy), images (copy), selectPlayerUnlockedTitles (copy), resolveFrostwyrmStoneSkillCheckTuning (copy), v2 (ref), icyFingers (copy), findSecretParts (copy), SecretMessage (copy)
        local idle, idle2 = useState("idle")
        local v12 = useRootSelector(selectPlayerUnlockedTitles(localPlayerUserId))
        local v13 = table.find(v12, "icyFingers") ~= nil
        local v14 = useBindingState(useViewport())
        local v18 = math.clamp(math.min(v14.X / 1050, v14.Y / 700), 0.55, 1)
        local TouchEnabled = UserInputService.TouchEnabled
        local v20 = resolveFrostwyrmStoneSkillCheckTuning(useIsUsingGamepad(), TouchEnabled)
        local v21 = useConfig()
        local disableMovement, enableMovement, getSound = v21.disableMovement, v21.enableMovement, v21.getSound
        local idle3 = useRef("idle")
        local v22 = useRef(nil)
        local v23 = useRef()
        local v24 = useRef(nil)
        local v25 = useRef(nil)
        local v26 = useRef(nil)
        local v27 = useRef(nil)
        local v28 = useRef(nil)
        local v29 = useRef(false)
        local v30 = useRef({})
        local v31 = useRef({})
        local v32 = useRef({})
        local v33 = useRef({})
        local v34 = useRef({})

        local function setEncounterPhase(p7) -- line: 160
            -- upvalues: idle2 (copy), idle3 (copy), secretFrostwyrmActiveAtom (copy)
            idle3.current = p7
            secretFrostwyrmActiveAtom(p7 ~= "idle")
            idle2(p7)
        end

        local stopIntroMusic

        local function playMinigameMusic() -- line: 166
            -- upvalues: getSound (copy), v26 (copy), v27 (copy), stopIntroMusic (ref)
            stopIntroMusic()

            local FrostwyrmMinigame = getSound("FrostwyrmMinigame")

            v27.current = FrostwyrmMinigame.Looped
            v26.current = FrostwyrmMinigame
            FrostwyrmMinigame:Stop()
            FrostwyrmMinigame.TimePosition = 9
            FrostwyrmMinigame.Looped = true
            FrostwyrmMinigame:Play()
        end

        local function stopMinigameMusic() -- line: 176
            -- upvalues: v26 (copy), v27 (copy)
            local current = v26.current

            if current == nil then
                return nil
            end

            current:Stop()

            if v27.current ~= nil then
                current.Looped = v27.current
            end

            v26.current = nil
            v27.current = nil
        end

        local function playIntroMusic() -- line: 188
            -- upvalues: getSound (copy), v28 (copy)
            local RareFishEncounter = getSound("RareFishEncounter")

            v28.current = RareFishEncounter
            RareFishEncounter:Stop()
            RareFishEncounter.TimePosition = 0
            RareFishEncounter:Play()
        end

        function stopIntroMusic() -- line: 195
            -- upvalues: v28 (copy)
            local current = v28.current

            if current == nil then
                return nil
            end

            current:Stop()
            v28.current = nil
        end

        local function hideLocalCharacter() -- line: 203
            -- upvalues: v30 (copy), v31 (copy), v32 (copy), v33 (copy), v34 (copy), Players (copy)
            local Character = Players.LocalPlayer.Character

            if Character == nil then
                return nil
            end

            local current = v30.current
            local current2 = v31.current
            local current3 = v32.current
            local current4 = v33.current
            local current5 = v34.current

            for _, descendant in Character:GetDescendants() do
                if descendant:IsA("BasePart") then
                    if current[descendant] == nil then
                        current[descendant] = descendant.LocalTransparencyModifier
                    end

                    descendant.LocalTransparencyModifier = 1
                elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
                    if current2[descendant] == nil then
                        current2[descendant] = descendant.Transparency
                    end

                    descendant.Transparency = 1
                elseif descendant:IsA("BillboardGui") or descendant:IsA("SurfaceGui") then
                    if current3[descendant] == nil then
                        current3[descendant] = descendant.Enabled
                    end

                    descendant.Enabled = false
                elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Trail") then
                    if current4[descendant] == nil then
                        current4[descendant] = descendant.Enabled
                    end

                    descendant.Enabled = false
                elseif descendant:IsA("Humanoid") then
                    if current5[descendant] == nil then
                        current5[descendant] = descendant.DisplayDistanceType
                    end

                    descendant.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                end
            end
        end

        local function restoreLocalCharacterVisibility() -- line: 247
            -- upvalues: v30 (copy), v31 (copy), v32 (copy), v33 (copy), v34 (copy)
            for v35, v36 in v30.current do
                if v35.Parent ~= nil then
                    v35.LocalTransparencyModifier = v36
                end
            end

            for v37, v38 in v31.current do
                if v37.Parent ~= nil then
                    v37.Transparency = v38
                end
            end

            for v39, v40 in v32.current do
                if v39.Parent ~= nil then
                    v39.Enabled = v40
                end
            end

            for v41, v42 in v33.current do
                if v41.Parent ~= nil then
                    v41.Enabled = v42
                end
            end

            for v43, v44 in v34.current do
                if v43.Parent ~= nil then
                    v43.DisplayDistanceType = v44
                end
            end

            table.clear(v30.current)
            table.clear(v31.current)
            table.clear(v32.current)
            table.clear(v33.current)
            table.clear(v34.current)
        end

        local function restoreCamera() -- line: 279
            -- upvalues: idle2 (copy), enableMovement (copy), idle3 (copy), v22 (copy), v23 (copy), v24 (copy), v25 (copy), v26 (copy), v27 (copy), v29 (copy), stopIntroMusic (ref), restoreLocalCharacterVisibility (copy), Workspace (copy), secretFrostwyrmActiveAtom (copy)
            local current = v24.current

            if current ~= nil then
                current:Cancel()
            end

            stopIntroMusic()

            local current2 = v26.current

            if current2 ~= nil then
                current2:Stop()

                if v27.current ~= nil then
                    current2.Looped = v27.current
                end

                v26.current = nil
                v27.current = nil
            end

            restoreLocalCharacterVisibility()

            if v29.current then
                enableMovement()
                v29.current = false
            end

            local current3 = v25.current

            if current3 ~= nil then
                current3:Resume()
            end

            v25.current = nil

            local CurrentCamera = Workspace.CurrentCamera
            local current4 = v23.current

            if CurrentCamera ~= nil and current4 ~= nil then
                CurrentCamera.CameraType = current4.cameraType
                CurrentCamera.CFrame = current4.cframe
                CurrentCamera.FieldOfView = current4.fov
            end

            v23.current = nil

            local current5 = v22.current

            if current5 ~= nil then
                current5.Enabled = true
            end

            idle3.current = "idle"
            secretFrostwyrmActiveAtom(false)
            idle2("idle")
        end

        local function startEncounter(p8) -- line: 310
            -- upvalues: idle2 (copy), disableMovement (copy), getSound (copy), idle3 (copy), v22 (copy), v23 (copy), v24 (copy), v25 (copy), v26 (copy), v27 (copy), v28 (copy), v29 (copy), stopIntroMusic (ref), hideLocalCharacter (copy), TweenService (copy), Workspace (copy), events (copy), secretFrostwyrmActiveAtom (copy), v2 (ref)
            if idle3.current ~= "idle" then
                return nil
            end

            local CurrentCamera = Workspace.CurrentCamera

            if CurrentCamera == nil or v2 == nil then
                return nil
            end

            events.analyticsFrostwyrmChallengeStarted:fire()
            disableMovement()
            v29.current = true
            hideLocalCharacter()

            local LifeInAnElevator = getSound("LifeInAnElevator")

            if LifeInAnElevator.IsPlaying then
                LifeInAnElevator:Pause()
                v25.current = LifeInAnElevator
            end

            v23.current = {
                cameraType = CurrentCamera.CameraType,
                cframe = CurrentCamera.CFrame,
                fov = CurrentCamera.FieldOfView
            }

            local current = v22.current

            if current ~= nil then
                current.Enabled = false
            end

            CurrentCamera.CameraType = Enum.CameraType.Scriptable
            v24.current = TweenService:Create(CurrentCamera, TweenInfo.new(1.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                CFrame = p8.CFrame
            })
            v24.current:Play()

            local RareFishEncounter = getSound("RareFishEncounter")

            v28.current = RareFishEncounter
            RareFishEncounter:Stop()
            RareFishEncounter.TimePosition = 0
            RareFishEncounter:Play()
            idle3.current = "intro"
            secretFrostwyrmActiveAtom(true)
            idle2("intro")
            task.delay(4.2, function() -- line: 343
                -- upvalues: idle2 (copy), getSound (copy), idle3 (copy), v26 (copy), v27 (copy), stopIntroMusic (ref), secretFrostwyrmActiveAtom (copy)
                if idle3.current == "intro" then
                    stopIntroMusic()

                    local FrostwyrmMinigame = getSound("FrostwyrmMinigame")

                    v27.current = FrostwyrmMinigame.Looped
                    v26.current = FrostwyrmMinigame
                    FrostwyrmMinigame:Stop()
                    FrostwyrmMinigame.TimePosition = 9
                    FrostwyrmMinigame.Looped = true
                    FrostwyrmMinigame:Play()
                    idle3.current = "playing"
                    secretFrostwyrmActiveAtom(true)
                    idle2("playing")
                end
            end)
        end

        useEffect(function() -- line: 350
            -- upvalues: enableMovement (copy), v22 (copy), v24 (copy), v26 (copy), v27 (copy), v29 (copy), stopIntroMusic (ref), restoreLocalCharacterVisibility (copy), startEncounter (copy), Players (copy), Workspace (copy), secretFrostwyrmActiveAtom (copy), findSecretParts (copy)
            local v45 = false
            local connection

            task.spawn(function() -- line: 353
                -- upvalues: v45 (ref), connection (ref), v22 (copy), startEncounter (copy), Players (copy), Workspace (copy), findSecretParts (copy)
                local v46 = Workspace:WaitForChild("FrostwyrmNPC", 10)

                if v45 or v46 == nil then
                    if not v45 then
                        warn("[Frostwyrm] Missing Workspace.FrostwyrmNPC")
                    end
                else
                    local v47 = findSecretParts(v46)
                    local cameraPart, promptPart = v47.cameraPart, v47.promptPart

                    if not v45 then
                        if cameraPart ~= nil and promptPart ~= nil then
                            local ProximityPrompt = promptPart:FindFirstChildOfClass("ProximityPrompt")

                            if ProximityPrompt == nil then
                                ProximityPrompt = promptPart:WaitForChild("ProximityPrompt", 10)

                                if not (if ProximityPrompt == nil then ProximityPrompt else ProximityPrompt:IsA("ProximityPrompt")) then
                                    ProximityPrompt = nil
                                end
                            end

                            if v45 then
                                return nil
                            end

                            if ProximityPrompt == nil then
                                warn("[Frostwyrm] Missing child ProximityPrompt instance")

                                return nil
                            end

                            v22.current = ProximityPrompt
                            connection = ProximityPrompt.Triggered:Connect(function(p9) -- line: 380
                                -- upvalues: cameraPart (copy), startEncounter (copy), Players (copy)
                                if p9 ~= nil and p9 ~= Players.LocalPlayer then
                                    return nil
                                end

                                startEncounter(cameraPart)
                            end)

                            return
                        end

                        warn("[Frostwyrm] Missing FrostwyrmStone, ProximityPrompt part, or MinigameCamera part under Workspace.FrostwyrmNPC")
                    end
                end

                return nil
            end)

            return function() -- line: 387
                -- upvalues: v45 (ref), connection (ref), enableMovement (copy), v22 (copy), v24 (copy), v26 (copy), v27 (copy), v29 (copy), stopIntroMusic (ref), restoreLocalCharacterVisibility (copy), secretFrostwyrmActiveAtom (copy)
                v45 = true
                secretFrostwyrmActiveAtom(false)

                local connection2 = connection

                if connection2 ~= nil then
                    connection2:Disconnect()
                end

                v22.current = nil

                local current = v24.current

                if current ~= nil then
                    current:Cancel()
                end

                stopIntroMusic()

                local current2 = v26.current

                if current2 ~= nil then
                    current2:Stop()

                    if v27.current ~= nil then
                        current2.Looped = v27.current
                    end

                    v26.current = nil
                    v27.current = nil
                end

                restoreLocalCharacterVisibility()

                if v29.current then
                    enableMovement()
                    v29.current = false
                end
            end
        end, {})

        if idle == "idle" or v2 == nil then
            return nil
        end

        local v48 = (idle == "intro" or idle == "playing") and react.createElement(SecretMessage, {
            text = "The Frostwyrm Stone keeps a cold secret.\nProve your hands will not shake.",
            exiting = idle == "playing"
        })
        local v49 = idle == "playing" and react.createElement(default3, {
            failureMessage = "Better luck next time...",
            instantCaptureEnabled = false,
            showCountdown = true,
            simpleFailureCutscene = true,
            skipSuccessRewardScreen = true,
            currentFish = v2,
            difficultyMultiplier = v20.difficultyMultiplier,
            multiTapProgressMultiplier = v20.multiTapProgressMultiplier,
            onComplete = function(p10) -- onComplete | line: 421
                -- upvalues: idle2 (copy), idle3 (copy), v26 (copy), v27 (copy), restoreCamera (copy), v13 (copy), functions (copy), secretFrostwyrmActiveAtom (copy)
                local current = v26.current

                if current ~= nil then
                    current:Stop()

                    if v27.current ~= nil then
                        current.Looped = v27.current
                    end

                    v26.current = nil
                    v27.current = nil
                end

                if p10.success then
                    functions.claimFrostwyrmTitle():andThen(function() -- line: 425
                        -- upvalues: idle2 (copy), idle3 (copy), restoreCamera (copy), v13 (copy), secretFrostwyrmActiveAtom (copy)
                        idle3.current = "successMessage"
                        secretFrostwyrmActiveAtom(true)
                        idle2("successMessage")
                        task.delay(3, function() -- line: 427
                            -- upvalues: idle2 (copy), idle3 (copy), restoreCamera (copy), v13 (copy), secretFrostwyrmActiveAtom (copy)
                            if idle3.current == "successMessage" then
                                if v13 then
                                    restoreCamera()
                                else
                                    idle3.current = "reward"
                                    secretFrostwyrmActiveAtom(true)
                                    idle2("reward")
                                end
                            end
                        end)
                    end):catch(function() -- line: 436
                        -- upvalues: restoreCamera (copy)
                        return restoreCamera()
                    end)
                else
                    restoreCamera()
                end
            end,
            progressIconImage = images.questionMarksIcon,
            qteVariant = v20.qteVariant,
            randomPromptScreenInsetScale = v20.randomPromptScreenInsetScale,
            randomScreenPromptPositions = v20.randomScreenPromptPositions,
            slidePromptsEnabled = v20.slidePromptsEnabled
        })
        local v50 = idle == "successMessage" and react.createElement(SecretMessage, {
            text = "You did well. The ice remembers your name."
        })
        local v51 = idle == "reward"

        if v51 then
            local t8 = {
                revealDelaySec = 0.35,
                showIcon = false,
                title = "PLAYER TITLE!",
                onFinished = restoreCamera,
                onReveal = function() -- onReveal | line: 459
                    -- upvalues: playClonedSound (copy)
                    return playClonedSound("SkillCheckSuccess")
                end,
                rewardRayColor = Color3.fromRGB(255, 255, 255)
            }
            local t9 = {}
            local v52 = icyFingers

            if icyFingers ~= nil then
                v52 = icyFingers.animatedColor
            end

            if v52 ~= nil then
                t9.color = v52
            else
                local v53 = icyFingers

                if icyFingers ~= nil then
                    v53 = icyFingers.color
                end

                t9.color = if v53 == nil then Color3.fromRGB(255, 255, 255) else v53
            end

            local v54 = icyFingers

            if icyFingers ~= nil then
                v54 = icyFingers.displayName
            end

            t9.displayName = if v54 == nil then "Icy Fingers" else v54
            t9.perkDescription = if icyFingers ~= nil then icyFingers.perkDescription else icyFingers
            t8.titleReward = t9
            t8.titleRewardTextOnly = true
            t8.uiScale = v18
            t8.zIndex = 950
            v51 = react.createElement("frame", {
                BorderSizePixel = 0,
                ZIndex = 950,
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                Size = UDim2.fromScale(1, 1)
            }, react.createElement(default2, t8))
        end

        return react.createElement("screengui", {
            IgnoreGuiInset = true,
            ResetOnSpawn = false,
            ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        }, v48, v49, v50, v51)
    end
}
