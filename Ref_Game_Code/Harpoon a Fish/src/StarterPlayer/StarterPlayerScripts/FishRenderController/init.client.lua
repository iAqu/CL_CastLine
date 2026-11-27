-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local SwimScale = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("SwimScale"))
local t1 = {}
local t2 = {}
local t3 = {}

local function attr(p1, p2) -- line: 28
    -- upvalues: t2 (copy), t3 (copy)
    local v1 = t3[p1]
    local v2 = v1

    if not v1 then
        if not p1:IsDescendantOf(game) then
            return p1:GetAttribute(p2)
        end

        v2 = {
            values = {}
        }

        local connection = p1.AttributeChanged:Connect(function(p3) -- line: 33
            -- upvalues: v2 (ref)
            v2.values[p3] = nil
        end)
        local v3 = v2

        v3.changed = connection
        v3.moved = p1.AncestryChanged:Connect(function() -- line: 34
            -- upvalues: p1 (copy), v2 (ref), t3 (copy)
            if p1:IsDescendantOf(game) then
                return
            end

            v2.changed:Disconnect()
            v2.moved:Disconnect()

            if t3[p1] == v2 then
                t3[p1] = nil
            end
        end)
        t3[p1] = v2
    end

    local v4 = v2.values[p2]

    if v4 == nil then
        local Attribute = p1:GetAttribute(p2)

        if Attribute ~= nil then
            v2.values[p2] = Attribute
        else
            v2.values[p2] = t2
        end

        return Attribute
    end

    return if v4 ~= t2 then v4 else nil
end

local function fightHooked(p4) -- line: 56
    -- upvalues: attr (copy)
    return attr(p4, "Hooked") and not attr(p4, "Landing") and not attr(p4, "Jackpot")
end

local Drivers = script:WaitForChild("Drivers")
local FishMotionConfig = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("FishMotionConfig"))
local t4 = {
    fightHooked = fightHooked,
    SwimScale = SwimScale,
    attr = attr,
    renderLag = FishMotionConfig.renderLag,
    bodyLag = FishMotionConfig.bodyLag
}

for _, v5 in ipairs({
        "Octopus",
        "WhaleSwim",
        "TurtleFly",
        "SquidJet",
        "JellyPulse",
        "OctoCrawl",
        "Flail",
        "FishWave",
        "SharkSwim",
        "RayFlap",
        "LionFan",
        "EelDart",
        "AnglerSwim",
        "MarlinSwim",
        "NessieSwim",
        "VeilSwim",
        "LanternSwim",
        "SpikeSwim",
        "ClownSwim",
        "WhiskerSwim",
        "Crawl",
        "ScorpCrawl",
        "EelSwim",
        "StrokeClock",
        "CrabPaddle",
        "LobsterFlip",
        "PrawnSwim",
        "SeahorseSwim",
        "ZapSwim",
        "GlowSwim",
        "AngelGlide",
        "FlameFlick",
        "LeafDrift",
        "RockFan",
        "RibbonFin",
        "JawStrike",
        "WingGlide",
        "SailFlag",
        "AnglerGulp",
        "RattailSwim",
        "PerchScan",
        "GoldPeck",
        "LureSweep",
        "ClapGlide",
        "WyrmDart",
        "HoverSway",
        "Deepstalker",
        "BoneWhale",
        "SeahorseFan",
        "PufferSwim",
        "CetaceanSwim",
        "WalrusSwim",
        "PlesioFly",
        "MawSnap",
        "HydraSwim",
        "Nightcrawl",
        "ChubbyWobble",
        "PaddleSwim",
        "SharkSail",
        "JesterSwim",
        "WraithSwim",
        "VikingSwim",
        "FrogKick",
        "LobeSwim",
        "PlatypusRow",
        "LimbSwim",
        "WormSwim",
        "BichirSwim",
        "TherizSwim",
        "PachySwim",
        "ThalSwim",
        "PteroSwim",
        "MegaSwim",
        "DeinoSwim",
        "CameroJet",
        "ParaSwim",
        "PelaSwim",
        "MastSwim",
        "CarnoSwim",
        "DimetSwim",
        "TrikeSwim",
        "TyloSwim",
        "BoneSwim",
        "MawSwim",
        "AnkyloSwim",
        "ArgentoSwim",
        "RexSwim",
        "ChicxSwim",
        "FlatGlide",
        "PlacoSwim",
        "ChainPulse",
        "GraspSwim",
        "StiltStrike",
        "MakaraSwim",
        "BroodSwim",
        "TarWobble",
        "MothClap",
        "BloopPulse",
        "NingenCrawl",
        "TRexCrocSwim"
    }) do
    require(Drivers:WaitForChild(v5))(t1, t4)
end

local MutationDisplay = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("MutationDisplay"))
local t5 = {}
local t6 = {}
local t7 = {
    Y = 200,
    HYST = 10,
    FLOOR = -300,
    harpoon = false,
    fish = {}
}
local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")

Remotes:WaitForChild("HarpoonEnter").OnClientEvent:Connect(function() -- line: 152
    -- upvalues: t7 (copy)
    t7.harpoon = true
end)
Remotes:WaitForChild("HarpoonExit").OnClientEvent:Connect(function() -- line: 153
    -- upvalues: t7 (copy)
    t7.harpoon = false
end)

local Tint = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("MutationLook")).Tint

