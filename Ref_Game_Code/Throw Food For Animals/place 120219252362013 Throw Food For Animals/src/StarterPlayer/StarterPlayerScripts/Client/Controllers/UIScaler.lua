-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1 = {
    Changed = require(ReplicatedStorage.Shared.Signal).new()
}
local t2 = {
    TouchGui = true,
    Freecam = true
}
local t3 = {
    UIStroke = { "Thickness" },
    UICorner = { "CornerRadius" },
    UITextSizeConstraint = { "MinTextSize", "MaxTextSize" },
    ScrollingFrame = { "ScrollBarThickness" }
}
local LocalPlayer = Players.LocalPlayer
local v1 = Vector2.new(1265, 692)
local self = setmetatable({}, {
    __mode = "k"
})
local self2 = setmetatable({}, {
    __mode = "k"
})
local v4 = false

local function readViewport() -- line: 76
    -- upvalues: v1 (ref)
    local CurrentCamera = workspace.CurrentCamera
    local ViewportSize = CurrentCamera and CurrentCamera.ViewportSize or Vector2.zero

    if ViewportSize.Y >= 100 then
        v1 = ViewportSize
    end

    return math.floor(math.clamp(v1.Y / 692, 0.45, 2.5) * 100 + 0.5) / 100
end

local CurrentCamera = workspace.CurrentCamera
local ViewportSize = CurrentCamera and CurrentCamera.ViewportSize or Vector2.zero

if ViewportSize.Y >= 100 then
    v1 = ViewportSize
end

local v9 = math.floor(math.clamp(v1.Y / 692, 0.45, 2.5) * 100 + 0.5) / 100

function t1.Factor() -- line: 85
    -- upvalues: v9 (ref)
    return v9
end

function t1.IsTouch() -- line: 89
    -- upvalues: UserInputService (copy)
    return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end

function t1.IsPhone() -- line: 93
    -- upvalues: t1 (copy), v1 (ref)
    local v10 = t1.IsTouch()

    v10 = v10 and math.min(v1.X, v1.Y) < 500

    return v10
end

function t1.TouchBoost() -- line: 97
    -- upvalues: t1 (copy)
    if t1.IsPhone() then
        return 1.2
    end

    if t1.IsTouch() then
        return 1.1
    end

    return 1
end

function t1.Px(p1) -- line: 104
    -- upvalues: t1 (copy), v9 (ref)
    return p1 * v9 * t1.TouchBoost()
end

local function attr(p2, p3) -- line: 112
    return "UIScale" .. p3 .. "_" .. p2
end

local function scaledValue(p4, p5) -- line: 116
    -- upvalues: v9 (ref)
    if p4 == "Thickness" then
        if p5 <= 0 then
            return p5
        end

        return (math.max(p5 * v9, (math.min(p5, 0.6))))
    end

    if p4 == "CornerRadius" then
        return UDim.new(p5.Scale, (math.round(p5.Offset * v9)))
    end

    if p4 == "ScrollBarThickness" then
        if p5 <= 0 then
            return p5
        end

        return (math.max(2, (math.round(p5 * v9))))
    end

    return (math.clamp(math.round(p5 * v9), 1, 100))
end

local function same(p6, p7) -- line: 129
    if typeof(p6) ~= typeof(p7) then
        return false
    end

    if typeof(p6) == "UDim" then
        if p6.Scale == p7.Scale then
            return p6.Offset == p7.Offset
        end

        return false
    end

    if typeof(p6) ~= "number" then
        return p6 == p7
    end

    return math.abs(p6 - p7) < 0.001
end

local function write(p8, p9, p10) -- line: 136
    -- upvalues: scaledValue (copy)
    local v19 = scaledValue(p9, p10.Base)

    local function v20() -- line: 138
        -- upvalues: p8 (copy), p9 (copy), v19 (copy)
        p8[p9] = v19
    end

    pcall(v20)
    p10.Applied = p8[p9]
    p8:SetAttribute("UIScale" .. "Base" .. "_" .. p9, p10.Base)
    p8:SetAttribute("UIScale" .. "Applied" .. "_" .. p9, p10.Applied)
end

local function shouldScale(p11) -- line: 145
    -- upvalues: t2 (copy)
    while p11 do
        if p11:GetAttribute("UIScaleIgnore") then
            return false
        end

        if p11:IsA("LayerCollector") then
            if p11:IsA("ScreenGui") then
                return not t2[p11.Name]
            end

            if not p11:IsA("BillboardGui") then
                return false
            end

            return p11.Size.Y.Scale > 0
        end

        p11 = p11.Parent
    end

    return false
end

