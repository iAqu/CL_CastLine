-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Cinema = require(script.Parent.Cinema)
local CursedIslandWars = require(ReplicatedStorage.Data.CursedIslandWars)
local CursedIslandWarsFlags = require(ReplicatedStorage.Shared.Flags.CursedIslandWarsFlags)
local Fx = require(script.Parent.Fx)
local Ragdoll = require(ReplicatedStorage.Shared.Modules.Ragdoll)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local State = require(script.Parent.State)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local Controls = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls()
local Tuning = CursedIslandWars.Tuning
local Animations, VFX = CursedIslandWars.Assets.Animations, CursedIslandWars.Assets.VFX
local t1 = {
    [Enum.KeyCode.One] = 1,
    [Enum.KeyCode.Two] = 2,
    [Enum.KeyCode.Three] = 3,
    [Enum.KeyCode.Four] = 4,
    [Enum.KeyCode.Five] = 5
}
local v1 = Trove.new()
local v2 = Trove.new()
local t2 = {}
local t3 = {}
local t4 = {}
local t5 = {}
local self = setmetatable({}, {
    __mode = "k"
})
local v4
local v5 = false
local n1 = 0
local n2 = 0
local n3 = 0
local Position
local n4 = 0
local t8 = {}

local function character() -- line: 54
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character

    if Character == nil then
        return nil, nil, nil
    end

    return Character, Character:FindFirstChildOfClass("Humanoid"), (Character:FindFirstChild("HumanoidRootPart"))
end

local function flat(p1) -- line: 62
    return (Vector3.new(p1.X, 0, p1.Z))
end

function t8.Cooldown(p2) -- line: 66
    -- upvalues: t2 (copy)
    return t2[p2] or 0
end

function t8.SetCooldown(p3, p4) -- line: 70
    -- upvalues: t2 (copy)
    t2[p3] = p4
end

function t8.Equipped() -- line: 74
    -- upvalues: CursedIslandWars (copy), LocalPlayer (copy)
    local Character = LocalPlayer.Character

    if Character ~= nil then
        Character:FindFirstChildOfClass("Humanoid")
        Character:FindFirstChild("HumanoidRootPart")
    end

    local Tool = if Character then Character:FindFirstChildOfClass("Tool") else nil

    return if Tool and table.find(CursedIslandWars.Tools, Tool.Name) then Tool.Name else nil
end

local function ready(p5) -- line: 80
    -- upvalues: State (copy), t8 (copy)
    local v6 = State.Me()

    if v6 ~= nil and v6.State == "Alive" then
        return State.Armed() and State.Now() >= t8.Cooldown(p5)
    end

    return false
end

local function spend(p6, p7) -- line: 85
    -- upvalues: State (copy), t2 (copy)
    t2[p6] = State.Now() + p7
end

function t8.Equip(p8) -- line: 89
    -- upvalues: CursedIslandWars (copy), State (copy), LocalPlayer (copy)
    local v7 = CursedIslandWars.Tools[p8]
    local Character = LocalPlayer.Character
    local Humanoid

    if Character ~= nil then
        Humanoid = Character:FindFirstChildOfClass("Humanoid")
        Character:FindFirstChild("HumanoidRootPart")
    else
        Character = nil
    end

    local v8 = State.Me()

    if Character ~= nil and Humanoid ~= nil and v7 ~= nil and v8 ~= nil and v8.State == "Alive" then
        local Tool = Character:FindFirstChildOfClass("Tool")

        if Tool and Tool.Name == v7 then
            Humanoid:UnequipTools()

            return
        end

        local Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        local v9 = if Backpack then Backpack:FindFirstChild(v7) else nil

        if v9 and v9:IsA("Tool") then
            Humanoid:EquipTool(v9)
        end
    end
end

