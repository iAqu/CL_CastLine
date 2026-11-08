-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Buddy = require(script.Buddy)
local Celebrate = require(script.Celebrate)
local Cinematic = require(script.Cinematic)
local Fx = require(script.Fx)
local Hud = require(script.Hud)
local Meteor = require(script.Meteor)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local StarFeed = require(script.StarFeed)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = Color3.fromRGB(255, 225, 0)
local LocalPlayer = Players.LocalPlayer
local t1, t2
local t3 = {}

local function now() -- line: 80
    -- upvalues: Workspace (copy)
    return Workspace:GetServerTimeNow()
end

local function folder() -- line: 84
    -- upvalues: Workspace (copy)
    local ShootingStarClient = Workspace:FindFirstChild("ShootingStarClient")

    if ShootingStarClient and ShootingStarClient:IsA("Folder") then
        return ShootingStarClient
    end

    local Folder = Instance.new("Folder")

    Folder.Name = "ShootingStarClient"
    Folder.Parent = Workspace

    return Folder
end

local function rootPosition() -- line: 95
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    return if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart.Position else nil
end

local function starPosition(p1) -- line: 101
    local Buddy = p1.Buddy

    if Buddy then
        return Buddy:Position()
    end

    return p1.Payload.Landing.Position
end

local function endSession(p2) -- line: 109
    -- upvalues: Hud (copy), t1 (ref)
    if t1 == p2 then
        t1 = nil
    end

    p2.Done = true
    Hud.Waypoint(nil)
    Hud.Objective(false)
    Hud.Border(0)
    p2.Trove:Destroy()
end

local function refreshProgress(p3) -- line: 120
    -- upvalues: Workspace (copy), Hud (copy), LocalPlayer (copy)
    local Payload = p3.Payload
    local v2 = Payload.ExpiresAt - Workspace:GetServerTimeNow()
    local v4 = math.max(Payload.ExpiresAt - Payload.LandAt, 1)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local Position = if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then nil else HumanoidRootPart.Position
    local v5

    if p3.Buddy and p3.Noticed and Position then
        local Buddy = p3.Buddy

        if (Position - (if Buddy then Buddy:Position() else p3.Payload.Landing.Position)).Magnitude < 16 then
            v5 = if p3.HoldStart then "KEEP HOLDING!" else "HOLD TO CATCH IT!"
        end
    end

    Hud.Progress(v2 / v4, v2, v5)
end

local function placeMeteor(p4) -- line: 137
    -- upvalues: Workspace (copy), Fx (copy), Meteor (copy)
    local Payload = p4.Payload
    local new = Meteor.new
    local Landing = Payload.Landing
    local ShootingStarClient = Workspace:FindFirstChild("ShootingStarClient")

    if not (ShootingStarClient and ShootingStarClient:IsA("Folder")) then
        ShootingStarClient = Instance.new("Folder")
        ShootingStarClient.Name = "ShootingStarClient"
        ShootingStarClient.Parent = Workspace
    end

    local v6 = new(Landing, 3, 0, ShootingStarClient)

    p4.Meteor = v6
    p4.Trove:Add(function() -- line: 141
        -- upvalues: p4 (copy), v6 (copy)
        if p4.Meteor == v6 then
            v6:Destroy()
        end
    end)

    local LandingPosition = Payload.Landing.Position

    Fx.Emit("Impact", LandingPosition, 1)
    Fx.Sound("StarImpact", LandingPosition, 1)

    return v6
end

local function retireMeteor(p5, p6) -- line: 152
    local Meteor = p5.Meteor

    if Meteor == nil then
        return
    end

    p5.Meteor = nil
    task.delay(p6, function() -- line: 158
        -- upvalues: Meteor (copy)
        Meteor:LightOff()
        Meteor:Fade()
    end)
end

