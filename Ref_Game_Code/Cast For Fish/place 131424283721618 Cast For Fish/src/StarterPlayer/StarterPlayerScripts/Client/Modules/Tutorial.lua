-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local TutorialSteps = require(Shared.TutorialSteps)
local t1 = {}
local PlotFrame = require(Shared:WaitForChild("PlotFrame"))
local UIKit = require(script.Parent.UIKit)
local DataClient = require(script.Parent.DataClient)
local HUD = require(script.Parent.HUD)
local t2 = {
    IsCasting = nil,
    IsTraining = nil,
    StopTraining = nil
}
local LocalPlayer = Players.LocalPlayer
local CurrentCamera, new = workspace.CurrentCamera, Vector3.new
local v1 = Color3.fromRGB(255, 221, 40)
local v2 = Color3.fromRGB(255, 170, 20)
local Part, BillboardGui, ScreenGui, v3, Folder
local t3 = {}

t3.__index = t3
t3.AHEAD = 3.2
t3.MIN_DISTANCE = 4

function t3.new(p1) -- line: 38
    -- upvalues: v1 (copy), t3 (copy)
    local self = setmetatable({}, t3)
    local Model = Instance.new("Model")

    Model.Name = "TutorialFloorArrow"

    local function piece(p2, p3, p4) -- line: 42
        -- upvalues: Model (copy), v1 (copy)
        local v5 = Instance.new(p2)

        v5.Anchored = true
        v5.CanCollide = false
        v5.CanQuery = false
        v5.CanTouch = false
        v5.CastShadow = false
        v5.Material = Enum.Material.Neon
        v5.Color = v1
        v5.Size = p3
        v5.Transparency = 1
        v5:SetAttribute("NoStuds", true)
        v5.Parent = Model

        return {
            part = v5,
            offset = p4
        }
    end

    self.Pieces = {
        piece("Part", Vector3.new(0.9, 0.12, 2.4), CFrame.new(0, 0, 0.6)),
        piece("WedgePart", Vector3.new(0.12, 1.4, 1.6), CFrame.new(-0.7, 0, -1.4) * CFrame.Angles(0, 0, 1.5707963267948966)),
        (piece("WedgePart", Vector3.new(0.12, 1.4, 1.6), CFrame.new(0.7, 0, -1.4) * CFrame.Angles(0, 0, -1.5707963267948966)))
    }
    Model.Parent = p1
    self.Model = Model
    self.Visible = false

    return self
end

function t3:Hide() -- line: 68
    if self.Visible then
        self.Visible = false

        for _, v6 in ipairs(self.Pieces) do
            v6.part.Transparency = 1
        end
    end
end

function t3:Point(p7, p8, p9) -- line: 78
    -- upvalues: new (copy)
    local v9 = new(p8.X - p7.X, 0, p8.Z - p7.Z)

    if v9.Magnitude < self.MIN_DISTANCE then
        self:Hide()
    else
        local Unit = v9.Unit
        local v11 = math.sin(p9 * 5) * 0.15 + 0.25
        local v15 = new(p7.X, p8.Y + 0.16, p7.Z) + Unit * (self.AHEAD + math.sin(p9 * 5) * 0.35)
        local v16 = CFrame.lookAt(v15, v15 + Unit)

        for _, v17 in ipairs(self.Pieces) do
            v17.part.CFrame = v16 * v17.offset
            v17.part.Transparency = v11
        end

        self.Visible = true
    end
end

local v18
local t5 = {}
local v19 = false
local n1 = 0
local v20, v21
local t6 = {}

t6.__index = t6
t6.LEVELS = 2
t6.MIN_SECONDS = 3

function t6.new(p10) -- line: 106
    -- upvalues: TutorialSteps (copy), t6 (copy)
    return (setmetatable({
        Seconds = 0,
        Level = math.max(TutorialSteps.TRAIN_TO_LEVEL, p10 + t6.LEVELS),
        Last = os.clock()
    }, t6))
end

function t6.Tick(p11, p12) -- line: 110
    local elapsed = os.clock()

    if p12 then
        p11.Seconds += elapsed - p11.Last
    end

    p11.Last = elapsed
end

function t6.Done(p13, p14) -- line: 118
    if p13.Level <= p14 then
        return p13.Seconds >= p13.MIN_SECONDS
    end

    return false
end

t1[1] = nil

local elapsed
local v23 = false

local function plotGate() -- line: 128
    -- upvalues: PlotFrame (copy), LocalPlayer (copy)
    local PlotId = LocalPlayer:GetAttribute("PlotId")

    if type(PlotId) == "number" then
        return PlotFrame.ById(PlotId)
    end

    return nil
end

local function rootPart() -- line: 136
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character

    return Character and Character:FindFirstChild("HumanoidRootPart")
