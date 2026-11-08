-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local PumpkinBossFlags = require(ReplicatedStorage.Shared.Flags.PumpkinBossFlags)
local PumpkinBossState = require(ReplicatedStorage.Shared.Util.PumpkinBossState)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local ShrinePadZone = require(ReplicatedStorage.Shared.Util.ShrinePadZone)
local Kit = require(script.Parent.Kit)
local Vfx = require(script.Parent.Vfx)
local Phases, Attributes, CannonAttributes, TrapAttributes = PumpkinBossState.Phases, PumpkinBossState.Attributes, PumpkinBossState.CannonAttributes, PumpkinBossState.TrapAttributes
local v1 = Color3.fromRGB(255, 120, 20)
local CannonAim = PumpkinBossState.CannonAim
local LocalPlayer = Players.LocalPlayer

local function ballTemplate() -- line: 96
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local HalloweenDimension = Assets and Assets:FindFirstChild("HalloweenDimension")
    local PumpkinBoss = HalloweenDimension and HalloweenDimension:FindFirstChild("PumpkinBoss")
    local PumpkinCannonball = PumpkinBoss and PumpkinBoss:FindFirstChild("PumpkinCannonball")

    return if PumpkinCannonball and PumpkinCannonball:IsA("Model") then PumpkinCannonball else nil
end

local function muzzleFlash(p1, p2) -- line: 105
    -- upvalues: Vfx (copy)
    local v2 = Vfx.Template(Vfx.PhaseTwo, { "Cannon", "CannonFire" })

    if v2 ~= nil and not (p2.Magnitude < 0.001) then
        local ShotVFX = v2:FindFirstChild("ShotVFX")
        local v3 = if ShotVFX and ShotVFX:IsA("Attachment") then ShotVFX.Position else Vector3.new(0, 0, 0)

        Vfx.Emit(Vfx.Place(v2, CFrame.lookAt(p1, p1 + p2) * CFrame.new(-v3)))
    end
end

local function launchPoint(p3) -- line: 115
    local v4 = p3:FindFirstChild("LaunchPoint", true) or p3:FindFirstChild("Muzzle", true)

    return if v4 and v4:IsA("Attachment") then v4 else nil
end

local function rootPart() -- line: 121
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    return if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart else nil
end

local function alive() -- line: 127
    -- upvalues: TrapAttributes (copy), LocalPlayer (copy)
    local Character = LocalPlayer.Character

    if Character == nil or Character:GetAttribute(TrapAttributes.Trapped) == true then
        return false
    end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    return Humanoid ~= nil and Humanoid.Health > 0
end

local function flat(p4) -- line: 136
    return (Vector3.new(p4.X, 0, p4.Z))
end

local function yawOf(p5) -- line: 140
    return (math.atan2(-p5.X, -p5.Z))
end

local function barrelFrame(p6, p7, p8) -- line: 144
    local v7 = p7:PointToWorldSpace(p6.Hinge)

    return CFrame.new(v7) * CFrame.fromAxisAngle(p7.RightVector, p8) * CFrame.new(-v7) * p7 * p6.BarrelLocal
end

