-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SubArena = require(ReplicatedStorage.Shared.SubArena)
local Poses = require(script.Parent.Parent.Character.Poses)
local HullRig = require(script.Parent.Parent.Boss.HullRig)
local TripSet = require(script.Parent.Parent.World2Trip.TripSet)
local t1 = {}
local LocalPlayer = Players.LocalPlayer
local t2 = {
    Color3.fromRGB(255, 70, 70),
    Color3.fromRGB(255, 230, 90)
}
local Folder, v1
local t3 = {}
local v2, ColorCorrectionEffect, Highlight
local n1 = 0
local v3 = Color3.new(1, 1, 1)
local t4 = {}
local v4
local v5 = true

local function smooth(p1) -- line: 36
    local v6 = math.clamp(p1, 0, 1)

    return v6 * v6 * (3 - v6 * 2)
end

local function core() -- line: 41
    local SubBossArena = workspace:FindFirstChild("SubBossArena")
    local Core = SubBossArena and SubBossArena:FindFirstChild("Core")

    return if Core and Core:IsA("BasePart") then Core else nil
end

function t1.isBuilt() -- line: 47
    -- upvalues: Folder (ref)
    return Folder ~= nil
end

function t1.folder() -- line: 51
    -- upvalues: Folder (ref)
    return Folder
end

local function buildMonster(p2) -- line: 57
    -- upvalues: SubArena (copy), HullRig (copy)
    local v7 = HullRig.clone(SubArena.MONSTER_SCALE)

    if not v7 then
        return nil
    end

    v7.Name = "SubBossHullbreaker"

    local t5 = {}

    for _, descendant in v7:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.Name:find("Glow") then
            t5[descendant] = {
                Color = descendant.Color,
                Material = descendant.Material
            }

            local PointLight = Instance.new("PointLight")

            PointLight.Color = Color3.fromRGB(255, 200, 120)
            PointLight.Range = 36
            PointLight.Brightness = 1.6
            PointLight.Parent = descendant
        end
    end

    local Part = Instance.new("Part")

    Part.Name = "Nessie_Head"
    Part.Size = Vector3.new(16, 14, 16)
    Part.Transparency = 1
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Parent = v7
    v7.Parent = p2

    return {
        shown = nil,
        last = nil,
        speed = 0,
        model = v7,
        rig = HullRig.new(v7),
        head = v7:FindFirstChild("Hullbreaker_Head", true),
        stand = Part,
        glows = t5,
        born = os.clock()
    }
end

local function poseFor(p3, p4, p5, p6) -- line: 96
    local v9 = math.clamp(p5 / 30 + 0.25, 0.25, 1)

    if p3 == "Windup" then
        local v11 = math.clamp(p4 / 0.5, 0, 1)
        local v12 = v11 * v11 * (3 - v11 * 2)

        return {
            speed = 1.6,
            prop = 1,
            walk = v9 * 0.6,
            open = v12 * 0.7 + 0.3,
            raise = v12,
            jaw = v12 * 0.6
        }
    end

    if p3 == "Snap" then
        local v14 = math.clamp(p4 / 0.14, 0, 1)
        local v15 = v14 * v14 * (3 - v14 * 2)

        return {
            walk = 0.3,
            speed = 2,
            jaw = 0.3,
            prop = 1,
            open = 1 - v15,
            raise = 1 - v15
        }
    end

    if p3 == "Charge" then
        return {
            walk = 1,
            speed = 3.4,
            open = 0.15,
            raise = 0,
            jaw = 0.8,
            prop = 4
        }
    end

    if p3 == "Roar" then
        local v17 = math.clamp(p4 / 0.4, 0, 1)
        local v18 = v17 * v17 * (3 - v17 * 2)

        return {
            walk = 0.1,
            speed = 1,
            prop = 1.5,
            open = v18 * 0.8,
            raise = v18 * 0.55,
            jaw = v18
        }
    end

    if p3 == "Spin" then
        return {
            walk = 0.25,
            speed = 1.2,
            open = 0.5,
            raise = 0.15,
            jaw = 0.3,
            prop = math.min(p4, 1.5) * 6 + 2
        }
    end

    if p3 == "Slam" then
        local v19 = p4 % 0.8
        local v20

        if v19 < 0.55 then
            local v22 = math.clamp(v19 / 0.55, 0, 1)

            v20 = v22 * v22 * (3 - v22 * 2)
        else
            local v24 = math.clamp((v19 - 0.55) / 0.1, 0, 1)

            v20 = 1 - v24 * v24 * (3 - v24 * 2)
        end

        return {
            walk = 0.1,
            speed = 1,
            open = 0.2,
            jaw = 0.4,
            prop = 1,
            raise = v20 * 1.1 - 0.15
        }
    end

    if p3 == "Hurt" then
        local v26 = math.clamp(1 - p4 / 0.9, 0, 1)

        return {
            walk = 0.3,
            speed = 2.5,
            open = 0.6,
            raise = 0,
            prop = 1,
            jaw = v26 * 0.7,
            limp = v26 * 0.45
        }
    end

    if p3 == "Dead" then
        local t6 = {
            walk = 0,
            speed = 1,
            open = 0.2,
            raise = 0,
            jaw = 0.9,
            prop = 0.1
        }
        local v28 = math.clamp(p4 / 1.5, 0, 1)

        t6.limp = v28 * v28 * (3 - v28 * 2)

        return t6
    end

    return {
        open = 0.3,
        snap = false,
        raise = 0,
        prop = 0.6,
        walk = v9,
        speed = p5 / 18 + 1.1,
        jaw = (math.sin(p6 * 1.7) + 1) * 0.06 + 0.08
    }
