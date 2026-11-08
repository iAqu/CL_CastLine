-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local ButtonHintStrip = require(ReplicatedStorage.Client.ButtonHintStrip)
local CursedIslandWars = require(ReplicatedStorage.Data.CursedIslandWars)
local CursedIslandWarsFlags = require(ReplicatedStorage.Shared.Flags.CursedIslandWarsFlags)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local Input = require(script.Parent.Input)
local State = require(script.Parent.State)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local _ = CursedIslandWars.Tuning
local UI = CursedIslandWars.Assets.UI
local t1 = {
    Bat = CursedIslandWarsFlags.BatCooldown,
    PumpkinLauncher = CursedIslandWarsFlags.LauncherCooldown,
    WallBuilder = CursedIslandWarsFlags.WallCooldown,
    Landmine = CursedIslandWarsFlags.MineCooldown,
    JumpPad = CursedIslandWarsFlags.PadCooldown
}
local v1 = Color3.fromRGB(40, 40, 50)
local v2 = Color3.fromRGB(150, 150, 160)
local v3 = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v4 = Color3.fromRGB(255, 60, 60)
local v5 = Color3.fromRGB(255, 30, 30)
local v6 = TweenInfo.new(0.25)
local v7 = Trove.new()
local CursedIslandWarsUI
local t2 = {}
local t3 = {}
local t4 = {}
local t5 = {}
local n1 = 0
local n2 = 0
local t6
local n3 = 0
local clone
local t7 = {}

local function hex(p1) -- line: 54
    return p1:ToHex()
end

local function clock(p2) -- line: 58
    local v9 = math.max(0, (math.ceil(p2)))

    return string.format("%d:%02d", v9 // 60, v9 % 60)
end

local function pop(p3) -- line: 63
    -- upvalues: TweenService (copy), v3 (copy)
    local Pop = p3:FindFirstChild("Pop")

    if Pop then
        Pop.Scale = 0.6
        TweenService:Create(Pop, v3, {
            Scale = 1
        }):Play()
    end
end

function t7.Banner(p4, p5, p6, p7) -- line: 71
    -- upvalues: CursedIslandWarsUI (ref), n1 (ref), pop (copy)
    if CursedIslandWarsUI == nil then
        return
    end

    n1 += 1

    local v10 = n1
    local Banner = CursedIslandWarsUI.Banner

    Banner.Title.Text = p4
    Banner.Title.TextColor3 = p6 or Color3.new(1, 1, 1)
    Banner.Sub.Text = p5 or ""
    Banner.Visible = true
    pop(Banner)
    task.delay(p7 or 3, function() -- line: 83
        -- upvalues: v10 (copy), Banner (copy), CursedIslandWarsUI (ref), n1 (ref)
        if n1 == v10 and CursedIslandWarsUI then
            Banner.Visible = false
        end
    end)
end

function t7.Alarm(p8, p9) -- line: 90
    -- upvalues: t6 (ref)
    local t8 = t6

    t6 = {
        Chunks = p8,
        EndsAt = p9,
        Shown = t8 ~= nil and t8.Shown
    }
end

function t7.SafeZone(p10) -- line: 95
    -- upvalues: LocalPlayer (copy), UI (copy), clone (ref)
    local clone2 = clone

    if p10 ~= nil then
        if clone2 == nil then
            local clone2 = UI.SafeMarker:Clone()

            clone2.Adornee = p10
            clone2.Parent = LocalPlayer.PlayerGui
            clone = clone2
        end
    else
        clone = nil

        if clone2 then
            clone2:Destroy()
        end
    end
end

local function standingOn(p11) -- line: 112
    -- upvalues: Workspace (copy), LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = if Character then Character:FindFirstChild("HumanoidRootPart") else nil

    if HumanoidRootPart == nil then
        return false
    end

    local v11 = RaycastParams.new()

    v11.FilterType = Enum.RaycastFilterType.Include
    v11.FilterDescendantsInstances = p11

    return Workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -14, 0), v11) ~= nil
