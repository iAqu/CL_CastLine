-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local PenBoard = PlayerGui:WaitForChild("HUD"):WaitForChild("PenBoard")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Format = require(Modules:WaitForChild("Format"))
local FishDisplay = require(Modules:WaitForChild("FishDisplay"))
local RarityDisplay = require(Modules:WaitForChild("RarityDisplay"))
local MimicConfig = require(Modules:WaitForChild("MimicConfig"))
local Plots = workspace:WaitForChild("Plots")
local _ = {
    HEIGHT = 4.2,
    SLOT = 0.9,
    ENDS = 0.3,
    OUT = 7,
    LIFT = 0.25,
    TILT = 50,
    MAX_W = 0.92
}
local _ = {
    AMP = 0.18,
    PERIOD = 5.5,
    ROLL = 1.2
}
local _ = {
    IN = 0.35,
    OUT = 0.2,
    PUNCH = 1.18,
    PUNCH_TIME = 0.3
}
local _ = {
    PEAK = 1.15,
    UP = 0.12,
    SETTLE = 0.35
}
local Slot = PenBoard.Panel.List.Slot
local Folder = Instance.new("Folder")

Folder.Name = "PenBoards"
Folder.Parent = workspace

local t1 = {}

local function tween(p1, p2, p3, p4, p5) -- line: 66
    -- upvalues: TweenService (copy)
    local tween = TweenService:Create(p1, TweenInfo.new(p2, p3, p4), p5)

    tween:Play()

    return tween
end

local function boardOf(p6) -- line: 72
    -- upvalues: PlayerGui (copy), PenBoard (copy), Folder (copy), t1 (copy)
    local v1 = t1[p6]

    if v1 then
        return v1
    end

    local Part = Instance.new("Part")

    Part.Name = "PenBoard_" .. p6.Name
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = Vector3.new(0.05, 0.05, 0.05)
    Part.Parent = Folder

    local clone = PenBoard:Clone()

    clone.Name = "PenBoard_" .. p6.Name
    clone.Adornee = Part
    clone.Enabled = false
    clone.Parent = PlayerGui

    local List = clone.Panel.List

    List.Slot:Destroy()

    local Position = p6:GetPivot().Position
    local t2 = {
        count = 0,
        w = 0,
        h = 0,
        part = Part,
        gui = clone,
        list = List,
        slots = {},
        phase = (Position.X * 0.37 + Position.Z * 0.61) % 6.283185307179586
    }

    t1[p6] = t2

    return t2
end

local t3 = {
    GOLD_TOP = Color3.fromRGB(255, 222, 110),
    GOLD_BOTTOM = Color3.fromRGB(205, 125, 20),
    EDGE = Color3.fromRGB(255, 244, 190),
    RED = Color3.fromRGB(255, 40, 40),
    RED_EDGE = Color3.fromRGB(70, 0, 5),
    FONT = Font.new("rbxasset://fonts/families/Bangers.json")
}

