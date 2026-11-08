-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local PumpkinBossState = require(ReplicatedStorage.Shared.Util.PumpkinBossState)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Cannon = require(script.Cannon)
local Drops = require(script.Drops)
local HazardView = require(script.HazardView)
local HeadSwap = require(script.HeadSwap)
local Kit = require(script.Kit)
local Markers = require(script.Markers)
local MonsterDeath = require(script.Parent.MonsterDeath)
local Presentation = require(script.Presentation)
local Rigs = require(script.Rigs)
local Scenes = require(script.Scenes)
local Transition = require(script.Transition)
local Vfx = require(script.Vfx)
local ArenaName, Fx, Phases = PumpkinBossState.ArenaName, PumpkinBossState.Fx, PumpkinBossState.Phases
local v1 = table.freeze({
    BruteRise = true
})
local Attributes, ModelAttributes = PumpkinBossState.Attributes, PumpkinBossState.ModelAttributes
local v2 = CFrame.Angles(0, 3.141592653589793, 0)
local v3 = ("rbxassetid://%*"):format(PumpkinBossState.Clips.Brute.Walk.Id)
local t1 = {
    0.55, 1.35, 2.15, 2.95
}
local t2 = {
    King = {
        ShadowDash = "KingShadowDash",
        SummonMinions = "KingSummonMinions"
    }
}
local LocalPlayer = Players.LocalPlayer

local function vector(p1) -- line: 84
    return if typeof(p1) == "Vector3" then p1 else nil
end

local function number(p2) -- line: 88
    return if type(p2) == "number" then p2 else nil
end

local function bossRig(p3, p4) -- line: 92
    local Boss = p3.Boss

    return if Boss and Boss.Parent and Boss.Name == p4 then Boss else nil
end

local function rigScale(p5) -- line: 97
    if p5 then
        return (p5:GetScale())
    end

    return 1
end

local function rigRoot(p6) -- line: 101
    return if p6 then p6.PrimaryPart else nil
end

local function walkTrack(p7) -- line: 105
    -- upvalues: v3 (copy)
    local v4 = p7:FindFirstChildWhichIsA("Animator", true)

    if v4 ~= nil then
        for _, v5 in v4:GetPlayingAnimationTracks() do
            if v5.Animation and v5.Animation.AnimationId == v3 then
                return v5
            end
        end
    end

    return nil
end

local function crossed(p8, p9, p10) -- line: 120
    if p10 < p9 then
        if p9 < p8 then
            return true
        end

        return p8 <= p10
    end

    if p9 < p8 then
        return p8 <= p10
    end

    return false
end

local function alongFrame(p11, p12, p13) -- line: 129
    -- upvalues: Kit (copy)
    local v6 = Kit.Flat(p12)
    local v7 = if v6.Magnitude > 0.001 then v6.Unit else Vector3.new(1, 0, 0)

    return CFrame.fromMatrix(p11, v7, (Vector3.new(0, 1, 0))) * (p13 or CFrame.identity)
end