end

local function stepAlarm(p12) -- line: 125
    -- upvalues: v4 (copy), CursedIslandWarsUI (ref), n1 (ref), t6 (ref), n3 (ref), t7 (copy), pop (copy), standingOn (copy)
    local t10 = t6

    if t10 == nil then
        return
    end

    local Banner = CursedIslandWarsUI.Banner
    local v13 = math.ceil(t10.EndsAt - p12)
    local v14 = v13 > 0 and standingOn(t10.Chunks)

    if v13 <= 0 then
        t6 = nil
    end

    if v14 then
        if not t10.Shown then
            t10.Shown = true
            n1 += 1
            pop(Banner)
        end

        Banner.Visible = true
        Banner.Title.TextColor3 = v4
        Banner.Title.Text = "YOU'RE ON FALLING GROUND!"
        Banner.Sub.Text = ("Run to the centre! %*"):format(v13)

        if n3 <= p12 then
            n3 = p12 + 0.8
            t7.Hurt()
        end
    elseif t10.Shown then
        t10.Shown = false
        Banner.Visible = false
    end
end

local function stepSafeMarker() -- line: 158
    -- upvalues: LocalPlayer (copy), clone (ref)
    local clone2 = clone
    local Adornee = if clone2 then clone2.Adornee else nil
    local Character = LocalPlayer.Character
    local HumanoidRootPart = if Character then Character:FindFirstChild("HumanoidRootPart") else nil

    if clone2 == nil or Adornee == nil or HumanoidRootPart == nil then
        return
    end

    local Magnitude = (Vector3.new(Adornee.Position.X, 0, Adornee.Position.Z) - Vector3.new(HumanoidRootPart.Position.X, 0, HumanoidRootPart.Position.Z)).Magnitude

    clone2.Enabled = Magnitude > 28
    clone2.Distance.Text = tostring((math.floor(Magnitude)))
end

function t7.TeamCard(p13) -- line: 171
    -- upvalues: CursedIslandWars (copy), CursedIslandWarsUI (ref), pop (copy)
    if CursedIslandWarsUI == nil then
        return
    end

    local TeamCard = CursedIslandWarsUI.TeamCard
    local v17 = CursedIslandWars.Teams[p13]

    TeamCard.Title.Text = ("YOU ARE %*"):format(v17.Name)
    TeamCard.Title.TextColor3 = v17.Color
    TeamCard.Visible = true
    pop(TeamCard)
    task.delay(2.6, function() -- line: 181
        -- upvalues: TeamCard (copy), CursedIslandWarsUI (ref)
        if CursedIslandWarsUI then
            TeamCard.Visible = false
        end
    end)
end

function t7.Feed(p14) -- line: 188
    -- upvalues: TweenService (copy), CursedIslandWarsUI (ref)
    if CursedIslandWarsUI == nil then
        return
    end

    local Feed = CursedIslandWarsUI.Feed
    local clone = CursedIslandWarsUI.Templates.FeedLine:Clone()

    clone.Text = p14
    clone.LayoutOrder = -os.clock() * 1000
    clone.Parent = Feed

    local t11 = {}

    for _, child in Feed:GetChildren() do
        if child:IsA("TextLabel") then
            table.insert(t11, child)
        end
    end

    table.sort(t11, function(p15, p16) -- line: 203
        return p15.LayoutOrder < p16.LayoutOrder
    end)

    for i = 6, #t11 do
        t11[i]:Destroy()
    end

    task.delay(5, function() -- line: 209
        -- upvalues: clone (copy), TweenService (copy)
        if clone.Parent then
            TweenService:Create(clone, TweenInfo.new(0.4), {
                TextTransparency = 1
            }):Play()
            task.delay(0.4, function() -- line: 212
                -- upvalues: clone (copy)
                clone:Destroy()
            end)
        end
    end)
