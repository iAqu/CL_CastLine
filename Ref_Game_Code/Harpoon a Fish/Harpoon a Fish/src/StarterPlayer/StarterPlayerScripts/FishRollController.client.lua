-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local FishDisplay = require(Modules:WaitForChild("FishDisplay"))
local RarityDisplay = require(Modules:WaitForChild("RarityDisplay"))
local RarityStyle = require(Modules:WaitForChild("RarityStyle"))
local JURASSIC_TITAN = require(Modules:WaitForChild("WorldConfig")).IsJurassic() and RarityStyle.JURASSIC_TITAN or RarityStyle.TITAN
local VFXBurst = require(Modules:WaitForChild("VFXBurst"))
local SpawnClockConfig = require(Modules:WaitForChild("SpawnClockConfig"))
local WeatherConfig = require(Modules:WaitForChild("WeatherConfig"))
local TitanConfig = require(Modules:WaitForChild("TitanConfig"))
local FishRoll = workspace:WaitForChild("FishRoll")
local RollBase = FishRoll:WaitForChild("RollBase")
local Tag = RollBase:WaitForChild("Tag")
local Body = Tag:WaitForChild("Body")
local Pop = Body:WaitForChild("Pop")
local Rarity = Body:WaitForChild("Rarity")
local Species = Body:WaitForChild("Species")
local Board = FishRoll:WaitForChild("Board"):WaitForChild("Board")
local Timer = Board:WaitForChild("Timer")
local Grad = Timer:WaitForChild("Grad")
local Pop2 = Timer:WaitForChild("Pop")
local Explosion = ReplicatedStorage:WaitForChild("VFX"):WaitForChild("Explosion")
local Folder = Instance.new("Folder")

Folder.Name = "Live"
Folder.Parent = FishRoll

local v1 = RarityStyle.GradientOf(RarityDisplay.Legendary.color)
local v2 = RarityStyle.GradientOf(RarityDisplay.Mythic.color)
local v3 = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v4
local v5 = false

