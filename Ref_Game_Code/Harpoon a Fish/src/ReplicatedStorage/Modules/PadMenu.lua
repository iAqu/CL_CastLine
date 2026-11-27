-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")
local MarketplaceService = game:GetService("MarketplaceService")
local GamepadService = game:GetService("GamepadService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InputMode = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("InputMode"))
local t1 = {}
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local t2 = {}

local function cursorOn() -- line: 38
    -- upvalues: GamepadService (copy)
    return GamepadService.GamepadCursorEnabled
end

local v1 = false
local Frame = Instance.new("Frame")

Frame.Name = "PadSelection"
Frame.BackgroundTransparency = 1
Frame.Size = UDim2.fromScale(1, 1)

local UICorner = Instance.new("UICorner")

UICorner.CornerRadius = UDim.new(0.18, 0)
UICorner.Parent = Frame

local UIStroke = Instance.new("UIStroke")

UIStroke.Color = Color3.fromRGB(255, 244, 200)
UIStroke.Thickness = 4
UIStroke.Transparency = 0.05
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = Frame

local UIGradient = Instance.new("UIGradient")

UIGradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 205, 80))
UIGradient.Rotation = 90
UIGradient.Parent = UIStroke
PlayerGui.SelectionImageObject = Frame

local function visibleIn(p1, p2) -- line: 63
    -- upvalues: PlayerGui (copy)
    while p1 and p1 ~= PlayerGui do
        if p1:IsA("GuiObject") and not p1.Visible or p1:IsA("LayerCollector") and not p1.Enabled then
            return false
        end

        if p1 == p2 then
            return true
        end

        p1 = p1.Parent
    end

    return p1 == p2
end

