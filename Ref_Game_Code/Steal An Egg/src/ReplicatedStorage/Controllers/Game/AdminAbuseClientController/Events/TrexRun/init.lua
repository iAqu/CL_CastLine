-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Cutscene = require(script.Cutscene)
local Fx = require(script.Fx)
local Herd = require(script.Herd)
local Hud = require(script.Hud)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Shake = require(ReplicatedStorage.Client.Shake)
local TrexRunHerd = require(ReplicatedStorage.Shared.Modules.TrexRunHerd)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = Color3.fromRGB(255, 214, 89)
local Attributes = TrexRunHerd.Attributes
local LocalPlayer = Players.LocalPlayer
local v2, v3, v4, v5
local n1 = 0
local t1 = {}

local function attribute(p1) -- line: 46
    -- upvalues: Workspace (copy)
    return Workspace:GetAttribute(p1)
end

local function buildBeacon(p2) -- line: 50
    -- upvalues: Fx (copy), v1 (copy)
    local EggBeacon = Fx.Holder(Vector3.new(0, 0, 0), "EggBeacon")
    local EggBeaconTop = Fx.Holder(Vector3.new(0, 0, 0), "EggBeaconTop")
    local Attachment = Instance.new("Attachment")
    local Attachment2 = Instance.new("Attachment")

    Attachment.Parent = EggBeacon
    Attachment2.Parent = EggBeaconTop

    for v6, v7 in { 7, 18 } do
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
            NumberSequenceKeypoint.new(0, v6 == 1 and 0.1 or 0.55),
            NumberSequenceKeypoint.new(0.7, v6 == 1 and 0.5 or 0.8),
            NumberSequenceKeypoint.new(1, 1)
        })
        Beam.Width0 = v7
        Beam.Width1 = v7 * 0.4
        Beam.Parent = EggBeacon
    end

    local PointLight = Instance.new("PointLight")

    PointLight.Color = v1
    PointLight.Range = 40
    PointLight.Brightness = 3
    PointLight.Parent = EggBeacon
    p2:Add(EggBeacon)
    p2:Add(EggBeaconTop)

    return EggBeacon, EggBeaconTop
end

local function updateBeacon(p3, p4, p5) -- line: 94
    -- upvalues: Players (copy), Workspace (copy), Attributes (copy), LocalPlayer (copy)
    local Attribute = Workspace:GetAttribute(Attributes.EggPosition)

    if typeof(Attribute) ~= "Vector3" then
        p3.Position = Vector3.new(0, -5000, 0)
        p4.Position = Vector3.new(0, -5000, 0)

        return
    end

    local Attribute2 = Workspace:GetAttribute(Attributes.CarrierUserId)
    local v8 = if type(Attribute2) == "number" then Players:GetPlayerByUserId(Attribute2) else nil

    if v8 == LocalPlayer then
        p3.Position = Vector3.new(0, -5000, 0)
        p4.Position = Vector3.new(0, -5000, 0)
    else
        local Character = if v8 == nil then nil else v8.Character
        local HumanoidRootPart = if Character == nil then nil else Character:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then
            Attribute = HumanoidRootPart.Position
        end

        if not (p3.Position.Y < -1000) then
            Attribute = p3.Position:Lerp(Attribute, (math.min(p5 * 12, 1)))
        end

        p3.Position = Attribute
        p4.Position = Attribute + Vector3.new(0, 900, 0)
    end
end

local function buildCarrierHighlight(p6) -- line: 125
    -- upvalues: Fx (copy), v1 (copy)
    local Highlight = Instance.new("Highlight")

    Highlight.Name = "TrexCarrierHighlight"
    Highlight.FillColor = v1
    Highlight.OutlineColor = v1
    Highlight.FillTransparency = 0.85
    Highlight.OutlineTransparency = 0.4
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.Enabled = false
    Highlight.Parent = Fx.Folder()
    p6:Add(Highlight)

    return Highlight
end

