-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local AssetRoster = require(ReplicatedStorage.Client.AssetRoster)
local Buddy = require(script.Parent.Buddy)
local Assets = require(ReplicatedStorage.Data.Assets)
local MountControls = require(script.Parent.MountControls)
local StarConfirmation = require(script.Parent.StarConfirmation)
local Save = require(ReplicatedStorage.Shared.Save)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Fx = require(script.Parent.Fx)
local GUI = require(ReplicatedStorage.Client.GUI)
local Lanes = require(ReplicatedStorage.Client.Notifications.Lanes)
local PetMountFlags = require(ReplicatedStorage.Shared.Flags.PetMountFlags)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local SmartProximityPrompt = require(ReplicatedStorage.Client.SmartProximityPrompt)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = Color3.fromRGB(255, 216, 77)
local v2 = Color3.fromRGB(255, 170, 30)
local v3 = Color3.fromRGB(255, 100, 100)
local v4 = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v5 = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local LocalPlayer = Players.LocalPlayer
local v6
local t1 = {}
local t2 = {}
local t3 = {}
local t4 = {}
local t5 = {}
local v7 = false
local v8 = false
local v9 = false
local t6 = {}

local function activeAssets() -- line: 77
    -- upvalues: ReplicatedStorage (copy), v6 (ref)
    if v6 == nil then
        v6 = require(ReplicatedStorage.Controllers.Game.Plots.ActiveAssetsController)
    end

    return v6
end

local function folder() -- line: 84
    -- upvalues: Workspace (copy)
    local StarFeedClient = Workspace:FindFirstChild("StarFeedClient")

    if StarFeedClient then
        return StarFeedClient
    end

    local Folder = Instance.new("Folder")

    Folder.Name = "StarFeedClient"
    Folder.Parent = Workspace

    return Folder
end

local function smooth(p1) -- line: 95
    local v10 = math.clamp(p1, 0, 1)

    return v10 * v10 * (3 - v10 * 2)
end

local function holdingStar() -- line: 100
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character

    if Character ~= nil then
        for _, child in Character:GetChildren() do
            if child:IsA("Tool") and child:GetAttribute("ItemType") == "MountStar" then
                return true
            end
        end
    end

    return false
end

local function mounted() -- line: 113
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character

    return Character ~= nil and Character:FindFirstChild("PetMountSession") ~= nil
end

local function eggPromptInView() -- line: 118
    -- upvalues: t2 (copy)
    for v11 in t2 do
        if v11.Parent ~= nil and v11.Enabled then
            return true
        end

        t2[v11] = nil
    end

    return false
end

local function syncRidePrompts() -- line: 128
    -- upvalues: MountControls (copy), t1 (copy), t2 (copy)
    local v12 = false
    local v13

    for v14 in t2 do
        if v14.Parent ~= nil and v14.Enabled then
            v13 = true
            v12 = true
            break
        end

        t2[v14] = nil
    end

    if not v12 then
        v13 = false
    end

    for _, v15 in t1 do
        if v15.Mode == "Ride" and v15.Prompt.Enabled == v13 then
            v15.Prompt.Enabled = not v13
        end
    end

    MountControls.Refresh()
end

local function currentMode() -- line: 138
    -- upvalues: Tabs (copy), PetMountFlags (copy), LocalPlayer (copy), v7 (ref), holdingStar (copy)
    if not PetMountFlags.Enabled:Get() or v7 or Tabs.Active() ~= nil then
        return "None"
    end

    if holdingStar() then
        return "Feed"
    end

    local Character = LocalPlayer.Character

    if Character ~= nil and Character:FindFirstChild("PetMountSession") ~= nil then
        return "None"
    end

    return "Ride"
end

local function displayName(p2) -- line: 151
    -- upvalues: Assets (copy)
    local v16 = Assets.Directory[p2]

    if not (v16 and v16.DisplayName) then
        return p2
    end

    return v16.DisplayName
end

local function rarityHex(p3) -- line: 156
    -- upvalues: Assets (copy)
    local v17 = Assets.Directory[p3]
    local Color = if not (v17 and v17.Rarity) then nil else v17.Rarity.Color

    if typeof(Color) == "Color3" then
        return (("#%*"):format((Color:ToHex())))
    end

    return "#FFD84D"
end