local function newAim(p9) -- line: 154
    -- upvalues: CannonAttributes (copy), CannonAim (copy)
    local Attribute = p9:GetAttribute(CannonAttributes.Base)
    local Attribute2 = p9:GetAttribute(CannonAttributes.Hinge)
    local Attribute3 = p9:GetAttribute(CannonAttributes.Barrel)
    local Barrel = p9:FindFirstChild("Barrel")
    local OperatorZone, RootHitbox, v8

    if typeof(Attribute) ~= "CFrame" or typeof(Attribute2) ~= "Vector3" or typeof(Attribute3) ~= "CFrame" or Barrel == nil then
        v8 = true
    elseif Barrel:IsA("Model") then
        OperatorZone = p9:FindFirstChild("OperatorZone")
        RootHitbox = p9:FindFirstChild("RootHitbox")

        if not OperatorZone or not OperatorZone:IsA("BasePart") then
            OperatorZone = nil
        end

        v8 = false
    else
        v8 = true
    end

    if v8 then
        return nil
    end

    if not (RootHitbox and RootHitbox:IsA("BasePart")) then
        RootHitbox = nil
    end

    local OperatorPad = p9:FindFirstChild("OperatorPad")

    if not (OperatorPad and OperatorPad:IsA("Model")) then
        OperatorPad = nil
    end

    local LookVector = (Attribute * Attribute3).LookVector
    local LookVector2 = Barrel:GetPivot().LookVector
    local v10 = math.atan2(LookVector2.Y, Vector3.new(LookVector2.X, 0, LookVector2.Z).Magnitude) - math.atan2(LookVector.Y, Vector3.new(LookVector.X, 0, LookVector.Z).Magnitude)

    return {
        Occupied = false,
        Kick = 0,
        Jolt = 0,
        JoltDirection = Vector3.new(1, 0, 0),
        Jolted = nil,
        Model = p9,
        Barrel = Barrel,
        Zone = OperatorZone,
        ZoneFrame = if OperatorZone then OperatorZone.CFrame else CFrame.identity,
        Hitbox = RootHitbox,
        HitboxFrame = if RootHitbox then RootHitbox.CFrame else CFrame.identity,
        Pad = OperatorPad,
        PadFrame = if OperatorPad then OperatorPad:GetPivot() else CFrame.identity,
        Rest = Attribute,
        Base = Attribute,
        Hinge = Attribute2,
        BarrelLocal = Attribute3,
        Pitch = math.clamp(v10, 0, CannonAim.MaxPitch)
    }
end

local function restoreFixed(p10) -- line: 203
    local Zone, Hitbox, Pad = p10.Zone, p10.Hitbox, p10.Pad

    if Zone then
        Zone.CFrame = p10.ZoneFrame
    end

    if Hitbox then
        Hitbox.CFrame = p10.HitboxFrame
    end

    if Pad then
        Pad:PivotTo(p10.PadFrame)
    end
end

local function occupied(p11) -- line: 216
    -- upvalues: Players (copy), ShrinePadZone (copy)
    for _, player in Players:GetPlayers() do
        local Character = player.Character
        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") and ShrinePadZone.ContainsPoint(p11, HumanoidRootPart.Position) then
            return true
        end
    end

    return false
end

local t2 = {}

t2.__index = t2

function t2.new(p12, p13) -- line: 230
    -- upvalues: RunService (copy), UserInputService (copy), Kit (copy), ballTemplate (copy), t2 (copy)
    local v11 = setmetatable({
        Active = nil,
        Bound = false,
        NextShotId = 0,
        LastFire = 0,
        NextScan = 0,
        Facing = nil,
        FacingAutoRotate = true,
        Trove = p12,
        Arena = p13,
        Predicted = {},
        Flights = {},
        Folder = Instance.new("Folder"),
        Ball = ballTemplate(),
        MoveParts = {},
        MoveFrames = {},
        Aims = {}
    }, t2)

    v11.Folder.Name = "PumpkinCannonballs"
    v11.Folder.Parent = Kit.Debris()
    p12:Add(v11.Folder)
    p12:Connect(UserInputService.InputBegan, function(p14, p15) -- line: 256
        -- upvalues: v11 (copy)
        if not p15 and (p14.UserInputType == Enum.UserInputType.MouseButton1 or p14.UserInputType == Enum.UserInputType.Touch or p14.KeyCode == Enum.KeyCode.ButtonR2) then
            v11:Fire()
        end
    end)
    p12:Connect(RunService.RenderStepped, function(p16) -- line: 269
        -- upvalues: v11 (copy)
        v11:Step(p16)
    end)
    p12:Add(function() -- line: 272
        -- upvalues: v11 (copy)
        v11:SetBound(false)
        v11:Face(nil)
        v11:ResetAims()
    end)

    return v11
end