local function focusTop() -- line: 77
    -- upvalues: GuiService (copy), GamepadService (copy), InputMode (copy), t2 (copy), visibleIn (copy)
    local v3 = t2[#t2]

    if not v3 or not InputMode.Pad() or GuiService.MenuIsOpen or GamepadService.GamepadCursorEnabled then
        return
    end

    local SelectedObject = GuiService.SelectedObject

    if SelectedObject and SelectedObject ~= v3.root and visibleIn(SelectedObject, v3.root) then
        return
    end

    local first = v3.first

    if type(first) == "function" then
        first = first()
    end

    if first and first.Parent and visibleIn(first, v3.root) then
        GuiService.SelectedObject = first
    else
        local function v4() -- line: 87
            -- upvalues: v3 (copy), GuiService (copy)
            GuiService:Select(v3.root)
        end

        pcall(v4)
    end
end

local t3 = {
    "SelectionBehaviorUp",
    "SelectionBehaviorDown",
    "SelectionBehaviorLeft",
    "SelectionBehaviorRight"
}

local function fence(p3) -- line: 92
    -- upvalues: t3 (copy)
    local t4 = {}

    local function v5() -- line: 94
        -- upvalues: p3 (copy), t4 (copy), t3 (copy)
        t4.group = p3.SelectionGroup

        for _, v6 in ipairs(t3) do
            t4[v6] = p3[v6]
        end

        p3.SelectionGroup = true

        for _, v7 in ipairs(t3) do
            p3[v7] = Enum.SelectionBehavior.Stop
        end
    end

    pcall(v5)

    return t4
end

local function unfence(p4, p5) -- line: 102
    -- upvalues: t3 (copy)
    if p5 and p5.group ~= nil then
        local function v8() -- line: 104
            -- upvalues: p4 (copy), p5 (copy), t3 (copy)
            p4.SelectionGroup = p5.group

            for _, v9 in ipairs(t3) do
                if p5[v9] then
                    p4[v9] = p5[v9]
                end
            end
        end

        pcall(v8)
    end
end

local function bindBack(p6) -- line: 110
    -- upvalues: ContextActionService (copy), t2 (copy)
    if p6 then
        ContextActionService:BindActionAtPriority("PadMenuBack", function(_, p8) -- line: 112
            -- upvalues: t2 (copy)
            if p8 == Enum.UserInputState.Begin then
                local v10 = t2[#t2]

                if v10 and v10.close then
                    task.spawn(v10.close)
                end
            end

            return Enum.ContextActionResult.Sink
        end, false, 3000, Enum.KeyCode.ButtonB)
    else
        ContextActionService:UnbindAction("PadMenuBack")
    end
end

local function badgeOn(p9) -- line: 124
    -- upvalues: InputMode (copy)
    if not p9 then
        return nil
    end

    local PadBack = p9:FindFirstChild("PadBack")

    if not PadBack then
        local ImageLabel = Instance.new("ImageLabel")

        PadBack = ImageLabel
        ImageLabel.Name = "PadBack"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.Position = UDim2.fromScale(0.12, 0.12)
        ImageLabel.Size = UDim2.fromScale(0.5, 0.5)
        ImageLabel.ZIndex = (p9:IsA("GuiObject") and p9.ZIndex or 1) + 5
        Instance.new("UIAspectRatioConstraint").Parent = ImageLabel
        ImageLabel.Parent = p9
    end

    PadBack.Image = InputMode.Icon(Enum.KeyCode.ButtonB)
    PadBack.Visible = InputMode.Pad()

    return PadBack
end

local function watch() -- line: 145
    -- upvalues: GuiService (copy), GamepadService (copy), InputMode (copy), t2 (copy), v1 (ref), visibleIn (copy), focusTop (copy)
    if not v1 then
        v1 = true
        task.spawn(function() -- line: 148
            -- upvalues: GuiService (copy), GamepadService (copy), InputMode (copy), t2 (copy), v1 (ref), visibleIn (copy), focusTop (copy)
            while #t2 > 0 do
                task.wait(0.4)

                local v11 = t2[#t2]

                if v11 and InputMode.Pad() and not GuiService.MenuIsOpen and not GamepadService.GamepadCursorEnabled then
                    local SelectedObject = GuiService.SelectedObject

                    if not SelectedObject or not visibleIn(SelectedObject, v11.root) then
                        focusTop()
                    end
                end
            end

            v1 = false
        end)
    end
end

function t1.Open(p10, p11, p12) -- line: 161
    -- upvalues: GuiService (copy), ContextActionService (copy), GamepadService (copy), InputMode (copy), t1 (copy), t2 (copy), v1 (ref), visibleIn (copy), focusTop (copy), t3 (copy), badgeOn (copy)
    p12 = p12 or {}
    t1.Close(p10)

    local v13 = #t2 + 1
    local t5 = {
        root = p10,
        close = p11,
        first = p12.first,
        badge = badgeOn(p12.closeButton)
    }
    local t6 = {}

    local function v14() -- line: 94
        -- upvalues: p10 (copy), t6 (copy), t3 (copy)
        t6.group = p10.SelectionGroup

        for _, v15 in ipairs(t3) do
            t6[v15] = p10[v15]
        end

        p10.SelectionGroup = true

        for _, v16 in ipairs(t3) do
            p10[v16] = Enum.SelectionBehavior.Stop
        end
    end

    pcall(v14)
    t5.fenced = t6
    t2[v13] = t5
    ContextActionService:BindActionAtPriority("PadMenuBack", function(_, p14) -- line: 112
        -- upvalues: t2 (copy)
        if p14 == Enum.UserInputState.Begin then
            local v17 = t2[#t2]

            if v17 and v17.close then
                task.spawn(v17.close)
            end
        end

        return Enum.ContextActionResult.Sink
    end, false, 3000, Enum.KeyCode.ButtonB)
    task.delay(0.05, focusTop)

    if not v1 then
        v1 = true
        task.spawn(function() -- line: 148
            -- upvalues: GuiService (copy), GamepadService (copy), InputMode (copy), t2 (copy), v1 (ref), visibleIn (copy), focusTop (copy)
            while #t2 > 0 do
                task.wait(0.4)

                local v18 = t2[#t2]

                if v18 and InputMode.Pad() and not GuiService.MenuIsOpen and not GamepadService.GamepadCursorEnabled then
                    local SelectedObject = GuiService.SelectedObject

                    if not SelectedObject or not visibleIn(SelectedObject, v18.root) then
                        focusTop()
                    end
                end
            end

            v1 = false
        end)
    end
end

function t1.Close(p15) -- line: 171
    -- upvalues: GuiService (copy), ContextActionService (copy), GamepadService (copy), t2 (copy), focusTop (copy), t3 (copy)
    for i = #t2, 1, -1 do
        if t2[i].root == p15 then
            if t2[i].badge then
                t2[i].badge.Visible = false
            end

            local fenced = t2[i].fenced

            if fenced and fenced.group ~= nil then
                local function v19() -- line: 104
                    -- upvalues: p15 (copy), fenced (copy), t3 (copy)
                    p15.SelectionGroup = fenced.group

                    for _, v20 in ipairs(t3) do
                        if fenced[v20] then
                            p15[v20] = fenced[v20]
                        end
                    end
                end

                pcall(v19)
            end

            table.remove(t2, i)
        end
    end

    local SelectedObject = GuiService.SelectedObject

    if SelectedObject and SelectedObject:IsDescendantOf(p15) then
        GuiService.SelectedObject = nil
    end

    local v21 = #t2 == 0
    local GamepadCursorEnabled

    if v21 then
        ContextActionService:UnbindAction("PadMenuBack")
        GamepadCursorEnabled = GamepadService.GamepadCursorEnabled
    else
        task.delay(0.05, focusTop)
    end

    if (not v21 or GamepadCursorEnabled) and v21 then
        local function v22() -- line: 183
            -- upvalues: GamepadService (copy)
            GamepadService:DisableGamepadCursor()
        end

        pcall(v22)
    end
end

local t7 = {
    [Enum.KeyCode.DPadUp] = true,
    [Enum.KeyCode.DPadDown] = true,
    [Enum.KeyCode.DPadLeft] = true,
    [Enum.KeyCode.DPadRight] = true
}

UserInputService.InputChanged:Connect(function(p16) -- line: 192
    -- upvalues: GuiService (copy), GamepadService (copy), t2 (copy), visibleIn (copy)
    if p16.KeyCode ~= Enum.KeyCode.Thumbstick1 or p16.Position.Magnitude < 0.5 then
        return
    end

    local v23 = t2[#t2]
    local SelectedObject

    if not v23 or GamepadService.GamepadCursorEnabled or GuiService.MenuIsOpen then
        return
    else
        SelectedObject = GuiService.SelectedObject

        if not SelectedObject or not visibleIn(SelectedObject, v23.root) then
            SelectedObject = v23.root
        end
    end

    GuiService.SelectedObject = nil

    local function v25() -- line: 199
        -- upvalues: SelectedObject (ref), GamepadService (copy)
        GamepadService:EnableGamepadCursor(SelectedObject)
    end

    pcall(v25)
end)
UserInputService.InputBegan:Connect(function(p17) -- line: 201
    -- upvalues: GamepadService (copy), t2 (copy), focusTop (copy), t7 (copy)
    if not t7[p17.KeyCode] or not GamepadService.GamepadCursorEnabled or #t2 == 0 then
        return
    end

    local function v26() -- line: 203
        -- upvalues: GamepadService (copy)
        GamepadService:DisableGamepadCursor()
    end

    pcall(v26)
    focusTop()
end)
InputMode.Changed:Connect(function(p18) -- line: 208
    -- upvalues: GuiService (copy), InputMode (copy), t2 (copy), focusTop (copy)
    for _, v27 in ipairs(t2) do
        if v27.badge then
            v27.badge.Image = InputMode.Icon(Enum.KeyCode.ButtonB)
            v27.badge.Visible = p18
        end
    end

    if p18 then
        focusTop()
    elseif GuiService.SelectedObject then
        GuiService.SelectedObject = nil
    end
end)

local function regain() -- line: 218
    -- upvalues: focusTop (copy)
    task.delay(0.15, focusTop)
end

MarketplaceService.PromptProductPurchaseFinished:Connect(regain)
MarketplaceService.PromptGamePassPurchaseFinished:Connect(regain)
GuiService.MenuClosed:Connect(regain)

return t1