local function aimPoint() -- line: 108
    -- upvalues: UserInputService (copy), Workspace (copy), State (copy), LocalPlayer (copy), Position (ref)
    local CurrentCamera = Workspace.CurrentCamera
    local LastInputType = UserInputService:GetLastInputType()
    local v10 = LastInputType == Enum.UserInputType.MouseMovement or LastInputType == Enum.UserInputType.MouseButton1 or LastInputType == Enum.UserInputType.Keyboard
    local Position2 = if LastInputType == Enum.UserInputType.Touch then Position else nil
    local v11 = if v10 then UserInputService:GetMouseLocation() else CurrentCamera.ViewportSize / 2
    local v12 = if Position2 then CurrentCamera:ScreenPointToRay(Position2.X, Position2.Y) else CurrentCamera:ViewportPointToRay(v11.X, v11.Y)
    local v13 = RaycastParams.new()

    v13.FilterType = Enum.RaycastFilterType.Exclude

    local t9 = {}
    local Character = LocalPlayer.Character

    if Character then
        table.insert(t9, Character)
    end

    local CursedIslandWarsFx = Workspace:FindFirstChild("CursedIslandWarsFx")

    if CursedIslandWarsFx then
        table.insert(t9, CursedIslandWarsFx)
    end

    local v14 = State.Island()

    if v14 then
        table.insert(t9, v14.Bounds)
    end

    v13.FilterDescendantsInstances = t9

    local v15 = Workspace:Raycast(v12.Origin, v12.Direction * 400, v13)

    if v15 then
        return v15.Position
    end

    return v12.Origin + v12.Direction * 400
end

local function clampedTarget(p9) -- line: 138
    -- upvalues: LocalPlayer (copy), aimPoint (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart

    if Character ~= nil then
        Character:FindFirstChildOfClass("Humanoid")
        HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    end

    if HumanoidRootPart == nil then
        return nil
    end

    local v16 = aimPoint()
    local v17 = v16 - HumanoidRootPart.Position
    local v18 = Vector3.new(v17.X, 0, v17.Z)

    if p9 < v18.Magnitude then
        v16 = HumanoidRootPart.Position + v18.Unit * p9 + Vector3.new(0, 1, 0) * (v16.Y - HumanoidRootPart.Position.Y)
    end

    return v16
end

local function onMarker(p10, p11, p12) -- line: 151
    -- upvalues: t4 (copy)
    t4[p10] = p12
    task.delay(p11 + 0.25, function() -- line: 153
        -- upvalues: p10 (copy), p12 (copy), t4 (copy)
        if t4[p10] ~= p12 then
            return
        end

        t4[p10] = nil
        p12()
    end)
end

local function hideFor(p13, p14) -- line: 174
    for _, descendant in p13:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Transparency = 1
        end
    end

    task.delay(p14, function() -- line: 180
        -- upvalues: p13 (copy)
        for _, descendant in p13:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Transparency = 0
            end
        end
    end)
end

local function play(p15, p16) -- line: 189
    -- upvalues: t3 (copy)
    local v19 = t3[p15]

    if v19 then
        v19:Play(p16 or 0.1)
    end
end

local function fireLauncher(p17) -- line: 196
    -- upvalues: TweenService (copy), Cinema (copy), CursedIslandWarsFlags (copy), Fx (copy), Remotes (copy), State (copy), VFX (copy), t2 (copy), t3 (copy), n2 (ref), t8 (copy), aimPoint (copy), hideFor (copy)
    local v20 = State.Me()

    if v20 ~= nil then
        local v21 = State.Me()

        if v21 ~= nil and v21.State == "Alive" and State.Armed() and State.Now() >= t8.Cooldown("PumpkinLauncher") then
            local Handle = p17.Handle
            local Muzzle = Handle.Muzzle
            local WorldPosition = Muzzle.WorldPosition
            local v22 = aimPoint() - WorldPosition
            local v23 = if v22.Magnitude > 0.5 then v22.Unit else Muzzle.WorldCFrame.LookVector
            local v24 = CursedIslandWarsFlags.LauncherCooldown:Get()

            t2.PumpkinLauncher = State.Now() + v24
            n2 += 1
            Fx.Launch(("%*:%*"):format(v20.Id, n2), WorldPosition, v23 * CursedIslandWarsFlags.LauncherSpeed:Get(), State.Now(), v20.Team)

            local BackBlast = Handle.BackBlast

            for _, v25 in {
                    Muzzle.WorldCFrame,
                    BackBlast.WorldCFrame * CFrame.Angles(0, 3.141592653589793, 0)
                } do
                local v26 = Fx.Welded(VFX.V4_LauncherMuzzle, Handle, v25)

                Fx.Burst(v26, "MuzzleBurst")
                task.delay(0.8, function() -- line: 214
                    -- upvalues: v26 (copy)
                    v26:Destroy()
                end)
            end

            hideFor(p17.Pumpkin, v24)

            local BarrelWeld = p17.Barrel.BarrelWeld
            local C0 = BarrelWeld.C0

            BarrelWeld.C0 = C0 * CFrame.new(0, 0, 0.35)
            TweenService:Create(BarrelWeld, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                C0 = C0
            }):Play()

            local Fire = t3.Fire

            if Fire then
                Fire:Play(0.05)
            end

            Cinema.Shake(0.08)

            local Use = Remotes.IslandWars.Use

            Use:FireServer("Launch", n2, WorldPosition, v23)
        end
    end
