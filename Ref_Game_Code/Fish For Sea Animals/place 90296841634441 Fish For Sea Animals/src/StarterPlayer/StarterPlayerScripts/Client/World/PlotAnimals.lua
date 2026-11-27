-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local AnimalModel = require(ReplicatedStorage.Shared.AnimalModel)
local Animals = require(ReplicatedStorage.Shared.Animals)
local Config = require(ReplicatedStorage.Shared.Config)
local Auras = require(script.Parent.Parent.Auras.Auras)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Tooltip = require(script.Parent.Parent.UI.Tooltip)
local Settings = require(script.Parent.Parent.UI.Settings)
local t1 = {}
local t2 = {}
local v1 = Random.new()

local function randomPoint(p1) -- line: 38
    -- upvalues: v1 (copy)
    local floor = p1.floor
    local v4 = math.min(4 + p1.size * 0.4, math.min(floor.Size.X, floor.Size.Z) * 0.3)
    local v5 = (floor.Size / 2 - Vector3.new(v4, 0, v4)):Max((Vector3.new(0, 0, 0)))

    return floor.Position + Vector3.new(v1:NextNumber(-v5.X, v5.X), 0, v1:NextNumber(-v5.Z, v5.Z))
end

local function placeRing(p2, p3, p4) -- line: 48
    -- upvalues: Debris (copy), UIUtil (copy)
    local Part = Instance.new("Part")

    Part.Name = "PlaceRing"
    Part.Shape = Enum.PartType.Cylinder
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Material = Enum.Material.Neon
    Part.Color = Color3.new(1, 1, 1)
    Part.Transparency = 0.2
    Part.Size = Vector3.new(0.1, p4 * 0.6, p4 * 0.6)

    local v10 = p2.Position.Y + p2.Size.Y / 2

    Part.CFrame = CFrame.new(p3.X, v10 + 0.06, p3.Z) * CFrame.Angles(0, 0, 1.5707963267948966)
    Part.Parent = workspace
    UIUtil.tween(Part, 0.5, {
        Transparency = 1,
        Size = Vector3.new(0.1, p4 * 2.2, p4 * 2.2)
    })
    Debris:AddItem(Part, 0.6)
end

local function randomHeight(p5) -- line: 70
    -- upvalues: v1 (copy)
    local v14 = math.clamp(15 - (p5.size + 1), 2, 7)

    return p5.hover + v1:NextNumber(0, v14)
end

