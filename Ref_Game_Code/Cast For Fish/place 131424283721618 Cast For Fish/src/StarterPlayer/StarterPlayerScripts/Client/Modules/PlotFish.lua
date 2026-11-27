-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local FishModels = require(Shared.FishModels)
local Fish = require(Shared.Data.Fish)
local Variants = require(Shared.Data.Variants)
local Sizes = require(Shared.Data.Sizes)
local Events = require(Shared.Data.Events)
local Roll = require(Shared.Roll)
local NumberFormat = require(Shared.NumberFormat)
local PlotFrame = require(Shared:WaitForChild("PlotFrame"))
local DataClient = require(script.Parent.DataClient)
local t1 = {}
local t2 = {}
local t3 = {}
local Folder
local n1 = 0
local v1 = false
local LocalPlayer = Players.LocalPlayer

local function pondOf(p1) -- line: 54
    -- upvalues: PlotFrame (copy)
    local Pond = p1:FindFirstChild("Pond")
    local Water = Pond and Pond:FindFirstChild("Water")

    if not Water then
        return PlotFrame.Of(p1) * CFrame.new(0, 0, 36), 82.5, 36
    end

    local _CFrame = Water.CFrame

    return CFrame.new(_CFrame.X, 0, _CFrame.Z) * _CFrame.Rotation, Water.Size.X / 2, Water.Size.Z / 2
end

local sin, cos, exp, clamp = math.sin, math.cos, math.exp, math.clamp
local v2 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local v4 = if v2 then 4 else 10
local v3 = if v2 then 90 else 150
local v5 = v3 - 30
local v6 = if v2 then 2 else 4

t1.IsMobile = v2
t1.OtherPlotCap = v4

local t4 = {}

t4.__index = t4

function t4.new(p2) -- line: 81
    -- upvalues: t4 (copy)
    local self = setmetatable({}, t4)

    self.Cap = p2

    return self
end

function t4.IsOwn(_, p4) -- line: 87
    -- upvalues: LocalPlayer (copy)
    return p4:GetAttribute("OwnerUserId") == LocalPlayer.UserId
end

function t4.Score(_, p6) -- line: 91
    -- upvalues: Roll (copy)
    local income = Roll.income
    local Id = p6:GetAttribute("Id")
    local v8 = p6:GetAttribute("V") or 1
    local v9 = p6:GetAttribute("S") or 1
    local v10 = p6:GetAttribute("E") or ""
    local ok, result = pcall(income, Id, v8, v9, v10, p6:GetAttribute("B"))

    if not ok or type(result) ~= "number" then
        return 0
    end

    return result
end

