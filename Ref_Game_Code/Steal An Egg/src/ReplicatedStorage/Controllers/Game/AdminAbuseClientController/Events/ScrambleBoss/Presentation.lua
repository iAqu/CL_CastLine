-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LightingController = require(ReplicatedStorage.Controllers.Game.LightingController)
local Notifications = require(ReplicatedStorage.Client.Notifications)
local CorruptedPlate = require(ReplicatedStorage.Client.Notifications.CorruptedPlate)
local TutorialBeam = require(ReplicatedStorage.Client.WorldFX.TutorialBeam)
local Kit = require(script.Parent.Kit)
local Vfx = require(script.Parent.Vfx)
local v1 = Color3.fromRGB(10, 60, 10)
local v2 = Color3.fromRGB(120, 120, 120)
local v3 = Kit.Green:ToHex()
local t1 = {
    Waiting = "DR. SCRAMBLE'S MECH",
    Mech = "DR. SCRAMBLE'S MECH",
    Ejecting = "DR. SCRAMBLE'S MECH",
    Ball = "DR. SCRAMBLE",
    Human = "DR. SCRAMBLE",
    Final = "DR. SCRAMBLE",
    Defeated = "DR. SCRAMBLE"
}
local LocalPlayer = Players.LocalPlayer
local self = setmetatable({}, {
    __mode = "k"
})

local function now() -- line: 53
    -- upvalues: Workspace (copy)
    return Workspace:GetServerTimeNow()
end

local function struggleHint() -- line: 57
    -- upvalues: UserInputService (copy)
    local LastInputType = UserInputService:GetLastInputType()

    if LastInputType == Enum.UserInputType.Touch then
        return "Tap fast to break free!"
    end

    if string.find(LastInputType.Name, "Gamepad") then
        return "Mash A to break free!"
    end

    return "Mash click or Space to break free!"
end

local function remember(p1, p2, p3) -- line: 68
    local Attribute = p1:GetAttribute(p2)

    if Attribute ~= nil then
        return Attribute
    end

    p1:SetAttribute(p2, p3)

    return p3
end

local function tintCoil(p4, p5) -- line: 79
    -- upvalues: Kit (copy), v2 (copy), self (copy)
    if self[p4] == p5 then
        return
    end

    self[p4] = p5

    for _, descendant in p4:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local Color = descendant.Color
            local CoilBaseColor = descendant:GetAttribute("CoilBaseColor")

            if CoilBaseColor ~= nil then
                Color = CoilBaseColor
            else
                descendant:SetAttribute("CoilBaseColor", Color)
            end

            local Brightness = descendant.Brightness
            local CoilBaseBrightness = descendant:GetAttribute("CoilBaseBrightness")

            if CoilBaseBrightness ~= nil then
                Brightness = CoilBaseBrightness
            else
                descendant:SetAttribute("CoilBaseBrightness", Brightness)
            end

            if p5 == "Lit" then
                Color = ColorSequence.new(Kit.Green)
            elseif p5 == "Spent" then
                Color = ColorSequence.new(v2)
            end

            descendant.Color = Color

            if p5 == "Spent" then
                Brightness *= 0.35
            end

            descendant.Brightness = Brightness
        elseif descendant:IsA("BasePart") and descendant.Material == Enum.Material.Neon then
            local Color = descendant.Color
            local CoilBaseColor = descendant:GetAttribute("CoilBaseColor")

            if CoilBaseColor ~= nil then
                Color = CoilBaseColor
            else
                descendant:SetAttribute("CoilBaseColor", Color)
            end

            descendant.Color = if p5 == "Spent" then v2 else Color
        elseif descendant:IsA("Light") then
            local Enabled = descendant.Enabled
            local CoilBaseEnabled = descendant:GetAttribute("CoilBaseEnabled")

            if CoilBaseEnabled ~= nil then
                Enabled = CoilBaseEnabled
            else
                descendant:SetAttribute("CoilBaseEnabled", Enabled)
            end

            descendant.Enabled = Enabled and p5 ~= "Spent"
        end
    end
end