local function applyMutationLook(p5) -- line: 162
    -- upvalues: MutationDisplay (copy), t5 (copy), t6 (copy), Tint (copy)
    if t5[p5] then
        return
    end

    local Mutation = p5:GetAttribute("Mutation")
    local v6 = Mutation and MutationDisplay[Mutation]
    local v7 = p5.PrimaryPart or p5:FindFirstChildWhichIsA("BasePart")

    if not v6 then
        Mutation = p5:GetAttribute("SpeciesAura")
    end

    if not (Mutation and v7) then
        return
    end

    if v6 then
        Tint(v7, v6)
    end

    local v8 = t6[p5]

    if v6 and v8 and v8.proxyMesh.Parent then
        Tint(v8.proxyMesh, v6)
    end

    local Part = Instance.new("Part")

    Part.Name = "MutationAura"
    Part.Size = v7.Size
    Part.CFrame = v7.CFrame
    Part.Anchored = true
    Part.Transparency = 1
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Parent = workspace.CurrentCamera

    local t8 = {}
    local t9 = {}
    local v9 = game:GetService("ReplicatedStorage").VFX.MutationAura:FindFirstChild(Mutation)

    if v9 then
        for _, child in ipairs(v9:GetChildren()) do
            local clone = child:Clone()

            clone.Parent = Part

            local function adoptPart(p6) -- line: 192
                -- upvalues: t8 (copy)
                p6.Anchored = true
                p6.CanCollide = false
                p6.CanQuery = false
                p6.CanTouch = false
                p6.CastShadow = false

                local AuraOffset = p6:GetAttribute("AuraOffset")

                t8[#t8 + 1] = {
                    part = p6,
                    off = if typeof(AuraOffset) ~= "CFrame" or not AuraOffset then CFrame.identity else AuraOffset
                }
            end

            if clone:IsA("BasePart") then
                adoptPart(clone)
            end

            if clone:IsA("ParticleEmitter") then
                t9[#t9 + 1] = clone
            end

            for _, descendant in ipairs(clone:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    adoptPart(descendant)
                elseif descendant:IsA("ParticleEmitter") then
                    t9[#t9 + 1] = descendant
                end
            end
        end
    end

    t5[p5] = {
        culled = false,
        lastCull = 0,
        mesh = v7,
        carrier = Part,
        parts = t8,
        emitters = t9,
        cycle = v6 and v6.cycle
    }
end

local function endLook(p7) -- line: 212
    -- upvalues: t5 (copy)
    local v11 = t5[p7]

    if v11 then
        t5[p7] = nil
        v11.carrier:Destroy()
    end
end

local t12 = {
    WIDTH = 0.18,
    MAX = 0.9,
    MIN = 0.8,
    LIFT = 0.75,
    CULL = 200,
    POTATO = 80,
    template = game:GetService("ReplicatedStorage"):WaitForChild("AdminProps"):WaitForChild("Crown"),
    hat = game:GetService("ReplicatedStorage"):WaitForChild("HalloweenProps"):WaitForChild("WitchHat"),
    turkey = game:GetService("ReplicatedStorage"):WaitForChild("ThanksgivingProps"):WaitForChild("TurkeyHat"),
    BONES = { "Head", "Neck", "Spine_01" },
    list = {},
    parts = {},
    cfs = {}
}

function t12.fit(p8) -- line: 244
    -- upvalues: t12 (copy)
    local Size = p8.mesh.Size
    local nose, up = p8.nose, p8.up
    local v14 = math.abs(nose.X) * Size.X + math.abs(nose.Y) * Size.Y + math.abs(nose.Z) * Size.Z
    local v17 = math.abs(up.X) * Size.X + math.abs(up.Y) * Size.Y + math.abs(up.Z) * Size.Z
    local v21 = math.max(t12.MIN, (math.min(v14 * t12.WIDTH, v17 * t12.MAX)))

    p8.part.Size = p8.template.Size * (v21 / p8.template.Size.X)
    p8.len = v14
    p8.meshSize = Size

    local v22 = p8.up * (p8.part.Size.Y * 0.5)

    p8.offLocal = p8.baked and p8.baked * Size + v22 or p8.up * (v17 * 0.5 * t12.LIFT) + v22
end

function t12.apply(p9) -- line: 255
    -- upvalues: t12 (copy)
    local v23 = p9:GetAttribute("Crowned") == true
    local v24 = p9:GetAttribute("WitchHat") or false
    local Cap = p9:GetAttribute("Cap")
    local HatProps = game:GetService("ReplicatedStorage"):FindFirstChild("HatProps")
    local v25, v26

    if v23 or v24 then
        v26 = false
    elseif type(Cap) == "string" and HatProps then
        local v27 = HatProps:FindFirstChild(Cap)

        if v27 then
            v25 = v27
            v26 = true
        else
            v26 = false
        end
    else
        v26 = false
    end

    if not v26 then
        v25 = nil
    end

    if t12.list[p9] or not v23 and not v24 and not v25 then
        return
    end

    local v28 = p9.PrimaryPart or p9:FindFirstChildWhichIsA("MeshPart", true)

    if not v28 then
        return
    end

    local AnatomyInverse = p9:GetAttribute("AnatomyInverse")
    local v29 = p9:GetPivot() * (typeof(AnatomyInverse) == "CFrame" and AnatomyInverse or CFrame.identity):Inverse()
    local CrownOff = p9:GetAttribute("CrownOff")
    local CrownBone = p9:GetAttribute("CrownBone")
    local _ipairs = ipairs
    local v30, v31

    if typeof(CrownOff) == "Vector3" and type(CrownBone) == "string" then
        local t13 = {
            CrownBone
        }

        if t13 then
            v30 = t13
            v31 = true
        else
            v31 = false
        end
    else
        v31 = false
    end

    if not v31 then
        v30 = t12.BONES
    end

    local v32

    for _, v33 in _ipairs(v30) do
        local v34 = v28:FindFirstChild(v33, true)

        if not v32 and v34 and v34:IsA("Bone") then
            v32 = v34
        end
    end

    local v35, v36

    if v23 then
        local template = t12.template

        if template then
            v35 = template
            v36 = true
        elseif v24 then
            if v24 == "Turkey" then
                local turkey = t12.turkey

                if turkey then
                    v35 = turkey
                    v36 = true
                else
                    local hat = t12.hat

                    if hat then
                        v35 = hat
                        v36 = true
                    else
                        v36 = false
                    end
                end
            else
                local hat = t12.hat

                if hat then
                    v35 = hat
                    v36 = true
                else
                    v36 = false
                end
            end
        else
            v36 = false
        end
    elseif v24 then
        if v24 == "Turkey" then
            local turkey = t12.turkey

            if turkey then
                v35 = turkey
                v36 = true
            else
                local hat = t12.hat

                if hat then
                    v35 = hat
                    v36 = true
                else
                    v36 = false
                end
            end
        else
            local hat = t12.hat

            if hat then
                v35 = hat
                v36 = true
            else
                v36 = false
            end
        end
    else
        v36 = false
    end

    if not v36 then
        v35 = v25
    end

    local clone = v35:Clone()

    if v23 then
        clone.Name = "AdminCrown"
    elseif v24 then
        if v24 == "Turkey" then
            clone.Name = "TurkeyHat"
        else
            clone.Name = "WitchHat"
        end
    else
        clone.Name = "BlackMarketHat"
    end

    local t14 = {
        shown = false,
        culled = true,
        lastCull = -1,
        mesh = v28,
        part = clone,
        template = v35,
        bone = v32
    }
    local CrownOff2, v37

    if typeof(CrownOff) ~= "Vector3" or v32 == nil then
        v37 = false
    elseif CrownOff then
        CrownOff2 = CrownOff
        v37 = true
    else
        v37 = false
    end

    t14.baked = if not v37 then nil else CrownOff2
    t14.nose = v28.CFrame:VectorToObjectSpace(v29.RightVector)
    t14.up = v28.CFrame:VectorToObjectSpace(v29.UpVector)
    t12.fit(t14)
    t12.list[p9] = t14
end

function t12.drop(p10) -- line: 285
    -- upvalues: t12 (copy)
    local v38 = t12.list[p10]

    if v38 then
        t12.list[p10] = nil
        v38.part:Destroy()
    end
end

local function popCurve(p11) -- line: 309
    if p11 < 0.12 then
        return 1 + 0.3999999999999999 * (1 - (1 - p11 / 0.12) ^ 3)
    end

    return if p11 < 0.67 then (math.cos((p11 - 0.12) / 0.55 * 3.141592653589793) * 0.5 + 0.5) * 0.3999999999999999 + 1 else nil
end

local function endPop(p12) -- line: 320
    -- upvalues: t6 (copy)
    local v40 = t6[p12]

    if not v40 then
        return
    end

    t6[p12] = nil
    v40.proxy:Destroy()

    if v40.mesh.Parent then
        v40.mesh.LocalTransparencyModifier = 0
    end
end

local function cloneProxy(p13, p14, p15) -- line: 330
    local clone = p14:Clone()
    local Descendants = p14:GetDescendants()
    local Descendants2 = clone:GetDescendants()
    local t15 = {}

    for v41, v42 in ipairs(Descendants) do
        if v42:IsA("Bone") then
            t15[#t15 + 1] = {
                v42,
                Descendants2[v41]
            }
        end
    end

    for _, child in ipairs(clone:GetChildren()) do
        if child.ClassName == "Attachment" or child:IsA("Constraint") then
            child:Destroy()
        end
    end

    clone.Anchored = true
    clone.CanCollide = false
    clone.CanQuery = false
    clone.CanTouch = false
    clone.PivotOffset = CFrame.identity

    local Model = Instance.new("Model")

    Model.Name = p13.Name .. p15
    clone.Parent = Model
    Model.PrimaryPart = clone
    Model.Parent = workspace.CurrentCamera

    return Model, clone, t15
end

local t16 = {}

local function startPop(p16) -- line: 357
    -- upvalues: t6 (copy), t7 (copy), cloneProxy (copy), t16 (copy)
    if t7.fish[p16] then
        return
    end

    local elapsed = os.clock()

    if not ((t16[p16] or -1) > elapsed - 0.25) then
        t16[p16] = elapsed

        local v43 = t6[p16]

        if v43 then
            v43.t = 0
        else
            local v44 = p16.PrimaryPart or p16:FindFirstChildWhichIsA("MeshPart")

            if v44 then
                local _Pop, _Pop2, _Pop3 = cloneProxy(p16, v44, "_Pop")

                v44.LocalTransparencyModifier = 1
                t6[p16] = {
                    t = 0,
                    mesh = v44,
                    proxy = _Pop,
                    proxyMesh = _Pop2,
                    bonePairs = _Pop3
                }
            end
        end
    end
end

local UserId = game:GetService("Players").LocalPlayer.UserId
local VFXBurst = require(game:GetService("ReplicatedStorage").Modules:WaitForChild("VFXBurst"))
local Splash = game:GetService("ReplicatedStorage").VFX:WaitForChild("Splash")
local WaterBoom = game:GetService("ReplicatedStorage").VFX:WaitForChild("WaterBoom")
local FeedBurst = game:GetService("ReplicatedStorage").VFX:WaitForChild("FeedBurst")
local GrowBurst = game:GetService("ReplicatedStorage").VFX:WaitForChild("GrowBurst")
local t17 = {
    {
        upTo = 0.34,
        id = "rbxassetid://126105529228330"
    },
    {
        upTo = 0.67,
        id = "rbxassetid://87702599635040"
    },
    {
        upTo = 1.01,
        id = "rbxassetid://83673781452193"
    }
}
local t18 = {
    {
        upTo = 0.34,
        id = "rbxassetid://124413188007145"
    },
    {
        upTo = 0.67,
        id = "rbxassetid://9114124038"
    },
    {
        upTo = 1.01,
        id = "rbxassetid://82052646932617"
    }
}
local t19 = {
    0.9, 1.1
}
local t20 = {
    1.1, 0.8
}
local t21 = {
    0.6, 1.3
}
local t22 = {
    0.55, 1.2
}
local SoundService = game:GetService("SoundService")
local TankWater = SoundService:FindFirstChild("TankWater")

if not TankWater then
    TankWater = Instance.new("SoundGroup")
    TankWater.Name = "TankWater"
    TankWater.Volume = 1
    TankWater.Parent = SoundService
end

local LocalPlayer = game:GetService("Players").LocalPlayer

RunService.RenderStepped:Connect(function(p17) -- line: 471
    -- upvalues: TankWater (ref), LocalPlayer (copy)
    local CurrentCamera = workspace.CurrentCamera

    if not CurrentCamera then
        return
    end

    local v46 = math.clamp((CurrentCamera.CFrame.Position.Y - -13) / 14, 0, 1)

    if LocalPlayer:GetAttribute("SetAquariumSounds") == false then
        v46 = 0
    end

    local TankWater2 = TankWater

    TankWater2.Volume = TankWater2.Volume + (v46 - TankWater.Volume) * math.min(1, p17 * 5)
end)

local t23 = {}

local function soundTemplate(p18) -- line: 481
    -- upvalues: TankWater (ref), t23 (copy)
    local v49 = t23[p18]

    if not v49 then
        v49 = Instance.new("Sound")
        v49.SoundId = p18
        v49.Volume = 0.55
        v49.SoundGroup = TankWater
        v49.RollOffMode = Enum.RollOffMode.Linear
        v49.RollOffMinDistance = 60
        v49.RollOffMaxDistance = 400
        v49.Parent = script
        t23[p18] = v49
    end

    return v49
end

local Sound

if not t23["rbxassetid://126105529228330"] then
    Sound = Instance.new("Sound")
    Sound.SoundId = "rbxassetid://126105529228330"
    Sound.Volume = 0.55
    Sound.SoundGroup = TankWater
    Sound.RollOffMode = Enum.RollOffMode.Linear
    Sound.RollOffMinDistance = 60
    Sound.RollOffMaxDistance = 400
    Sound.Parent = script
    t23["rbxassetid://126105529228330"] = Sound
end

local id, Sound2

for _, v50 in ipairs(t17) do
    id = v50.id

    if not t23[id] then
        Sound2 = Instance.new("Sound")
        Sound2.SoundId = id
        Sound2.Volume = 0.55
        Sound2.SoundGroup = TankWater
        Sound2.RollOffMode = Enum.RollOffMode.Linear
        Sound2.RollOffMinDistance = 60
        Sound2.RollOffMaxDistance = 400
        Sound2.Parent = script
        t23[id] = Sound2
    end
end

for _, v51 in ipairs(t18) do
    id = v51.id

    if not t23[id] then
        Sound2 = Instance.new("Sound")
        Sound2.SoundId = id
        Sound2.Volume = 0.55
        Sound2.SoundGroup = TankWater
        Sound2.RollOffMode = Enum.RollOffMode.Linear
        Sound2.RollOffMinDistance = 60
        Sound2.RollOffMaxDistance = 400
        Sound2.Parent = script
        t23[id] = Sound2
    end
end

if not t23["rbxassetid://129840040992692"] then
    Sound = Instance.new("Sound")
    Sound.SoundId = "rbxassetid://129840040992692"
    Sound.Volume = 0.55
    Sound.SoundGroup = TankWater
    Sound.RollOffMode = Enum.RollOffMode.Linear
    Sound.RollOffMinDistance = 60
    Sound.RollOffMaxDistance = 400
    Sound.Parent = script
    t23["rbxassetid://129840040992692"] = Sound
end

if not t23["rbxassetid://2789427964"] then
    Sound = Instance.new("Sound")
    Sound.SoundId = "rbxassetid://2789427964"
    Sound.Volume = 0.55
    Sound.SoundGroup = TankWater
    Sound.RollOffMode = Enum.RollOffMode.Linear
    Sound.RollOffMinDistance = 60
    Sound.RollOffMaxDistance = 400
    Sound.Parent = script
    t23["rbxassetid://2789427964"] = Sound
end

local function isMine(p19) -- line: 501
    -- upvalues: UserId (copy)
    return p19:GetAttribute("PenOwner") == UserId
end

local LocalPlayer2 = game:GetService("Players").LocalPlayer

local function hideOthers() -- line: 510
    -- upvalues: LocalPlayer2 (copy)
    if LocalPlayer2:GetAttribute("SetOtherAquariums") == false then
        return true
    end

    return LocalPlayer2:GetAttribute("Potato") == true
end

local function hiddenOther(p20) -- line: 513
    -- upvalues: UserId (copy), LocalPlayer2 (copy)
    if LocalPlayer2:GetAttribute("SetOtherAquariums") ~= false and LocalPlayer2:GetAttribute("Potato") ~= true then
        return false
    end

    local PenOwner = p20:GetAttribute("PenOwner")

    return PenOwner ~= nil and PenOwner ~= UserId
end

local function othersTank(p21) -- line: 520
    -- upvalues: UserId (copy)
    local PenOwner = p21:GetAttribute("PenOwner")

    return PenOwner ~= nil and PenOwner ~= UserId
end

local function playAt(p22, p23, p24, p25, p26, p27, p28) -- line: 525
    -- upvalues: t22 (copy), TankWater (ref), t23 (copy)
    local v52 = t23[p23]

    if not v52 then
        v52 = Instance.new("Sound")
        v52.SoundId = p23
        v52.Volume = 0.55
        v52.SoundGroup = TankWater
        v52.RollOffMode = Enum.RollOffMode.Linear
        v52.RollOffMinDistance = 60
        v52.RollOffMaxDistance = 400
        v52.Parent = script
        t23[p23] = v52
    end

    local clone = v52:Clone()

    if not p27 or not p24 then
        clone.PlaybackSpeed = p24 + (math.random() * 2 - 1) * 0.05
    else
        clone.PlaybackSpeed = p24
    end

    clone.Volume = 0.55 * (t22[1] + (t22[2] - t22[1]) * p25) * (p28 or 1)

    if not p26 then
        clone.Volume *= 0.25
        clone.RollOffMinDistance = 20
        clone.RollOffMaxDistance = 120
    end

    clone.Parent = p22
    clone:Play()
    game:GetService("Debris"):AddItem(clone, 10)
end

local function playGlobal(p29, p30, p31, p32, p33) -- line: 546
    -- upvalues: t22 (copy), TankWater (ref), t23 (copy)
    local v53 = t23[p29]

    if not v53 then
        v53 = Instance.new("Sound")
        v53.SoundId = p29
        v53.Volume = 0.55
        v53.SoundGroup = TankWater
        v53.RollOffMode = Enum.RollOffMode.Linear
        v53.RollOffMinDistance = 60
        v53.RollOffMaxDistance = 400
        v53.Parent = script
        t23[p29] = v53
    end

    local clone = v53:Clone()

    if not p33 or not p30 then
        clone.PlaybackSpeed = p30 + (math.random() * 2 - 1) * 0.05
    else
        clone.PlaybackSpeed = p30
    end

    clone.Volume = 0.55 * (t22[1] + (t22[2] - t22[1]) * p31)

    if not p32 then
        clone.Volume *= 0.25
    end

    clone.Parent = script
    clone:Play()
    game:GetService("Debris"):AddItem(clone, 10)
end

local function fishLength(p34) -- line: 555
    local ExtentsSize = p34:GetExtentsSize()

    return (math.max(ExtentsSize.X, ExtentsSize.Y, ExtentsSize.Z, 1))
end

local function apexCry(p35) -- line: 560
    -- upvalues: UserId (copy), t18 (copy), t19 (copy), LocalPlayer2 (copy), playAt (copy)
    local v54 = false

    if LocalPlayer2:GetAttribute("SetOtherAquariums") == false or LocalPlayer2:GetAttribute("Potato") == true then
        local PenOwner = p35:GetAttribute("PenOwner")

        v54 = PenOwner ~= nil and PenOwner ~= UserId
    end

    if not v54 then
        local v55 = p35.PrimaryPart or p35:FindFirstChildWhichIsA("BasePart")

        if v55 and not (math.random() > 0.6) then
            local v57 = math.clamp(p35:GetAttribute("JumpPower") or 0.5, 0, 1)

            for _, v58 in ipairs(t18) do
                if v57 < v58.upTo then
                    playAt(v55, v58.id, t19[1] + (t19[2] - t19[1]) * math.random(), v57, p35:GetAttribute("PenOwner") == UserId)

                    return
                end
            end
        end
    end
end

local function waterBurst(p36, p37, p38, p39) -- line: 573
    -- upvalues: UserId (copy), VFXBurst (copy), t17 (copy), t20 (copy), t21 (copy), playAt (copy)
    local PenOwner = p36:GetAttribute("PenOwner")

    if PenOwner == nil or PenOwner == UserId then
        local Attribute = p36:GetAttribute(p37)

        if typeof(Attribute) == "Vector3" then
            local v60 = math.clamp(p36:GetAttribute("JumpPower") or 0.5, 0, 1)
            local ExtentsSize = p36:GetExtentsSize()
            local v61 = math.max(ExtentsSize.X, ExtentsSize.Y, ExtentsSize.Z, 1) / p39 * (t21[1] + (t21[2] - t21[1]) * v60) * 0.7
            local v62 = VFXBurst.Play(p38, CFrame.new(Attribute), (math.min(v61, 2.5)))
            local v63 = p36:GetAttribute("PenOwner") == UserId

            if p37 == "Exit" then
                playAt(v62, "rbxassetid://126105529228330", t20[1] + (t20[2] - t20[1]) * v60, v60, v63, false, 0.5)
            else
                for _, v64 in ipairs(t17) do
                    if v60 < v64.upTo then
                        playAt(v62, v64.id, 1, v60, v63, false, 0.5)

                        return
                    end
                end
            end
        end
    end
end

local function feedBurst(p40) -- line: 596
    -- upvalues: UserId (copy), VFXBurst (copy), FeedBurst (copy), playAt (copy)
    local PenOwner = p40:GetAttribute("PenOwner")

    if PenOwner == nil or PenOwner == UserId then
        local v65 = p40.PrimaryPart or p40:FindFirstChildWhichIsA("BasePart")

        if v65 then
            local Play = VFXBurst.Play
            local v66 = CFrame.new(v65.Position)
            local ExtentsSize = p40:GetExtentsSize()

            Play(FeedBurst, v66, math.max(ExtentsSize.X, ExtentsSize.Y, ExtentsSize.Z, 1) / 30)
            playAt(v65, "rbxassetid://129840040992692", 1, 1, p40:GetAttribute("PenOwner") == UserId)
        end
    end
end

local function growBurst(p41) -- line: 605
    -- upvalues: UserId (copy), VFXBurst (copy), GrowBurst (copy), t22 (copy), TankWater (ref), t23 (copy)
    local PenOwner = p41:GetAttribute("PenOwner")

    if PenOwner == nil or PenOwner == UserId then
        local v67 = p41.PrimaryPart or p41:FindFirstChildWhichIsA("BasePart")

        if v67 then
            local GrowthDisplay = require(game:GetService("ReplicatedStorage").Modules.GrowthDisplay)
            local v68 = p41:GetAttribute("Stage") or 1
            local v69 = GrowthDisplay.gradients[v68] or ColorSequence.new(GrowthDisplay.colors[v68] or Color3.new(1, 1, 1))
            local Play = VFXBurst.Play
            local v70 = CFrame.new(v67.Position)
            local ExtentsSize = p41:GetExtentsSize()

            Play(GrowBurst, v70, math.clamp(math.max(ExtentsSize.X, ExtentsSize.Y, ExtentsSize.Z, 1) / 12, 0.5, 40), v69)

            if p41:GetAttribute("PenOwner") == UserId then
                local v72 = t23["rbxassetid://2789427964"]

                if not v72 then
                    v72 = Instance.new("Sound")
                    v72.SoundId = "rbxassetid://2789427964"
                    v72.Volume = 0.55
                    v72.SoundGroup = TankWater
                    v72.RollOffMode = Enum.RollOffMode.Linear
                    v72.RollOffMinDistance = 60
                    v72.RollOffMaxDistance = 400
                    v72.Parent = script
                    t23["rbxassetid://2789427964"] = v72
                end

                local clone = v72:Clone()

                clone.PlaybackSpeed = 1
                clone.Volume = 0.55 * (t22[1] + (t22[2] - t22[1]) * 1)
                clone.Parent = script
                clone:Play()
                game:GetService("Debris"):AddItem(clone, 10)
            end
        end
    end
end

local function watchHook(p42) -- line: 618
    -- upvalues: applyMutationLook (copy), t12 (copy), startPop (copy), UserId (copy), Splash (copy), WaterBoom (copy), apexCry (copy), waterBurst (copy), feedBurst (copy), growBurst (copy)
    p42:GetAttributeChangedSignal("Hooked"):Connect(function() -- line: 619
        -- upvalues: p42 (copy), startPop (copy), UserId (copy)
        if p42:GetAttribute("Hooked") and p42:GetAttribute("HookedBy") ~= UserId then
            startPop(p42)
        end
    end)
    p42:GetAttributeChangedSignal("BeatPop"):Connect(function() -- line: 622
        -- upvalues: p42 (copy), startPop (copy)
        startPop(p42)
    end)
    p42:GetAttributeChangedSignal("LocalHit"):Connect(function() -- line: 623
        -- upvalues: p42 (copy), startPop (copy)
        startPop(p42)
    end)
    p42:GetAttributeChangedSignal("Cracked"):Connect(function() -- line: 624
        -- upvalues: p42 (copy), applyMutationLook (copy)
        applyMutationLook(p42)
    end)

    if p42:GetAttribute("Mutation") or p42:GetAttribute("SpeciesAura") then
        applyMutationLook(p42)
    end

    p42:GetAttributeChangedSignal("WitchHat"):Connect(function() -- line: 627
        -- upvalues: p42 (copy), t12 (copy)
        t12.drop(p42)
        t12.apply(p42)
    end)
    p42:GetAttributeChangedSignal("Crowned"):Connect(function() -- line: 631
        -- upvalues: p42 (copy), t12 (copy)
        t12.drop(p42)
        t12.apply(p42)
    end)
    p42:GetAttributeChangedSignal("Cap"):Connect(function() -- line: 635
        -- upvalues: p42 (copy), t12 (copy)
        t12.drop(p42)
        t12.apply(p42)
    end)
    t12.apply(p42)
    p42:GetAttributeChangedSignal("ExitN"):Connect(function() -- line: 642
        -- upvalues: p42 (copy), WaterBoom (copy), waterBurst (copy)
        waterBurst(p42, "Exit", WaterBoom, 30)
    end)
    p42:GetAttributeChangedSignal("EntryN"):Connect(function() -- line: 643
        -- upvalues: p42 (copy), Splash (copy), waterBurst (copy)
        waterBurst(p42, "Entry", Splash, 40)
    end)
    p42:GetAttributeChangedSignal("ApexN"):Connect(function() -- line: 644
        -- upvalues: p42 (copy), apexCry (copy)
        apexCry(p42)
    end)
    p42:GetAttributeChangedSignal("FedN"):Connect(function() -- line: 645
        -- upvalues: p42 (copy), feedBurst (copy)
        feedBurst(p42)
    end)
    p42:GetAttributeChangedSignal("GrownN"):Connect(function() -- line: 646
        -- upvalues: p42 (copy), growBurst (copy)
        growBurst(p42)
    end)
end

task.spawn(function() -- line: 650
    -- upvalues: VFXBurst (copy), Splash (copy), WaterBoom (copy), FeedBurst (copy), GrowBurst (copy), t23 (copy)
    local v73 = VFXBurst.Emitters(Splash)

    for _, v74 in ipairs(VFXBurst.Emitters(WaterBoom)) do
        v73[#v73 + 1] = v74
    end

    for _, v75 in ipairs(VFXBurst.Emitters(FeedBurst)) do
        v73[#v73 + 1] = v75
    end

    for _, v76 in ipairs(VFXBurst.Emitters(GrowBurst)) do
        v73[#v73 + 1] = v76
    end

    for _, v77 in pairs(t23) do
        v73[#v73 + 1] = v77
    end

    local function v78() -- line: 656
        -- upvalues: v73 (copy)
        game:GetService("ContentProvider"):PreloadAsync(v73)
    end

    pcall(v78)
end)

local function updatePops(p43) -- line: 660
    -- upvalues: t6 (copy)
    for v79, v80 in pairs(t6) do
        if v79.Parent and v80.mesh.Parent then
            v80.t += p43

            local t = v80.t
            local v81 = if t < 0.12 then 1 + 0.3999999999999999 * (1 - (1 - t / 0.12) ^ 3) elseif t < 0.67 then (math.cos((t - 0.12) / 0.55 * 3.141592653589793) * 0.5 + 0.5) * 0.3999999999999999 + 1 else nil

            if v81 then
                v80.proxy:PivotTo(v80.mesh.CFrame)
                v80.proxy:ScaleTo(v81)
                v80.proxyMesh.Transparency = v80.mesh.Transparency

                for _, v83 in ipairs(v80.bonePairs) do
                    v83[2].Transform = v83[1].Transform
                end
            else
                local v84 = t6[v79]

                if v84 then
                    t6[v79] = nil
                    v84.proxy:Destroy()

                    if v84.mesh.Parent then
                        v84.mesh.LocalTransparencyModifier = 0
                    end
                end
            end
        else
            local v85 = t6[v79]

            if v85 then
                t6[v79] = nil
                v85.proxy:Destroy()

                if v85.mesh.Parent then
                    v85.mesh.LocalTransparencyModifier = 0
                end
            end
        end
    end
end

local t24 = {}
local Live

local function tryShowcase(p44) -- line: 695
    -- upvalues: t1 (copy), t24 (copy)
    if t24[p44] then
        return
    end

    local ProceduralAnim = p44:GetAttribute("ProceduralAnim")
    local v86 = ProceduralAnim and t1[ProceduralAnim]

    if v86 then
        task.spawn(function() -- line: 700
            -- upvalues: p44 (copy), v86 (copy), t24 (copy)
            local result

            for _ = 1, 40 do
                if t24[p44] then
                    return
                end

                local ShowScale = p44:GetAttribute("ShowScale")
                local Scale = p44:GetScale()

                if ShowScale and math.abs(ShowScale - Scale) > 1E-04 then
                    p44:ScaleTo(ShowScale)
                end

                local register = v86.register
                local ok, result2 = pcall(register, p44)

                if ShowScale and math.abs(ShowScale - Scale) > 1E-04 then
                    p44:ScaleTo(Scale)
                end

                if ok and result2 then
                    t24[p44] = {
                        showcase = true,
                        driver = v86,
                        state = result2
                    }

                    return
                end

                if not ok and result2 then
                    result = result2
                end

                task.wait(0.5)
            end

            warn("[FRC] could not register roll model " .. p44.Name .. (result and ": " .. tostring(result) or ""))
        end)
    end
end

local function treadmill(p45, p46, p47) -- line: 722
    local ShowSwim = p45:GetAttribute("ShowSwim")
    local AnatomyInverse = p45:GetAttribute("AnatomyInverse")

    if ShowSwim and typeof(AnatomyInverse) == "CFrame" then
        local Pivot = p45:GetPivot()
        local showPivot = p46.showPivot

        p46.showPivot = Pivot

        if showPivot then
            local v89 = Pivot * showPivot:Inverse()

            for _, v90 in ipairs({ "lastPos", "lastMid" }) do
                if p46[v90] then
                    p46[v90] = v89 * p46[v90]
                end
            end

            if p46.crawl and p46.crawl.lastPos then
                p46.crawl.lastPos = v89 * p46.crawl.lastPos
            end

            if p46.trail then
                for v91, v92 in ipairs(p46.trail) do
                    p46.trail[v91] = v89 * v92
                end
            end

            for _, v93 in ipairs({ "lastNose", "lastFlat", "kappa" }) do
                if typeof(p46[v93]) == "Vector3" then
                    p46[v93] = v89:VectorToWorldSpace(p46[v93])
                end
            end
        end

        local v95 = -(Pivot * AnatomyInverse:Inverse()).RightVector * (ShowSwim * p47)

        if p46.lastPos then
            p46.lastPos += v95
        end

        if p46.lastMid then
            p46.lastMid += v95
        end

        if p46.crawl and p46.crawl.lastPos then
            p46.crawl.lastPos += v95
        end

        if p46.trail then
            for v96, v97 in ipairs(p46.trail) do
                p46.trail[v96] = v97 + v95
            end
        end
    end
end

task.spawn(function() -- line: 749
    -- upvalues: t1 (copy), t24 (copy), Live (ref), tryShowcase (copy)
    Live = workspace:WaitForChild("FishRoll"):WaitForChild("Live")

    for _, child in ipairs(Live:GetChildren()) do
        if not t24[child] then
            local ProceduralAnim = child:GetAttribute("ProceduralAnim")
            local v98 = ProceduralAnim and t1[ProceduralAnim]

            if v98 then
                task.spawn(function() -- line: 700
                    -- upvalues: child (copy), v98 (copy), t24 (copy)
                    local result

                    for _ = 1, 40 do
                        if t24[child] then
                            return
                        end

                        local ShowScale = child:GetAttribute("ShowScale")
                        local Scale = child:GetScale()

                        if ShowScale and math.abs(ShowScale - Scale) > 1E-04 then
                            child:ScaleTo(ShowScale)
                        end

                        local register = v98.register
                        local ok, result2 = pcall(register, child)

                        if ShowScale and math.abs(ShowScale - Scale) > 1E-04 then
                            child:ScaleTo(Scale)
                        end

                        if ok and result2 then
                            t24[child] = {
                                showcase = true,
                                driver = v98,
                                state = result2
                            }

                            return
                        end

                        if not ok and result2 then
                            result = result2
                        end

                        task.wait(0.5)
                    end

                    warn("[FRC] could not register roll model " .. child.Name .. (result and ": " .. tostring(result) or ""))
                end)
            end
        end
    end

    Live.ChildAdded:Connect(tryShowcase)
end)

local function tryRegister(p48) -- line: 755
    -- upvalues: t1 (copy), t24 (copy), tryRegister (copy)
    local ProceduralAnim = p48:GetAttribute("ProceduralAnim")
    local v101 = ProceduralAnim and t1[ProceduralAnim]

    if v101 then
        task.spawn(function() -- line: 759
            -- upvalues: p48 (copy), v101 (copy), t24 (copy), tryRegister (copy)
            local result

            for _ = 1, 40 do
                if not p48.Parent or t24[p48] then
                    return
                end

                local register = v101.register
                local ok, result2 = pcall(register, p48)

                if ok and result2 then
                    t24[p48] = {
                        driver = v101,
                        state = result2
                    }

                    return
                end

                if not ok and result2 then
                    result = result2
                end

                task.wait(0.5)
            end

            if p48.Parent and not t24[p48] then
                if p48:FindFirstChildWhichIsA("MeshPart", true) then
                    warn("[FRC] could not register " .. p48.Name .. (result and ": " .. tostring(result) or ""))
                else
                    local connection

                    connection = p48.DescendantAdded:Connect(function(p49) -- line: 779
                        -- upvalues: connection (ref), p48 (copy), tryRegister (copy)
                        if not p49:IsA("MeshPart") then
                            return
                        end

                        connection:Disconnect()
                        tryRegister(p48)
                    end)
                end
            end
        end)
    end
end

task.spawn(function() -- line: 791
    -- upvalues: t1 (copy), t5 (copy), t6 (copy), t7 (copy), t16 (copy), watchHook (copy), t24 (copy), tryRegister (copy)
    local Fish = workspace:WaitForChild("Fish")

    for _, child in ipairs(Fish:GetChildren()) do
        local ProceduralAnim = child:GetAttribute("ProceduralAnim")
        local v102 = ProceduralAnim and t1[ProceduralAnim]

        if v102 then
            task.spawn(function() -- line: 759
                -- upvalues: child (copy), v102 (copy), t24 (copy), tryRegister (copy)
                local result

                for _ = 1, 40 do
                    if not child.Parent or t24[child] then
                        return
                    end

                    local register = v102.register
                    local ok, result2 = pcall(register, child)

                    if ok and result2 then
                        t24[child] = {
                            driver = v102,
                            state = result2
                        }

                        return
                    end

                    if not ok and result2 then
                        result = result2
                    end

                    task.wait(0.5)
                end

                if child.Parent and not t24[child] then
                    if child:FindFirstChildWhichIsA("MeshPart", true) then
                        warn("[FRC] could not register " .. child.Name .. (result and ": " .. tostring(result) or ""))
                    else
                        local connection

                        connection = child.DescendantAdded:Connect(function(p50) -- line: 779
                            -- upvalues: child (copy), tryRegister (copy), connection (ref)
                            if not p50:IsA("MeshPart") then
                                return
                            end

                            connection:Disconnect()
                            tryRegister(child)
                        end)
                    end
                end
            end)
        end

        watchHook(child)
    end

    Fish.ChildAdded:Connect(function(p51) -- line: 794
        -- upvalues: t1 (copy), watchHook (copy), t24 (copy), tryRegister (copy)
        local ProceduralAnim = p51:GetAttribute("ProceduralAnim")
        local v103 = ProceduralAnim and t1[ProceduralAnim]

        if v103 then
            task.spawn(function() -- line: 759
                -- upvalues: p51 (copy), v103 (copy), t24 (copy), tryRegister (copy)
                local result

                for _ = 1, 40 do
                    if not p51.Parent or t24[p51] then
                        return
                    end

                    local register = v103.register
                    local ok, result2 = pcall(register, p51)

                    if ok and result2 then
                        t24[p51] = {
                            driver = v103,
                            state = result2
                        }

                        return
                    end

                    if not ok and result2 then
                        result = result2
                    end

                    task.wait(0.5)
                end

                if p51.Parent and not t24[p51] then
                    if p51:FindFirstChildWhichIsA("MeshPart", true) then
                        warn("[FRC] could not register " .. p51.Name .. (result and ": " .. tostring(result) or ""))
                    else
                        local connection

                        connection = p51.DescendantAdded:Connect(function(p52) -- line: 779
                            -- upvalues: p51 (copy), tryRegister (copy), connection (ref)
                            if not p52:IsA("MeshPart") then
                                return
                            end

                            connection:Disconnect()
                            tryRegister(p51)
                        end)
                    end
                end
            end)
        end

        watchHook(p51)
    end)
    Fish.ChildRemoved:Connect(function(p53) -- line: 795
        -- upvalues: t5 (copy), t6 (copy), t7 (copy), t16 (copy), t24 (copy)
        t24[p53] = nil
        t16[p53] = nil
        t7.fish[p53] = nil

        local v104 = t6[p53]

        if v104 then
            t6[p53] = nil
            v104.proxy:Destroy()

            if v104.mesh.Parent then
                v104.mesh.LocalTransparencyModifier = 0
            end
        end

        local v105 = t5[p53]

        if v105 then
            t5[p53] = nil
            v105.carrier:Destroy()
        end
    end)
end)

local n1 = 0
local t25 = {
    100, 200
}
local v106 = game:GetService("Players").LocalPlayer:GetAttribute("Potato") == true

game:GetService("Players").LocalPlayer:GetAttributeChangedSignal("Potato"):Connect(function() -- line: 821
    -- upvalues: v106 (ref)
    v106 = game:GetService("Players").LocalPlayer:GetAttribute("Potato") == true
end)

local n2 = 0

local function forgetMotion(p54) -- line: 825
    p54.lastPos = nil
    p54.lastNose = nil
    p54.lastFlat = nil
    p54.lastMid = nil

    if p54.crawl then
        p54.crawl.lastPos = nil
    end
end

RunService.RenderStepped:Connect(function(p55) -- line: 829
    -- upvalues: t1 (copy), attr (copy), t5 (copy), t6 (copy), t7 (copy), applyMutationLook (copy), t12 (copy), UserId (copy), LocalPlayer2 (copy), updatePops (copy), t24 (copy), Live (ref), treadmill (copy), tryRegister (copy), n1 (ref), t25 (copy), v106 (ref), n2 (ref)
    n1 += p55
    n2 += 1

    local v107 = workspace.CurrentCamera
    local _CFrame = v107.CFrame
    local Y = _CFrame.Position.Y
    local FieldOfView = v107.FieldOfView
    local v109 = math.tan(math.rad(FieldOfView) / 2)
    local v108 = v109 * v107.ViewportSize.X / math.max(v107.ViewportSize.Y, 1)

    v107 = LocalPlayer2:GetAttribute("SetOtherAquariums") == false or LocalPlayer2:GetAttribute("Potato") == true

    local v110 = LocalPlayer2:GetAttribute("TurkeyRun") ~= nil
    local v111 = {}
    local mesh, Y2, v112, v113, v114, v115, v116, v117

    for v118, v119 in pairs(t24) do
        if v119.showcase then
            if v118.Parent and v118.Parent == Live and not game:GetService("Players").LocalPlayer:GetAttribute("CameraUnderwater") then
                treadmill(v118, v119.state, p55)
                v119.driver.update(v119.state, p55, n1)
            end
        elseif v118.Parent then
            if v119.state.mesh.Parent ~= nil then
                mesh = v119.state.mesh
                Y2 = mesh.Position.Y
                v116 = t7.fish[v118] ~= nil

                if t7.harpoon then
                    v113 = Y2 - Y
                    v112 = math.abs(v113)
                    v115 = t7.Y + t7.HYST < v112
                    v117 = v112 < t7.Y - t7.HYST
                else
                    v115 = Y2 < t7.FLOOR - t7.HYST
                    v117 = t7.FLOOR + t7.HYST < Y2
                end

                if v107 then
                    v112 = v118:GetAttribute("PenOwner")

                    if v112 ~= nil and v112 ~= UserId then
                        v115 = true
                        v117 = false
                    end
                end

                if v110 and v118:GetAttribute("PenOwner") == nil and v118:GetAttribute("OnlyFor") ~= UserId then
                    v115 = true
                    v117 = false
                end

                if v116 then
                    if v117 then
                        t7.fish[v118] = nil
                        mesh.LocalTransparencyModifier = 0
                        t24[v118] = nil
                        v111[#v111 + 1] = v118
                    end
                elseif v115 then
                    t7.fish[v118] = true
                    v112 = t6[v118]

                    if v112 then
                        t6[v118] = nil
                        v112.proxy:Destroy()

                        if v112.mesh.Parent then
                            v112.mesh.LocalTransparencyModifier = 0
                        end
                    end

                    mesh.LocalTransparencyModifier = 1

                    for _, descendant in ipairs(mesh:GetDescendants()) do
                        if descendant:IsA("Bone") then
                            descendant.Transform = CFrame.identity
                        end
                    end
                else
                    v112 = _CFrame:PointToObjectSpace(mesh.Position)
                    v113 = mesh.Size.Magnitude * 2
                    v114 = -v112.Z

                    local v121 = -v113

                    if v121 < v114 then
                        v121 = math.abs(v112.X)

                        local X = v114 * v108 + v113

                        if v121 <= X then
                            X = v112.Y
                            v121 = math.abs(X)
                            X = v114 * v109 + v113

                            if v121 <= X then
                                v119.offscreen = nil
                                X = attr(v118, "PenOwner")

                                local v122 = v106
                                local Magnitude, v123, v124

                                if v122 then
                                    v122 = mesh.Size
                                    Magnitude = v112.Magnitude
                                    v123 = Magnitude - math.max(0, math.max(v122.X, v122.Y, v122.Z) / 2 - 75)
                                    v124 = t25[2]

                                    if v124 < v123 then
                                        v124 = v106
                                        Magnitude = if v124 then 4 else 3
                                    else
                                        Magnitude = if t25[1] < v123 then 2 else 1
                                    end
                                elseif X == UserId then
                                    Magnitude = 1
                                else
                                    v122 = mesh.Size
                                    Magnitude = v112.Magnitude
                                    v123 = Magnitude - math.max(0, math.max(v122.X, v122.Y, v122.Z) / 2 - 75)
                                    v124 = t25[2]

                                    if v124 < v123 then
                                        v124 = v106
                                        Magnitude = if v124 then 4 else 3
                                    else
                                        Magnitude = if t25[1] < v123 then 2 else 1
                                    end
                                end

                                if Magnitude == 1 then
                                    v122 = v119.driver.update
                                    v123 = v119.state
                                    Magnitude = p55 + (v119.skipDt or 0)
                                    v124 = n1
                                    v122(v123, Magnitude, v124)
                                    v119.skipDt = nil
                                else
                                    v119.skipDt = (v119.skipDt or 0) + p55
                                    v119.phase = v119.phase or math.random(0, 5)
                                    v122 = (n2 + v119.phase) % Magnitude

                                    if v122 == 0 then
                                        v122 = v119.driver.update
                                        v123 = v119.state
                                        Magnitude = v119.skipDt
                                        v124 = n1
                                        v122(v123, Magnitude, v124)
                                        v119.skipDt = nil
                                    end
                                end
                            else
                                v121 = v119.offscreen

                                if not v121 then
                                    v119.offscreen = true
                                    v119.skipDt = nil
                                    v121 = v119.state
                                    v121.lastPos = nil
                                    v121.lastNose = nil
                                    v121.lastFlat = nil
                                    v121.lastMid = nil

                                    if v121.crawl then
                                        v121.crawl.lastPos = nil
                                    end
                                end
                            end
                        else
                            v121 = v119.offscreen

                            if not v121 then
                                v119.offscreen = true
                                v119.skipDt = nil
                                v121 = v119.state
                                v121.lastPos = nil
                                v121.lastNose = nil
                                v121.lastFlat = nil
                                v121.lastMid = nil

                                if v121.crawl then
                                    v121.crawl.lastPos = nil
                                end
                            end
                        end
                    else
                        v121 = v119.offscreen

                        if not v121 then
                            v119.offscreen = true
                            v119.skipDt = nil
                            v121 = v119.state
                            v121.lastPos = nil
                            v121.lastNose = nil
                            v121.lastFlat = nil
                            v121.lastMid = nil

                            if v121.crawl then
                                v121.crawl.lastPos = nil
                            end
                        end
                    end
                end
            else
                t24[v118] = nil
                t7.fish[v118] = nil
                mesh = v118:GetAttribute("ProceduralAnim")

                local v120 = mesh and t1[mesh]

                if v120 then
                    v116 = task.spawn
                    v116(function() -- line: 759
                        -- upvalues: v120 (copy), v118 (copy), t24 (copy), tryRegister (copy)
                        local result

                        for _ = 1, 40 do
                            if not v118.Parent or t24[v118] then
                                return
                            end

                            local register = v120.register
                            local ok, result2 = pcall(register, v118)

                            if ok and result2 then
                                t24[v118] = {
                                    driver = v120,
                                    state = result2
                                }

                                return
                            end

                            if not ok and result2 then
                                result = result2
                            end

                            task.wait(0.5)
                        end

                        if v118.Parent and not t24[v118] then
                            if v118:FindFirstChildWhichIsA("MeshPart", true) then
                                warn("[FRC] could not register " .. v118.Name .. (result and ": " .. tostring(result) or ""))
                            else
                                local connection

                                connection = v118.DescendantAdded:Connect(function(p56) -- line: 779
                                    -- upvalues: v118 (copy), tryRegister (copy), connection (ref)
                                    if not p56:IsA("MeshPart") then
                                        return
                                    end

                                    connection:Disconnect()
                                    tryRegister(v118)
                                end)
                            end
                        end
                    end)
                end
            end
        else
            t24[v118] = nil
            t7.fish[v118] = nil
        end
    end

    for _, v128 in ipairs(v111) do
        mesh = v128:GetAttribute("ProceduralAnim")

        local v129 = mesh and t1[mesh]

        if v129 then
            mesh = task.spawn
            mesh(function() -- line: 759
                -- upvalues: v128 (copy), v129 (copy), t24 (copy), tryRegister (copy)
                local result

                for _ = 1, 40 do
                    if not v128.Parent or t24[v128] then
                        return
                    end

                    local register = v129.register
                    local ok, result2 = pcall(register, v128)

                    if ok and result2 then
                        t24[v128] = {
                            driver = v129,
                            state = result2
                        }

                        return
                    end

                    if not ok and result2 then
                        result = result2
                    end

                    task.wait(0.5)
                end

                if v128.Parent and not t24[v128] then
                    if v128:FindFirstChildWhichIsA("MeshPart", true) then
                        warn("[FRC] could not register " .. v128.Name .. (result and ": " .. tostring(result) or ""))
                    else
                        local connection

                        connection = v128.DescendantAdded:Connect(function(p57) -- line: 779
                            -- upvalues: v128 (copy), tryRegister (copy), connection (ref)
                            if not p57:IsA("MeshPart") then
                                return
                            end

                            connection:Disconnect()
                            tryRegister(v128)
                        end)
                    end
                end
            end)
        end
    end

    v111 = workspace.CurrentCamera.CFrame.Position

    for v130, v131 in pairs(t5) do
        v109 = t7.fish[v130] ~= nil or v131.mesh.Transparency >= 1

        if v130.Parent then
            if v131.mesh.Parent ~= nil then
                if v109 == (v131.hidden or false) then
                    if not v109 then
                        mesh = v131.mesh.CFrame
                        v131.carrier.CFrame = mesh

                        for _, v132 in ipairs(v131.parts) do
                            v132.part.CFrame = mesh * v132.off
                        end

                        if v131.cycle then
                            v131.mesh.Color = Color3.fromHSV(n1 * 0.2 % 1, 0.85, 1)
                            Y2 = t6[v130]

                            if Y2 then
                                Y2.proxyMesh.Color = v131.mesh.Color
                            end
                        end

                        if n1 - v131.lastCull > 0.25 then
                            v131.lastCull = n1
                            Y2 = t24[v130]
                            v116 = v106

                            if not v116 then
                                v115 = v130:GetAttribute("PenOwner")
                                v116 = v115 ~= nil and v115 ~= UserId

                                if not v116 then
                                    v116 = if Y2 ~= nil then Y2.offscreen == true or (v111 - mesh.Position).Magnitude > 120 else (v111 - mesh.Position).Magnitude > 120
                                end
                            end

                            if v116 ~= v131.culled then
                                v131.culled = v116

                                for _, v134 in ipairs(v131.emitters) do
                                    v134.Enabled = not v116
                                end
                            end
                        end
                    end
                else
                    v131.hidden = v109

                    for _, v135 in ipairs(v131.parts) do
                        v135.part.LocalTransparencyModifier = v109 and 1 or 0
                    end

                    for _, v136 in ipairs(v131.emitters) do
                        v136.Enabled = not v109 and not v131.culled
                    end
                end
            else
                v107 = t5[v130]

                if v107 then
                    t5[v130] = nil
                    v107.carrier:Destroy()
                end

                applyMutationLook(v130)
            end
        else
            Y = t5[v130]

            if Y then
                t5[v130] = nil
                Y.carrier:Destroy()
            end
        end
    end

    local parts = t12.parts
    local cfs = t12.cfs

    table.clear(parts)
    v115 = nil
    table.clear(cfs)

    for v137, v138 in pairs(t12.list) do
        if not v137.Parent or v138.mesh.Parent == nil then
            v115 = v115 or {}
            v115[#v115 + 1] = v137
        elseif v138.culled then
            local v139 = v138.shown

            if not v139 then
                v139 = not (n1 - v138.lastCull <= 0.25)
            end

            if v139 then
                v111 = v138.mesh

                local _CFrame2 = v111.CFrame

                v112 = n1
                v117 = v112 - v138.lastCull

                if v117 > 0.25 then
                    v117 = n1
                    v138.lastCull = v117
                    v117 = t24[v137]
                    v113 = v137:GetAttribute("PenOwner")
                    v112 = v113 ~= nil and v113 ~= UserId

                    if not v112 then
                        v112 = if v117 ~= nil then v117.offscreen == true or (_CFrame.Position - _CFrame2.Position).Magnitude > (v106 and t12.POTATO or t12.CULL) else (_CFrame.Position - _CFrame2.Position).Magnitude > (v106 and t12.POTATO or t12.CULL)
                    end

                    v138.culled = v112

                    if v111.Size ~= v138.meshSize then
                        t12.fit(v138)
                    end
                end

                v117 = not v138.culled

                if v117 then
                    v117 = t7.fish[v137] == nil and v111.Transparency < 1 and v111.LocalTransparencyModifier < 1
                end

                if v117 ~= v138.shown then
                    v138.shown = v117
                    v138.part.Parent = v117 and workspace.CurrentCamera or nil
                end

                if v117 then
                    v112 = _CFrame2:VectorToWorldSpace(v138.up)

                    local v141 = _CFrame2:VectorToWorldSpace(v138.nose)

                    v114 = (v138.bone and v138.bone.TransformedWorldCFrame.Position or _CFrame2.Position + v141 * (v138.len * 0.3)) + _CFrame2:VectorToWorldSpace(v138.offLocal)
                    parts[#parts + 1] = v138.part
                    cfs[#cfs + 1] = CFrame.lookAt(v114, v114 + v141, v112)
                end
            end
        else
            v111 = v138.mesh

            local _CFrame2 = v111.CFrame

            v112 = n1
            v117 = v112 - v138.lastCull

            if v117 > 0.25 then
                v117 = n1
                v138.lastCull = v117
                v117 = t24[v137]
                v113 = v137:GetAttribute("PenOwner")
                v112 = v113 ~= nil and v113 ~= UserId

                if not v112 then
                    v112 = if v117 ~= nil then v117.offscreen == true or (_CFrame.Position - _CFrame2.Position).Magnitude > (v106 and t12.POTATO or t12.CULL) else (_CFrame.Position - _CFrame2.Position).Magnitude > (v106 and t12.POTATO or t12.CULL)
                end

                v138.culled = v112

                if v111.Size ~= v138.meshSize then
                    t12.fit(v138)
                end
            end

            v117 = not v138.culled

            if v117 then
                v117 = t7.fish[v137] == nil and v111.Transparency < 1 and v111.LocalTransparencyModifier < 1
            end

            if v117 ~= v138.shown then
                v138.shown = v117
                v138.part.Parent = v117 and workspace.CurrentCamera or nil
            end

            if v117 then
                v112 = _CFrame2:VectorToWorldSpace(v138.up)

                local v142 = _CFrame2:VectorToWorldSpace(v138.nose)

                v114 = (v138.bone and v138.bone.TransformedWorldCFrame.Position or _CFrame2.Position + v142 * (v138.len * 0.3)) + _CFrame2:VectorToWorldSpace(v138.offLocal)
                parts[#parts + 1] = v138.part
                cfs[#cfs + 1] = CFrame.lookAt(v114, v114 + v142, v112)
            end
        end
    end

    if #parts > 0 then
        workspace:BulkMoveTo(parts, cfs, Enum.BulkMoveMode.FireCFrameChanged)
    end

    if v115 then
        for _, v143 in ipairs(v115) do
            t12.drop(v143)

            if v143.Parent then
                t12.apply(v143)
            end
        end
    end

    updatePops(p55)
end)