end

local function count(p15) -- line: 141
    local n2 = 0

    for _ in pairs(p15 or {}) do
        n2 += 1
    end

    return n2
end

local function worldTarget(p16) -- line: 150
    -- upvalues: PlotFrame (copy), UIKit (copy), t2 (copy), LocalPlayer (copy)
    local Character = LocalPlayer.Character

    if Character then
        Character:FindFirstChild("HumanoidRootPart")
    end

    local PlotId = LocalPlayer:GetAttribute("PlotId")
    local v24 = if type(PlotId) == "number" then PlotFrame.ById(PlotId) else nil

    if p16 == "dock" or p16 == "recast" then
        return (Vector3.new(0, 0, 2))
    end

    if p16 == "place" and v24 then
        return v24 * Vector3.new(0, 0, 9)
    end

    if (p16 == "circle" or p16 == "train") and v24 then
        return if p16 ~= "train" or not t2.IsTraining or not t2.IsTraining() then v24 * Vector3.new(10, 0, -12) else nil
    end

    return if p16 == "bait" and not (UIKit.Windows.BaitShop and UIKit.Windows.BaitShop.IsOpen) then Vector3.new(74, 0, 46) else nil
end

local function complete(p17) -- line: 172
    -- upvalues: TutorialSteps (copy), DataClient (copy), t2 (copy), v19 (ref), t1 (copy)
    local Value = DataClient.Value

    if not Value then
        return false
    end

    if p17 == "dock" then
        return t2.IsCasting ~= nil and t2.IsCasting() ~= "idle"
    end

    if p17 == "circle" then
        return t2.IsTraining ~= nil and (t2.IsTraining())
    end

    if p17 == "recast" then
        return v19
    end

    if p17 == "train" and t1[1] and not t1[1]:Done(Value.Level or 1) then
        return false
    end

    return TutorialSteps.DataAllows(p17, Value)
end

local function build() -- line: 190
    -- upvalues: UIKit (copy), LocalPlayer (copy), v1 (copy), Part (ref), BillboardGui (ref), ScreenGui (ref), v3 (ref), Folder (ref), t3 (copy), v18 (ref), t5 (copy)
    Part = Instance.new("Part")
    Part.Name = "TutorialArrow"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1
    Part.Size = Vector3.new(1, 1, 1)
    Part:SetAttribute("NoStuds", true)
    BillboardGui = Instance.new("BillboardGui")
    BillboardGui.Name = "Arrow"

    local BillboardGui2 = BillboardGui

    BillboardGui2.Size = UDim2.fromScale(5, 5)
    BillboardGui.AlwaysOnTop = false
    BillboardGui.LightInfluence = 0
    BillboardGui.MaxDistance = 600
    BillboardGui.Enabled = false
    UIKit.icon(BillboardGui, "Arrow", {
        Size = UDim2.fromScale(1, 1)
    })
    BillboardGui.Adornee = Part

    local Part2 = Part

    Part2.Parent = workspace

    local BillboardGui3 = BillboardGui

    BillboardGui3.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TutorialArrow"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 30

    local ScreenGui2 = ScreenGui

    ScreenGui2.Parent = LocalPlayer:WaitForChild("PlayerGui")
    v3 = UIKit.icon(ScreenGui, "Arrow", {
        Size = UDim2.fromOffset(80, 80),
        AnchorPoint = Vector2.new(0.5, 1)
    })
    v3.Visible = false
    Folder = Instance.new("Folder")
    Folder.Name = "TutorialTrail"

    local Folder2 = Folder

    Folder2.Parent = workspace
    v18 = t3.new(Folder)

    for i = 1, 12 do
        local t8 = {}

        for j = 1, 2 do
            local WedgePart = Instance.new("WedgePart")

            WedgePart.Name = "Chevron"
            WedgePart.Anchored = true
            WedgePart.CanCollide = false
            WedgePart.CanQuery = false
            WedgePart.CanTouch = false
            WedgePart.CastShadow = false
            WedgePart.Material = Enum.Material.Neon
            WedgePart.Color = v1
            WedgePart.Size = Vector3.new(0.12, 1.3, 2.2)
            WedgePart.Transparency = 1
            WedgePart:SetAttribute("NoStuds", true)
            WedgePart.Parent = Folder
            t8[j] = WedgePart
        end

        t5[i] = t8
    end
end

local function hideTrail() -- line: 250
    -- upvalues: t5 (copy)
    for _, v25 in ipairs(t5) do
        v25[1].Transparency = 1
        v25[2].Transparency = 1
    end
end

