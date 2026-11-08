-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TrainEvent = require(ReplicatedStorage.Shared.Remotes).TrainEvent
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = Color3.fromRGB(150, 255, 120)
local v2 = Color3.fromRGB(20, 70, 10)
local LocalPlayer = Players.LocalPlayer
local v3 = Trove.new()
local v4 = false
local t1 = {}

local function heldTicket() -- line: 37
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character

    if Character ~= nil then
        for _, child in Character:GetChildren() do
            if child:IsA("Tool") and child:GetAttribute("ConductorTicket") == true then
                return child
            end
        end
    end

    return nil
end

local function gripFrame() -- line: 50
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character

    if Character == nil then
        return nil
    end

    local v5 = Character:FindFirstChild("RightGripAttachment", true)

    if v5 ~= nil and v5:IsA("Attachment") then
        return v5.WorldCFrame
    end

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

    return if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart.CFrame * CFrame.new(1, 0, -1) else nil
end

local function buildTicket() -- line: 66
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local GhostDogQuest = Assets and Assets:FindFirstChild("GhostDogQuest")
    local Ticket = GhostDogQuest and GhostDogQuest:FindFirstChild("Ticket")

    if Ticket == nil or not Ticket:IsA("Model") then
        return nil
    end

    local clone = Ticket:Clone()

    clone.Name = "ConductorTicketFlight"

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanTouch = false
            descendant.CanQuery = false
            descendant.CastShadow = false
        elseif descendant:IsA("LuaSourceContainer") then
            descendant:Destroy()
        end
    end

    local _, BoundingBox = clone:GetBoundingBox()
    local v6 = math.max(BoundingBox.X, BoundingBox.Y, BoundingBox.Z)

    if v6 > 0 then
        clone:ScaleTo(clone:GetScale() * 1.8 / v6)
    end

    return clone
end

local function bezier(p1, p2, p3, p4) -- line: 94
    local v7 = 1 - p4

    return p1 * (v7 * v7) + p2 * (v7 * 2 * p4) + p3 * (p4 * p4)
end

local function ease(p5) -- line: 99
    return p5 * p5 * (3 - p5 * 2)
end

local function fly(p6, p7, p8, p9, p10) -- line: 103
    -- upvalues: RunService (copy), Workspace (copy), v3 (copy), buildTicket (copy)
    local v8 = buildTicket()

    if v8 == nil then
        return
    end

    local v9 = v3:Extend()

    v9:Add(v8)

    local Scale = v8:GetScale()
    local n1 = 0

    local function step(p11) -- line: 119
        -- upvalues: p6 (copy), p7 (copy), p8 (copy), p9 (copy), p10 (copy), v8 (copy), v9 (copy), Scale (copy), n1 (ref), v3 (copy)
        n1 += p11

        local v11 = math.clamp(n1 / p9, 0, 1)
        local v12 = p8()

        if v12 ~= nil and not (v11 >= 1) then
            local v13 = v11 * v11 * (3 - v11 * 2)
            local v15 = math.sin(v11 * 3.141592653589793)
            local v17 = math.clamp((v12 - p6).Magnitude * 0.35, 3, 12)
            local v18 = (p6 + v12) / 2 + Vector3.new(0, v17, 0)

            v8:ScaleTo(Scale * math.max((if p10 then 1 - v13 * 0.65 else v13 * 0.65 + 0.35) + v15 * 0.3, 0.05))

            local new = CFrame.new
            local v20 = 1 - v13

            v8:PivotTo(new(p6 * (v20 * v20) + v18 * (v20 * 2 * v13) + v12 * (v13 * v13)) * p7 * CFrame.Angles(v15 * 0.6, v13 * 3.141592653589793 * 2 * 2, 0))

            return true
        end

        v3:Remove(v9)

        return false
    end

    if step(0) then
        v8.Parent = Workspace
        v9:Connect(RunService.RenderStepped, step)
    end
end

local function secondsOf(p12) -- line: 148
    local Seconds = p12.Seconds

    if type(Seconds) == "number" and Seconds > 0 and Seconds <= 3 then
        return Seconds
    end

    return 0.65
end