function t2.Usable(p17) -- line: 282
    -- upvalues: PumpkinBossState (copy), ShrinePadZone (copy), Phases (copy), Attributes (copy), CannonAttributes (copy), TrapAttributes (copy), LocalPlayer (copy)
    local Attribute = p17.Arena:GetAttribute(Attributes.Phase)

    if Attribute == Phases.Shield or Attribute == Phases.Stunned then
        local Character = LocalPlayer.Character
        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
            HumanoidRootPart = nil
        end

        local v12 = p17.Arena:FindFirstChild(PumpkinBossState.CannonFolder)

        if HumanoidRootPart ~= nil and v12 ~= nil then
            local Character = LocalPlayer.Character

            if Character ~= nil and Character:GetAttribute(TrapAttributes.Trapped) ~= true then
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                if Humanoid ~= nil and Humanoid.Health > 0 then
                    local child, child2

                    for _, child3 in v12:GetChildren() do
                        local Attribute = child3:GetAttribute(CannonAttributes.OwnerUserId)

                        if Attribute == LocalPlayer.UserId then
                            child = child3
                        elseif Attribute == 0 and child2 == nil then
                            local OperatorZone = child3:FindFirstChild("OperatorZone")

                            if OperatorZone and OperatorZone:IsA("BasePart") and ShrinePadZone.ContainsPoint(OperatorZone, HumanoidRootPart.Position) then
                                child2 = child3
                            end
                        end
                    end

                    local v13 = child or child2

                    if v13 ~= nil and v13:GetAttribute(CannonAttributes.Ready) == true then
                        local OperatorZone = v13:FindFirstChild("OperatorZone")

                        if OperatorZone ~= nil and OperatorZone:IsA("BasePart") and ShrinePadZone.ContainsPoint(OperatorZone, HumanoidRootPart.Position) then
                            return v13
                        end
                    end

                    return nil
                end
            end
        end
    end

    return nil
end

function t2.SetBound(p18, p19) -- line: 328
    -- upvalues: ContextActionService (copy)
    if p18.Bound ~= p19 then
        p18.Bound = p19

        if p19 then
            ContextActionService:BindActionAtPriority("PumpkinCannonFire", function(_, p21) -- line: 335
                -- upvalues: p18 (copy)
                if p21 == Enum.UserInputState.Begin then
                    p18:Fire()
                end

                return Enum.ContextActionResult.Pass
            end, true, Enum.ContextActionPriority.High.Value)
            ContextActionService:SetTitle("PumpkinCannonFire", "FIRE")
        else
            ContextActionService:UnbindAction("PumpkinCannonFire")
        end
    end
end

function t2.KingAim(p22) -- line: 347
    for _, child in p22.Arena:GetChildren() do
        if child.Name == "King" and child:IsA("Model") then
            local Hitbox = child:FindFirstChild("Hitbox")

            if Hitbox and Hitbox:IsA("BasePart") then
                return Hitbox.Position
            end
        end
    end

    return nil
end

function t2.Fire(p23) -- line: 359
    -- upvalues: Workspace (copy), PumpkinBossFlags (copy), PumpkinBossState (copy), Remotes (copy), Kit (copy), LocalPlayer (copy)
    local Active = p23.Active

    if Active ~= nil then
        local elapsed = os.clock()

        if not (elapsed - p23.LastFire < PumpkinBossFlags.CannonFireCooldown:Get()) then
            p23.LastFire = elapsed
            p23.NextShotId += 1

            local NextShotId = p23.NextShotId

            Remotes.PumpkinBoss.CannonFire:FireServer(NextShotId)
            Kit.Sound("CannonFire", nil, 0.8, 1.3)
            Kit.Shake(4, 12, 0.35)
            p23:Kick(Active)

            local v14 = Active:FindFirstChild("LaunchPoint", true) or Active:FindFirstChild("Muzzle", true)

            if not (v14 and v14:IsA("Attachment")) then
                v14 = nil
            end

            local v15 = p23:KingAim()

            if v14 and v15 then
                local WorldPosition = v14.WorldPosition

                p23.Predicted[PumpkinBossState.ShotKey(LocalPlayer.UserId, NextShotId)] = elapsed + 5
                p23:Launch(WorldPosition, v15, PumpkinBossState.ShotFlight(WorldPosition, v15), Workspace:GetServerTimeNow())
            end
        end
    end
