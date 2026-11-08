-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Cutscene = require(script.Cutscene)
local RedLightGreenLightFlags = require(ReplicatedStorage.Shared.Flags.RedLightGreenLightFlags)
local Fx = require(script.Fx)
local Giant = require(script.Giant)
local Hud = require(script.Hud)
local Laser = require(script.Laser)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Shake = require(ReplicatedStorage.Client.Shake)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = Color3.fromRGB(255, 214, 89)
local v2 = table.freeze({
    Giant = "RLGL_Giant",
    GiantHeight = "RLGL_GiantHeight",
    RiseAt = "RLGL_RiseAt",
    Light = "RLGL_Light",
    FakeAt = "RLGL_FakeAt",
    EggPosition = "RLGL_EggPosition",
    CarrierUserId = "RLGL_CarrierUserId",
    Lives = "RLGL_Lives"
})
local LocalPlayer = Players.LocalPlayer
local v3, v4, v5, v6
local n1 = 0
local t1 = {}

local function currentLight() -- line: 56
    -- upvalues: Workspace (copy), v2 (copy)
    local Attribute = Workspace:GetAttribute(v2.Light)

    if type(Attribute) == "string" then
        return Attribute
    end

    return "Rise"
end

local function isRedLight() -- line: 62
    -- upvalues: Workspace (copy), v2 (copy)
    local Attribute = Workspace:GetAttribute(v2.Light)

    if type(Attribute) ~= "string" then
        Attribute = "Rise"
    end

    return Attribute == "Red"
end

local function buildBeacon(p1) -- line: 66
    -- upvalues: Fx (copy), v1 (copy)
    local EggBeacon = Fx.Holder(Vector3.new(0, 0, 0), "EggBeacon")
    local EggBeaconTop = Fx.Holder(Vector3.new(0, 0, 0), "EggBeaconTop")
    local Attachment = Instance.new("Attachment")
    local Attachment2 = Instance.new("Attachment")

    Attachment.Parent = EggBeacon
    Attachment2.Parent = EggBeaconTop

    for v7, v8 in { 7, 18 } do
        local Beam = Instance.new("Beam")

        Beam.Attachment0 = Attachment
        Beam.Attachment1 = Attachment2
        Beam.Texture = "rbxassetid://16288356764"
        Beam.TextureMode = Enum.TextureMode.Stretch
        Beam.TextureSpeed = 0.4
        Beam.LightEmission = 1
        Beam.Brightness = 2
        Beam.FaceCamera = true
        Beam.Color = ColorSequence.new(v1)
        Beam.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, v7 == 1 and 0.1 or 0.55),
            NumberSequenceKeypoint.new(0.7, v7 == 1 and 0.5 or 0.8),
            NumberSequenceKeypoint.new(1, 1)
        })
        Beam.Width0 = v8
        Beam.Width1 = v8 * 0.4
        Beam.Parent = EggBeacon
    end

    local PointLight = Instance.new("PointLight")

    PointLight.Color = v1
    PointLight.Range = 40
    PointLight.Brightness = 3
    PointLight.Parent = EggBeacon
    p1:Add(EggBeacon)
    p1:Add(EggBeaconTop)

    return EggBeacon, EggBeaconTop
end

local function updateBeacon(p2, p3, p4) -- line: 110
    -- upvalues: Players (copy), Workspace (copy), v2 (copy)
    local Attribute = Workspace:GetAttribute(v2.EggPosition)

    if typeof(Attribute) ~= "Vector3" then
        p2.Position = Vector3.new(0, -5000, 0)
        p3.Position = Vector3.new(0, -5000, 0)

        return
    end

    local Attribute2 = Workspace:GetAttribute(v2.CarrierUserId)
    local v9 = if type(Attribute2) == "number" then Players:GetPlayerByUserId(Attribute2) else nil
    local Character = if v9 == nil then nil else v9.Character
    local HumanoidRootPart = if Character == nil then nil else Character:FindFirstChild("HumanoidRootPart")

    if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then
        Attribute = HumanoidRootPart.Position
    end

    if not (p2.Position.Y < -1000) then
        Attribute = p2.Position:Lerp(Attribute, (math.min(p4 * 12, 1)))
    end

    p2.Position = Attribute
    p3.Position = Attribute + Vector3.new(0, 900, 0)
end