local function unbind(p4) -- line: 162
    -- upvalues: t1 (copy)
    local v18 = t1[p4]

    if v18 == nil then
        return
    end

    t1[p4] = nil
    v18.Cleanup()
    v18.Prompt:Destroy()
end

local refresh

local function ride(p5) -- line: 174
    -- upvalues: Remotes (copy), Toast (copy), v3 (copy)
    local function v19() -- line: 175
        -- upvalues: p5 (copy), Remotes (copy)
        return Remotes.PetMount.Request:InvokeServer("mount", p5)
    end

    local v20, v21, v22 = pcall(v19)

    if v20 and v21 == false and typeof(v22) == "string" then
        Toast.Show({
            Seconds = 2.5,
            SingleLine = true,
            Text = v22,
            Color = v3
        })
    end
end

local function askToFeed(p6, p7) -- line: 183
    -- upvalues: TweenService (copy), AssetRoster (copy), StarConfirmation (copy), Save (copy), Tabs (copy), Fx (copy), GUI (copy), PetMountFlags (copy), Remotes (copy), Toast (copy), Trove (copy), v3 (copy), v4 (copy), v5 (copy), LocalPlayer (copy), t5 (copy), v7 (ref), v8 (ref), holdingStar (copy), refresh (ref)
    if not v7 and not v8 and holdingStar() then
        local v23, v24 = StarConfirmation.Resolve(p6, p7)

        v7 = true
        refresh()

        local v25 = Trove.new()
        local Pop = v24:FindFirstChild("Pop")

        Pop.Scale = 0.6
        v24.Visible = true
        v23.Enabled = true
        TweenService:Create(Pop, v4, {
            Scale = 1
        }):Play()
        Fx.Sound("BuddyNotice", nil, 0.6)

        local v26 = false

        local function close() -- line: 200
            -- upvalues: v23 (copy), v24 (copy), v25 (copy), Pop (copy), v26 (ref), TweenService (copy), v5 (copy), v7 (ref), refresh (ref)
            if v26 then
                return
            end

            v26 = true
            v25:Destroy()

            local tween = TweenService:Create(Pop, v5, {
                Scale = 0.6
            })

            tween:Play()
            tween.Completed:Once(function() -- line: 208
                -- upvalues: v23 (copy), v24 (copy), v7 (ref)
                if not v7 then
                    v24.Visible = false
                    v23.Enabled = false
                end
            end)
            v7 = false
            refresh()
        end

        local function answer(p8) -- line: 218
            -- upvalues: p6 (copy), v24 (copy), v26 (ref), close (copy), Remotes (copy), Toast (copy), v3 (copy), t5 (copy), v8 (ref)
            if v26 then
                return
            end

            local v27 = v24.AbsolutePosition + v24.AbsoluteSize / 2

            close()

            if not p8 then
                return
            end

            t5[p6] = v27
            v8 = true
            task.spawn(function() -- line: 229
                -- upvalues: p6 (copy), Remotes (copy), Toast (copy), v3 (copy), t5 (copy), v8 (ref)
                local function v28() -- line: 230
                    -- upvalues: p6 (copy), Remotes (copy)
                    return Remotes.ShootingStar.AskFeed:InvokeServer(p6)
                end

                local v29, v30, v31 = pcall(v28)

                v8 = false

                if v29 and v30 == true then
                    return
                end

                t5[p6] = nil
                Toast.Show({
                    Seconds = 2.5,
                    SingleLine = true,
                    Text = if typeof(v31) == "string" then v31 else "Couldn't feed the Star. Try again.",
                    Color = v3
                })
            end)
        end

        for v32, v33 in {
                Yes = true,
                No = false,
                Close = false
            } do
            local v34 = v24.Content:FindFirstChild(v32)

            if v34 and v34:IsA("GuiButton") then
                v25:Add(GUI.OnActivated(v34, function() -- line: 251
                    -- upvalues: p6 (copy), v24 (copy), v26 (ref), close (copy), v33 (copy), Remotes (copy), Toast (copy), v3 (copy), t5 (copy), v8 (ref)
                    if v26 then
                        return
                    end

                    local v35 = v24.AbsolutePosition + v24.AbsoluteSize / 2

                    close()

                    if not v33 then
                        return
                    end

                    t5[p6] = v35
                    v8 = true
                    task.spawn(function() -- line: 229
                        -- upvalues: p6 (copy), Remotes (copy), Toast (copy), v3 (copy), t5 (copy), v8 (ref)
                        local function v36() -- line: 230
                            -- upvalues: p6 (copy), Remotes (copy)
                            return Remotes.ShootingStar.AskFeed:InvokeServer(p6)
                        end

                        local v37, v38, v39 = pcall(v36)

                        v8 = false

                        if v37 and v38 == true then
                            return
                        end

                        t5[p6] = nil
                        Toast.Show({
                            Seconds = 2.5,
                            SingleLine = true,
                            Text = if typeof(v39) == "string" then v39 else "Couldn't feed the Star. Try again.",
                            Color = v3
                        })
                    end)
                end))
            end
        end

        StarConfirmation.Bind(v23, v24, v25, close)
        v25:Connect(Tabs.Activated, close)
        v25:Connect(PetMountFlags.Enabled.Changed, function() -- line: 258
            -- upvalues: close (copy), PetMountFlags (copy)
            if not PetMountFlags.Enabled:Get() then
                close()
            end
        end)
        v25:Connect(AssetRoster.OwnerRefreshed, function(p9) -- line: 261
            -- upvalues: p6 (copy), p7 (copy), StarConfirmation (copy), LocalPlayer (copy)
            if p9 == LocalPlayer.UserId then
                StarConfirmation.Resolve(p6, p7)
            end
        end)
        v25:Connect(LocalPlayer.CharacterRemoving, close)

        local Character = LocalPlayer.Character

        if Character then
            v25:Connect(Character.ChildRemoved, function() -- line: 269
                -- upvalues: close (copy), holdingStar (copy)
                if not holdingStar() then
                    close()
                end
            end)
        end

        v25:Connect(Save.Watch("Inventory"), function() -- line: 273
            -- upvalues: p6 (copy), close (copy), Save (copy)
            local v40 = Save.Peek()
            local v41 = v40 and v40.Inventory[p6]

            if not v41 or v41.Rideable or v41.InFuse then
                close()
            end
        end)
        v25:Connect(Save.Watch("EquippedAssets"), function(p10) -- line: 278
            -- upvalues: p6 (copy), close (copy)
            if typeof(p10) ~= "table" or not table.find(p10, p6) then
                close()
            end
        end)
    end