end

local function updateMonster(p7) -- line: 126
    -- upvalues: HullRig (copy), t2 (copy), Folder (ref), v1 (ref), Highlight (ref), n1 (ref), v3 (ref), v4 (ref), poseFor (copy)
    local SubBossArena = workspace:FindFirstChild("SubBossArena")
    local Core = SubBossArena and SubBossArena:FindFirstChild("Core")

    if not (Core and Core:IsA("BasePart")) then
        Core = nil
    end

    if v1 and Core then
        if v1.model.Parent == nil and Folder then
            v1.model.Parent = Folder
        end

        if v4 then
            local v30, v31 = v4(os.clock() - v1.born)

            v1.shown = v30

            local v32 = v1

            v32.last = v30.Position
            HullRig.pose(v1.rig, v30, os.clock() - v1.born, v31)

            if v1.head then
                v1.stand.CFrame = v1.head.CFrame
            end
        else
            local _CFrame = Core.CFrame
            local v33 = v1

            v33.shown = if v1.shown then v1.shown:Lerp(_CFrame, (math.min(1, p7 * 9))) else _CFrame

            local shown = v1.shown
            local v35 = if v1.last then (shown.Position - v1.last).Magnitude / math.max(p7, 0.004166666666666667) else 0
            local v36 = v1

            v36.last = shown.Position

            local v37 = v1

            v37.speed = v37.speed + (v35 - v1.speed) * math.min(1, p7 * 5)

            local v40 = Core:GetAttribute("Act") or "Walk"
            local v41 = workspace:GetServerTimeNow() - (Core:GetAttribute("ActAt") or 0)
            local v42 = os.clock() - v1.born
            local v43 = poseFor(v40, v41, v1.speed, v42)

            if v40 == "Roar" then
                shown *= CFrame.Angles(math.sin(v42 * 31) * 0.012, 0, math.sin(v42 * 27) * 0.015)
            elseif v40 == "Dead" then
                local v48 = math.clamp(v41 / 3, 0, 1)
                local v49 = v48 * v48 * (3 - v48 * 2)

                shown = shown * CFrame.new(0, -v49 * 18, 0) * CFrame.Angles(0, 0, v49 * 0.5)
            end

            HullRig.pose(v1.rig, shown, v42, v43)

            if v1.head then
                v1.stand.CFrame = v1.head.CFrame
            end

            local v50 = (workspace:GetAttribute("SubBossWeakUntil") or 0) > workspace:GetServerTimeNow()

            for v51, v52 in v1.glows do
                if v50 then
                    v51.Material = Enum.Material.Neon
                    v51.Color = t2[1]:Lerp(t2[2], (math.sin(os.clock() * 16) + 1) / 2)
                else
                    v51.Material = v52.Material
                    v51.Color = v52.Color
                end
            end

            local v57 = n1

            n1 = math.max(0, v57 - p7 * 3.5)

            if Highlight then
                Highlight.FillColor = v3

                local Highlight2 = Highlight

                Highlight2.FillTransparency = 1 - n1 * 0.8

                local Highlight3 = Highlight

                Highlight3.OutlineTransparency = 1 - n1
            end
        end
    elseif v1 then
        v1.model.Parent = nil
    end
end

function t1.monsterModel() -- line: 189
    -- upvalues: v1 (ref)
    return v1 and v1.model
end

