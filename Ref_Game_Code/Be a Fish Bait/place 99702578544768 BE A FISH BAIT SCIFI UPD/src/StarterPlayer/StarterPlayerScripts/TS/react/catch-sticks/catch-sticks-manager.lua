-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out")
local useBindingState, useViewport = out.useBindingState, out.useViewport
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local HttpService, Players, TweenService, UserInputService = services.HttpService, services.Players, services.TweenService, services.UserInputService
local Workspace = services.Workspace
local catchSticksActiveAtom = RuntimeLib.import(script, script.Parent.Parent.Parent, "catch-sticks-active-atom").catchSticksActiveAtom
local useConfig = RuntimeLib.import(script, script.Parent.Parent, "context", "config-context").useConfig
local playClonedSound = RuntimeLib.import(script, script.Parent.Parent.Parent, "vfx").playClonedSound
local hapticCatch = RuntimeLib.import(script, script.Parent.Parent.Parent, "haptics").hapticCatch
local network = RuntimeLib.import(script, script.Parent.Parent.Parent, "network")
local events, functions = network.events, network.functions
local rewardPresentationQueue = RuntimeLib.import(script, script.Parent.Parent.Parent, "reward-presentation-queue").rewardPresentationQueue
local default = RuntimeLib.import(script, script.Parent, "catch-sticks-button").default
local default2 = RuntimeLib.import(script, script.Parent, "catch-sticks-results").default
local default3 = RuntimeLib.import(script, script.Parent, "catch-sticks-mode-select").default
local default4 = RuntimeLib.import(script, script.Parent, "catch-sticks-countdown").default
local v1 = Color3.fromRGB(0, 255, 0)
local v2 = Color3.fromRGB(255, 0, 0)
local t1 = {
    insane = {
        buttonWorldDropOffset = 2,
        reactionWindowSec = 0.4
    },
    normal = {
        buttonWorldDropOffset = 4,
        reactionWindowSec = 0.65
    }
}

local function findCatchSticksParts() -- line: 54
    -- upvalues: Workspace (copy)
    local v3 = Workspace:WaitForChild("CatchSticksGame", 10)

    if v3 ~= nil then
        local v4 = v3:WaitForChild("Button", 10)
        local v5 = v3:WaitForChild("StickGameCamera", 10)
        local v6 = v3:WaitForChild("Sticks", 10)

        if v4 ~= nil and v5 ~= nil and v6 ~= nil then
            if not v5:IsA("BasePart") then
                return nil
            end

            local v7 = v4:FindFirstChildOfClass("ProximityPrompt") or v4:WaitForChild("ProximityPrompt", 10)

            if v7 == nil or not v7:IsA("ProximityPrompt") then
                return nil
            end

            local t2 = {}

            for i = 1, 10 do
                local v8 = v6:WaitForChild(("Stick%*"):format(i), 10)

                if v8 ~= nil and v8:IsA("BasePart") then
                    table.insert(t2, v8)
                end
            end

            return if #t2 ~= 0 then {
                buttonPart = if v4:IsA("BasePart") then v4 else nil,
                cameraPart = v5,
                prompt = v7,
                sticks = t2
            } else nil
        end
    end

    return nil
end