end

local function bind(p11, p12, p13, p14) -- line: 283
    -- upvalues: Assets (copy), SmartProximityPrompt (copy), LocalPlayer (copy), t1 (copy), t2 (copy), ride (copy), askToFeed (copy)
    local ProximityPrompt = Instance.new("ProximityPrompt")

    ProximityPrompt.Name = p13 == "Feed" and "FeedMountStar" or "RideMount"
    ProximityPrompt.ActionText = p13 == "Feed" and "Feed Star" or "Mount"

    local v42 = Assets.Directory[p14]

    if not (v42 and v42.DisplayName) then
        ProximityPrompt.ObjectText = p14
    else
        ProximityPrompt.ObjectText = v42.DisplayName
    end

    ProximityPrompt.HoldDuration = p13 == "Feed" and 0.35 or 0

    if p13 == "Feed" then
        ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.E
    else
        ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.F
    end

    if p13 == "Feed" then
        ProximityPrompt.GamepadKeyCode = Enum.KeyCode.ButtonX
    else
        ProximityPrompt.GamepadKeyCode = Enum.KeyCode.ButtonY
    end

    ProximityPrompt.RequiresLineOfSight = false
    ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom

    if p13 == "Ride" then
        local v43 = false
        local v44

        for v45 in t2 do
            if v45.Parent ~= nil and v45.Enabled then
                v44 = true
                v43 = true
                break
            end

            t2[v45] = nil
        end

        if not v43 then
            v44 = false
        end

        ProximityPrompt.Enabled = not v44
    else
        ProximityPrompt.Enabled = true
    end

    local v46 = SmartProximityPrompt.AttachToModel(ProximityPrompt, p12, {
        MaxActivationDistance = 10,
        TrackDistance = 10,
        SurfaceOffset = 0.75
    })

    ProximityPrompt.Triggered:Connect(function(p15) -- line: 299
        -- upvalues: p11 (copy), p13 (copy), p14 (copy), LocalPlayer (copy), ride (copy), askToFeed (copy)
        if p15 == LocalPlayer then
            if p13 == "Feed" then
                askToFeed(p11, p14)
            else
                ride(p11)
            end
        end
    end)
    t1[p11] = {
        Mode = p13,
        Model = p12,
        Prompt = ProximityPrompt,
        Cleanup = v46
    }