local function track(p12, p13) -- line: 159
    -- upvalues: self (copy), write (copy)
    local v22 = self[p12]

    if v22 then
        for v23, v24 in pairs(v22) do
            write(p12, v23, v24)
        end
    else
        local t8 = {}

        self[p12] = t8

        for _, v25 in ipairs(p13) do
            local v26 = p12[v25]
            local Attribute = p12:GetAttribute("UIScale" .. "Base" .. "_" .. v25)
            local Attribute2 = p12:GetAttribute("UIScale" .. "Applied" .. "_" .. v25)

            if Attribute ~= nil and Attribute2 ~= nil then
                local v27 = typeof(v26) == typeof(Attribute2) and (if typeof(v26) == "UDim" then v26.Scale == Attribute2.Scale and v26.Offset == Attribute2.Offset elseif typeof(v26) == "number" then math.abs(v26 - Attribute2) < 0.001 else v26 == Attribute2)

                if v27 then
                    v26 = Attribute
                end
            end

            local t9 = {
                Base = v26
            }

            t8[v25] = t9
            write(p12, v25, t9)
            p12:GetPropertyChangedSignal(v25):Connect(function() -- line: 180
                -- upvalues: p12 (copy), v25 (copy), t9 (copy), write (copy)
                local v29 = p12[v25]
                local Applied = t9.Applied
                local v30 = typeof(v29) == typeof(Applied) and (if typeof(v29) == "UDim" then v29.Scale == Applied.Scale and v29.Offset == Applied.Offset elseif typeof(v29) == "number" then math.abs(v29 - Applied) < 0.001 else v29 == Applied)

                if v30 then
                    return
                end

                t9.Base = v29
                write(p12, v25, t9)
            end)
        end
    end
end

function t1.Base(p14, p15) -- line: 190
    -- upvalues: self (copy)
    if not p14 then
        return nil
    end

    local v32 = self[p14]

    if v32 and v32[p15] then
        return v32[p15].Base
    end

    local Attribute = p14:GetAttribute("UIScale" .. "Base" .. "_" .. p15)

    if Attribute == nil then
        return p14[p15]
    end

    return Attribute
end

function t1.DrawCross(p16) -- line: 203
    if p16:FindFirstChild("Cross") then
        return
    end

    local TextColor3 = p16.TextColor3

    p16.Text = ""

    local ZIndex = p16.ZIndex
    local Frame = Instance.new("Frame")

    Frame.Name = "Cross"
    Frame.BackgroundTransparency = 1
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.Size = UDim2.fromScale(0.8, 0.8)
    Frame.SizeConstraint = Enum.SizeConstraint.RelativeYY
    Frame.ZIndex = ZIndex

    for v33, v34 in ipairs({
            {
                1, 0.34,
                Color3.new(0, 0, 0),
                ZIndex
            },
            {
                0.84, 0.18,
                TextColor3,
                ZIndex + 1
            }
        }) do
        for _, v35 in ipairs({ 45, -45 }) do
            local Frame2 = Instance.new("Frame")

            Frame2.Name = v33 == 1 and "Outline" or "Fill"
            Frame2.BorderSizePixel = 0
            Frame2.BackgroundColor3 = v34[3]
            Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
            Frame2.Position = UDim2.fromScale(0.5, 0.5)
            Frame2.Size = UDim2.fromScale(v34[1], v34[2])
            Frame2.Rotation = v35
            Frame2.ZIndex = v34[4]

            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = UDim.new(0.5, 0)
            UICorner.Parent = Frame2
            Frame2.Parent = Frame
        end
    end

    Frame.Parent = p16
end

local function isCloseLabel(p17) -- line: 237
    if p17.Text ~= "X" or not p17.TextScaled then
        return false
    end

    local Parent = p17.Parent

    if not Parent then
        return false
    end

    if Parent:IsA("GuiButton") then
        return true
    end

    return string.find(Parent.Name, "Close") ~= nil
end

local function handle(p18) -- line: 249
    -- upvalues: t1 (copy), t3 (copy), shouldScale (copy), track (copy)
    local v36 = t3[p18.ClassName]

    if v36 then
        if shouldScale(p18) then
            track(p18, v36)
        end
    elseif p18:IsA("TextLabel") and p18.Text == "X" and p18.TextScaled then
        local Parent = p18.Parent

        if Parent and (Parent:IsA("GuiButton") or string.find(Parent.Name, "Close") ~= nil) and shouldScale(p18) then
            t1.DrawCross(p18)
        end
    end
end

local function handleWorld(p19) -- line: 259
    -- upvalues: t3 (copy), handle (copy)
    if t3[p19.ClassName] and p19:FindFirstAncestorWhichIsA("BillboardGui") then
        handle(p19)
    end
end

local function refreshAll() -- line: 265
    -- upvalues: self (copy), write (copy)
    for v37, v38 in pairs(self) do
        if v37.Parent then
            for v39, v40 in pairs(v38) do
                write(v37, v39, v40)
            end
        end
    end