local function setHolding(p7, p8) -- line: 164
    -- upvalues: RunService (copy), TweenService (copy), Workspace (copy), Fx (copy), Hud (copy)
    if p8 then
        local CurrentCamera = Workspace.CurrentCamera
        local elapsed = os.clock()

        p7.HoldStart = elapsed

        local FieldOfView = CurrentCamera.FieldOfView
        local n1 = 0
        local v7 = false
        local v8 = p7.Trove:Extend()

        v8:Add(function() -- line: 180
            -- upvalues: CurrentCamera (copy), FieldOfView (copy), v7 (ref), TweenService (copy)
            v7 = true
            TweenService:Create(CurrentCamera, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                FieldOfView = FieldOfView
            }):Play()
        end)
        v8:Connect(RunService.RenderStepped, function() -- line: 188
            -- upvalues: p7 (copy), CurrentCamera (copy), elapsed (copy), FieldOfView (copy), n1 (ref), v7 (ref), v8 (copy), Fx (copy), Hud (copy)
            if v7 then
                return
            end

            if p7.HoldStart ~= elapsed then
                v7 = true
                task.defer(function() -- line: 194
                    -- upvalues: v8 (copy)
                    v8:Destroy()
                end)

                return
            end

            local v10 = math.clamp((os.clock() - elapsed) / p7.Payload.HoldSeconds, 0, 1)
            local v11 = v10 * v10 * (3 - v10 * 2)

            if p7.Buddy then
                p7.Buddy:Charge(v11)
            end

            Hud.Border(v11)

            if not Fx.ReducedMotion() then
                CurrentCamera.FieldOfView = FieldOfView - v11 * 6
            end

            local elapsed2 = os.clock()

            if elapsed2 - n1 > 0.1 then
                n1 = elapsed2
                Fx.Shake(0.14, v11 * 0.32 + 0.06, nil)
            end
        end)
    else
        p7.HoldStart = nil
        Hud.Border(0)

        if p7.Buddy then
            p7.Buddy:Release(false)
        end
    end
end

local function spawnBuddy(p9, p10) -- line: 216
    -- upvalues: Workspace (copy), Buddy (copy), Hud (copy), Remotes (copy), setHolding (copy)
    local Payload = p9.Payload
    local new = Buddy.new
    local ShootingStarClient = Workspace:FindFirstChild("ShootingStarClient")

    if not (ShootingStarClient and ShootingStarClient:IsA("Folder")) then
        ShootingStarClient = Instance.new("Folder")
        ShootingStarClient.Name = "ShootingStarClient"
        ShootingStarClient.Parent = Workspace
    end

    local v12 = new(ShootingStarClient, p9.Leg, p9.Noticed, Payload.HoldSeconds, {
        HoldBegan = function() -- HoldBegan | line: 219
            -- upvalues: p9 (copy), Payload (copy), Remotes (copy), setHolding (copy)
            if not (p9.Done or p9.Caught) then
                Remotes.ShootingStar.Hold:FireServer(Payload.Id, true)
                setHolding(p9, true)
            end
        end,
        HoldEnded = function() -- HoldEnded | line: 226
            -- upvalues: p9 (copy), Payload (copy), Hud (copy), Remotes (copy)
            local HoldStart = p9.HoldStart

            task.delay(0.15, function() -- line: 228
                -- upvalues: HoldStart (copy), p9 (copy), Payload (copy), Hud (copy), Remotes (copy)
                if p9.Done or p9.Caught or p9.HoldStart ~= HoldStart then
                    return
                end

                Remotes.ShootingStar.Hold:FireServer(Payload.Id, false)
                p9.HoldStart = nil
                Hud.Border(0)

                if p9.Buddy then
                    p9.Buddy:Release(false)
                end
            end)
        end,
        Triggered = function() -- Triggered | line: 236
            -- upvalues: p9 (copy), Payload (copy), Hud (copy), Remotes (copy)
            if p9.Done or p9.Caught then
                return
            end

            p9.Caught = true
            Remotes.ShootingStar.Catch:FireServer(Payload.Id)
            task.delay(1.5, function() -- line: 242
                -- upvalues: p9 (copy), Hud (copy)
                if p9.Done or not p9.Caught then
                    return
                end

                p9.Caught = false
                p9.HoldStart = nil
                Hud.Border(0)

                if p9.Buddy then
                    p9.Buddy:Release(false)
                end
            end)
        end
    })

    p9.Buddy = v12
    p9.Trove:Add(function() -- line: 251
        -- upvalues: p9 (copy), v12 (copy)
        if p9.Buddy == v12 then
            v12:Destroy()
        end
    end)

    if p10 then
        v12:PopOut()
    end

    return v12