return {
    default = function() -- CatchSticksManager | line: 89
        -- upvalues: RuntimeLib (copy), react (copy), useEffect (copy), useRef (copy), useState (copy), useBindingState (copy), useViewport (copy), HttpService (copy), Players (copy), TweenService (copy), UserInputService (copy), Workspace (copy), catchSticksActiveAtom (copy), useConfig (copy), playClonedSound (copy), hapticCatch (copy), events (copy), functions (copy), rewardPresentationQueue (copy), default (copy), default2 (copy), default3 (copy), default4 (copy), v1 (copy), v2 (copy), t1 (copy), findCatchSticksParts (copy)
        local idle, idle2 = useState("idle")
        local v9, v10 = useState(nil)
        local v11, v12 = useState(nil)
        local v13, v14 = useState(0)
        local v15, v16 = useState(0)
        local v17 = useConfig()
        local disableMovement, enableMovement = v17.disableMovement, v17.enableMovement
        local v18 = useBindingState(useViewport())
        local v22 = math.clamp(math.min(v18.X / 1050, v18.Y / 700), 0.55, 1)
        local idle3 = useRef("idle")
        local v23 = useRef(nil)
        local v24 = useRef(nil)
        local v25 = useRef()
        local v26 = useRef(nil)
        local v27 = useRef(nil)
        local v28 = useRef({})
        local v29 = useRef(nil)
        local v30 = useRef(false)
        local v31 = useRef(false)
        local v32 = useRef(t1.normal)
        local normal = useRef("normal")
        local v33 = useRef({})
        local v34 = useRef({})
        local v35 = useRef({})
        local v36 = useRef({})
        local v37 = useRef({})
        local v38 = useRef({})
        local v39 = useRef({})

        local function setPhaseState(p1) -- line: 119
            -- upvalues: idle2 (copy), idle3 (copy), catchSticksActiveAtom (copy)
            idle3.current = p1
            catchSticksActiveAtom(p1 ~= "idle")
            idle2(p1)
        end

        local function hideInstanceTree(p2) -- line: 126
            -- upvalues: v35 (copy), v36 (copy), v37 (copy), v38 (copy), v39 (copy)
            local function v40(p3) -- line: 127
                -- upvalues: v35 (copy), v36 (copy), v37 (copy), v38 (copy), v39 (copy)
                if p3:IsA("BasePart") then
                    if v35.current[p3] == nil then
                        v35.current[p3] = p3.LocalTransparencyModifier
                    end

                    p3.LocalTransparencyModifier = 1
                elseif p3:IsA("Decal") or p3:IsA("Texture") then
                    if v36.current[p3] == nil then
                        v36.current[p3] = p3.Transparency
                    end

                    p3.Transparency = 1
                else
                    if p3:IsA("BillboardGui") or p3:IsA("SurfaceGui") then
                        if v37.current[p3] == nil then
                            v37.current[p3] = p3.Enabled
                        end
                    else
                        if not (p3:IsA("ParticleEmitter") or p3:IsA("Beam") or p3:IsA("Trail")) then
                            if p3:IsA("Humanoid") then
                                if v39.current[p3] == nil then
                                    v39.current[p3] = p3.DisplayDistanceType
                                end

                                p3.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                            end

                            return
                        end

                        if v38.current[p3] == nil then
                            v38.current[p3] = p3.Enabled
                        end
                    end

                    p3.Enabled = false
                end
            end

            if p2:IsA("BasePart") then
                v40(p2)
            end

            for _, descendant in p2:GetDescendants() do
                v40(descendant)
            end
        end

        local function hideBaitRig(p4) -- line: 190
            -- upvalues: hideInstanceTree (copy), Workspace (copy)
            local HumanoidRootPart = p4:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
                return nil
            end

            local t4 = {}

            for _, v41 in HumanoidRootPart:GetConnectedParts(true) do
                if not v41:IsDescendantOf(p4) then
                    local v42 = v41
                    local v43 = v41

                    while v43.Parent ~= nil and v43.Parent ~= Workspace do
                        local Parent = v43.Parent

                        v43 = Parent
                        v42 = if Parent:IsA("Model") then Parent else v42
                    end

                    if v42 ~= p4 and t4[v42] == nil then
                        t4[v42] = true
                        hideInstanceTree(v42)
                    end
                end
            end
        end

        local function hideAllCharacters() -- line: 223
            -- upvalues: hideInstanceTree (copy), hideBaitRig (copy), Players (copy)
            for _, player in Players:GetPlayers() do
                local Character = player.Character

                if Character ~= nil then
                    hideInstanceTree(Character)
                    hideBaitRig(Character)
                end
            end
        end

        local function restoreAllCharacters() -- line: 233
            -- upvalues: v35 (copy), v36 (copy), v37 (copy), v38 (copy), v39 (copy)
            for v44, v45 in v35.current do
                if v44.Parent ~= nil then
                    v44.LocalTransparencyModifier = v45
                end
            end

            for v46, v47 in v36.current do
                if v46.Parent ~= nil then
                    v46.Transparency = v47
                end
            end

            for v48, v49 in v37.current do
                if v48.Parent ~= nil then
                    v48.Enabled = v49
                end
            end

            for v50, v51 in v38.current do
                if v50.Parent ~= nil then
                    v50.Enabled = v51
                end
            end

            for v52, v53 in v39.current do
                if v52.Parent ~= nil then
                    v52.DisplayDistanceType = v53
                end
            end

            table.clear(v35.current)
            table.clear(v36.current)
            table.clear(v37.current)
            table.clear(v38.current)
            table.clear(v39.current)
        end

        local function hideStick(p5) -- line: 266
            -- upvalues: v34 (copy)
            if v34.current[p5] == nil then
                v34.current[p5] = p5.LocalTransparencyModifier
            end

            p5.LocalTransparencyModifier = 1

            for _, descendant in p5:GetDescendants() do
                if descendant:IsA("BasePart") then
                    if v34.current[descendant] == nil then
                        v34.current[descendant] = descendant.LocalTransparencyModifier
                    end

                    descendant.LocalTransparencyModifier = 1
                end
            end
        end

        local function restoreSticks() -- line: 288
            -- upvalues: v28 (copy), v33 (copy), v34 (copy)
            for v54 in v28.current do
                v54:Cancel()
            end

            table.clear(v28.current)

            for v55, v56 in v34.current do
                if v55.Parent ~= nil then
                    v55.LocalTransparencyModifier = v56
                end
            end

            table.clear(v34.current)

            for v57, v58 in v33.current do
                if v57.Parent ~= nil then
                    v57.CFrame = v58
                end
            end

            table.clear(v33.current)
        end

        local function restoreState() -- line: 306
            -- upvalues: idle2 (copy), v10 (copy), v12 (copy), enableMovement (copy), idle3 (copy), v23 (copy), v24 (copy), v25 (copy), v26 (copy), v27 (copy), v29 (copy), v31 (copy), restoreAllCharacters (copy), restoreSticks (copy), Workspace (copy), catchSticksActiveAtom (copy), v1 (copy)
            local current = v26.current

            if current ~= nil then
                current:Cancel()
            end

            v26.current = nil

            local current2 = v27.current

            if current2 ~= nil then
                current2:Cancel()
            end

            v27.current = nil

            if v29.current ~= nil then
                task.cancel(v29.current)
                v29.current = nil
            end

            restoreSticks()
            restoreAllCharacters()

            if v31.current then
                enableMovement()
                v31.current = false
            end

            local CurrentCamera = Workspace.CurrentCamera
            local current3 = v25.current

            if CurrentCamera ~= nil and current3 ~= nil then
                CurrentCamera.CameraType = current3.cameraType
                CurrentCamera.CFrame = current3.cframe
                CurrentCamera.FieldOfView = current3.fov
            end

            v25.current = nil

            if v24.current ~= nil then
                v24.current.Enabled = true
            end

            local current4 = v23.current

            if current4 ~= nil then
                current4 = current4.buttonPart
            end

            if current4 ~= nil then
                v23.current.buttonPart.Color = v1
            end

            v10(nil)
            v12(nil)
            idle3.current = "idle"
            catchSticksActiveAtom(false)
            idle2("idle")
        end

        local function resolveConsoleKeyCode(p6, p7) -- line: 349
            -- upvalues: v23 (copy), v32 (copy)
            local current = v23.current

            if current ~= nil then
                current = current.sticks
            end

            if current == nil or #current <= 1 then
                return Enum.KeyCode.ButtonY
            end

            local v59 = table.create(#current)

            local function v60(p8) -- line: 360
                -- upvalues: p7 (copy), v32 (copy)
                local v61 = p8.Position.Y - p8.Size.Y / 2

                return {
                    screenX = p7:WorldToViewportPoint((Vector3.new(p8.Position.X, v61 - v32.current.buttonWorldDropOffset, p8.Position.Z))).X,
                    stick = p8
                }
            end

            for v64, v65 in current do
                v59[v64] = v60(v65, v64 - 1, current)
            end

            table.sort(v59, function(p9, p10) -- line: 373
                return p9.screenX < p10.screenX
            end)

            local n1 = -1

            for v66, v67 in v59 do
                local _ = v66 - 1

                if v67.stick == p6 == true then
                    n1 = v66 - 1
                    break
                end
            end

            if n1 < 0 then
                return Enum.KeyCode.ButtonY
            end

            local v69 = math.ceil(#v59 / 3)
            local v71 = math.ceil((#v59 - v69) / 2)

            if n1 < v69 then
                return Enum.KeyCode.ButtonX
            end

            if n1 < v69 + v71 then
                return Enum.KeyCode.ButtonY
            end

            return Enum.KeyCode.ButtonB
        end

        local function catchStick(p11, p12) -- line: 404
            -- upvalues: v10 (copy), idle3 (copy), v27 (copy), v28 (copy), v30 (copy), v32 (copy), hideStick (copy), resolveConsoleKeyCode (copy), TweenService (copy), playClonedSound (copy), hapticCatch (copy)
            local reactionWindowSec = v32.current.reactionWindowSec
            local v72 = p11.Position.Y - p11.Size.Y / 2
            local v74 = p12:WorldToViewportPoint((Vector3.new(p11.Position.X, v72 - v32.current.buttonWorldDropOffset, p11.Position.Z)))
            local v76 = UDim2.fromOffset(math.round(v74.X), (math.round(v74.Y)))
            local v77 = resolveConsoleKeyCode(p11, p12)

            v30.current = false
            v10({
                consoleKeyCode = v77,
                position = v76
            })

            local v78 = p11.CFrame - Vector3.new(0, 6, 0)
            local v79 = TweenService:Create(p11, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                CFrame = v78
            })

            v27.current = v79
            v28.current[v79] = true
            v79:Play()

            local elapsed = os.clock()

            while os.clock() - elapsed < reactionWindowSec and not v30.current and idle3.current == "playing" do
                task.wait()
            end

            v27.current = nil

            if idle3.current == "playing" then
                if v30.current then
                    v79:Cancel()
                    v28.current[v79] = nil
                    hideStick(p11)
                    playClonedSound("PopSound")
                    playClonedSound("ButtonSuccess")
                    hapticCatch()
                    v10({
                        caught = true,
                        consoleKeyCode = v77,
                        position = v76
                    })
                    task.wait(0.4)
                    v10(nil)

                    return true
                end

                playClonedSound("FishSC_Miss")
                v10({
                    missed = true,
                    consoleKeyCode = v77,
                    position = v76
                })
                task.wait(0.5)
                v10(nil)
            end

            return false
        end

        local function playResultSound(p13) -- line: 468
            -- upvalues: playClonedSound (copy)
            if p13 < 2 then
                playClonedSound("Fahh")
            elseif p13 < 4 then
                playClonedSound("RareFishFail")
            elseif p13 > 5 then
                playClonedSound("LavaBucketLevelUp")
            end
        end

        local v80 = RuntimeLib.async(function(p14) -- line: 477
            -- upvalues: idle2 (copy), v12 (copy), v14 (copy), v16 (copy), idle3 (copy), restoreSticks (copy), catchStick (copy), RuntimeLib (copy), HttpService (copy), Workspace (copy), catchSticksActiveAtom (copy), playClonedSound (copy), functions (copy), rewardPresentationQueue (copy)
            task.wait(1)

            if idle3.current ~= "playing" then
                return nil
            end

            playClonedSound("3-2-1Countdown")

            for _, v81 in { 3, 2, 1 } do
                if idle3.current ~= "playing" then
                    return nil
                end

                v12((tostring(v81)))
                task.wait(0.8)
            end

            if idle3.current ~= "playing" then
                return nil
            end

            v12("START!")
            playClonedSound("countdownCompleted")
            task.wait(0.6)
            v12(nil)

            local t5 = {}

            for i = 0, #p14 - 1 do
                table.insert(t5, i)
            end

            for i = #t5 - 1, 1, -1 do
                local v82 = math.random(0, i)
                local v83 = t5[i + 1]

                t5[i + 1] = t5[v82 + 1]
                t5[v82 + 1] = v83
            end

            local n2 = 0

            for _, v84 in t5 do
                if idle3.current ~= "playing" then
                    return nil
                end

                local CurrentCamera = Workspace.CurrentCamera

                if CurrentCamera == nil then
                    return nil
                end

                if catchStick(p14[v84 + 1], CurrentCamera) then
                    n2 += 1
                end

                task.wait(0.5 + math.random() * 1.5)
            end

            if idle3.current ~= "playing" then
                return nil
            end

            restoreSticks()

            if n2 < 2 then
                playClonedSound("Fahh")
            elseif n2 < 4 then
                playClonedSound("RareFishFail")
            elseif n2 > 5 then
                playClonedSound("LavaBucketLevelUp")
            end

            v14(n2)
            v16(0)

            local v85 = RuntimeLib.await(functions.submitCatchSticksResult(n2))

            if v85 == false then
                v85 = 0
            end

            v16(v85)

            if v85 > 0 then
                rewardPresentationQueue:enqueue({
                    kind = "minigameTickets",
                    id = HttpService:GenerateGUID(false),
                    reward = {
                        source = "catchSticks",
                        amount = v85
                    }
                })
            end

            idle3.current = "results"
            catchSticksActiveAtom(true)
            idle2("results")
        end)

        local function enterModeSelect() -- line: 546
            -- upvalues: idle2 (copy), disableMovement (copy), idle3 (copy), v23 (copy), v24 (copy), v31 (copy), catchSticksActiveAtom (copy), v2 (copy)
            if idle3.current ~= "idle" then
                return nil
            end

            local current = v23.current

            if current == nil then
                return nil
            end

            disableMovement()
            v31.current = true

            if v24.current ~= nil then
                v24.current.Enabled = false
            end

            if current.buttonPart ~= nil then
                current.buttonPart.Color = v2
            end

            idle3.current = "modeSelect"
            catchSticksActiveAtom(true)
            idle2("modeSelect")
        end

        local function startGame(p15) -- line: 564
            -- upvalues: idle2 (copy), idle3 (copy), v23 (copy), v25 (copy), v26 (copy), v29 (copy), v32 (copy), normal (copy), v33 (copy), hideAllCharacters (copy), v80 (copy), TweenService (copy), UserInputService (copy), Workspace (copy), catchSticksActiveAtom (copy), events (copy), t1 (copy)
            if idle3.current ~= "modeSelect" then
                return nil
            end

            local current = v23.current
            local CurrentCamera = Workspace.CurrentCamera

            if current == nil or CurrentCamera == nil then
                return nil
            end

            local v86 = t1[p15]

            if p15 == "insane" and UserInputService.KeyboardEnabled then
                v86 = table.clone(v86)
                setmetatable(v86, nil)
                v86.reactionWindowSec = 0.5
            end

            v32.current = v86
            normal.current = p15
            events.catchSticksGameStarted:fire(p15)
            hideAllCharacters()
            table.clear(v33.current)

            for _, v87 in current.sticks do
                v33.current[v87] = v87.CFrame
            end

            v25.current = {
                cameraType = CurrentCamera.CameraType,
                cframe = CurrentCamera.CFrame,
                fov = CurrentCamera.FieldOfView
            }
            CurrentCamera.CameraType = Enum.CameraType.Scriptable
            v26.current = TweenService:Create(CurrentCamera, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                CFrame = current.cameraPart.CFrame
            })
            v26.current:Play()
            idle3.current = "playing"
            catchSticksActiveAtom(true)
            idle2("playing")
            v29.current = task.spawn(function() -- line: 605
                -- upvalues: current (copy), v80 (copy)
                return v80(current.sticks)
            end)
        end

        useEffect(function() -- line: 609
            -- upvalues: idle2 (copy), disableMovement (copy), enableMovement (copy), idle3 (copy), v23 (copy), v24 (copy), v25 (copy), v26 (copy), v27 (copy), v29 (copy), v31 (copy), restoreAllCharacters (copy), restoreSticks (copy), Players (copy), Workspace (copy), catchSticksActiveAtom (copy), v1 (copy), v2 (copy), findCatchSticksParts (copy)
            local v88 = false
            local connection

            task.spawn(function() -- line: 612
                -- upvalues: v88 (ref), connection (ref), idle2 (copy), disableMovement (copy), idle3 (copy), v23 (copy), v24 (copy), v31 (copy), Players (copy), catchSticksActiveAtom (copy), v1 (copy), v2 (copy), findCatchSticksParts (copy)
                local v89 = findCatchSticksParts()

                if v88 then
                    return nil
                end

                if v89 == nil then
                    warn("[CatchSticks] Missing Workspace.CatchSticksGame parts (Button/StickGameCamera/Sticks)")

                    return nil
                end

                v23.current = v89
                v24.current = v89.prompt

                if v89.buttonPart ~= nil then
                    v89.buttonPart.Color = v1
                end

                connection = v89.prompt.Triggered:Connect(function(p16) -- line: 626
                    -- upvalues: idle2 (copy), disableMovement (copy), idle3 (copy), v23 (copy), v24 (copy), v31 (copy), Players (copy), catchSticksActiveAtom (copy), v2 (copy)
                    if p16 ~= nil and p16 ~= Players.LocalPlayer then
                        return nil
                    end

                    if idle3.current == "idle" then
                        local current = v23.current

                        if current ~= nil then
                            disableMovement()
                            v31.current = true

                            if v24.current ~= nil then
                                v24.current.Enabled = false
                            end

                            if current.buttonPart ~= nil then
                                current.buttonPart.Color = v2
                            end

                            idle3.current = "modeSelect"
                            catchSticksActiveAtom(true)
                            idle2("modeSelect")
                        end
                    end
                end)
            end)

            return function() -- line: 633
                -- upvalues: v88 (ref), connection (ref), enableMovement (copy), v23 (copy), v25 (copy), v26 (copy), v27 (copy), v29 (copy), v31 (copy), restoreAllCharacters (copy), restoreSticks (copy), Workspace (copy), catchSticksActiveAtom (copy), v1 (copy)
                v88 = true
                catchSticksActiveAtom(false)

                local connection2 = connection

                if connection2 ~= nil then
                    connection2:Disconnect()
                end

                local current = v26.current

                if current ~= nil then
                    current:Cancel()
                end

                local current2 = v27.current

                if current2 ~= nil then
                    current2:Cancel()
                end

                if v29.current ~= nil then
                    task.cancel(v29.current)
                    v29.current = nil
                end

                restoreSticks()
                restoreAllCharacters()

                if v31.current then
                    enableMovement()
                    v31.current = false
                end

                local current3 = v23.current

                if current3 ~= nil then
                    current3 = current3.buttonPart
                end

                if current3 ~= nil then
                    v23.current.buttonPart.Color = v1
                end

                local CurrentCamera = Workspace.CurrentCamera
                local current4 = v25.current

                if CurrentCamera == nil or current4 == nil then
                    return
                end

                CurrentCamera.CameraType = current4.cameraType
                CurrentCamera.CFrame = current4.cframe
                CurrentCamera.FieldOfView = current4.fov
            end
        end, {})

        if idle == "idle" then
            return nil
        end

        local createElement = react.createElement
        local t6 = {
            IgnoreGuiInset = true,
            ResetOnSpawn = false,
            ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        }
        local v90 = idle == "modeSelect" and react.createElement(default3, {
            onClose = restoreState,
            onSelect = startGame,
            uiScale = v22
        })
        local v91 = idle == "playing" and v11 ~= nil and react.createElement(default4, {
            key = v11,
            label = v11,
            uiScale = v22
        })
        local v92

        if idle ~= "playing" then
            v92 = false

            return createElement("screengui", t6, v90, v91, v92, idle == "results" and react.createElement(default2, {
                total = 10,
                onClose = restoreState,
                score = v13,
                ticketsAwarded = v15,
                uiScale = v22
            }))
        end

        if v9 ~= nil then
            v92 = react.createElement(default, {
                caught = v9.caught,
                consoleKeyCode = v9.consoleKeyCode,
                missed = v9.missed,
                onCatch = function() -- onCatch | line: 694
                    -- upvalues: v30 (copy)
                    v30.current = true
                end,
                position = v9.position,
                windowSec = v32.current.reactionWindowSec
            })
        else
            v92 = false
        end

        return createElement("screengui", t6, v90, v91, v92, idle == "results" and react.createElement(default2, {
            total = 10,
            onClose = restoreState,
            score = v13,
            ticketsAwarded = v15,
            uiScale = v22
        }))
    end
}