RunService.Heartbeat:Connect(function() -- line: 120
    -- upvalues: TweenService (copy), SpawnClockConfig (copy), Timer (copy), Grad (copy), Pop2 (copy), v1 (copy), v2 (copy), v3 (copy), v4 (ref), v5 (ref)
    if v5 then
        return
    end

    local v7 = math.ceil((SpawnClockConfig.SecondsLeft(workspace:GetServerTimeNow())))

    if v7 == v4 then
        return
    end

    v4 = v7
    Timer.Text = string.format("%d:%02d", v7 // 60, v7 % 60)

    local v8 = v7 <= 10

    Grad.Color = v8 and v2 or v1
    Pop2.Scale = v8 and 1.3 or 1.12
    TweenService:Create(Pop2, v3, {
        Scale = 1
    }):Play()
end)

local Heartbeat = ReplicatedStorage:WaitForChild("FishRollModels")
local Count = Heartbeat:GetAttribute("Count")
local elapsed = os.clock()

while type(Count) == "number" and #Heartbeat:GetChildren() < Count and os.clock() - elapsed < 30 do
    task.wait(0.1)
end

local Children = Heartbeat:GetChildren()

if #Children == 0 then
    warn("[FishRoll] no fish in ReplicatedStorage.FishRollModels -- roll inactive")
else
    local v10 = Random.new()
    local t1 = {}

    local function makeSilhouette(p1) -- line: 158
        for _, descendant in ipairs(p1:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Trail") or descendant:IsA("Light") then
                descendant.Enabled = false
            elseif descendant:IsA("SurfaceAppearance") or descendant:IsA("Decal") or descendant:IsA("Texture") then
                descendant:Destroy()
            elseif descendant:IsA("BasePart") then
                if descendant:IsA("MeshPart") then
                    descendant.TextureID = ""
                end

                if descendant.Transparency > 0 and descendant.Transparency < 1 then
                    descendant.Transparency = 0
                end
            end
        end

        local Highlight = Instance.new("Highlight")

        Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
        Highlight.FillColor = Color3.new(0, 0, 0)
        Highlight.FillTransparency = 0
        Highlight.OutlineColor = Color3.new(1, 1, 1)
        Highlight.OutlineTransparency = 0.7
        Highlight.Parent = p1
    end

    local function prep(p2) -- line: 179
        -- upvalues: t1 (copy), makeSilhouette (copy)
        local v11 = t1[p2]

        if v11 then
            return v11
        end

        local AnatomyInverse = p2:GetAttribute("AnatomyInverse")

        if typeof(AnatomyInverse) ~= "CFrame" then
            AnatomyInverse = CFrame.identity
        end

        local ExtentsSize = p2:GetExtentsSize()
        local clone = p2:Clone()
        local v12 = CFrame.fromMatrix(Vector3.new(0, 0, 0), Vector3.new(1, 0, 0), (Vector3.new(0, 1, 0))) * AnatomyInverse

        clone:PivotTo(v12)

        local t2 = {}
        local v13 = Vector3.new(1, 1, 1) * 1e999
        local v14 = Vector3.new(-1, -1, -1, -0) * 1e999

        for _, descendant in ipairs(clone:GetDescendants()) do
            if descendant:IsA("BasePart") then
                t2[#t2 + 1] = {
                    part = descendant,
                    t = descendant.Transparency
                }

                local v15 = descendant.Size / 2
                local v16 = v13
                local v17 = v14

                for _, v18 in ipairs({ -1, 1 }) do
                    local v19 = v16
                    local v20 = v17

                    for _, v21 in ipairs({ -1, 1 }) do
                        for _, v24 in ipairs({ -1, 1 }) do
                            local v28 = descendant.CFrame:PointToWorldSpace((Vector3.new(v15.X * v18, v15.Y * v21, v15.Z * v24)))

                            v19 = v19:Min(v28)
                            v20 = v20:Max(v28)
                        end

                        v17 = v20
                        v16 = v19
                    end

                    v14 = v17
                    v13 = v16
                end
            end
        end

        local clone2 = clone:Clone()

        makeSilhouette(clone2)

        local t3 = {
            species = p2.Name,
            full = clone,
            sil = clone2,
            fade = t2,
            rot = v12,
            centre = (v13 + v14) / 2,
            half = (v14.Y - v13.Y) / 2,
            scale = clone:GetScale(),
            length = math.max(ExtentsSize.X, ExtentsSize.Y, ExtentsSize.Z)
        }

        clone:SetAttribute("ShowScale", t3.scale)
        clone2:SetAttribute("ShowScale", t3.scale)
        t1[p2] = t3

        return t3
    end

    local elapsed = os.clock()
    local t4

    local function place(p3) -- line: 233
        -- upvalues: TweenService (copy), RollBase (copy), elapsed (copy), t4 (ref)
        local e, model = t4.e, t4.model
        local v30 = math.clamp((p3 - t4.t0) / t4.dur, 0, 1)

        v30 = t4.ease and TweenService:GetValue(v30, t4.ease, t4.dir) or v30

        local v32 = math.max(0.001, t4.s0 + (t4.s1 - t4.s0) * v30)

        if v32 ~= t4.s then
            model:ScaleTo(e.scale * v32)
            t4.s = v32
        end

        local v33 = p3 - elapsed
        local RollBasePosition = RollBase.Position
        local v36 = RollBasePosition.Y + e.half + math.sin(v33 * 0.9) * 0.6

        if t4.rise then
            v36 = t4.rise + (v36 - t4.rise) * v30
        end

        local v41 = CFrame.Angles(0, v33 * 0.5235987755982988, 0) * CFrame.Angles(math.sin(v33 * 0.9) * 0.05235987755982989, 0, math.cos(v33 * 0.9 * 0.8) * 0.05235987755982989)

        model:PivotTo(CFrame.new(RollBasePosition.X, v36, RollBasePosition.Z) * v41 * CFrame.new(-e.centre * v32) * e.rot)

        if t4.fade then
            for _, v42 in ipairs(e.fade) do
                v42.part.Transparency = v42.t + (1 - v42.t) * math.clamp(v30, 0, 1)
            end
        end
    end

    local function show(p4, p5, p6, p7, p8, p9, p10, p11, p12) -- line: 259
        -- upvalues: Folder (copy), t4 (ref), place (copy)
        if t4 and t4.model ~= p5 then
            t4.model.Parent = nil
        end

        t4 = {
            e = p4,
            model = p5,
            s0 = p6,
            s1 = p7,
            t0 = os.clock(),
            dur = p8,
            ease = p9,
            dir = p10,
            rise = p11,
            fade = p12
        }
        place(os.clock())
        p5.Parent = Folder
    end

    local function clear() -- line: 267
        -- upvalues: t4 (ref)
        if not t4 then
            return
        end

        t4.model.Parent = nil

        for _, v43 in ipairs(t4.e.fade) do
            v43.part.Transparency = v43.t
        end

        t4 = nil
    end

    RunService.RenderStepped:Connect(function() -- line: 276
        -- upvalues: Players (copy), t4 (ref), place (copy)
        if t4 and not Players.LocalPlayer:GetAttribute("CameraUnderwater") then
            place(os.clock())
        end
    end)

    local v44 = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local roll = WeatherConfig.HALLOWEEN.roll

    local function showTag(p13) -- line: 287
        -- upvalues: TweenService (copy), FishDisplay (copy), RarityDisplay (copy), RarityStyle (copy), Tag (copy), Pop (copy), Rarity (copy), Species (copy), v44 (copy), roll (copy)
        local v45 = FishDisplay[p13.species]
        local v46 = not v45 and p13.full:GetAttribute("Weather") == "Halloween" and roll[p13.species]
        local RarityDisplay2, shown, v47, v48

        if v46 then
            local Halloween = RarityDisplay.Halloween

            if Halloween then
                v47 = Halloween
                v48 = true
            elseif v45 then
                RarityDisplay2 = RarityDisplay
                shown = v45.shown or v45.rarity
                v48 = false
            else
                v47 = v45
                v48 = true
            end
        elseif v45 then
            RarityDisplay2 = RarityDisplay
            shown = v45.shown or v45.rarity
            v48 = false
        else
            v47 = v45
            v48 = true
        end

        if not v48 then
            v47 = RarityDisplay2[shown]
        end

        Rarity.Text = v47 and v47.display or ""

        if v47 then
            RarityStyle.Apply(Rarity, v47.color)
        end

        local v49, v50

        if v46 then
            v49 = v46
            v50 = true
        elseif v45 then
            local display = v45.display

            if display then
                v49 = display
                v50 = true
            else
                v50 = false
            end
        else
            v50 = false
        end

        Species.Text = if not v50 then p13.species else v49
        Tag.StudsOffsetWorldSpace = Vector3.new(0, 2 * p13.half + 1.5 + Tag.Size.Y.Scale / 2, 0)
        Pop.Scale = 0.5
        Tag.Enabled = true
        TweenService:Create(Pop, v44, {
            Scale = 1
        }):Play()
    end

    local t5 = {}

    for _, v52 in ipairs(Children) do
        local Weather = v52:GetAttribute("Weather")

        if Weather then
            t5[Weather] = true
        end
    end

    local function inSet(p14, p15) -- line: 309
        local t6 = {}

        for _, v53 in ipairs(p14) do
            if v53:GetAttribute("Weather") == p15 then
                t6[#t6 + 1] = v53
            end
        end

        return t6
    end

    local function activeSet() -- line: 317
        -- upvalues: WeatherConfig (copy), t5 (copy)
        local v54 = WeatherConfig.Now()

        if t5.Halloween and WeatherConfig.Halloween(v54) then
            return "Halloween"
        end

        local v55 = WeatherConfig.Active(v54)

        return if v55 and t5[v55] then v55 else nil
    end

    local function rollSet() -- line: 326
        -- upvalues: WeatherConfig (copy), Children (copy), t1 (copy), t5 (copy), inSet (copy)
        local v56 = WeatherConfig.Now()
        local v57

        if not (t5.Halloween and WeatherConfig.Halloween(v56)) then
            local v58 = WeatherConfig.Active(v56)

            if v58 and t5[v58] then
                v57 = v58
            end
        else
            v57 = "Halloween"
        end

        if not v57 then
            return nil
        end

        for _, v59 in ipairs((inSet(Children, v57))) do
            if not t1[v59] then
                return nil
            end
        end

        return v57
    end

    local function fromSet(p16) -- line: 337
        -- upvalues: Children (copy), v10 (copy), t1 (copy), inSet (copy)
        local v60 = inSet(Children, p16)

        if #v60 == 0 then
            v60 = Children
        end

        local t7 = {}

        for _, v61 in ipairs(v60) do
            if t1[v61] then
                t7[#t7 + 1] = v61
            end
        end

        if not (#t7 > 0) or not t7 then
            t7 = { v60[v10:NextInteger(1, #v60)] }
        end

        return t7
    end

    local function pick(p17) -- line: 347
        -- upvalues: v10 (copy), prep (copy), fromSet (copy)
        local v62 = fromSet(p17)

        return (prep(v62[v10:NextInteger(1, #v62)]))
    end

    local t8 = {}
    local t9 = {}
    local v63

    local function pickWinner(p18) -- line: 360
        -- upvalues: v10 (copy), prep (copy), fromSet (copy), t8 (copy), t9 (copy), v63 (ref)
        local v64 = fromSet(p18)

        if p18 == "Halloween" then
            local t10 = {}

            for _, v65 in ipairs(v64) do
                if not t9[v65] then
                    t10[#t10 + 1] = v65
                end
            end

            if #t10 == 0 then
                table.clear(t9)

                for _, v66 in ipairs(v64) do
                    if v66 ~= v63 or #v64 == 1 then
                        t10[#t10 + 1] = v66
                    end
                end
            end

            local v67 = t10[v10:NextInteger(1, #t10)]

            t9[v67] = true
            v63 = v67

            return (prep(v67))
        end

        local v73 = math.max(0, (math.min(#v64 - 2, (math.max(7, (math.floor(#v64 * 0.18421052631578946)))))))
        local t11 = {}

        for _, v74 in ipairs(v64) do
            local v75 = table.find(t8, v74)

            if not v75 or v75 <= #t8 - v73 then
                t11[#t11 + 1] = v74
            end
        end

        if #t11 ~= 0 then
            v64 = t11
        end

        local v76 = v64[v10:NextInteger(1, #v64)]
        local v77 = table.find(t8, v76)

        if v77 then
            table.remove(t8, v77)
        end

        table.insert(t8, v76)

        if #t8 > 30 then
            table.remove(t8, 1)
        end

        return (prep(v76))
    end

    local function runOneRoll() -- line: 394
        -- upvalues: VFXBurst (copy), WeatherConfig (copy), Tag (copy), Explosion (copy), Children (copy), v10 (copy), t1 (copy), prep (copy), t4 (ref), show (copy), showTag (copy), t5 (copy), inSet (copy), fromSet (copy), pickWinner (copy)
        for i = 20, 1, -1 do
            local v78 = WeatherConfig.Now()
            local v79

            if not (t5.Halloween and WeatherConfig.Halloween(v78)) then
                local v80 = WeatherConfig.Active(v78)

                if v80 and t5[v80] then
                    v79 = v80
                end
            else
                v79 = "Halloween"
            end

            local v81

            if v79 then
                local v82 = false

                for _, v83 in ipairs((inSet(Children, v79))) do
                    if not t1[v83] then
                        v81 = nil
                        v82 = true
                        break
                    end
                end

                if not v82 then
                    v81 = v79
                end
            end

            local v84 = fromSet(v81)
            local v85 = prep(v84[v10:NextInteger(1, #v84)])

            if i == 20 then
                show(v85, v85.sil, 0.15, 1, 0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -6)
                task.wait(0.35)
            else
                show(v85, v85.sil, 0.5, 1, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.InOut)

                local v86 = 1 - i / 20

                task.wait((v86 ^ 2 * 0.255 + 0.032) * 0.8)
            end
        end

        local v87 = WeatherConfig.Now()
        local v88

        if not (t5.Halloween and WeatherConfig.Halloween(v87)) then
            local v89 = WeatherConfig.Active(v87)

            if v89 and t5[v89] then
                v88 = v89
            end
        else
            v88 = "Halloween"
        end

        local v90

        if v88 then
            local v91 = false

            for _, v92 in ipairs((inSet(Children, v88))) do
                if not t1[v92] then
                    v90 = nil
                    v91 = true
                    break
                end
            end

            if not v91 then
                v90 = v88
            end
        end

        local v93 = pickWinner(v90)

        show(v93, v93.full, 0.5, 1, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.InOut)
        showTag(v93)
        task.wait(5)
        Tag.Enabled = false

        local Position = v93.full:GetBoundingBox().Position

        VFXBurst.Play(Explosion, CFrame.new(Position), v93.length * 0.1)
        show(v93, v93.full, 1, 0, 0.28, Enum.EasingStyle.Back, Enum.EasingDirection.In, nil, true)
        task.wait(0.28)

        if not t4 then
            return
        end

        t4.model.Parent = nil

        for _, v94 in ipairs(t4.e.fade) do
            v94.part.Transparency = v94.t
        end

        t4 = nil
    end

    local function rollLoop() -- line: 425
        -- upvalues: Tag (copy), t4 (ref), runOneRoll (copy)
        while true do
            local ok, result = pcall(runOneRoll)

            if ok then
                task.wait(0.25)
                continue
            end

            warn("[FishRoll] roll error:", result)

            if t4 then
                t4.model.Parent = nil

                for _, v95 in ipairs(t4.e.fade) do
                    v95.part.Transparency = v95.t
                end

                t4 = nil
            end

            Tag.Enabled = false
            task.wait(2)
            task.wait(0.25)
        end
    end

    local v96 = task.spawn(rollLoop)

    task.spawn(function() -- line: 448
        -- upvalues: ContentProvider (copy), WeatherConfig (copy), Children (copy), t1 (copy), prep (copy), t5 (copy), inSet (copy)
        local v97 = t5.Halloween and WeatherConfig.HalloweenNext(WeatherConfig.Now()) ~= nil

        local function nextToMake() -- line: 450
            -- upvalues: v97 (copy), WeatherConfig (copy), Children (copy), t1 (copy), t5 (copy), inSet (copy)
            local v98 = WeatherConfig.Now()
            local v99

            if not (t5.Halloween and WeatherConfig.Halloween(v98)) then
                local v100 = WeatherConfig.Active(v98)

                if v100 and t5[v100] then
                    v99 = v100
                end
            else
                v99 = "Halloween"
            end

            if v99 then
                for _, v101 in ipairs((inSet(Children, v99))) do
                    if not t1[v101] then
                        return v101
                    end
                end
            end

            for _, v102 in ipairs(Children) do
                if not t1[v102] and v102:GetAttribute("Weather") ~= "Halloween" then
                    return v102
                end
            end

            if v97 then
                for _, v103 in ipairs((inSet(Children, "Halloween"))) do
                    if not t1[v103] then
                        return v103
                    end
                end
            end

            return nil
        end

        while true do
            task.wait(1)

            local v104 = nextToMake()

            if v104 then
                local function v105() -- line: 471
                    -- upvalues: v104 (copy), ContentProvider (copy)
                    ContentProvider:PreloadAsync({
                        v104
                    })
                end

                pcall(v105)
                prep(v104)
                continue
            end

            break
        end
    end)

    local n1 = 0

    FishRoll:GetAttributeChangedSignal("HoldUntil"):Connect(function() -- line: 478
        -- upvalues: FishRoll (copy), Tag (copy), t4 (ref), show (copy), rollLoop (copy), v96 (ref), n1 (ref)
        local HoldUntil = FishRoll:GetAttribute("HoldUntil")

        if type(HoldUntil) ~= "number" then
            return
        end

        n1 += 1

        local v106 = n1

        if coroutine.status(v96) ~= "dead" then
            task.cancel(v96)
        end

        Tag.Enabled = false

        if t4 then
            local t12 = t4

            show(t12.e, t12.model, t12.s or 1, 0, 0.12, Enum.EasingStyle.Back, Enum.EasingDirection.In, nil, t12.model == t12.e.full)
            task.delay(0.12, function() -- line: 489
                -- upvalues: v106 (copy), t12 (copy), t4 (ref), n1 (ref)
                if n1 ~= v106 or not t4 or t4.model ~= t12.model or not t4 then
                    return
                end

                t4.model.Parent = nil

                for _, v109 in ipairs(t4.e.fade) do
                    v109.part.Transparency = v109.t
                end

                t4 = nil
            end)
        end

        task.delay(math.max(0, HoldUntil - os.clock()), function() -- line: 493
            -- upvalues: v106 (copy), t4 (ref), rollLoop (copy), v96 (ref), n1 (ref)
            if n1 ~= v106 then
                return
            end

            if t4 then
                t4.model.Parent = nil

                for _, v111 in ipairs(t4.e.fade) do
                    v111.part.Transparency = v111.t
                end

                t4 = nil
            end

            v96 = task.spawn(rollLoop)
        end)
    end)

    local t13 = {
        SOUND = 139682612041479,
        VOLUME = 2,
        EVERY = 0,
        CHANGES = 3,
        TAG_UP = 14,
        ROLLOFF = { 80, 1200 },
        GLYPHS = {
            "Ξ",
            "Ψ",
            "Ω",
            "Σ",
            "Δ",
            "Φ",
            "Θ",
            "Λ",
            "Π",
            "Γ",
            "∇",
            "∑",
            "∏",
            "∫",
            "∮",
            "⊕",
            "⊗",
            "⊙"
        },
        LENGTHS = {
            title = 9,
            timer = 4,
            rarity = 6,
            species = 8
        }
    }
    local Sound = Instance.new("Sound")

    Sound.Name = "TitanHijack"
    Sound.SoundId = "rbxassetid://" .. t13.SOUND
    Sound.Volume = t13.VOLUME
    Sound.RollOffMode = Enum.RollOffMode.InverseTapered

    local v112 = t13.ROLLOFF[1]
    local v113 = t13.ROLLOFF[2]

    Sound.RollOffMinDistance = v112
    Sound.RollOffMaxDistance = v113
    Sound.Parent = RollBase
    task.spawn(function() -- line: 525
        -- upvalues: ContentProvider (copy), Sound (copy)
        local function v114() -- line: 525
            -- upvalues: ContentProvider (copy), Sound (copy)
            ContentProvider:PreloadAsync({
                Sound
            })
        end

        pcall(v114)
    end)

    local Title = Board:WaitForChild("Title")
    local Text = Title.Text
    local t14 = {
        title = Title,
        timer = Timer,
        rarity = Rarity,
        species = Species
    }
    local t15 = {}
    local t16 = {}

    local function glyphs(p19) -- line: 534
        -- upvalues: v10 (copy), t13 (copy)
        local t17 = {}

        for i = 1, p19 do
            t17[i] = t13.GLYPHS[v10:NextInteger(1, #t13.GLYPHS)]
        end

        return t17
    end

    local function hijackOn() -- line: 539
        -- upvalues: RarityStyle (copy), JURASSIC_TITAN (copy), Tag (copy), Pop (copy), v5 (ref), t4 (ref), show (copy), v96 (ref), n1 (ref), t13 (copy), t14 (copy), t15 (copy), t16 (copy), glyphs (copy)
        v5 = true

        if coroutine.status(v96) ~= "dead" then
            task.cancel(v96)
        end

        n1 += 1

        if t4 then
            local t18 = t4

            show(t18.e, t18.model, t18.s or 1, 0, 0.12, Enum.EasingStyle.Back, Enum.EasingDirection.In, nil, t18.model == t18.e.full)
            task.delay(0.12, function() -- line: 546
                -- upvalues: t18 (copy), v5 (ref), t4 (ref)
                if not v5 or not t4 or t4.model ~= t18.model or not t4 then
                    return
                end

                t4.model.Parent = nil

                for _, v117 in ipairs(t4.e.fade) do
                    v117.part.Transparency = v117.t
                end

                t4 = nil
            end)
        end

        for v118, v119 in pairs(t14) do
            local Grad = v119:FindFirstChild("Grad")
            local UIStroke = v119:FindFirstChildOfClass("UIStroke")

            t15[v119] = {
                text = v119.TextColor3,
                grad = Grad and Grad.Color or false,
                stroke = UIStroke and UIStroke.Color
            }
            t16[v118] = glyphs(t13.LENGTHS[v118])
            v119.Text = table.concat(t16[v118])
            RarityStyle.Track(v119, JURASSIC_TITAN.COLOR)
        end

        Tag.StudsOffsetWorldSpace = Vector3.new(0, t13.TAG_UP, 0)
        Pop.Scale = 1
        Tag.Enabled = true
    end

    local function hijackOff() -- line: 559
        -- upvalues: RarityStyle (copy), Tag (copy), Grad (copy), v1 (copy), v4 (ref), v5 (ref), t4 (ref), rollLoop (copy), v96 (ref), Title (copy), Text (copy), t15 (copy)
        v5 = false

        for v120, v121 in pairs(t15) do
            RarityStyle.Track(v120, nil)

            local Grad = v120:FindFirstChild("Grad")
            local UIStroke = v120:FindFirstChildOfClass("UIStroke")

            if v121.grad then
                if Grad then
                    Grad.Color = v121.grad
                end
            elseif Grad then
                Grad:Destroy()
            end

            v120.TextColor3 = v121.text

            if UIStroke and v121.stroke then
                UIStroke.Color = v121.stroke
            end
        end

        table.clear(t15)
        Title.Text = Text
        Grad.Color = v1
        v4 = nil
        Tag.Enabled = false

        if t4 then
            t4.model.Parent = nil

            for _, v122 in ipairs(t4.e.fade) do
                v122.part.Transparency = v122.t
            end

            t4 = nil
        end

        v96 = task.spawn(rollLoop)
    end

    local n2 = 0

    RunService.Heartbeat:Connect(function(p20) -- line: 581
        -- upvalues: TitanConfig (copy), v5 (ref), v10 (copy), t13 (copy), Sound (copy), t14 (copy), t16 (copy), hijackOn (copy), hijackOff (copy), n2 (ref)
        local v123 = TitanConfig.Now()
        local v124 = TitanConfig.Hijacked(v123)

        if v124 ~= v5 then
            if v124 then
                hijackOn()

                local v125 = TitanConfig.Current(v123)

                if v125 and v123 - (v125 - TitanConfig.SONG) < 1 then
                    Sound.TimePosition = 0
                    Sound:Play()
                end
            else
                hijackOff()
            end
        end

        if v5 then
            n2 += p20

            if not (n2 < t13.EVERY) then
                n2 = 0

                for v127, v128 in pairs(t14) do
                    local v129 = t16[v127]

                    for _ = 1, t13.CHANGES do
                        v129[v10:NextInteger(1, #v129)] = t13.GLYPHS[v10:NextInteger(1, #t13.GLYPHS)]
                    end

                    v128.Text = table.concat(v129)
                end
            end
        end
    end)
end