local function find(p6, p7) -- line: 106
    for _, v6 in p7 do
        p6 = p6:WaitForChild(v6, 10)
        assert(p6, (("ScrambleBossUI is missing %*"):format((table.concat(p7, ".")))))
    end

    return p6
end

local t4 = {}

t4.__index = t4

function t4.new(p8, p9) -- line: 119
    -- upvalues: RunService (copy), LightingController (copy), LocalPlayer (copy), find (copy), t4 (copy)
    local v8 = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ScrambleBossUI", 20)
    local v9 = setmetatable({
        Trove = p8,
        Arena = p9,
        Gui = v8,
        BossName = find(v8, { "BossHPBar", "BossName" }),
        HealthText = find(v8, { "BossHPBar", "BarHolder", "HealthAmount" }),
        HealthHolder = find(v8, { "BossHPBar", "BarHolder" }),
        Bar = find(v8, { "BossHPBar", "BarHolder", "BarBG", "Bar" }),
        Phantom = find(v8, { "BossHPBar", "BarHolder", "BarBG", "PhantomBar" }),
        PhaseSegments = find(v8, { "BossHPBar", "BarHolder", "ShieldBarHolder" }),
        BossScale = find(v8, { "BossHPBar", "JuiceScale" }),
        TimerLabel = find(v8, { "BossHPBar", "Frame", "TimerLabel" }),
        TimerTitle = find(v8, { "BossHPBar", "Frame", "Title" }),
        TimerFrame = find(v8, { "BossHPBar", "Frame" }),
        Countdown = find(v8, { "BossHPBar", "Countdown" }),
        CountdownPlate = find(v8, { "BossHPBar", "Countdown", "Plate" }),
        CountdownBody = find(v8, { "BossHPBar", "Countdown", "Plate", "Body" }),
        CountdownText = "",
        StopCountdownGlitch = nil,
        Target = find(v8, { "Target" }),
        TargetTitle = find(v8, { "Target", "Title" }),
        TargetSub = find(v8, { "Target", "Sub" }),
        TargetCountdown = find(v8, { "Target", "Countdown" }),
        Flash = find(v8, { "Flash" }),
        DisplayedHealth = 1,
        LastHealthFraction = 1,
        LastPhase = "",
        HealthJuice = p8:Extend(),
        PhantomValue = 1,
        CrocTargetUntil = 0,
        Arrow = nil,
        ArrowKey = "",
        ArrowTarget = nil,
        Reticles = {},
        Lit = false,
        HumanFade = 0
    }, t4)

    v9.Segments = {}

    for _, child in v9.PhaseSegments:GetChildren() do
        if child:IsA("Frame") then
            table.insert(v9.Segments, child)
        end
    end

    table.sort(v9.Segments, function(p10, p11) -- line: 166
        return p10.LayoutOrder < p11.LayoutOrder
    end)
    v9.Target.Visible = false
    v9.Flash.BackgroundTransparency = 1
    v9.Countdown.Visible = false
    p8:Add(function() -- line: 174
        -- upvalues: v8 (copy), v9 (copy), LightingController (copy)
        v8.Enabled = false
        v9:SetCountdown(nil)
        v9:SetArrow("", nil)

        for _, v10 in v9.Reticles do
            v10:Destroy()
        end

        if v9.Lit then
            LightingController.ClearLayer("ScrambleBoss", 2)
        end
    end)
    p8:Connect(RunService.RenderStepped, function(p12) -- line: 186
        -- upvalues: v9 (copy)
        v9:Step(p12)
    end)

    return v9
end

function t4.PunchHealth(p13, p14) -- line: 193
    -- upvalues: GuiService (copy), TweenService (copy)
    p13.HealthJuice:Clean()

    if GuiService.ReducedMotionEnabled then
        p13.BossScale.Scale = 1
        p13.HealthHolder.Rotation = 0
    else
        local v11 = p13.Gui.BossHPBar:GetAttribute("HealthPunchScale") or 1.06
        local BossScale = p13.BossScale

        if p14 then
            v11 += 0.04
        end

        BossScale.Scale = v11
        p13.HealthHolder.Rotation = math.random() < 0.5 and -1.5 or 1.5

        local tween = TweenService:Create(p13.BossScale, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        })
        local tween2 = TweenService:Create(p13.HealthHolder, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Rotation = 0
        })

        p13.HealthJuice:Add(tween)
        p13.HealthJuice:Add(tween2)
        tween:Play()
        tween2:Play()
    end