local function hideAll() -- line: 257
    -- upvalues: BillboardGui (ref), v3 (ref), v18 (ref), t5 (copy)
    BillboardGui.Enabled = false
    v3.Visible = false

    for _, v26 in ipairs(t5) do
        v26[1].Transparency = 1
        v26[2].Transparency = 1
    end

    v18:Hide()
end

local v27 = CFrame.Angles(0, 0, 1.5707963267948966)
local v28 = CFrame.Angles(0, 0, -1.5707963267948966)

local function drawTrail(p18, p19, p20) -- line: 267
    -- upvalues: new (copy), v1 (copy), v2 (copy), t5 (copy), v27 (copy), v28 (copy)
    local v31 = new(p19.X - p18.X, 0, p19.Z - p18.Z)
    local Magnitude = v31.Magnitude

    if Magnitude < 9 then
        for _, v32 in ipairs(t5) do
            v32[1].Transparency = 1
            v32[2].Transparency = 1
        end
    else
        local v33 = v31 / Magnitude
        local v34 = Magnitude - 3
        local v35 = p20 * 9 % 4.5
        local v36 = p19.Y + 0.14

        for v37, v38 in ipairs(t5) do
            local v39 = 3.5 + (v37 - 1) * 4.5 + v35

            if v34 < v39 then
                v38[1].Transparency = 1
                v38[2].Transparency = 1
            else
                local v40 = new(p18.X, v36, p18.Z) + v33 * v39
                local v41 = CFrame.lookAt(v40, v40 + v33)
                local v45 = 1 - math.clamp((v39 - 3.5) / 3, 0, 1) * math.clamp((math.min(v34, 57.5) - v39) / 4, 0, 1) * 0.85

                v38[1].CFrame = v41 * CFrame.new(-0.65, 0, 0) * v27
                v38[2].CFrame = v41 * CFrame.new(0.65, 0, 0) * v28
                v38[1].Transparency = v45
                v38[2].Transparency = v45

                local v46 = v1:Lerp(v2, v37 % 2)

                v38[1].Color = v46
                v38[2].Color = v46
            end
        end
    end
end

local function stepButton(p21) -- line: 304
    -- upvalues: RunService (copy), UIKit (copy), LocalPlayer (copy), v23 (ref)
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")

    if p21 == "place" then
        local Held = PlayerGui and PlayerGui:FindFirstChild("Held")
        local Panel = Held and Held:FindFirstChild("Panel")

        if Panel then
            local Place = Panel:FindFirstChild("Place")

            if Panel.Visible and Place then
                return Place, "left"
            end
        end
    elseif p21 == "bait" then
        local BaitShop = UIKit.Windows.BaitShop

        if not (BaitShop and BaitShop.IsOpen) then
            v23 = false

            return nil
        end

        if not v23 then
            v23 = true
            task.spawn(function() -- line: 321
                -- upvalues: BaitShop (copy), RunService (copy)
                local BaitShop2 = require(script.Parent.BaitShop)
                local elapsed = os.clock()

                while BaitShop.IsOpen and os.clock() - elapsed < 0.6 do
                    BaitShop2.ScrollTo("bread")
                    RunService.Heartbeat:Wait()
                end
            end)
        end

        local Cards = BaitShop.Content:FindFirstChild("Cards")
        local bread = Cards and Cards:FindFirstChild("bread")
        local Action = bread and bread:FindFirstChild("Action")

        if Action then
            return Action, "top"
        end
    end

    return nil
end

function t2.Step() -- line: 341
    -- upvalues: TutorialSteps (copy), DataClient (copy)
    return DataClient.Get("TutorialStep") or TutorialSteps.DONE
end

function t2.Active() -- line: 345
    -- upvalues: TutorialSteps (copy), DataClient (copy), t2 (copy)
    return DataClient.IsReady() and t2.Step() < TutorialSteps.DONE
end

function t2.Before(p22) -- line: 350
    -- upvalues: TutorialSteps (copy), t2 (copy)
    local v47 = TutorialSteps.IndexOf[p22]

    return v47 ~= nil and t2.Active() and t2.Step() < v47
end