end

function t2.Launch(p24, p25, p26, p27, p28) -- line: 393
    -- upvalues: PumpkinBossState (copy), Kit (copy), v1 (copy), muzzleFlash (copy)
    local t4 = {}
    local t5 = {}
    local Ball = p24.Ball
    local v16

    if Ball then
        v16 = Ball:Clone()

        local Pivot = v16:GetPivot()

        for _, descendant in v16:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true
                descendant.CanCollide = false
                descendant.CanQuery = false
                descendant.CanTouch = false
                table.insert(t4, descendant)
                table.insert(t5, Pivot:ToObjectSpace(descendant.CFrame))
            end
        end

        v16:PivotTo(CFrame.new(p25))
        v16.Parent = p24.Folder
    else
        v16 = Kit.Part({
            Name = "Cannonball",
            Size = Vector3.new(3, 3, 3),
            Shape = Enum.PartType.Ball,
            Material = Enum.Material.SmoothPlastic,
            Color = v1,
            CFrame = CFrame.new(p25)
        })
        v16.Parent = p24.Folder
        table.insert(t4, v16)
        table.insert(t5, CFrame.identity)
    end

    local v17 = PumpkinBossState.LaunchVelocity(p25, p26, p27)

    muzzleFlash(p25, v17)
    Kit.Poof(p25, 0.7)
    table.insert(p24.Flights, {
        Root = v16,
        Parts = t4,
        Offsets = t5,
        Last = p25,
        Origin = p25,
        Velocity = v17,
        Target = p26,
        StartedAt = p28,
        Seconds = p27
    })
end

function t2.OnShot(p29, p30) -- line: 452
    -- upvalues: Workspace (copy), PumpkinBossState (copy), Kit (copy), CannonAttributes (copy), LocalPlayer (copy)
    local v18 = PumpkinBossState.ShotKey(p30.UserId, p30.ShotId)

    if p30.UserId == LocalPlayer.UserId and p29.Predicted[v18] then
        p29.Predicted[v18] = nil

        return
    end

    local Origin = p30.Origin
    local Origin2, Target, v19, v20

    if typeof(Origin) == "Vector3" and typeof(p30.Target) == "Vector3" then
        Origin2 = p30.Origin
        Target = p30.Target
        v19 = p30.Flight or 1
        v20 = p30.StartAt or Workspace:GetServerTimeNow()
        p29:Launch(Origin2, Target, v19, v20)
        Kit.Sound("CannonFire", p30.Origin, 0.6, 1.3)
        Kit.ShakeFrom(p30.Origin, 2, 90)
    end

    local v21 = p29.Arena:FindFirstChild(PumpkinBossState.CannonFolder)

    if v21 and type(p30.CannonId) == "number" then
        for _, child in v21:GetChildren() do
            if child:IsA("Model") and child:GetAttribute(CannonAttributes.CannonId) == p30.CannonId then
                p29:Kick(child)

                return
            end
        end
    end
end

function t2.Kick(p31, p32) -- line: 481
    -- upvalues: newAim (copy)
    local Aims = p31.Aims
    local v22 = Aims[p32]

    if v22 == nil then
        v22 = newAim(p32)

        if v22 == nil then
            return
        end

        Aims[p32] = v22
    end

    v22.Kick = 1
end

function t2.Jolt(p33, p34, p35) -- line: 494
    -- upvalues: Workspace (copy), LocalPlayer (copy), newAim (copy)
    local Aims = p33.Aims
    local v23 = Aims[p34]

    if v23 == nil then
        v23 = newAim(p34)

        if v23 == nil then
            return
        end

        Aims[p34] = v23
    end

    p35 = p35 or v23.Base.Position

    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        HumanoidRootPart = nil
    end

    local CurrentCamera = Workspace.CurrentCamera
    local v25 = if HumanoidRootPart and (HumanoidRootPart.Position - p35).Magnitude <= 24 then p35 - HumanoidRootPart.Position elseif CurrentCamera then CurrentCamera.CFrame.LookVector else Vector3.new(1, 0, 0)
    local v26 = Vector3.new(v25.X, 0, v25.Z)

    if v26.Magnitude > 0.001 then
        v23.JoltDirection = v26.Unit
    else
        v23.JoltDirection = Vector3.new(1, 0, 0)
    end

    v23.Jolt = 1