end

local function startHud(p11) -- line: 262
    -- upvalues: RunService (copy), Hud (copy), refreshProgress (copy)
    Hud.Objective(true)
    refreshProgress(p11)
    Hud.Waypoint(function() -- line: 265
        -- upvalues: p11 (copy)
        if p11.Done then
            return nil
        end

        local Buddy = p11.Buddy

        if Buddy then
            return (Buddy:Position())
        end

        return p11.Payload.Landing.Position
    end)

    local n2 = 0

    p11.Trove:Connect(RunService.Heartbeat, function(p12) -- line: 269
        -- upvalues: p11 (copy), n2 (ref), refreshProgress (copy)
        n2 += p12

        if n2 >= 0.2 then
            n2 = 0
            refreshProgress(p11)
        end
    end)
end

local function reveal(p13) -- line: 278
    -- upvalues: Workspace (copy), Cinematic (copy), spawnBuddy (copy)
    if p13.Done or p13.Buddy then
        return
    end

    if p13.Meteor then
        p13.Meteor:Open()

        local v14 = math.max(p13.Payload.LandAt + Cinematic.Seconds() - Workspace:GetServerTimeNow(), 1.5)
        local Meteor = p13.Meteor

        if Meteor ~= nil then
            p13.Meteor = nil
            task.delay(v14, function() -- line: 158
                -- upvalues: Meteor (copy)
                Meteor:LightOff()
                Meteor:Fade()
            end)
        end
    end

    task.delay(0.45, function() -- line: 287
        -- upvalues: p13 (copy), spawnBuddy (copy)
        if not p13.Done and p13.Buddy == nil then
            spawnBuddy(p13, true)
        end
    end)
end

local function runFall(p14, p15) -- line: 294
    -- upvalues: RunService (copy), Workspace (copy), Cinematic (copy), Fx (copy), now (copy), placeMeteor (copy), startHud (copy), reveal (copy)
    local Payload = p14.Payload
    local v15 = Payload.FallAt + 1
    local clone = Fx.Kit():FindFirstChild("FallingStar"):Clone()
    local ShootingStarClient = Workspace:FindFirstChild("ShootingStarClient")

    if not (ShootingStarClient and ShootingStarClient:IsA("Folder")) then
        ShootingStarClient = Instance.new("Folder")
        ShootingStarClient.Name = "ShootingStarClient"
        ShootingStarClient.Parent = Workspace
    end

    clone.Parent = ShootingStarClient
    p14.Trove:Add(clone)

    local v16 = false
    local v17 = false

    local function land() -- line: 303
        -- upvalues: p14 (copy), p15 (copy), clone (copy), v17 (ref), placeMeteor (copy), startHud (copy), reveal (copy)
        if v17 or p14.Done then
            return
        end

        v17 = true
        clone:Destroy()
        placeMeteor(p14)

        if not p15 then
            task.delay(0.85, reveal, p14)
            startHud(p14)
        end
    end

    local connection

    connection = p14.Trove:Connect(RunService.RenderStepped, function() -- line: 317
        -- upvalues: p14 (copy), p15 (copy), Payload (copy), v15 (copy), clone (copy), v16 (ref), v17 (ref), connection (ref), Workspace (copy), Cinematic (copy), Fx (copy), placeMeteor (copy), startHud (copy), reveal (copy)
        local ServerTimeNow = Workspace:GetServerTimeNow()
        local v19 = math.clamp((ServerTimeNow - v15) / (Payload.LandAt - v15), 0, 1)

        if ServerTimeNow < v15 then
            clone:PivotTo(CFrame.new(Cinematic.StarAt(Payload.Landing, 0)))
        else
            if not v16 then
                v16 = true
                Fx.Sound("StarFall", nil, 0.85)
            end

            local v20 = Cinematic.StarAt(Payload.Landing, v19)
            local v22 = Cinematic.StarAt(Payload.Landing, (math.min(v19 + 0.02, 1)))

            if not ((v22 - v20).Magnitude > 0.001) then
                v22 = v20 + Vector3.new(0, -1, 0)
            end

            clone:PivotTo(CFrame.lookAt(v20, v22) * CFrame.Angles(0, 0, ServerTimeNow * 6))

            if v19 >= 1 then
                connection:Disconnect()

                if not v17 then
                    if p14.Done then
                        return
                    end

                    v17 = true
                    clone:Destroy()
                    placeMeteor(p14)

                    if not p15 then
                        task.delay(0.85, reveal, p14)
                        startHud(p14)
                    end
                end
            end
        end
    end)

    if not p15 then
        return
    end

    Cinematic.Play(Payload, now, {
        Land = land,
        Rise = function() -- Rise | line: 343
            -- upvalues: p14 (copy), reveal (copy)
            reveal(p14)
        end
    })
    task.delay(math.max(Payload.LandAt + Cinematic.Seconds() + 0.6 - Workspace:GetServerTimeNow(), 0), function() -- line: 347
        -- upvalues: p14 (copy), startHud (copy)
        if not p14.Done then
            startHud(p14)
        end
    end)