local function wrDress(p7, p8) -- line: 101
    -- upvalues: TweenService (copy), t3 (copy)
    local WRGlow = p7:FindFirstChild("WRGlow")

    if p8 then
        if not WRGlow then
            local Frame = Instance.new("Frame")

            Frame.Name = "WRGlow"
            Frame.AnchorPoint = Vector2.new(0.5, 0.5)
            Frame.Position = UDim2.fromScale(0.5, 0.5)
            Frame.Size = UDim2.fromScale(1.04, 0.98)
            Frame.BackgroundColor3 = Color3.new(1, 1, 1)
            Frame.BackgroundTransparency = 0.1
            Frame.ZIndex = 1

            local UIGradient = Instance.new("UIGradient")

            UIGradient.Rotation = 90
            UIGradient.Color = ColorSequence.new(t3.GOLD_TOP, t3.GOLD_BOTTOM)
            UIGradient.Parent = Frame

            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = UDim.new(0.22, 0)
            UICorner.Parent = Frame

            local UIStroke = Instance.new("UIStroke")

            UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
            UIStroke.Thickness = 0.05
            UIStroke.Color = t3.EDGE
            UIStroke.Parent = Frame
            Frame.Parent = p7

            local TextLabel = Instance.new("TextLabel")

            TextLabel.Name = "WRTag"
            TextLabel.BackgroundTransparency = 1
            TextLabel.Text = "#1"
            TextLabel.FontFace = t3.FONT
            TextLabel.TextScaled = true
            TextLabel.TextColor3 = t3.RED
            TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            TextLabel.Position = UDim2.fromScale(0.22, 0.55)
            TextLabel.Size = UDim2.fromScale(0.8, 0.38)
            TextLabel.Rotation = -14
            TextLabel.ZIndex = 8

            local UIStroke2 = Instance.new("UIStroke")

            UIStroke2.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
            UIStroke2.Thickness = 0.1
            UIStroke2.Color = t3.RED_EDGE
            UIStroke2.Parent = TextLabel

            local UIScale = Instance.new("UIScale")

            UIScale.Scale = 0
            UIScale.Parent = TextLabel
            TextLabel.Parent = p7

            local Back = Enum.EasingStyle.Back
            local Out = Enum.EasingDirection.Out
            local t4 = {
                Scale = 1
            }

            TweenService:Create(UIScale, TweenInfo.new(0.35, Back, Out), t4):Play()
        end
    else
        for _, v2 in ipairs({ "WRGlow", "WRTag" }) do
            local v3 = p7:FindFirstChild(v2)

            if v3 then
                v3:Destroy()
            end
        end
    end
end

local function dress(p9, p10, p11) -- line: 157
    -- upvalues: Format (copy), FishDisplay (copy), RarityDisplay (copy), MimicConfig (copy), wrDress (copy)
    wrDress(p9, p10.w == 1)

    local v4 = FishDisplay[p10.n]
    local v5, v6

    if v4 then
        local shown = v4.shown

        if shown then
            v5 = shown
            v6 = true
        else
            local rarity = v4.rarity

            if rarity then
                v5 = rarity
                v6 = true
            else
                v6 = false
            end
        end
    else
        v6 = false
    end

    if not v6 then
        v5 = "Common"
    end

    local v7 = RarityDisplay[v5] or RarityDisplay.Common
    local Square = p9.Square

    Square.Image = v7.square
    Square.ImageColor3 = v7.squareTint or Color3.new(1, 1, 1)

    local offset, size = RarityDisplay.squareRect.offset, RarityDisplay.squareRect.size

    Square.ImageRectOffset = offset
    Square.ImageRectSize = size

    if p10.n == MimicConfig.NAME then
        Square.Icon.Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150"):format(p11)
    else
        Square.Icon.Image = v4 and v4.icon or ""
    end

    local v8 = p10.b and "+" .. p10.b .. "%" or Format.money(p10.r or 0) .. "/s"
    local v9 = p9.Rate.Text ~= v8

    p9.Rate.Text = v8

    return v9
end