local function updateCarrierHighlight(p7) -- line: 141
    -- upvalues: Players (copy), Workspace (copy), Attributes (copy)
    local Attribute = Workspace:GetAttribute(Attributes.CarrierUserId)
    local v10 = if type(Attribute) == "number" then Players:GetPlayerByUserId(Attribute) else nil
    local Character = if v10 == nil then nil else v10.Character

    if Character ~= nil then
        if p7.Adornee ~= Character then
            p7.Adornee = Character
        end

        p7.Enabled = true
    else
        p7.Enabled = false
        p7.Adornee = nil
    end
end

local function carrierPlayer() -- line: 161
    -- upvalues: Players (copy), Workspace (copy), Attributes (copy)
    local Attribute = Workspace:GetAttribute(Attributes.CarrierUserId)

    return if type(Attribute) == "number" then Players:GetPlayerByUserId(Attribute) else nil
end

local function refreshStatus() -- line: 167
    -- upvalues: Players (copy), Workspace (copy), Hud (copy), Attributes (copy), LocalPlayer (copy), v4 (ref)
    local v11 = v4

    if v11 == nil then
        return
    end

    local Attribute = Workspace:GetAttribute(Attributes.CarrierUserId)
    local v12 = if type(Attribute) == "number" then Players:GetPlayerByUserId(Attribute) else nil

    if Workspace:GetAttribute(Attributes.Phase) == "Wait" then
        Hud.SetObjective(v11, "Starts at sunrise")
    elseif v12 == LocalPlayer then
        Hud.SetObjective(v11, "Run it home!")
    elseif v12 ~= nil then
        Hud.SetObjective(v11, (("%* has the egg!"):format(v12.DisplayName)))
    else
        Hud.SetObjective(v11, "Steal the TRex Egg!")
    end
end

local function updateProgress(p8, p9, p10) -- line: 187
    -- upvalues: Players (copy), Workspace (copy), Hud (copy), TrexRunHerd (copy), Attributes (copy)
    local Attribute = Workspace:GetAttribute(Attributes.CarrierUserId)
    local v13 = if type(Attribute) == "number" then Players:GetPlayerByUserId(Attribute) else nil
    local Character = if v13 == nil then nil else v13.Character
    local HumanoidRootPart = if Character == nil then nil else Character:FindFirstChild("HumanoidRootPart")
    local v14 = if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then Workspace:GetAttribute(Attributes.EggPosition) else HumanoidRootPart.Position

    if typeof(v14) ~= "Vector3" then
        return
    end

    local v16 = math.max(TrexRunHerd.Locate(p9, v14), 0)

    Hud.SetProgress(p8, 1 - v16 / math.max(p10, 1), (`{ math.floor(v16 / 10) * 10 } studs`))
end

local function onHerdTurned(p11) -- line: 204
    -- upvalues: Workspace (copy), Fx (copy), Herd (copy), Shake (copy), Attributes (copy), v3 (ref)
    local v19 = v3
    local Attribute = Workspace:GetAttribute(Attributes.Herd)

    if v19 == nil or p11 == nil or p11 == Attribute then
        return
    end

    Herd.Roar(v19, 1)
    Fx.Sound({ "Sounds", "ScrambleBoss", "Rumble" }, nil, 1.1, 0.9)
    Shake.Play({
        Seconds = 0.8,
        Magnitude = 1.4,
        Shape = "Fade"
    })
end

local function onTrampled(p12, p13, _) -- line: 217
    -- upvalues: Fx (copy), Herd (copy), Hud (copy), Shake (copy), LocalPlayer (copy), v4 (ref)
    if type(p12) == "number" and typeof(p13) == "Vector3" then
        Herd.Dust(p13, 1)

        if p12 ~= LocalPlayer.UserId then
            Fx.Sound({ "Sounds", "ScrambleBoss", "HeavyLand" }, p13, 1, 1.1, 300)

            return
        end

        if v4 ~= nil then
            Hud.Flash(v4)
        end

        Fx.Sound({ "Sounds", "ScrambleBoss", "HeavyLand" }, nil, 1.3, 1.1)
        Shake.Play({
            Seconds = 0.6,
            Magnitude = 2.4,
            Shape = "Fade"
        })
    end