function t1.monsterPivot() -- line: 193
    -- upvalues: v1 (ref)
    if v1 and v1.shown then
        return v1.shown
    end

    local SubBossArena = workspace:FindFirstChild("SubBossArena")
    local Core = SubBossArena and SubBossArena:FindFirstChild("Core")

    if not (Core and Core:IsA("BasePart")) then
        Core = nil
    end

    return Core and Core.CFrame
end

function t1.middle() -- line: 202
    -- upvalues: SubArena (copy), t1 (copy)
    local v58 = t1.monsterPivot()

    return v58 and (v58 * CFrame.new(0, SubArena.MIDDLE_UP, 0)).Position
end

function t1.headPosition() -- line: 207
    -- upvalues: t1 (copy), v1 (ref)
    local v59, v60

    if v1 and v1.head then
        local headPosition = v1.head.Position

        if headPosition then
            v59 = headPosition
            v60 = true
        else
            v60 = false
        end
    else
        v60 = false
    end

    if not v60 then
        v59 = t1.middle()
    end

    return v59
end

function t1.holdMonster(p8) -- line: 212
    -- upvalues: v4 (ref)
    v4 = p8
end

function t1.flash(p9, p10) -- line: 217
    -- upvalues: n1 (ref), v3 (ref)
    n1 = math.max(n1, p10)
    v3 = p9
end

local function sitAbove(p11) -- line: 224
    local Humanoid = p11:FindFirstChildOfClass("Humanoid")

    if not Humanoid or Humanoid.RigType ~= Enum.HumanoidRigType.R15 then
        return 1.5
    end

    return Humanoid.HipHeight * 0.55 + 0.2
end

local function dropSub(p12) -- line: 232
    -- upvalues: Poses (copy), LocalPlayer (copy), t3 (copy)
    local v62 = t3[p12]

    if not v62 then
        return
    end

    v62.sub.model:Destroy()

    if v62.character and v62.character.Parent and p12 ~= LocalPlayer then
        Poses.playFor(v62.character, nil)
    end

    t3[p12] = nil
end

local function ensureSub(p13) -- line: 243
    -- upvalues: Poses (copy), TripSet (copy), LocalPlayer (copy), Folder (ref), t3 (copy)
    local Character = p13.Character
    local v63 = t3[p13]

    if v63 and v63.character == Character then
        return v63
    end

    local v64 = t3[p13]

    if v64 then
        v64.sub.model:Destroy()

        if v64.character and v64.character.Parent and p13 ~= LocalPlayer then
            Poses.playFor(v64.character, nil)
        end

        t3[p13] = nil
    end

    if not (Character and Folder) then
        return nil
    end

    local v65 = TripSet.sub(Folder)

    if not v65 then
        return nil
    end

    v65.model.Name = "Sub_" .. p13.Name

    local v66 = TripSet.seat(v65, CFrame.identity)
    local new = CFrame.new
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local t8 = {
        spin = 0,
        sub = v65,
        offset = v66 * new(0, if not Humanoid or Humanoid.RigType ~= Enum.HumanoidRigType.R15 then 1.5 else Humanoid.HipHeight * 0.55 + 0.2, 0),
        character = Character
    }

    t3[p13] = t8

    if p13 ~= LocalPlayer then
        Poses.playFor(Character, "Drive")
    end

    return t8
end

function t1.subOf(p14) -- line: 269
    -- upvalues: t3 (copy)
    return t3[p14]
end

function t1.subFrame(p15, p16) -- line: 274
    -- upvalues: t3 (copy), ensureSub (copy)
    local v67 = t3[p15] or ensureSub(p15)

    return v67 and p16 * v67.offset:Inverse()
end

function t1.rootFrame(p17, p18) -- line: 280
    -- upvalues: t3 (copy), ensureSub (copy)
    local v68 = t3[p17] or ensureSub(p17)

    return v68 and p18 * v68.offset
end

function t1.nose(p19) -- line: 286
    -- upvalues: t3 (copy)
    local v69 = t3[p19]

    return if v69 and v69.cf then (v69.cf * CFrame.new(0, -3, -17)).Position else nil
end

function t1.place(p20, p21, p22, p23) -- line: 295
    -- upvalues: TripSet (copy), t4 (copy), ensureSub (copy)
    if not p21 then
        t4[p20] = nil

        return
    end

    t4[p20] = true

    local v70 = ensureSub(p20)

    if v70 then
        v70.cf = p21
        TripSet.placeSub(v70.sub, p21, p22 or 0, p23 or 0)
    end
end

function t1.showOthers(p24) -- line: 309
    -- upvalues: LocalPlayer (copy), t3 (copy), v5 (ref)
    v5 = p24

    for v71, v72 in t3 do
        if v71 ~= LocalPlayer then
            for _, v73 in v72.sub.pieces do
                v73.part.LocalTransparencyModifier = p24 and 0 or 1
            end
        end
    end