end

function refresh() -- line: 312
    -- upvalues: ReplicatedStorage (copy), AssetRoster (copy), MountControls (copy), Save (copy), Tabs (copy), PetMountFlags (copy), LocalPlayer (copy), v6 (ref), t1 (copy), t4 (copy), v7 (ref), holdingStar (copy), syncRidePrompts (copy), bind (copy)
    local v47 = "None"

    if PetMountFlags.Enabled:Get() and not v7 and Tabs.Active() == nil then
        if holdingStar() then
            v47 = "Feed"
        else
            local Character = LocalPlayer.Character

            v47 = if Character ~= nil and Character:FindFirstChild("PetMountSession") ~= nil then "None" else "Ride"
        end
    end

    MountControls.Refresh()

    local t9 = {}

    if v47 ~= "None" then
        for v48, v49 in (AssetRoster.ReadOwnerPen(LocalPlayer.UserId)) do
            local ItemData = v49.ItemData
            local v50 = Save.Peek()
            local v51 = (v50 and v50.Inventory[v48] or ItemData).Rideable == true

            if v47 == "Feed" ~= v51 and not t4[v48] then
                if v6 == nil then
                    v6 = require(ReplicatedStorage.Controllers.Game.Plots.ActiveAssetsController)
                end

                local v52 = v6.GetModelByUID(v48)

                if v52 ~= nil and v52.Parent ~= nil then
                    t9[v48] = true

                    local v53 = t1[v48]

                    if v53 and (v53.Mode ~= v47 or v53.Model ~= v52) then
                        local v54 = t1[v48]

                        if v54 ~= nil then
                            t1[v48] = nil
                            v54.Cleanup()
                            v54.Prompt:Destroy()
                        end

                        v53 = nil
                    end

                    if v53 == nil then
                        bind(v48, v52, v47, ItemData.Category)
                    end
                end
            end
        end
    end

    for v55 in t1 do
        if not t9[v55] then
            local v56 = t1[v55]

            if v56 ~= nil then
                t1[v55] = nil
                v56.Cleanup()
                v56.Prompt:Destroy()
            end
        end
    end

    syncRidePrompts()
end

local function handPoint(p16) -- line: 349
    for _, v57 in { "RightHand", "Right Arm", "Head", "HumanoidRootPart" } do
        local v58 = p16:FindFirstChild(v57)

        if v58 and v58:IsA("BasePart") then
            return v58.Position
        end
    end

    return nil
end

local function bezier(p17, p18, p19, p20) -- line: 359
    local v59 = 1 - p20

    return p17 * (v59 * v59) + p18 * (v59 * 2 * p20) + p19 * (p20 * p20)
end

local function shockwave(p21, p22) -- line: 364
    -- upvalues: TweenService (copy), Workspace (copy), v1 (copy)
    local Part = Instance.new("Part")

    Part.Name = "StarFeedShockwave"
    Part.Shape = Enum.PartType.Cylinder
    Part.Material = Enum.Material.Neon
    Part.Color = v1
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 0.15
    Part.Size = Vector3.new(0.25, p22 * 0.4, p22 * 0.4)
    Part.CFrame = CFrame.new(p21) * CFrame.Angles(0, 0, 1.5707963267948966)

    local StarFeedClient = Workspace:FindFirstChild("StarFeedClient")

    if not StarFeedClient then
        StarFeedClient = Instance.new("Folder")
        StarFeedClient.Name = "StarFeedClient"
        StarFeedClient.Parent = Workspace
    end

    Part.Parent = StarFeedClient

    local v63 = math.max(p22 * 3.2, 14)

    TweenService:Create(Part, TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Transparency = 1,
        Size = Vector3.new(0.05, v63, v63)
    }):Play()
    task.delay(0.6, function() -- line: 385
        -- upvalues: Part (copy)
        Part:Destroy()
    end)
end

