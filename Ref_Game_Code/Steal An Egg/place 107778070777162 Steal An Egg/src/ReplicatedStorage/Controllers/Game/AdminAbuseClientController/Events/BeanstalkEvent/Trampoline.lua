-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local BeanstalkEvent = require(ReplicatedStorage.Data.BeanstalkEvent)
local Juice = require(script.Parent.Parent.ScrambleBoss.Juice)
local Remotes = require(ReplicatedStorage.Shared.Remotes)

require(ReplicatedStorage.Packages.Trove)

local LocalPlayer = Players.LocalPlayer
local Trampoline = ReplicatedStorage.Assets.BeanstalkEventAssets.Trampoline
local TrampolineJump = ReplicatedStorage.Assets.Sounds.BeanstalkEvent.TrampolineJump
local v1 = Color3.fromRGB(120, 255, 120)

local function stage() -- line: 44
    -- upvalues: BeanstalkEvent (copy), LocalPlayer (copy)
    local Attribute = LocalPlayer:GetAttribute(BeanstalkEvent.StageAttribute)

    return if typeof(Attribute) == "number" then Attribute else nil
end

local function widenWithSpeed(p1, p2) -- line: 50
    -- upvalues: RunService (copy), Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local FieldOfView = CurrentCamera.FieldOfView
    local Position = p1.Position
    local elapsed = os.clock()
    local connection

    connection = RunService.RenderStepped:Connect(function(p3) -- line: 56
        -- upvalues: p1 (copy), p2 (copy), CurrentCamera (copy), FieldOfView (copy), Position (ref), elapsed (copy), connection (ref)
        local Position2 = p1.Position
        local v2 = if p3 > 0 then (Position2 - Position).Magnitude / p3 else 0

        Position = Position2

        local v3 = os.clock() - elapsed
        local v4 = if v3 < p2 then FieldOfView + math.clamp(v2 / 600, 0, 1) * 30 else FieldOfView

        CurrentCamera.FieldOfView = CurrentCamera.FieldOfView + (v4 - CurrentCamera.FieldOfView) * math.min(p3 * 8, 1)

        if p2 + 0.6 <= v3 or p1.Parent == nil then
            CurrentCamera.FieldOfView = FieldOfView

            local connection2 = connection

            if connection2 ~= nil then
                connection2:Disconnect()
            end
        end
    end)
end

local function flingOnStageChange(p4, p5, p6) -- line: 76
    -- upvalues: RunService (copy), Workspace (copy), BeanstalkEvent (copy), Juice (copy), LocalPlayer (copy)
    local connection

    connection = LocalPlayer:GetAttributeChangedSignal(BeanstalkEvent.StageAttribute):Connect(function() -- line: 78
        -- upvalues: p4 (copy), p5 (copy), p6 (copy), connection (ref), RunService (copy), Workspace (copy), BeanstalkEvent (copy), Juice (copy), LocalPlayer (copy)
        local connection2 = connection

        if connection2 ~= nil then
            connection2:Disconnect()
        end

        local Attribute = LocalPlayer:GetAttribute(BeanstalkEvent.StageAttribute)

        if typeof(Attribute) ~= "number" then
            Attribute = nil
        end

        if Attribute ~= p5 + 1 then
            return
        end

        Juice.Throw(p4.Root, p4.Humanoid, p6, BeanstalkEvent.LaunchSeconds)

        local Root = p4.Root
        local LaunchSeconds = BeanstalkEvent.LaunchSeconds
        local CurrentCamera = Workspace.CurrentCamera
        local FieldOfView = CurrentCamera.FieldOfView
        local RootPosition = Root.Position
        local elapsed = os.clock()
        local connection3

        connection3 = RunService.RenderStepped:Connect(function(p7) -- line: 56
            -- upvalues: Root (copy), LaunchSeconds (copy), CurrentCamera (copy), FieldOfView (copy), RootPosition (ref), elapsed (copy), connection3 (ref)
            local RootPosition2 = Root.Position
            local v8 = if p7 > 0 then (RootPosition2 - RootPosition).Magnitude / p7 else 0

            RootPosition = RootPosition2

            local v9 = os.clock() - elapsed
            local v10 = if v9 < LaunchSeconds then FieldOfView + math.clamp(v8 / 600, 0, 1) * 30 else FieldOfView

            CurrentCamera.FieldOfView = CurrentCamera.FieldOfView + (v10 - CurrentCamera.FieldOfView) * math.min(p7 * 8, 1)

            if LaunchSeconds + 0.6 <= v9 or Root.Parent == nil then
                CurrentCamera.FieldOfView = FieldOfView

                local connection = connection3

                if connection ~= nil then
                    connection:Disconnect()
                end
            end
        end)
    end)
    task.delay(2, function() -- line: 88
        -- upvalues: connection (ref)
        local connection2 = connection

        if connection2 ~= nil and connection2.Connected then
            connection2:Disconnect()
        end
    end)
end

return {
    Show = function(p8, p9, p10, p11) -- Show | line: 100
        -- upvalues: RunService (copy), SoundService (copy), TweenService (copy), Workspace (copy), BeanstalkEvent (copy), Remotes (copy), LocalPlayer (copy), Trampoline (copy), TrampolineJump (copy), v1 (copy), flingOnStageChange (copy)
        local clone = p8:Clone(Trampoline)

        clone:PivotTo(p9.CFrame)

        for _, descendant in clone:GetDescendants() do
            if descendant:IsA("BasePart") then
                local Transparency = descendant.Transparency

                descendant.Transparency = 1
                TweenService:Create(descendant, TweenInfo.new(0.8), {
                    Transparency = Transparency
                }):Play()
            end
        end

        local Highlight = Instance.new("Highlight")

        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Highlight.FillColor = v1
        Highlight.FillTransparency = 1
        Highlight.OutlineColor = v1
        Highlight.Parent = clone
        clone.Parent = Workspace

        local PrimaryPart = clone.PrimaryPart
        local v14 = os.clock() + 0.8
        local v15 = false

        p8:Connect(RunService.Heartbeat, function() -- line: 122
            -- upvalues: p10 (copy), p11 (copy), PrimaryPart (copy), v14 (copy), v15 (ref), SoundService (copy), BeanstalkEvent (copy), Remotes (copy), LocalPlayer (copy), TrampolineJump (copy), flingOnStageChange (copy)
            local Attribute = LocalPlayer:GetAttribute(BeanstalkEvent.StageAttribute)

            if typeof(Attribute) ~= "number" then
                Attribute = nil
            end

            if not v15 and Attribute ~= nil and not (os.clock() < v14) then
                local v16 = PrimaryPart.CFrame:PointToObjectSpace(p11.Root.Position)
                local v17 = PrimaryPart.Size * 0.5

                if not (math.abs(v16.X) > v17.X) and not (math.abs(v16.Z) > v17.Z) and not (v16.Y < 0) and not (v16.Y > 6) then
                    v15 = true
                    p11.Root.AssemblyLinearVelocity = Vector3.new(0, 60, 0)
                    SoundService:PlayLocalSound(TrampolineJump)
                    flingOnStageChange(p11, Attribute, p10.Position + Vector3.new(0, 3, 0))
                    Remotes.BeanstalkEvent.AskLaunch:FireServer()
                    task.delay(2, function() -- line: 138
                        -- upvalues: v15 (ref)
                        v15 = false
                    end)
                end
            end
        end)
    end
}