end

function t7.Knockout(p17, p18, p19) -- line: 219
    -- upvalues: CursedIslandWars (copy), State (copy), t7 (copy)
    local v18 = State.Entry(p17)

    if v18 == nil then
        return
    end

    local v19 = ("<font color=\"#%*\">%*</font>"):format(CursedIslandWars.Teams[v18.Team].Color:ToHex(), v18.Name)
    local v20 = State.Entry(p18)
    local v21 = if v20 then ("<font color=\"#%*\">%*</font>  🎃  %*"):format(CursedIslandWars.Teams[v20.Team].Color:ToHex(), v20.Name, v19) else ("%* fell into the void"):format(v19)

    if p19 then
        v21 ..= "  ☠ ELIMINATED"
    end

    t7.Feed(v21)
end

function t7.Hurt() -- line: 235
    -- upvalues: TweenService (copy), CursedIslandWarsUI (ref)
    if CursedIslandWarsUI == nil then
        return
    end

    local Vignette = CursedIslandWarsUI.Vignette

    Vignette.GroupTransparency = 0.25
    TweenService:Create(Vignette, TweenInfo.new(0.5), {
        GroupTransparency = 1
    }):Play()
end

function t7.HitMarker(p20, p21) -- line: 244
    -- upvalues: TweenService (copy), LocalPlayer (copy), UI (copy), v6 (copy), CursedIslandWarsUI (ref), n2 (ref)
    if CursedIslandWarsUI == nil then
        return
    end

    local HitMarker = CursedIslandWarsUI.HitMarker
    local UIStroke = HitMarker:FindFirstChildOfClass("UIStroke")

    n2 += 1

    local v22 = n2

    HitMarker.Visible = true
    HitMarker.TextTransparency = 0
    UIStroke.Transparency = 0
    TweenService:Create(HitMarker, v6, {
        TextTransparency = 1
    }):Play()
    TweenService:Create(UIStroke, v6, {
        Transparency = 1
    }):Play()
    task.delay(v6.Time, function() -- line: 257
        -- upvalues: HitMarker (copy), v22 (copy), CursedIslandWarsUI (ref), n2 (ref)
        if n2 == v22 and CursedIslandWarsUI then
            HitMarker.Visible = false
        end
    end)

    local HumanoidRootPart = if p20 then p20:FindFirstChild("HumanoidRootPart") else nil

    if HumanoidRootPart == nil then
        return
    end

    local clone = UI.DamageNumber:Clone()

    clone.Adornee = HumanoidRootPart
    clone.Amount.Text = ("-%*"):format(p21)
    clone.Parent = LocalPlayer.PlayerGui
    TweenService:Create(clone, TweenInfo.new(0.7, Enum.EasingStyle.Quad), {
        StudsOffset = clone.StudsOffset + Vector3.new(0, 3, 0)
    }):Play()
    TweenService:Create(clone.Amount, TweenInfo.new(0.7), {
        TextTransparency = 1
    }):Play()
    task.delay(0.7, function() -- line: 274
        -- upvalues: clone (copy)
        clone:Destroy()
    end)
end

function t7.Win(p22, p23) -- line: 279
    -- upvalues: CursedIslandWars (copy), CursedIslandWarsUI (ref), pop (copy)
    if CursedIslandWarsUI == nil then
        return
    end

    local Win = CursedIslandWarsUI.Win
    local v23 = CursedIslandWars.Teams[p22]

    Win.Title.Text = ("%* TEAM WINS!"):format(v23.Name)
    Win.Title.TextColor3 = v23.Color

    for _, child in Win.Names:GetChildren() do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    Win.Visible = true
    pop(Win)

    for v24, v25 in p23 do
        task.delay(v24 * 0.25, function() -- line: 295
            -- upvalues: Win (copy), v24 (copy), v25 (copy), CursedIslandWarsUI (ref), pop (copy)
            local clone = CursedIslandWarsUI.Templates.WinName:Clone()

            clone.Text = v25
            clone.LayoutOrder = v24
            clone.Parent = Win.Names
            pop(clone)
        end)
    end