end

local function begin(p15, p16) -- line: 237
    -- upvalues: Players (copy), ReplicatedStorage (copy), RunService (copy), Workspace (copy), Cutscene (copy), Fx (copy), Herd (copy), Hud (copy), Remotes (copy), Shake (copy), TrexRunHerd (copy), v1 (copy), Attributes (copy), LocalPlayer (copy), v2 (ref), v3 (ref), v4 (ref), v5 (ref), n1 (ref), buildBeacon (copy), updateBeacon (copy), refreshStatus (copy), updateProgress (copy), onHerdTurned (copy), onTrampled (copy)
    local v20 = os.clock() + 10

    while TrexRunHerd.ReadCourse(Workspace) == nil and os.clock() < v20 and p15 == n1 do
        task.wait(0.1)
    end

    local v21 = TrexRunHerd.ReadCourse(Workspace)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local v22 = if Assets == nil then nil else Assets:WaitForChild("TrexRunVisuals", 10)

    if p15 ~= n1 or v21 == nil or v22 == nil then
        return
    end

    local v23 = v2
    local v24 = Herd.new(v21, v22)

    if v24 == nil then
        return
    end

    v3 = v24

    local v25 = Hud.Mount()
    local Attribute = Workspace:GetAttribute(Attributes.Alpha)

    v4 = v25

    if typeof(Attribute) == "CFrame" then
        Herd.MountAlpha(v24, Attribute)
    end

    v23:Connect(Remotes.TrexRun.Wave.OnClientEvent, function(p17) -- line: 276
        -- upvalues: Workspace (copy), Herd (copy), v3 (ref)
        local v26 = v3

        if v26 ~= nil and type(p17) == "table" then
            Herd.Add(v26, p17)

            if type(p17.Depth) == "number" then
                Herd.RowDust(v26, p17, p17.Depth, Workspace.CurrentCamera.CFrame.Position)
            end
        end
    end)
    v23:Connect(Remotes.TrexRun.Herd.OnClientEvent, function(p18) -- line: 289
        -- upvalues: Herd (copy), v3 (ref)
        if v3 ~= nil and type(p18) == "table" then
            Herd.Set(v3, p18)
        end
    end)
    v23:Connect(Remotes.TrexRun.Trampled.OnClientEvent, onTrampled)

    local function v27() -- line: 296
        -- upvalues: Remotes (copy)
        return Remotes.TrexRun.FetchHerd:InvokeServer()
    end

    local ok, result = pcall(v27)

    if p15 == n1 then
        if ok and type(result) == "table" then
            Herd.Set(v24, result)
        end

        local Attribute = Workspace:GetAttribute(Attributes.IntroAt)
        local Attribute2 = Workspace:GetAttribute(Attributes.EggPosition)
        local v28 = not (type(p16) == "table" and p16.WasInProgress == true) and v25 ~= nil and type(Attribute) == "number" and typeof(Attribute2) == "Vector3" and Workspace:GetServerTimeNow() - Attribute < 4

        if v28 then
            v5 = Cutscene.Play(v24, v25, Attribute, Attribute2)
        elseif v25 ~= nil then
            Hud.SetBoardShown(v25, true)
        end

        refreshStatus()

        local v29 = Workspace:GetAttribute(Attributes.Herd)
        local v30 = Workspace:GetServerTimeNow() >= (Workspace:GetAttribute(Attributes.StartAt) or 0)
        local v31 = os.clock() + 7
        local v32, v33 = buildBeacon(v23)
        local Attribute3 = Workspace:GetAttribute(Attributes.EggPosition)
        local v34 = if typeof(Attribute3) == "Vector3" then TrexRunHerd.Locate(v21, Attribute3) else v21.Far
        local Highlight = Instance.new("Highlight")

        Highlight.Name = "TrexCarrierHighlight"
        Highlight.FillColor = v1
        Highlight.OutlineColor = v1
        Highlight.FillTransparency = 0.85
        Highlight.OutlineTransparency = 0.4
        Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
        Highlight.Enabled = false
        Highlight.Parent = Fx.Folder()
        v23:Add(Highlight)
        v23:Connect(Workspace:GetAttributeChangedSignal(Attributes.Herd), function() -- line: 336
            -- upvalues: v29 (ref), Workspace (copy), Attributes (copy), refreshStatus (copy), onHerdTurned (copy)
            onHerdTurned(v29)
            v29 = Workspace:GetAttribute(Attributes.Herd)
            refreshStatus()
        end)
        v23:Connect(Workspace:GetAttributeChangedSignal(Attributes.Phase), refreshStatus)
        v23:Connect(Workspace:GetAttributeChangedSignal(Attributes.CarrierUserId), refreshStatus)
        v23:Connect(RunService.RenderStepped, function(p19) -- line: 343
            -- upvalues: v21 (copy), v30 (ref), v31 (ref), v32 (copy), v33 (copy), Highlight (copy), v34 (copy), Players (copy), Workspace (copy), Fx (copy), Herd (copy), Hud (copy), Shake (copy), Attributes (copy), LocalPlayer (copy), v3 (ref), v4 (ref), updateBeacon (copy), updateProgress (copy)
            local v35 = v3

            if v35 == nil then
                return
            end

            local ServerTimeNow = Workspace:GetServerTimeNow()
            local CurrentCamera = Workspace.CurrentCamera

            Herd.Update(v35, p19, ServerTimeNow, CurrentCamera.CFrame.Position)

            local Attribute = Workspace:GetAttribute(Attributes.StartAt)

            if not v30 and type(Attribute) == "number" and Attribute <= ServerTimeNow then
                v30 = true
                Herd.Roar(v35, 1.2)
                Fx.Sound({ "Sounds", "ScrambleBoss", "Rumble" }, nil, 1.3, 0.85)
                Shake.Play({
                    Seconds = 1,
                    Magnitude = 1.6,
                    Shape = "Fade"
                })
            end

            if v30 and os.clock() >= v31 then
                v31 = os.clock() + 7 * (0.8 + math.random() * 0.4)
                Herd.Roar(v35, 0.6)
            end

            local v36 = v4

            if v36 ~= nil then
                local Character = LocalPlayer.Character
                local HumanoidRootPart = if Character == nil then nil else Character:FindFirstChild("HumanoidRootPart")
                local v37 = if v30 and HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then Herd.Danger(v35, ServerTimeNow, HumanoidRootPart.Position, 170) else 0

                Hud.SetDanger(v36, v37)
                Hud.Update(v36, p19)
                updateProgress(v36, v21, v34)
            end

            updateBeacon(v32, v33, p19)

            local Attribute2 = Workspace:GetAttribute(Attributes.CarrierUserId)
            local v38 = if type(Attribute2) == "number" then Players:GetPlayerByUserId(Attribute2) else nil
            local Character = if v38 == nil then nil else v38.Character

            if Character ~= nil then
                if Highlight.Adornee ~= Character then
                    Highlight.Adornee = Character
                end

                Highlight.Enabled = true
            else
                Highlight.Enabled = false
                Highlight.Adornee = nil
            end
        end)
    end
end

function t1.StartEvent(_, _, p22) -- line: 396
    -- upvalues: Trove (copy), v2 (ref), n1 (ref), t1 (copy), begin (copy)
    t1:StopEvent()
    n1 += 1
    v2 = Trove.new()
    task.spawn(begin, n1, p22)
end

function t1.StopEvent(_) -- line: 404
    -- upvalues: Herd (copy), Hud (copy), v2 (ref), v3 (ref), v4 (ref), v5 (ref), n1 (ref)
    n1 += 1

    local v39 = v5

    v5 = nil

    if v39 ~= nil then
        v39.Stop()
    end

    if v2 ~= nil then
        v2:Clean()
        v2 = nil
    end

    local v40 = v3

    v3 = nil

    if v40 ~= nil then
        Herd.Destroy(v40)
    end

    local v41 = v4

    v4 = nil

    if v41 ~= nil then
        Hud.Unmount(v41)
    end
end

return t1
