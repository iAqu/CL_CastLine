-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local AreaGuiController = require(ReplicatedStorage.Controllers.GUI.AreaGuiController)
local Audio = require(ReplicatedStorage.Shared.Audio)
local BossMastery = require(script.BossMastery)
local BossPortal = require(script.BossPortal)
local ChaseView = require(script.ChaseView)
local ChromaBeacon = require(script.ChromaBeacon)
local EggShop = require(script.EggShop)
local EggHighlights = require(script.EggHighlights)
local GhostDogQuest = require(ReplicatedStorage.Data.GhostDogQuest)
local HalloweenDimension = require(ReplicatedStorage.Shared.Util.HalloweenDimension)
local HalloweenDimensionEligibility = require(ReplicatedStorage.Shared.Util.HalloweenDimensionEligibility)
local HeadlessHorseman = require(script.HeadlessHorseman)
local HitFeedback = require(ReplicatedStorage.Controllers.Game.ScrambleClientController.HitFeedback)
local LightingController = require(ReplicatedStorage.Controllers.Game.LightingController)
local ManorGate = require(script.ManorGate)
local ManorGateTimer = require(script.ManorGateTimer)
local MonsterDeath = require(script.MonsterDeath)
local Music = require(script.Music)
local NightCycle = require(script.NightCycle)
local PumpkinBoss = require(script.PumpkinBoss)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Transition = require(script.Transition)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Tutorial = require(script.Tutorial)
local WorldEvents = require(script.WorldEvents)
local LocalPlayer = Players.LocalPlayer
local v1 = Color3.fromRGB(255, 96, 96)
local PlayerAttributes = HalloweenDimension.PlayerAttributes
local v2 = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v3 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local v4 = TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local ZoneGradients = ReplicatedStorage.Assets.HalloweenDimension:WaitForChild("ZoneGradients")
local LockedPortal = ReplicatedStorage.Assets.HalloweenDimension:WaitForChild("LockedPortal")
local Label = ReplicatedStorage.Assets.UI:WaitForChild("Scramble"):WaitForChild("Label")
local t1 = {}

local function child(p1, p2) -- line: 86
    local v5 = p1:WaitForChild(p2, 10)

    if v5 == nil then
        error((("HalloweenDimensionUI is missing %*.%*"):format(p1:GetFullName(), p2)))
    end

    return v5
end

local function bindUi(p3) -- line: 94
    local v6 = p3:WaitForChild("Chase", 10)

    if v6 == nil then
        error((("HalloweenDimensionUI is missing %*.Chase"):format((p3:GetFullName()))))
    end

    local v7 = p3:WaitForChild("Alert", 10)

    if v7 == nil then
        error((("HalloweenDimensionUI is missing %*.Alert"):format((p3:GetFullName()))))
    end

    local t2 = {
        Gui = p3,
        Chase = v6
    }
    local v8 = v6:WaitForChild("Distance", 10)

    if v8 == nil then
        error((("HalloweenDimensionUI is missing %*.Distance"):format((v6:GetFullName()))))
    end

    t2.Distance = v8

    local v9 = p3:WaitForChild("Vignette", 10)

    if v9 == nil then
        error((("HalloweenDimensionUI is missing %*.Vignette"):format((p3:GetFullName()))))
    end

    t2.Vignette = v9

    local v10 = p3:WaitForChild("Damage", 10)

    if v10 == nil then
        error((("HalloweenDimensionUI is missing %*.Damage"):format((p3:GetFullName()))))
    end

    t2.Damage = v10

    local v11 = p3:WaitForChild("Fade", 10)

    if v11 == nil then
        error((("HalloweenDimensionUI is missing %*.Fade"):format((p3:GetFullName()))))
    end

    t2.Fade = v11
    t2.Alert = v7

    local v12 = v7:WaitForChild("UIScale", 10)

    if v12 == nil then
        error((("HalloweenDimensionUI is missing %*.UIScale"):format((v7:GetFullName()))))
    end

    t2.AlertScale = v12

    local v13 = v7:WaitForChild("SubAlert", 10)

    if v13 == nil then
        error((("HalloweenDimensionUI is missing %*.SubAlert"):format((v7:GetFullName()))))
    end

    t2.SubAlert = v13

    return t2
end

