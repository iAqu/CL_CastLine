-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Directory = require(ReplicatedStorage.Data.Assets).Directory
local Audio = require(ReplicatedStorage.Shared.Audio)
local Confetti = require(ReplicatedStorage.Client.UI.VFX.Confetti)
local Flash = require(ReplicatedStorage.Client.UI.VFX.Flash)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local ItemDisplay = require(ReplicatedStorage.Shared.Modules.ItemDisplay)
local ModelBounds = require(ReplicatedStorage.Shared.Utils.ModelBounds)
local Mutations = require(ReplicatedStorage.Shared.Modules.Mutations)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local PetWheel = require(ReplicatedStorage.Data.PetWheel)
local Rarities = require(ReplicatedStorage.Data.Rarity).Rarities
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Shake = require(ReplicatedStorage.Client.Shake)
local Spring = require(ReplicatedStorage.Packages.Spring)
local SwapGradient = require(ReplicatedStorage.Shared.Utils.SwapGradient)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = NumberRange.new(4.6, 5.6)
local v2 = Color3.fromRGB(70, 40, 110)
local v3 = Color3.fromRGB(255, 236, 170)
local v4 = Color3.fromRGB(150, 140, 175)
local t1 = {
    PetWheel = true,
    OverlayUI = true
}
local _ = {
    Tick = 137872392480008,
    Deposit = 133204478644023,
    Whoosh = 3755636638,
    Riser = 101937236820642,
    Impact = 138533090376585,
    Poof = 71827381891260,
    Mutate = 139860804876890,
    BigWin = 81538018128209,
    Finale = 119977062667102
}
local LocalPlayer = Players.LocalPlayer
local v5 = Random.new()
local v6 = false
local t2 = {}

local function spinCurve(p1) -- line: 98
    if p1 < 0.06 then
        return (p1 / 0.06) ^ 2 * 0.07
    end

    return (1 - (1 - (p1 - 0.06) / 0.94) ^ 4) * 0.9299999999999999 + 0.07
end

local function petName(p2) -- line: 108
    -- upvalues: Directory (copy)
    return Directory[p2].DisplayName
end

local function mutationColor(p3) -- line: 112
    -- upvalues: Mutations (copy), v4 (copy)
    if p3 == Mutations.NO_MUTATION then
        return v4
    end

    return assert(Mutations.Get(p3), (("Unknown mutation %*"):format(p3))).Tint
end

local function playSound(p4, p5) -- line: 119
    -- upvalues: Audio (copy)
    return Audio.Play(p4, script, {
        Volume = p5 or 0.8
    })
end