end

local function plantMine(p18) -- line: 229
    -- upvalues: CursedIslandWarsFlags (copy), Remotes (copy), State (copy), Controls (copy), t2 (copy), t3 (copy), t4 (copy), n4 (ref), t8 (copy), hideFor (copy)
    local v28 = State.Me()

    if v28 ~= nil and v28.State == "Alive" and State.Armed() and State.Now() >= t8.Cooldown("Landmine") then
        local v29 = CursedIslandWarsFlags.MineCooldown:Get()

        t2.Landmine = State.Now() + v29

        local Mine = t3.Mine

        if Mine then
            Mine:Play(0.1)
        end

        local v30 = os.clock() + 0.8

        n4 = v30
        Controls:Disable()
        task.delay(0.8, function() -- line: 166
            -- upvalues: v30 (copy), Controls (copy), n4 (ref)
            if n4 == v30 then
                Controls:Enable()
            end
        end)

        local function v31() -- line: 237
            -- upvalues: p18 (copy), v29 (copy), Remotes (copy), hideFor (copy)
            hideFor(p18, v29)
            Remotes.IslandWars.Use:FireServer("Mine")
        end

        t4.Place = v31

        local delay = task.delay
        local v32 = "Place"

        delay(0.667, function() -- line: 153
            -- upvalues: v31 (copy), v32 (copy), t4 (copy)
            if t4[v32] ~= v31 then
                return
            end

            t4[v32] = nil
            v31()
        end)
    end
end

local function placeWall() -- line: 244
    -- upvalues: CursedIslandWarsFlags (copy), Remotes (copy), State (copy), Controls (copy), t2 (copy), t3 (copy), t4 (copy), v4 (ref), v5 (ref), n4 (ref), t8 (copy)
    local v33 = v4
    local v34 = v5

    if v33 ~= nil then
        local v35 = State.Me()

        if v35 ~= nil and v35.State == "Alive" and State.Armed() and State.Now() >= t8.Cooldown("WallBuilder") then
            local v36 = CursedIslandWarsFlags.WallCooldown:Get()

            t2.WallBuilder = State.Now() + v36

            local Place = t3.Place

            if Place then
                Place:Play(0.1)
            end

            local v37 = os.clock() + 0.8

            n4 = v37
            Controls:Disable()
            task.delay(0.8, function() -- line: 166
                -- upvalues: v37 (copy), Controls (copy), n4 (ref)
                if n4 == v37 then
                    Controls:Enable()
                end
            end)

            local function v38() -- line: 253
                -- upvalues: v33 (copy), v34 (copy), Remotes (copy)
                Remotes.IslandWars.Use:FireServer("Wall", v33, v34)
            end

            t4.Slam = v38

            local delay = task.delay
            local v39 = "Slam"

            delay(0.583, function() -- line: 153
                -- upvalues: v38 (copy), v39 (copy), t4 (copy)
                if t4[v39] ~= v38 then
                    return
                end

                t4[v39] = nil
                v38()
            end)
        end
    end
end