local function isEligible() -- line: 110
    -- upvalues: HalloweenDimensionEligibility (copy), Save (copy)
    local v14 = Save.Peek()

    if v14 ~= nil and type(v14.SpeedPower) == "number" then
        return (HalloweenDimensionEligibility.IsEligible(v14.SpeedPower))
    end

    return false
end

local function finishedTutorial() -- line: 117
    -- upvalues: Save (copy)
    local v15 = Save.Peek()

    return v15 ~= nil and v15.GuardTutorialProgress.Completed
end

local function dimensionMap() -- line: 122
    -- upvalues: Workspace (copy), HalloweenDimension (copy)
    local v16 = Workspace:FindFirstChild(HalloweenDimension.MapName)

    return if v16 ~= nil and v16:IsA("Model") then v16 else nil
end

local function zoneAt(p4, p5) -- line: 127
    local Zones = p4:FindFirstChild("Zones")

    assert(Zones ~= nil, "Halloween map is missing Zones")

    for _, child in Zones:GetChildren() do
        if child:IsA("BasePart") then
            local v18 = child.CFrame:PointToObjectSpace(p5)

            if not (math.abs(v18.X) > child.Size.X * 0.5) and not (math.abs(v18.Z) > child.Size.Z * 0.5) then
                if child.Name == "SafeZone" then
                    return 0
                end

                return (tonumber(string.match(child.Name, "^Zone(%d+)$")))
            end
        end
    end

    return nil
end

local function beaconOf(p6) -- line: 145
    local v19 = if p6 == nil then nil else p6:FindFirstChild("Beacon", true)

    return if v19 ~= nil and v19:IsA("Beam") then v19 else nil
end