local function dashFx(p14, p15, p16, p17, p18, p19) -- line: 157
    -- upvalues: Debris (copy), RunService (copy), Kit (copy), Vfx (copy)
    local v8 = Kit.Flat(p17 - p16)
    local Magnitude = v8.Magnitude

    if Magnitude < 0.001 or p18 <= 0 then
        return
    end

    local Y = p16.Y
    local PrimaryPart, v9

    if p15 then
        v9 = p15:GetScale()
        PrimaryPart = p15.PrimaryPart
    else
        v9 = 1
    end

    local v10 = if PrimaryPart then PrimaryPart.Position.Y else 0
    local v11 = Vfx.Template(p14, { "PumpkinCharge", "Wind" })
    local v12 = if p19.Ride then Vfx.Template(p14, { "PumpkinCharge", "ChargeRun" }) else nil
    local v13 = p19.Linger or 0
    local v14 = p19.Width or 0
    local v15 = if p19.Strip and v13 > 0 and v14 > 0 then Vfx.Template(p14, {
        "PumpkinCharge",
        p19.Strip
    }) else nil
    local v16 = if v11 then v11.Position.Y * v9 else 0
    local WindTurn = p19.WindTurn
    local v17

    if v11 then
        local Place = Vfx.Place
        local v18 = p16 + Vector3.new(0, v16, 0)
        local v19 = Kit.Flat(v8)
        local v20 = if v19.Magnitude > 0.001 then v19.Unit else Vector3.new(1, 0, 0)

        v17 = Place(v11, CFrame.fromMatrix(v18, v20, (Vector3.new(0, 1, 0))) * (WindTurn or CFrame.identity), p19.WindScale or v9)
    end

    local v21

    if v17 then
        if p19.FitWind then
            for _, descendant in v17:GetDescendants() do
                if descendant:IsA("ParticleEmitter") then
                    local v22 = descendant.Speed.Max * descendant.Lifetime.Max
                    local v23 = if v22 > 0.001 then math.min(1, Magnitude / v22) else 1

                    descendant.Speed = NumberRange.new(descendant.Speed.Min * v23, descendant.Speed.Max * v23)
                end
            end
        end

        v21 = Vfx.Hold(v17)
    end

    local v25 = table.clone(p19.StripLook or {})

    if p19.StripAtRig and PrimaryPart then
        v25.Lift = v10 - Y
    end

    local v26

    if v15 then
        local Strip = Vfx.Strip
        local v27 = Kit.Flat(v8)
        local v28 = if v27.Magnitude > 0.001 then v27.Unit else Vector3.new(1, 0, 0)

        v26 = Strip(v15, CFrame.fromMatrix(p16, v28, (Vector3.new(0, 1, 0))) * CFrame.identity, v9, v25)
    end

    if v26 then
        v26:Span(p16, p16, v14)
    end

    local v29

    if v12 then
        local Place = Vfx.Place
        local v30 = Kit.Flat(v8)
        local v31 = if v30.Magnitude > 0.001 then v30.Unit else Vector3.new(1, 0, 0)

        v29 = Place(v12, CFrame.fromMatrix(p16, v31, (Vector3.new(0, 1, 0))) * CFrame.identity, v9, p19.RideParticles or 1)
    end

    local t3 = {}
    local t4 = {}

    if v29 then
        local v32 = Magnitude / p18

        for _, descendant in v29:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false
                t3[descendant] = descendant.Rate / v32
                t4[descendant] = 0
            end
        end
    end

    if v21 == nil and v29 == nil and v26 == nil then
        return
    end

    local elapsed = os.clock()
    local v33 = p16
    local connection

    connection = RunService.Heartbeat:Connect(function() -- line: 239
        -- upvalues: p16 (copy), p17 (copy), p18 (copy), p19 (copy), v8 (copy), Y (copy), PrimaryPart (ref), v13 (copy), v14 (copy), WindTurn (copy), v26 (ref), t3 (copy), t4 (copy), v29 (ref), elapsed (copy), v33 (ref), connection (ref), v16 (copy), v10 (copy), v21 (ref), Debris (copy), Kit (copy), Vfx (copy)
        local v35 = math.clamp((os.clock() - elapsed) / p18, 0, 1)
        local v36 = v35 < 1 and PrimaryPart ~= nil and PrimaryPart.Parent ~= nil
        local v37 = if v35 >= 1 then Vector3.new(p17.X, Y, p17.Z) elseif not PrimaryPart or not v36 then p16:Lerp(p17, 1 - (1 - v35) ^ 2) else Vector3.new(PrimaryPart.Position.X, Y, PrimaryPart.Position.Z)

        if v21 then
            local v40 = v37 + Vector3.new(0, v16 + (if PrimaryPart and v36 then PrimaryPart.Position.Y - v10 else 0), 0)
            local v41 = Kit.Flat(v8)
            local v42 = if v41.Magnitude > 0.001 then v41.Unit else Vector3.new(1, 0, 0)

            v21:Move(CFrame.fromMatrix(v40, v42, (Vector3.new(0, 1, 0))) * (WindTurn or CFrame.identity))
        end

        if v26 then
            v26:Span(p16, v37, v14)
        end

        if v29 then
            local v43 = Kit.Flat(v8)
            local v44 = if v43.Magnitude > 0.001 then v43.Unit else Vector3.new(1, 0, 0)

            v29.CFrame = CFrame.fromMatrix(v37, v44, (Vector3.new(0, 1, 0))) * CFrame.identity

            local Magnitude = Kit.Flat(v37 - v33).Magnitude

            for v45, v46 in t3 do
                local v47 = t4[v45] + Magnitude * v46
                local v48 = math.floor(v47)

                if v48 > 0 then
                    v45:Emit(v48)
                end

                t4[v45] = v47 - v48
            end
        end

        v33 = v37

        if not (v35 >= 1) then
            return
        end

        connection:Disconnect()

        if v21 then
            v21:Stop()
        end

        if v29 then
            local Settle = Vfx.Settle

            Debris:AddItem(v29, Settle(v29))
        end

        if not v26 then
            return
        end

        task.delay(math.max(v13 - (p19.StopLead or 0), 0), function() -- line: 277
            -- upvalues: v26 (ref)
            v26:Stop()
        end)
    end)
end

local function lockControls(p20) -- line: 285
    -- upvalues: LocalPlayer (copy)
    local PlayerScripts = LocalPlayer:FindFirstChildOfClass("PlayerScripts")
    local PlayerModule = PlayerScripts and PlayerScripts:FindFirstChild("PlayerModule")

    if PlayerModule == nil or not PlayerModule:IsA("ModuleScript") then
        return
    end

    local _require = require
    local ok, result = pcall(_require, PlayerModule)

    if ok and type(result) == "table" then
        local Controls = result:GetControls()

        if Controls ~= nil and Controls.controlsEnabled ~= false then
            Controls:Disable()

            local Character = LocalPlayer.Character
            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

            if Humanoid then
                Humanoid:Move((Vector3.new(0, 0, 0)))
                Humanoid.Jump = false
            end

            p20:Add(function() -- line: 307
                -- upvalues: Controls (copy)
                if Controls.controlsEnabled == false then
                    Controls:Enable()
                end
            end)
        end
    end
end