end

local function unjolt(p36) -- line: 517
    local Jolted = p36.Jolted

    if Jolted == nil then
        return
    end

    p36.Jolted = nil
    p36.Model:PivotTo(Jolted:Inverse() * p36.Model:GetPivot())

    local Zone, Hitbox, Pad = p36.Zone, p36.Hitbox, p36.Pad

    if Zone then
        Zone.CFrame = p36.ZoneFrame
    end

    if Hitbox then
        Hitbox.CFrame = p36.HitboxFrame
    end

    if Pad then
        Pad:PivotTo(p36.PadFrame)
    end
end

local function jolt(p37, p38) -- line: 528
    if p37.Jolt <= 0 then
        return
    end

    p37.Jolt = math.max(p37.Jolt - p38 / 0.25, 0)

    local Jolt = p37.Jolt
    local v29 = math.sin((1 - Jolt) * 3.141592653589793 * 2.5) * Jolt * Jolt

    if Jolt <= 0 or math.abs(v29) < 1E-04 then
        return
    end

    local BasePosition = p37.Base.Position
    local v30 = (Vector3.new(0, 1, 0)):Cross(p37.JoltDirection)
    local v31 = if v30.Magnitude > 0.001 then CFrame.fromAxisAngle(v30.Unit, v29 * 0.04363323129985824) else CFrame.identity
    local v32 = CFrame.new(BasePosition + p37.JoltDirection * 0.35 * v29) * v31 * CFrame.new(-BasePosition)

    p37.Model:PivotTo(v32 * p37.Model:GetPivot())
    p37.Jolted = v32

    local Zone, Hitbox, Pad = p37.Zone, p37.Hitbox, p37.Pad

    if Zone then
        Zone.CFrame = p37.ZoneFrame
    end

    if Hitbox then
        Hitbox.CFrame = p37.HitboxFrame
    end

    if Pad then
        Pad:PivotTo(p37.PadFrame)
    end
end

local function kick(p39, p40) -- line: 553
    -- upvalues: barrelFrame (copy)
    if p39.Kick <= 0 then
        return
    end

    p39.Kick = math.max(p39.Kick - p40 / 0.4, 0)

    local v34 = 1 - p39.Kick
    local v35 = if v34 < 0.12 then v34 / 0.12 else (1 - (v34 - 0.12) / 0.88) ^ 2

    p39.Barrel:PivotTo(barrelFrame(p39, p39.Base, p39.Pitch + v35 * 0.17453292519943295) * CFrame.new(0, 0, v35 * 1.8))
end

function t2.Scan(p41) -- line: 570
    -- upvalues: PumpkinBossState (copy), Phases (copy), Attributes (copy), CannonAttributes (copy), newAim (copy), occupied (copy)
    local Aims = p41.Aims

    for v36 in Aims do
        if v36.Parent == nil then
            Aims[v36] = nil
        end
    end

    local v37 = p41.Arena:FindFirstChild(PumpkinBossState.CannonFolder)

    if v37 == nil then
        return
    end

    local Attribute = p41.Arena:GetAttribute(Attributes.Phase)
    local v38 = Attribute == Phases.Shield or Attribute == Phases.Stunned

    for _, child in v37:GetChildren() do
        if child:IsA("Model") then
            local v39 = Aims[child]

            if v39 ~= nil then
                local Zone = v39.Zone

                if v38 then
                    if Zone ~= nil then
                        if child:GetAttribute(CannonAttributes.Ready) == true then
                            v39.Occupied = occupied(Zone)
                        else
                            v39.Occupied = false
                        end
                    else
                        v39.Occupied = false
                    end
                else
                    v39.Occupied = v38
                end
            else
                v39 = newAim(child)

                if v39 ~= nil then
                    Aims[child] = v39

                    local Zone = v39.Zone

                    if v38 then
                        if Zone ~= nil then
                            if child:GetAttribute(CannonAttributes.Ready) == true then
                                v39.Occupied = occupied(Zone)
                            else
                                v39.Occupied = false
                            end
                        else
                            v39.Occupied = false
                        end
                    else
                        v39.Occupied = v38
                    end
                end
            end
        end
    end