local function applyLight(p5) -- line: 134
    -- upvalues: Fx (copy), Giant (copy), Hud (copy), Shake (copy), v4 (ref), v5 (ref), v6 (ref)
    local v11 = v4
    local v12 = v5
    local v13 = v6 ~= nil and not v6.Done

    if v12 ~= nil then
        Hud.SetLight(v12, p5)
    end

    if v11 ~= nil and not v13 then
        if p5 == "Red" then
            Giant.Face(v11, true)
            Giant.SetEyes(v11, 0.75)
            Fx.Sound({ "Sounds", "ScrambleBoss", "Swoosh" }, nil, 1.5, 0.75)
            Fx.Sound({ "Sounds", "ScrambleBoss", "Stomp" }, nil, 0.7, 0.8)
            Fx.Sound({ "Sounds", "ScrambleBoss", "Tick" }, nil, 1.2, 0.6)
            Shake.Play({
                Seconds = 0.45,
                Magnitude = 1.1,
                Shape = "Fade"
            })
        elseif p5 == "Green" then
            Giant.Face(v11, false)
            Giant.SetEyes(v11, 0)
            Fx.Sound({ "Sounds", "ScrambleBoss", "Swoosh" }, nil, 0.9, 1.1)
        elseif p5 == "Wait" then
            Giant.Face(v11, false)
            Giant.SetEyes(v11, 0)
        end
    end
end

local function onFake() -- line: 164
    -- upvalues: Workspace (copy), Fx (copy), Giant (copy), v2 (copy), v4 (ref)
    local v14 = v4

    if v14 == nil then
        return
    end

    local Attribute = Workspace:GetAttribute(v2.Light)

    if type(Attribute) ~= "string" then
        Attribute = "Rise"
    end

    if Attribute == "Green" then
        Giant.TwitchHead(v14, math.random() < 0.5 and -1 or 1)
        Fx.Sound({ "Sounds", "ScrambleBoss", "Tick" }, nil, 1, 0.9)
    end
end

local function refreshLives() -- line: 175
    -- upvalues: RedLightGreenLightFlags (copy), Hud (copy), v2 (copy), LocalPlayer (copy), v5 (ref)
    local v15 = v5

    if v15 == nil then
        return
    end

    local Attribute = LocalPlayer:GetAttribute(v2.Lives)
    local v16 = RedLightGreenLightFlags.Lives:Get()
    local SetLives = Hud.SetLives

    if type(Attribute) ~= "number" then
        Attribute = v16
    end

    SetLives(v15, Attribute, v16)
end

local function sinkGiant(p6) -- line: 188
    -- upvalues: RunService (copy), Fx (copy), Giant (copy)
    local elapsed = os.clock()
    local connection

    Fx.Sound({ "Sounds", "ScrambleBoss", "Rumble" }, p6.Ground.Position, 1, 1, 6000)
    connection = RunService.RenderStepped:Connect(function(p7) -- line: 193
        -- upvalues: p6 (copy), elapsed (copy), connection (ref), Giant (copy)
        local v18 = math.clamp((os.clock() - elapsed) / 1.8, 0, 1)

        p6.Rise = 1 - v18 * v18
        Giant.Update(p6, p7)

        if v18 >= 1 then
            if connection ~= nil then
                connection:Disconnect()
            end

            Giant.Destroy(p6)
        end
    end)
end

