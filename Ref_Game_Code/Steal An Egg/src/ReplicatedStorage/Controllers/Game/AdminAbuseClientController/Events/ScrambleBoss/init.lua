-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ContentProvider = game:GetService("ContentProvider")
local Environment = require(ReplicatedStorage.Shared.Modules.Environment)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local ScrambleBossFlags = require(ReplicatedStorage.Shared.Flags.ScrambleBossFlags)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Cinematic = require(script.Cinematic)
local HazardView = require(script.HazardView)
local Kit = require(script.Kit)
local Music = require(script.Music)
local Presentation = require(script.Presentation)
local Rider = require(script.Rider)
local Rigs = require(script.Rigs)
local Transition = require(script.Transition)
local Vfx = require(script.Vfx)
local t1 = {
    [Enum.UserInputType.MouseButton1] = true,
    [Enum.UserInputType.Touch] = true
}
local t2 = {
    [Enum.KeyCode.Space] = true,
    [Enum.KeyCode.ButtonA] = true,
    [Enum.KeyCode.ButtonX] = true,
    [Enum.KeyCode.ButtonR2] = true
}
local v1 = Color3.new(1, 1, 1)
local v2 = Color3.fromRGB(120, 235, 255)
local v3 = Trove.new()
local v4 = Random.new()
local v5 = false
local LocalPlayer = Players.LocalPlayer
local v6 = false

local function coilBolts(p1, p2) -- line: 100
    -- upvalues: Debris (copy), Kit (copy), v1 (copy), v2 (copy), v4 (copy)
    local Folder = Instance.new("Folder")

    Folder.Name = "CoilBolts"
    Folder.Parent = Kit.Debris()
    Debris:AddItem(Folder, 0.6)

    for i = 1, 3 do
        local t3 = {
            p1
        }

        for j = 1, 5 do
            table.insert(t3, p1:Lerp(p2, j / 6) + v4:NextUnitVector() * 3.5)
        end

        table.insert(t3, p2)

        local v8 = if i == 1 then 0.5 else 0.3

        for k = 1, #t3 - 1 do
            local v9 = t3[k]
            local v10 = t3[k + 1]

            Kit.Part({
                Name = "Bolt",
                Color = if i == 1 then v1 else v2,
                Size = Vector3.new(v8, v8, (v10 - v9).Magnitude),
                CFrame = CFrame.lookAt((v9 + v10) / 2, v10),
                Parent = Folder
            })
        end
    end
end