local function refresh(p12) -- line: 177
    -- upvalues: TweenService (copy), HttpService (copy), Slot (copy), dress (copy)
    local JSONDecode = HttpService.JSONDecode
    local PenBoard = p12.owner and p12.owner:GetAttribute("PenBoard") or "[]"
    local ok, result = pcall(JSONDecode, HttpService, PenBoard)

    if not ok or type(result) ~= "table" then
        result = {}
    end

    local n1 = 0

    for _, v10 in ipairs(result) do
        if not v10.b then
            n1 += v10.r or 0
        end
    end

    for _, v11 in ipairs(result) do
        v11.v = v11.b and n1 * v11.b / 100 or v11.r or 0
    end

    table.sort(result, function(p13, p14) -- line: 188
        if p13.v ~= p14.v then
            return p13.v < p14.v
        end

        return tostring(p13.i) < tostring(p14.i)
    end)

    local t5 = {}

    for v13, v14 in ipairs(result) do
        local v15 = tostring(v14.i)

        t5[v15] = true

        local v16 = p12.slots[v15]

        if v16 then
            if dress(v16, v14, p12.owner.UserId) then
                v16.Rate.Pop.Scale = 1.18

                local Pop = v16.Rate.Pop
                local Back = Enum.EasingStyle.Back
                local Out = Enum.EasingDirection.Out
                local t6 = {
                    Scale = 1
                }

                TweenService:Create(Pop, TweenInfo.new(0.3, Back, Out), t6):Play()
            end
        else
            v16 = Slot:Clone()
            v16.Name = v15
            v16.Visible = true
            dress(v16, v14, p12.owner.UserId)
            v16.Pop.Scale = 0
            v16.Parent = p12.list

            local Pop = v16.Pop
            local Back = Enum.EasingStyle.Back
            local Out = Enum.EasingDirection.Out
            local t7 = {
                Scale = 1
            }

            TweenService:Create(Pop, TweenInfo.new(0.35, Back, Out), t7):Play()
            p12.slots[v15] = v16
        end

        v16.LayoutOrder = v13
    end

    for v17, v18 in pairs(p12.slots) do
        if not t5[v17] then
            p12.slots[v17] = nil

            local Pop = v18.Pop
            local Back = Enum.EasingStyle.Back
            local In = Enum.EasingDirection.In
            local t8 = {
                Scale = 0
            }
            local tween = TweenService:Create(Pop, TweenInfo.new(0.2, Back, In), t8)

            tween:Play()
            tween.Completed:Once(function() -- line: 217
                -- upvalues: v18 (copy)
                v18:Destroy()
            end)
        end
    end

    p12.count = #result
end

local function clear(p15) -- line: 225
    for v19, v20 in pairs(p15.slots) do
        v20:Destroy()
        p15.slots[v19] = nil
    end

    p15.count = 0
end