end

local function begin(p16) -- line: 355
    -- upvalues: Workspace (copy), Fx (copy), Hud (copy), Trove (copy), t1 (ref), spawnBuddy (copy), startHud (copy), runFall (copy)
    if t1 then
        local t6 = t1

        if t1 == t6 then
            t1 = nil
        end

        t6.Done = true
        Hud.Waypoint(nil)
        Hud.Objective(false)
        Hud.Border(0)
        t6.Trove:Destroy()
    end

    if Workspace:GetServerTimeNow() >= p16.ExpiresAt then
        return
    end

    local t7, v24

    if not Fx.KitReady() or Fx.Kit():FindFirstChild("Buddy") == nil then
        warn("[ShootingStar] ReplicatedStorage.Assets.ShootingStar is missing, skipping the star")

        return
    else
        local LandingPosition = p16.Landing.Position

        t7 = {
            Meteor = nil,
            Buddy = nil,
            HoldStart = nil,
            Caught = false,
            Done = false,
            Payload = p16,
            Trove = Trove.new()
        }
        v24 = p16.Leg or {
            From = LandingPosition,
            To = LandingPosition,
            StartAt = p16.LandAt,
            ArriveAt = p16.LandAt
        }
    end

    t7.Leg = v24
    t7.Noticed = p16.Noticed == true
    t1 = t7

    if Workspace:GetServerTimeNow() >= p16.LandAt then
        spawnBuddy(t7, Workspace:GetServerTimeNow() < p16.LandAt + 3.6)
        startHud(t7)
    else
        runFall(t7, p16.Cinematic and Workspace:GetServerTimeNow() <= p16.FallAt + 0.6)
    end
end

local function onWander(p17, p18, p19) -- line: 390
    -- upvalues: t1 (ref), refreshProgress (copy)
    local t8 = t1
    local v27, v28

    if t8 ~= nil then
        if t8.Payload.Id == p17 and typeof(p18) == "table" then
            t8.Leg = p18
            v27 = p19 == true
            v28 = false
        else
            v28 = true
        end
    else
        v28 = true
    end

    if v28 then
        return
    end

    t8.Noticed = v27

    if t8.Buddy then
        t8.Buddy:SetLeg(p18, t8.Noticed)
    end

    refreshProgress(t8)
end

local function onSlipped(p20) -- line: 403
    -- upvalues: Hud (copy), t1 (ref)
    local t9 = t1

    if t9 ~= nil and t9.Payload.Id == p20 then
        t9.Caught = false
        t9.HoldStart = nil
        Hud.Border(0)

        if t9.Buddy then
            t9.Buddy:Release(false)
        end
    end
end

