-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local BillboardTweens = require(script.Parent.BillboardTweens)
local ViewabilityTracker = require(script.Parent.ViewabilityTracker)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local Save = require(ReplicatedStorage.Shared.Save)
local LocalPlayer = Players.LocalPlayer
local t1 = {}

local function getProductIcon(p1) -- line: 33
    -- upvalues: MarketplaceService (copy), t1 (copy)
    local v1 = t1[p1]

    if v1 then
        return v1
    end

    local GetProductInfo = MarketplaceService.GetProductInfo
    local Product = Enum.InfoType.Product
    local ok, result = pcall(GetProductInfo, MarketplaceService, p1, Product)

    if not ok or not result or not result.IconImageAssetId or result.IconImageAssetId <= 0 then
        return nil
    end

    local v2 = "rbxassetid://" .. tostring(result.IconImageAssetId)

    t1[p1] = v2

    return v2
end

local function applyProductIcon(p2, p3) -- line: 56
    -- upvalues: MarketplaceService (copy), t1 (copy)
    if p2 then
        local Icon = p2:FindFirstChild("Icon")

        if Icon and (Icon:IsA("ImageLabel") or Icon:IsA("ImageButton")) then
            task.spawn(function() -- line: 67
                -- upvalues: p3 (copy), Icon (copy), MarketplaceService (copy), t1 (copy)
                local v3 = t1[p3]

                if not v3 then
                    local GetProductInfo = MarketplaceService.GetProductInfo
                    local Product = Enum.InfoType.Product
                    local ok, result = pcall(GetProductInfo, MarketplaceService, p3, Product)

                    if not ok or not result or not result.IconImageAssetId or result.IconImageAssetId <= 0 then
                        v3 = nil
                    else
                        v3 = "rbxassetid://" .. tostring(result.IconImageAssetId)
                        t1[p3] = v3
                    end
                end

                if v3 and Icon.Parent then
                    Icon.Image = v3
                end
            end)
        end
    end
end

local function getPlayerPosition() -- line: 75
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    return HumanoidRootPart and HumanoidRootPart.Position
end

local function getDistanceFromPlayer(p4) -- line: 81
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local v4 = HumanoidRootPart and HumanoidRootPart.Position

    return v4 and (v4 - p4).Magnitude
end

local function isInRange(p5, p6) -- line: 86
    -- upvalues: LocalPlayer (copy)
    if not (p5 and p5.Parent) then
        return false
    end

    local Position = p5.Position
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local v5 = HumanoidRootPart and HumanoidRootPart.Position
    local v6 = v5 and (v5 - Position).Magnitude

    return v6 ~= nil and v6 <= p6
end

local function waitUntilWithinRange(p7, p8) -- line: 94
    -- upvalues: RunService (copy), LocalPlayer (copy)
    while true do
        if not p7.Parent then
            return false
        end

        RunService.Heartbeat:Wait()

        local Position = p7.Position
        local Character = LocalPlayer.Character
        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
        local v7 = HumanoidRootPart and HumanoidRootPart.Position
        local v8 = v7 and (v7 - Position).Magnitude

        if not (v8 and v8 <= p8) then
            task.wait(0.5)
            continue
        end

        break
    end

    return true
end

local function formatTimer(p9) -- line: 106
    local v11 = math.max(0, (math.ceil(p9 - os.clock())))
    local v13 = math.floor(v11 / 3600)
    local v15 = math.floor(v11 % 3600 / 60)
    local v16 = v11 % 60

    if v13 > 0 then
        return string.format("%02d:%02d:%02d", v13, v15, v16)
    end

    return string.format("%02d:%02d", v15, v16)
end

local function clampAngle(p10, p11) -- line: 117
    return (math.clamp(p10, math.rad(p11.X), (math.rad(p11.Y))))
end