local function bindArena(p3) -- line: 131
    -- upvalues: Players (copy), RunService (copy), UserInputService (copy), Workspace (copy), Remotes (copy), ScrambleBossFlags (copy), Cinematic (copy), HazardView (copy), Kit (copy), Music (copy), Presentation (copy), Rider (copy), Rigs (copy), Vfx (copy), t1 (copy), t2 (copy), v3 (copy), v4 (copy), LocalPlayer (copy), coilBolts (copy)
    local v11 = v3:Extend()

    v11:Connect(p3.AncestryChanged, function() -- line: 133
        -- upvalues: p3 (copy), v11 (copy), Workspace (copy)
        if not p3:IsDescendantOf(Workspace) then
            v11:Destroy()
        end
    end)

    local v12 = Presentation.new(v11, p3)

    Music.new(v11, p3, v12)

    local v13 = HazardView.new(v11, p3)
    local v14
    local n1 = 0
    local Folder, GrabRescue

    local function bindActor(p4) -- line: 147
        -- upvalues: p3 (copy), v11 (copy), v14 (ref), Rider (copy), Rigs (copy)
        if not p4:IsA("Model") then
            return
        end

        local v15 = v11:Extend()

        v15:Connect(p4.AncestryChanged, function() -- line: 153
            -- upvalues: p4 (copy), v15 (copy), p3 (copy)
            if not p4:IsDescendantOf(p3) then
                v15:Destroy()
            end
        end)

        if p4.Name == "Mech" then
            v14 = Rigs.Mech(v15, p4)
        elseif p4.Name == "Croc" then
            Rider.Mount(v15, p4)
        elseif p4.Name == "Ball" then
            p4:WaitForChild("Root", 5)

            if p4.PrimaryPart then
                Rigs.Ball(v15, p4, p3)
            end
        end
    end

    local function bindDrone(p5) -- line: 171
        -- upvalues: v11 (copy), Workspace (copy), Rigs (copy)
        if not p5:IsA("Model") then
            return
        end

        local v16 = v11:Extend()

        v16:Connect(p5.AncestryChanged, function() -- line: 177
            -- upvalues: p5 (copy), v16 (copy), Workspace (copy)
            if not p5:IsDescendantOf(Workspace) then
                v16:Destroy()
            end
        end)
        Rigs.Drone(v16, p5)
    end

    local function watchDrones(p6) -- line: 185
        -- upvalues: v11 (copy), bindDrone (copy)
        v11:Connect(p6.ChildAdded, bindDrone)

        for _, child in p6:GetChildren() do
            bindDrone(child)
        end
    end

    for _, child in p3:GetChildren() do
        bindActor(child)

        if child.Name == "Drones" then
            v11:Connect(child.ChildAdded, bindDrone)

            for _, child in child:GetChildren() do
                bindDrone(child)
            end
        end
    end

    v11:Connect(p3.ChildAdded, function(p7) -- line: 198
        -- upvalues: v11 (copy), bindActor (copy), bindDrone (copy)
        bindActor(p7)

        if p7.Name == "Drones" then
            v11:Connect(p7.ChildAdded, bindDrone)

            for _, child in p7:GetChildren() do
                bindDrone(child)
            end
        end
    end)

    local function syncHold() -- line: 205
        -- upvalues: LocalPlayer (copy)
        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            if LocalPlayer:GetAttribute("ScrambleGrabbed") == true then
                Humanoid.PlatformStand = true
            else
                Humanoid.PlatformStand = LocalPlayer:GetAttribute("ScrambleThrown") ~= nil
            end
        end
    end

    v11:Connect(LocalPlayer:GetAttributeChangedSignal("ScrambleGrabbed"), syncHold)
    v11:Connect(LocalPlayer:GetAttributeChangedSignal("ScrambleThrown"), syncHold)
    v11:Connect(UserInputService.InputBegan, function(p8, p9) -- line: 216
        -- upvalues: n1 (ref), Remotes (copy), Kit (copy), t1 (copy), t2 (copy), LocalPlayer (copy)
        if not LocalPlayer:GetAttribute("ScrambleGrabbed") then
            return
        end

        if (t1[p8.UserInputType] == true or t2[p8.KeyCode] == true and not p9) and not (os.clock() - n1 < 0.07) then
            n1 = os.clock()
            Remotes.ScrambleBoss.HazardHit:FireServer(-2)
            Kit.Sound("Tick", nil, 0.8, 1.3 + math.random() * 0.4)
            Kit.Shake(1.5, 30, 0.15)
        end
    end)

    local function clearRescue() -- line: 233
        -- upvalues: Folder (ref), GrabRescue (ref)
        if Folder then
            Folder:Destroy()
        end

        Folder = nil
        GrabRescue = nil
    end

    v11:Add(clearRescue)
    v11:Connect(RunService.RenderStepped, function() -- line: 242
        -- upvalues: p3 (copy), Folder (ref), GrabRescue (ref), Kit (copy), Vfx (copy), LocalPlayer (copy)
        local v17 = p3:GetAttribute("GrabVictim") or 0
        local Mech = p3:FindFirstChild("Mech")
        local GrabRescue2 = Mech and Mech:FindFirstChild("GrabRescue")

        if v17 ~= 0 and v17 ~= LocalPlayer.UserId and GrabRescue2 ~= nil then
            if GrabRescue ~= GrabRescue2 then
                if Folder then
                    Folder:Destroy()
                end

                Folder = nil
                GrabRescue = nil

                local Folder2 = Instance.new("Folder")

                Folder2.Name = "ScrambleRescue"

                local v18 = Vfx.Ground(GrabRescue2.Position, p3:GetAttribute("FloorY"))

                Kit.Part({
                    Name = "Disc",
                    Transparency = 0.5,
                    Shape = Enum.PartType.Cylinder,
                    Color = Kit.Green,
                    Size = Vector3.new(0.3, GrabRescue2.Size.X, GrabRescue2.Size.Z),
                    CFrame = CFrame.new(v18 + Vector3.new(0, 0.2, 0)) * CFrame.Angles(0, 0, 1.5707963267948966),
                    Parent = Folder2
                })
                Kit.Part({
                    Name = "Pillar",
                    Transparency = 0.6,
                    Shape = Enum.PartType.Cylinder,
                    Color = Kit.Green,
                    Size = Vector3.new(GrabRescue2.Size.Y, 2.5, 2.5),
                    CFrame = CFrame.new(v18 + Vector3.new(0, GrabRescue2.Size.Y / 2, 0)) * CFrame.Angles(0, 0, 1.5707963267948966),
                    Parent = Folder2
                })
                Folder2.Parent = Kit.Debris()
                Folder = Folder2
                GrabRescue = GrabRescue2
            end

            local v21 = (math.sin(os.clock() * 8) + 1) / 2

            for _, child in Folder:GetChildren() do
                if child:IsA("BasePart") then
                    if child.Name == "Disc" then
                        child.Transparency = v21 * 0.3 + 0.35
                    else
                        child.Transparency = v21 * 0.3 + 0.5
                    end
                end
            end
        else
            if Folder then
                Folder:Destroy()
            end

            Folder = nil
            GrabRescue = nil
        end
    end)
    v11:Connect(Remotes.ScrambleBoss.Hazard.OnClientEvent, function(p10) -- line: 291
        -- upvalues: v13 (copy)
        v13:Add(p10)
    end)

    local function coilTop(p11) -- line: 295
        -- upvalues: p3 (copy)
        local Coils = p3:FindFirstChild("Coils")
        local v22 = Coils and Coils:FindFirstChild(p11)

        if v22 == nil then
            return nil
        end

        local Top = v22:FindFirstChild("Top")

        if Top and Top:IsA("BasePart") then
            return Top.Position
        end

        if not v22:IsA("Model") then
            return nil
        end

        local BoundingBox, BoundingBox2 = v22:GetBoundingBox()

        return BoundingBox.Position + Vector3.new(0, BoundingBox2.Y / 2, 0)
    end

    local function coilBurst(p12) -- line: 314
        -- upvalues: p3 (copy)
        local Coils = p3:FindFirstChild("Coils")
        local v24 = Coils and Coils:FindFirstChild(p12)

        if v24 ~= nil then
            for _, descendant in v24:GetDescendants() do
                if descendant:IsA("ParticleEmitter") then
                    descendant:Emit(descendant.Name == "AreaLightning" and 4 or 1)
                end
            end
        end
    end

    local function floor(p13) -- line: 328
        -- upvalues: p3 (copy), Vfx (copy)
        return Vfx.Ground(p13, p3:GetAttribute("FloorY"))
    end

    local function slam(p14, p15) -- line: 332
        -- upvalues: floor (copy), Vfx (copy)
        Vfx.Burst("Slam", CFrame.new(floor(p14)), p15)
    end

    local function hold(p16, p17) -- line: 336
        -- upvalues: v11 (copy)
        if p16 == nil then
            return
        end

        v11:Add(task.delay(p17, function() -- line: 341
            -- upvalues: p16 (copy)
            p16:Stop()
        end))
        v11:Add(function() -- line: 344
            -- upvalues: p16 (copy)
            p16:Stop()
        end)
    end

    local function zap(p18, p19, p20) -- line: 349
        -- upvalues: v11 (copy), RunService (copy), Vfx (copy)
        local LaserBeam = Vfx.Hold("LaserBeam", CFrame.new(p18))

        if LaserBeam == nil then
            return
        end

        local t7 = {}
        local t8 = {}
        local v25, v26

        for _, descendant in LaserBeam.Root:GetDescendants() do
            if descendant:IsA("Beam") and descendant.Attachment0 and descendant.Attachment1 then
                v25 = v25 or descendant.Attachment0.WorldPosition
                v26 = v26 or descendant.Attachment1.WorldPosition
            end
        end

        for _, descendant in LaserBeam.Root:GetDescendants() do
            if descendant:IsA("Attachment") then
                local WorldPosition = descendant.WorldPosition

                table.insert(if (if v26 then (WorldPosition - v26).Magnitude else 1e999) < (if v25 then (WorldPosition - v25).Magnitude else 0) then t8 else t7, descendant)
            end
        end

        local function place() -- line: 374
            -- upvalues: p18 (copy), p19 (copy), t7 (copy), t8 (copy)
            local v28 = p19()

            for _, v29 in t7 do
                v29.WorldPosition = p18
            end

            for _, v30 in t8 do
                v30.WorldPosition = v28
            end
        end

        local v31 = p19()

        for _, v32 in t7 do
            v32.WorldPosition = p18
        end

        for _, v33 in t8 do
            v33.WorldPosition = v31
        end

        local elapsed = os.clock()
        local connection

        connection = RunService.RenderStepped:Connect(function() -- line: 387
            -- upvalues: p18 (copy), p19 (copy), p20 (copy), LaserBeam (copy), t7 (copy), t8 (copy), elapsed (copy), connection (ref)
            local v34 = p19()

            for _, v35 in t7 do
                v35.WorldPosition = p18
            end

            for _, v36 in t8 do
                v36.WorldPosition = v34
            end

            if os.clock() - elapsed >= p20 then
                if connection then
                    connection:Disconnect()
                end

                LaserBeam:Stop()
            end
        end)
        v11:Add(function() -- line: 396
            -- upvalues: LaserBeam (copy), connection (ref)
            if connection then
                connection:Disconnect()
            end

            LaserBeam:Stop()
        end)
    end

    local function ballPosition(p21) -- line: 404
        -- upvalues: p3 (copy)
        local Ball = p3:FindFirstChild("Ball")

        if Ball ~= nil and Ball:IsA("Model") then
            local v37 = Ball:FindFirstChild("DrScrambleBall", true)

            if v37 and v37:IsA("Model") then
                return v37:GetBoundingBox().Position
            end

            if Ball.PrimaryPart then
                return Ball.PrimaryPart.Position
            end
        end

        return p21
    end

    local t9 = {
        MechIncoming = function(_) -- MechIncoming | line: 419
            -- upvalues: v12 (copy), Kit (copy)
            v12:Say("INCOMING!", nil, 1.5)
            Kit.Sound("Charge", nil, 1.2, 0.7)
        end,
        MechLand = function(p23) -- MechLand | line: 423
            -- upvalues: floor (copy), Kit (copy), Vfx (copy)
            Kit.Shake(8, 14, 1.4)
            Kit.Sound("ShockwaveRing", p23.At, 1.2)

            local At = p23.At

            Vfx.Burst("Slam", CFrame.new(floor(At)), 1.1)
        end,
        Stomp = function(p24) -- Stomp | line: 428
            -- upvalues: floor (copy), Kit (copy), Vfx (copy)
            local v38 = p24.Kind == "Slam"

            Kit.ShakeFrom(p24.At, v38 and 11 or 8, 520)
            Kit.Sound("ShockwaveRing", p24.At, v38 and 1.2 or 1)

            local At = p24.At
            local v39 = v38 and 1 or 0.8

            Vfx.Burst("Slam", CFrame.new(floor(At)), v39)
        end,
        Swipe = function(p25) -- Swipe | line: 434
            -- upvalues: p3 (copy), Kit (copy), Vfx (copy)
            local v40 = Kit.Flat(p25.Direction or Vector3.new(0, 0, 0))

            if v40.Magnitude < 0.1 then
                v40 = Vector3.new(0, 0, 1)
            end

            local v41 = p25.Origin or p25.At
            local v42 = Vfx.Ground(v41, p3:GetAttribute("FloorY")) + Vector3.new(0, 9, 0)
            local v43 = Vfx.Frame("BossSwipe", v42, v40)

            if (p25.Side or 1) < 0 then
                v43 = CFrame.new(v42) * CFrame.fromAxisAngle(v40.Unit, 3.141592653589793) * v43.Rotation
            end

            local BossSwipe = Vfx.Template("BossSwipe")
            local v44 = BossSwipe and BossSwipe:GetAttribute("ReferenceRadius")

            if typeof(v44) ~= "number" then
                v44 = 21
            end

            local v45 = (p25.Radius or 46) * 0.85 / v44

            Vfx.Burst("BossSwipe", v43, v45, 0.3)
            Kit.Sound("WideArmSwipe", p25.At, 1.2)
            Kit.ShakeFrom(p25.At, 5, 180)
        end,
        LaserCharge = function(_) -- LaserCharge | line: 458
            -- upvalues: Kit (copy)
            Kit.Sound("Charge", nil, 0.9, 1.1)
        end,
        RushDash = function(p27) -- RushDash | line: 461
            -- upvalues: p3 (copy), v11 (copy), RunService (copy), Kit (copy), Vfx (copy)
            local Mech = p3:FindFirstChild("Mech")

            Mech = Mech and Mech:IsA("Model") and Mech.PrimaryPart

            if Mech == nil then
                return
            end

            local function frame() -- line: 468
                -- upvalues: Mech (ref), p3 (copy), Kit (copy), Vfx (copy)
                local v46 = Kit.Flat(Mech.CFrame.LookVector)
                local v47 = if v46.Magnitude > 0.1 then v46.Unit else Vector3.new(0, 0, 1)
                local MechPosition = Mech.Position
                local v48 = Vfx.Ground(MechPosition, p3:GetAttribute("FloorY")) + v47 * 34 + Vector3.new(0, 30, 0)

                return Vfx.Frame("SpiderSlashes", v48, v47)
            end

            local Burst = Vfx.Burst
            local v49 = Kit.Flat(Mech.CFrame.LookVector)
            local v50 = if v49.Magnitude > 0.1 then v49.Unit else Vector3.new(0, 0, 1)
            local MechPosition = Mech.Position
            local v51 = Vfx.Ground(MechPosition, p3:GetAttribute("FloorY")) + v50 * 34 + Vector3.new(0, 30, 0)

            Burst("SpiderSlashes", Vfx.Frame("SpiderSlashes", v51, v50), 1, 0.35)
            Kit.Sound("SpiderRush", Mech, 1)

            local SpiderSlashes = Vfx.Hold("SpiderSlashes", frame())

            if SpiderSlashes == nil then
                return
            end

            local v52 = os.clock() + (p27.Seconds or 0.5)
            local connection

            connection = RunService.RenderStepped:Connect(function() -- line: 487
                -- upvalues: Mech (ref), frame (copy), SpiderSlashes (copy), v52 (copy), connection (ref)
                if os.clock() >= v52 or Mech.Parent == nil then
                    if connection then
                        connection:Disconnect()
                    end

                    SpiderSlashes:Stop()
                else
                    SpiderSlashes:Move(frame())
                end
            end)
            v11:Add(function() -- line: 497
                -- upvalues: SpiderSlashes (copy), connection (ref)
                if connection then
                    connection:Disconnect()
                end

                SpiderSlashes:Stop()
            end)
        end,
        RushStop = function(p28) -- RushStop | line: 504
            -- upvalues: floor (copy), Kit (copy), Vfx (copy)
            Kit.ShakeFrom(p28.At, 6, 250)
            Kit.Sound("HeavyLand", p28.At, 1.2)

            local At = p28.At

            Vfx.Burst("Slam", CFrame.new(floor(At)), 0.45)
        end,
        GrabReach = function(p29) -- GrabReach | line: 509
            -- upvalues: Kit (copy)
            Kit.Sound("Swoosh", p29.At, 1.6, 0.55)
            Kit.Sound("Charge", p29.At, 0.8, 1.3)
        end,
        GrabMiss = function(p30) -- GrabMiss | line: 513
            -- upvalues: floor (copy), Kit (copy), Vfx (copy)
            Kit.Sound("HeavyLand", p30.At, 1, 1.2)
            Kit.ShakeFrom(p30.At, 4, 160)

            local At = p30.At

            Vfx.Burst("Slam", CFrame.new(floor(At)), 0.4)
        end,
        Grab = function(p31) -- Grab | line: 518
            -- upvalues: v12 (copy), Players (copy), Kit (copy), LocalPlayer (copy)
            Kit.Sound("Chomp", nil, 1.5, 0.6)
            Kit.Sound("Boom", nil, 0.8, 1.2)

            local PlayerByUserId = Players:GetPlayerByUserId(p31.UserId or 0)

            if p31.UserId == LocalPlayer.UserId then
                Kit.Shake(6, 18, 0.6)
                v12:FlashScreen(Kit.Red, 0.6, 0.4)
                v12:Say("YOU'VE BEEN GRABBED!", nil, 2)
            else
                v12:Say(("SAVE %*!"):format((string.upper(PlayerByUserId and PlayerByUserId.DisplayName or "THEM"))), nil, 2.5)
            end
        end,
        GrabHit = function(_) -- GrabHit | line: 534
            -- upvalues: p3 (copy), Kit (copy)
            local v53 = p3:GetAttribute("GrabFree") or 0
            local v55 = math.max(p3:GetAttribute("GrabNeeded") or 1, 1)

            Kit.Sound("BatHit", nil, 1, 0.8 + v53 / v55 * 0.6)
            Kit.Shake(2, 20, 0.25)
        end,
        GrabBreak = function(p33) -- GrabBreak | line: 540
            -- upvalues: v12 (copy), Players (copy), Kit (copy), Vfx (copy), LocalPlayer (copy)
            Kit.Sound("Boom", p33.At, 1.2, 1.3)
            Kit.Sound("Pop", p33.At, 1.5)
            Kit.Shake(5, 16, 0.6)

            if p33.At then
                Vfx.Glitch(p33.At, 1.4, 0.35)
            end

            local PlayerByUserId = Players:GetPlayerByUserId(p33.UserId or 0)

            v12:Say(if p33.UserId == LocalPlayer.UserId then "BROKE FREE!" else ("%* IS FREE!"):format((string.upper(PlayerByUserId and PlayerByUserId.DisplayName or "THEY"))), nil, 1.6)
        end,
        Throw = function(p34) -- Throw | line: 556
            -- upvalues: v12 (copy), Kit (copy), LocalPlayer (copy)
            Kit.Sound("Swoosh", nil, 2, 0.5)

            if p34.UserId == LocalPlayer.UserId then
                Kit.Shake(7, 14, 1)
                v12:FlashScreen(Color3.new(1, 1, 1), 0.35, 0.3)
            end
        end,
        ThrowLand = function(p35) -- ThrowLand | line: 563
            -- upvalues: floor (copy), Kit (copy), Vfx (copy)
            Kit.ShakeFrom(p35.At, 6, 180)
            Kit.Sound("HeavyLand", p35.At, 1.1)

            local At = p35.At

            Vfx.Burst("Slam", CFrame.new(floor(At)), 0.35)
        end,
        MechHit = function(p36) -- MechHit | line: 568
            -- upvalues: v14 (ref)
            if v14 then
                v14.Hit(p36.Overheated == true)
            end
        end,
        Overheat = function(_) -- Overheat | line: 573
            -- upvalues: v12 (copy), Kit (copy)
            Kit.Sound("DrScrambleOverheating", nil, 1)
            v12:Say("HE'S OVERHEATING! HIT HIM NOW!", nil, 3)
        end,
        PhaseTwo = function(_) -- PhaseTwo | line: 577
            -- upvalues: Kit (copy)
            Kit.Shake(5, 10, 1.5)
            Kit.Sound("Roar", nil, 1.2, 0.7)
        end,
        Callout = function(p39) -- Callout | line: 581
            -- upvalues: v12 (copy)
            v12:Say(p39.Text or "", p39.Speaker, p39.Seconds)
        end,
        CrocWarn = function(_) -- CrocWarn | line: 584
            -- upvalues: v12 (copy), Kit (copy)
            v12:Say("GET THEM!", "Dr. Scramble", 2)
            Kit.Sound("DrScrambleLaughing", nil, 1)

            for i = 0, 5 do
                task.delay(i * 0.3, function() -- line: 588
                    -- upvalues: Kit (copy)
                    Kit.Sound("Tick", nil, 1, 1.8)
                end)
            end
        end,
        CrocLand = function(p41) -- CrocLand | line: 593
            -- upvalues: floor (copy), Kit (copy), Vfx (copy)
            Kit.ShakeFrom(p41.At, 8, 500)
            Kit.Sound("CrocShockwave", p41.At, 1.2)
            Vfx.Burst("CrocLeap", CFrame.new(floor(p41.At)), 1)
        end,
        CrocTarget = function(p42) -- CrocTarget | line: 598
            -- upvalues: v12 (copy), ScrambleBossFlags (copy), Kit (copy), LocalPlayer (copy)
            if p42.UserId == LocalPlayer.UserId then
                Kit.Sound("TargetLock", nil, 1)
            end

            v12:CrocTarget(p42.UserId or 0, ScrambleBossFlags.CrocChaseSeconds:Get() + 0.6)
        end,
        CrocBite = function(p43) -- CrocBite | line: 607
            -- upvalues: Kit (copy)
            Kit.Sound("ChaseBite", p43.At, 1.2)
            Kit.ShakeFrom(p43.At, 3.5, 140)
        end,
        CrocSweep = function(p44) -- CrocSweep | line: 611
            -- upvalues: p3 (copy), Kit (copy), Vfx (copy)
            Kit.Sound("TailSweep", p44.At, 1.2)
            Kit.ShakeFrom(p44.At, 4, 200)

            local Croc = p3:FindFirstChild("Croc")
            local v57 = if not (Croc and Croc:IsA("Model")) then Vector3.new(0, 0, 1) else Kit.Flat(Croc:GetPivot().LookVector)
            local v58 = Vfx.CrocScale(p3)
            local At = p44.At
            local v61 = Vfx.Ground(At, p3:GetAttribute("FloorY")) + Vector3.new(0, 2.34 * v58, 0)

            Vfx.Burst("CrocTail", Vfx.Frame("CrocTail", v61, v57), v58 * 1.6)
        end,
        CrocCharge = function(p45) -- CrocCharge | line: 622
            -- upvalues: Kit (copy)
            Kit.Sound("Roar", p45.At, 1.2, 1.1)
        end,
        CrocLeave = function(p46) -- CrocLeave | line: 625
            -- upvalues: v12 (copy), floor (copy), Kit (copy), Vfx (copy)
            Vfx.Burst("CrocLeap", CFrame.new(floor(p46.At)), 0.6)
            Kit.Sound("DrScrambleLaughing", nil, 1)
            v12:Say("HAHAHA! GOOD BOY!", "Dr. Scramble", 2)
        end,
        DroneSpawn = function(p47) -- DroneSpawn | line: 630
            -- upvalues: hold (copy), Vfx (copy)
            hold(Vfx.Hold("DroneSummon", CFrame.new(p47.At)), 0.9)
        end,
        DroneBoom = function(p48) -- DroneBoom | line: 633
            -- upvalues: floor (copy), Kit (copy), Vfx (copy)
            local At = p48.At

            Vfx.Burst("Slam", CFrame.new(floor(At)), 0.35)
            Kit.Sound("Boom", p48.At, 1)
            Kit.ShakeFrom(p48.At, 5, 80)
        end,
        DroneHit = function(p49) -- DroneHit | line: 638
            -- upvalues: Kit (copy)
            Kit.Sound("BatHit", p49.At, 0.7, 1.25)
        end,
        DronePop = function(p50) -- DronePop | line: 641
            -- upvalues: Kit (copy), Vfx (copy)
            Vfx.Glitch(p50.At, 1.2, 0.3)
            Kit.Sound("BatHit", p50.At, 1)
        end,
        EjectStart = function(p51) -- EjectStart | line: 645
            -- upvalues: v12 (copy), hold (copy), Kit (copy), Vfx (copy)
            v12:Say("SYSTEM FAILURE!", nil, 1.6)

            local v62 = p51.Open or 1.3

            Kit.Sound("DrScrambleEjecting", nil, 1)
            hold(Vfx.Hold("DroneSummon", CFrame.new(p51.At), 2.2), v62)
            Kit.Shake(2, 25, v62 + 0.4)
        end,
        Eject = function(p52) -- Eject | line: 652
            -- upvalues: Kit (copy), Vfx (copy)
            Vfx.Glitch(p52.At, 2.2, 0.35)
            Kit.Shake(6, 16, 1.1)
        end,
        MechWreck = function(p53) -- MechWreck | line: 656
            -- upvalues: p3 (copy), hold (copy), Vfx (copy)
            local Mech = p3:FindFirstChild("Mech")
            local v63 = 30

            if Mech and Mech:IsA("Model") then
                local _, BoundingBox = Mech:GetBoundingBox()

                v63 = BoundingBox.Y * 0.45
            end

            local Hold = Vfx.Hold
            local new = CFrame.new
            local At = p53.At

            hold(Hold("DroneSummon", new(Vfx.Ground(At, p3:GetAttribute("FloorY")) + Vector3.new(0, v63, 0)), 3), p53.Seconds or 25)
        end,
        MechDespawn = function(p54) -- MechDespawn | line: 672
            -- upvalues: Kit (copy), Vfx (copy)
            Vfx.Glitch(p54.At, 3, 0.35)
            Kit.Sound("Pop", p54.At, 1.6)
        end,
        SuitImpact = function(p55) -- SuitImpact | line: 676
            -- upvalues: floor (copy), Kit (copy), Vfx (copy)
            Kit.Shake(12, 12, 2)
            Kit.Sound("HeavyLand", nil, 2)
            Kit.Sound("Boom", nil, 1.5)

            for v64, v65 in p55.Points or {} do
                task.delay(v64 * 0.04, function() -- line: 681
                    -- upvalues: v65 (copy), floor (copy), Vfx (copy)
                    Vfx.Burst("Slam", CFrame.new(floor(v65)), 0.6)
                end)
            end
        end,
        BallLand = function(p56) -- BallLand | line: 686
            -- upvalues: floor (copy), Kit (copy), Vfx (copy)
            local v66 = p56.Big and 1.5 or 1

            Kit.ShakeFrom(p56.At, v66 * 10, 420)
            Kit.Sound("HeavyLand", p56.At, 1.6)
            Kit.Sound("Boom", p56.At, 1.1, 0.9)
            Vfx.Burst("CrocLeap", CFrame.new(floor(p56.At)), p56.Big and 0.9 or 0.5850000000000001)
        end,
        BallBounce = function(p57) -- BallBounce | line: 697
            -- upvalues: floor (copy), Kit (copy), Vfx (copy)
            Kit.Sound("HeavyLand", p57.At, 0.7, 1.25)
            Kit.ShakeFrom(p57.At, 3, 200)

            local At = p57.At

            Vfx.Burst("Slam", CFrame.new(floor(At)), 0.3)
        end,
        CoilsRise = function(_) -- CoilsRise | line: 702
            -- upvalues: p3 (copy), floor (copy), Kit (copy), Vfx (copy)
            Kit.Sound("Rumble", nil, 1, 1.2)
            Kit.Shake(2, 20, 2.2)

            local Coils = p3:FindFirstChild("Coils")
            local v67 = if Coils then Coils:GetChildren() else {}

            for _, v68 in v67 do
                local Home = v68:GetAttribute("Home")

                if typeof(Home) == "Vector3" then
                    Vfx.Burst("CrocLeap", CFrame.new(floor(Home)), 0.45)
                end
            end
        end,
        BallTarget = function(p59) -- BallTarget | line: 713
            -- upvalues: v12 (copy), Kit (copy), LocalPlayer (copy)
            if p59.UserId == LocalPlayer.UserId then
                Kit.Sound("TargetLock", nil, 1)
                v12:FlashScreen(Kit.Red, 0.5, 0.35)
            end
        end,
        BallBump = function(p60) -- BallBump | line: 719
            -- upvalues: Kit (copy)
            Kit.ShakeFrom(p60.At, 5, 60)
            Kit.Sound("Boom", p60.At, 0.8, 1.3)
        end,
        CoilZap = function(p61) -- CoilZap | line: 723
            -- upvalues: v11 (copy), coilTop (copy), coilBurst (copy), zap (copy), ballPosition (copy), Kit (copy), Vfx (copy), v4 (copy), coilBolts (copy)
            local v69 = coilTop(p61.Coil or "") or p61.At

            Kit.Sound("Tesla", v69, 1.5)
            Kit.ShakeFrom(v69, 6, 300)
            zap(v69, function() -- line: 727
                -- upvalues: p61 (copy), ballPosition (copy)
                return (ballPosition(p61.At))
            end, 0.6)
            Vfx.Glitch(ballPosition(p61.At), 1.8, 0.6)
            coilBurst(p61.Coil or "")
            Vfx.Burst("LightningSurge", CFrame.new((ballPosition(p61.At))), 3)
            Vfx.Burst("LightningSurge", CFrame.new(v69), 2)

            for i = 0, 5 do
                v11:Add(task.delay(i * 0.12, function() -- line: 735
                    -- upvalues: p61 (copy), v69 (copy), ballPosition (copy), v4 (copy), coilBolts (copy)
                    coilBolts(v69, ballPosition(p61.At) + v4:NextUnitVector() * 3)
                end))
            end
        end,
        CoreHit = function(p62) -- CoreHit | line: 743
            -- upvalues: Kit (copy), Vfx (copy)
            Kit.Sound("BatHit", p62.At, 0.8, 0.8 + math.random() * 0.2)
            Kit.Sound("Zap", p62.At, 0.35, 1.3 + math.random() * 0.3)
            Vfx.Glitch(p62.At, 0.9, 0.2)
        end,
        CoreCrack = function(p63) -- CoreCrack | line: 748
            -- upvalues: v12 (copy), Kit (copy), Vfx (copy)
            Kit.Sound("Zap", p63.At, 1.4, 0.8)
            Kit.Sound("HeavyLand", p63.At, 0.9, 1.3)
            Kit.Shake(4, 18, 0.8)
            Vfx.Glitch(p63.At, 1.8, 0.6)

            local v70 = p63.Stage or 1
            local v71 = p63.Needed or 3

            v12:Say(if v70 == 1 then "CORE DAMAGED!" elseif v70 < v71 then "CORE CRITICAL!" else "CORE OVERLOADED!", nil, 1.8)
        end,
        CoreBurst = function(p64) -- CoreBurst | line: 761
            -- upvalues: floor (copy), Kit (copy), Vfx (copy)
            Kit.Sound("Boom", p64.At, 1.2)
            Kit.Sound("Zap", p64.At, 2, 0.7)
            Kit.Shake(8, 16, 1.2)

            local At = p64.At

            Vfx.Burst("Slam", CFrame.new(floor(At)), 0.7)
            Vfx.Glitch(p64.At, 2.52, 0.7)
        end,
        HumanHit = function(p65) -- HumanHit | line: 768
            -- upvalues: Kit (copy)
            Kit.Sound("BatHit", p65.At, 1.5)
            Kit.ShakeFrom(p65.At, 3, 80)
        end,
        FinalHit = function(p66) -- FinalHit | line: 772
            -- upvalues: p3 (copy), v11 (copy), v12 (copy), Cinematic (copy)
            task.spawn(Cinematic.FinalHit, v11, p3, v12, p66)
        end,
        Defeated = function(_) -- Defeated | line: 775
            -- upvalues: v12 (copy)
            v12:Say("DR. SCRAMBLE DEFEATED!", nil, 5)
        end
    }

    v11:Connect(RunService.RenderStepped, Vfx.Sample)
    v11:Connect(Remotes.ScrambleBoss.Fx.OnClientEvent, function(p68, p69) -- line: 781
        -- upvalues: t9 (copy)
        local v73 = t9[p68]

        if not v73 then
            return
        end

        p69 = p69 or {}

        local ok, result = pcall(v73, p69)

        if not ok then
            warn((("[ScrambleBoss] fx %* failed: %*"):format(p68, result)))
        end
    end)
