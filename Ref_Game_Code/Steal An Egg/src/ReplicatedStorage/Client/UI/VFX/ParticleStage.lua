-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Workspace = game:GetService("Workspace")
local t1 = {
    Anchored = true,
    CanCollide = false,
    CanQuery = false,
    CanTouch = false,
    CastShadow = false,
    Name = "ParticleStage",
    Transparency = 1
}
local t2 = {}

t2.__index = t2

local function sortedKeys(p1) -- line: 32
    local t3 = {}

    for v1 in p1 do
        table.insert(t3, v1)
    end

    table.sort(t3)

    return t3
end

local function write(p2, p3) -- line: 41
    local t4 = {}

    for v2 in p3 do
        table.insert(t4, v2)
    end

    table.sort(t4)

    for _, v3 in t4 do
        p2[v3] = p3[v3]
    end
end

function t2:Emitter(p5) -- line: 48
    local ParticleEmitter = Instance.new("ParticleEmitter")
    local t5 = {}

    for v4 in self do
        table.insert(t5, v4)
    end

    table.sort(t5)

    for _, v5 in t5 do
        ParticleEmitter[v5] = self[v5]
    end

    if p5 ~= nil then
        local t6 = {}

        for v6 in p5 do
            table.insert(t6, v6)
        end

        table.sort(t6)

        for _, v7 in t6 do
            ParticleEmitter[v7] = p5[v7]
        end
    end

    return ParticleEmitter
end

function t2:Scale(p7) -- line: 57
    -- upvalues: t2 (copy)
    local t7 = {
        Acceleration = self.Acceleration * p7,
        Size = t2.ScaleSequence(self.Size, p7),
        Speed = NumberRange.new(self.Speed.Min * p7, self.Speed.Max * p7),
        ZOffset = self.ZOffset * p7
    }
    local t8 = {}

    for v8 in t7 do
        table.insert(t8, v8)
    end

    table.sort(t8)

    for _, v9 in t8 do
        self[v9] = t7[v9]
    end
end

function t2:ScaleSequence(p9) -- line: 66
    local v10 = table.create(#self.Keypoints)

    for v11, v12 in self.Keypoints do
        v10[v11] = NumberSequenceKeypoint.new(v12.Time, v12.Value * p9, v12.Envelope * p9)
    end

    return NumberSequence.new(v10)
end

function t2.QualityBudget() -- line: 74
    local Value = UserSettings().GameSettings.SavedQualityLevel.Value

    if Value <= 0 then
        return 1
    end

    return (Value / 10) ^ 1.25
end

function t2.SetEnabled(p10, p11) -- line: 82
    for _, v13 in p10 do
        v13.Enabled = p11
    end
end

function t2.new(p12, p13) -- line: 88
    -- upvalues: t1 (copy), t2 (copy)
    local self = setmetatable({}, t2)

    self.depth = p12
    self.thickness = p13
    self.watchers = {}

    local Part = Instance.new("Part")
    local t10 = {}

    for v15 in t1 do
        table.insert(t10, v15)
    end

    table.sort(t10)

    for _, v16 in t10 do
        Part[v16] = t1[v16]
    end

    self.Part = Part
    self:Follow()

    return self
end

function t2:Fit() -- line: 100
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil then
        return
    end

    local CFrame = CurrentCamera.CFrame
    local LookVector = CFrame.LookVector
    local v17 = self.depth + self.thickness * 0.5
    local ViewportSize = CurrentCamera.ViewportSize

    local function onFarPlane(p15, p16) -- line: 110
        -- upvalues: CurrentCamera (copy), CFrame (copy), LookVector (copy), v17 (copy)
        local Direction = CurrentCamera:ViewportPointToRay(p15, p16).Direction

        return CFrame.Position + Direction * (v17 / Direction:Dot(LookVector))
    end

    local Direction = CurrentCamera:ViewportPointToRay(0, 0).Direction
    local v18 = CFrame.Position + Direction * (v17 / Direction:Dot(LookVector))
    local Direction2 = CurrentCamera:ViewportPointToRay(ViewportSize.X, ViewportSize.Y).Direction
    local v19 = CFrame.Position + Direction2 * (v17 / Direction2:Dot(LookVector))
    local v20 = v19 - v18
    local v21 = (v18 + v19) * 0.5 - LookVector * (self.thickness * 0.5)

    self.Part.Size = Vector3.new(math.abs((v20:Dot(CFrame.RightVector))), math.abs((v20:Dot(CFrame.UpVector))), self.thickness)
    self.Part.CFrame = CFrame.Rotation + v21
end

function t2:Follow() -- line: 124
    -- upvalues: Workspace (copy)
    for _, v26 in self.watchers do
        v26:Disconnect()
    end

    table.clear(self.watchers)

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil then
        return
    end

    self:Fit()
    self.Part.Parent = CurrentCamera

    local function refit() -- line: 135
        -- upvalues: self (copy)
        self:Fit()
    end

    table.insert(self.watchers, CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(refit))
    table.insert(self.watchers, CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(refit))
    table.insert(self.watchers, CurrentCamera:GetPropertyChangedSignal("FieldOfView"):Connect(refit))
    table.insert(self.watchers, Workspace:GetPropertyChangedSignal("CurrentCamera"):Once(function() -- line: 141
        -- upvalues: self (copy)
        self:Follow()
    end))
end

function t2:Adopt(p19) -- line: 146
    p19.Parent = self.Part
end

function t2:Dispose() -- line: 150
    for _, v28 in self.watchers do
        v28:Disconnect()
    end

    table.clear(self.watchers)
    self.Part:Destroy()
end

return table.freeze(t2)