local function placePad() -- line: 258
    -- upvalues: CursedIslandWarsFlags (copy), Remotes (copy), State (copy), LocalPlayer (copy), Controls (copy), Tuning (copy), t2 (copy), t3 (copy), t4 (copy), n4 (ref), t8 (copy), aimPoint (copy)
    local v40 = State.Me()

    if v40 == nil or v40.State ~= "Alive" or not State.Armed() or not (State.Now() >= t8.Cooldown("JumpPad")) then
        return
    end

    local Range = Tuning.Pad.Range
    local Character = LocalPlayer.Character
    local HumanoidRootPart

    if Character ~= nil then
        Character:FindFirstChildOfClass("Humanoid")
        HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    end

    local v41

    if HumanoidRootPart ~= nil then
        v41 = aimPoint()

        local v42 = v41 - HumanoidRootPart.Position
        local v43 = Vector3.new(v42.X, 0, v42.Z)

        if Range < v43.Magnitude then
            v41 = HumanoidRootPart.Position + v43.Unit * Range + Vector3.new(0, 1, 0) * (v41.Y - HumanoidRootPart.Position.Y)
        end
    end

    if v41 == nil then
        return
    end

    local v44 = CursedIslandWarsFlags.PadCooldown:Get()

    t2.JumpPad = State.Now() + v44

    local Pad = t3.Pad

    if Pad then
        Pad:Play(0.1)
    end

    local v45 = os.clock() + 0.8

    n4 = v45
    Controls:Disable()
    task.delay(0.8, function() -- line: 166
        -- upvalues: v45 (copy), Controls (copy), n4 (ref)
        if n4 == v45 then
            Controls:Enable()
        end
    end)

    local function v46() -- line: 269
        -- upvalues: v41 (ref), Remotes (copy)
        Remotes.IslandWars.Use:FireServer("Pad", v41)
    end

    t4.Place = v46

    local delay = task.delay
    local v47 = "Place"

    delay(0.625, function() -- line: 153
        -- upvalues: v46 (copy), v47 (copy), t4 (copy)
        if t4[v47] ~= v46 then
            return
        end

        t4[v47] = nil
        v46()
    end)
end

local function nearestEnemy(p19) -- line: 274
    -- upvalues: State (copy)
    local v48 = State.Me()
    local Snapshot = State.Snapshot

    if v48 == nil or Snapshot == nil then
        return nil
    end

    local n5 = 1e999
    local HumanoidRootPart

    for _, v49 in Snapshot.Entries do
        local Model = if v49.Team ~= v48.Team and v49.State == "Alive" then v49.Model else nil
        local HumanoidRootPart2 = if Model then Model:FindFirstChild("HumanoidRootPart") else nil
        local v50 = if HumanoidRootPart2 then (HumanoidRootPart2.Position - p19.Position).Magnitude else 1e999

        if v50 < n5 then
            n5 = v50
            HumanoidRootPart = HumanoidRootPart2
        end
    end

    return HumanoidRootPart
end

local function swingBat(p20) -- line: 293
    -- upvalues: CursedIslandWarsFlags (copy), Ragdoll (copy), Remotes (copy), State (copy), LocalPlayer (copy), t2 (copy), t3 (copy), t8 (copy), nearestEnemy (copy)
    local Character = LocalPlayer.Character
    local Humanoid, HumanoidRootPart

    if Character ~= nil then
        Humanoid = Character:FindFirstChildOfClass("Humanoid")
        HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    else
        Character = nil
    end

    if Character ~= nil and Humanoid ~= nil and HumanoidRootPart ~= nil and not Ragdoll.IsRagdolled(Character) then
        local v51 = State.Me()

        if v51 ~= nil and v51.State == "Alive" and State.Armed() and State.Now() >= t8.Cooldown("Bat") then
            local v52 = CursedIslandWarsFlags.BatCooldown:Get()

            t2.Bat = State.Now() + v52

            local Swing = t3.Swing

            if Swing == nil then
                Swing = Humanoid:FindFirstChildOfClass("Animator"):LoadAnimation(p20.HitAnim)
                Swing.Priority = Enum.AnimationPriority.Action
                t3.Swing = Swing
            end

            Swing:Play(0.05)
            Remotes.IslandWars.Use:FireServer("Swing", (nearestEnemy(HumanoidRootPart)))
        end
    end