local function begin(p8, p9) -- line: 209
    -- upvalues: ReplicatedStorage (copy), RunService (copy), Workspace (copy), Cutscene (copy), RedLightGreenLightFlags (copy), Giant (copy), Hud (copy), Laser (copy), Remotes (copy), v2 (copy), LocalPlayer (copy), v3 (ref), v4 (ref), v5 (ref), v6 (ref), n1 (ref), isRedLight (copy), buildBeacon (copy), updateBeacon (copy), applyLight (copy), onFake (copy), refreshLives (copy)
    while Workspace:GetAttribute(v2.Giant) == nil and p8 == n1 do
        task.wait(0.1)
    end

    if p8 == n1 then
        local v19 = ReplicatedStorage:FindFirstChild("RedLightGreenLightPersona") or ReplicatedStorage:WaitForChild("RedLightGreenLightPersona", 3)

        if p8 == n1 then
            local v20 = v3
            local Attribute = Workspace:GetAttribute(v2.Giant)
            local Attribute2 = Workspace:GetAttribute(v2.GiantHeight)

            if v19 == nil or not v19:IsA("Model") then
                v19 = nil
            end

            local v21 = Hud.Mount(v19)

            v5 = v21

            if v19 ~= nil then
                v4 = Giant.new(v19, Attribute, if type(Attribute2) == "number" then Attribute2 else 520)
            end

            local v22 = v4
            local Attribute3 = Workspace:GetAttribute(v2.RiseAt)
            local v23 = not (type(p9) == "table" and p9.WasInProgress == true) and type(Attribute3) == "number" and Workspace:GetServerTimeNow() - Attribute3 < 6

            if v22 ~= nil and v21 ~= nil and v23 then
                v6 = Cutscene.Play(v22, v21, Attribute3)
            else
                if v22 ~= nil then
                    local Face = Giant.Face
                    local Attribute = Workspace:GetAttribute(v2.Light)

                    if type(Attribute) ~= "string" then
                        Attribute = "Rise"
                    end

                    Face(v22, Attribute == "Red", true)
                end

                if v21 ~= nil then
                    Hud.SetBoardShown(v21, true)
                end
            end

            local Attribute4 = Workspace:GetAttribute(v2.Light)

            if type(Attribute4) ~= "string" then
                Attribute4 = "Rise"
            end

            applyLight(Attribute4)

            local v24 = v5

            if v24 ~= nil then
                local Attribute = LocalPlayer:GetAttribute(v2.Lives)
                local v25 = RedLightGreenLightFlags.Lives:Get()
                local SetLives = Hud.SetLives

                if type(Attribute) ~= "number" then
                    Attribute = v25
                end

                SetLives(v24, Attribute, v25)
            end

            local v26, v27 = buildBeacon(v20)

            v20:Connect(Workspace:GetAttributeChangedSignal(v2.Light), function() -- line: 262
                -- upvalues: Workspace (copy), v2 (copy), applyLight (copy)
                local Attribute = Workspace:GetAttribute(v2.Light)

                if type(Attribute) ~= "string" then
                    Attribute = "Rise"
                end

                applyLight(Attribute)
            end)
            v20:Connect(Workspace:GetAttributeChangedSignal(v2.FakeAt), onFake)
            v20:Connect(LocalPlayer:GetAttributeChangedSignal(v2.Lives), refreshLives)
            v20:Connect(Remotes.RedLightGreenLight.Caught.OnClientEvent, function(p10, p11, _, p13, p14) -- line: 269
                -- upvalues: Laser (copy), v4 (ref), isRedLight (copy)
                local v28 = v4
                local Fire, v29

                if v28 ~= nil and type(p10) == "number" and typeof(p11) == "Vector3" and type(p14) == "number" then
                    Fire = Laser.Fire
                    v29 = p13 == true
                    Fire(v28, p10, p11, p14, v29, isRedLight)
                end
            end)
            v20:Connect(Remotes.RedLightGreenLight.Cover.OnClientEvent, function(p15) -- line: 290
                -- upvalues: Hud (copy), v5 (ref)
                if v5 ~= nil and type(p15) == "number" then
                    Hud.Cover(v5, (math.clamp(p15, 0.1, 2)))
                end
            end)
            v20:Connect(RunService.RenderStepped, function(p16) -- line: 295
                -- upvalues: v26 (copy), v27 (copy), Giant (copy), Hud (copy), v4 (ref), v5 (ref), v6 (ref), updateBeacon (copy)
                local v30 = v4
                local v31 = v6

                if v30 ~= nil and (v31 == nil or v31.Done) then
                    v30.Rise = 1
                end

                if v30 ~= nil then
                    Giant.Update(v30, p16)
                end

                if v5 ~= nil then
                    Hud.Update(v5, p16, v30)
                end

                updateBeacon(v26, v27, p16)
            end)
        end
    end
end

function t1.StartEvent(_, _, p19) -- line: 319
    -- upvalues: Trove (copy), v3 (ref), n1 (ref), t1 (copy), begin (copy)
    t1:StopEvent()
    n1 += 1
    v3 = Trove.new()

    local v32 = n1

    task.spawn(begin, v32, p19)
end

function t1.StopEvent(_) -- line: 329
    -- upvalues: Hud (copy), v3 (ref), v4 (ref), v5 (ref), v6 (ref), n1 (ref), sinkGiant (copy)
    n1 += 1

    local v33 = v6

    v6 = nil

    if v33 ~= nil then
        v33.Stop()
    end

    if v3 ~= nil then
        v3:Clean()
        v3 = nil
    end

    local v34 = v4

    v4 = nil

    if v34 ~= nil then
        sinkGiant(v34)
    end

    local v35 = v5

    v5 = nil

    if v35 ~= nil then
        Hud.Unmount(v35)
    end
end

return t1