end

function t7.WallsOpen() -- line: 305
    -- upvalues: CursedIslandWarsUI (ref), t2 (copy), t7 (copy)
    if CursedIslandWarsUI == nil then
        return
    end

    for v26, v27 in t2 do
        v27:Destroy()
        t2[v26] = nil
    end

    t7.Banner("FIGHT!", nil, Color3.fromRGB(255, 170, 0), 1.6)
end

local function setIcon(p24, p25) -- line: 316
    -- upvalues: CursedIslandWarsUI (ref), t5 (copy)
    if t5[p24] then
        return
    end

    t5[p24] = true

    if p25.ToolTip ~= "" then
        CursedIslandWarsUI.Bar[("Slot%*"):format(p24)].Label.Text = p25.ToolTip
    end

    local Model = CursedIslandWarsUI.Bar[("Slot%*"):format(p24)].Icon.Model
    local Model2 = Instance.new("Model")

    for _, descendant in p25:GetDescendants() do
        if descendant:IsA("BasePart") then
            local clone = descendant:Clone()

            clone:ClearAllChildren()
            clone.Anchored = true
            clone.Parent = Model2
        end
    end

    Model2.Parent = Model

    local BoundingBox, BoundingBox2 = Model2:GetBoundingBox()
    local Camera = Instance.new("Camera")

    Camera.FieldOfView = 30

    local v28 = BoundingBox2.Magnitude / 0.5358983848622454 * 0.9

    Camera.CFrame = CFrame.lookAt(BoundingBox.Position + (Vector3.new(-1, 0.6, -1)).Unit * v28, BoundingBox.Position)
    Camera.Parent = Model
    Model.CurrentCamera = Camera
    Model.Visible = true
end

local function refreshIcons() -- line: 345
    -- upvalues: CursedIslandWars (copy), LocalPlayer (copy), setIcon (copy)
    local t12 = {
        LocalPlayer:FindFirstChildOfClass("Backpack"),
        LocalPlayer.Character
    }

    for v29, v30 in CursedIslandWars.Tools do
        for _, v31 in t12 do
            local v32 = if v31 then v31:FindFirstChild(v30) else nil

            if v32 and v32:IsA("Tool") then
                setIcon(v29, v32)
                break
            end
        end
    end
end

local function refreshTeams(p26) -- line: 358
    -- upvalues: CursedIslandWars (copy), State (copy), v1 (copy), v2 (copy), CursedIslandWarsUI (ref)
    local v33 = State.Me()

    for _, v34 in CursedIslandWars.TeamIds do
        local v35 = CursedIslandWarsUI.Teams[v34]
        local You = v35.You

        if v33 ~= nil then
            You.Visible = v33.Team == v34
        else
            You.Visible = false
        end

        local v36 = p26.Crystals[v34]
        local v37 = if v36 then v36.Health / v36.MaxHealth else 0

        v35.Bar.Fill.Size = UDim2.fromScale(v37, 1)

        local Health = v35.Health

        if v37 > 0 then
            Health.Text = ("%*%%"):format((math.ceil(v37 * 100)))
        else
            Health.Text = "SHATTERED"
        end

        local t13 = {}

        for _, v39 in p26.Entries do
            if v39.Team == v34 then
                table.insert(t13, v39)
            end
        end

        table.sort(t13, function(p27, p28) -- line: 373
            return p27.Id < p28.Id
        end)

        for i = 1, CursedIslandWars.TeamSize do
            local v40 = v35.Pips[("Pip%*"):format(i)]
            local v41 = t13[i]

            if v41 == nil or v41.State == "Out" then
                v40.BackgroundColor3 = v1
            elseif v41.State == "Down" then
                v40.BackgroundColor3 = v2
            else
                v40.BackgroundColor3 = CursedIslandWars.Teams[v34].Color
            end
        end
    end