local function notify(p13) -- line: 157
    -- upvalues: Toast (copy), v1 (copy), v2 (copy)
    Toast.Show({
        Lane = "Feed",
        Seconds = 3,
        Text = p13,
        Color = v1,
        StrokeColor = v2
    })
end

local function setHidden(p14, p15) -- line: 167
    for _, descendant in p14:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.LocalTransparencyModifier = p15 and 1 or 0
        end
    end
end

local function hideUntilStowed(p16) -- line: 175
    -- upvalues: LocalPlayer (copy)
    for _, descendant in p16:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.LocalTransparencyModifier = 1
        end
    end

    local connection

    connection = p16.AncestryChanged:Connect(function() -- line: 178
        -- upvalues: p16 (copy), connection (ref), LocalPlayer (copy)
        if p16.Parent == LocalPlayer.Character then
            return
        end

        if connection ~= nil then
            connection:Disconnect()
        end

        for _, descendant in p16:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.LocalTransparencyModifier = 0
            end
        end
    end)
end

local function onTicketIn(p17) -- line: 189
    -- upvalues: Toast (copy), v1 (copy), v2 (copy), LocalPlayer (copy), heldTicket (copy), gripFrame (copy), fly (copy)
    local v21 = heldTicket()

    if v21 ~= nil then
        for _, descendant in v21:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.LocalTransparencyModifier = 1
            end
        end

        local connection

        connection = v21.AncestryChanged:Connect(function() -- line: 178
            -- upvalues: v21 (copy), connection (ref), LocalPlayer (copy)
            if v21.Parent == LocalPlayer.Character then
                return
            end

            if connection ~= nil then
                connection:Disconnect()
            end

            for _, descendant in v21:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.LocalTransparencyModifier = 0
                end
            end
        end)
    end

    local v22 = gripFrame()

    if v22 == nil and typeof(p17.From) == "CFrame" then
        v22 = p17.From
    end

    local To = p17.To
    local fly2, Position, Rotation, v23, Seconds

    if v22 ~= nil and typeof(To) == "Vector3" and (To - v22.Position).Magnitude <= 160 then
        fly2 = fly
        Position = v22.Position
        Rotation = v22.Rotation

        v23 = function() -- line: 204
            -- upvalues: To (copy)
            return To
        end

        Seconds = p17.Seconds

        if type(Seconds) ~= "number" or not (Seconds > 0) or not (Seconds <= 3) then
            Seconds = 0.65
        end

        fly2(Position, Rotation, v23, Seconds, true)
    end

    Toast.Show({
        Lane = "Feed",
        Text = "Pass punched! All aboard!",
        Seconds = 3,
        Color = v1,
        StrokeColor = v2
    })
end

local function onTicketOut(p18) -- line: 211
    -- upvalues: Toast (copy), v1 (copy), v2 (copy), gripFrame (copy), fly (copy)
    local From = p18.From
    local v24 = gripFrame()
    local fly2, Rotation, v25, Seconds

    if v24 ~= nil and typeof(From) == "Vector3" and (v24.Position - From).Magnitude <= 160 then
        fly2 = fly
        Rotation = v24.Rotation

        v25 = function() -- line: 219
            -- upvalues: gripFrame (copy)
            local v26 = gripFrame()

            return if v26 ~= nil then v26.Position else nil
        end

        Seconds = p18.Seconds

        if type(Seconds) ~= "number" or not (Seconds > 0) or not (Seconds <= 3) then
            Seconds = 0.65
        end

        fly2(From, Rotation, v25, Seconds, false)
    end

    Toast.Show({
        Lane = "Feed",
        Text = "Boarding cancelled. Pass returned!",
        Seconds = 3,
        Color = v1,
        StrokeColor = v2
    })
end

function t1.Start() -- line: 231
    -- upvalues: TrainEvent (copy), v4 (ref), onTicketIn (copy), onTicketOut (copy)
    if not v4 then
        v4 = true
        TrainEvent.Travel.OnClientEvent:Connect(function(p19, p20) -- line: 236
            -- upvalues: onTicketIn (copy), onTicketOut (copy)
            local v27 = if typeof(p20) == "table" then p20 else {}

            if p19 == "TicketIn" then
                onTicketIn(v27)
            elseif p19 == "TicketOut" then
                onTicketOut(v27)
            end
        end)
    end
end

return t1
