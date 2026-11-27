-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local t1 = {}

t1.__index = t1
t1.FADE_TAG = "OthersFish"
t1.FADED = 0.85
t1.CELL = 32
t1.MIN_SIZE = 2.5
t1.PUSH = 0.75
t1.MAX_CELLS = 400
t1.FOLDERS = { "Lobby", "Plots", "Stalls", "Props", "Aquariums", "AquariumDecor", "Cliffs" }

local function key(p1, p2) -- line: 16
    return (p1 + 32768) * 65536 + (p2 + 32768)
end

function t1.new() -- line: 20
    -- upvalues: Players (copy), t1 (copy)
    local self = setmetatable({}, t1)

    self.Player = Players.LocalPlayer
    self.Grid = {}
    self.Big = {}
    self.Parts = {}
    self.Models = {}
    self.Faded = {}
    self.Frame = 0
    self.Stamp = {}
    self.Corrections = 0

    return self
end

function t1:Solid(p4) -- line: 34
    if p4:IsA("BasePart") and p4.Anchored and not (p4.Transparency >= 0.5) and not p4:GetAttribute("CameraPass") then
        local Size = p4.Size

        return math.max(Size.X, Size.Y, Size.Z) >= self.MIN_SIZE and math.min(Size.X, Size.Y, Size.Z) >= 0.2
    end

    return false
end

function t1:Add(p6) -- line: 42
    if self.Parts[p6] then
        return
    end

    local CFrame = p6.CFrame
    local v3 = p6.Size / 2
    local v6 = math.abs(CFrame.RightVector.X) * v3.X + math.abs(CFrame.UpVector.X) * v3.Y + math.abs(CFrame.LookVector.X) * v3.Z
    local v9 = math.abs(CFrame.RightVector.Z) * v3.X + math.abs(CFrame.UpVector.Z) * v3.Y + math.abs(CFrame.LookVector.Z) * v3.Z
    local CFramePosition = CFrame.Position
    local v11 = math.floor((CFramePosition.X - v6) / self.CELL)
    local v13 = math.floor((CFramePosition.X + v6) / self.CELL)
    local v15 = math.floor((CFramePosition.Z - v9) / self.CELL)
    local v17 = math.floor((CFramePosition.Z + v9) / self.CELL)
    local t3 = {
        part = p6,
        cf = CFrame,
        half = v3
    }

    self.Parts[p6] = t3

    if (v13 - v11 + 1) * (v17 - v15 + 1) > self.MAX_CELLS then
        table.insert(self.Big, t3)
    else
        for i = v11, v13 do
            for j = v15, v17 do
                local v18 = (i + 32768) * 65536 + (j + 32768)
                local v19 = self.Grid[v18]

                if not v19 then
                    v19 = {}
                    self.Grid[v18] = v19
                end

                table.insert(v19, t3)
            end
        end
    end
end

function t1:Watch(p8) -- line: 71
    for _, descendant in ipairs(p8:GetDescendants()) do
        if self:Solid(descendant) then
            self:Add(descendant)
        end
    end

    p8.DescendantAdded:Connect(function(p9) -- line: 77
        -- upvalues: self (copy)
        if self:Solid(p9) then
            self:Add(p9)
        end
    end)
    p8.DescendantRemoving:Connect(function(p10) -- line: 82
        -- upvalues: self (copy)
        if self.Parts[p10] then
            self.Parts[p10] = nil
        end
    end)
end

function t1.RayBox(_, p12, p13, p14) -- line: 89
    local cf, half = p12.cf, p12.half
    local v20 = cf:PointToObjectSpace(p13)
    local v21 = cf:VectorToObjectSpace(p14)

    if math.abs(v20.X) <= half.X and math.abs(v20.Y) <= half.Y and math.abs(v20.Z) <= half.Z then
        return nil
    end

    local n1 = 0
    local n2 = 1

    for _, v22 in ipairs({ "X", "Y", "Z" }) do
        local v23 = v20[v22]
        local v24 = v21[v22]
        local v25 = half[v22]

        if math.abs(v24) < 1E-06 then
            if v25 < math.abs(v23) then
                return nil
            end
        else
            local v26 = (-v25 - v23) / v24
            local v27 = (v25 - v23) / v24

            if not (v27 < v26) then
                v27, v26 = v26, v27
            end

            if n1 < v27 then
                n1 = v27
            end

            if v26 < n2 then
                n2 = v26
            end

            if n2 < n1 then
                return nil
            end
        end
    end

    return n1
end