function t1.Start() -- line: 154
    -- upvalues: GuiService (copy), RunService (copy), TweenService (copy), Workspace (copy), AreaGuiController (copy), Audio (copy), BossMastery (copy), BossPortal (copy), ChaseView (copy), ChromaBeacon (copy), EggShop (copy), EggHighlights (copy), GhostDogQuest (copy), HalloweenDimension (copy), HalloweenDimensionEligibility (copy), HeadlessHorseman (copy), HitFeedback (copy), LightingController (copy), ManorGate (copy), ManorGateTimer (copy), MonsterDeath (copy), Music (copy), NightCycle (copy), PumpkinBoss (copy), Remotes (copy), Save (copy), Transition (copy), Trove (copy), Tutorial (copy), WorldEvents (copy), LocalPlayer (copy), v1 (copy), PlayerAttributes (copy), v2 (copy), v3 (copy), v4 (copy), ZoneGradients (copy), LockedPortal (copy), Label (copy), bindUi (copy), zoneAt (copy)
    local v20 = Trove.new()
    local v21 = EggHighlights.new()

    v20:Add(v21.Destroy)
    PumpkinBoss.Start(v20)

    local HalloweenDimensionUI = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("HalloweenDimensionUI")
    local v22 = bindUi(HalloweenDimensionUI)
    local World = Workspace:WaitForChild("World")
    local t3
    local v23 = false
    local v24 = nil
    local v25 = false
    local n1 = 0
    local v26
    local n2 = 0

    local function alert(p7, p8, p9, p10) -- line: 171
        -- upvalues: v22 (copy), n2 (ref), GuiService (copy), TweenService (copy), v2 (copy), v3 (copy)
        n2 += 1

        local v27 = n2
        local t4 = {
            v22.Alert,
            v22.SubAlert
        }

        v22.Alert.Text = p7
        v22.Alert.TextColor3 = p8
        v22.SubAlert.Text = p10 or ""
        v22.Alert.Visible = true

        for _, v28 in t4 do
            v28.TextTransparency = 0

            local UIStroke = v28:FindFirstChildOfClass("UIStroke")

            if UIStroke ~= nil then
                UIStroke.Transparency = 0
            end
        end

        if GuiService.ReducedMotionEnabled then
            v22.AlertScale.Scale = 1
        else
            v22.AlertScale.Scale = 0.6
            TweenService:Create(v22.AlertScale, v2, {
                Scale = 1
            }):Play()
        end

        task.delay(p9 or 2, function() -- line: 192
            -- upvalues: v27 (copy), t4 (copy), n2 (ref), TweenService (copy), v3 (copy)
            if v27 ~= n2 then
                return
            end

            for _, v29 in t4 do
                TweenService:Create(v29, v3, {
                    TextTransparency = 1
                }):Play()

                local UIStroke = v29:FindFirstChildOfClass("UIStroke")

                if UIStroke ~= nil then
                    TweenService:Create(UIStroke, v3, {
                        Transparency = 1
                    }):Play()
                end
            end
        end)
    end

    local function syncChase() -- line: 206
        -- upvalues: v22 (copy), v24 (ref), v25 (ref), alert (copy), Workspace (copy), ChaseView (copy), HalloweenDimension (copy), LocalPlayer (copy), PlayerAttributes (copy)
        if LocalPlayer:GetAttribute(PlayerAttributes.Carrying) == true then
            local v30 = Workspace:FindFirstChild(HalloweenDimension.MapName)

            if v30 == nil or not v30:IsA("Model") then
                v30 = nil
            end

            if not v25 and v30 ~= nil then
                v25 = true

                if v24 ~= nil then
                    v24:Destroy()
                end

                local new = ChaseView.new
                local t5 = {
                    Chase = v22.Chase,
                    Distance = v22.Distance,
                    Vignette = v22.Vignette
                }
                local v31 = if v30 == nil then nil else v30:FindFirstChild("Beacon", true)

                if v31 == nil or not v31:IsA("Beam") then
                    v31 = nil
                end

                v24 = new(v30, t5, alert, v31)
            end
        else
            local v32 = v24

            if v25 and v32 ~= nil then
                v25 = false

                local Attribute = LocalPlayer:GetAttribute(PlayerAttributes.Delivered)

                task.delay(0.35, function() -- line: 230
                    -- upvalues: v32 (copy), Attribute (copy), v24 (ref), LocalPlayer (copy), PlayerAttributes (copy)
                    if v24 == v32 then
                        v24 = nil
                        v32:Finish(LocalPlayer:GetAttribute(PlayerAttributes.Delivered) ~= Attribute)
                    end
                end)
            end
        end
    end

    local function ghostCaught(p11) -- line: 239
        -- upvalues: v22 (copy), alert (copy), TweenService (copy), Audio (copy), v1 (copy), v4 (copy)
        alert(p11, v1, 2.2)
        v22.Damage.ImageTransparency = 0.15
        TweenService:Create(v22.Damage, v4, {
            ImageTransparency = 1
        }):Play()
        Audio.Play("rbxassetid://131844023775097", script, {
            Volume = 0.4,
            PlaybackSpeed = 0.8
        })
    end

    local function syncZone() -- line: 246
        -- upvalues: v23 (ref), n1 (ref), v26 (ref), Workspace (copy), AreaGuiController (copy), GhostDogQuest (copy), HalloweenDimension (copy), LocalPlayer (copy), ZoneGradients (copy), zoneAt (copy)
        local v33 = Workspace:FindFirstChild(HalloweenDimension.MapName)

        if v33 == nil or not v33:IsA("Model") then
            v33 = nil
        end

        local Character = LocalPlayer.Character
        local HumanoidRootPart = if Character == nil then nil else Character:FindFirstChild("HumanoidRootPart")

        if v23 and v33 ~= nil and HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then
            if LocalPlayer:GetAttribute(GhostDogQuest.ChaseAttribute) ~= nil then
                v26 = nil
            else
                local v34 = zoneAt(v33, HumanoidRootPart.Position)

                if v34 ~= nil then
                    if v34 < n1 then
                        local elapsed = os.clock()
                        local v35 = v26 or elapsed

                        v26 = v35

                        if elapsed - v35 >= 3 then
                            n1 = v34
                            v26 = nil
                        end
                    else
                        v26 = nil

                        if v34 ~= n1 then
                            n1 = v34

                            local v36 = HalloweenDimension.Zones[v34]
                            local v37 = ZoneGradients:FindFirstChild((("Zone%*"):format(v34)))

                            assert(v36 ~= nil and v37 ~= nil, (("Halloween zone %* has no display info"):format(v34)))
                            AreaGuiController.Show(v36.DisplayName, v36.Emoji, v37)
                        end
                    end
                end
            end
        end
    end

    local function syncInside() -- line: 282
        -- upvalues: HalloweenDimensionUI (copy), v22 (copy), v23 (ref), v24 (ref), v25 (ref), n1 (ref), alert (copy), syncChase (copy), Workspace (copy), HalloweenDimension (copy), LightingController (copy), LocalPlayer (copy), PlayerAttributes (copy)
        local v40 = LocalPlayer:GetAttribute(PlayerAttributes.Inside) == true

        if v40 ~= v23 then
            v23 = v40

            if v23 then
                if LightingController.Presets[HalloweenDimension.LightingPreset] ~= nil then
                    LightingController.SetLayer("HalloweenDimension", HalloweenDimension.LightingPreset, 150, 0.8)
                end

                v22.Chase.Visible = false
                v22.Vignette.ImageTransparency = 1
                v22.Damage.ImageTransparency = 1
                HalloweenDimensionUI.Enabled = true

                local Attribute = Workspace:GetAttribute(HalloweenDimension.Attributes.WorldEventText)

                if type(Attribute) == "string" then
                    alert("THE CORRUPTED REALM", Color3.fromRGB(255, 150, 60), 5, Attribute)
                else
                    alert("THE CORRUPTED REALM", Color3.fromRGB(255, 150, 60), 2.4)
                end

                syncChase()
            else
                LightingController.ClearLayer("HalloweenDimension", 0.8)

                if v24 ~= nil then
                    v24:Destroy()
                    v24 = nil
                end

                v25 = false
                n1 = 0
                task.delay(1, function() -- line: 321
                    -- upvalues: HalloweenDimensionUI (copy), v23 (ref)
                    if not v23 then
                        HalloweenDimensionUI.Enabled = false
                    end
                end)
            end
        end
    end

    local Folder = Instance.new("Folder")
    local clone

    local function bindPortal(p12) -- line: 333
        -- upvalues: v20 (copy), World (copy), t3 (ref), Folder (copy)
        t3 = {
            Model = p12
        }
        v20:Connect(p12.AncestryChanged, function() -- line: 337
            -- upvalues: p12 (copy), World (copy), t3 (ref), Folder (copy)
            local t6 = t3

            if t6 ~= nil and t6.Model == p12 and p12.Parent ~= World and p12.Parent ~= Folder then
                t3 = nil
            end
        end)
    end

    local function refresh() -- line: 351
        -- upvalues: World (copy), t3 (ref), Folder (copy), clone (ref), HalloweenDimensionEligibility (copy), Save (copy), LockedPortal (copy)
        local t7 = t3
        local v41 = false

        if t7 ~= nil then
            local v42 = Save.Peek()

            v41 = v42 ~= nil and v42.GuardTutorialProgress.Completed
        end

        local v43 = Save.Peek()
        local v44 = v43 ~= nil and type(v43.SpeedPower) == "number" and HalloweenDimensionEligibility.IsEligible(v43.SpeedPower)

        if t7 ~= nil then
            local v45 = if v41 and v44 then World else Folder

            if t7.Model.Parent ~= v45 then
                t7.Model.Parent = v45
            end
        end

        local clone2 = clone

        if not v41 or v44 then
            if clone2 ~= nil then
                clone2:Destroy()
                clone = nil
            end
        elseif clone2 == nil then
            local clone2 = LockedPortal:Clone()

            clone2:FindFirstChild("Status", true).Text = ("Unlocks at %* speed"):format((HalloweenDimensionEligibility.RequirementText()))
            clone2.Parent = World
            clone = clone2
        end
    end

    v20:Connect(World.ChildAdded, function(p13) -- line: 376
        -- upvalues: v20 (copy), World (copy), t3 (ref), Folder (copy), refresh (copy), HalloweenDimension (copy)
        local t8 = t3

        if p13.Name == HalloweenDimension.PortalName and p13:IsA("Model") and (t8 == nil or t8.Model ~= p13) then
            t3 = {
                Model = p13
            }
            v20:Connect(p13.AncestryChanged, function() -- line: 337
                -- upvalues: p13 (copy), World (copy), t3 (ref), Folder (copy)
                local t9 = t3

                if t9 ~= nil and t9.Model == p13 and p13.Parent ~= World and p13.Parent ~= Folder then
                    t3 = nil
                end
            end)
            refresh()
        end
    end)

    local v46 = World:FindFirstChild(HalloweenDimension.PortalName)

    if v46 ~= nil and v46:IsA("Model") then
        t3 = {
            Model = v46
        }
        v20:Connect(v46.AncestryChanged, function() -- line: 337
            -- upvalues: World (copy), t3 (ref), Folder (copy), v46 (copy)
            local t10 = t3

            if t10 ~= nil and t10.Model == v46 and v46.Parent ~= World and v46.Parent ~= Folder then
                t3 = nil
            end
        end)
    end

    v20:Connect(LocalPlayer:GetAttributeChangedSignal(PlayerAttributes.Inside), syncInside)
    v20:Connect(LocalPlayer:GetAttributeChangedSignal(PlayerAttributes.Carrying), function() -- line: 393
        -- upvalues: syncChase (copy)
        task.defer(syncChase)
    end)
    v20:Connect(LocalPlayer:GetAttributeChangedSignal(PlayerAttributes.Lost), function() -- line: 396
        -- upvalues: alert (copy), Audio (copy), v1 (copy)
        alert("YOU LOST YOUR EGG!", v1, 2.2)
        Audio.Play("rbxassetid://131844023775097", script, {
            Volume = 0.4,
            PlaybackSpeed = 0.8
        })
    end)
    v20:Connect(LocalPlayer:GetAttributeChangedSignal(PlayerAttributes.Seized), function() -- line: 400
        -- upvalues: ghostCaught (copy)
        ghostCaught("THE GHOST TOOK YOUR EGG BACK!")
    end)
    v20:Connect(LocalPlayer:GetAttributeChangedSignal(PlayerAttributes.Dropped), function() -- line: 403
        -- upvalues: ghostCaught (copy)
        ghostCaught("THE GHOST KNOCKED YOUR EGG AWAY!")
    end)
    v20:Connect(LocalPlayer:GetAttributeChangedSignal(PlayerAttributes.Knocked), function() -- line: 406
        -- upvalues: alert (copy), Audio (copy), v1 (copy)
        alert("YOUR EGG WAS KNOCKED AWAY!", v1, 2.2)
        Audio.Play("rbxassetid://131844023775097", script, {
            Volume = 0.4,
            PlaybackSpeed = 0.8
        })
    end)

    local v47 = HitFeedback.new(LocalPlayer:WaitForChild("PlayerGui"), Label)

    v20:Add(v47.Destroy)
    v20:Connect(RunService.RenderStepped, v47.Step)
    v20:Connect(Remotes.HalloweenDimension.MonsterHit.OnClientEvent, function(p14, p15) -- line: 416
        -- upvalues: v47 (copy)
        local Parent = if p14 == nil then nil else p14.Parent

        if p14 ~= nil and Parent ~= nil and Parent:IsA("Model") then
            v47.Hit(Parent, p14.Position + Vector3.new(0, p14.Size.Y / 2, 0), p15)
        end
    end)

    local n3 = 0.2

    v20:Connect(RunService.Heartbeat, function(p16) -- line: 429
        -- upvalues: v21 (copy), v23 (ref), syncZone (copy), refresh (copy), n3 (ref), Workspace (copy), HalloweenDimension (copy), LocalPlayer (copy)
        n3 += p16

        if not (n3 >= 0.2) then
            return
        end

        n3 = 0
        refresh()
        syncZone()

        local Character = LocalPlayer.Character
        local HumanoidRootPart = if Character == nil then nil else Character:FindFirstChild("HumanoidRootPart")
        local Step = v21.Step
        local v49 = Workspace:FindFirstChild(HalloweenDimension.MapName)

        if v49 == nil or not v49:IsA("Model") then
            v49 = nil
        end

        Step(v49, v23, if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then nil else HumanoidRootPart.Position)
    end)
    Transition.Start(v20)
    ManorGate.Start(v20)
    ManorGateTimer.Start(v20)
    BossPortal.Start(v20)
    EggShop.Start(v20)
    HeadlessHorseman.Start(v20)
    BossMastery.Start(v20)
    MonsterDeath.Start(v20)
    ChromaBeacon.Start(v20)
    WorldEvents.Start(v20)
    Music.Start(v20)
    NightCycle.Start(v20)
    Tutorial.Start(v20)
    syncInside()
    refresh()

    return v20
end

return t1