local function popFactor(p16, p17) -- line: 231
    -- upvalues: TweenService (copy)
    if not p16.popT0 then
        return 1
    end

    local v21 = p17 - p16.popT0

    if v21 < 0.12 then
        return 1 + 0.1499999999999999 * TweenService:GetValue(v21 / 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    end

    if v21 < 0.47 then
        return 1.15 + -0.1499999999999999 * TweenService:GetValue((v21 - 0.12) / 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end

    p16.popT0 = nil

    return 1
end

local function scan() -- line: 245
    -- upvalues: Players (copy), Plots (copy), boardOf (copy), refresh (copy)
    for _, child in ipairs(Plots:GetChildren()) do
        local v22 = boardOf(child)
        local Aquarium = child:FindFirstChild("Aquarium")

        v22.glass = Aquarium and Aquarium:FindFirstChild("GlassFront")

        local PlayerByUserId = Players:GetPlayerByUserId(child:GetAttribute("OwnerUserId") or 0)

        if PlayerByUserId ~= v22.owner then
            if v22.conn then
                v22.conn:Disconnect()
            end

            for v23, v24 in pairs(v22.slots) do
                v24:Destroy()
                v22.slots[v23] = nil
            end

            v22.count = 0
            v22.owner = PlayerByUserId
            v22.conn = nil

            if PlayerByUserId then
                v22.conn = PlayerByUserId:GetAttributeChangedSignal("PenBoard"):Connect(function() -- line: 256
                    -- upvalues: v22 (copy), refresh (copy)
                    refresh(v22)
                end)
                refresh(v22)
            end
        end
    end
end

local v25 = CFrame.Angles(0.8726646259971648, 0, 0)
local n2 = 1

local function watchPlot(p18) -- line: 266
    -- upvalues: boardOf (copy), scan (copy)
    p18.ChildAdded:Connect(function(p19) -- line: 267
        -- upvalues: p18 (copy), boardOf (copy), scan (copy)
        if p19.Name == "Aquarium" then
            local function arrived() -- line: 269
                -- upvalues: p19 (copy), p18 (copy), boardOf (copy), scan (copy)
                scan()

                if p19:GetAttribute("Popped") then
                    boardOf(p18).popT0 = os.clock()
                end
            end

            local GlassFront = p19:FindFirstChild("GlassFront")
            local Popped

            if GlassFront then
                scan()
                Popped = p19:GetAttribute("Popped")
            else
                task.spawn(function() -- line: 276
                    -- upvalues: p19 (copy), p18 (copy), boardOf (copy), scan (copy)
                    if p19:WaitForChild("GlassFront", 5) then
                        scan()

                        if p19:GetAttribute("Popped") then
                            boardOf(p18).popT0 = os.clock()
                        end
                    end
                end)
            end

            if (not GlassFront or Popped) and GlassFront then
                boardOf(p18).popT0 = os.clock()
            end
        end
    end)
end

for _, child in ipairs(Plots:GetChildren()) do
    child.ChildAdded:Connect(function(p20) -- line: 267
        -- upvalues: boardOf (copy), scan (copy), child (copy)
        if p20.Name == "Aquarium" then
            local GlassFront = p20:FindFirstChild("GlassFront")
            local Popped

            if GlassFront then
                scan()
                Popped = p20:GetAttribute("Popped")
            else
                task.spawn(function() -- line: 276
                    -- upvalues: boardOf (copy), scan (copy), child (copy), p20 (copy)
                    if p20:WaitForChild("GlassFront", 5) then
                        scan()

                        if p20:GetAttribute("Popped") then
                            boardOf(child).popT0 = os.clock()
                        end
                    end
                end)
            end

            if (not GlassFront or Popped) and GlassFront then
                boardOf(child).popT0 = os.clock()
            end
        end
    end)
end

Plots.ChildAdded:Connect(watchPlot)
RunService.Heartbeat:Connect(function(p21) -- line: 282
    -- upvalues: t1 (copy), popFactor (copy), scan (copy), v25 (copy), n2 (ref)
    n2 += p21

    if n2 >= 1 then
        n2 = 0
        scan()
    end

    local CFramePosition = workspace.CurrentCamera.CFrame.Position
    local ServerTimeNow = workspace:GetServerTimeNow()
    local v27 = 1 - math.exp(-10 * p21)

    for _, v28 in pairs(t1) do
        local glass = v28.glass

        if v28.owner then
            if glass and glass.Parent then
                local Unit = Vector3.new(glass.CFrame.LookVector.X, 0, glass.CFrame.LookVector.Z).Unit
                local v29 = Vector3.new(glass.Position.X, 0, glass.Position.Z) + Unit * 7

                if not ((v29 - CFramePosition).Magnitude > 400) then
                    local v30, v31

                    if v28.count > 0 then
                        local v32 = (v28.count * 0.9 + 0.6) * 4.2
                        local v34 = math.min(1, glass.Size.X * 0.92 / v32)

                        v30 = v32 * v34
                        v31 = 4.2 * v34
                    else
                        v30 = 0
                        v31 = 0
                    end

                    v28.w += (v30 - v28.w) * v27
                    v28.h += (v31 - v28.h) * v27

                    if v28.count == 0 and v28.h < 0.05 then
                        v28.w = 0
                        v28.h = 0
                        v28.gui.Enabled = false
                    else
                        v28.gui.Enabled = true

                        local v35 = ServerTimeNow / 5.5 * 3.141592653589793 * 2 + v28.phase
                        local v37 = v29 + Vector3.new(0, 0.25 + math.sin(v35) * 0.18, 0)
                        local v39 = CFrame.Angles(0, 0, math.sin(v35 * 0.77 + 1.3) * 0.020943951023931952)
                        local v40 = popFactor(v28, os.clock())
                        local v41 = v28.w * v40
                        local v42 = v28.h * v40

                        v28.part.Size = Vector3.new(math.max(v41, 0.05), math.max(v42, 0.05), 0.05)
                        v28.part.CFrame = CFrame.lookAt(v37, v37 + Unit) * v39 * v25 * CFrame.new(0, v42 / 2, 0)
                    end
                end
            end
        else
            v28.gui.Enabled = false
        end
    end
end)