function t4:Shown(p8) -- line: 96
    -- upvalues: Fish (copy)
    local Placed = p8:FindFirstChild("Placed")
    local t6 = {}

    for _, v11 in ipairs(Placed and Placed:GetChildren() or {}) do
        local Id = v11:GetAttribute("Id")

        if type(Id) == "string" and Fish.ById[Id] then
            table.insert(t6, {
                cfg = v11,
                score = self:Score(v11)
            })
        end
    end

    table.sort(t6, function(p9, p10) -- line: 105
        if p9.score == p10.score then
            return p9.cfg.Name < p10.cfg.Name
        end

        return p9.score > p10.score
    end)

    local t8 = {}

    for i = 1, math.min(self.Cap, #t6) do
        t8[t6[i].cfg] = true
    end

    return t8
end

function t4:Allowed(p12, p13) -- line: 118
    if self:IsOwn(p13) then
        return true
    end

    return self:Shown(p13)[p12] == true
end

local v13 = t4.new(v4)
local t9 = {}

t9.__index = t9

function t9:ColorOf() -- line: 130
    local n2 = 0
    local n3 = 0
    local n4 = 0
    local n5 = 0

    for _, descendant in ipairs(self:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant.Transparency < 0.9 then
            local v14 = descendant.Size.X * descendant.Size.Y * descendant.Size.Z

            n2 += descendant.Color.R * v14
            n3 += descendant.Color.G * v14
            n4 += descendant.Color.B * v14
            n5 += v14
        end
    end

    if n5 <= 0 then
        return Color3.fromRGB(200, 200, 200)
    end

    return Color3.new(n2 / n5, n3 / n5, n4 / n5)
end

function t9:Strip() -- line: 147
    for _, descendant in ipairs(self:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
            descendant.CastShadow = false
        elseif descendant:IsA("JointInstance")
            or descendant:IsA("WeldConstraint")
            or descendant:IsA("Texture")
            or descendant:IsA("Decal")
            or descendant:IsA("ParticleEmitter")
            or descendant:IsA("Light")
            or descendant:IsA("Beam")
            or descendant:IsA("Trail")
            or descendant:IsA("BillboardGui") then
            descendant:Destroy()
        end
    end
end

function t9.new(p16, _) -- line: 161
    -- upvalues: t9 (copy)
    local self = setmetatable({}, t9)
    local clone = p16:Clone()

    clone.Name = "FishImpostor"
    t9.Strip(clone)
    clone:SetAttribute("Impostor", true)
    clone:PivotTo(p16:GetPivot())
    self.Model = clone

    return self
end

local function hex(p18) -- line: 172
    return string.format("#%02X%02X%02X", math.floor(p18.R * 255 + 0.5), math.floor(p18.G * 255 + 0.5), (math.floor(p18.B * 255 + 0.5)))
end

local v22 = math.log(132 / (12 * (Sizes.List[#Sizes.List].scale or 10) ^ 0.8)) / 2.908720896564361

function t1.ShownLength(p19, p20) -- line: 196
    -- upvalues: Sizes (copy), clamp (copy), v22 (copy)
    local v23 = (Sizes.List[p20] or Sizes.List[1]).scale or 1
    local v24 = p19 / v23

    if not (v24 <= 12) then
        v24 = 12 * (v24 / 12) ^ v22
    end

    local v25 = v24 * v23 ^ 0.8 * 3

    return (math.max(v25, (clamp(2.2 * v25 ^ 0.55, 2.5, 6))))
end

local function hidden(p21) -- line: 206
    -- upvalues: v1 (ref), LocalPlayer (copy)
    return v1 and p21:GetAttribute("OwnerUserId") ~= LocalPlayer.UserId
end

local function nameplate(p22) -- line: 210
    -- upvalues: Fish (copy), Variants (copy), Sizes (copy), Events (copy), Roll (copy), NumberFormat (copy)
    local Nameplate = p22.model:FindFirstChild("Nameplate")

    if Nameplate then
        Nameplate:Destroy()
    end

    local v28 = Fish.ById[p22.id]
    local v29 = Variants.List[p22.v] or Variants.List[1]
    local v30 = Sizes.List[p22.s] or Sizes.List[Sizes.NORMAL_INDEX]
    local v31 = Events.ById[p22.e]
    local v32 = if v31 then 20 else 0
    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "Nameplate"
    BillboardGui.Size = UDim2.fromOffset(300, v32 + 52)
    BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, p22.height / 2 + 1.6 + (if v31 then 0.5 else 0), 0)
    BillboardGui.MaxDistance = math.max(75, p22.length * 2.5)
    BillboardGui.LightInfluence = 0
    BillboardGui.Adornee = p22.model.PrimaryPart

    local function label(p23, p24, p25, p26, p27) -- line: 227
        -- upvalues: BillboardGui (copy)
        local TextLabel = Instance.new("TextLabel")

        TextLabel.BackgroundTransparency = 1
        TextLabel.Size = UDim2.new(1, 0, 0, p25)
        TextLabel.Position = UDim2.fromOffset(0, p24)
        TextLabel.Font = Enum.Font.FredokaOne
        TextLabel.RichText = true
        TextLabel.Text = p23
        TextLabel.TextSize = p25 - 2
        TextLabel.TextScaled = true

        local UITextSizeConstraint = Instance.new("UITextSizeConstraint")

        UITextSizeConstraint.MaxTextSize = p25 - 2
        UITextSizeConstraint.MinTextSize = 8
        UITextSizeConstraint.Parent = TextLabel
        TextLabel.TextColor3 = p26

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Thickness = 2.5
        UIStroke.Color = p27
        UIStroke.LineJoinMode = Enum.LineJoinMode.Round
        UIStroke.Parent = TextLabel
        TextLabel.Parent = BillboardGui

        return TextLabel
    end

    if v31 then
        label(("%s %s x%d"):format(v31.icon, string.upper(v31.mutation), v31.mult), 0, 20, v31.Color, Color3.fromRGB(14, 14, 22))
    end

    local v35

    if v29.index and v29.index >= 2 then
        local Color = v29.Color

        v35 = ("<font color=\"%s\">%s</font> "):format(string.format("#%02X%02X%02X", math.floor(Color.R * 255 + 0.5), math.floor(Color.G * 255 + 0.5), (math.floor(Color.B * 255 + 0.5))), v29.id)
    else
        v35 = ""
    end

    if v30.index ~= Sizes.NORMAL_INDEX then
        local Color = v30.Color

        v35 ..= ("<font color=\"%s\">%s</font> "):format(string.format("#%02X%02X%02X", math.floor(Color.R * 255 + 0.5), math.floor(Color.G * 255 + 0.5), (math.floor(Color.B * 255 + 0.5))), v30.id)
    end

    label(v35 .. v28.name, v32, 22, Color3.new(1, 1, 1), Color3.fromRGB(14, 14, 22))
    label(NumberFormat.rate(Roll.income(p22.id, p22.v, p22.s, p22.e, p22.b)), v32 + 22, 28, Color3.fromRGB(120, 235, 90), Color3.fromRGB(20, 70, 26))
    BillboardGui.Parent = p22.model
end

local function aura(p28, p29) -- line: 266
    -- upvalues: Events (copy), Folder (ref), clamp (copy)
    local EventAura = p28.model:FindFirstChild("EventAura")

    if EventAura then
        EventAura:Destroy()
    end

    local v46 = Events.ById[p28.e]

    if not v46 then
        return
    end

    local BoundingBox, BoundingBox2 = p28.model:GetBoundingBox()
    local Part = Instance.new("Part")

    Part.Name = "EventAura"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = BoundingBox2 * 0.85
    Part.CFrame = BoundingBox
    Part:SetAttribute("NoStuds", true)

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "Sparks"
    ParticleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter.Color = ColorSequence.new(Color3.new(1, 1, 1), v46.Color)
    ParticleEmitter.LightEmission = 0.9

    local v48 = clamp(p28.length * 0.07, 0.5, 3)

    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.25, v48),
        NumberSequenceKeypoint.new(1, 0)
    })
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Lifetime = NumberRange.new(0.7, 1.3)
    ParticleEmitter.Speed = NumberRange.new(0.4, 1.6 + p28.length * 0.04)
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter.Rotation = NumberRange.new(0, 360)
    ParticleEmitter.RotSpeed = NumberRange.new(-90, 90)
    ParticleEmitter.Shape = Enum.ParticleEmitterShape.Box
    ParticleEmitter.Rate = clamp(6 + p28.length * 0.5, 8, 28)
    ParticleEmitter.Parent = Part
    Part.Parent = p28.model

    if not p29 then
        return
    end

    ParticleEmitter:Emit(40)

    local Part2 = Instance.new("Part")

    Part2.Name = "MutateFlash"
    Part2.Shape = Enum.PartType.Ball
    Part2.Anchored = true
    Part2.CanCollide = false
    Part2.CanQuery = false
    Part2.CanTouch = false
    Part2.CastShadow = false
    Part2.Material = Enum.Material.Neon
    Part2.Color = v46.Color
    Part2.Transparency = 0.25

    local v50 = math.max(BoundingBox2.X, BoundingBox2.Y, BoundingBox2.Z)

    Part2.Size = Vector3.new(1, 1, 1) * v50 * 0.4
    Part2.CFrame = BoundingBox
    Part2:SetAttribute("NoStuds", true)
    Part2.Parent = Folder
    game:GetService("TweenService"):Create(Part2, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 1,
        Size = Vector3.new(1, 1, 1) * v50 * 1.5
    }):Play()
    game:GetService("Debris"):AddItem(Part2, 0.8)
end

local function fitLoop(p30) -- line: 333
    -- upvalues: clamp (copy)
    local v54 = math.max(math.min(p30.reach + 0.8, 8), p30.reach * 0.75)

    p30.ax = math.max(p30.hx - v54, p30.hx * 0.25) * p30.axFactor
    p30.az = math.max(p30.hz - v54, (math.min(p30.hz * 0.3, 6))) * p30.azFactor

    local v61 = math.min(1, 20 / p30.reach)

    p30.w1 = clamp(p30.speed * p30.k1 / p30.ax, 0.015, (math.max(v61 * 0.5, 0.03)))
    p30.w2 = clamp(p30.speed * p30.k2 / p30.az, 0.015, (math.max(v61 * 0.4, 0.025)))
    p30.topSpeed = math.sqrt((p30.ax * p30.w1) ^ 2 + (p30.az * p30.w2) ^ 2)
end

local function stillPlaced(p31, p32) -- line: 345
    local Parent = p31.Parent

    if Parent ~= nil and Parent.Name == "Placed" then
        return Parent.Parent == p32
    end

    return false
end

local function awayFrom(p33) -- line: 350
    local CFramePosition = workspace.CurrentCamera.CFrame.Position
    local pcfPosition = p33.pcf.Position

    return math.abs(CFramePosition.X - pcfPosition.X) + math.abs(CFramePosition.Z - pcfPosition.Z) - p33.length * 0.5 - math.max(p33.hx, p33.hz)
end

local function toImpostor(p34) -- line: 356
    -- upvalues: CollectionService (copy), Folder (ref), t9 (copy), nameplate (copy), aura (copy)
    if p34.impostor then
        return
    end

    local v73 = t9.new(p34.model, p34.color)

    p34.model:Destroy()
    p34.model = v73.Model
    p34.impostor = true
    nameplate(p34)
    aura(p34, false)
    CollectionService:AddTag(v73.Model, "OthersFish")
    v73.Model.Parent = Folder
end

local function build(p35, p36, p37) -- line: 370
    -- upvalues: CollectionService (copy), FishModels (copy), Fish (copy), Sizes (copy), t2 (copy), t3 (copy), Folder (ref), v1 (ref), LocalPlayer (copy), pondOf (copy), clamp (copy), v3 (copy), v13 (copy), t9 (copy), v22 (copy), nameplate (copy), aura (copy), fitLoop (copy), toImpostor (copy)
    if t2[p35] or t3[p35] or v1 and p36:GetAttribute("OwnerUserId") ~= LocalPlayer.UserId then
        return
    end

    local Parent = p35.Parent

    if Parent ~= nil and Parent.Name == "Placed" and Parent.Parent == p36 and v13:Allowed(p35, p36) then
        local Id = p35:GetAttribute("Id")

        if type(Id) == "string" and Fish.ById[Id] then
            local v74 = p35:GetAttribute("V") or 1
            local v75 = p35:GetAttribute("S") or 1
            local v76 = tonumber(string.match(p36.Name, "%d+")) or 3
            local v77 = tonumber(p35.Name) or 0

            t3[p35] = true

            local Get = FishModels.Get
            local ok, result = pcall(Get, Id, v74, v75)

            t3[p35] = nil

            if ok then
                if not t2[p35] and (not v1 or p36:GetAttribute("OwnerUserId") == LocalPlayer.UserId) then
                    local Parent = p35.Parent

                    if Parent ~= nil and Parent.Name == "Placed" and Parent.Parent == p36 and v13:Allowed(p35, p36) then
                        result:PivotTo(CFrame.new())

                        local _, BoundingBox = result:GetBoundingBox()
                        local v78 = math.max(BoundingBox.X, BoundingBox.Y, BoundingBox.Z, 0.1)
                        local v79 = (Sizes.List[v75] or Sizes.List[1]).scale or 1
                        local v80 = v78 / v79

                        if not (v80 <= 12) then
                            v80 = 12 * (v80 / 12) ^ v22
                        end

                        local v81 = v80 * v79 ^ 0.8 * 3
                        local v84 = math.max(v81, (clamp(2.2 * v81 ^ 0.55, 2.5, 6)))

                        result:ScaleTo(result:GetScale() * v84 / v78)
                        result:PivotTo(CFrame.new())

                        local _, BoundingBox2 = result:GetBoundingBox()
                        local v85 = FishModels.CenterOffset(result)

                        for _, descendant in ipairs(result:GetDescendants()) do
                            if descendant:IsA("BasePart") then
                                descendant.CanCollide = false
                                descendant.CanQuery = false
                                descendant.CanTouch = false
                                descendant.CastShadow = false
                            elseif descendant:IsA("PointLight") then
                                descendant.Range = math.min(descendant.Range, 8)
                            end
                        end

                        if p36:GetAttribute("OwnerUserId") ~= LocalPlayer.UserId then
                            for _, descendant in ipairs(result:GetDescendants()) do
                                if descendant:IsA("Texture") or descendant:IsA("PointLight") then
                                    descendant:Destroy()
                                end
                            end
                        end

                        local v86 = Random.new(v77 * 7919 + v76)
                        local v87, v88, v89 = pondOf(p36)
                        local v90 = 1 / (v84 / 9 + 1)
                        local v91, v92

                        if v84 <= 14 then
                            v91 = 1.6 + BoundingBox2.Y * 0.5 + v84 * 0.12
                            v92 = v84 * 0.04 + 1.15
                        elseif v84 <= 40 then
                            v91 = BoundingBox2.Y * 0.14
                            v92 = 3
                        else
                            v91 = 0
                            v92 = 1
                        end

                        local t11 = {
                            cfg = p35,
                            plot = p36,
                            pcf = v87,
                            hx = v88,
                            hz = v89,
                            reach = math.max(BoundingBox2.X, BoundingBox2.Z) / 2,
                            axFactor = v86:NextNumber(0.55, 1),
                            azFactor = v86:NextNumber(0.55, 1),
                            speed = math.min(v84 * 0.07 + 2.4, 12),
                            k1 = v86:NextNumber(0.75, 1.05),
                            k2 = v86:NextNumber(0.3, 0.55),
                            uid = v77,
                            model = result,
                            id = Id,
                            v = v74,
                            s = v75,
                            e = p35:GetAttribute("E") or "",
                            b = p35:GetAttribute("B"),
                            length = v84,
                            height = BoundingBox2.Y,
                            p1 = v86:NextNumber(0, 6.283185307179586),
                            p2 = v86:NextNumber(0, 6.283185307179586),
                            y = math.max(BoundingBox2.Y * 0.16, BoundingBox2.Y / 2 - 2) + 0.9 - v85.Y,
                            cOffX = v85.X,
                            cOffZ = v85.Z,
                            bob = clamp(v84 * 0.008 + 0.1, 0.1, 0.6),
                            bobRate = (v90 * 0.55 + 0.45) * 1.7,
                            bobPhase = v86:NextNumber(0, 6),
                            hop = v91,
                            hopTime = v92,
                            hopEvery = v86:NextNumber(11, 24) + (not (v91 > 0 and v84 > 14) and 0 or 10),
                            hopOffset = v86:NextNumber(0, 24),
                            tailRate = v90 * 6 + 5,
                            turnRate = v90 * 4.6 + 0.9,
                            bank = v90 * 0.5,
                            yaw = nil,
                            turn = 0,
                            phase = v86:NextNumber(0, 6),
                            acc = 0,
                            born = if p37 then os.clock() - 1 else os.clock(),
                            color = t9.ColorOf(result),
                            own = v13:IsOwn(p36)
                        }

                        fitLoop(t11)
                        t2[p35] = t11
                        nameplate(t11)
                        aura(t11, false)
                        result:PivotTo(v87 + Vector3.new(0, 0.9, 0))

                        if not t11.own then
                            CollectionService:AddTag(result, "OthersFish")
                        end

                        result.Parent = Folder

                        if not t11.own then
                            local CFramePosition = workspace.CurrentCamera.CFrame.Position
                            local pcfPosition = t11.pcf.Position

                            if math.abs(CFramePosition.X - pcfPosition.X) + math.abs(CFramePosition.Z - pcfPosition.Z) - t11.length * 0.5 - math.max(t11.hx, t11.hz) > v3 then
                                toImpostor(t11)
                            end
                        end

                        p35:GetAttributeChangedSignal("E"):Connect(function() -- line: 477
                            -- upvalues: p35 (copy), t11 (copy), t2 (copy), nameplate (copy), aura (copy)
                            if t2[p35] ~= t11 then
                                return
                            end

                            local v104 = p35:GetAttribute("E") or ""

                            if v104 ~= t11.e then
                                t11.e = v104
                                nameplate(t11)
                                aura(t11, v104 ~= "")
                            end
                        end)
                        p35:GetAttributeChangedSignal("B"):Connect(function() -- line: 489
                            -- upvalues: p35 (copy), t11 (copy), t2 (copy), nameplate (copy)
                            if t2[p35] == t11 and t11.b ~= p35:GetAttribute("B") then
                                t11.b = p35:GetAttribute("B")
                                nameplate(t11)
                            end
                        end)

                        return
                    end
                end

                result:Destroy()
            end
        end
    end
end

local function add(p38, p39, p40) -- line: 497
    -- upvalues: t2 (copy), t3 (copy), Folder (ref), build (copy)
    local ok, result = pcall(build, p38, p39, p40)

    if ok then
        return
    end

    t3[p38] = nil

    local v106 = t2[p38]

    if v106 and v106.model and v106.model.Parent ~= Folder then
        t2[p38] = nil
        v106.model:Destroy()
    end

    warn("[PlotFish] " .. tostring(result))
end

local t12 = {}

t12.__index = t12

function t12.new() -- line: 513
    -- upvalues: t12 (copy)
    local self = setmetatable({}, t12)

    self.Plots = nil
    self.Built = 0

    return self
end

function t12:Sweep() -- line: 520
    -- upvalues: t2 (copy), t3 (copy), v1 (ref), LocalPlayer (copy), v13 (copy), add (copy)
    if self.Plots then
        for _, child in ipairs(self.Plots:GetChildren()) do
            local Placed = child:FindFirstChild("Placed")

            if Placed and (not v1 or child:GetAttribute("OwnerUserId") == LocalPlayer.UserId) then
                local v108 = v13:IsOwn(child)
                local v109 = if v108 then nil else v13:Shown(child)

                for _, child2 in ipairs(Placed:GetChildren()) do
                    if not t2[child2] and not t3[child2] and (v108 or v109[child2]) then
                        self.Built += 1
                        task.spawn(add, child2, child, true)
                    end
                end
            end
        end
    end
end

local v110 = t12.new()

t1.Repair = v110

local function remove(p42) -- line: 542
    -- upvalues: t2 (copy)
    local v111 = t2[p42]

    if v111 then
        t2[p42] = nil
        v111.model:Destroy()
    end
end

local function repond(p43) -- line: 551
    -- upvalues: t2 (copy), pondOf (copy), fitLoop (copy)
    local v112, v113, v114 = pondOf(p43)

    for _, v115 in pairs(t2) do
        if v115.plot == p43 then
            v115.pcf = v112
            v115.hx = v113
            v115.hz = v114
            fitLoop(v115)
        end
    end
end

local function refreshPlot(p44) -- line: 562
    -- upvalues: t2 (copy), v1 (ref), LocalPlayer (copy), v13 (copy), add (copy)
    if v1 and p44:GetAttribute("OwnerUserId") ~= LocalPlayer.UserId then
        for v116, v117 in pairs(t2) do
            if v117.plot == p44 then
                t2[v116] = nil
                v117.model:Destroy()
            end
        end
    else
        local v118 = v13:IsOwn(p44)
        local v119 = if v118 then nil else v13:Shown(p44)

        for v120, v121 in pairs(t2) do
            if v121.plot == p44 and (v121.own ~= v118 or v119 and not v119[v120]) then
                t2[v120] = nil
                v121.model:Destroy()
            end
        end

        local Placed = p44:FindFirstChild("Placed")

        for _, v122 in ipairs(Placed and Placed:GetChildren() or {}) do
            if v118 or v119[v122] then
                task.spawn(add, v122, p44, true)
            end
        end
    end
end

local function watch(p45) -- line: 588
    -- upvalues: t2 (copy), v13 (copy), add (copy), repond (copy), refreshPlot (copy)
    p45:GetAttributeChangedSignal("OwnerUserId"):Connect(function() -- line: 589
        -- upvalues: p45 (copy), refreshPlot (copy)
        refreshPlot(p45)
    end)
    task.spawn(function() -- line: 592
        -- upvalues: p45 (copy), repond (copy)
        local v123 = p45:WaitForChild("Pond", 30)
        local v124 = v123 and v123:WaitForChild("Water", 30)

        if not v124 then
            return
        end

        v124:GetPropertyChangedSignal("Size"):Connect(function() -- line: 596
            -- upvalues: p45 (copy), repond (copy)
            repond(p45)
        end)
        v124:GetPropertyChangedSignal("CFrame"):Connect(function() -- line: 599
            -- upvalues: p45 (copy), repond (copy)
            repond(p45)
        end)
        repond(p45)
    end)
    task.spawn(function() -- line: 605
        -- upvalues: p45 (copy), t2 (copy), v13 (copy), add (copy), refreshPlot (copy)
        local v125 = p45:WaitForChild("Placed", 30)

        if not v125 then
            return
        end

        v125.ChildAdded:Connect(function(p46) -- line: 610
            -- upvalues: p45 (copy), v13 (copy), add (copy), refreshPlot (copy)
            if v13:IsOwn(p45) then
                task.defer(add, p46, p45)
            else
                task.defer(refreshPlot, p45)
            end
        end)
        v125.ChildRemoved:Connect(function(p47) -- line: 617
            -- upvalues: p45 (copy), t2 (copy), v13 (copy), refreshPlot (copy)
            local v126 = t2[p47]

            if v126 then
                t2[p47] = nil
                v126.model:Destroy()
            end

            if not v13:IsOwn(p45) then
                task.defer(refreshPlot, p45)
            end
        end)

        for _, child in ipairs(v125:GetChildren()) do
            task.spawn(add, child, p45)
        end
    end)
end

local function animate(p48, p49, p50, p51) -- line: 629
    -- upvalues: FishModels (copy), sin (copy), cos (copy), exp (copy), clamp (copy)
    local v127 = math.max(p49, 0.004166666666666667)
    local v128 = p48.w1 * p50 + p48.p1
    local v129 = p48.w2 * p50 + p48.p2
    local v130 = p48.ax * sin(v128)
    local v131 = p48.az * sin(v129)
    local v132 = p48.ax * p48.w1 * cos(v128)
    local v133 = p48.az * p48.w2 * cos(v129)
    local v135 = math.sqrt(v132 * v132 + v133 * v133)
    local v137 = clamp(v135 / p48.topSpeed, 0, 1)
    local v138 = if v135 > 0.001 then math.atan2(-v132, -v133) else p48.yaw or 0

    if not p48.yaw then
        p48.yaw = v138
    end

    local v143 = ((v138 - p48.yaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * (1 - exp(-v127 * p48.turnRate))

    p48.yaw += v143
    p48.turn = p48.turn + (v143 / v127 - p48.turn) * (1 - exp(-v127 * 4))

    if p48.turn ~= p48.turn or p48.yaw ~= p48.yaw or p48.phase ~= p48.phase then
        p48.turn = 0
        p48.yaw = v138
        p48.phase = 0
    end

    local v147 = clamp(p48.turn * p48.bank, -0.38, 0.38)

    p48.phase += v127 * p48.tailRate * (v137 * 0.8 + 0.5)

    local v148 = sin(p48.phase)
    local v150 = p48.y + sin(p50 * p48.bobRate + p48.bobPhase) * p48.bob
    local v152 = sin(p50 * p48.bobRate * 0.6 + p48.bobPhase * 1.7) * 0.035
    local v153, v154, v155
    local v156 = v150
    local v157 = v152

    if p48.hop > 0 then
        local v158 = (p50 + p48.hopOffset) % p48.hopEvery

        if v158 < p48.hopTime then
            local v159 = v158 / p48.hopTime
            local v161 = sin(v159 * 3.141592653589793)

            v153 = v150 + v161 * v161 * p48.hop
            v156 = v153
            v154 = sin(v159 * 2 * 3.141592653589793)
            v155 = if p48.length <= 14 then 0.55 else 0.12
            v157 = v152 + v154 * v155
        end
    end

    local v163 = p51 - p48.born

    if v163 < 0.6 then
        v156 += (1 - v163 / 0.6) ^ 3 * 7
    end

    local v164 = CFrame.Angles(0, p48.yaw - v148 * 0.05 * (v137 * 0.6 + 0.4), 0)
    local v165 = CFrame.new(v130, v156, v131) * v164 * CFrame.new(-p48.cOffX, 0, -p48.cOffZ)

    p48.model:PivotTo(p48.pcf * v165 * CFrame.Angles(v157, 0, v147))

    if not p48.impostor then
        FishModels.Animate(p48.model, p50, nil, v137 * 0.16 + 0.26, p48.phase)
    end
end

local t14 = {}

t14.__index = t14
t14.INTERVAL = 0.2
t14.PAD = 4

function t14.new() -- line: 694
    -- upvalues: t14 (copy)
    return (setmetatable({
        Next = 0
    }, t14))
end

function t14.Step(p52, p53, p54) -- line: 698
    -- upvalues: Roll (copy), t14 (copy)
    if p54 < p52.Next then
        return
    end

    p52.Next = p54 + t14.INTERVAL

    local CurrentCamera = workspace.CurrentCamera
    local CFramePosition = CurrentCamera.CFrame.Position
    local t16 = {}

    for _, v166 in pairs(p53) do
        local Nameplate = v166.model:FindFirstChild("Nameplate")

        if Nameplate then
            local Adornee = Nameplate.Adornee

            if Adornee and Adornee:IsA("BasePart") then
                local v167 = Adornee.Position + Nameplate.StudsOffsetWorldSpace
                local Magnitude = (v167 - CFramePosition).Magnitude
                local v168, v169 = CurrentCamera:WorldToViewportPoint(v167)

                if v169 and Magnitude <= Nameplate.MaxDistance then
                    v166.rate = v166.rate or Roll.income(v166.id, v166.v, v166.s, v166.e, v166.b)

                    local AbsoluteSize = Nameplate.AbsoluteSize

                    table.insert(t16, {
                        gui = Nameplate,
                        x = v168.X,
                        y = v168.Y,
                        w = AbsoluteSize.X * 0.6,
                        h = AbsoluteSize.Y,
                        rate = v166.rate,
                        dist = Magnitude
                    })
                else
                    Nameplate.Enabled = true
                end
            end
        end
    end

    table.sort(t16, function(p55, p56) -- line: 722
        if p55.rate == p56.rate then
            return p55.dist < p56.dist
        end

        return p55.rate > p56.rate
    end)

    local t18 = {}
    local PAD = t14.PAD

    for _, v170 in ipairs(t16) do
        local v171 = true

        for _, v172 in ipairs(t18) do
            if math.abs(v170.x - v172.x) * 2 < v170.w + v172.w + PAD and math.abs(v170.y - v172.y) * 2 < v170.h + v172.h + PAD then
                v171 = false
                break
            end
        end

        v170.gui.Enabled = v171

        if v171 then
            table.insert(t18, v170)
        end
    end
end

local v175 = t14.new()

local function update(p57) -- line: 747
    -- upvalues: FishModels (copy), t2 (copy), Folder (ref), n1 (ref), v1 (ref), LocalPlayer (copy), v3 (copy), v5 (copy), toImpostor (copy), add (copy), v110 (copy), animate (copy), v175 (copy), v6 (copy)
    local v176 = math.min(p57, 0.1)

    n1 += 1

    local elapsed = os.clock()
    local ServerTimeNow = workspace:GetServerTimeNow()
    local CFrame = workspace.CurrentCamera.CFrame
    local CFramePosition, LookVector = CFrame.Position, CFrame.LookVector

    v175:Step(t2, elapsed)

    if n1 % 120 == 0 then
        local t19 = {}

        for v177, v178 in pairs(t2) do
            local v179 = v178.model.PrimaryPart and v178.model.PrimaryPart.Position
            local plot = v178.plot
            local Parent = v177.Parent

            if Parent ~= nil and Parent.Name == "Placed" and Parent.Parent == plot then
                local plot = v178.plot

                if v1 and plot:GetAttribute("OwnerUserId") ~= LocalPlayer.UserId then
                    t2[v177] = nil
                    v178.model:Destroy()
                elseif v178.model.Parent ~= Folder or not v179 or v179 ~= v179 or math.abs(v179.Y) > 5000 then
                    t2[v177] = nil
                    v178.model:Destroy()
                    table.insert(t19, {
                        v177,
                        v178.plot
                    })
                elseif v178.model:GetAttribute("Placeholder") then
                    if FishModels.Has(v178.id) then
                        t2[v177] = nil
                        v178.model:Destroy()
                        table.insert(t19, {
                            v177,
                            v178.plot
                        })
                    else
                        FishModels.Retry(v178.id)
                    end
                end
            else
                t2[v177] = nil
                v178.model:Destroy()
            end
        end

        local t23 = {}

        for _, v180 in pairs(t2) do
            t23[v180.model] = true
        end

        for _, child in ipairs(Folder:GetChildren()) do
            if child:IsA("Model") and not t23[child] then
                child:Destroy()
            end
        end

        for _, v181 in ipairs(t19) do
            task.spawn(add, v181[1], v181[2])
        end

        v110:Sweep()
    end

    if n1 % 20 == 0 then
        local t24 = {}

        for v182, v183 in pairs(t2) do
            if not v183.own then
                local CFramePosition = workspace.CurrentCamera.CFrame.Position
                local pcfPosition = v183.pcf.Position
                local v188 = math.abs(CFramePosition.X - pcfPosition.X) + math.abs(CFramePosition.Z - pcfPosition.Z) - v183.length * 0.5 - math.max(v183.hx, v183.hz)

                if v183.impostor then
                    if v183.impostor and v188 < v5 and #t24 < v6 then
                        t2[v182] = nil
                        v183.model:Destroy()
                        table.insert(t24, {
                            v182,
                            v183.plot
                        })
                    end
                elseif v3 < v188 then
                    toImpostor(v183)
                elseif v183.impostor and v188 < v5 and #t24 < v6 then
                    t2[v182] = nil
                    v183.model:Destroy()
                    table.insert(t24, {
                        v182,
                        v183.plot
                    })
                end
            end
        end

        for _, v189 in ipairs(t24) do
            task.spawn(add, v189[1], v189[2], true)
        end
    end

    for _, v190 in pairs(t2) do
        local pcfPosition = v190.pcf.Position
        local v191 = math.max(v190.hx, v190.hz)
        local v195 = math.abs(CFramePosition.X - pcfPosition.X) + math.abs(CFramePosition.Z - pcfPosition.Z) - v190.length * 0.5 - v191

        if v195 < 240 or not v190.placed then
            v190.acc += v176

            local v196 = Vector3.new(pcfPosition.X, 0, pcfPosition.Z) - CFramePosition
            local v197 = v195 > 30 and v196:Dot(LookVector) < -(v190.length * 0.5 + 40 + v191)

            if v190.placed then
                if not v197 then
                    if v195 < 190 then
                        animate(v190, math.min(v190.acc, 0.1), ServerTimeNow, elapsed)
                        v190.acc = 0
                        v190.placed = true
                    elseif n1 % 2 == 0 then
                        animate(v190, math.min(v190.acc, 0.1), ServerTimeNow, elapsed)
                        v190.acc = 0
                        v190.placed = true
                    end
                end
            else
                animate(v190, math.min(v190.acc, 0.1), ServerTimeNow, elapsed)
                v190.acc = 0
                v190.placed = true
            end
        end
    end
end

function t1.Count() -- line: 833
    -- upvalues: t2 (copy)
    local n6 = 0

    for _ in pairs(t2) do
        n6 += 1
    end

    return n6
end

function t1.ModelCount() -- line: 842
    -- upvalues: Folder (ref)
    local n7 = 0

    for _, v199 in ipairs(Folder and Folder:GetChildren() or {}) do
        if v199:IsA("Model") then
            n7 += 1
        end
    end

    return n7
end

function t1.Init() -- line: 852
    -- upvalues: RunService (copy), ReplicatedStorage (copy), DataClient (copy), Folder (ref), v1 (ref), v2 (copy), v110 (copy), refreshPlot (copy), watch (copy), update (copy)
    Folder = Instance.new("Folder")
    Folder.Name = "PlotFish"
    Folder.Parent = workspace
    task.spawn(function() -- line: 856
        -- upvalues: ReplicatedStorage (copy), DataClient (copy), v1 (ref), v2 (copy), v110 (copy), refreshPlot (copy), watch (copy)
        local Plots = workspace:WaitForChild("World"):WaitForChild("Plots")

        v110.Plots = Plots
        Plots.ChildAdded:Connect(watch)

        for _, child in ipairs(Plots:GetChildren()) do
            watch(child)
        end

        local function apply(p58) -- line: 863
            -- upvalues: Plots (copy), ReplicatedStorage (copy), v1 (ref), v2 (copy), refreshPlot (copy)
            if v2 and type(p58) == "table" and p58.HideOthersMobileSet == false then
                p58.HideOthersMobileSet = true
                p58.HideOthersFish = true

                local SetSetting = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SetSetting")

                task.spawn(function() -- line: 868
                    -- upvalues: SetSetting (copy)
                    SetSetting:InvokeServer("HideOthersMobileSet", true)
                    SetSetting:InvokeServer("HideOthersFish", true)
                end)
            end

            local v200 = type(p58) == "table" and p58.HideOthersFish == true

            if v200 ~= v1 then
                v1 = v200

                for _, child in ipairs(Plots:GetChildren()) do
                    refreshPlot(child)
                end
            end
        end

        DataClient.Observe("Settings", apply)
        apply(DataClient.Get("Settings"))
    end)
    RunService.RenderStepped:Connect(update)
end

return t1