local function banner(p23) -- line: 390
    -- upvalues: ReplicatedStorage (copy), Assets (copy), Fx (copy), Lanes (copy)
    local Assets2 = ReplicatedStorage:FindFirstChild("Assets")
    local UI = Assets2 and Assets2:FindFirstChild("UI")
    local Notifs = UI and UI:FindFirstChild("Notifs")
    local GoldenNotif = Notifs and Notifs:FindFirstChild("GoldenNotif")

    if GoldenNotif == nil then
        return
    end

    local clone = GoldenNotif:Clone()
    local Main = clone:FindFirstChild("Main")
    local Content = Main and Main:FindFirstChild("Content")

    if Content and Content:IsA("TextLabel") then
        Content.RichText = true

        local v64 = Assets.Directory[p23]
        local Color = if v64 and v64.Rarity then v64.Rarity.Color else nil
        local v65 = if typeof(Color) == "Color3" then ("#%*"):format((Color:ToHex())) else "#FFD84D"
        local v66 = Assets.Directory[p23]

        Content.Text = ("<font color=\"%*\">%*</font> is now a mount!"):format(v65, if not (v66 and v66.DisplayName) then p23 else v66.DisplayName)
    end

    Lanes.Schedule({
        Lane = "Banner",
        Seconds = 4.5,
        UniqueKey = "MountStarFed",
        Frame = clone,
        OnShown = function() -- OnShown | line: 411
            -- upvalues: Fx (copy)
            Fx.Sound("StarReward", nil, 0.85)
        end
    })
end