end

local function updateSubs(p25) -- line: 320
    -- upvalues: Players (copy), Poses (copy), TripSet (copy), LocalPlayer (copy), t3 (copy), t4 (copy), v5 (ref), ensureSub (copy)
    for _, player in Players:GetPlayers() do
        if player:GetAttribute("SubBossIn") == true and player.Character ~= nil then
            if not t3[player] then
                local v74 = ensureSub(player)

                if v74 and player ~= LocalPlayer and not v5 then
                    for _, v75 in v74.sub.pieces do
                        v75.part.LocalTransparencyModifier = 1
                    end
                end
            end
        elseif t3[player] then
            local v76 = t3[player]

            if v76 then
                v76.sub.model:Destroy()

                if v76.character and v76.character.Parent and player ~= LocalPlayer then
                    Poses.playFor(v76.character, nil)
                end

                t3[player] = nil
            end
        end
    end

    for v77, v78 in t3 do
        if v77.Parent then
            if not t4[v77] then
                local v79 = v78.character and v78.character:FindFirstChild("HumanoidRootPart")

                if v79 then
                    local v80 = v79.CFrame * v78.offset:Inverse()
                    local v81 = if v78.cf then (v80.Position - v78.cf.Position).Magnitude / math.max(p25, 0.004166666666666667) else 0

                    v78.cf = v80
                    v78.spin += (1 + v81 / 8) * p25 * 6
                    TripSet.placeSub(v78.sub, v80, v78.spin, 0)

                    if v78.sub.bubbles then
                        v78.sub.bubbles.Rate = 6 + v81 * 1.2
                    end
                end
            end
        else
            local v82 = t3[v77]

            if v82 then
                v82.sub.model:Destroy()

                if v82.character and v82.character.Parent and v77 ~= LocalPlayer then
                    Poses.playFor(v82.character, nil)
                end

                t3[v77] = nil
            end
        end
    end
end

function t1.start() -- line: 359
    -- upvalues: Lighting (copy), TripSet (copy), Folder (ref), v1 (ref), v2 (ref), ColorCorrectionEffect (ref), Highlight (ref), v5 (ref), buildMonster (copy)
    if Folder then
        return
    end

    local Folder2 = Instance.new("Folder")

    Folder2.Name = "SubBossSet"
    Folder2.Parent = workspace
    Folder = Folder2
    TripSet.build(Folder2)
    v1 = buildMonster(Folder2)
    v2 = TripSet.snow(Folder2)

    local Highlight2 = Instance.new("Highlight")

    Highlight2.Name = "SubBossFlash"
    Highlight2.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight2.FillTransparency = 1
    Highlight2.OutlineTransparency = 1
    Highlight2.Adornee = v1 and v1.model
    Highlight2.Parent = Folder2
    Highlight = Highlight2

    local ColorCorrectionEffect2 = Instance.new("ColorCorrectionEffect")

    ColorCorrectionEffect2.Name = "SubBossGrade"
    ColorCorrectionEffect2.TintColor = Color3.fromRGB(200, 222, 255)
    ColorCorrectionEffect2.Contrast = 0.08
    ColorCorrectionEffect2.Parent = Lighting
    ColorCorrectionEffect = ColorCorrectionEffect2
    v5 = true
end

function t1.stop() -- line: 387
    -- upvalues: Poses (copy), LocalPlayer (copy), Folder (ref), v1 (ref), t3 (copy), v2 (ref), ColorCorrectionEffect (ref), Highlight (ref), t4 (copy), v4 (ref)
    for v83 in t3 do
        local v84 = t3[v83]

        if v84 then
            v84.sub.model:Destroy()

            if v84.character and v84.character.Parent and v83 ~= LocalPlayer then
                Poses.playFor(v84.character, nil)
            end

            t3[v83] = nil
        end
    end

    table.clear(t4)
    v4 = nil

    if ColorCorrectionEffect then
        ColorCorrectionEffect:Destroy()
        ColorCorrectionEffect = nil
    end

    if Folder then
        Folder:Destroy()
    end

    Folder = nil
    v1 = nil
    v2 = nil
    Highlight = nil
end

function t1.update(p26) -- line: 403
    -- upvalues: Folder (ref), v2 (ref), updateMonster (copy), updateSubs (copy)
    if Folder then
        updateMonster(p26)
        updateSubs(p26)

        if v2 then
            v2.CFrame = workspace.CurrentCamera.CFrame
        end
    end
end

return t1