end

local function activate(p21) -- line: 309
    -- upvalues: fireLauncher (copy), plantMine (copy), placeWall (copy), placePad (copy), swingBat (copy)
    if p21.Name == "Bat" then
        swingBat(p21)
    elseif p21.Name == "PumpkinLauncher" then
        fireLauncher(p21)
    elseif p21.Name == "Landmine" then
        plantMine(p21)
    elseif p21.Name == "WallBuilder" then
        placeWall()
    elseif p21.Name == "JumpPad" then
        placePad()
    end
end

local function watchTool(p22) -- line: 323
    -- upvalues: CursedIslandWars (copy), v1 (ref), t3 (copy), self (copy), activate (copy)
    if not p22:IsA("Tool") or not table.find(CursedIslandWars.Tools, p22.Name) or self[p22] then
        return
    end

    self[p22] = true

    local v53 = v1

    v53:Add(p22.Activated:Connect(function() -- line: 328
        -- upvalues: p22 (copy), activate (copy)
        activate(p22)
    end))

    if p22.Name == "PumpkinLauncher" then
        local v54 = v1

        v54:Add(p22.Equipped:Connect(function() -- line: 332
            -- upvalues: t3 (copy)
            local Hold = t3.Hold

            if Hold then
                Hold:Play(0.15)
            end
        end))

        local v55 = v1

        v55:Add(p22.Unequipped:Connect(function() -- line: 335
            -- upvalues: t3 (copy)
            local Hold = t3.Hold

            if Hold then
                Hold:Stop(0.15)
            end
        end))
    end
end

local function clearGhosts() -- line: 344
    -- upvalues: t5 (copy), v4 (ref), n1 (ref)
    for _, v56 in t5 do
        v56.Transparency = 1
    end

    v4 = nil
    n1 = 0
end