end

local fit

local function fitSoon(p20) -- line: 278
    -- upvalues: fit (ref)
    fit(p20)
    task.defer(fit, p20)
    task.delay(0.1, fit, p20)
end

function fit(p21) -- line: 284
    -- upvalues: t1 (copy), self2 (copy), v9 (ref)
    local v41 = self2[p21]
    local Parent = p21.Parent

    if v41 and Parent and Parent:IsA("GuiBase2d") then
        local ScreenGui = p21:FindFirstAncestorWhichIsA("ScreenGui")

        if ScreenGui and not ScreenGui.Enabled then
            return
        end

        local Opts = v41.Opts
        local UIAspectRatioConstraint = p21:FindFirstChildOfClass("UIAspectRatioConstraint")

        if UIAspectRatioConstraint and v41.Ratio then
            UIAspectRatioConstraint.AspectRatio = Opts.PhoneRatio and t1.IsPhone() and Opts.PhoneRatio or v41.Ratio
        end

        local AbsoluteSize = Parent.AbsoluteSize
        local X, Y = AbsoluteSize.X, AbsoluteSize.Y

        if not (X < 50 or Y < 50) then
            local Size, Position = v41.Size, v41.Position
            local v42 = p21.SizeConstraint == Enum.SizeConstraint.RelativeYY and Y or X
            local v43 = if p21.SizeConstraint ~= Enum.SizeConstraint.RelativeXX or not X then Y else X
            local v44 = Size.X.Scale * v42 + Size.X.Offset
            local v45 = Size.Y.Scale * v43 + Size.Y.Offset

            if UIAspectRatioConstraint and UIAspectRatioConstraint.AspectType == Enum.AspectType.FitWithinMaxSize and v44 > 0 and v45 > 0 then
                local AspectRatio = UIAspectRatioConstraint.AspectRatio

                if AspectRatio < v44 / v45 then
                    v44 = v45 * AspectRatio
                else
                    v45 = v44 / AspectRatio
                end
            end

            if not (v44 <= 0 or v45 <= 0) then
                local v47 = math.max(4, v9 * 8)
                local v49 = math.max(0, -Parent.AbsolutePosition.Y) + v47
                local v50 = Y - v47
                local v51 = X - v47
                local v55 = math.min(t1.TouchBoost(), (v50 - v49) / v45, (v51 - v47) / v44)

                p21.Size = UDim2.new(Size.X.Scale * v55, Size.X.Offset * v55, Size.Y.Scale * v55, Size.Y.Offset * v55)

                if Opts.Reposition ~= false then
                    local v56 = v44 * v55
                    local v57 = v45 * v55
                    local AnchorPoint = p21.AnchorPoint
                    local v58 = Position.X.Scale * X + Position.X.Offset - AnchorPoint.X * v56
                    local v59 = Position.Y.Scale * Y + Position.Y.Offset - AnchorPoint.Y * v57
                    local v60 = if v59 < v49 then v49 - v59 elseif v50 < v59 + v57 then v50 - (v59 + v57) else 0
                    local v61 = if v58 < v47 then v47 - v58 elseif v51 < v58 + v56 then v51 - (v58 + v56) else 0

                    p21.Position = UDim2.new(Position.X.Scale, Position.X.Offset + math.round(v61), Position.Y.Scale, Position.Y.Offset + math.round(v60))
                end
            end
        end
    end
end

function t1.FitWindow(p22, p23) -- line: 329
    -- upvalues: self2 (copy), fit (ref)
    if not p22 then
        return
    end

    local UIAspectRatioConstraint = p22:FindFirstChildOfClass("UIAspectRatioConstraint")
    local v62 = self2[p22]
    local v63 = v62

    if not v62 then
        local t10 = {}

        v63 = t10
        self2[p22] = t10
        p22.AncestryChanged:Connect(function() -- line: 337
            -- upvalues: p22 (copy), v63 (ref), fit (ref)
            if v63.GuiConn then
                v63.GuiConn:Disconnect()
                v63.GuiConn = nil
            end

            local LayerCollector = p22:FindFirstAncestorWhichIsA("LayerCollector")

            if LayerCollector then
                v63.GuiConn = LayerCollector:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 341
                    -- upvalues: p22 (copy), fit (ref)
                    fit(p22)
                    task.defer(fit, p22)
                    task.delay(0.1, fit, p22)
                end)
            end

            task.defer(fit, p22)
        end)

        local LayerCollector = p22:FindFirstAncestorWhichIsA("LayerCollector")

        if LayerCollector then
            local connection = LayerCollector:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 347
                -- upvalues: p22 (copy), fit (ref)
                fit(p22)
                task.defer(fit, p22)
                task.delay(0.1, fit, p22)
            end)

            v63.GuiConn = connection
        end
    end

    local Size = p22.Size

    v63.Size = Size
    v63.Position = p22.Position
    v63.Ratio = UIAspectRatioConstraint and UIAspectRatioConstraint.AspectRatio or nil
    v63.Opts = p23 or {}
    fit(p22)
    task.defer(fit, p22)