end

local function turn(p42, p43, p44) -- line: 606
    -- upvalues: CannonAim (copy), barrelFrame (copy)
    local Base = p42.Base
    local BasePosition = Base.Position
    local v40 = p43 - BasePosition
    local v41 = Vector3.new(v40.X, 0, v40.Z)

    if v41.Magnitude <= CannonAim.MinDistance then
        return
    end

    local LookVector = Base.LookVector
    local v44 = math.atan2(-LookVector.X, -LookVector.Z)
    local v47 = (math.atan2(-v41.X, -v41.Z) - v44 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
    local v48 = CannonAim.TurnRate * p44
    local v50 = v44 + math.clamp(v47, -v48, v48)
    local v51 = CFrame.new(BasePosition) * CFrame.Angles(0, v50, 0)
    local v52 = p43 - v51:PointToWorldSpace(p42.Hinge)
    local v54 = math.clamp(math.atan2(v52.Y, Vector3.new(v52.X, 0, v52.Z).Magnitude), 0, CannonAim.MaxPitch)
    local v55 = CannonAim.PitchRate * p44
    local v58 = p42.Pitch + math.clamp(v54 - p42.Pitch, -v55, v55)
    local v60 = math.abs(v50 - v44) > 1E-04
    local v61 = if not v60 then math.abs(v58 - p42.Pitch) <= 1E-04 else nil

    if not v60 and v61 then
        return
    end

    if v60 then
        p42.Model:PivotTo(v51 * Base:Inverse() * p42.Model:GetPivot())
        p42.Base = v51

        local Zone, Hitbox, Pad = p42.Zone, p42.Hitbox, p42.Pad

        if Zone then
            Zone.CFrame = p42.ZoneFrame
        end

        if Hitbox then
            Hitbox.CFrame = p42.HitboxFrame
        end

        if Pad then
            Pad:PivotTo(p42.PadFrame)
        end
    end

    p42.Pitch = v58
    p42.Barrel:PivotTo((barrelFrame(p42, p42.Base, v58)))
end

function t2.ResetAims(p45) -- line: 640
    -- upvalues: barrelFrame (copy)
    for v63, v64 in p45.Aims do
        v64.Jolt = 0

        if v63.Parent then
            local Jolted = v64.Jolted

            if Jolted ~= nil then
                v64.Jolted = nil
                v64.Model:PivotTo(Jolted:Inverse() * v64.Model:GetPivot())

                local Zone, Hitbox, Pad = v64.Zone, v64.Hitbox, v64.Pad

                if Zone then
                    Zone.CFrame = v64.ZoneFrame
                end

                if Hitbox then
                    Hitbox.CFrame = v64.HitboxFrame
                end

                if Pad then
                    Pad:PivotTo(v64.PadFrame)
                end
            end
        end

        if v63.Parent and v64.Kick > 0 then
            v64.Kick = 0
            v64.Barrel:PivotTo((barrelFrame(v64, v64.Base, v64.Pitch)))
        end

        if v63.Parent and v64.Base ~= v64.Rest then
            v63:PivotTo(v64.Rest * v64.Base:Inverse() * v63:GetPivot())

            local Zone, Hitbox, Pad = v64.Zone, v64.Hitbox, v64.Pad

            if Zone then
                Zone.CFrame = v64.ZoneFrame
            end

            if Hitbox then
                Hitbox.CFrame = v64.HitboxFrame
            end

            if Pad then
                Pad:PivotTo(v64.PadFrame)
            end
        end
    end

    table.clear(p45.Aims)
end

function t2.Face(p46, p47) -- line: 659
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local Humanoid = if not p47 or not Character then nil else Character:FindFirstChildOfClass("Humanoid")
    local Facing = p46.Facing

    if Facing and Facing ~= Humanoid then
        if Facing.Parent then
            Facing.AutoRotate = p46.FacingAutoRotate
        end

        p46.Facing = nil
    end

    if Humanoid == nil or p47 == nil then
        return
    end

    if p46.Facing == nil then
        p46.FacingAutoRotate = Humanoid.AutoRotate
        Humanoid.AutoRotate = false
        p46.Facing = Humanoid
    end

    local Character2 = LocalPlayer.Character
    local HumanoidRootPart = Character2 and Character2:FindFirstChild("HumanoidRootPart")

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        HumanoidRootPart = nil
    end

    if HumanoidRootPart == nil then
        return
    end

    local v65 = p47 - HumanoidRootPart.Position
    local v66 = Vector3.new(v65.X, 0, v65.Z)

    if not (v66.Magnitude < 0.001) then
        local v69 = math.atan2(-v66.X, -v66.Z)
        local LookVector = HumanoidRootPart.CFrame.LookVector

        if math.abs((v69 - math.atan2(-LookVector.X, -LookVector.Z) + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) > 0.017453292519943295 then
            HumanoidRootPart.CFrame = CFrame.lookAt(HumanoidRootPart.Position, HumanoidRootPart.Position + v66.Unit)
        end
    end
end

function t2.Step(p48, p49) -- line: 695
    -- upvalues: Workspace (copy), PumpkinBossState (copy), jolt (copy), kick (copy), turn (copy)
    p48.Active = p48:Usable()
    p48:SetBound(p48.Active ~= nil)

    local elapsed = os.clock()

    if p48.NextScan <= elapsed then
        p48.NextScan = elapsed + 0.2
        p48:Scan()
    end

    local v74 = false
    local v73

    for _, v75 in p48.Aims do
        local Jolted = v75.Jolted

        if Jolted ~= nil then
            v75.Jolted = nil
            v75.Model:PivotTo(Jolted:Inverse() * v75.Model:GetPivot())

            local Zone, Hitbox, Pad = v75.Zone, v75.Hitbox, v75.Pad

            if Zone then
                Zone.CFrame = v75.ZoneFrame
            end

            if Hitbox then
                Hitbox.CFrame = v75.HitboxFrame
            end

            if Pad then
                Pad:PivotTo(v75.PadFrame)
            end
        end

        if v75.Occupied then
            if not v74 then
                v73 = p48:KingAim()
                v74 = true
            end

            if v73 then
                turn(v75, v73, p49)
            end
        end

        kick(v75, p49)
        jolt(v75, p49)
    end

    if p48.Active then
        p48:Face(if v74 then v73 else p48:KingAim())
    else
        p48:Face(nil)
    end

    local ServerTimeNow = Workspace:GetServerTimeNow()
    local MoveParts, MoveFrames = p48.MoveParts, p48.MoveFrames
    local v76 = #p48.Flights
    local n1 = 0

    for i = v76, 1, -1 do
        local v77 = p48.Flights[i]
        local v78 = ServerTimeNow - v77.StartedAt

        if v77.Seconds <= v78 then
            v77.Root:Destroy()
            table.remove(p48.Flights, i)
        else
            local v79 = PumpkinBossState.Arc(v77.Origin, v77.Velocity, (math.max(v78, 0)))
            local v80 = v79 - v77.Last
            local v81 = if v80.Magnitude > 0.001 then CFrame.lookAt(v79, v79 + v80) else CFrame.new(v79)

            v77.Last = v79

            local v82 = n1

            for v83, v84 in v77.Parts do
                v82 += 1
                n1 = v82
                MoveParts[v82] = v84
                MoveFrames[v82] = v81 * v77.Offsets[v83]
            end
        end
    end

    if n1 > 0 then
        Workspace:BulkMoveTo(MoveParts, MoveFrames, Enum.BulkMoveMode.FireCFrameChanged)
    end

    table.clear(MoveParts)
    table.clear(MoveFrames)

    for v85, v86 in p48.Predicted do
        if v86 < elapsed then
            p48.Predicted[v85] = nil
        end
    end
end

return t2