local function bindArena(p21, p22) -- line: 314
    -- upvalues: RunService (copy), Workspace (copy), PumpkinBossState (copy), Remotes (copy), Trove (copy), Cannon (copy), Drops (copy), HazardView (copy), HeadSwap (copy), Kit (copy), Markers (copy), MonsterDeath (copy), Presentation (copy), Rigs (copy), Scenes (copy), Vfx (copy), Fx (copy), Phases (copy), v1 (copy), Attributes (copy), ModelAttributes (copy), v2 (copy), t1 (copy), t2 (copy), LocalPlayer (copy), walkTrack (copy), dashFx (copy), lockControls (copy)
    local v50 = p21:Extend()

    v50:Connect(p22.AncestryChanged, function() -- line: 316
        -- upvalues: p21 (copy), p22 (copy), v50 (copy), Workspace (copy)
        if not p22:IsDescendantOf(Workspace) then
            p21:Remove(v50)
        end
    end)

    local v51 = p22:GetAttribute(Attributes.SkipCutscenes) == true
    local v52 = Presentation.new(v50, p22)
    local v53 = HazardView.new(v50, p22)
    local v54 = Rigs.new(v50, p22)
    local v55 = Cannon.new(v50, p22)

    Drops.new(v50)
    Markers.Start(v50)
    v50:Add(Scenes.StopAll)

    local function say(p23, p24, p25) -- line: 331
        -- upvalues: v52 (copy)
        v52:Say(p23, p24, p25)
    end

    local function bossSource(p26, p27) -- line: 335
        -- upvalues: v54 (copy)
        local Boss = v54.Boss

        if not Boss or not Boss.Parent or Boss.Name ~= p26 then
            Boss = nil
        end

        return (if Boss then Boss.PrimaryPart else nil) or p27
    end

    local v56, v57
    local n1 = 0

    v50:Connect(RunService.Heartbeat, function() -- line: 343
        -- upvalues: v54 (copy), v56 (ref), v57 (ref), n1 (ref), Workspace (copy), PumpkinBossState (copy), Kit (copy), ModelAttributes (copy), t1 (copy), t2 (copy), LocalPlayer (copy), walkTrack (copy)
        local Boss = v54.Boss

        if Boss == nil or Boss.Parent == nil then
            v56 = nil
            v57 = nil

            return
        end

        local v58 = LocalPlayer:GetAttribute(PumpkinBossState.MemberAttribute) == true
        local Attribute = Boss:GetAttribute(ModelAttributes.Anim)
        local Attribute2 = Boss:GetAttribute(ModelAttributes.AnimAt)
        local v59 = ("%*:%*@%*"):format(Boss.Name, Attribute, Attribute2)

        if v59 ~= v56 then
            v56 = v59
            v57 = nil

            local v60 = t2[Boss.Name]
            local v61 = if v60 and type(Attribute) == "string" then v60[Attribute] else nil

            if v58 and v61 and type(Attribute2) == "number" and Workspace:GetServerTimeNow() - Attribute2 < 0.5 then
                Kit.Sound(v61, if Boss then Boss.PrimaryPart else nil)
            end
        end

        if Boss.Name == "Brute" and Attribute == "Walk" then
            local v62 = v57

            if v62 == nil or not v62.IsPlaying then
                v57 = walkTrack(Boss)
                n1 = if v57 then v57.TimePosition else 0
            else
                local TimePosition = v62.TimePosition
                local v63 = n1

                n1 = TimePosition

                for _, v64 in t1 do
                    if v58 and (if TimePosition < v63 then v63 < v64 or v64 <= TimePosition else v63 < v64 and v64 <= TimePosition) then
                        Kit.Sound("BruteStep", if Boss then Boss.PrimaryPart else nil)

                        return
                    end
                end
            end
        end
    end)

    local n2 = (-1e999)
    local v65

    local function unlockScene() -- line: 395
        -- upvalues: v65 (ref)
        local v66 = v65

        v65 = nil

        if v66 then
            v66:Destroy()
        end
    end

    v50:Add(unlockScene)

    local function lockScene(p28, p29) -- line: 404
        -- upvalues: p22 (copy), v65 (ref), unlockScene (copy), PumpkinBossState (copy), Trove (copy), Attributes (copy), LocalPlayer (copy), lockControls (copy)
        local v67 = v65

        v65 = nil

        if v67 then
            v67:Destroy()
        end

        if p29 <= 0 then
            return
        end

        local v68 = Trove.new()

        v65 = v68
        v68:Add(task.delay(p29, unlockScene))
        v68:Connect(p22:GetAttributeChangedSignal(Attributes.Scene), function() -- line: 413
            -- upvalues: p28 (copy), p22 (copy), v65 (ref), Attributes (copy)
            if p22:GetAttribute(Attributes.Scene) == p28 then
                return
            end

            local v69 = v65

            v65 = nil

            if v69 then
                v69:Destroy()
            end
        end)
        v68:Connect(LocalPlayer:GetAttributeChangedSignal(PumpkinBossState.MemberAttribute), function() -- line: 420
            -- upvalues: v65 (ref), PumpkinBossState (copy), LocalPlayer (copy)
            if LocalPlayer:GetAttribute(PumpkinBossState.MemberAttribute) == true then
                return
            end

            local v70 = v65

            v65 = nil

            if v70 then
                v70:Destroy()
            end
        end)
        v68:Connect(LocalPlayer.CharacterAdded, unlockScene)

        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

        if Humanoid ~= nil and not (Humanoid.Health <= 0) then
            v68:Connect(Humanoid.Died, unlockScene)
            lockControls(v68)
        else
            local v71 = v65

            v65 = nil

            if v71 then
                v71:Destroy()
            end
        end
    end

    local v72

    local function playScene(p30, p31, p32) -- line: 438
        -- upvalues: p22 (copy), say (copy), lockScene (copy), v72 (ref), Workspace (copy), Scenes (copy), v1 (copy)
        local v73 = ("%*@%*"):format(p30, p32)

        if v73 == v72 then
            return
        end

        v72 = v73
        Scenes.Play(p30, p22, p31, p32, say)

        if v1[p30] then
            lockScene(p30, p31 - (Workspace:GetServerTimeNow() - p32))
        end
    end

    local function catchUp() -- line: 451
        -- upvalues: p22 (copy), say (copy), lockScene (copy), v72 (ref), v51 (copy), Workspace (copy), PumpkinBossState (copy), Scenes (copy), v1 (copy), Attributes (copy), LocalPlayer (copy)
        if not v51 and LocalPlayer:GetAttribute(PumpkinBossState.MemberAttribute) == true then
            local Attribute = p22:GetAttribute(Attributes.Scene)
            local Attribute2 = p22:GetAttribute(Attributes.SceneAt)
            local Attribute3 = p22:GetAttribute(Attributes.SceneEnds)

            if type(Attribute) ~= "string" or type(Attribute2) ~= "number" or type(Attribute3) ~= "number" or Attribute3 - Workspace:GetServerTimeNow() < 1 then
                return
            end

            local v74 = Attribute3 - Attribute2
            local v75 = ("%*@%*"):format(Attribute, Attribute2)

            if v75 ~= v72 then
                v72 = v75
                Scenes.Play(Attribute, p22, v74, Attribute2, say)

                if v1[Attribute] then
                    lockScene(Attribute, v74 - (Workspace:GetServerTimeNow() - Attribute2))
                end
            end
        end
    end

    v50:Connect(LocalPlayer:GetAttributeChangedSignal(PumpkinBossState.MemberAttribute), catchUp)

    local function minionAt(p33) -- line: 468
        -- upvalues: p22 (copy), PumpkinBossState (copy), MonsterDeath (copy)
        return MonsterDeath.NearestModel(p22:FindFirstChild(PumpkinBossState.MinionFolder), p33, 10)
    end

    v50:Connect(Remotes.PumpkinBoss.Hazard.OnClientEvent, function(p34) -- line: 476
        -- upvalues: v53 (copy), v54 (copy), n2 (ref), Kit (copy)
        local v76 = false
        local v77 = false
        local v78 = false
        local v79 = false
        local v80 = false

        if type(p34) == "table" then
            v76 = true
        else
            v80 = true
        end

        if v76 then
            if typeof(p34.Origin) == "Vector3" then
                v77 = true
            else
                v80 = true
            end
        end

        v76 = false

        if v77 then
            if type(p34.Id) == "number" then
                v76 = true
            else
                v80 = true
            end
        end

        v77 = false

        if v76 then
            v53:Add(p34)

            if p34.Kind == "Missile" then
                v77 = true
            else
                v80 = true
            end
        end

        v76 = false

        if v77 then
            if p34.Style == "Bomb" then
                v76 = true
            else
                v80 = true
            end
        end

        v77 = false

        local elapsed

        if v76 then
            elapsed = os.clock()

            if elapsed - n2 > 0.4 then
                v77 = true
            else
                v80 = false
            end
        end

        v76 = false

        local Boss

        if v77 then
            Boss = v54.Boss

            if Boss then
                v76 = true
            else
                v78 = true
            end
        end

        v77 = false

        if v76 then
            if Boss.Parent then
                v77 = true
            else
                v78 = true
            end
        end

        v76 = false

        if v77 then
            if Boss.Name == "Brute" then
                v76 = true
            else
                v78 = true
            end
        end

        v77 = false

        if v78 then
            v77 = true
        end

        v78 = false

        local Boss2

        if v76 then
            Boss2 = Boss
            v77 = true
        end

        v76 = false

        if v77 then
            if Boss2 then
                v78 = true
            else
                v76 = true
            end
        end

        v77 = false

        local Sound, Origin, Boss3

        if v76 then
            Sound = Kit.Sound
            Origin = p34.Origin
            Boss3 = v54.Boss

            if Boss3 then
                v77 = true
            else
                v79 = true
            end
        end

        v76 = false

        if v77 then
            if Boss3.Parent then
                v76 = true
            else
                v79 = true
            end
        end

        v77 = false

        if v76 then
            if Boss3.Name == "King" then
                v77 = true
            else
                v79 = true
            end
        end

        v76 = false

        if v79 then
            v76 = true
        end

        v79 = false

        local Boss4

        if v77 then
            Boss4 = Boss3
            v76 = true
        end

        v77 = false

        if v76 then
            if Boss4 then
                v79 = true
            else
                v77 = true
            end
        end

        v76 = false

        if v77 then
            v76 = true
        end

        v77 = false

        local PrimaryPart

        if v79 then
            PrimaryPart = Boss4.PrimaryPart
            v76 = true
        end

        v79 = false

        if v76 then
            v80 = false
            Sound("KingBarrageShoot", PrimaryPart or Origin)
        end

        v76 = false

        local Sound2

        if v78 then
            Sound2 = Kit.Sound

            if Boss2 then
                v79 = true
            else
                v76 = true
            end
        end

        v78 = false

        if v76 then
            v78 = true
        end

        v76 = false

        local PrimaryPart2

        if v79 then
            PrimaryPart2 = Boss2.PrimaryPart
            v78 = true
        end

        v79 = false

        local v81

        if v78 then
            if PrimaryPart2 then
                v81 = PrimaryPart2
                v76 = true
            else
                v79 = true
            end
        end

        v78 = false

        local From

        if v79 then
            From = p34.From

            if typeof(From) == "Vector3" then
                v77 = true
            else
                v78 = true
            end
        end

        if v78 then
            v81 = nil
            v76 = true
        end

        if v77 then
            v81 = From
            v76 = true
        end

        if v76 then
            v80 = false
            Sound2("BruteBombThrow", v81)
        end

        if not v80 then
            n2 = elapsed
        end
    end)

    local t5 = {
        [Fx.Callout] = function(p35) -- line: 499
            -- upvalues: v52 (copy)
            if type(p35.Text) ~= "string" then
                return
            end

            v52:Say(p35.Text, p35.Speaker, p35.Seconds or 2.5)
        end,
        [Fx.Scene] = function(p36) -- line: 504
            -- upvalues: p22 (copy), say (copy), lockScene (copy), v72 (ref), v51 (copy), Workspace (copy), Scenes (copy), v1 (copy)
            local Name = p36.Name
            local v83, v84

            if type(Name) ~= "string" or v51 then
                v84 = true
            else
                v83 = if type(p36.At) == "number" then p36.At else Workspace:GetServerTimeNow()
                v84 = false
            end

            if v84 or Workspace:GetServerTimeNow() - v83 > 1 then
                return
            end

            local Name2 = p36.Name
            local v85 = p36.Seconds or 2
            local v86 = ("%*@%*"):format(Name2, v83)

            if v86 ~= v72 then
                v72 = v86
                Scenes.Play(Name2, p22, v85, v83, say)

                if v1[Name2] then
                    lockScene(Name2, v85 - (Workspace:GetServerTimeNow() - v83))
                end
            end
        end,
        [Fx.BossHit] = function(p37) -- line: 516
            -- upvalues: v54 (copy), Kit (copy)
            Kit.Sound("Hit", nil, 0.5, p37.Stunned and 1.2 or 1)
            v54:Flash()
        end,
        [Fx.BossSpawn] = function(p38) -- line: 520
            -- upvalues: Kit (copy)
            local At = p38.At

            if typeof(At) ~= "Vector3" then
                At = nil
            end

            if At then
                Kit.ShakeFrom(At, 6, 250)
            end

            Kit.Sound("Roar", nil, 0.8)
        end,
        [Fx.Stomp] = function(p39) -- line: 527
            -- upvalues: v54 (copy), Kit (copy), Vfx (copy)
            local At = p39.At

            if typeof(At) ~= "Vector3" then
                At = nil
            end

            if not At then
                return
            end

            Kit.ShakeFrom(At, (p39.Radius or 0) > 150 and 8 or 4, 300)

            local v87 = p39.Kind == "Slam"

            Kit.Sound("BruteSlam", At, v87 and 1 or 0.75, v87 and 1 or 1.08)

            local v88 = Vfx.Template(Vfx.PhaseOne, { "PumpkinSlam", "PumpkinSlam" })

            if not v88 then
                return
            end

            local v89 = if p39.Kind == "Slam" then 1.4 else 1
            local Boss = v54.Boss

            if not Boss or not Boss.Parent or Boss.Name ~= "Brute" then
                Boss = nil
            end

            local v90 = (if Boss then Boss:GetScale() else 1) * v89

            Vfx.Emit(Vfx.Place(v88, CFrame.new(At) * v88.CFrame.Rotation, v90))
        end,
        [Fx.Swipe] = function(p40) -- line: 546
            -- upvalues: v54 (copy), Kit (copy), Vfx (copy)
            local Origin = p40.Origin

            if typeof(Origin) ~= "Vector3" then
                Origin = nil
            end

            if Origin == nil then
                return
            end

            local Sound = Kit.Sound
            local Boss = v54.Boss

            if not Boss or not Boss.Parent or Boss.Name ~= "Brute" then
                Boss = nil
            end

            Sound("BruteSwipe", (if Boss then Boss.PrimaryPart else nil) or Origin)

            local v91 = if p40.Side == "Left" then "BossSwipeLeft" else "BossSwipeRight"
            local v92 = Vfx.Template(Vfx.PhaseOne, { "PumpkinSwipe", v91 })
            local Flat = Kit.Flat
            local Direction = p40.Direction

            if typeof(Direction) ~= "Vector3" then
                Direction = nil
            end

            local v93 = Flat(Direction or Vector3.new(0, 0, 0))

            if not (v92 and v93.Magnitude > 0.001) then
                return
            end

            local Boss2 = v54.Boss

            if not Boss2 or not Boss2.Parent or Boss2.Name ~= "Brute" then
                Boss2 = nil
            end

            local v94 = if Boss2 then Boss2:GetScale() else 1
            local v95 = CFrame.lookAt(Origin, Origin + v93)

            Vfx.Emit(Vfx.Place(v92, v95 * CFrame.new(Vector3.new(0, 5.36, -4) * v94) * v92.CFrame.Rotation, v94))
        end,
        [Fx.Charge] = function(p41) -- line: 567
            -- upvalues: v54 (copy), Kit (copy), Vfx (copy), dashFx (copy)
            local From = p41.From

            if typeof(From) ~= "Vector3" then
                From = nil
            end

            local To = p41.To

            if typeof(To) ~= "Vector3" then
                To = nil
            end

            if From then
                Kit.ShakeFrom(From, 3, 200)
            end

            local Sound = Kit.Sound
            local Boss = v54.Boss

            if not Boss or not Boss.Parent or Boss.Name ~= "Brute" then
                Boss = nil
            end

            Sound("BruteCharge", (if Boss then Boss.PrimaryPart else nil) or From)

            if not (From and To) then
                return
            end

            local PhaseOne = Vfx.PhaseOne
            local Boss2 = v54.Boss

            if not Boss2 or not Boss2.Parent or Boss2.Name ~= "Brute" then
                Boss2 = nil
            end

            local v96 = p41.Seconds or 0.6
            local t6 = {
                Ride = true,
                Strip = "ChargeRun",
                WindScale = 1,
                RideParticles = Vfx.FireParticles
            }
            local Linger = p41.Linger

            t6.Linger = if type(Linger) ~= "number" then nil else Linger

            local Width = p41.Width

            t6.Width = if type(Width) ~= "number" then nil else Width
            t6.StripLook = {
                Particles = Vfx.FireParticles,
                Density = Vfx.FireDensity
            }
            dashFx(PhaseOne, Boss2, From, To, v96, t6)
        end,
        [Fx.BruteDown] = function(p42) -- line: 586
            -- upvalues: v54 (copy), Kit (copy)
            local At = p42.At

            if typeof(At) ~= "Vector3" then
                At = nil
            end

            if At then
                Kit.ShakeFrom(At, 7, 300)
            end

            local Sound = Kit.Sound

            if not At then
                local Boss = v54.Boss

                if not Boss or not Boss.Parent or Boss.Name ~= "Brute" then
                    Boss = nil
                end

                At = (if Boss then Boss.PrimaryPart else nil) or nil
            end

            Sound("BruteDeath", At)
        end,
        [Fx.BruteHead] = function(p43) -- line: 593
            -- upvalues: v54 (copy), Workspace (copy), HeadSwap (copy)
            local At = p43.At

            if typeof(At) ~= "Vector3" then
                At = nil
            end

            if not At then
                return
            end

            local Play = HeadSwap.Play
            local Boss = v54.Boss

            if not Boss or not Boss.Parent or Boss.Name ~= "Brute" then
                Boss = nil
            end

            local Facing = p43.Facing

            if typeof(Facing) ~= "Vector3" then
                Facing = nil
            end

            Play(Boss, At, Facing or Vector3.new(-0, -0, -1, -0), if type(p43.Drop) == "number" then p43.Drop else 0.8, if type(p43.Sit) == "number" then p43.Sit else 0, if type(p43.StartedAt) == "number" then p43.StartedAt else Workspace:GetServerTimeNow())
        end,
        [Fx.KingRise] = function(p44) -- line: 608
            -- upvalues: Kit (copy)
            local At = p44.At

            if typeof(At) ~= "Vector3" then
                At = nil
            end

            if At then
                Kit.ShakeFrom(At, 5, 300)
            end
        end,
        [Fx.ShadowDash] = function(p45) -- line: 614
            -- upvalues: v54 (copy), Kit (copy), Vfx (copy), v2 (copy), dashFx (copy)
            local From = p45.From

            if typeof(From) ~= "Vector3" then
                From = nil
            end

            local To = p45.To

            if typeof(To) ~= "Vector3" then
                To = nil
            end

            local Sound = Kit.Sound
            local Boss = v54.Boss

            if not Boss or not Boss.Parent or Boss.Name ~= "King" then
                Boss = nil
            end

            Sound("KingDash", (if Boss then Boss.PrimaryPart else nil) or From)

            if not (From and To) then
                return
            end

            local Boss2 = v54.Boss

            if not Boss2 or not Boss2.Parent or Boss2.Name ~= "King" then
                Boss2 = nil
            end

            local PhaseTwo = Vfx.PhaseTwo
            local v100 = p45.Seconds or 0.45
            local t7 = {
                Strip = "Toxic",
                StopLead = 3,
                StripAtRig = true,
                WindScale = 1,
                FitWind = true
            }
            local Linger = p45.Linger

            t7.Linger = if type(Linger) ~= "number" then nil else Linger

            local Width = p45.Width

            t7.Width = if type(Width) ~= "number" then nil else Width
            t7.StripLook = {
                Density = 6,
                Particles = if Boss2 then Boss2:GetScale() else 1
            }
            t7.WindTurn = v2
            dashFx(PhaseTwo, Boss2, From, To, v100, t7)
        end,
        [Fx.VineTrap] = function(p46) -- line: 633
            -- upvalues: v52 (copy), Kit (copy), LocalPlayer (copy)
            if p46.UserId == LocalPlayer.UserId then
                v52:FlashScreen(Kit.Red, 0.55, 0.4)
                Kit.Shake(3, 14, 0.4)
            end
        end,
        [Fx.VineHit] = function(_) -- line: 639
            -- upvalues: Kit (copy)
            Kit.Sound("Hit", nil, 0.35, 1.3)
        end,
        [Fx.VineBreak] = function(p48) -- line: 642
            -- upvalues: Kit (copy)
            local At = p48.At

            if typeof(At) ~= "Vector3" then
                At = nil
            end

            if At then
                Kit.Burst(At, 8, Kit.Green, 0.35)
            end
        end,
        [Fx.MinionSpawn] = function(p49) -- line: 648
            -- upvalues: Kit (copy)
            local At = p49.At

            if typeof(At) ~= "Vector3" then
                At = nil
            end

            if At then
                Kit.Burst(At, 6, Kit.Orange, 0.35)
            end
        end,
        [Fx.MinionHit] = function(_) -- line: 654
            -- upvalues: Kit (copy)
            Kit.Sound("Hit", nil, 0.35, 1.4)
        end,
        [Fx.MinionPop] = function(p51) -- line: 657
            -- upvalues: minionAt (copy), Kit (copy), MonsterDeath (copy)
            local At = p51.At

            if typeof(At) ~= "Vector3" then
                At = nil
            end

            if At ~= nil then
                if p51.Despawn == true then
                    Kit.Burst(At, 4, Kit.Orange, 0.3)
                else
                    MonsterDeath.Play(At, 1, minionAt(At))
                end
            end
        end,
        [Fx.MinionBoom] = function(p52) -- line: 669
            -- upvalues: Kit (copy), Vfx (copy)
            local At = p52.At

            if typeof(At) ~= "Vector3" then
                At = nil
            end

            if not At then
                return
            end

            if not Vfx.Play(Vfx.PhaseTwo, { "HeadExplode" }, CFrame.new(At), 0.5) then
                local v101 = if type(p52.Radius) == "number" then p52.Radius else 14

                Kit.Burst(At, v101, Kit.Orange, 0.45)
                Kit.Burst(At, v101 * 0.5, Color3.new(1, 1, 1), 0.2)
            end

            Kit.ShakeFrom(At, 4, 80)
            Kit.Sound("Explosion", At, 0.7)
        end,
        [Fx.MinionArm] = function(_) -- line: 683
        end,
        [Fx.ShieldUp] = function(_) -- line: 684
            -- upvalues: v52 (copy), v54 (copy), Kit (copy)
            local Sound = Kit.Sound
            local Boss = v54.Boss

            if not Boss or not Boss.Parent or Boss.Name ~= "King" then
                Boss = nil
            end

            Sound("KingShieldCast", (if Boss then Boss.PrimaryPart else nil) or nil)
            v52:FlashScreen(Kit.Purple, 0.6, 0.6)
        end,
        [Fx.ShieldHit] = function(_) -- line: 688
            -- upvalues: Kit (copy)
            Kit.Sound("Hit", nil, 0.5, 0.8)
        end,
        [Fx.ShieldBreak] = function(p56) -- line: 691
            -- upvalues: v52 (copy), v54 (copy), Kit (copy), Vfx (copy)
            local At = p56.At

            if typeof(At) ~= "Vector3" then
                At = nil
            end

            if At then
                local v102 = v54:ShieldSize()
                local v103 = if v102 then v102 / 15 else 1

                Vfx.Play(Vfx.PhaseTwo, { "Shield", "ShieldBreak" }, CFrame.new(At), v103)
                Kit.ShakeFrom(At, 6, 300)
            end

            local Sound = Kit.Sound

            if not At then
                local Boss = v54.Boss

                if not Boss or not Boss.Parent or Boss.Name ~= "King" then
                    Boss = nil
                end

                At = (if Boss then Boss.PrimaryPart else nil) or nil
            end

            Sound("KingShieldBreak", At)
            v52:FlashScreen(Color3.new(1, 1, 1), 0.4, 0.5)
        end,
        [Fx.RootHit] = function(p57) -- line: 702
            -- upvalues: p22 (copy), v54 (copy), v55 (copy), PumpkinBossState (copy), Kit (copy)
            Kit.Sound("Hit", nil, 0.35, 1.1)

            local v104 = p22:FindFirstChild(PumpkinBossState.CannonFolder)
            local v105 = v104 == nil
            local v106 = if not v105 then type(p57.CannonId) == "number" else nil

            if not v105 and v106 then
                for _, child in v104:GetChildren() do
                    if child:IsA("Model") and child:GetAttribute(PumpkinBossState.CannonAttributes.CannonId) == p57.CannonId then
                        v54:FlashCannon(child)

                        local At = p57.At

                        if typeof(At) ~= "Vector3" then
                            At = nil
                        end

                        v55:Jolt(child, At)

                        return
                    end
                end
            end
        end,
        [Fx.RootBreak] = function(p58) -- line: 720
            -- upvalues: Kit (copy)
            local At = p58.At

            if typeof(At) ~= "Vector3" then
                At = nil
            end

            if At then
                Kit.Burst(At, 10, Kit.Green, 0.4)
            end
        end,
        [Fx.CannonShot] = function(p59) -- line: 726
            -- upvalues: v55 (copy)
            v55:OnShot(p59)
        end,
        [Fx.CannonImpact] = function(p60) -- line: 729
            -- upvalues: p22 (copy), v54 (copy), Kit (copy), Vfx (copy), Phases (copy), Attributes (copy)
            local At = p60.At

            if typeof(At) ~= "Vector3" then
                At = nil
            end

            if not At then
                return
            end

            Vfx.Play(Vfx.PhaseTwo, { "Cannon", "CannonballImpact" }, CFrame.new(At))
            Kit.Sound("Explosion", At, 0.5)

            local Attribute = p22:GetAttribute(Attributes.Phase)

            if Attribute ~= Phases.Stunned and Attribute ~= Phases.Shield then
                Kit.ShakeFrom(At, 2, 200)

                return
            end

            local Boss = v54.Boss

            Boss = Boss and Boss.PrimaryPart

            local v107 = if Boss then Boss.Position - At else nil

            if Attribute ~= Phases.Shield or p22:GetAttribute(Attributes.ShieldActive) ~= true then
                v54:Flash(v107, 2.2)
            else
                v54:FlashShield(v107, 2.2)
            end

            Kit.ShakeFrom(At, 3.5, 260)
            Kit.Sound("Hit", At, 0.6, Attribute == Phases.Stunned and 1.2 or 0.9)
        end,
        [Fx.Stun] = function(p61) -- line: 754
            -- upvalues: v52 (copy), v54 (copy), Kit (copy)
            local Sound = Kit.Sound
            local Boss = v54.Boss

            if not Boss or not Boss.Parent or Boss.Name ~= "King" then
                Boss = nil
            end

            Sound("KingStun", (if Boss then Boss.PrimaryPart else nil) or nil)
            v52:Say(("The King is STUNNED for %*s! Keep shooting at him!"):format(p61.Seconds or 7), nil, 2.5)
        end,
        [Fx.Defeated] = function(p62) -- line: 758
            -- upvalues: v54 (copy), Kit (copy), Vfx (copy)
            local At = p62.At

            if typeof(At) ~= "Vector3" then
                At = nil
            end

            if p62.Stage ~= nil then
                if p62.Stage == "Landed" and At then
                    local Boss = v54.Boss

                    if not Boss or not Boss.Parent or Boss.Name ~= "King" then
                        Boss = nil
                    end

                    local BodyHeight = Boss and Boss:GetAttribute("BodyHeight")
                    local v109 = if type(BodyHeight) == "number" then At + Vector3.new(0, BodyHeight * 0.2, 0) else At

                    Kit.Poof(At, 3)
                    Vfx.Play(Vfx.PhaseTwo, { "DieFinal" }, CFrame.new(v109))
                    Kit.ShakeFrom(At, 10, 400)
                end
            else
                local Sound = Kit.Sound

                if not At then
                    local Boss = v54.Boss

                    if not Boss or not Boss.Parent or Boss.Name ~= "King" then
                        Boss = nil
                    end

                    At = (if Boss then Boss.PrimaryPart else nil) or nil
                end

                Sound("KingDeath", At)
            end
        end,
        [Fx.Currency] = function(p63) -- line: 778
            -- upvalues: Drops (copy)
            if type(p63.Amount) == "number" and p63.Amount > 0 then
                Drops.ShowCurrency(p63.Amount)
            end
        end
    }

    v50:Connect(Remotes.PumpkinBoss.Fx.OnClientEvent, function(p64, p65) -- line: 785
        -- upvalues: t5 (copy)
        local v111 = t5[p64]

        if not v111 then
            return
        end

        local v112 = if type(p65) == "table" then p65 else {}
        local ok, result = pcall(v111, v112)

        if not ok then
            warn((("[PumpkinBoss] fx %* failed: %*"):format(p64, result)))
        end
    end)
    catchUp()
end

local t9 = {
    Start = function(p66) -- Start | line: 800
        -- upvalues: Workspace (copy), Scenes (copy), ArenaName (copy), bindArena (copy)
        local v113 = Workspace:FindFirstChild(ArenaName)

        if v113 and v113:IsA("Model") then
            task.defer(bindArena, p66, v113)
        end

        p66:Connect(Workspace.ChildAdded, function(p67) -- line: 806
            -- upvalues: p66 (copy), ArenaName (copy), bindArena (copy)
            if p67.Name == ArenaName and p67:IsA("Model") then
                task.defer(bindArena, p66, p67)
            end
        end)
        p66:Add(Scenes.StopAll)
    end
}

Transition.Listen()

return t9