end

function t4.SetPhaseSegments(p15, p16) -- line: 220
    for v12, v13 in p15.Segments do
        local Fill = v13:FindFirstChild("Fill")

        if Fill then
            local v15 = math.clamp(p16 * #p15.Segments - (v12 - 1), 0, 1)

            Fill.Visible = v15 > 0
            Fill.Size = UDim2.fromScale(v15, 1)
        end
    end
end

function t4.FadeHuman(p17, p18, p19) -- line: 231
    local v16 = if p19 then math.floor(os.clock() * 12) % 2 == 0 else nil
    local v18 = if not p19 or not v16 then 0 else 0.6

    if p18 ~= nil and v18 ~= p17.HumanFade then
        p17.HumanFade = v18

        for _, descendant in p18:GetDescendants() do
            if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                descendant.LocalTransparencyModifier = v18
            end
        end
    end
end

function t4.InArena(_) -- line: 247
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("InScrambleArena") == true
end

function t4.SetArrow(p21, p22, p23) -- line: 251
    -- upvalues: TutorialBeam (copy), LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if p23 ~= nil and HumanoidRootPart ~= nil then
        local v19 = if typeof(p23) == "Vector3" then p23 else p23.Position
        local v20 = Vector3.new(v19.X, HumanoidRootPart.Position.Y, v19.Z)

        p21.ArrowKey = p22
        p21.ArrowTarget = p23

        if p21.Arrow then
            TutorialBeam.Retarget(p21.Arrow, v20)
        else
            p21.Arrow = TutorialBeam.Attach(v20)
        end
    else
        if p21.Arrow then
            TutorialBeam.Destroy(p21.Arrow)
            p21.Arrow = nil
        end

        if p23 ~= nil then
            p21.ArrowKey = ""
        else
            p21.ArrowKey = p22
        end

        p21.ArrowTarget = nil
    end
end

function t4.Say(p24, p25, p26, p27) -- line: 275
    -- upvalues: Notifications (copy), Kit (copy), v1 (copy)
    if not p24:InArena() then
        return
    end

    local v21 = p26 ~= nil and p26 ~= ""

    Notifications.Toast.Show({
        Lane = "Banner",
        SingleLine = true,
        Unique = true,
        Corrupted = true,
        Text = p25,
        Seconds = p27 or 2.5,
        PreText = if v21 then {
            Text = ("%*:"):format(p26),
            Color = Kit.Green,
            StrokeColor = v1
        } else nil
    })
end

function t4.SetCountdown(p28, p29) -- line: 294
    -- upvalues: CorruptedPlate (copy)
    if p29 ~= nil then
        local CountdownBody = p28.CountdownBody

        if p29 ~= p28.CountdownText then
            p28.CountdownText = p29
            CountdownBody.Text = p29
        end

        local v22 = math.max(p28.BossScale.Scale, 0.01)
        local v24 = math.floor(p28.CountdownPlate.AbsoluteSize.Y / v22)

        if v24 > 0 and CountdownBody.TextSize ~= v24 then
            CountdownBody.TextSize = v24
        end

        p28.TimerFrame.Visible = false
        p28.Countdown.Visible = true

        if p28.StopCountdownGlitch == nil then
            p28.StopCountdownGlitch = CorruptedPlate.Attach(p28.Countdown, p28.CountdownPlate)
        end
    else
        if p28.StopCountdownGlitch then
            p28.StopCountdownGlitch()
            p28.StopCountdownGlitch = nil
        end

        p28.Countdown.Visible = false
        p28.TimerFrame.Visible = true
        p28.CountdownText = ""
    end
end

function t4.FlashScreen(p30, p31, p32, p33) -- line: 325
    -- upvalues: TweenService (copy)
    p30.Flash.BackgroundColor3 = p31
    p30.Flash.BackgroundTransparency = 1 - (p33 or 0.6)
    TweenService:Create(p30.Flash, TweenInfo.new(p32), {
        BackgroundTransparency = 1
    }):Play()
end

function t4.CrocTarget(p34, p35, p36) -- line: 331
    -- upvalues: Players (copy), Kit (copy), Vfx (copy), LocalPlayer (copy)
    for v25, v26 in p34.Reticles do
        v26:Destroy()
        p34.Reticles[v25] = nil
    end

    local PlayerByUserId = Players:GetPlayerByUserId(p35)
    local v27 = PlayerByUserId and PlayerByUserId.Character and PlayerByUserId.Character:FindFirstChild("HumanoidRootPart")
    local v28 = v27 and Vfx.Stamp("CrocTarget", v27, p36, true)

    if PlayerByUserId and v28 then
        p34.Reticles[PlayerByUserId] = v28
        task.delay(p36, function() -- line: 344
            -- upvalues: p34 (copy), PlayerByUserId (copy), v28 (copy)
            if p34.Reticles[PlayerByUserId] == v28 then
                v28:Destroy()
                p34.Reticles[PlayerByUserId] = nil
            end
        end)
    end

    if p35 ~= LocalPlayer.UserId then
        return
    end

    p34.CrocTargetUntil = os.clock() + p36
    Kit.Sound("Tick", nil, 1, 1.4)
    p34:FlashScreen(Kit.Red, 0.5, 0.35)
end

function t4.Step(p37, p38) -- line: 359
    -- upvalues: Players (copy), GuiService (copy), UserInputService (copy), Workspace (copy), LightingController (copy), Kit (copy), v2 (copy), v3 (copy), t1 (copy), LocalPlayer (copy), tintCoil (copy)
    local Arena = p37.Arena
    local v29 = p37:InArena()

    p37.Gui.Enabled = v29

    if v29 ~= p37.Lit then
        p37.Lit = v29

        local DrScramble = if v29 then LightingController.Presets.DrScramble else nil

        if not v29 or not DrScramble then
            LightingController.ClearLayer("ScrambleBoss", 2)
        else
            LightingController.SetLayer("ScrambleBoss", "DrScramble", 160, 2)
        end
    end

    if not v29 then
        p37:SetArrow("", nil)
        p37:SetCountdown(nil)

        return
    end

    local v30 = Arena:GetAttribute("Phase") or "Waiting"

    p37.BossName.Text = t1[v30] or "DR. SCRAMBLE"

    local v31, v32, v33

    if v30 == "Waiting" then
        local v34 = Arena:GetAttribute("SpawnsAt") or 0
        local v37 = math.ceil((math.max(0, v34 - Workspace:GetServerTimeNow())))
        local v38 = if v34 > 0 then ("ARRIVING IN %*"):format(v37) else "WAITING FOR CHALLENGERS"
        local v39 = if v37 == 1 then "second" else "seconds"

        v32 = v38
        v31 = 1
        v33 = if v34 > 0 then ("The battle will begin in <font color=\"#%*\">%*</font> %*"):format(v3, v37, v39) else "Waiting for challengers"
    elseif v30 == "Mech" or v30 == "Ejecting" then
        local v40 = Arena:GetAttribute("Health") or 0
        local v42 = math.max(Arena:GetAttribute("MaxHealth") or 1, 1)
        local v43 = v40 / v42

        v32 = ("%* / %* HP"):format(math.floor(v40), (math.floor(v42)))

        local Mech = Arena:FindFirstChild("Mech")

        Mech = Mech and Mech:GetAttribute("Overheated")
        p37.TimerTitle.Text = "Phase"

        local TimerLabel = p37.TimerLabel

        if Mech then
            TimerLabel.Text = "OVERHEAT"
        elseif Arena:GetAttribute("PhaseTwo") then
            TimerLabel.Text = "2/3"
        else
            TimerLabel.Text = "1/3"
        end

        v31 = v43
    elseif v30 == "Ball" then
        local v44 = Arena:GetAttribute("CoreStage") or 0

        if Arena:GetAttribute("BallStunned") then
            local v45 = Arena:GetAttribute("CoreHealth") or 0
            local v47 = math.max(Arena:GetAttribute("CoreMax") or 1, 1)

            v31 = v45 / v47
            v32 = ("CORE %* / %*"):format(v45, v47)
        else
            v31 = 1 - v44 / 3
            v32 = ("CORE DAMAGE %* / 3"):format(v44)
        end

        p37.TimerTitle.Text = "Phase"
        p37.TimerLabel.Text = "3/3"
    elseif v30 == "Human" or v30 == "Final" then
        local v48 = Arena:GetAttribute("HumanHits") or 0
        local v50 = math.max(Arena:GetAttribute("HumanNeeded") or 3, 1)

        v31 = 1 - v48 / v50
        v32 = ("HIT HIM! %* / %*"):format(v48, v50)
        p37.TimerTitle.Text = "Phase"
        p37.TimerLabel.Text = "FINAL"
    elseif v30 == "Defeated" then
        p37.TimerTitle.Text = "Phase"
        v31 = 0
        v32 = "DEFEATED!"
        p37.TimerLabel.Text = "WIN"
    else
        v31 = 1
        v32 = ""
    end

    p37:SetCountdown(v33)

    local v51 = math.clamp(v31, 0, 1)

    p37.HealthText.Text = v32

    local v52 = v30 ~= p37.LastPhase
    local v53 = v51 < p37.LastHealthFraction - 0.001

    if v52 or v53 then
        p37:PunchHealth(v52)
    end

    p37.LastPhase = v30
    p37.LastHealthFraction = v51

    local v54 = p37.Gui.BossHPBar:GetAttribute("HealthTweenSpeed") or 14
    local v55 = p37.Gui.BossHPBar:GetAttribute("PhantomTweenSpeed") or 2.5
    local v56 = if GuiService.ReducedMotionEnabled then 1 else math.min(1, p38 * v54)
    local v58 = if GuiService.ReducedMotionEnabled then 1 else math.min(1, p38 * v55)

    p37.DisplayedHealth += (v51 - p37.DisplayedHealth) * v56
    p37.PhantomValue += (v51 - p37.PhantomValue) * v58
    p37.Bar.Size = UDim2.fromScale(p37.DisplayedHealth, 1)
    p37.Phantom.Size = UDim2.fromScale(math.max(p37.PhantomValue, p37.DisplayedHealth), 1)
    p37:SetPhaseSegments(v51)

    local v60 = Arena:GetAttribute("BallTarget") or 0
    local v61 = Arena:GetAttribute("BallCoil") or ""
    local v62 = Arena:GetAttribute("SpentCoil") or ""
    local Coils = Arena:FindFirstChild("Coils")
    local v63 = v60 == LocalPlayer.UserId and v30 == "Ball"
    local v64 = v30 == "Mech" and Arena:GetAttribute("GrabVictim") or 0
    local v65 = v64 ~= 0 and v64 == LocalPlayer.UserId
    local v69 = math.clamp((Arena:GetAttribute("GrabFree") or 0) / math.max(Arena:GetAttribute("GrabNeeded") or 1, 1), 0, 1)

    if v63 then
        local v71 = math.max(0, (Arena:GetAttribute("BallTargetEnds") or 0) - Workspace:GetServerTimeNow())

        p37.Target.Visible = true
        p37.TargetTitle.Text = "YOU'RE TARGETED!"
        p37.TargetSub.Text = v71 > 0 and "Lead him into the glowing coil!" or "HE'S SPEEDING UP! GET TO THE COIL!"
        p37.TargetCountdown.Text = string.format("%.2f", v71)

        local TargetCountdown = p37.TargetCountdown

        if v71 > 1.5 then
            TargetCountdown.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            TargetCountdown.TextColor3 = Kit.Red
        end
    elseif v65 then
        p37.Target.Visible = true
        p37.TargetTitle.Text = "GRABBED!"

        local TargetSub = p37.TargetSub
        local LastInputType = UserInputService:GetLastInputType()

        if LastInputType == Enum.UserInputType.Touch then
            TargetSub.Text = "Tap fast to break free!"
        elseif string.find(LastInputType.Name, "Gamepad") then
            TargetSub.Text = "Mash A to break free!"
        else
            TargetSub.Text = "Mash click or Space to break free!"
        end

        p37.TargetCountdown.Text = ("%*%%"):format((math.floor(v69 * 100)))
        p37.TargetCountdown.TextColor3 = Color3.new(1, 1, 1):Lerp(Kit.Green, v69)
    elseif os.clock() < p37.CrocTargetUntil then
        p37.Target.Visible = true
        p37.TargetTitle.Text = "TARGETED!"
        p37.TargetSub.Text = "The croc is coming for you. RUN!"
        p37.TargetCountdown.Text = string.format("%.1f", p37.CrocTargetUntil - os.clock())
        p37.TargetCountdown.TextColor3 = Kit.Red
    elseif v64 == 0 then
        p37.Target.Visible = false
    else
        local PlayerByUserId = Players:GetPlayerByUserId(v64)

        p37.Target.Visible = true
        p37.TargetTitle.Text = ("SAVE %*!"):format((string.upper(PlayerByUserId and PlayerByUserId.DisplayName or "THEM")))
        p37.TargetSub.Text = "Get under the claw and hit it!"
        p37.TargetCountdown.Text = ("%*%%"):format((math.floor(v69 * 100)))
        p37.TargetCountdown.TextColor3 = Color3.new(1, 1, 1):Lerp(Kit.Green, v69)
    end

    if Coils then
        for _, child in Coils:GetChildren() do
            local Zone = child:FindFirstChild("Zone")
            local ZoneRing = child:FindFirstChild("ZoneRing")
            local v74 = child.Name == v61 and v30 == "Ball"
            local v75 = not v74 and child.Name == v62 and v30 == "Ball"
            local v77 = (math.sin(os.clock() * 6) + 1) / 2

            tintCoil(child, if v74 then "Lit" elseif v75 then "Spent" else "Idle")

            if Zone then
                if v74 then
                    Zone.Transparency = v77 * 0.3 + 0.35
                else
                    Zone.Transparency = 0.8
                end

                if v74 then
                    Zone.Color = Kit.Green
                elseif v75 then
                    Zone.Color = v2
                else
                    Zone.Color = Color3.fromRGB(90, 220, 255)
                end
            end

            if ZoneRing then
                ZoneRing.Transparency = v74 and 0 or 0.4

                if v74 then
                    ZoneRing.Color = Kit.Green
                elseif v75 then
                    ZoneRing.Color = v2
                else
                    ZoneRing.Color = Color3.fromRGB(200, 250, 255)
                end
            end
        end
    end

    local ScrambleHuman = Arena:FindFirstChild("ScrambleHuman")

    p37:FadeHuman(ScrambleHuman, v30 == "Human" and ScrambleHuman ~= nil and ScrambleHuman:GetAttribute("Immune") == true)

    local Mech = Arena:FindFirstChild("Mech")
    local GrabRescue = Mech and Mech:FindFirstChild("GrabRescue")

    if v63 and Coils and Coils:FindFirstChild(v61) then
        local v78 = Coils:FindFirstChild(v61)
        local Top = v78:FindFirstChild("Top")

        if not (Top and Top:IsA("BasePart")) then
            local BoundingBox, BoundingBox2 = v78:GetBoundingBox()

            p37:SetArrow(("coil:%*"):format(v61), BoundingBox.Position + Vector3.new(0, BoundingBox2.Y / 2, 0))
        else
            p37:SetArrow(("coil:%*"):format(v61), Top)
        end

        return
    end

    if v64 ~= 0 and not v65 and GrabRescue then
        p37:SetArrow("rescue", GrabRescue)
    elseif Mech and Mech:GetAttribute("Overheated") and v30 == "Mech" then
        p37:SetArrow("mech", (Mech:FindFirstChild("Torso")))
    elseif v30 == "Ball" and Arena:GetAttribute("BallStunned") then
        local Ball = Arena:FindFirstChild("Ball")

        p37:SetArrow("ball", Ball and Ball.PrimaryPart or nil)
    elseif v30 == "Human" then
        local ScrambleHuman = Arena:FindFirstChild("ScrambleHuman")

        p37:SetArrow("human", ScrambleHuman and ScrambleHuman.PrimaryPart or nil)
    else
        p37:SetArrow("", nil)
    end
end

return t4