end

local function warmAssets() -- line: 792
    -- upvalues: ReplicatedStorage (copy), ContentProvider (copy)
    local t10 = {}
    local t11 = {
        MeshPart = true,
        Decal = true,
        Animation = true,
        ParticleEmitter = true,
        Beam = true,
        ImageLabel = true,
        Sound = true
    }

    for _, v75 in { ReplicatedStorage.CutsceneAssets.ScrambleBossCutsceneAssets } do
        for _, descendant in v75:GetDescendants() do
            local v76 = false

            for v77 in t11 do
                if descendant:IsA(v77) then
                    v76 = true
                    break
                end
            end

            if v76 then
                table.insert(t10, descendant)
            end
        end
    end

    print((("[%*] Preloading %* assets"):format(script.Name, #t10)))
    ContentProvider:PreloadAsync(t10)
    print((("[%*] Preloading completed"):format(script.Name)))
end

task.spawn(function() -- line: 832
    -- upvalues: RunService (copy), warmAssets (copy)
    local v78 = os.time()

    if RunService:IsStudio() and v78 < 1790434800 then
        warmAssets()
    elseif v78 < 1790431200 then
        task.wait(1790431200 - v78)
        task.delay(math.random(180), warmAssets)
    elseif v78 < 1790434800 then
        task.delay(math.random(60), warmAssets)
    end
end)

local function joinAdminFight() -- line: 849
    -- upvalues: Remotes (copy), Transition (copy)
    Transition.Cover()

    local function v79() -- line: 851
        -- upvalues: Remotes (copy)
        return Remotes.ScrambleBoss.EnterArena:InvokeServer()
    end

    local ok, result = pcall(v79)

    if not ok or result ~= true then
        Transition.Reveal()
    end
end

local t12 = {
    StartEvent = function(_, _, p72) -- StartEvent | line: 861
        -- upvalues: Workspace (copy), Environment (copy), ScrambleBossFlags (copy), v3 (copy), v5 (ref), v6 (ref), bindArena (copy), joinAdminFight (copy)
        local v80 = Environment.IsTestPlace() and p72 ~= nil and p72.Testing == true

        if not (ScrambleBossFlags.ContentEnabled:Get() or v80) then
            return
        end

        v3:Clean()
        v6 = false

        local v81 = p72 ~= nil and type(p72.StarterUserId) == "number"

        if v81 and p72 and not p72.SkipCutscenes then
            local function v82() -- line: 872
                -- upvalues: v3 (copy), v6 (ref)
                require(script.Cutscenes.IntroCutscene1)(v3).Run()
                require(script.Cutscenes.IntroCutscene2)(v3).Run()
                v3:Clean()
                v6 = true
            end

            local function v83(p73) -- line: 881
                warn((("[%*] %*"):format(script.Name, p73)))
            end

            xpcall(v82, v83)
        end

        v5 = true

        local ScrambleArena = Workspace:FindFirstChild("ScrambleArena")

        if ScrambleArena and ScrambleArena:IsA("Model") then
            task.defer(bindArena, ScrambleArena)
        end

        v3:Connect(Workspace.ChildAdded, function(p74) -- line: 893
            -- upvalues: v5 (ref), bindArena (copy)
            if p74.Name == "ScrambleArena" and p74:IsA("Model") and v5 then
                task.defer(bindArena, p74)
            end
        end)

        if v81 then
            task.spawn(joinAdminFight)
        end
    end,
    StopEvent = function(_) -- StopEvent | line: 904
        -- upvalues: v3 (copy), v5 (ref), v6 (ref)
        v3:Clean()
        v5 = false

        if not v6 then
            return
        end

        v6 = false

        local function v84() -- line: 911
            -- upvalues: v3 (copy)
            require(script.Cutscenes.OutroCutscene1)(v3).Run()
            require(script.Cutscenes.OutroCutscene2)(v3).Run()
            v3:Clean()
        end

        local function v85(p76) -- line: 918
            warn((("[%*] %*"):format(script.Name, p76)))
        end

        xpcall(v84, v85)
    end
}

Transition.Listen()

return t12