local function play(p24, p25) -- line: 417
    -- upvalues: ReplicatedStorage (copy), RunService (copy), TweenService (copy), Workspace (copy), AssetRoster (copy), Buddy (copy), Fx (copy), Trove (copy), v1 (copy), v2 (copy), LocalPlayer (copy), v6 (ref), t4 (copy), t5 (copy), refresh (ref), handPoint (copy), shockwave (copy), banner (copy)
    if t4[p25] then
        return
    end

    if v6 == nil then
        v6 = require(ReplicatedStorage.Controllers.Game.Plots.ActiveAssetsController)
    end

    local v67 = v6.GetModelByUID(p25)
    local Character = p24.Character
    local v68, v69

    if v67 == nil or Character == nil then
        v69 = true
    elseif Fx.KitReady() then
        v68 = p24 == LocalPlayer
        v69 = false
    else
        v69 = true
    end

    if v69 then
        return
    end

    local CurrentCamera = Workspace.CurrentCamera
    local BoundingBox, BoundingBox2 = v67:GetBoundingBox()

    if not v68 and CurrentCamera and (CurrentCamera.CFrame.Position - BoundingBox.Position).Magnitude > 320 then
        return
    end

    local v70 = handPoint(Character)

    if not v70 then
        v70 = BoundingBox.Position
    end

    local v71 = t5[p25]

    t5[p25] = nil

    if v68 and v71 and CurrentCamera then
        local v72 = CurrentCamera:ScreenPointToRay(v71.X, v71.Y)

        v70 = v72.Origin + v72.Direction * 6
    end

    local v73 = AssetRoster.ReadOwnerPen(p24.UserId)[p25]
    local v74 = if v73 then v73.ItemData.Category else v67.Name

    t4[p25] = true

    if v68 then
        refresh()
    end

    local v75 = Trove.new()
    local Scale = v67:GetScale()
    local v76 = math.max(BoundingBox2.X, BoundingBox2.Z, 2)
    local v78 = math.clamp(v76 / 6, 0.7, 2.4)

    v75:Add(function() -- line: 455
        -- upvalues: p25 (copy), v67 (copy), v68 (ref), Scale (copy), t4 (copy), refresh (ref)
        if v67.Parent then
            v67:ScaleTo(Scale)
        end

        t4[p25] = nil

        if v68 then
            refresh()
        end
    end)

    local function petCenter() -- line: 465
        -- upvalues: v67 (copy)
        local BoundingBox, BoundingBox2 = v67:GetBoundingBox()

        return BoundingBox.Position, BoundingBox2
    end

    local Spawn = Buddy.Spawn
    local StarFeedClient = Workspace:FindFirstChild("StarFeedClient")

    if not StarFeedClient then
        StarFeedClient = Instance.new("Folder")
        StarFeedClient.Name = "StarFeedClient"
        StarFeedClient.Parent = Workspace
    end

    local v79 = Spawn(StarFeedClient, CFrame.new(v70))

    v75:Add(v79)

    local PrimaryPart = v79.PrimaryPart

    PrimaryPart.Anchored = true

    local v80 = v79:GetAttribute("HeldScale") or 0.5

    v79:ScaleTo(v80)

    local v81 = Buddy.CalmIdle(v79)

    if v81 then
        v81:Play(0.05)
        v81:SetSpeed(1.6)
        v75:Add(function() -- line: 480
            -- upvalues: v81 (copy)
            local function v82() -- line: 481
                -- upvalues: v81 (copy)
                v81:Stop(0)
            end

            pcall(v82)
        end)
    end

    Fx.Emit("Reveal", v70, 0.6)
    Fx.Sound("BuddyBoing", PrimaryPart, 0.75, 1.1)
    Fx.Sound("BuddyGiggle", PrimaryPart, 0.55, 1.2)

    local Highlight = Instance.new("Highlight")

    Highlight.Name = "StarFeedGlow"
    Highlight.FillColor = v1
    Highlight.OutlineColor = Color3.new(1, 1, 1)
    Highlight.FillTransparency = 1
    Highlight.OutlineTransparency = 1
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.Adornee = v67

    local StarFeedClient2 = Workspace:FindFirstChild("StarFeedClient")

    if not StarFeedClient2 then
        StarFeedClient2 = Instance.new("Folder")
        StarFeedClient2.Name = "StarFeedClient"
        StarFeedClient2.Parent = Workspace
    end

    Highlight.Parent = StarFeedClient2
    v75:Add(Highlight)

    local elapsed = os.clock()
    local v83 = "Flight"
    local n1 = 0
    local n2 = 0
    local v84
    local v85 = false

    local function burst() -- line: 508
        -- upvalues: v67 (copy), v68 (ref), v76 (copy), v78 (copy), Highlight (copy), v84 (ref), TweenService (copy), Fx (copy), v1 (copy), shockwave (copy)
        local BoundingBox, BoundingBox2 = v67:GetBoundingBox()
        local BoundingBoxPosition = BoundingBox.Position

        Fx.Sound("StarBurst", v67.PrimaryPart, 1)
        Fx.Emit("Burst", BoundingBoxPosition, v78)
        Fx.Emit("Impact", BoundingBoxPosition - Vector3.new(0, BoundingBox2.Y * 0.45, 0), v78)
        shockwave(BoundingBoxPosition - Vector3.new(0, BoundingBox2.Y * 0.45, 0), v76)
        Fx.HitFlash(v67, 0.35)

        if v84 then
            v84:Stop()
        end

        Highlight.FillTransparency = 0.15
        Highlight.OutlineColor = v1
        Highlight.OutlineTransparency = 0
        TweenService:Create(Highlight, TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            FillTransparency = 1,
            OutlineTransparency = 1
        }):Play()

        if not v68 then
            return
        end

        Fx.Flash(v1, 0.18, 0.4)
        Fx.FovPunch(8, 0.7)
        Fx.Shake(0.4, 0.7, BoundingBoxPosition)
        Fx.Grade(v1, 0.3, 1)
    end

    v75:Connect(RunService.RenderStepped, function() -- line: 534
        -- upvalues: v67 (copy), v68 (ref), v70 (ref), v75 (copy), Scale (copy), v76 (copy), v78 (copy), v79 (copy), PrimaryPart (copy), v80 (copy), Highlight (copy), elapsed (ref), v83 (ref), n1 (ref), n2 (ref), v84 (ref), v85 (ref), burst (copy), v74 (copy), Fx (copy), v1 (copy), v2 (copy), banner (copy)
        if v85 then
            return
        end

        if v67.Parent ~= nil then
            local elapsed2 = os.clock()
            local v88 = elapsed2 - elapsed
            local BoundingBox, BoundingBox2 = v67:GetBoundingBox()
            local BoundingBoxPosition = BoundingBox.Position
            local v90 = BoundingBoxPosition + Vector3.new(0, BoundingBox2.Y * 0.5 + 1.6, 0)
            local v92 = math.max(v76 * 0.7, 3)

            if v83 == "Flight" then
                local v94 = math.clamp(v88 / 0.62, 0, 1)
                local v95 = v90 + Vector3.new(v92, 0, 0)
                local v98 = (v70 + v95) / 2 + Vector3.new(0, 4 + BoundingBox2.Y * 0.3, 0)
                local v99 = v70
                local v100 = math.clamp(v94, 0, 1)
                local v101 = v100 * v100 * (3 - v100 * 2)
                local v102 = 1 - v101
                local v103 = v99 * (v102 * v102) + v98 * (v102 * 2 * v101) + v95 * (v101 * v101)
                local v106 = CFrame.Angles(0, v94 * 3.141592653589793 * 4, math.sin(v94 * 3.141592653589793) * 0.6)
                local v108 = math.clamp(v94 * 2, 0, 1)

                v79:ScaleTo(v80 * (v108 * v108 * (3 - v108 * 2) * 0.65 + 0.35))
                v79:PivotTo(CFrame.new(v103) * v106)

                if v94 >= 1 then
                    v83 = "Swirl"
                    elapsed = elapsed2
                    Fx.Sound("BuddyNotice", PrimaryPart, 0.6, 1.15)
                    Fx.Sound("BuddyOrbit", PrimaryPart, 0.7)
                end
            elseif v83 == "Swirl" then
                local v110 = math.clamp(v88 / 1.25, 0, 1)
                local v111 = v110 * v110 * (1.6 - v110 * 0.6)

                n1 = v111 * 2.75 * 3.141592653589793 * 2

                local v112 = v92 * (1 - v111)
                local v113 = v90:Lerp(BoundingBoxPosition, v111)
                local v121 = v113 + Vector3.new(math.cos(n1), 0, (math.sin(n1))) * v112 + Vector3.new(0, math.sin(n1 * 2) * 0.6 * (1 - v110), 0)
                local v122 = if (v113 - v121).Magnitude > 0.05 then CFrame.lookAt(v121, v113) * CFrame.Angles(0, 0, -0.5) else CFrame.new(v121)

                v79:ScaleTo(v80 * math.max(0.08, 1 - v111 * 0.85 * v111))
                v79:PivotTo(v122)

                local v124 = math.clamp(v110, 0, 1)

                v67:ScaleTo(Scale * (1 - v124 * v124 * (3 - v124 * 2) * 0.08))

                if n2 <= elapsed2 then
                    n2 = elapsed2 + 0.12
                    Fx.Emit("Collect", v121, 0.35)
                end

                if v110 >= 1 then
                    v83 = "Charge"
                    elapsed = elapsed2
                    v79.Parent = nil
                    Fx.Sound("StarHit1", v67.PrimaryPart, 0.9)
                    Fx.Sound("BuddyPop", v67.PrimaryPart, 0.7, 0.9)
                    Fx.Emit("Hit", BoundingBoxPosition, v78)
                    Fx.HitFlash(v67, 0.25)
                    v67:ScaleTo(Scale * 1.14)
                    v84 = Fx.Sound("StarCharge", v67.PrimaryPart, 0.85)

                    if v68 then
                        Fx.FovPunch(3, 0.4)
                    end
                end
            elseif v83 == "Charge" then
                local v126 = math.clamp(v88 / 1.35, 0, 1)
                local v128 = math.max(0, 1 - v88 / 0.25) * 0.14
                local v129 = v126 * 34 * v126 + 10
                local v131 = math.sin(v88 * v129) * (v126 * 0.05 + 0.015)

                v67:ScaleTo(Scale * (v128 + 1 + v131 + v126 * 0.05))

                local v132 = math.clamp(v126, 0, 1)

                Highlight.FillTransparency = 1 - v132 * v132 * (3 - v132 * 2) * 0.65

                local v133 = math.clamp(v126, 0, 1)

                Highlight.OutlineTransparency = 1 - v133 * v133 * (3 - v133 * 2)
                Highlight.FillColor = v1:Lerp(v2, math.sin(v88 * v129 * 0.5) * 0.5 + 0.5)

                if n2 <= elapsed2 then
                    n2 = elapsed2 + math.max(0.08, 0.28 - v126 * 0.2)

                    local v136 = math.random() * 3.141592653589793 * 2
                    local v139 = Vector3.new(math.cos(v136), 0, (math.sin(v136))) * (v76 * 0.6)

                    Fx.Emit("Charge", BoundingBoxPosition + v139, v78 * 0.6)
                end

                if v126 >= 1 then
                    v83 = "Settle"
                    elapsed = elapsed2
                    burst()
                end
            elseif v83 == "Settle" then
                local v141 = math.clamp(v88 / 0.9, 0, 1)

                v67:ScaleTo(Scale * (math.exp(v141 * -6) * math.cos(v141 * 22) * 0.24 + 1))

                if v141 >= 1 then
                    v85 = true

                    if v68 then
                        banner(v74)
                    end

                    task.delay(0.6, function() -- line: 626
                        -- upvalues: v75 (copy)
                        v75:Destroy()
                    end)
                end
            end
        else
            v85 = true
            v75:Destroy()
        end
    end)