local function onClaimed(p21, p22, _) -- line: 412
    -- upvalues: Fx (copy), Hud (copy), t1 (ref), t2 (ref)
    local t10 = t1
    local v29 = true

    if t10 ~= nil then
        if t10.Payload.Id == p21 then
            t10.HoldStart = nil

            local Buddy = t10.Buddy

            t10.Buddy = nil

            if Buddy then
                t2 = {
                    Model = Buddy:Detach(),
                    Amount = p22
                }
            else
                t2 = {
                    Model = nil,
                    Amount = p22
                }
            end

            v29 = false
        end
    end

    if v29 then
        return
    end

    local Meteor = t10.Meteor

    if Meteor ~= nil then
        t10.Meteor = nil
        task.delay(2, function() -- line: 158
            -- upvalues: Meteor (copy)
            Meteor:LightOff()
            Meteor:Fade()
        end)
    end

    Hud.BorderFade()

    if t1 == t10 then
        t1 = nil
    end

    t10.Done = true
    Hud.Waypoint(nil)
    Hud.Objective(false)
    Hud.Border(0)
    t10.Trove:Destroy()
    Fx.FovPunch(4, 0.6)
end

local function onCelebrate(p24, p25, p26, p27) -- line: 431
    -- upvalues: Celebrate (copy), Fx (copy), Hud (copy), Tabs (copy), LocalPlayer (copy), t2 (ref)
    if typeof(p24) ~= "Instance" or not p24:IsA("Player") then
        return
    end

    if p24 ~= LocalPlayer then
        Celebrate.Play(p24, {
            Kind = p25,
            From = p26,
            Count = p27
        })

        return
    end

    if p25 == "Gift" and Tabs.IsActive("Shop") then
        Tabs.Deactivate()
    end

    local t11 = t2

    t2 = nil

    local v30 = if type(p27) == "number" then p27 elseif t11 then t11.Amount else 1

    Celebrate.Play(p24, {
        Kind = p25,
        From = p26,
        Model = if t11 then t11.Model else nil,
        Count = v30,
        OnRaised = function() -- OnRaised | line: 450
            -- upvalues: v30 (copy), Fx (copy), Hud (copy)
            Fx.Sound("StarReward", nil, 0.8)
            Hud.Reward(v30)
        end
    })
end

local function onExpired(p28) -- line: 457
    -- upvalues: Hud (copy), Toast (copy), v1 (copy), t1 (ref)
    local t13 = t1
    local v31 = true

    if t13 ~= nil then
        if t13.Payload.Id == p28 then
            local Buddy = t13.Buddy

            t13.Buddy = nil

            if Buddy then
                Buddy:Leave()
            end

            v31 = false
        end
    end

    if v31 then
        return
    end

    local Meteor = t13.Meteor

    if Meteor ~= nil then
        t13.Meteor = nil
        task.delay(0, function() -- line: 158
            -- upvalues: Meteor (copy)
            Meteor:LightOff()
            Meteor:Fade()
        end)
    end

    Toast.Show({
        Text = "The little star went home to the sky...",
        Seconds = 4,
        Color = v1
    })

    if t1 == t13 then
        t1 = nil
    end

    t13.Done = true
    Hud.Waypoint(nil)
    Hud.Objective(false)
    Hud.Border(0)
    t13.Trove:Destroy()
end

function t3.Start() -- line: 476
    -- upvalues: Remotes (copy), StarFeed (copy), t1 (ref), begin (copy), onWander (copy), onSlipped (copy), onClaimed (copy), onCelebrate (copy), onExpired (copy)
    Remotes.ShootingStar.Fall.OnClientEvent:Connect(begin)
    Remotes.ShootingStar.Wander.OnClientEvent:Connect(onWander)
    Remotes.ShootingStar.Slipped.OnClientEvent:Connect(onSlipped)
    Remotes.ShootingStar.Claimed.OnClientEvent:Connect(onClaimed)
    Remotes.ShootingStar.Celebrate.OnClientEvent:Connect(onCelebrate)
    Remotes.ShootingStar.Expired.OnClientEvent:Connect(onExpired)
    StarFeed.Start()
    task.spawn(function() -- line: 484
        -- upvalues: Remotes (copy), t1 (ref), begin (copy)
        local function v32() -- line: 485
            -- upvalues: Remotes (copy)
            return Remotes.ShootingStar.AskState:InvokeServer()
        end

        local ok, result = pcall(v32)

        if ok and typeof(result) == "table" and t1 == nil then
            begin(result)
        end
    end)
end

return t3