function t2.Start() -- line: 123
    -- upvalues: Debris (copy), Players (copy), ProximityPromptService (copy), ReplicatedStorage (copy), RunService (copy), StarterGui (copy), TweenService (copy), Workspace (copy), Directory (copy), Audio (copy), Confetti (copy), Flash (copy), HiddenUIHandler (copy), ItemDisplay (copy), ModelBounds (copy), Mutations (copy), Toast (copy), PetWheel (copy), Rarities (copy), Remotes (copy), Shake (copy), Spring (copy), SwapGradient (copy), Trove (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), t1 (copy), LocalPlayer (copy), v5 (copy), v6 (ref)
    local Machines = Workspace:WaitForChild("World"):WaitForChild("Machines")
    local PetWheel2 = Machines:FindFirstChild("PetWheel")
    local PetWheel3 = PetWheel2

    while not PetWheel2 do
        PetWheel2 = Machines.ChildAdded:Wait()

        if PetWheel2.Name == "PetWheel" then
            PetWheel3 = PetWheel2
        else
            PetWheel3 = nil
            PetWheel2 = nil
        end
    end

    assert(PetWheel2:IsA("Model"), "PetWheel must be a Model")

    local Root = PetWheel2:WaitForChild("Root")
    local PetSpot = Root:WaitForChild("PetSpot")
    local WideFocus = Root:WaitForChild("WideFocus")
    local WideRadius = PetWheel2:GetAttribute("WideRadius")
    local PetLight = PetWheel2:WaitForChild("Body"):WaitForChild("PedestalTop"):WaitForChild("PetLight")
    local ProximityPrompt = PetWheel2:WaitForChild("Machine"):WaitForChild("Attachment"):WaitForChild("ProximityPrompt")
    local PetWheel4 = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("PetWheel")
    local Banner = PetWheel4:WaitForChild("Banner")
    local Heading = Banner:WaitForChild("Heading")
    local Result = Banner:WaitForChild("Result")
    local Detail = Banner:WaitForChild("Detail")
    local Sparkles = ReplicatedStorage.Assets.Particles.Sparkles
    local PlayerModule = require((LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")))
    local v9 = -Root.CFrame.LookVector

    local function buildWheel(p6, p7) -- line: 150
        -- upvalues: PetWheel3 (ref), Spring (copy), v3 (copy)
        local v10 = PetWheel3:WaitForChild((("%*Wheel"):format(p6)))

        assert(v10:GetAttribute("Segments") == #p7, (("PetWheel %*Wheel was built for a different segment list; rebuild it"):format(p6)))

        local Hub = v10:WaitForChild("Hub")
        local Pivot = PetWheel3:WaitForChild((("%*Pointer"):format(p6))):WaitForChild("Pivot")
        local t3 = {}

        for _, child in PetWheel3:WaitForChild((("%*Bulbs"):format(p6))):GetChildren() do
            t3[child:GetAttribute("Index")] = child
        end

        local n1 = 0

        for _, v13 in p7 do
            n1 += v13.Weight
        end

        local t4 = {}
        local t5 = {}
        local t6 = {}
        local n2 = 0

        for v14, v15 in p7 do
            t4[v14] = n2
            t5[v14] = v15.Weight / n1 * 6.283185307179586
            table.insert(t6, (6.283185307179586 - n2) % 6.283185307179586)
            n2 += t5[v14]
        end

        table.sort(t6)

        local t7 = {}

        for _, descendant in v10:GetDescendants() do
            local Segment = descendant:GetAttribute("Segment")

            if typeof(Segment) == "number" and descendant:IsA("BasePart") then
                t7[Segment] = t7[Segment] or {}
                table.insert(t7[Segment], descendant)
            end
        end

        local v18 = Spring.new(0)

        v18.Speed = 22
        v18.Damper = 0.42

        return {
            Angle = 0,
            Count = 0,
            BulbMode = "Idle",
            LastTick = 0,
            Hub = Hub,
            Rest = Hub.CFrame,
            Pointer = Pivot,
            PointerRest = Pivot.CFrame,
            PointerSpring = v18,
            Bulbs = t3,
            BulbColor = v3,
            Starts = t4,
            Spans = t5,
            Marks = t6,
            Radius = v10:GetAttribute("Radius"),
            Slices = t7
        }
    end

    local v19 = buildWheel("Rarity", PetWheel.Rarity)
    local v20 = buildWheel("Mutation", PetWheel.Mutation)
    local t8 = {
        v19,
        v20
    }

    local function crossings(p8, p9) -- line: 210
        local v22 = math.floor(p9 / 6.283185307179586)
        local v23 = p9 - v22 * 6.283185307179586
        local n3 = 0

        for _, v24 in p8.Marks do
            if v24 <= v23 then
                n3 += 1
            end
        end

        return v22 * #p8.Marks + n3
    end

    local function render(p10, p11, p12) -- line: 222
        -- upvalues: Audio (copy)
        p10.Hub.CFrame = p10.Rest * CFrame.Angles(0, 0, -p11)

        local v26 = math.floor(p11 / 6.283185307179586)
        local v27 = p11 - v26 * 6.283185307179586
        local n4 = 0

        for _, v28 in p10.Marks do
            if v28 <= v27 then
                n4 += 1
            end
        end

        local v29 = v26 * #p10.Marks + n4

        if p12 and p10.Count < v29 then
            p10.PointerSpring:Impulse(38 * p10.PointerSpring.Speed)

            local elapsed = os.clock()

            if elapsed - p10.LastTick > 0.035 then
                p10.LastTick = elapsed
                Audio.Play(137872392480008, script, {
                    Volume = 0.75,
                    PlaybackSpeed = { 0.96, 1.06 }
                })
            end
        end

        p10.Count = v29
    end

    local function landingAngle(p13, p14) -- line: 236
        -- upvalues: v5 (copy)
        local v30 = v5:NextNumber()
        local v31 = if v30 < 0.24 then v5:NextNumber(0.05, 0.14) elseif v30 < 0.48 then v5:NextNumber(0.86, 0.95) else v5:NextNumber(0.25, 0.75)

        return p13.Starts[p14] + p13.Spans[p14] * v31
    end

    local function spin(p15, p16) -- line: 245
        -- upvalues: render (copy), landingAngle (copy), RunService (copy), TweenService (copy), Audio (copy), v1 (copy), v5 (copy)
        local Angle = p15.Angle
        local v32 = -landingAngle(p15, p16) % 6.283185307179586
        local v33 = Angle - Angle % 6.283185307179586 + v32 + 6.283185307179586 * v5:NextInteger(4, 6)
        local v35 = math.rad((v5:NextNumber(1.5, 3.2)))
        local v36 = v33 - v35
        local v37 = v5:NextNumber(v1.Min, v1.Max)
        local v39 = math.floor(Angle / 6.283185307179586)
        local v40 = Angle - v39 * 6.283185307179586
        local n5 = 0

        for _, v41 in p15.Marks do
            if v41 <= v40 then
                n5 += 1
            end
        end

        p15.Count = v39 * #p15.Marks + n5
        p15.BulbMode = "Spin"
        Audio.Play(3755636638, script, {
            Volume = 0.6
        })

        local elapsed = os.clock()
        local v42

        while true do
            local v44 = math.clamp((os.clock() - elapsed) / v37, 0, 1)

            render(p15, Angle + (v36 - Angle) * (if v44 < 0.06 then (v44 / 0.06) ^ 2 * 0.07 else (1 - (1 - (v44 - 0.06) / 0.94) ^ 4) * 0.9299999999999999 + 0.07), true)

            if v44 >= 0.5 and v42 == nil then
                v42 = Audio.Play(101937236820642, script, {
                    Volume = 0.45
                })
            end

            if v44 >= 1 then
                break
            end

            RunService.RenderStepped:Wait()
        end

        task.wait(0.14)

        local elapsed2 = os.clock()

        while true do
            local v48 = math.clamp((os.clock() - elapsed2) / 0.5, 0, 1)

            render(p15, v36 + v35 * TweenService:GetValue(v48, Enum.EasingStyle.Back, Enum.EasingDirection.Out), true)

            if v48 >= 1 then
                break
            end

            RunService.RenderStepped:Wait()
        end

        if v42 then
            v42:Stop()
        end

        p15.Angle = v33 % 6.283185307179586

        local Angle2 = p15.Angle

        p15.Hub.CFrame = p15.Rest * CFrame.Angles(0, 0, -Angle2)

        local v50 = math.floor(Angle2 / 6.283185307179586)
        local v51 = Angle2 - v50 * 6.283185307179586
        local n6 = 0

        for _, v52 in p15.Marks do
            if v52 <= v51 then
                n6 += 1
            end
        end

        p15.Count = v50 * #p15.Marks + n6
    end

    local function stepBulbs() -- line: 288
        -- upvalues: t8 (copy), v2 (copy), v3 (copy)
        local elapsed = os.clock()

        for _, v53 in t8 do
            local v54 = #v53.Bulbs

            for v55, v56 in v53.Bulbs do
                local v57 = if v53.BulbMode == "Win" then if (v55 + math.floor(elapsed * 8)) % 2 == 0 then v53.BulbColor else v3
                    elseif v53.BulbMode == "Spin" then if (v55 + math.floor(elapsed * 22)) % 3 == 0 then v3 else v53.BulbColor
                    elseif (v55 + math.floor(elapsed * 5)) % 4 == 0 then v3
                    else v2

                if v56.Color ~= v57 then
                    v56.Color = v57
                end
            end

            if v54 > 0 and v53.BulbMode == "Spin" then
                v53.BulbColor = Color3.fromHSV(elapsed * 0.6 % 1, 0.7, 1)
            end

            local v61 = math.clamp(v53.PointerSpring.Position, -10, 34)

            v53.Pointer.CFrame = v53.PointerRest * CFrame.Angles(0, 0, (math.rad(v61)))
        end
    end

    local function shot(p17, p18, p19) -- line: 313
        -- upvalues: v9 (copy), Workspace (copy)
        local CurrentCamera = Workspace.CurrentCamera
        local ViewportSize = CurrentCamera.ViewportSize
        local v62 = if ViewportSize.Y > 0 then ViewportSize.X / ViewportSize.Y else 1
        local v65 = p18 / (math.tan((math.rad(CurrentCamera.FieldOfView / 2))) * math.min(1, v62)) * 1.06
        local Unit = (v9 + Vector3.new(0, p19, 0)).Unit

        return CFrame.lookAt(p17 + Unit * v65, p17)
    end

    local function moveCamera(p20, p21) -- line: 323
        -- upvalues: TweenService (copy), Workspace (copy)
        local tween = TweenService:Create(Workspace.CurrentCamera, TweenInfo.new(p21, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {
            CFrame = p20
        })

        tween:Play()
        tween.Completed:Wait()
    end

    local function focusWheel(p22) -- line: 334
        -- upvalues: shot (copy), moveCamera (copy), TweenService (copy), Workspace (copy), v1 (copy)
        local v66 = p22.Rest.Position + Vector3.new(0, 0.5, 0)

        moveCamera(shot(v66, p22.Radius * 1.15, 0.03), 0.75)
        TweenService:Create(Workspace.CurrentCamera, TweenInfo.new(v1.Min, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            CFrame = shot(v66, p22.Radius * 0.92, 0)
        }):Play()
    end

    local function glowSegment(p23, p24) -- line: 344
        local v67 = p23.Slices[p24]
        local t9 = {}

        for _, v68 in v67 do
            t9[v68] = v68.Color
        end

        task.spawn(function() -- line: 350
            -- upvalues: t9 (copy)
            for i = 1, 8 do
                local v69 = i % 2 == 1

                for v70, v71 in t9 do
                    if v69 then
                        v70.Material = Enum.Material.Neon
                        v70.Color = v71:Lerp(Color3.new(1, 1, 1), 0.25)
                    else
                        v70.Material = Enum.Material.SmoothPlastic
                        v70.Color = v71
                    end
                end

                task.wait(0.14)
            end

            for v72, v73 in t9 do
                v72.Material = Enum.Material.SmoothPlastic
                v72.Color = v73
            end
        end)
    end

    local function burst(p25, p26, p27) -- line: 366
        -- upvalues: Sparkles (copy), Debris (copy), Workspace (copy)
        local Part = Instance.new("Part")

        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.Transparency = 1
        Part.Size = Vector3.new(1, 1, 1)
        Part.CFrame = CFrame.new(p25)
        Part.Parent = Workspace

        local Attachment = Instance.new("Attachment")

        Attachment.Parent = Part

        for _, child in Sparkles:GetChildren() do
            if child:IsA("ParticleEmitter") then
                local clone = child:Clone()

                clone.Color = ColorSequence.new(p26, Color3.new(1, 1, 1))
                clone.Enabled = false
                clone.Parent = Attachment
                clone:Emit(p27)
            end
        end

        Debris:AddItem(Part, 4)
    end

    local function setLabel(p28, p29) -- line: 390
        -- upvalues: TweenService (copy)
        p28.Text = p29
        p28.Visible = true

        local Pop = p28:FindFirstChild("Pop")

        Pop.Scale = 0.2
        TweenService:Create(Pop, TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
    end

    local function paintResult(p30, p31) -- line: 402
        -- upvalues: Result (copy), SwapGradient (copy)
        if p31 then
            SwapGradient(Result, p31)
        else
            local v74 = Result:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")

            v74.Color = p30 or ColorSequence.new(Color3.new(1, 1, 1))
            v74.Transparency = NumberSequence.new(0)
            v74.Rotation = 90
            v74.Offset = Vector2.zero
            v74.Parent = Result
        end
    end

    local function mutationColors(p32) -- line: 415
        -- upvalues: Mutations (copy), v4 (copy)
        if p32 == "Rainbow" then
            local t10 = {}

            for i = 0, 6 do
                table.insert(t10, ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6, 0.75, 1)))
            end

            return ColorSequence.new(t10)
        end

        local v77 = if p32 == Mutations.NO_MUTATION then v4 else assert(Mutations.Get(p32), (("Unknown mutation %*"):format(p32))).Tint

        return ColorSequence.new(v77:Lerp(Color3.new(1, 1, 1), 0.45), v77)
    end

    local function placeDisplay(p33) -- line: 427
        -- upvalues: v9 (copy)
        local Model = p33.Model
        local v81 = math.sin(os.clock() * 1.3) * 0.35 + p33.Spin
        local v83 = math.sin(os.clock() * 2.2) * 0.12
        local v84 = CFrame.lookAt(Vector3.new(0, 0, 0), v9) * CFrame.Angles(0, v81, 0)

        Model:PivotTo(CFrame.new(p33.Spot.Position + Vector3.new(0, p33.Lift * p33.Size + v83, 0)) * v84)
    end

    local function showPet(p34, p35) -- line: 436
        -- upvalues: PetSpot (copy), v9 (copy), Workspace (copy), ItemDisplay (copy), ModelBounds (copy)
        local v86 = ItemDisplay.CreateActiveModel(nil, p34, true)

        v86.Name = "PetWheelDisplay"

        for _, descendant in v86:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = true
                descendant.CanCollide = false
                descendant.CanQuery = false
                descendant.CanTouch = false
            end
        end

        v86:PivotTo(CFrame.lookAt(Vector3.new(0, 0, 0), v9))

        local _, v87 = ModelBounds(v86)
        local v90 = math.min(4.8 / v87.Y, 5.6 / math.max(v87.X, v87.Z))

        v86:ScaleTo(v86:GetScale() * v90)

        local v91, v92 = ModelBounds(v86)
        local v93 = v86:GetPivot().Position.Y - (v91.Position.Y - v92.Y / 2)
        local Scale = v86:GetScale()

        v86.Parent = Workspace
        p35:Add(v86)

        local t11 = {
            Size = 1,
            Spin = 0,
            Model = v86,
            Spot = PetSpot.WorldCFrame,
            Lift = v93
        }

        t11.Model:SetAttribute("FullScale", Scale)

        return t11
    end

    local function grow(p36, p37, p38, p39, p40) -- line: 467
        -- upvalues: placeDisplay (copy), RunService (copy), TweenService (copy)
        local FullScale = p36.Model:GetAttribute("FullScale")
        local elapsed = os.clock()

        while true do
            local v95 = math.clamp((os.clock() - elapsed) / p39, 0, 1)
            local Value = TweenService:GetValue(v95, p40, if p37 < p38 then Enum.EasingDirection.Out else Enum.EasingDirection.In)

            p36.Size = math.max(p37 + (p38 - p37) * Value, 0.02)
            p36.Model:ScaleTo(FullScale * p36.Size)
            placeDisplay(p36)

            if v95 >= 1 then
                break
            end

            RunService.RenderStepped:Wait()
        end
    end

    local function swapPet(p41, p42, p43, p44) -- line: 483
        -- upvalues: burst (copy), placeDisplay (copy), showPet (copy), grow (copy), RunService (copy), Audio (copy), Flash (copy), Shake (copy)
        local elapsed = os.clock()

        while os.clock() - elapsed < 0.7 do
            local v98 = (os.clock() - elapsed) / 0.7

            p41.Spin += v98 * 0.9
            placeDisplay(p41)
            RunService.RenderStepped:Wait()
        end

        grow(p41, p41.Size, 0, 0.16, Enum.EasingStyle.Quad)
        p41.Model:Destroy()
        burst(p41.Spot.Position + Vector3.new(0, 2.4, 0), p44, 40)
        Flash.Play({
            Attack = 0.04,
            Decay = 0.4,
            Opacity = 0.6,
            Tint = p44
        })
        Shake.Play({
            Seconds = 0.35
        })
        Audio.Play(71827381891260, script, {
            Volume = 0.9
        })

        local v100 = showPet(p42, p43)

        grow(v100, 0, 1, 0.5, Enum.EasingStyle.Back)

        return v100
    end

    local function celebrate(p45, p46, p47, p48) -- line: 503
        -- upvalues: PetLight (copy), glowSegment (copy), burst (copy), TweenService (copy), Audio (copy), Confetti (copy), Flash (copy), Shake (copy), v3 (copy)
        p45.BulbMode = "Win"
        p45.BulbColor = p47
        glowSegment(p45, p46)
        TweenService:Create(PetLight, TweenInfo.new(0.4), {
            Brightness = 3,
            Color = p47
        }):Play()
        Audio.Play(138533090376585, script, {
            Volume = 0.7
        })
        Flash.Play({
            Attack = 0.03,
            Decay = 0.35,
            Opacity = 0.45,
            Tint = p47
        })
        Shake.Play({
            Seconds = 0.3
        })
        burst(p45.PointerRest.Position, p47, 30)

        if p48 then
            Audio.Play(81538018128209, script, {
                Volume = 0.9
            })
            Confetti.Burst({
                Palette = {
                    p47,
                    Color3.new(1, 1, 1),
                    v3
                }
            })
        end
    end

    local function run(p49, p50) -- line: 518
        -- upvalues: PetSpot (copy), WideFocus (copy), WideRadius (copy), PetLight (copy), Banner (copy), Heading (copy), Result (copy), Detail (copy), v19 (copy), v20 (copy), spin (copy), shot (copy), moveCamera (copy), focusWheel (copy), burst (copy), setLabel (copy), paintResult (copy), mutationColors (copy), placeDisplay (copy), showPet (copy), grow (copy), swapPet (copy), celebrate (copy), RunService (copy), Workspace (copy), Directory (copy), Audio (copy), Confetti (copy), Mutations (copy), PetWheel (copy), Rarities (copy), v3 (copy), v4 (copy)
        local Before, After = p49.Before, p49.After
        local Id = PetWheel.Rarity[p49.Rarity].Id
        local Id2 = PetWheel.Mutation[p49.Mutation].Id
        local v101 = Rarities[Id]
        local v102 = Id2 ~= Mutations.NO_MUTATION
        local v103 = table.clone(After)

        v103.Mutations = Before.Mutations
        v103.BaseMutation = Before.BaseMutation

        local CurrentCamera = Workspace.CurrentCamera
        local CameraType = CurrentCamera.CameraType

        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        p50:Add(function() -- line: 531
            -- upvalues: CurrentCamera (copy), CameraType (copy)
            CurrentCamera.CameraType = CameraType
        end)

        local v104 = PetSpot.WorldPosition + Vector3.new(0, 2.16, 0)
        local Color, Brightness = PetLight.Color, PetLight.Brightness

        p50:Add(function() -- line: 537
            -- upvalues: Color (copy), Brightness (copy), PetLight (copy)
            PetLight.Color = Color
            PetLight.Brightness = Brightness
        end)
        moveCamera(shot(WideFocus.WorldPosition, WideRadius, 0.1), 0.9)

        local v105 = showPet(Before, p50)
        local v106 = v105

        Audio.Play(133204478644023, script, {
            Volume = 0.9
        })
        burst(v104, v3, 25)
        grow(v105, 0, 1, 0.45, Enum.EasingStyle.Back)

        local v107 = true

        p50:Add(function() -- line: 547
            -- upvalues: v107 (ref)
            v107 = false
        end)
        task.spawn(function() -- line: 550
            -- upvalues: v106 (ref), v107 (ref), placeDisplay (copy), RunService (copy)
            while v107 do
                if v106.Model.Parent then
                    placeDisplay(v106)
                end

                RunService.RenderStepped:Wait()
            end
        end)
        task.wait(0.5)
        Banner.Visible = true
        Result.Visible = false
        Detail.Visible = false
        setLabel(Heading, "RARITY WHEEL")
        focusWheel(v19)
        spin(v19, p49.Rarity)
        celebrate(v19, p49.Rarity, v101.Color, v101.Rank >= 8)
        paintResult(nil, v101.RarityGradient)
        setLabel(Result, (("%*!"):format((string.upper(v101.DisplayName)))))
        task.wait(1.2)
        moveCamera(shot(v104, 4.6, 0.18), 0.6)
        v106 = swapPet(v106, v103, p50, v101.Color)
        setLabel(Detail, Directory[After.Category].DisplayName)
        task.wait(1.3)
        v19.BulbMode = "Idle"
        Result.Visible = false
        Detail.Visible = false
        Heading.Visible = false
        focusWheel(v20)
        spin(v20, p49.Mutation)

        local v108 = if Id2 == Mutations.NO_MUTATION then v4 else assert(Mutations.Get(Id2), (("Unknown mutation %*"):format(Id2))).Tint

        celebrate(v20, p49.Mutation, v108, Id2 == "Rainbow" or Id2 == "Golden")

        if not v102 then
            Audio.Chime("Failure")
        end

        paintResult(mutationColors(Id2), nil)
        setLabel(Result, if v102 then ("%*!"):format((string.upper(Mutations.LabelOf(Id2)))) else "NO MUTATION")
        task.wait(1.2)
        moveCamera(shot(v104, 4.6, 0.18), 0.6)

        if v102 then
            v106 = swapPet(v106, After, p50, v108)
            Audio.Play(139860804876890, script, {
                Volume = 0.9
            })
        end

        v20.BulbMode = "Idle"
        Audio.Play(119977062667102, script, {
            Volume = 0.7
        })
        Confetti.Burst({
            Palette = {
                v101.Color,
                v108,
                v3
            }
        })
        paintResult(nil, v101.RarityGradient)
        setLabel(Heading, "YOU GOT")
        setLabel(Result, if v102 then ("%* %*"):format(Mutations.LabelOf(Id2), Directory[After.Category].DisplayName) else Directory[After.Category].DisplayName)
        setLabel(Detail, v101.DisplayName)
        task.wait(2.6)
        Banner.Visible = false
        grow(v106, v106.Size, 0, 0.3, Enum.EasingStyle.Back)
    end

    local function hideInterface() -- line: 607
        -- upvalues: PetWheel4 (copy), Players (copy), ProximityPromptService (copy), StarterGui (copy), Workspace (copy), t1 (copy), LocalPlayer (copy)
        local t12 = {}
        local t13 = {}

        local function suppress(p51) -- line: 611
            -- upvalues: t12 (copy), t13 (copy)
            local v115 = p51.Enabled

            p51.Enabled = false
            table.insert(t12, p51:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 614
                -- upvalues: p51 (copy), v115 (ref)
                if p51.Enabled then
                    v115 = true
                    p51.Enabled = false
                end
            end))
            table.insert(t13, function() -- line: 620
                -- upvalues: p51 (copy), v115 (ref)
                if p51.Parent then
                    p51.Enabled = v115
                end
            end)
        end

        local function consider(p52) -- line: 627
            -- upvalues: suppress (copy), t1 (copy)
            if p52:IsA("BillboardGui") or p52:IsA("ScreenGui") and not t1[p52.Name] then
                suppress(p52)
            end
        end

        for _, v118 in {
                PetWheel4.Parent,
                Workspace
            } do
            for _, descendant in v118:GetDescendants() do
                if descendant:IsA("BillboardGui") or descendant:IsA("ScreenGui") and not t1[descendant.Name] then
                    suppress(descendant)
                end
            end

            table.insert(t12, v118.DescendantAdded:Connect(consider))
        end

        local function hideBody(p53) -- line: 640
            -- upvalues: t13 (copy)
            if not (p53:IsA("BasePart") or p53:IsA("Decal")) then
                if p53:IsA("Trail") or p53:IsA("ParticleEmitter") or p53:IsA("Beam") then
                    local Enabled = p53.Enabled

                    p53.Enabled = false
                    table.insert(t13, function() -- line: 650
                        -- upvalues: p53 (copy), Enabled (copy)
                        p53.Enabled = Enabled
                    end)
                end
            else
                local Transparency = p53.Transparency

                p53.Transparency = 1
                table.insert(t13, function() -- line: 644
                    -- upvalues: p53 (copy), Transparency (copy)
                    p53.Transparency = Transparency
                end)
            end
        end

        local Character = LocalPlayer.Character

        if Character then
            for _, descendant in Character:GetDescendants() do
                hideBody(descendant)
            end

            table.insert(t12, Character.DescendantAdded:Connect(hideBody))
        end

        for _, player in Players:GetPlayers() do
            local Character = player.Character
            local Humanoid = if Character then Character:FindFirstChildOfClass("Humanoid") else nil

            if Humanoid then
                local DisplayDistanceType = Humanoid.DisplayDistanceType

                Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                table.insert(t13, function() -- line: 670
                    -- upvalues: Humanoid (copy), DisplayDistanceType (copy)
                    Humanoid.DisplayDistanceType = DisplayDistanceType
                end)
            end
        end

        local t14 = {}

        for _, v122 in Enum.CoreGuiType:GetEnumItems() do
            if v122 ~= Enum.CoreGuiType.All then
                t14[v122] = StarterGui:GetCoreGuiEnabled(v122)
            end
        end

        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

        local GetCore = StarterGui.GetCore
        local TopbarEnabled, TopbarEnabled2 = pcall(GetCore, StarterGui, "TopbarEnabled")
        local SetCore = StarterGui.SetCore

        pcall(SetCore, StarterGui, "TopbarEnabled", false)

        local Enabled = ProximityPromptService.Enabled

        ProximityPromptService.Enabled = false
        table.insert(t13, function() -- line: 687
            -- upvalues: t14 (copy), TopbarEnabled (copy), TopbarEnabled2 (copy), Enabled (copy), ProximityPromptService (copy), StarterGui (copy)
            for v124, v125 in t14 do
                StarterGui:SetCoreGuiEnabled(v124, v125)
            end

            local SetCore = StarterGui.SetCore
            local v126 = not TopbarEnabled or TopbarEnabled2

            pcall(SetCore, StarterGui, "TopbarEnabled", v126)
            ProximityPromptService.Enabled = Enabled
        end)

        return function() -- line: 695
            -- upvalues: t12 (copy), t13 (copy)
            for _, v127 in t12 do
                v127:Disconnect()
            end

            for _, v128 in t13 do
                v128()
            end
        end
    end

    local function play(p54) -- line: 705
        -- upvalues: ProximityPrompt (copy), Banner (copy), PlayerModule (copy), t8 (copy), run (copy), hideInterface (copy), HiddenUIHandler (copy), Remotes (copy), Trove (copy), v6 (ref)
        v6 = true
        ProximityPrompt.Enabled = false

        local v129 = Trove.new()

        v129:Add(HiddenUIHandler.Acquire())
        v129:Add((hideInterface()))

        local Controls = PlayerModule:GetControls()

        Controls:Disable()
        v129:Add(function() -- line: 713
            -- upvalues: Controls (copy)
            Controls:Enable()
        end)

        local traceback = debug.traceback
        local v130, v131 = xpcall(run, traceback, p54, v129)

        Banner.Visible = false

        for _, v132 in t8 do
            v132.BulbMode = "Idle"
        end

        v129:Destroy()
        Remotes.PetWheel.Finish:FireServer()
        ProximityPrompt.Enabled = true
        v6 = false

        if not v130 then
            error(v131, 2)
        end
    end

    local function holdingPet() -- line: 730
        -- upvalues: LocalPlayer (copy)
        local Character = LocalPlayer.Character
        local Tool = if Character then Character:FindFirstChildOfClass("Tool") else nil

        return Tool ~= nil and Tool:GetAttribute("ItemType") == "Asset"
    end

    local function notifyError(p55) -- line: 736
        -- upvalues: Toast (copy)
        Toast.Show({
            Seconds = 3,
            Text = p55,
            Color = Color3.fromRGB(255, 0, 0)
        })
    end

    ProximityPrompt.ActionText = "Spin Pet"
    ProximityPrompt.ObjectText = "Lucky Wheels"
    ProximityPrompt.Triggered:Connect(function() -- line: 750
        -- upvalues: play (copy), Toast (copy), Remotes (copy), LocalPlayer (copy), v6 (ref)
        if v6 then
            return
        end

        local Character = LocalPlayer.Character
        local Tool = if Character then Character:FindFirstChildOfClass("Tool") else nil

        if Tool == nil or Tool:GetAttribute("ItemType") ~= "Asset" then
            Toast.Show({
                Text = "Hold a pet to spin it!",
                Seconds = 3,
                Color = Color3.fromRGB(255, 0, 0)
            })

            return
        end

        v6 = true

        local v133, v134 = Remotes.PetWheel.Spin:InvokeServer()

        if v133 then
            task.spawn(play, v134)
        else
            v6 = false

            if typeof(v134) ~= "string" then
                v134 = "The wheels jammed. Try again!"
            end

            Toast.Show({
                Seconds = 3,
                Text = v134,
                Color = Color3.fromRGB(255, 0, 0)
            })
        end
    end)
    RunService.RenderStepped:Connect(stepBulbs)
end

return t2