end

local function onFed(p26, p27) -- line: 634
    -- upvalues: LocalPlayer (copy), t3 (copy), play (copy)
    if typeof(p27) == "string" then
        if p26 == LocalPlayer then
            t3[p27] = true
        end

        play(p26, p27)
    end
end

local function watchCharacter(p28) -- line: 644
    -- upvalues: refresh (ref)
    if p28 == nil then
        return
    end

    p28.ChildAdded:Connect(function(p29) -- line: 648
        -- upvalues: refresh (ref)
        if p29:IsA("Tool") or p29.Name == "PetMountSession" then
            task.defer(refresh)
        end
    end)
    p28.ChildRemoved:Connect(function(p30) -- line: 653
        -- upvalues: refresh (ref)
        if p30:IsA("Tool") or p30.Name == "PetMountSession" then
            task.defer(refresh)
        end
    end)
    task.defer(refresh)
end

function t6.Start() -- line: 665
    -- upvalues: ProximityPromptService (copy), ReplicatedStorage (copy), AssetRoster (copy), MountControls (copy), Save (copy), Tabs (copy), PetMountFlags (copy), Remotes (copy), LocalPlayer (copy), v6 (ref), t1 (copy), t2 (copy), v9 (ref), syncRidePrompts (copy), currentMode (copy), refresh (ref), ride (copy), onFed (copy), watchCharacter (copy)
    if v9 then
        return
    end

    v9 = true
    MountControls.Bind(function() -- line: 670
        -- upvalues: t1 (copy)
        return t1
    end, currentMode, ride)
    Save.Watch("Inventory"):Connect(function() -- line: 671
        -- upvalues: refresh (ref)
        task.defer(refresh)
    end)
    Tabs.Activated:Connect(function() -- line: 672
        -- upvalues: refresh (ref)
        task.defer(refresh)
    end)
    Tabs.Deactivated:Connect(function() -- line: 673
        -- upvalues: refresh (ref)
        task.defer(refresh)
    end)
    Remotes.ShootingStar.Fed.OnClientEvent:Connect(onFed)
    LocalPlayer.CharacterAdded:Connect(watchCharacter)
    watchCharacter(LocalPlayer.Character)
    AssetRoster.OwnerRefreshed:Connect(function(p31) -- line: 677
        -- upvalues: LocalPlayer (copy), refresh (ref)
        if p31 == LocalPlayer.UserId then
            task.defer(refresh)
        end
    end)
    AssetRoster.SnapshotRefreshed:Connect(function() -- line: 682
        -- upvalues: refresh (ref)
        task.defer(refresh)
    end)
    task.defer(function() -- line: 685
        -- upvalues: ReplicatedStorage (copy), v6 (ref), refresh (ref)
        if v6 == nil then
            v6 = require(ReplicatedStorage.Controllers.Game.Plots.ActiveAssetsController)
        end

        v6.ItemAdded:Connect(function() -- line: 686
            -- upvalues: refresh (ref)
            task.defer(refresh)
        end)

        if v6 == nil then
            v6 = require(ReplicatedStorage.Controllers.Game.Plots.ActiveAssetsController)
        end

        v6.ItemRemoved:Connect(function() -- line: 689
            -- upvalues: refresh (ref)
            task.defer(refresh)
        end)
        refresh()
    end)
    PetMountFlags.Enabled.Changed:Connect(function() -- line: 694
        -- upvalues: refresh (ref)
        task.defer(refresh)
    end)
    ProximityPromptService.PromptShown:Connect(function(p32) -- line: 697
        -- upvalues: t2 (copy), syncRidePrompts (copy)
        if p32:GetAttribute("PlacedEggPrompt") == true then
            t2[p32] = true
            syncRidePrompts()
        end
    end)
    ProximityPromptService.PromptHidden:Connect(function(p33) -- line: 703
        -- upvalues: t2 (copy), syncRidePrompts (copy)
        if t2[p33] then
            t2[p33] = nil
            syncRidePrompts()
        end
    end)
end

return t6
