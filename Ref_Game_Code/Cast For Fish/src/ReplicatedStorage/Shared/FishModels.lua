-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Parent = script.Parent
local Fish = require(Parent.Data.Fish)
local Variants = require(Parent.Data.Variants)
local Sizes = require(Parent.Data.Sizes)
local StudPack = require(Parent.StudPack)
local t1 = {}
local fromRGB = Color3.fromRGB

local function assetsFolder() -- line: 16
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")

    return Assets and Assets:FindFirstChild("Fish")
end

local self = setmetatable({}, {
    __mode = "k"
})

local function preload(p1) -- line: 26
    task.spawn(function() -- line: 28
        -- upvalues: p1 (copy)
        local function v2() -- line: 29
            -- upvalues: p1 (copy)
            game:GetService("ContentProvider"):PreloadAsync({
                p1
            })
        end

        pcall(v2)
    end)
end

local function complete(p2) -- line: 34
    -- upvalues: RunService (copy), StudPack (copy), self (copy)
    if self[p2] then
        return true
    end

    local Pieces = p2:GetAttribute("Pieces")

    if type(Pieces) == "number" and not (Pieces <= #p2:GetDescendants()) then
        return false
    end

    self[p2] = true
    StudPack.Shared:Unpack(p2)

    if RunService:IsClient() then
        task.spawn(function() -- line: 28
            -- upvalues: p2 (copy)
            local function v3() -- line: 29
                -- upvalues: p2 (copy)
                game:GetService("ContentProvider"):PreloadAsync({
                    p2
                })
            end

            pcall(v3)
        end)
    end

    return true
end

local function locate(p3) -- line: 52
    -- upvalues: ReplicatedStorage (copy)
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local PlayerGui = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local FishCache = PlayerGui and PlayerGui:FindFirstChild("FishCache")
    local v4 = FishCache and FishCache:FindFirstChild(p3)

    if v4 then
        return v4
    end

    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local Fish = Assets and Assets:FindFirstChild("Fish")

    return Fish and Fish:FindFirstChild(p3)
end

local function hasParts(p4) -- line: 64
    return p4:FindFirstChildWhichIsA("BasePart", true) ~= nil
end

local function findBase(p5) -- line: 68
    -- upvalues: complete (copy), locate (copy)
    local v5 = locate(p5)

    return if v5 and complete(v5) then v5 else nil
end

function t1.Has(p6) -- line: 76
    -- upvalues: complete (copy), locate (copy)
    local v6 = locate(p6)

    if not (v6 and complete(v6)) then
        v6 = nil
    end

    return v6 ~= nil
end

t1.Base = findBase

local t4 = {}
local t5 = {}
local v7 = false

function t1.Prepare(p7) -- line: 86
    -- upvalues: ReplicatedStorage (copy), RunService (copy), Fish (copy), complete (copy), locate (copy), t4 (copy), t5 (ref), v7 (ref)
    if not RunService:IsClient() then
        return
    end

    for _, v8 in ipairs(p7) do
        if type(v8) == "string" and Fish.ById[v8] and not t4[v8] then
            local v9 = locate(v8)

            if not (v9 and complete(v9) and v9) then
                t4[v8] = true
                table.insert(t5, v8)
            end
        end
    end

    if #t5 > 0 and not v7 then
        v7 = true
        task.defer(function() -- line: 98
            -- upvalues: ReplicatedStorage (copy), t4 (copy), t5 (ref), v7 (ref)
            local t7 = t5

            t5 = {}
            v7 = false

            local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
            local v10 = Remotes and Remotes:WaitForChild("RequestFish", 10)

            for i = 1, #t7, 10 do
                local move = table.move
                local v11 = #t7
                local v12 = move(t7, i, math.min(i + 9, v11), 1, {})
                local v13 = false
                local v14 = false

                if v10 ~= nil then
                    local function v15() -- line: 107
                        -- upvalues: v12 (copy), v13 (ref), v10 (copy)
                        v13 = v10:InvokeServer(v12) == true
                    end

                    v14 = pcall(v15)
                end

                if not (v14 and v13) then
                    for _, v16 in ipairs(v12) do
                        t4[v16] = nil
                    end
                end
            end
        end)
    end
end

function t1.Retry(p8) -- line: 120
    -- upvalues: t1 (copy), locate (copy), t4 (copy)
    if not locate(p8) then
        t4[p8] = nil
        t1.Prepare({ p8 })
    end
end

t1.WAIT = 20

local function source(p9, p10) -- line: 132
    -- upvalues: RunService (copy), Fish (copy), StudPack (copy), t1 (copy), self (copy), complete (copy), locate (copy), t4 (copy)
    local v17 = locate(p9)

    if not (v17 and complete(v17)) then
        v17 = nil
    end

    local elapsed, v18, v19

    if v17 then
        v19 = true
    elseif RunService:IsClient() and Fish.ById[p9] then
        t1.Prepare({ p9 })
        elapsed = os.clock()
        v18 = p10 or t1.WAIT
        v19 = false
    else
        v19 = true
    end

    if v19 then
        return v17
    end

    local v20 = -1
    local elapsed2 = os.clock()
    local elapsed3 = os.clock()
    local v21

    while true do
        task.wait(0.05)
        v21 = locate(p9)

        if not (v21 and complete(v21)) then
            v21 = nil
        end

        if v21 then
            break
        end

        local v22 = locate(p9)
        local elapsed4 = os.clock()

        if v22 then
            local v23 = #v22:GetDescendants()

            if v23 == v20 then
                if not (elapsed4 - elapsed2 > 3) or v22:FindFirstChildWhichIsA("BasePart", true) == nil then
                    if elapsed4 - elapsed > 120 then
                        break
                    end

                    continue
                end

                self[v22] = true
                StudPack.Shared:Unpack(v22)
                v21 = v22
                break
            end

            elapsed2 = elapsed4
            v20 = v23
        else
            if elapsed4 - elapsed3 > 6 then
                elapsed3 = elapsed4
                t4[p9] = nil
                t1.Prepare({ p9 })
            end

            if v18 < elapsed4 - elapsed then
                break
            end
        end

        if elapsed4 - elapsed > 120 then
            break
        end
    end

    if not v21 then
        t4[p9] = nil
    end

    return v21
end

local function lum(p11) -- line: 176
    return 0.3 * p11.R + 0.59 * p11.G + 0.11 * p11.B
end

local function partLum(p12) -- line: 182
    local Lum = p12:GetAttribute("Lum")

    if not Lum then
        local Color = p12.Color

        Lum = 0.3 * Color.R + 0.59 * Color.G + 0.11 * Color.B
    end

    return Lum
end

local function sparkle(p13, p14, p15, p16) -- line: 186
    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "VariantFx"
    ParticleEmitter.Color = ColorSequence.new(p14)
    ParticleEmitter.LightEmission = p16 and 0 or 1
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.3, p16 and 1.4 or 0.45),
        NumberSequenceKeypoint.new(1, 0)
    })
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Lifetime = NumberRange.new(0.6, 1.2)
    ParticleEmitter.Rate = p15
    ParticleEmitter.Speed = NumberRange.new(0.5, 2)
    ParticleEmitter.SpreadAngle = Vector2.new(180, 180)
    ParticleEmitter.Rotation = NumberRange.new(0, 360)
    ParticleEmitter.Shape = Enum.ParticleEmitterShape.Box
    ParticleEmitter.Parent = p13

    return ParticleEmitter