local function lerpAngle(p12, p13, p14) -- line: 121
    return p12 + ((p13 - p12 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * p14
end

local function startPivotRotation(p15, p16) -- line: 126
    -- upvalues: RunService (copy), LocalPlayer (copy)
    local v19 = p16:GetAttribute("PivotX") or Vector2.zero
    local v20 = p16:GetAttribute("PivotY") or Vector2.zero
    local v21 = v19.X ~= 0 or v19.Y ~= 0
    local v22 = v20.X ~= 0 or v20.Y ~= 0

    if not (v21 or v22) then
        return
    end

    local Ball = p15:FindFirstChild("Ball")
    local Socket = p15:FindFirstChild("Socket")

    if Ball and Socket then
        local v24 = math.clamp(p16:GetAttribute("Range") or 50, 0, 500)
        local v26 = math.clamp(v24 * 5, 0, 500)
        local n1 = 0
        local n2 = 0

        task.spawn(function() -- line: 146
            -- upvalues: p15 (copy), Ball (copy), Socket (copy), v24 (copy), v26 (copy), n1 (ref), n2 (ref), v19 (copy), v20 (copy), v21 (copy), v22 (copy), RunService (copy), LocalPlayer (copy)
            while p15.Parent do
                RunService.Heartbeat:Wait()

                local Value = Ball.Value
                local Value2 = Socket.Value
                local v27 = false
                local v28 = false
                local v29 = false
                local v30 = false

                if Value then
                    v27 = true
                else
                    v30 = true
                end

                if v27 then
                    if Value2 then
                        v28 = true
                    else
                        v30 = true
                    end
                end

                v27 = false

                local v31, v32

                if v28 then
                    v31 = p15
                    v32 = v26

                    if p15 then
                        v27 = true
                    else
                        v29 = true
                    end
                end

                v28 = false

                if v27 then
                    if v31.Parent then
                        v28 = true
                    else
                        v29 = true
                    end
                end

                v27 = false

                local v33

                if v29 then
                    v33 = false
                    v30 = false
                end

                v29 = false

                local Position, Character, v34

                if v28 then
                    Position = v31.Position
                    Character = LocalPlayer.Character

                    if Character then
                        v29 = true
                    else
                        v34 = Character
                        v27 = true
                    end
                end

                v28 = false

                if v29 then
                    v34 = Character:FindFirstChild("HumanoidRootPart")
                    v27 = true
                end

                v29 = false

                local v35

                if v27 then
                    if v34 then
                        v29 = true
                    else
                        v35 = v34
                        v28 = true
                    end
                end

                v27 = false

                if v29 then
                    v35 = v34.Position
                    v28 = true
                end

                v29 = false

                local v36

                if v28 then
                    if v35 then
                        v29 = true
                    else
                        v36 = v35
                        v27 = true
                    end
                end

                v28 = false

                if v29 then
                    v36 = (v35 - Position).Magnitude
                    v27 = true
                end

                v29 = false

                if v27 then
                    if v36 ~= nil then
                        v29 = true
                    else
                        v33 = false
                        v30 = false
                    end
                end

                v27 = false

                if v29 then
                    if v36 <= v32 then
                        v28 = true
                    else
                        v27 = true
                    end
                end

                if v27 then
                    v33 = false
                    v30 = false
                end

                if v28 then
                    v33 = true
                    v30 = false
                end

                if v30 then
                    task.wait(2)
                else
                    local v37 = false
                    local v38 = false
                    local v39 = false
                    local v40 = false

                    if v33 then
                        v37 = true
                    else
                        v40 = true
                    end

                    local v41, v42

                    if v37 then
                        v41 = p15
                        v42 = v24

                        if p15 then
                            v38 = true
                        else
                            v39 = true
                        end
                    end

                    v37 = false

                    if v38 then
                        if v41.Parent then
                            v37 = true
                        else
                            v39 = true
                        end
                    end

                    v38 = false

                    local v43

                    if v39 then
                        v43 = false
                        v40 = false
                    end

                    v39 = false

                    local Position, Character, v44

                    if v37 then
                        Position = v41.Position
                        Character = LocalPlayer.Character

                        if Character then
                            v39 = true
                        else
                            v44 = Character
                            v38 = true
                        end
                    end

                    v37 = false

                    if v39 then
                        v44 = Character:FindFirstChild("HumanoidRootPart")
                        v38 = true
                    end

                    v39 = false

                    local v45

                    if v38 then
                        if v44 then
                            v39 = true
                        else
                            v45 = v44
                            v37 = true
                        end
                    end

                    v38 = false

                    if v39 then
                        v45 = v44.Position
                        v37 = true
                    end

                    v39 = false

                    local v46

                    if v37 then
                        if v45 then
                            v39 = true
                        else
                            v46 = v45
                            v38 = true
                        end
                    end

                    v37 = false

                    if v39 then
                        v46 = (v45 - Position).Magnitude
                        v38 = true
                    end

                    v39 = false

                    if v38 then
                        if v46 ~= nil then
                            v39 = true
                        else
                            v43 = false
                            v40 = false
                        end
                    end

                    v38 = false

                    if v39 then
                        if v46 <= v42 then
                            v37 = true
                        else
                            v38 = true
                        end
                    end

                    if v38 then
                        v43 = false
                        v40 = false
                    end

                    if v37 then
                        v43 = true
                        v40 = false
                    end

                    if v40 then
                        task.wait(2)
                    elseif v43 and Value.Parent and Value.Parent.Parent then
                        local Character = LocalPlayer.Character
                        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
                        local v47 = HumanoidRootPart and HumanoidRootPart.Position
                        local WorldCFrame = Value2.WorldCFrame
                        local v48 = WorldCFrame:PointToObjectSpace(v47)
                        local v49 = if v21 then math.clamp(math.atan2(-v48.X, -v48.Z), math.rad(v19.X), (math.rad(v19.Y))) else 0
                        local v55 = 0

                        if v22 then
                            local v57 = math.sqrt(v48.X ^ 2 + v48.Z ^ 2)

                            v55 = math.clamp(math.atan2(v48.Y, (math.max(v57, 0.5))), math.rad(v20.X), (math.rad(v20.Y)))
                        end

                        local v62 = n2

                        n2 = v62 + ((v49 - v62 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * 0.12

                        local v63 = n1

                        n1 = v63 + ((v55 - v63 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) * 0.12

                        local v64 = WorldCFrame:VectorToWorldSpace(CFrame.Angles(n1, n2, 0) * Vector3.new(0, 0, -1))
                        local v65 = CFrame.lookAt(WorldCFrame.Position, WorldCFrame.Position + v64, WorldCFrame.UpVector)

                        Value.Parent.CFrame = v65 * Value.CFrame:Inverse()
                    else
                        task.wait(1)
                    end
                end
            end
        end)
    end
end

local t2 = {}
local t3

local function teardown() -- line: 199
    -- upvalues: t3 (ref)
    if not t3 then
        return
    end

    t3.dead = true
    t3 = nil
end

function t2.start(p17, p18, p19, p20) -- line: 206
    -- upvalues: ReplicatedStorage (copy), RunService (copy), BillboardTweens (copy), ViewabilityTracker (copy), Simple (copy), Save (copy), LocalPlayer (copy), applyProductIcon (copy), waitUntilWithinRange (copy), formatTimer (copy), startPivotRotation (copy), t2 (copy), t3 (ref)
    local Screen = p17:FindFirstChild("Screen")

    if not Screen then
        Screen = p17:WaitForChild("Screen", 10)
    end

    if Screen then
        if t3 then
            t3.dead = true
            t3 = nil
        end

        p17.ChildRemoved:Connect(function(p21) -- line: 224
            -- upvalues: Screen (ref), t3 (ref)
            if p21 ~= Screen or not t3 then
                return
            end

            t3.dead = true
            t3 = nil
        end)
        p17.ChildAdded:Connect(function(p22) -- line: 229
            -- upvalues: p17 (copy), p18 (copy), p19 (copy), p20 (copy), t2 (copy), t3 (ref)
            if p22.Name == "Screen" and p22:IsA("BasePart") and not t3 then
                t2.start(p17, p18, p19, p20)
            end
        end)

        local v66 = Screen:WaitForChild("RewardedVideoBillboard", 10)

        if v66 then
            local devProductId

            if not v66.Adornee then
                local Parent = v66.Parent

                if Parent and Parent:IsA("BasePart") then
                    v66.Adornee = Parent
                end
            end

            local Adornee = v66.Adornee
            local Adornee2

            if not Adornee then
                for _ = 1, 10 do
                    task.wait(1)

                    if v66.Adornee then
                        break
                    end
                end

                Adornee2 = v66.Adornee
            end

            if Adornee or Adornee2 then
                local Adornee = v66.Adornee

                if not (Adornee and Adornee:IsA("BasePart")) then
                    warn((("[RVBillboard] %* | no valid Adornee"):format((v66:GetFullName()))))
                else
                    if not Adornee.Parent then
                        local v67 = os.clock() + 60

                        while not Adornee.Parent do
                            task.wait(1)

                            if v67 < os.clock() then
                                warn((`[RVBillboard] Board {nil} — Adornee never parented after {60}s.`))

                                return
                            end
                        end
                    end

                    v66.Enabled = true

                    local Parent, v68
                    local v69 = Save.Await()
                    local v70 = v69 and v69.GuardTutorialProgress
                    local v71

                    if not v70 or v70.Completed then
                        v71 = false
                    else
                        Parent = p17.Parent
                        v68 = p17:GetPivot()
                        v71 = true
                        p17.Parent = ReplicatedStorage
                    end

                    local AdorneeParent = Adornee.Parent

                    if not (AdorneeParent and AdorneeParent:IsA("Model")) then
                        AdorneeParent = nil
                    end

                    local ScreenFrame = v66:FindFirstChild("ScreenFrame")

                    if ScreenFrame then
                        local v72 = ScreenFrame:FindFirstChild("Input") or ScreenFrame:FindFirstChildOfClass("TextButton")

                        if v72 and v72:IsA("GuiButton") then
                            startPivotRotation(Adornee, p17)

                            local UIScale = ScreenFrame:FindFirstChild("UIScale")
                            local Default = ScreenFrame:FindFirstChild("Default")
                            local v73 = Default and Default:FindFirstChild("IconHolder") or nil
                            local IconHolder = ScreenFrame:FindFirstChild("IconHolder")
                            local Cooldown = ScreenFrame:FindFirstChild("Cooldown")
                            local Timer = Cooldown and Cooldown:FindFirstChild("Timer") or nil
                            local Available = ScreenFrame:FindFirstChild("Available")
                            local CashValue, PlayButton

                            if Available then
                                CashValue = Available:FindFirstChild("CashValue") or nil
                                PlayButton = Available:FindFirstChild("PlayButton") or nil
                            end

                            local UIScale2 = PlayButton and PlayButton:FindFirstChild("UIScale") or nil
                            local Starburst = ScreenFrame:FindFirstChild("Starburst")
                            local Surface = ScreenFrame:FindFirstChild("Surface")
                            local Border = Surface and Surface:FindFirstChild("Border")
                            local Color = if Border then Border.Color or Color3.new() else Color3.new()
                            local Thickness = Border and Border.Thickness or 0
                            local Brightness = v66.Brightness
                            local BackgroundColor3 = Surface and Surface.BackgroundColor3 or Color3.new()
                            local v79 = Color3.new(math.min(1, BackgroundColor3.R + 0.0392156862745098), math.min(1, BackgroundColor3.G + 0.0392156862745098), (math.min(1, BackgroundColor3.B + 0.0392156862745098)))

                            if Default then
                                Default.Visible = true
                            end

                            if IconHolder then
                                IconHolder.Visible = false
                            end

                            if Cooldown then
                                Cooldown.Visible = false
                            end

                            if Available then
                                Available.Visible = false
                            end

                            if Starburst then
                                task.spawn(function() -- line: 359
                                    -- upvalues: Adornee (copy), Starburst (copy), RunService (copy)
                                    while Adornee.Parent do
                                        Starburst.Rotation = os.clock() % 6 / 6 * 360
                                        RunService.Heartbeat:Wait()
                                    end
                                end)
                            end

                            local t4 = {
                                placementId = nil,
                                cooldownEndsAt = 0,
                                pending = false,
                                claimable = false,
                                retried = false,
                                connected = false,
                                gated = false,
                                checking = false,
                                dead = false,
                                bootTelemetrySent = false,
                                multiplier = 1,
                                rewardDuration = 30,
                                rewardConfirmed = false,
                                lastInfoRefresh = 0,
                                currentVisibility = nil,
                                updateVisibility = nil,
                                surfaceGui = v66,
                                screenPart = Adornee,
                                cooldownTimer = Timer,
                                adorneeModel = AdorneeParent,
                                playAdButton = v72,
                                boardId = nil,
                                viewabilityTracker = ViewabilityTracker.new(Adornee, p17:GetAttribute("Range") or 50, p20)
                            }

                            t3 = t4

                            if v71 then
                                task.spawn(function() -- line: 399
                                    -- upvalues: p17 (copy), p19 (copy), Parent (ref), v68 (ref), t4 (copy), Save (copy)
                                    while true do
                                        if not t4.dead and p17.Parent then
                                            local v80 = Save.Await()
                                            local v81 = v80 and v80.GuardTutorialProgress

                                            if not (v81 and v81.Completed) then
                                                Save.Watch("GuardTutorialProgress"):Wait()
                                                continue
                                            end
                                        end

                                        break
                                    end

                                    if t4.dead or not p17.Parent then
                                        return
                                    end

                                    local InvokeServer = p19.GetPlacementInfo.InvokeServer
                                    local GetPlacementInfo = p19.GetPlacementInfo
                                    local ok, result = pcall(InvokeServer, GetPlacementInfo)

                                    if ok and result and result.controlGroup then
                                        t4.dead = true
                                    else
                                        p17.Parent = Parent
                                        p17:PivotTo(v68)
                                    end
                                end)
                            end

                            local v83
                            local HintEffect = script.Parent:FindFirstChild("HintEffect")

                            if HintEffect and p17:GetAttribute("ShowHint") then
                                v83 = require(HintEffect).new(p17, Adornee, v72)
                            end

                            t4.updateVisibility = function(p23) -- line: 435
                                -- upvalues: Default (copy), IconHolder (copy), Cooldown (copy), Available (copy), t4 (copy)
                                if p23 == t4.currentVisibility then
                                    return
                                end

                                t4.currentVisibility = p23

                                if Default then
                                    Default.Visible = p23 == "Default" or p23 == "Gated"
                                end

                                if IconHolder then
                                    IconHolder.Visible = p23 == "Cooldown" or p23 == "Available"
                                end

                                if Cooldown then
                                    Cooldown.Visible = p23 == "Cooldown"
                                end

                                if Available then
                                    Available.Visible = p23 == "Available"
                                end
                            end

                            t4.updateVisibility("Default")

                            local function passProximityAndAvailability() -- line: 456
                                -- upvalues: p18 (copy), Adornee (copy), t4 (copy), RunService (copy), waitUntilWithinRange (copy)
                                if t4.dead or t4.checking then
                                    return false
                                end

                                t4.checking = true

                                local function finish(p24) -- line: 462
                                    -- upvalues: t4 (copy)
                                    t4.checking = false

                                    return p24
                                end

                                if not t4.bootTelemetrySent then
                                    if not waitUntilWithinRange(Adornee, 150) or t4.dead then
                                        t4.checking = false

                                        return false
                                    end

                                    t4.bootTelemetrySent = true
                                    p18.Remotes.LogTelemetry:FireServer("Boot")
                                end

                                while Adornee.Parent and not t4.dead do
                                    RunService.Heartbeat:Wait()

                                    local v88 = RunService.Heartbeat:Wait()

                                    if t4.viewabilityTracker:update(v88) then
                                        break
                                    end
                                end

                                if not t4.dead and not (t4.cooldownEndsAt > os.clock()) and p18.IsAvailable() then
                                    if t4.dead then
                                        t4.checking = false

                                        return false
                                    end

                                    t4.claimable = true
                                    p18.Remotes.LogTelemetry:FireServer("RegisterOpportunity")
                                    t4.checking = false

                                    return true
                                end

                                t4.checking = false

                                return false
                            end

                            task.spawn(function() -- line: 501
                                -- upvalues: p17 (copy), p19 (copy), v66 (copy), Adornee (copy), t4 (copy), v83 (ref), passProximityAndAvailability (copy), LocalPlayer (copy), formatTimer (copy)
                                while Adornee.Parent do
                                    task.wait()

                                    if v66 and v66.Parent then
                                        local v89 = false

                                        if Adornee and Adornee.Parent then
                                            local AdorneePosition = Adornee.Position
                                            local Character = LocalPlayer.Character
                                            local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
                                            local v90 = HumanoidRootPart and HumanoidRootPart.Position
                                            local v91 = v90 and (v90 - AdorneePosition).Magnitude

                                            v89 = v91 ~= nil and v91 <= 250
                                        end

                                        if v89 then
                                            local v92 = if t4.gated then "Gated"
                                                elseif not t4.connected then "Default"
                                                elseif t4.cooldownEndsAt > os.clock() or not t4.claimable then "Cooldown"
                                                else "Available"

                                            t4.updateVisibility(v92)

                                            if v83 then
                                                local v93 = false
                                                local v94 = false
                                                local v95 = false
                                                local v96 = false
                                                local v97 = false

                                                if v92 == "Available" then
                                                    v93 = true
                                                end

                                                local Adornee2, v98

                                                if v93 then
                                                    Adornee2 = Adornee
                                                    v98 = (p17:GetAttribute("Range") or 50) / 2

                                                    if Adornee then
                                                        v94 = true
                                                    else
                                                        v95 = true
                                                    end
                                                end

                                                v93 = false

                                                if v94 then
                                                    if Adornee2.Parent then
                                                        v93 = true
                                                    else
                                                        v95 = true
                                                    end
                                                end

                                                v94 = false

                                                local v99

                                                if v95 then
                                                    v99 = false
                                                    v94 = true
                                                end

                                                v95 = false

                                                local Position, Character, v100

                                                if v93 then
                                                    Position = Adornee2.Position
                                                    Character = LocalPlayer.Character

                                                    if Character then
                                                        v95 = true
                                                    else
                                                        v100 = Character
                                                        v96 = true
                                                    end
                                                end

                                                v93 = false

                                                if v95 then
                                                    v100 = Character:FindFirstChild("HumanoidRootPart")
                                                    v96 = true
                                                end

                                                v95 = false

                                                local v101

                                                if v96 then
                                                    if v100 then
                                                        v95 = true
                                                    else
                                                        v101 = v100
                                                        v93 = true
                                                    end
                                                end

                                                v96 = false

                                                if v95 then
                                                    v101 = v100.Position
                                                    v93 = true
                                                end

                                                v95 = false

                                                local v102

                                                if v93 then
                                                    if v101 then
                                                        v95 = true
                                                    else
                                                        v102 = v101
                                                        v96 = true
                                                    end
                                                end

                                                v93 = false

                                                if v95 then
                                                    v102 = (v101 - Position).Magnitude
                                                    v96 = true
                                                end

                                                v95 = false

                                                if v96 then
                                                    if v102 ~= nil then
                                                        v95 = true
                                                    else
                                                        v99 = false
                                                        v94 = true
                                                    end
                                                end

                                                v96 = false

                                                if v95 then
                                                    if v102 <= v98 then
                                                        v93 = true
                                                    else
                                                        v96 = true
                                                    end
                                                end

                                                if v96 then
                                                    v99 = false
                                                    v94 = true
                                                end

                                                if v93 then
                                                    v99 = true
                                                    v94 = true
                                                end

                                                if v94 then
                                                    v97 = not not v99
                                                end

                                                if v97 then
                                                    v83:show()
                                                else
                                                    v83:hide()
                                                end
                                            end

                                            if v92 == "Cooldown" and t4.cooldownTimer then
                                                if t4.cooldownEndsAt > os.clock() then
                                                    t4.cooldownTimer.Text = formatTimer(t4.cooldownEndsAt)
                                                else
                                                    t4.cooldownTimer.Text = ""
                                                end
                                            end

                                            if v92 == "Cooldown" and t4.connected and t4.cooldownEndsAt <= os.clock() and not t4.claimable and not t4.pending and not t4.checking then
                                                local elapsed = os.clock()

                                                if elapsed - (t4.lastInfoRefresh or 0) >= 5 then
                                                    t4.lastInfoRefresh = elapsed
                                                    task.spawn(function() -- line: 555
                                                        -- upvalues: p19 (copy), t4 (copy), passProximityAndAvailability (copy)
                                                        if t4.dead then
                                                            return
                                                        end

                                                        local InvokeServer = p19.GetPlacementInfo.InvokeServer
                                                        local GetPlacementInfo = p19.GetPlacementInfo
                                                        local ok, result = pcall(InvokeServer, GetPlacementInfo)

                                                        if ok and result then
                                                            if result.placementId then
                                                                t4.placementId = result.placementId
                                                            end

                                                            if result.gated then
                                                                t4.gated = true
                                                                t4.updateVisibility("Gated")
                                                            elseif result.claimsMax and result.claimsMax > 0 and result.claimsUsed and result.claimsUsed >= result.claimsMax and result.windowResetsAt then
                                                                local v104 = math.max(0, result.windowResetsAt - os.time())

                                                                t4.cooldownEndsAt = os.clock() + v104
                                                            elseif result.secondsLeft and result.secondsLeft > 0 then
                                                                t4.cooldownEndsAt = os.clock() + result.secondsLeft
                                                            elseif result.eligible then
                                                                passProximityAndAvailability()
                                                            end
                                                        end
                                                    end)
                                                end
                                            end

                                            task.wait(1)
                                        else
                                            if v83 then
                                                v83:hide()
                                            end

                                            task.wait(2)
                                        end
                                    else
                                        if v83 then
                                            v83:hide()
                                        end

                                        task.wait(1)
                                    end
                                end
                            end)

                            local t5 = {}

                            if IconHolder then
                                table.insert(t5, {
                                    instance = IconHolder,
                                    basePosition = IconHolder.Position
                                })
                            end

                            if v73 then
                                table.insert(t5, {
                                    instance = v73,
                                    basePosition = v73.Position
                                })
                            end

                            if #t5 > 0 then
                                local v106 = p17:GetAttribute("Range") or 50

                                task.spawn(function() -- line: 606
                                    -- upvalues: Adornee (copy), t5 (copy), v106 (copy), RunService (copy), LocalPlayer (copy)
                                    while Adornee.Parent do
                                        RunService.Heartbeat:Wait()

                                        local v107 = false

                                        if Adornee and Adornee.Parent then
                                            local AdorneePosition = Adornee.Position
                                            local Character = LocalPlayer.Character
                                            local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
                                            local v108 = HumanoidRootPart and HumanoidRootPart.Position
                                            local v109 = v108 and (v108 - AdorneePosition).Magnitude

                                            v107 = v109 ~= nil and v109 <= 250
                                        end

                                        if v107 then
                                            local AdorneePosition = Adornee.Position
                                            local Character = LocalPlayer.Character
                                            local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
                                            local v110 = HumanoidRootPart and HumanoidRootPart.Position
                                            local v111 = v110 and (v110 - AdorneePosition).Magnitude

                                            if v111 then
                                                if v111 <= v106 then
                                                    local v113 = (math.sin(os.clock() * 2.0943951023931953) + 1) / 2

                                                    for _, v114 in t5 do
                                                        v114.instance.Position = UDim2.new(v114.basePosition.X.Scale, v114.basePosition.X.Offset, v114.basePosition.Y.Scale, v114.basePosition.Y.Offset - v113 * 5)
                                                    end
                                                else
                                                    for _, v115 in t5 do
                                                        v115.instance.Position = v115.basePosition
                                                    end
                                                end
                                            else
                                                task.wait(2)
                                            end
                                        else
                                            task.wait(2)
                                        end
                                    end
                                end)
                            end

                            local Design = ScreenFrame:FindFirstChild("Design")

                            if Design then
                                local t8 = {}

                                for _, child in Design:GetChildren() do
                                    if child:IsA("GuiObject") then
                                        local v116 = (#t8 + 1 - 1) * 1.25 + 10
                                        local v117 = v116 * 1.4

                                        table.insert(t8, {
                                            instance = child,
                                            basePosition = child.Position,
                                            baseRotation = child.Rotation,
                                            omegaY = 6.283185307179586 / v116,
                                            omegaX = 6.283185307179586 / v117,
                                            startAt = os.clock() + math.random() * 2
                                        })
                                    end
                                end

                                if #t8 > 0 then
                                    task.spawn(function() -- line: 657
                                        -- upvalues: Adornee (copy), t8 (copy), RunService (copy), LocalPlayer (copy)
                                        while Adornee.Parent do
                                            RunService.Heartbeat:Wait()

                                            local v118 = false

                                            if Adornee and Adornee.Parent then
                                                local AdorneePosition = Adornee.Position
                                                local Character = LocalPlayer.Character
                                                local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
                                                local v119 = HumanoidRootPart and HumanoidRootPart.Position
                                                local v120 = v119 and (v119 - AdorneePosition).Magnitude

                                                v118 = v120 ~= nil and v120 <= 250
                                            end

                                            if v118 then
                                                local elapsed = os.clock()

                                                for _, v121 in t8 do
                                                    if not (elapsed < v121.startAt) then
                                                        local v122 = elapsed - v121.startAt

                                                        v121.instance.Position = v121.basePosition + UDim2.fromScale(math.sin(v122 * v121.omegaX) * 0.01, math.sin(v122 * v121.omegaY) * 0.02)
                                                        v121.instance.Rotation = v121.baseRotation + math.sin(v122 * v121.omegaY) * 2
                                                    end
                                                end
                                            else
                                                task.wait(2)
                                            end
                                        end
                                    end)
                                end
                            end

                            local t10 = {}

                            if IconHolder then
                                table.insert(t10, {
                                    instance = IconHolder,
                                    baseRotation = IconHolder.Rotation
                                })
                            end

                            if v73 then
                                table.insert(t10, {
                                    instance = v73,
                                    baseRotation = v73.Rotation
                                })
                            end

                            local v127 = BillboardTweens.new({
                                frameScale = UIScale,
                                buttonScale = UIScale2,
                                frameStroke = Border,
                                surfaceGui = v66,
                                surface = Surface,
                                baseStrokeColor = Color,
                                baseStrokeThickness = Thickness,
                                baseBrightness = Brightness,
                                baseBackground = BackgroundColor3,
                                bumpedBackground = v79,
                                shakeTargets = t10
                            })

                            task.spawn(function() -- line: 702
                                -- upvalues: Adornee (copy), v127 (copy), RunService (copy), LocalPlayer (copy)
                                local v128 = false

                                while Adornee.Parent do
                                    RunService.Heartbeat:Wait()

                                    local v129 = false

                                    if Adornee and Adornee.Parent then
                                        local AdorneePosition = Adornee.Position
                                        local Character = LocalPlayer.Character
                                        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
                                        local v130 = HumanoidRootPart and HumanoidRootPart.Position
                                        local v131 = v130 and (v130 - AdorneePosition).Magnitude

                                        v129 = v131 ~= nil and v131 <= 250
                                    end

                                    if v129 ~= v128 then
                                        v128 = v129

                                        if not v129 then
                                            v127.resetHover()
                                        end
                                    end

                                    if v129 then
                                        RunService.Heartbeat:Wait()
                                    else
                                        task.wait(2)
                                    end
                                end
                            end)
                            task.spawn(function() -- line: 721
                                -- upvalues: Adornee (copy), v127 (copy), RunService (copy), LocalPlayer (copy)
                                while Adornee.Parent do
                                    task.wait(math.random(5, 15))

                                    local v132 = false

                                    if Adornee and Adornee.Parent then
                                        local AdorneePosition = Adornee.Position
                                        local Character = LocalPlayer.Character
                                        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
                                        local v133 = HumanoidRootPart and HumanoidRootPart.Position
                                        local v134 = v133 and (v133 - AdorneePosition).Magnitude

                                        v132 = v134 ~= nil and v134 <= 250
                                    end

                                    if v132 then
                                        v127.shakeIcon()
                                    else
                                        RunService.Heartbeat:Wait()
                                    end
                                end
                            end)
                            v72.MouseEnter:Connect(function() -- line: 732
                                -- upvalues: p18 (copy), Adornee (copy), t4 (copy), v127 (copy), LocalPlayer (copy)
                                if Adornee and Adornee.Parent then
                                    local AdorneePosition = Adornee.Position
                                    local Character = LocalPlayer.Character
                                    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
                                    local v135 = HumanoidRootPart and HumanoidRootPart.Position
                                    local v136 = v135 and (v135 - AdorneePosition).Magnitude

                                    if v136 ~= nil and v136 <= 250 then
                                        p18.Audio.playEnterSound()

                                        if not (t4.cooldownEndsAt > os.clock()) and t4.claimable then
                                            v127.hoverIn()
                                            v127.shakeIcon()
                                        end
                                    end
                                end
                            end)
                            v72.MouseLeave:Connect(function() -- line: 744
                                -- upvalues: Adornee (copy), v127 (copy), LocalPlayer (copy)
                                if Adornee and Adornee.Parent then
                                    local AdorneePosition = Adornee.Position
                                    local Character = LocalPlayer.Character
                                    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
                                    local v137 = HumanoidRootPart and HumanoidRootPart.Position
                                    local v138 = v137 and (v137 - AdorneePosition).Magnitude

                                    if v138 ~= nil and v138 <= 250 then
                                        v127.resetHover()
                                        v127.shakeIcon()
                                    end
                                end
                            end)
                            v72.Activated:Connect(function() -- line: 752
                                -- upvalues: p18 (copy), Adornee (copy), t4 (copy), v127 (copy), LocalPlayer (copy)
                                local v139 = false

                                if Adornee and Adornee.Parent then
                                    local AdorneePosition = Adornee.Position
                                    local Character = LocalPlayer.Character
                                    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
                                    local v140 = HumanoidRootPart and HumanoidRootPart.Position
                                    local v141 = v140 and (v140 - AdorneePosition).Magnitude

                                    v139 = v141 ~= nil and v141 <= 250
                                end

                                if not v139 then
                                    return
                                end

                                v127.frameScale(0.98, 0.06)

                                local v142 = v127.buttonScale(0.6, 0.06)

                                if v142 then
                                    v142.Completed:Wait()
                                end

                                v127.frameScale(1, 0.12)
                                v127.buttonScale(1, 0.12)
                                v127.shakeIcon()
                                v127.strokeHoverOut()
                                p18.Audio.playClickSound()

                                if not t4.connected or t4.cooldownEndsAt > os.clock() or not t4.claimable or t4.pending then
                                    return
                                end

                                t4.retried = false
                                t4.pending = true

                                if p18.IsAvailable() then
                                    if not p18.ShowAd() then
                                        t4.pending = false
                                    end
                                else
                                    t4.pending = false
                                    t4.claimable = false
                                end
                            end)
                            p18.OnAdCompleted(function(p25) -- line: 792
                                -- upvalues: p18 (copy), t4 (copy)
                                p18.Audio.playAdCompleteSound()
                                t4.pending = false
                                t4.claimable = false
                                t4.viewabilityTracker:reset()

                                if p25.claimsMax and p25.claimsMax > 0 and p25.claimsUsed and p25.claimsUsed >= p25.claimsMax and p25.windowResetsAt then
                                    local v144 = math.max(0, p25.windowResetsAt - os.time())

                                    t4.cooldownEndsAt = os.clock() + v144
                                else
                                    if not p25.cooldownEndsAt then
                                        return
                                    end

                                    local v146 = math.max(0, p25.cooldownEndsAt - os.time())

                                    t4.cooldownEndsAt = os.clock() + v146
                                end
                            end)
                            p18.OnAdFailed(function(p26) -- line: 812
                                -- upvalues: p17 (copy), p19 (copy), IconHolder (copy), t4 (copy), passProximityAndAvailability (copy), v73 (copy), ReplicatedStorage (copy), applyProductIcon (copy)
                                t4.viewabilityTracker:reset()

                                if p26.reason == "ControlGroup" then
                                    t4.dead = true

                                    if p17 and p17.Parent then
                                        p17.Parent = ReplicatedStorage
                                    end
                                elseif p26.reason == "RewardAssigned" then
                                    if p26.assignedProductId then
                                        applyProductIcon(IconHolder, p26.assignedProductId)
                                        applyProductIcon(v73, p26.assignedProductId)
                                    end

                                    if p26.multiplier then
                                        t4.multiplier = p26.multiplier
                                    end

                                    if p26.rewardDuration then
                                        t4.rewardDuration = p26.rewardDuration
                                    end

                                    t4.rewardConfirmed = true
                                elseif p26.reason == "SyncUpdate" then
                                    if p26.claimsMax and p26.claimsMax > 0 and p26.claimsUsed and p26.claimsUsed >= p26.claimsMax and p26.windowResetsAt then
                                        local v148 = math.max(0, p26.windowResetsAt - os.time())

                                        t4.cooldownEndsAt = os.clock() + v148
                                    elseif p26.secondsLeft and p26.secondsLeft > 0 then
                                        t4.cooldownEndsAt = os.clock() + p26.secondsLeft
                                    end

                                    t4.claimable = false
                                elseif p26.reason == "ClaimLimitReached" then
                                    task.spawn(function() -- line: 849
                                        -- upvalues: p19 (copy), t4 (copy)
                                        local InvokeServer = p19.GetPlacementInfo.InvokeServer
                                        local GetPlacementInfo = p19.GetPlacementInfo
                                        local ok, result = pcall(InvokeServer, GetPlacementInfo)

                                        if ok and result and result.windowResetsAt then
                                            local v150 = math.max(0, result.windowResetsAt - os.time())

                                            t4.cooldownEndsAt = os.clock() + v150
                                        end

                                        t4.pending = false
                                    end)
                                else
                                    t4.pending = false

                                    if p26.result == Enum.ShowAdResult.ShowInterrupted and not t4.retried then
                                        t4.retried = true
                                        task.delay(6, function() -- line: 861
                                            -- upvalues: t4 (copy), passProximityAndAvailability (copy)
                                            if not t4.dead and not (t4.cooldownEndsAt > os.clock()) then
                                                passProximityAndAvailability()
                                            end
                                        end)
                                    end
                                end
                            end)
                            task.delay(5, function() -- line: 874
                                -- upvalues: p17 (copy), p19 (copy), devProductId (ref), IconHolder (copy), t4 (copy), passProximityAndAvailability (copy), v73 (copy), ReplicatedStorage (copy), applyProductIcon (copy)
                                if t4.dead then
                                    return
                                end

                                while not t4.dead do
                                    wait()

                                    local InvokeServer = p19.GetPlacementInfo.InvokeServer
                                    local GetPlacementInfo = p19.GetPlacementInfo
                                    local ok, result = pcall(InvokeServer, GetPlacementInfo)

                                    if ok and result then
                                        if result.controlGroup then
                                            t4.dead = true

                                            if p17 and p17.Parent then
                                                p17.Parent = ReplicatedStorage
                                            end

                                            return
                                        end

                                        if not result.pending then
                                            if result.devProductId then
                                                devProductId = result.devProductId
                                                t4.boardId = devProductId
                                            end

                                            local v151 = result.assignedProductId or devProductId

                                            if v151 then
                                                applyProductIcon(IconHolder, v151)
                                                applyProductIcon(v73, v151)
                                            end

                                            if result.multiplier then
                                                t4.multiplier = result.multiplier
                                            end

                                            if result.rewardDuration then
                                                t4.rewardDuration = result.rewardDuration
                                            end

                                            if result.placementId then
                                                t4.placementId = result.placementId
                                            end

                                            if result.gated then
                                                t4.gated = true
                                                t4.updateVisibility("Gated")
                                            else
                                                t4.connected = true

                                                if result.claimsMax and result.claimsMax > 0 and result.claimsUsed and result.claimsUsed >= result.claimsMax and result.windowResetsAt then
                                                    local v153 = math.max(0, result.windowResetsAt - os.time())

                                                    t4.cooldownEndsAt = os.clock() + v153

                                                    return
                                                end

                                                if result.secondsLeft and result.secondsLeft > 0 then
                                                    t4.cooldownEndsAt = os.clock() + result.secondsLeft
                                                end

                                                if result.eligible then
                                                    passProximityAndAvailability()
                                                end
                                            end

                                            return
                                        end
                                    end

                                    task.wait(5)
                                end
                            end)

                            if CashValue then
                                local spawn = task.spawn
                                local CashValue2 = CashValue

                                spawn(function() -- line: 948
                                    -- upvalues: Adornee (copy), t4 (copy), CashValue2 (copy), Simple (copy), LocalPlayer (copy)
                                    local v154 = LocalPlayer:WaitForChild("leaderstats", 30)
                                    local v155 = v154 and v154:WaitForChild("Money/s", 30)

                                    if v155 then
                                        while Adornee.Parent and not t4.dead do
                                            local v157 = math.max(v155.Value * t4.multiplier * t4.rewardDuration, 1000)

                                            CashValue2.Text = "$" .. Simple.FormatCompact(math.round(v157), ".#")
                                            task.wait(1)
                                        end
                                    end
                                end)
                            end
                        else
                            warn((("[RVBillboard] %* | no GuiButton found in ScreenFrame"):format((v66:GetFullName()))))
                        end
                    else
                        warn((("[RVBillboard] %* | no ScreenFrame found"):format((v66:GetFullName()))))
                    end
                end
            else
                warn((("[RVBillboard] %* | Adornee was not assigned; aborting."):format((v66:GetFullName()))))
            end
        else
            warn((("[RVBillboard] No SurfaceGui found in %*"):format((Screen:GetFullName()))))
        end
    else
        local connection

        connection = p17.ChildAdded:Connect(function(p27) -- line: 213
            -- upvalues: p17 (copy), p18 (copy), p19 (copy), p20 (copy), connection (ref), t2 (copy)
            if p27.Name ~= "Screen" or not p27:IsA("BasePart") then
                return
            end

            connection:Disconnect()
            t2.start(p17, p18, p19, p20)
        end)
    end
end

return t2