function t1:Cast(p16, p17) -- line: 122
    local v28 = p17 - p16
    local v29

    self.Frame += 1

    local Frame = self.Frame

    local function test(p18) -- line: 127
        -- upvalues: self (copy), p16 (copy), v28 (copy), v29 (ref), Frame (copy)
        if self.Stamp[p18] ~= Frame then
            self.Stamp[p18] = Frame

            if self.Parts[p18.part] == p18 then
                local v30 = self:RayBox(p18, p16, v28)

                if v30 and (not v29 or v30 < v29) then
                    v29 = v30
                end
            end
        end
    end

    local v32 = math.floor(math.min(p16.X, p17.X) / self.CELL)
    local v34 = math.floor(math.max(p16.X, p17.X) / self.CELL)
    local v36 = math.floor(math.min(p16.Z, p17.Z) / self.CELL)
    local v38 = math.floor(math.max(p16.Z, p17.Z) / self.CELL)
    local v39

    for i = v32, v34 do
        for j = v36, v38 do
            local v40 = self.Grid[(i + 32768) * 65536 + (j + 32768)]

            if v40 then
                for _, v42 in ipairs(v40) do
                    if self.Stamp[v42] ~= Frame then
                        self.Stamp[v42] = Frame

                        if self.Parts[v42.part] == v42 then
                            local v43 = self:RayBox(v42, p16, v28)

                            if v43 and (not v29 or v43 < v29) then
                                v39 = v43
                                v29 = v43
                            end
                        end
                    end
                end
            end
        end
    end

    for _, v44 in ipairs(self.Big) do
        if self.Stamp[v44] ~= Frame then
            self.Stamp[v44] = Frame

            if self.Parts[v44.part] == v44 then
                local v45 = self:RayBox(v44, p16, v28)

                if v45 and (not v29 or v45 < v29) then
                    v29 = v45
                end
            end
        end
    end

    return v29
end

function t1:Root() -- line: 158
    local Character = self.Player.Character

    return Character and Character:FindFirstChild("HumanoidRootPart")
end

function t1:Collide() -- line: 163
    local CurrentCamera = workspace.CurrentCamera

    if not CurrentCamera or CurrentCamera.CameraType ~= Enum.CameraType.Custom or not self:Root() then
        return
    end

    local FocusPosition = CurrentCamera.Focus.Position
    local CFrame = CurrentCamera.CFrame
    local v46 = CFrame.Position - FocusPosition
    local Magnitude = v46.Magnitude

    if not (Magnitude < 1) then
        local v47 = self:Cast(FocusPosition, CFrame.Position)

        if v47 then
            local v49 = math.max(0.5, v47 * Magnitude - self.PUSH)

            CurrentCamera.CFrame = CFrame.Rotation + (FocusPosition + v46.Unit * v49)
            self.Corrections += 1
        end
    end
end

function t1:Track(p22) -- line: 183
    if p22:IsA("Model") then
        self.Models[p22] = true
    end
end

function t1:SetFade(p24, p25) -- line: 190
    if self.Faded[p24] == true == p25 then
        return
    end

    local Faded = self.Faded
    local v50

    if p25 then
        Faded[p24] = true
        v50 = self.FADED
    else
        v50 = 0
        Faded[p24] = nil
    end

    for _, descendant in ipairs(p24:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.LocalTransparencyModifier = v50
        elseif descendant:IsA("BillboardGui") then
            descendant.Enabled = not p25
        end
    end
end

function t1.Blocking(_, p27, p28, p29) -- line: 205
    local GetBoundingBox = p27.GetBoundingBox
    local v51, v52, v53 = pcall(GetBoundingBox, p27)

    if not v51 then
        return false
    end

    local v54 = v53.Magnitude * 0.42 + 1
    local Position = v52.Position
    local v55 = p29 - p28
    local v56 = v55:Dot(v55)

    return (Position - (p28 + v55 * (if v56 > 0 then math.clamp((Position - p28):Dot(v55) / v56, 0, 1) else 0))).Magnitude < v54
end

function t1:Fade() -- line: 219
    local CurrentCamera = workspace.CurrentCamera
    local v59 = self:Root()

    if not CurrentCamera or not v59 then
        return
    end

    local CFramePosition = CurrentCamera.CFrame.Position
    local Position = v59.Position
    local v60 = (CFramePosition - Position).Magnitude + 300

    for v61 in pairs(self.Models) do
        if v61.Parent ~= nil then
            self:SetFade(v61, (v61:GetPivot().Position - Position).Magnitude < v60 and self:Blocking(v61, CFramePosition, Position))
        else
            self.Models[v61] = nil
            self.Faded[v61] = nil
        end
    end
end

function t1:Start() -- line: 239
    -- upvalues: RunService (copy), CollectionService (copy)
    task.spawn(function() -- line: 240
        -- upvalues: self (copy)
        local World = workspace:WaitForChild("World")

        for _, v62 in ipairs(self.FOLDERS) do
            task.spawn(function() -- line: 243
                -- upvalues: World (copy), v62 (copy), self (copy)
                local v63 = World:WaitForChild(v62, 30)

                if v63 then
                    self:Watch(v63)
                end
            end)
        end
    end)

    for _, v64 in ipairs(CollectionService:GetTagged(self.FADE_TAG)) do
        self:Track(v64)
    end

    CollectionService:GetInstanceAddedSignal(self.FADE_TAG):Connect(function(p32) -- line: 254
        -- upvalues: self (copy)
        self:Track(p32)
    end)
    CollectionService:GetInstanceRemovedSignal(self.FADE_TAG):Connect(function(p33) -- line: 257
        -- upvalues: self (copy)
        self.Models[p33] = nil
        self.Faded[p33] = nil
    end)

    local n3 = 0

    RunService:BindToRenderStep("CameraGuard", Enum.RenderPriority.Camera.Value + 1, function() -- line: 262
        -- upvalues: self (copy), n3 (ref)
        self:Collide()
        n3 += 1

        if n3 % 3 == 0 then
            self:Fade()
        end
    end)

    return self
end

return t1