end

local function refreshPlates(p29) -- line: 387
    -- upvalues: CursedIslandWars (copy), CursedIslandWarsFlags (copy), State (copy), LocalPlayer (copy), UI (copy), v5 (copy), t3 (copy), t4 (copy)
    local v42 = State.Me()
    local t14 = {}

    for _, v43 in p29.Entries do
        local Model = v43.Model

        if Model ~= nil and Model ~= LocalPlayer.Character then
            t14[Model] = true

            local Head = Model:FindFirstChild("Head")
            local Humanoid = Model:FindFirstChildOfClass("Humanoid")

            if Head ~= nil then
                local v44 = t3[Model]

                if v44 == nil then
                    v44 = UI.Nameplate:Clone()
                    v44.Adornee = Head
                    v44.Parent = LocalPlayer.PlayerGui
                    t3[Model] = v44

                    local Highlight = Instance.new("Highlight")

                    Highlight.FillTransparency = 1
                    Highlight.OutlineColor = v5
                    Highlight.OutlineTransparency = 0.2
                    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
                    Highlight.Parent = Model
                    t4[Model] = Highlight

                    if Humanoid then
                        Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                    end
                end

                local Color = CursedIslandWars.Teams[v43.Team].Color
                local v45 = v43.State == "Alive"
                local v46 = v42 ~= nil and v43.Team == v42.Team

                v44.Enabled = v45 and not v46
                v44.Label.Text = v43.Name
                v44.Label.TextColor3 = Color
                v44.Bar.Fill.Size = UDim2.fromScale(math.clamp(v43.Health / CursedIslandWarsFlags.PlayerHealth:Get(), 0, 1), 1)
                v44.Bar.Fill.BackgroundColor3 = Color

                local v48 = t4[Model]

                if v45 then
                    v45 = v42 ~= nil and not v46
                end

                v48.Enabled = v45
            end
        end
    end

    for v49, v50 in t3 do
        if not t14[v49] then
            v50:Destroy()
            t3[v49] = nil

            local v51 = t4[v49]

            t4[v49] = nil

            if v51 then
                v51:Destroy()
            end
        end
    end
end

local function refreshBoards(p30) -- line: 442
    -- upvalues: LocalPlayer (copy), UI (copy), t2 (copy)
    local Island = p30.Island

    if Island == nil or p30.Phase ~= "Reveal" and p30.Phase ~= "Prep" and p30.Phase ~= "Intro" then
        return
    end

    local BoardSurface = Island.RulesBarrier.BoardSurface

    for _, v52 in {
            Enum.NormalId.Left,
            Enum.NormalId.Right
        } do
        if t2[v52] == nil then
            local clone = UI.RulesBoard:Clone()

            clone.Adornee = BoardSurface
            clone.Face = v52
            clone.Parent = LocalPlayer.PlayerGui
            t2[v52] = clone
        end
    end
end

local function refresh(p31) -- line: 459
    -- upvalues: State (copy), CursedIslandWarsUI (ref), refreshIcons (copy), refreshTeams (copy), refreshPlates (copy), refreshBoards (copy)
    if p31 ~= nil and CursedIslandWarsUI ~= nil then
        refreshTeams(p31)
        refreshPlates(p31)
        refreshBoards(p31)
        refreshIcons()

        local Phase = p31.Phase
        local Teams = CursedIslandWarsUI.Teams

        if Phase == "Intro" or Phase == "Reveal" then
            Teams.Visible = false
        else
            Teams.Visible = Phase ~= "Outro"
        end

        local v53 = State.Me()
        local Bar = CursedIslandWarsUI.Bar

        if Phase == "Intro" or Phase == "Win" or Phase == "Outro" or v53 == nil then
            Bar.Visible = false
        else
            Bar.Visible = v53.State == "Alive"
        end

        if Phase ~= "Win" then
            CursedIslandWarsUI.Win.Visible = false
        end
    end