local function stepGhost() -- line: 352
    -- upvalues: Players (copy), Workspace (copy), CursedIslandWars (copy), State (copy), LocalPlayer (copy), Tuning (copy), t5 (copy), v4 (ref), v5 (ref), n1 (ref), t8 (copy), aimPoint (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart

    if Character ~= nil then
        Character:FindFirstChildOfClass("Humanoid")
        HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    end

    local v57 = State.Island()
    local v58 = State.Me()

    if t8.Equipped() ~= "WallBuilder"
        or HumanoidRootPart == nil
        or v57 == nil
        or v58 == nil
        or v58.State ~= "Alive"
        or State.Now() < t8.Cooldown("WallBuilder") then
        for _, v67 in t5 do
            v67.Transparency = 1
        end

        v4 = nil
        n1 = 0
    elseif not (os.clock() < n1) then
        n1 = os.clock() + 0.1

        local t10 = {
            v57.Parent
        }

        for _, player in Players:GetPlayers() do
            if player.Character then
                table.insert(t10, player.Character)
            end
        end

        local v60, v61, v62 = CursedIslandWars.WallSearch(v57, t10, HumanoidRootPart.Position, (aimPoint()))

        v4 = v60
        v5 = v61

        local Color = CursedIslandWars.Teams[v58.Team].Color

        for i = 1, math.max(#v62, #t5) do
            local v65 = t5[i]

            if v65 == nil then
                v65 = Instance.new("Part")
                v65.Anchored = true
                v65.CanCollide = false
                v65.CanQuery = false
                v65.CanTouch = false
                v65.CastShadow = false
                v65.Material = Enum.Material.ForceField
                v65.Size = Vector3.new(1, 1, 1) * Tuning.Brick.Size
                v65.Parent = Workspace.CurrentCamera
                t5[i] = v65
            end

            local v66 = v62[i]

            v65.Transparency = v66 and 0.2 or 1

            if v66 then
                v65.CFrame = v66
                v65.Color = Color
            end
        end
    end
end

local function launch(p23, p24, p25, p26) -- line: 401
    -- upvalues: Cinema (copy), CursedIslandWarsFlags (copy), Fx (copy), Remotes (copy), LocalPlayer (copy), v1 (ref), t3 (copy), n3 (ref)
    n3 = os.clock()

    local MoveDirection = p25.MoveDirection
    local Unit

    if MoveDirection.Magnitude > 0.1 then
        Unit = MoveDirection.Unit
    else
        local LookVector = p24.CFrame.LookVector

        Unit = Vector3.new(LookVector.X, 0, LookVector.Z).Unit
    end

    p24.AssemblyLinearVelocity = Unit * CursedIslandWarsFlags.PadLaunchForward:Get() + Vector3.new(0, 1, 0) * CursedIslandWarsFlags.PadLaunchUp:Get()
    p25:ChangeState(Enum.HumanoidStateType.Freefall)
    Fx.PadLaunch(p23, LocalPlayer.Character, p26)
    Cinema.Kick(12)

    local Launch = t3.Launch

    if Launch then
        Launch:Play(0.1)
    end

    local connection

    connection = p25.StateChanged:Connect(function(_, p28) -- line: 411
        -- upvalues: p24 (copy), connection (ref), Fx (copy), t3 (copy)
        if p28 ~= Enum.HumanoidStateType.Landed then
            return
        end

        connection:Disconnect()

        local Launch = t3.Launch

        if Launch then
            Launch:Stop(0.2)
        end

        Fx.PadLand(p24.Position - Vector3.new(0, 3, 0))
    end)
    v1:Add(connection)
    Remotes.IslandWars.Use:FireServer("Launched", p23)
end

local function stepPads() -- line: 425
    -- upvalues: State (copy), LocalPlayer (copy), n3 (ref), launch (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart, Humanoid

    if Character ~= nil then
        Humanoid = Character:FindFirstChildOfClass("Humanoid")
        HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    end

    local v68 = State.Me()
    local v69 = State.Island()

    if HumanoidRootPart ~= nil and Humanoid ~= nil and v68 ~= nil and v68.State == "Alive" and v69 ~= nil and not (os.clock() - n3 < 0.8) then
        local v70 = v69.Parent and v69.Parent:FindFirstChild("Pads")

        if v70 ~= nil then
            for _, child in v70:GetChildren() do
                if child:IsA("Model") and child:GetAttribute("Team") == v68.Team then
                    local v71 = child.Trigger.CFrame:PointToObjectSpace(HumanoidRootPart.Position)

                    if math.abs(v71.X) <= 2.4 and math.abs(v71.Z) <= 2.4 and v71.Y > -2 and v71.Y < 4.5 then
                        launch(child, HumanoidRootPart, Humanoid, v68.Team)

                        return
                    end
                end
            end
        end
    end
end

local function bindCharacter(p29) -- line: 449
    -- upvalues: Animations (copy), v2 (ref), t3 (copy), t4 (copy), watchTool (copy)
    v2:Clean()
    table.clear(t3)

    local Animator = p29:WaitForChild("Humanoid"):WaitForChild("Animator")

    for v72, v73 in {
            Hold = Animations.LauncherHold,
            Fire = Animations.LauncherFire,
            Place = Animations.WallPlace,
            Pad = Animations.PadPlace,
            Mine = Animations.MinePlace,
            Launch = Animations.PadLaunchPose
        } do
        local track = Animator:LoadAnimation(v73)

        t3[v72] = track
        v2:Add(function() -- line: 464
            -- upvalues: track (copy)
            track:Stop(0)
        end)
    end

    for v75, v76 in {
            [t3.Place] = "Slam",
            [t3.Pad] = "Place",
            [t3.Mine] = "Place"
        } do
        v2:Add(v75:GetMarkerReachedSignal(v76):Connect(function() -- line: 469
            -- upvalues: v76 (copy), t4 (copy)
            local v78 = t4[v76]

            t4[v76] = nil

            if v78 then
                v78()
            end
        end))
    end

    v2:Add(p29.ChildAdded:Connect(watchTool))

    for _, child in p29:GetChildren() do
        watchTool(child)
    end

    local Tool = p29:FindFirstChildOfClass("Tool")

    if Tool and Tool.Name == "PumpkinLauncher" then
        local Hold = t3.Hold

        if Hold then
            Hold:Play(0.1)
        end
    end
end

local function passOwnBarrier(p30) -- line: 488
    -- upvalues: State (copy)
    local v80 = State.Me()
    local v81 = if not p30 or not v80 then nil else p30.Barriers[v80.Team]

    if v81 and v81.Health > 0 then
        v81.Model.Hitbox.CanCollide = false
    end
end

function t8.Knock(p31) -- line: 496
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart, Humanoid

    if Character ~= nil then
        Humanoid = Character:FindFirstChildOfClass("Humanoid")
        HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    end

    if HumanoidRootPart and Humanoid then
        HumanoidRootPart.AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity * 0.25 + p31

        if p31.Y > 5 then
            Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
        end
    end
end

function t8.Start(p32) -- line: 506
    -- upvalues: RunService (copy), StarterGui (copy), UserInputService (copy), CursedIslandWars (copy), State (copy), LocalPlayer (copy), t1 (copy), v1 (ref), v2 (ref), t2 (copy), t4 (copy), t5 (copy), self (copy), v4 (ref), Position (ref), t8 (copy), watchTool (copy), stepGhost (copy), stepPads (copy), bindCharacter (copy), passOwnBarrier (copy)
    v1 = p32:Extend()
    v2 = v1:Extend()
    table.clear(t2)
    table.clear(t4)
    table.clear(self)

    local SetCore = StarterGui.SetCore

    pcall(SetCore, StarterGui, "ResetButtonCallback", false)
    v1:Add(function() -- line: 513
        -- upvalues: StarterGui (copy), t5 (copy), v4 (ref)
        local SetCore = StarterGui.SetCore

        pcall(SetCore, StarterGui, "ResetButtonCallback", true)

        for _, v83 in t5 do
            v83:Destroy()
        end

        table.clear(t5)
        v4 = nil
    end)

    local Backpack = LocalPlayer:WaitForChild("Backpack")

    v1:Add(LocalPlayer.ChildAdded:Connect(function(p33) -- line: 522
        -- upvalues: v1 (ref), watchTool (copy)
        if not p33:IsA("Backpack") then
            return
        end

        v1:Add(p33.ChildAdded:Connect(watchTool))
    end))
    v1:Add(Backpack.ChildAdded:Connect(watchTool))

    for _, child in Backpack:GetChildren() do
        watchTool(child)
    end

    if LocalPlayer.Character then
        task.spawn(bindCharacter, LocalPlayer.Character)
    end

    v1:Add(LocalPlayer.CharacterAdded:Connect(bindCharacter))
    v1:Add(State.Changed:Connect(passOwnBarrier))

    local Snapshot = State.Snapshot
    local v89 = State.Me()
    local v90 = if not Snapshot or not v89 then nil else Snapshot.Barriers[v89.Team]

    if v90 and v90.Health > 0 then
        v90.Model.Hitbox.CanCollide = false
    end

    v1:Add(UserInputService.InputBegan:Connect(function(p34, p35) -- line: 537
        -- upvalues: CursedIslandWars (copy), t1 (copy), Position (ref), t8 (copy)
        if p35 then
            return
        end

        if p34.UserInputType == Enum.UserInputType.Touch then
            Position = p34.Position
        end

        local v92 = t1[p34.KeyCode]

        if v92 then
            t8.Equip(v92)
        elseif p34.KeyCode == Enum.KeyCode.ButtonR1 or p34.KeyCode == Enum.KeyCode.ButtonL1 then
            local v93 = table.find(CursedIslandWars.Tools, t8.Equipped() or "") or 0
            local v94 = p34.KeyCode == Enum.KeyCode.ButtonR1 and 1 or -1

            t8.Equip((v93 - 1 + v94) % #CursedIslandWars.Tools + 1)
        end
    end))
    v1:Add(RunService.RenderStepped:Connect(function() -- line: 553
        -- upvalues: stepGhost (copy), stepPads (copy)
        stepGhost()
        stepPads()
    end))
end

return t8