end

function t1.Refit(p24, p25) -- line: 359
    -- upvalues: self2 (copy), fit (ref)
    local v65 = self2[p24]

    if not v65 then
        return
    end

    if p25 then
        v65.Position = p25
    end

    fit(p24)
    task.defer(fit, p24)
    task.delay(0.1, fit, p24)
end

function t1.CoverScreen(p26) -- line: 368
    p26.AnchorPoint = Vector2.new(0.5, 0.5)
    p26.Position = UDim2.fromScale(0.5, 0.5)
    p26.Size = UDim2.new(1, 1200, 1, 1200)

    local ScreenGui = p26:FindFirstAncestorWhichIsA("ScreenGui")

    if ScreenGui then
        ScreenGui.ClipToDeviceSafeArea = false
    end
end

local function onViewportChanged() -- line: 380
    -- upvalues: t1 (copy), v1 (ref), self2 (copy), v9 (ref), refreshAll (copy), fit (ref)
    local CurrentCamera = workspace.CurrentCamera
    local ViewportSize = CurrentCamera and CurrentCamera.ViewportSize or Vector2.zero

    if ViewportSize.Y >= 100 then
        v1 = ViewportSize
    end

    local v68 = math.floor(math.clamp(v1.Y / 692, 0.45, 2.5) * 100 + 0.5) / 100

    if v68 ~= v9 then
        v9 = v68
        refreshAll()
    end

    task.defer(function() -- line: 387
        -- upvalues: t1 (copy), self2 (copy), v9 (ref), fit (ref)
        for v69 in pairs(self2) do
            fit(v69)
        end

        t1.Changed:Fire(v9)
    end)
end

function t1.Init() -- line: 393
    -- upvalues: t1 (copy), t3 (copy), LocalPlayer (copy), v1 (ref), self2 (copy), v4 (ref), v9 (ref), handle (copy), handleWorld (copy), refreshAll (copy), fit (ref), onViewportChanged (copy)
    if v4 then
        return
    end

    v4 = true

    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    for _, descendant in ipairs(PlayerGui:GetDescendants()) do
        handle(descendant)
    end

    PlayerGui.DescendantAdded:Connect(handle)

    for _, descendant in ipairs(workspace:GetDescendants()) do
        if t3[descendant.ClassName] and descendant:FindFirstAncestorWhichIsA("BillboardGui") then
            handle(descendant)
        end
    end

    workspace.DescendantAdded:Connect(handleWorld)

    local connection

    local function hookCamera() -- line: 403
        -- upvalues: connection (ref), t1 (copy), v1 (ref), self2 (copy), v9 (ref), refreshAll (copy), fit (ref), onViewportChanged (copy)
        if connection then
            connection:Disconnect()
        end

        local CurrentCamera = workspace.CurrentCamera

        if CurrentCamera then
            connection = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(onViewportChanged)
        end

        local CurrentCamera2 = workspace.CurrentCamera
        local ViewportSize = CurrentCamera2 and CurrentCamera2.ViewportSize or Vector2.zero

        if ViewportSize.Y >= 100 then
            v1 = ViewportSize
        end

        local v73 = math.floor(math.clamp(v1.Y / 692, 0.45, 2.5) * 100 + 0.5) / 100

        if v73 ~= v9 then
            v9 = v73
            refreshAll()
        end

        task.defer(function() -- line: 387
            -- upvalues: t1 (copy), self2 (copy), v9 (ref), fit (ref)
            for v74 in pairs(self2) do
                fit(v74)
            end

            t1.Changed:Fire(v9)
        end)
    end

    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(hookCamera)

    if connection then
        connection:Disconnect()
    end

    local CurrentCamera = workspace.CurrentCamera

    if CurrentCamera then
        connection = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(onViewportChanged)
    end

    local CurrentCamera2 = workspace.CurrentCamera
    local ViewportSize = CurrentCamera2 and CurrentCamera2.ViewportSize or Vector2.zero

    if ViewportSize.Y >= 100 then
        v1 = ViewportSize
    end

    local v78 = math.floor(math.clamp(v1.Y / 692, 0.45, 2.5) * 100 + 0.5) / 100

    if v78 ~= v9 then
        v9 = v78
        refreshAll()
    end

    task.defer(function() -- line: 387
        -- upvalues: t1 (copy), self2 (copy), v9 (ref), fit (ref)
        for v79 in pairs(self2) do
            fit(v79)
        end

        t1.Changed:Fire(v9)
    end)
end

return t1