end

local function step() -- line: 477
    -- upvalues: CursedIslandWars (copy), CursedIslandWarsFlags (copy), Input (copy), State (copy), t1 (copy), CursedIslandWarsUI (ref), t2 (copy), stepAlarm (copy), stepSafeMarker (copy)
    local Snapshot = State.Snapshot

    if Snapshot ~= nil and CursedIslandWarsUI ~= nil then
        local v54 = State.Now()
        local v55 = Snapshot.PhaseEndsAt - v54
        local Phase = Snapshot.Phase
        local Timer = CursedIslandWarsUI.Timer

        if Phase == "Prep" or Phase == "Match" then
            Timer.Visible = true
        else
            Timer.Visible = Phase == "SuddenDeath"
        end

        if Timer.Visible then
            local v56 = true

            for _, v57 in Snapshot.Crystals do
                if v57.Health > 0 then
                    v56 = false
                end
            end

            local Title = Timer.Title

            if Phase == "Prep" then
                Title.Text = "MATCH STARTS IN"
            elseif Phase == "SuddenDeath" then
                Title.Text = "SUDDEN DEATH"
            elseif v56 then
                Title.Text = "SUDDEN DEATH IN"
            else
                Title.Text = ""
            end

            local v59 = math.max(0, (math.ceil(v55)))
            local v60 = string.format("%d:%02d", v59 // 60, v59 % 60)

            Timer.Time.Text = v60
            Timer.Shadow.Text = v60

            local Time = Timer.Time

            if Phase == "SuddenDeath" or v55 <= 10 then
                Time.TextColor3 = Color3.fromRGB(255, 60, 60)
            else
                Time.TextColor3 = Color3.new(1, 1, 1)
            end
        end

        if next(t2) then
            local v61 = v55 + (if Phase == "Prep" then 0 elseif Phase == "Reveal" then CursedIslandWarsFlags.PrepSeconds:Get() else CursedIslandWarsFlags.RevealSeconds:Get() + CursedIslandWarsFlags.PrepSeconds:Get())

            for _, v62 in t2 do
                v62.Main.TimerLabel.Text = ("%*s"):format((math.max(0, (math.ceil(v61)))))
            end
        end

        local v64 = State.Me()
        local Respawn = CursedIslandWarsUI.Respawn

        if v64 ~= nil then
            if v64.State == "Down" then
                Respawn.Visible = v64.RespawnAt ~= nil
            else
                Respawn.Visible = false
            end
        else
            Respawn.Visible = false
        end

        if v64 and v64.State == "Down" and v64.RespawnAt then
            CursedIslandWarsUI.Respawn.Count.Text = tostring((math.max(1, (math.ceil(v64.RespawnAt - v54)))))
        end

        local v68 = (v64 == nil or v64.State == "Out") and Phase ~= "Intro" and Phase ~= "Win" and Phase ~= "Outro"

        CursedIslandWarsUI.Status.Visible = v68
        CursedIslandWarsUI.Status.Text = v64 and "ELIMINATED - SPECTATING" or "SPECTATING"

        local v69 = Input.Equipped()
        local v70 = State.Armed()

        for v71, v72 in CursedIslandWars.Tools do
            local v73 = CursedIslandWarsUI.Bar[("Slot%*"):format(v71)]
            local v74 = Input.Cooldown(v72) - v54
            local n4 = 1

            if v70 then
                n4 = if v74 > 0 then math.clamp(v74 / t1[v72]:Get(), 0, 1) else 0
            end

            v73.Cooldown.Size = UDim2.fromScale(1, n4)

            local Time = v73.Time

            if v70 and v74 > 0 then
                Time.Text = tostring((math.ceil(v74)))
            else
                Time.Text = ""
            end

            local v77 = v69 == v72

            v73.Glow.ImageTransparency = v77 and 0.2 or 1
            v73.Ring.Visible = v77

            if table.find(CursedIslandWars.Pickups, v72) then
                local v78 = v64 and v64.Ammo[v72] or 0

                v73.Visible = v78 > 0
                v73.Count.Visible = v78 > 0
                v73.Count.Text = ("x%*"):format(v78)
            end
        end

        stepAlarm(v54)
        stepSafeMarker()
    end
end

function t7.Start(p32) -- line: 544
    -- upvalues: RunService (copy), StarterGui (copy), ButtonFX (copy), ButtonHintStrip (copy), CursedIslandWars (copy), HiddenUIHandler (copy), Input (copy), State (copy), LocalPlayer (copy), v7 (ref), CursedIslandWarsUI (ref), t2 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (ref), t7 (copy), refresh (copy), step (copy)
    v7 = p32:Extend()

    local CursedIslandWarsUI2 = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("CursedIslandWarsUI")

    CursedIslandWarsUI = CursedIslandWarsUI2
    table.clear(t5)
    CursedIslandWarsUI2.Win.Visible = false
    CursedIslandWarsUI2.Banner.Visible = false
    CursedIslandWarsUI2.TeamCard.Visible = false
    CursedIslandWarsUI2.Respawn.Visible = false
    CursedIslandWarsUI2.Status.Visible = false
    CursedIslandWarsUI2.HitMarker.Visible = false
    CursedIslandWarsUI2.Vignette.GroupTransparency = 1

    for _, child in CursedIslandWarsUI2.Feed:GetChildren() do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    for i = 1, #CursedIslandWars.Tools do
        local v79 = CursedIslandWarsUI2.Bar[("Slot%*"):format(i)]

        v79.Icon.Model:ClearAllChildren()
        v7:Add(ButtonFX(v79, nil, function() -- line: 564
            -- upvalues: i (copy), Input (copy)
            Input.Equip(i)
        end))
    end

    CursedIslandWarsUI2.Enabled = true
    v7:Add(HiddenUIHandler.Acquire())
    v7:Add(ButtonHintStrip.Hide())

    local SetCoreGuiEnabled = StarterGui.SetCoreGuiEnabled
    local Health = Enum.CoreGuiType.Health

    pcall(SetCoreGuiEnabled, StarterGui, Health, false)
    v7:Add(function() -- line: 572
        -- upvalues: CursedIslandWarsUI2 (copy), StarterGui (copy), CursedIslandWarsUI (ref), t2 (copy), t3 (copy), t4 (copy), t6 (ref), t7 (copy)
        local SetCoreGuiEnabled = StarterGui.SetCoreGuiEnabled
        local Health = Enum.CoreGuiType.Health

        pcall(SetCoreGuiEnabled, StarterGui, Health, true)
        CursedIslandWarsUI2.Enabled = false
        CursedIslandWarsUI = nil
        t6 = nil
        t7.SafeZone(nil)

        for v84, v85 in t2 do
            v85:Destroy()
            t2[v84] = nil
        end

        for v86, v87 in t3 do
            v87:Destroy()

            local Humanoid = v86:FindFirstChildOfClass("Humanoid")

            if Humanoid then
                Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
            end
        end

        table.clear(t3)

        for _, v88 in t4 do
            v88:Destroy()
        end

        table.clear(t4)
    end)
    v7:Add(State.Changed:Connect(refresh))
    v7:Add(RunService.RenderStepped:Connect(step))
    refresh(State.Snapshot)
end

function t7.Hide() -- line: 600
    -- upvalues: CursedIslandWarsUI (ref)
    if CursedIslandWarsUI then
        CursedIslandWarsUI.Enabled = false
    end
end

return t7