local function update() -- line: 355
    -- upvalues: Remotes (copy), TutorialSteps (copy), UIKit (copy), DataClient (copy), HUD (copy), t2 (copy), LocalPlayer (copy), CurrentCamera (copy), new (copy), Part (ref), BillboardGui (ref), v3 (ref), v18 (ref), t5 (copy), v19 (ref), n1 (ref), v20 (ref), v21 (ref), t6 (copy), t1 (copy), elapsed (ref), worldTarget (copy), complete (copy), drawTrail (copy), stepButton (copy)
    if not DataClient.IsReady() then
        return
    end

    local v48 = t2.Active()

    if v48 ~= v21 then
        v21 = v48
        HUD.SetMode(HUD.GetMode())
    end

    local v49 = t2.Step()
    local v50 = TutorialSteps.List[v49]

    if v50 then
        if v20 ~= v49 then
            v20 = v49
            v19 = false
            UIKit.sound("TutorialStep")
            t1[1] = if v50.id == "train" then t6.new(DataClient.Get("Level") or 1) else nil
        end

        if t1[1] then
            t1[1]:Tick(t2.IsTraining ~= nil and t2.IsTraining() == true)
        end

        if v50.id == "recast" and t2.IsCasting and t2.IsCasting() == "busy" then
            v19 = true
        end

        if complete(v50.id) and os.clock() - n1 > 0.3 then
            n1 = os.clock()
            Remotes.TutorialAdvance:FireServer(v49)
        end

        if HUD.GetMode() == "cutscene" then
            BillboardGui.Enabled = false
            v3.Visible = false

            for _, v53 in ipairs(t5) do
                v53[1].Transparency = 1
                v53[2].Transparency = 1
            end

            v18:Hide()
            HUD.SetInstruction(nil)
        else
            local text = v50.text

            if v50.id == "train" and t1[1] then
                text = "Train to Level " .. t1[1].Level .. "  (" .. math.min(DataClient.Get("Level") or 1, t1[1].Level) .. "/" .. t1[1].Level .. ")"
            end

            HUD.SetInstruction(text)

            local elapsed = os.clock()
            local v57 = math.abs((math.sin(elapsed * 4.2)))
            local Character = LocalPlayer.Character
            local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
            local v58, v59 = stepButton(v50.id)
            local v60 = if v58 or UIKit.anyWindowOpen() then nil else worldTarget(v50.id)

            if not v60 or not HumanoidRootPart then
                BillboardGui.Enabled = false

                for _, v61 in ipairs(t5) do
                    v61[1].Transparency = 1
                    v61[2].Transparency = 1
                end

                v18:Hide()
            else
                local v63 = math.clamp((CurrentCamera.CFrame.Position - v60).Magnitude * 0.085, 1.6, 13)

                BillboardGui.Size = UDim2.fromScale(v63, v63)
                Part.CFrame = CFrame.new(v60 + new(0, v63 * 0.6 + 5 + v57 * v63 * 0.3, 0))
                BillboardGui.Enabled = true

                if UIKit.anyWindowOpen() or HUD.GetMode() ~= "normal" then
                    for _, v65 in ipairs(t5) do
                        v65[1].Transparency = 1
                        v65[2].Transparency = 1
                    end

                    v18:Hide()
                else
                    drawTrail(HumanoidRootPart.Position, v60, elapsed)
                    v18:Point(HumanoidRootPart.Position, v60, elapsed)
                end
            end

            if v58 then
                local AbsolutePosition, AbsoluteSize = v58.AbsolutePosition, v58.AbsoluteSize
                local GuiInset = game:GetService("GuiService"):GetGuiInset()
                local v67 = AbsoluteSize.Y * 1.4

                v3.Size = UDim2.fromOffset(v67, v67)

                if v59 == "left" then
                    v3.AnchorPoint = Vector2.new(1, 0.5)
                    v3.Rotation = -90
                    v3.Position = UDim2.fromOffset(AbsolutePosition.X - 6 - v57 * v67 * 0.3, AbsolutePosition.Y + GuiInset.Y + AbsoluteSize.Y / 2)
                else
                    v3.AnchorPoint = Vector2.new(0.5, 1)
                    v3.Rotation = 0
                    v3.Position = UDim2.fromOffset(AbsolutePosition.X + AbsoluteSize.X / 2, AbsolutePosition.Y + GuiInset.Y - 4 - v57 * v67 * 0.3)
                end

                v3.Visible = true
            else
                v3.Visible = false
            end
        end
    else
        if v20 ~= nil then
            v20 = nil
            BillboardGui.Enabled = false
            v3.Visible = false

            for _, v73 in ipairs(t5) do
                v73[1].Transparency = 1
                v73[2].Transparency = 1
            end

            v18:Hide()
            HUD.SetInstruction(nil)
            elapsed = os.clock()
        end

        if elapsed and HUD.GetMode() == "normal" and (not t2.IsCasting or t2.IsCasting() == "idle") and os.clock() - elapsed > 0.4 then
            elapsed = nil
            require(script.Parent.TutorialComplete).new():Play()
        end
    end
end

function t2.Init() -- line: 457
    -- upvalues: RunService (copy), build (copy), update (copy)
    build()
    RunService.RenderStepped:Connect(function() -- line: 459
        -- upvalues: update (copy)
        local ok, result = pcall(update)

        if not ok then
            warn("[Tutorial] " .. tostring(result))
        end
    end)
end

return t2