local function lerpAngle(p6, p7, p8) -- line: 75
    return p6 + ((p7 - p6 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * p8
end

local function isEffect(p9) -- line: 80
    return p9:IsA("ParticleEmitter") or p9:IsA("Light") or p9:IsA("Beam") or p9:IsA("Trail")
end

local function applyTo(p10, p11, p12) -- line: 85
    if p10:IsA("BasePart") then
        p10.LocalTransparencyModifier = p11 and 1 or 0
    elseif p10:IsA("ParticleEmitter") or p10:IsA("Light") or p10:IsA("Beam") or p10:IsA("Trail") then
        local WasEnabled = p10:GetAttribute("WasEnabled")

        if WasEnabled == nil then
            WasEnabled = p10.Enabled
            p10:SetAttribute("WasEnabled", WasEnabled)
        end

        p10.Enabled = WasEnabled and p12 and not p11
    end
end

local function applySettings(p13, p14) -- line: 99
    -- upvalues: Players (copy), Settings (copy), applyTo (copy)
    local v15 = p13:GetAttribute("OwnerUserId") == Players.LocalPlayer.UserId

    p14.hidden = not Settings.get(v15 and "MyAnimals" or "OtherAnimals")
    p14.fx = Settings.get("AnimalFx")

    for _, descendant in p13:GetDescendants() do
        applyTo(descendant, p14.hidden, p14.fx)
    end
end

local function forget(p15) -- line: 108
    -- upvalues: Auras (copy), t2 (copy)
    local v16 = t2[p15]

    if v16 and v16.aura then
        Auras.destroy(v16.aura)
    end

    t2[p15] = nil
end

local function add(p16) -- line: 116
    -- upvalues: Players (copy), AnimalModel (copy), Animals (copy), Auras (copy), UIUtil (copy), t2 (copy), v1 (copy), placeRing (copy), applyTo (copy), applySettings (copy)
    if p16:IsA("Model") then
        task.defer(function() -- line: 120
            -- upvalues: p16 (copy), Players (copy), AnimalModel (copy), Animals (copy), Auras (copy), UIUtil (copy), t2 (copy), v1 (copy), placeRing (copy), applyTo (copy), applySettings (copy)
            local v17 = p16.Parent and p16.Parent.Parent
            local Floor = v17 and v17:FindFirstChild("Floor")

            if not (Floor and p16.Parent) then
                return
            end

            local v18 = p16:GetAttribute("DisplaySize") or 4
            local Pivot = p16:GetPivot()
            local LookVector = Pivot.LookVector
            local PlacedAt = p16:GetAttribute("PlacedAt")
            local v19 = PlacedAt ~= nil and workspace:GetServerTimeNow() - PlacedAt < 2

            if v19 then
                placeRing(Floor, Pivot.Position, v18)

                if p16:GetAttribute("OwnerUserId") == Players.LocalPlayer.UserId then
                    UIUtil.sound("Place", 0.7)
                end
            end

            local v20 = Animals.get(p16:GetAttribute("Species") or "")
            local v21 = v20 ~= nil and v20.Walks == true
            local v22 = v21 and v20 ~= nil and v20.Crab == true
            local v23 = AnimalModel.rig(p16)

            v23.crab = v22

            local t4 = {
                speed = 0,
                tilt = 0,
                drop = v19 and 1 or 0,
                rig = v23,
                floor = Floor,
                size = v18,
                pos = Pivot.Position,
                yaw = math.atan2(-LookVector.X, -LookVector.Z),
                walks = v21,
                crab = v22,
                moveSpeed = if v22 then math.min(v18, 16) * 0.3 + 3.2 elseif v21 then math.min(v18, 16) * 0.2 + 2 else math.min(v18, 16) * 0.35 + 3,
                arrive = math.max(1.2, v18 * 0.08),
                hover = if v21 then -v23.bottom + 0.05 else -v23.bottom + 1 + v18 * 0.15,
                idleUntil = os.clock() + v1:NextNumber(0.5, 3),
                center = Pivot.Position,
                seed = v1:NextNumber(0, 10)
            }

            t4.height = t4.hover

            if v21 then
                t4.targetHeight = t4.hover
            else
                local v28 = math.clamp(15 - (t4.size + 1), 2, 7)

                t4.targetHeight = t4.hover + v1:NextNumber(0, v28)
            end

            local v29 = t2[p16]

            if v29 and v29.aura then
                Auras.destroy(v29.aura)
            end

            t2[p16] = nil
            t4.aura = if v20 then Auras.make(v20, p16, v18) else nil
            t2[p16] = t4
            applySettings(p16, t4)
            p16.DescendantAdded:Connect(function(p17) -- line: 172
                -- upvalues: v21 (copy), v23 (copy), t4 (copy), p16 (copy), AnimalModel (copy), t2 (copy), applyTo (copy)
                if t2[p16] == t4 then
                    applyTo(p17, t4.hidden, t4.fx)
                end

                if p17:IsA("BasePart") and t2[p16] == t4 then
                    AnimalModel.addPart(v23, p17)

                    if v21 then
                        t4.hover = -v23.bottom + 0.05
                    end
                end
            end)
        end)
    end
end

local function step(_, p19, p20, p21) -- line: 186
    -- upvalues: AnimalModel (copy), Auras (copy), v1 (copy), randomPoint (copy)
    local v30

    if p19.target then
        local v31 = p19.target - p19.pos
        local v32 = Vector3.new(v31.X, 0, v31.Z)

        if v32.Magnitude < p19.arrive then
            p19.target = nil
            v30 = 0
            p19.idleUntil = p20 + v1:NextNumber(1.5, 4.5)
        else
            local v33 = math.atan2(v32.X, v32.Z)
            local v34 = v33

            if p19.crab then
                v34 = v33 + 1.5707963267948966

                local v35 = v33 - 1.5707963267948966

                if not (math.abs((v34 - p19.yaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) < math.abs((v35 - p19.yaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793)) then
                    v34 = v35
                end
            end

            local yaw = p19.yaw
            local v40 = math.min(1, p21 * (if p19.crab then 3 else 1.6))

            p19.yaw = yaw + ((v34 - yaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * v40
            p19.moveYaw = v33

            local v43 = math.max(0.2, (math.cos((v34 - p19.yaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793)))

            v30 = if p19.crab then v43 * (if math.sin(p20 * 3.1 + p19.seed * 2) > -0.35 then 1 else 0.05) else v43
        end
    else
        if p19.idleUntil < p20 then
            p19.target = randomPoint(p19)

            if not p19.walks then
                local v46 = math.clamp(15 - (p19.size + 1), 2, 7)

                p19.targetHeight = p19.hover + v1:NextNumber(0, v46)
            end
        end

        v30 = 0
    end

    p19.speed = p19.speed + (v30 - p19.speed) * math.min(1, p21 * (if p19.crab then 7 else 1.5))

    local v49 = if not (p19.crab and p19.moveYaw) then p19.yaw else p19.moveYaw

    p19.pos = p19.pos + Vector3.new(math.sin(v49), 0, (math.cos(v49))) * p19.moveSpeed * p19.speed * p21

    if not p19.walks then
        local v52 = p19.moveSpeed * 0.45
        local v55 = math.clamp((p19.targetHeight - p19.height) * 1.2, -v52, v52)

        p19.height += v55 * p21

        local v59 = math.clamp(-math.atan2(v55, (math.max(p19.moveSpeed * p19.speed, 1.5))), -0.6108652381980153, 0.6108652381980153)

        p19.tilt = p19.tilt + (v59 - p19.tilt) * math.min(1, p21 * 3)
    end

    local v62 = p19.floor.Position.Y + p19.floor.Size.Y / 2
    local v63 = if p19.walks then 0 else math.sin(p20 * 1.7 + p19.seed) * 0.35
    local v65 = if p19.walks then 0 else p19.tilt + math.cos(p20 * 1.7 + p19.seed) * 0.06981317007977318

    if p19.drop > 0 then
        p19.drop = math.max(0, p19.drop - p21 * 4)
        v63 += p19.drop * p19.drop * 4
    end

    local v68 = CFrame.new(p19.pos.X, v62 + (if p19.walks then p19.hover else p19.height) + v63, p19.pos.Z) * CFrame.Angles(0, p19.yaw, 0) * CFrame.Angles(v65, 0, 0)

    p19.center = v68.Position
    AnimalModel.pose(p19.rig, v68, p20, p19.speed, p19.walks)

    if p19.aura then
        Auras.move(p19.aura, v68.Position, p20, (Vector3.new(math.sin(p19.yaw), 0, (math.cos(p19.yaw)))))
    end
end

local function hovered() -- line: 254
    -- upvalues: UserInputService (copy), t2 (copy)
    local CurrentCamera = workspace.CurrentCamera

    if CurrentCamera.CameraType == Enum.CameraType.Scriptable or UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
        return nil
    end

    local MouseLocation = UserInputService:GetMouseLocation()
    local v72 = CurrentCamera.ViewportSize.Y / (math.tan(math.rad(CurrentCamera.FieldOfView) / 2) * 2)
    local n1 = 1e999
    local v73

    for v74, v75 in t2 do
        local v76, v77 = CurrentCamera:WorldToViewportPoint(v75.center)

        if v77 and not v75.hidden and v76.Z < n1 and v76.Z < 300 then
            local v78 = v75.size * 0.5 / v76.Z * v72

            if (Vector2.new(v76.X, v76.Y) - MouseLocation).Magnitude <= math.max(v78, 12) then
                v73 = v74
                n1 = v76.Z
            end
        end
    end

    return v73
end

local t5 = {}

local function plotBox(p22) -- line: 276
    -- upvalues: t5 (copy)
    local v79 = t5[p22]

    if not v79 then
        local BoundingBox, BoundingBox2 = p22:GetBoundingBox()

        v79 = {
            cf = BoundingBox,
            half = BoundingBox2 / 2 + Vector3.new(4, 10, 4)
        }
        t5[p22] = v79
    end

    return v79.cf, v79.half
end

local function plotUnder() -- line: 287
    -- upvalues: Players (copy), Config (copy), t5 (copy)
    local Character = Players.LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if HumanoidRootPart then
        for _, v80 in Config.allPlots() do
            if v80:IsA("Model") then
                local v81 = t5[v80]

                if not v81 then
                    local BoundingBox, BoundingBox2 = v80:GetBoundingBox()

                    v81 = {
                        cf = BoundingBox,
                        half = BoundingBox2 / 2 + Vector3.new(4, 10, 4)
                    }
                    t5[v80] = v81
                end

                local cf, half = v81.cf, v81.half
                local v82 = cf:PointToObjectSpace(HumanoidRootPart.Position)

                if math.abs(v82.X) <= half.X and math.abs(v82.Z) <= half.Z and math.abs(v82.Y) <= half.Y then
                    return v80
                end
            end
        end
    end

    return nil
end

local function updateTags() -- line: 305
    -- upvalues: t2 (copy), plotUnder (copy)
    local v83 = plotUnder()

    for v84, v85 in t2 do
        v85.tag = v85.tag or v84:FindFirstChild("AnimalTag", true)

        if v85.tag then
            local tag = v85.tag

            if v83 ~= nil then
                if v85.floor.Parent == v83 then
                    tag.Enabled = not v85.hidden
                else
                    tag.Enabled = false
                end
            else
                tag.Enabled = false
            end
        end
    end
end

local v86

local function updateHover() -- line: 316
    -- upvalues: Tooltip (copy), hovered (copy), v86 (ref)
    local v87 = Tooltip.owner()

    if v87 == nil or v87 == "plotAnimal" then
        local v88 = hovered()

        if v88 ~= v86 then
            v86 = v88

            if v88 then
                Tooltip.show("plotAnimal", v88:GetAttribute("Species") or "", v88:GetAttribute("Weight"), nil, v88:GetAttribute("Mutation"), v88:GetAttribute("SizeTier"))
            else
                Tooltip.hide("plotAnimal")
            end
        end
    else
        v86 = nil
    end
end

function t1.init() -- line: 335
    -- upvalues: CollectionService (copy), Players (copy), RunService (copy), AnimalModel (copy), Animals (copy), Auras (copy), UIUtil (copy), Settings (copy), t2 (copy), v1 (copy), placeRing (copy), applyTo (copy), applySettings (copy), add (copy), step (copy), updateTags (copy), updateHover (copy)
    CollectionService:GetInstanceAddedSignal("PlotAnimal"):Connect(add)
    CollectionService:GetInstanceRemovedSignal("PlotAnimal"):Connect(function(p23) -- line: 337
        -- upvalues: Auras (copy), t2 (copy)
        local v89 = t2[p23]

        if v89 and v89.aura then
            Auras.destroy(v89.aura)
        end

        t2[p23] = nil
    end)

    for _, v90 in CollectionService:GetTagged("PlotAnimal") do
        if v90:IsA("Model") then
            task.defer(function() -- line: 120
                -- upvalues: v90 (copy), Players (copy), AnimalModel (copy), Animals (copy), Auras (copy), UIUtil (copy), t2 (copy), v1 (copy), placeRing (copy), applyTo (copy), applySettings (copy)
                local v91 = v90.Parent and v90.Parent.Parent
                local Floor = v91 and v91:FindFirstChild("Floor")

                if not (Floor and v90.Parent) then
                    return
                end

                local v92 = v90:GetAttribute("DisplaySize") or 4
                local Pivot = v90:GetPivot()
                local LookVector = Pivot.LookVector
                local PlacedAt = v90:GetAttribute("PlacedAt")
                local v93 = PlacedAt ~= nil and workspace:GetServerTimeNow() - PlacedAt < 2

                if v93 then
                    placeRing(Floor, Pivot.Position, v92)

                    if v90:GetAttribute("OwnerUserId") == Players.LocalPlayer.UserId then
                        UIUtil.sound("Place", 0.7)
                    end
                end

                local v94 = Animals.get(v90:GetAttribute("Species") or "")
                local v95 = v94 ~= nil and v94.Walks == true
                local v96 = v95 and v94 ~= nil and v94.Crab == true
                local v97 = AnimalModel.rig(v90)

                v97.crab = v96

                local t6 = {
                    speed = 0,
                    tilt = 0,
                    drop = v93 and 1 or 0,
                    rig = v97,
                    floor = Floor,
                    size = v92,
                    pos = Pivot.Position,
                    yaw = math.atan2(-LookVector.X, -LookVector.Z),
                    walks = v95,
                    crab = v96,
                    moveSpeed = if v96 then math.min(v92, 16) * 0.3 + 3.2 elseif v95 then math.min(v92, 16) * 0.2 + 2 else math.min(v92, 16) * 0.35 + 3,
                    arrive = math.max(1.2, v92 * 0.08),
                    hover = if v95 then -v97.bottom + 0.05 else -v97.bottom + 1 + v92 * 0.15,
                    idleUntil = os.clock() + v1:NextNumber(0.5, 3),
                    center = Pivot.Position,
                    seed = v1:NextNumber(0, 10)
                }

                t6.height = t6.hover

                if v95 then
                    t6.targetHeight = t6.hover
                else
                    local v102 = math.clamp(15 - (t6.size + 1), 2, 7)

                    t6.targetHeight = t6.hover + v1:NextNumber(0, v102)
                end

                local v103 = t2[v90]

                if v103 and v103.aura then
                    Auras.destroy(v103.aura)
                end

                t2[v90] = nil
                t6.aura = if v94 then Auras.make(v94, v90, v92) else nil
                t2[v90] = t6
                applySettings(v90, t6)
                v90.DescendantAdded:Connect(function(p24) -- line: 172
                    -- upvalues: v90 (copy), AnimalModel (copy), t2 (copy), applyTo (copy), v95 (copy), v97 (copy), t6 (copy)
                    if t2[v90] == t6 then
                        applyTo(p24, t6.hidden, t6.fx)
                    end

                    if p24:IsA("BasePart") and t2[v90] == t6 then
                        AnimalModel.addPart(v97, p24)

                        if v95 then
                            t6.hover = -v97.bottom + 0.05
                        end
                    end
                end)
            end)
        end
    end

    for _, v104 in { "OtherAnimals", "MyAnimals", "AnimalFx" } do
        Settings.onChanged(v104, function() -- line: 345
            -- upvalues: t2 (copy), applySettings (copy)
            for v105, v106 in t2 do
                applySettings(v105, v106)
            end
        end)
    end

    local n2 = 0

    RunService.Heartbeat:Connect(function(p25) -- line: 353
        -- upvalues: n2 (ref), Auras (copy), t2 (copy), step (copy), updateTags (copy), updateHover (copy)
        local elapsed = os.clock()

        n2 += p25

        if n2 >= 0.2 then
            n2 = 0
            updateTags()
        end

        local CFramePosition = workspace.CurrentCamera.CFrame.Position

        for v107, v108 in t2 do
            local Magnitude = (v108.pos - CFramePosition).Magnitude

            if v107.Parent then
                if Magnitude < 300 and not v108.hidden then
                    step(v107, v108, elapsed, p25)
                end

                if v108.aura then
                    Auras.setActive(v108.aura, Magnitude < 160 and v108.fx and not v108.hidden)
                end
            else
                local v109 = t2[v107]

                if v109 and v109.aura then
                    Auras.destroy(v109.aura)
                end

                t2[v107] = nil
            end
        end

        updateHover()
    end)
end

return t1