end

local function applyVariant(p17, p18) -- line: 204
    -- upvalues: fromRGB (copy), sparkle (copy)
    if p18 == "Normal" then
        return
    end

    local PrimaryPart = p17.PrimaryPart
    local _, BoundingBox = p17:GetBoundingBox()
    local v24 = math.max(BoundingBox.Z, 0.1)
    local n1 = 1
    local n2 = 0

    for _, descendant in ipairs(p17:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant.Transparency < 1 and not (descendant:GetAttribute("Eye") or descendant:GetAttribute("Glow")) then
            local Lum = descendant:GetAttribute("Lum")

            if not Lum then
                local Color = descendant.Color

                Lum = 0.3 * Color.R + 0.59 * Color.G + 0.11 * Color.B
            end

            n1 = math.min(n1, Lum)
            n2 = math.max(n2, Lum)
        end
    end

    local v26 = math.max(n2 - n1, 0.05)

    for _, descendant in ipairs(p17:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant.Transparency < 1 and not descendant:GetAttribute("Eye") then
            local Glow = descendant:GetAttribute("Glow")
            local Lum = descendant:GetAttribute("Lum")

            if not Lum then
                local Color = descendant.Color

                Lum = 0.3 * Color.R + 0.59 * Color.G + 0.11 * Color.B
            end

            local v28 = math.clamp((Lum - n1) / v26, 0, 1)

            if Glow then
                if p18 ~= "Gold" and p18 ~= "Diamond" and p18 ~= "Ruby" and p18 ~= "Emerald" then
                    if descendant:IsA("UnionOperation") then
                        descendant.UsePartColor = true
                    end

                    if p18 == "Gold" then
                        descendant.Color = fromRGB(170, 110, 5):Lerp(fromRGB(255, 238, 120), v28)
                        descendant.Reflectance = 0.22
                    elseif p18 == "Diamond" then
                        descendant.Color = fromRGB(30, 140, 215):Lerp(fromRGB(215, 250, 255), v28)
                        descendant.Reflectance = 0.32
                    elseif p18 == "Ruby" then
                        descendant.Color = fromRGB(120, 5, 30):Lerp(fromRGB(255, 130, 150), v28)
                        descendant.Reflectance = 0.28
                    elseif p18 == "Emerald" then
                        descendant.Color = fromRGB(5, 95, 50):Lerp(fromRGB(150, 255, 180), v28)
                        descendant.Reflectance = 0.28
                    elseif p18 == "Rainbow" then
                        local v29 = (PrimaryPart.CFrame:PointToObjectSpace(descendant.Position).Z / v24 + 0.5) % 1

                        descendant:SetAttribute("Hue", v29)
                        descendant:SetAttribute("Val", v28 * 0.38 + 0.62)
                        descendant.Color = Color3.fromHSV(v29, 0.78, v28 * 0.38 + 0.62)
                    elseif p18 == "Void" then
                        descendant.Color = fromRGB(255, 60, 220)
                    end
                end
            else
                if descendant:IsA("UnionOperation") then
                    descendant.UsePartColor = true
                end

                if p18 == "Gold" then
                    descendant.Color = fromRGB(170, 110, 5):Lerp(fromRGB(255, 238, 120), v28)
                    descendant.Reflectance = 0.22
                elseif p18 == "Diamond" then
                    descendant.Color = fromRGB(30, 140, 215):Lerp(fromRGB(215, 250, 255), v28)
                    descendant.Reflectance = 0.32
                elseif p18 == "Ruby" then
                    descendant.Color = fromRGB(120, 5, 30):Lerp(fromRGB(255, 130, 150), v28)
                    descendant.Reflectance = 0.28
                elseif p18 == "Emerald" then
                    descendant.Color = fromRGB(5, 95, 50):Lerp(fromRGB(150, 255, 180), v28)
                    descendant.Reflectance = 0.28
                elseif p18 == "Rainbow" then
                    local v30 = (PrimaryPart.CFrame:PointToObjectSpace(descendant.Position).Z / v24 + 0.5) % 1

                    descendant:SetAttribute("Hue", v30)
                    descendant:SetAttribute("Val", v28 * 0.38 + 0.62)
                    descendant.Color = Color3.fromHSV(v30, 0.78, v28 * 0.38 + 0.62)
                elseif p18 == "Void" then
                    descendant.Color = fromRGB(14, 6, 26):Lerp(fromRGB(120, 55, 190), v28)
                end
            end
        end
    end

    if PrimaryPart then
        PrimaryPart.Size = Vector3.new(math.max(BoundingBox.X, 1), math.max(BoundingBox.Y, 1), (math.max(BoundingBox.Z, 1))) * 0.8

        if p18 == "Gold" then
            sparkle(PrimaryPart, fromRGB(255, 235, 120), 8)
        elseif p18 == "Diamond" then
            sparkle(PrimaryPart, fromRGB(220, 250, 255), 10)
        elseif p18 == "Ruby" then
            sparkle(PrimaryPart, fromRGB(255, 150, 170), 9)
        elseif p18 == "Emerald" then
            sparkle(PrimaryPart, fromRGB(170, 255, 190), 9)
        elseif p18 == "Rainbow" then
            sparkle(PrimaryPart, fromRGB(255, 255, 255), 12)
        elseif p18 == "Void" then
            sparkle(PrimaryPart, fromRGB(60, 20, 90), 10, true)

            local PointLight = Instance.new("PointLight")

            PointLight.Color = fromRGB(190, 80, 255)
            PointLight.Range = 14
            PointLight.Brightness = 2
            PointLight.Parent = PrimaryPart
        end
    end

    p17:SetAttribute("Variant", p18)
end

local function placeholder(p19) -- line: 278
    -- upvalues: fromRGB (copy)
    local Model = Instance.new("Model")

    Model.Name = p19
    Model:SetAttribute("Placeholder", true)

    local Part = Instance.new("Part")

    Part.Name = "Root"
    Part.Size = Vector3.new(2, 3, 6)
    Part.Color = fromRGB(120, 170, 220)
    Part.Material = Enum.Material.SmoothPlastic
    Part.Anchored = true
    Part.CanCollide = false
    Part.Parent = Model
    Model.PrimaryPart = Part

    return Model
end

local t8 = {}
local Folder

local function warmKey(p20, p21, p22) -- line: 301
    -- upvalues: Sizes (copy)
    return p20 .. "|" .. tostring(p21 or 1) .. "|" .. tostring(p22 or Sizes.NORMAL_INDEX)
end

t1.Warmed = 0

function t1.Take(p23, p24, p25) -- line: 306
    -- upvalues: Sizes (copy), t1 (copy), t8 (copy)
    local v40 = t8[p23 .. "|" .. tostring(p24 or 1) .. "|" .. tostring(p25 or Sizes.NORMAL_INDEX)]
    local v41

    repeat
        if not (v40 and #v40 > 0) then
            return t1.Get(p23, p24, p25)
        end

        v41 = table.remove(v40, 1)
    until v41.Parent

    t1.Warmed += 1

    return v41
end

function t1.Warm(p26, p27, p28, p29) -- line: 319
    -- upvalues: Sizes (copy), t1 (copy), t8 (copy), Folder (ref)
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local v42 = LocalPlayer and LocalPlayer.Character
    local HumanoidRootPart = v42 and v42:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return
    end

    if not (Folder and Folder.Parent) then
        Folder = Instance.new("Folder")
        Folder.Name = "WarmFish"
        Folder.Parent = workspace
    end

    local v46 = p26 .. "|" .. tostring(p27 or 1) .. "|" .. tostring(p28 or Sizes.NORMAL_INDEX)

    t8[v46] = t8[v46] or {}

    for _ = 1, p29 or 1 do
        local v47 = t1.Get(p26, p27, p28)

        for _, descendant in ipairs(v47:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.CanCollide = false
                descendant.CanQuery = false
                descendant.CanTouch = false
            end
        end

        v47:PivotTo(CFrame.new(HumanoidRootPart.Position - Vector3.new(0, 70, 0)))
        v47.Parent = Folder
        table.insert(t8[v46], v47)
    end
end

function t1.ClearWarm() -- line: 350
    -- upvalues: t8 (copy)
    for _, v49 in pairs(t8) do
        for _, v50 in ipairs(v49) do
            v50:Destroy()
        end
    end

    table.clear(t8)
end

local t9 = {}

t9.__index = t9

function t9.new() -- line: 362
    -- upvalues: t9 (copy)
    return (setmetatable({
        ByBase = setmetatable({}, {
            __mode = "k"
        })
    }, t9))
end

function t9.Get(p30, p31) -- line: 366
    local v51 = p30.ByBase[p31]

    if not v51 then
        v51 = p31:Clone()

        for _, descendant in ipairs(v51:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                descendant:Destroy()
            elseif descendant:IsA("PointLight") then
                descendant:Destroy()
            elseif descendant:IsA("Texture") then
                descendant:Destroy()
            end
        end

        p30.ByBase[p31] = v51
    end

    return v51
end

local v52 = t9.new()

function t1.Get(p32, p33, p34, p35, p36) -- line: 382
    -- upvalues: Variants (copy), Sizes (copy), source (copy), applyVariant (copy), placeholder (copy), v52 (copy)
    local v53 = source(p32, p35)
    local v54

    if v53 and v53:FindFirstChildWhichIsA("BasePart", true) ~= nil then
        if p36 then
            v53 = v52:Get(v53)
        end

        v54 = v53:Clone()
    else
        v54 = placeholder(p32)
    end

    local v55 = Variants.List[p33 or 1] or Variants.List[1]
    local v56 = Sizes.List[p34 or Sizes.NORMAL_INDEX] or Sizes.List[Sizes.NORMAL_INDEX]

    if v56.scale ~= 1 then
        v54:ScaleTo(v54:GetScale() * v56.scale)
    end

    applyVariant(v54, v55.id)

    local _, BoundingBox = v54:GetBoundingBox()

    v54:SetAttribute("Length", BoundingBox.Z)
    v54:SetAttribute("Height", BoundingBox.Y)
    v54:SetAttribute("Width", BoundingBox.X)

    return v54
end

function t1.CenterOffset(p37) -- line: 399
    local BoundingBox = p37:GetBoundingBox()

    return p37.PrimaryPart.CFrame:PointToObjectSpace(BoundingBox.Position)
end

local self2 = setmetatable({}, {
    __mode = "k"
})
local self3 = setmetatable({}, {
    __mode = "k"
})
local sin, Angles, fromAxisAngle = math.sin, CFrame.Angles, CFrame.fromAxisAngle

local function rigOf(p38) -- line: 421
    -- upvalues: self2 (copy)
    local v59 = self2[p38]

    if v59 then
        return v59
    end

    local t17 = {
        joints = {},
        moves = {},
        sway = p38:GetAttribute("Anim") == "sway",
        swayAmp = p38:GetAttribute("SwayAmp") or 0.1
    }
    local PrimaryPart = p38.PrimaryPart

    if PrimaryPart then
        local t18 = {}
        local Flex = p38:GetAttribute("Flex")

        for i = 1, Flex or 0 do
            local v60 = PrimaryPart:FindFirstChild("Flex" .. i)

            if v60 and v60:IsA("Motor6D") then
                table.insert(t18, v60)
            end
        end

        if Flex == nil then
            local TailJoint = PrimaryPart:FindFirstChild("TailJoint")

            if TailJoint and TailJoint:IsA("Motor6D") then
                t18[1] = TailJoint
            end
        end

        local n3 = 0

        for _, v61 in ipairs(t18) do
            if not v61:GetAttribute("Body") then
                n3 += 1
            end
        end

        local v62 = #t18 - n3
        local n4 = 0

        for v63, v64 in ipairs(t18) do
            local v65

            if v64:GetAttribute("Body") then
                v65 = 0.34 / math.max(v62, 1) ^ 0.6
            else
                n4 += 1
                v65 = (if n3 > 1 then (n4 - 1) * 0.44 / (n3 - 1) + 0.78 else 1) / math.max(n3, 1) ^ 0.8
            end

            table.insert(t17.joints, {
                v64,
                v64.C0,
                v65,
                (#t18 - v63) * 0.8,
                v63
            })
        end

        for i = 1, p38:GetAttribute("Moves") or 0 do
            local v66 = PrimaryPart:FindFirstChild("Move" .. i)

            if v66 and v66:IsA("Motor6D") then
                table.insert(t17.moves, {
                    v66,
                    v66.C0,
                    v66:GetAttribute("Axis") or Vector3.new(0, 1, 0),
                    v66:GetAttribute("Amp") or 0,
                    v66:GetAttribute("Rate") or 1,
                    v66:GetAttribute("Off") or 0,
                    v66:GetAttribute("Axis2"),
                    v66:GetAttribute("Amp2") or 0,
                    v66:GetAttribute("Rate2") or 1,
                    v66:GetAttribute("Off2") or 0,
                    v66:GetAttribute("Spin") == true
                })
            end
        end
    end

    self2[p38] = t17

    return t17
end

function t1.Animate(p39, p40, p41, p42, p43) -- line: 480
    -- upvalues: self3 (copy), sin (copy), Angles (copy), fromAxisAngle (copy), rigOf (copy)
    local v75 = rigOf(p39)

    p43 = p43 or p40 * (p41 or 7)
    p42 = p42 or 0.38

    if v75.sway then
        local v78 = v75.swayAmp * p42 / 0.38
        local v79 = p43 * 0.36

        for _, v80 in ipairs(v75.joints) do
            local v81 = v80[5] * 0.9

            v80[1].C0 = v80[2] * Angles(sin(v79 - v81) * v78 * 0.8, sin(v79 * 0.73 - v81 + 0.9) * v78 * 0.55, sin(v79 * 0.59 - v81 + 2.1) * v78 * 0.7)
        end
    else
        local v90 = sin(p43 * 0.23) * 0.12 + 0.88

        for _, v91 in ipairs(v75.joints) do
            local v92 = v91[4]
            local v93 = p42 * v91[3] * v90
            local v97 = (sin(p43 + v92) + sin(2 * p43 + 2 * v92 + 0.7) * 0.16) * v93

            v91[1].C0 = v91[2] * Angles(sin(p43 * 0.5 + v92) * v93 * 0.1, v97, v97 * 0.14)
        end
    end

    for _, v101 in ipairs(v75.moves) do
        local v102 = if v101[11] then (p40 * v101[5] + v101[6]) % 6.283185307179586 else sin(p40 * v101[5] + v101[6]) * v101[4]
        local v104 = v101[2] * fromAxisAngle(v101[3], v102)

        if v101[7] then
            v104 *= fromAxisAngle(v101[7], sin(p40 * v101[9] + v101[10]) * v101[8])
        end

        v101[1].C0 = v104
    end

    if p39:GetAttribute("Variant") ~= "Rainbow" then
        return
    end

    local v107 = self3[p39]

    if not v107 then
        v107 = {}

        for _, descendant in ipairs(p39:GetDescendants()) do
            local v108 = descendant:IsA("BasePart") and descendant:GetAttribute("Hue")

            if v108 then
                table.insert(v107, {
                    descendant,
                    v108,
                    descendant:GetAttribute("Val") or 1
                })
            end
        end

        self3[p39] = v107
    end

    local v109 = p40 * 0.25

    for _, v110 in ipairs(v107) do
        v110[1].Color = Color3.fromHSV((v110[2] + v109) % 1, 0.78, v110[3])
    end
end

function t1.Rescale(p44, p45) -- line: 535
    -- upvalues: self2 (copy)
    local v111 = self2[p44]

    if v111 then
        for _, v112 in ipairs(v111.joints) do
            v112[1].C0 = v112[2]
        end

        for _, v113 in ipairs(v111.moves) do
            v113[1].C0 = v113[2]
        end

        self2[p44] = nil
    end

    p44:ScaleTo(p45)
end

function t1.TailSwing(p46) -- line: 550
    return (math.sin(p46))
end

function t1.Picture(p47, p48, p49, p50, p51) -- line: 556
    -- upvalues: RunService (copy), t1 (copy)
    local ViewportFrame = Instance.new("ViewportFrame")

    ViewportFrame.Name = "FishPicture"
    ViewportFrame.BackgroundTransparency = 1
    ViewportFrame.Size = UDim2.fromScale(1, 1)
    ViewportFrame.Ambient = Color3.new(1, 1, 1)
    ViewportFrame.LightColor = Color3.new(1, 1, 1)
    ViewportFrame.LightDirection = Vector3.new(-1, -1, -0.4)
    ViewportFrame.ImageColor3 = if p50 then Color3.new(0, 0, 0) else Color3.new(1, 1, 1)
    ViewportFrame.ZIndex = p47.ZIndex + 1

    local Camera = Instance.new("Camera")

    Camera.FieldOfView = 30
    Camera.Parent = ViewportFrame
    ViewportFrame.CurrentCamera = Camera
    ViewportFrame.Parent = p47

    local n5 = 0

    local function fill() -- line: 572
        -- upvalues: p47 (copy), p48 (copy), p49 (copy), p51 (copy), ViewportFrame (copy), Camera (copy), n5 (ref), fill (copy), t1 (copy)
        if ViewportFrame.Parent then
            local v115 = t1.Get(p48, p49, nil, nil, true)

            if v115:GetAttribute("Placeholder") then
                v115:Destroy()
                n5 += 1
                t1.Retry(p48)
                task.delay(math.min(n5 * 3, 15), fill)
            else
                for _, descendant in ipairs(v115:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        descendant:Destroy()
                    elseif descendant:IsA("PointLight") then
                        descendant:Destroy()
                    elseif descendant:IsA("Texture") then
                        descendant:Destroy()
                    end
                end

                v115:PivotTo(CFrame.new())
                v115.Parent = ViewportFrame

                local BoundingBox, BoundingBox2 = v115:GetBoundingBox()
                local AbsoluteSize = p47.AbsoluteSize
                local v117 = if AbsoluteSize.Y > 1 then math.clamp(AbsoluteSize.X / AbsoluteSize.Y, 0.6, 2) else 1.1
                local v119 = BoundingBox2.Z * 0.92 + BoundingBox2.X * 0.4
                local v120 = BoundingBox2.Y * 0.96 + BoundingBox2.X * 0.25
                local v122 = math.max(v119 / v117, v120) / 0.5358983848622454 * 1.06
                local Unit = (p51 or Vector3.new(1, 0.28, -0.42)).Unit

                Camera.CFrame = CFrame.lookAt(BoundingBox.Position + Unit * v122, BoundingBox.Position)
                task.spawn(function() -- line: 604
                    -- upvalues: v115 (copy), ViewportFrame (copy)
                    local function v123() -- line: 605
                        -- upvalues: v115 (copy)
                        game:GetService("ContentProvider"):PreloadAsync({
                            v115
                        })
                    end

                    pcall(v123)

                    for _, v124 in { 0, 1, 3 } do
                        task.wait(v124)

                        if v115.Parent ~= ViewportFrame then
                            return
                        end

                        v115.Parent = nil
                        v115.Parent = ViewportFrame
                    end
                end)
            end
        end
    end

    if t1.Has(p48) or not RunService:IsClient() then
        fill()
    else
        t1.Prepare({ p48 })
        task.spawn(fill)
    end

    return ViewportFrame
end

return t1
