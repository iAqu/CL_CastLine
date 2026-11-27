-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Config = require(ReplicatedStorage.Shared.Config)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.UIUtil)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Style = require(script.Parent.Parent.Shop.Style)
local Diag = require(script.Parent.Parent.Character.Diag)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v2 = math.ceil(#Config.FeedbackTopics / 3)
local v3 = (v2 - 1) * 66 + 700
local v4 = Color3.fromRGB(255, 205, 50)
local v5 = Color3.fromRGB(70, 80, 105)
local t2 = {
    "Not fun 😞",
    "Meh 😕",
    "It's OK 🙂",
    "Good! 😀",
    "Love it! 😍"
}
local TEAL = Style.TEAL
local v6 = Color3.fromRGB(60, 72, 100)
local ScreenGui, ScreenGui2, v7, TextBox, v8, v9
local t3 = {}
local t4 = {}
local n1 = 0
local v10 = nil
local v11 = "Button"
local v12 = false
local v13 = false
local v14 = false

local function v15() -- line: 42
    return false
end

local function usingGamepad() -- line: 46
    -- upvalues: UserInputService (copy)
    return UserInputService:GetLastInputType().Name:find("^Gamepad") ~= nil
end

local function device() -- line: 50
    -- upvalues: UserInputService (copy)
    if UserInputService:GetLastInputType().Name:find("^Gamepad") ~= nil then
        return "Gamepad"
    end

    if not UserInputService.TouchEnabled or UserInputService.KeyboardEnabled then
        return "Keyboard"
    end

    return "Touch"
end

local function paintStars(p1) -- line: 58
    -- upvalues: v4 (copy), v5 (copy), t2 (copy), v7 (ref), t3 (copy), n1 (ref)
    p1 = p1 or n1

    for v17, v18 in t3 do
        local Label = v18.Label

        if v17 <= p1 then
            Label.TextColor3 = v4
        else
            Label.TextColor3 = v5
        end
    end

    local v19 = v7

    if p1 > 0 then
        v19.Text = t2[p1]
    else
        v19.Text = "Tap a star to rate"
    end
end

local function paintSend() -- line: 72
    -- upvalues: Style (copy), v9 (ref), n1 (ref), v12 (ref)
    local v20 = v9

    if not (n1 > 0) or v12 then
        v20.BackgroundColor3 = Style.GREY
    else
        v20.BackgroundColor3 = Style.BUY
    end

    v9.Label.Text = v12 and "SENDING..." or "SEND ✉️"
end

local function send() -- line: 85
    -- upvalues: UserInputService (copy), Remotes (copy), UIUtil (copy), Style (copy), Diag (copy), t1 (copy), v4 (copy), v5 (copy), t2 (copy), TEAL (copy), v6 (copy), v7 (ref), TextBox (ref), v9 (ref), t3 (copy), t4 (copy), n1 (ref), v10 (ref), v11 (ref), v12 (ref), v13 (ref)
    if v12 then
        return
    end

    if n1 == 0 then
        UIUtil.toast("Pick a star rating first!", "error")
    else
        v12 = true

        local v21 = v9

        if not (n1 > 0) or v12 then
            v21.BackgroundColor3 = Style.GREY
        else
            v21.BackgroundColor3 = Style.BUY
        end

        v9.Label.Text = v12 and "SENDING..." or "SEND ✉️"

        local InvokeServer = Remotes.SendFeedback.InvokeServer
        local SendFeedback = Remotes.SendFeedback
        local t5 = {
            Stars = n1,
            Topic = v10,
            Text = TextBox.Text,
            Source = v11,
            Device = if UserInputService:GetLastInputType().Name:find("^Gamepad") ~= nil then "Gamepad" elseif not UserInputService.TouchEnabled or UserInputService.KeyboardEnabled then "Keyboard" else "Touch",
            Diag = Diag.snapshot()
        }
        local v22, v23, v24 = pcall(InvokeServer, SendFeedback, t5)

        v12 = false

        local v25 = v9

        if not (n1 > 0) or v12 then
            v25.BackgroundColor3 = Style.GREY
        else
            v25.BackgroundColor3 = Style.BUY
        end

        v9.Label.Text = v12 and "SENDING..." or "SEND ✉️"

        if v22 then
            UIUtil.toast(v24 or "", v23 and "success" or "error")

            if v23 then
                v13 = true
                n1 = 0
                v10 = nil
                TextBox.Text = ""

                local v26 = n1

                for v27, v28 in t3 do
                    local Label = v28.Label

                    if v27 <= v26 then
                        Label.TextColor3 = v4
                    else
                        Label.TextColor3 = v5
                    end
                end

                local v29 = v7

                if v26 > 0 then
                    v29.Text = t2[v26]
                else
                    v29.Text = "Tap a star to rate"
                end

                for v30, v31 in t4 do
                    if v30 == v10 then
                        v31.BackgroundColor3 = TEAL
                    else
                        v31.BackgroundColor3 = v6
                    end
                end

                local v32 = v9

                if not (n1 > 0) or v12 then
                    v32.BackgroundColor3 = Style.GREY
                else
                    v32.BackgroundColor3 = Style.BUY
                end

                v9.Label.Text = v12 and "SENDING..." or "SEND ✉️"
                t1.close()
            end
        else
            UIUtil.toast("Couldn't send it, try again in a moment!", "error")
        end
    end
end

local function build() -- line: 117
    -- upvalues: Config (copy), UIUtil (copy), Kit (copy), Style (copy), LocalPlayer (copy), t1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), t2 (copy), TEAL (copy), v6 (copy), ScreenGui (ref), v7 (ref), TextBox (ref), v8 (ref), v9 (ref), t3 (copy), t4 (copy), n1 (ref), v10 (ref), v12 (ref), send (copy)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Feedback"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    local ScreenGui2 = ScreenGui

    ScreenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 6
    ScreenGui.Enabled = false

    local v33 = Kit.frame(ScreenGui, {
        Name = "Panel",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(820, v3),
        BackgroundColor3 = Color3.new(1, 1, 1)
    })

    Kit.corner(v33, 24)
    Kit.stroke(v33, 6)
    Style.gradient(v33, ColorSequence.new(Style.NAVY, Style.DEEP))
    Kit.studs(v33, 0.75, 44, 24)

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Scale"
    UIScale.Parent = v33

    local v34 = Kit.frame(v33, {
        Name = "Header",
        ZIndex = 2,
        BackgroundColor3 = Color3.new(1, 1, 1),
        Size = UDim2.new(1, 0, 0, 118)
    })

    Kit.corner(v34, 22)
    Kit.stroke(v34, 5)
    Style.gradient(v34, ColorSequence.new(Style.TEAL, Style.OCEAN), 0)
    Kit.studs(v34, 0.5, 48, 22)
    Style.bubble(v34, "📬", {
        ZIndex = 3,
        Position = UDim2.fromOffset(16, 10),
        Size = UDim2.fromOffset(98, 98)
    })

    local v35 = Kit.text(v34, "SEND FEEDBACK", {
        ZIndex = 3,
        StrokeThickness = 6,
        Position = UDim2.fromOffset(126, 10),
        Size = UDim2.fromOffset(500, 62),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    Style.gradient(v35, ColorSequence.new(Color3.new(1, 1, 1), Style.MINT))
    Style.text(v34, "Help us make the game better!", {
        ZIndex = 3,
        Position = UDim2.fromOffset(128, 72),
        Size = UDim2.fromOffset(440, 34),
        TextXAlignment = Enum.TextXAlignment.Left
    })
    Kit.button(v34, "X", Color3.fromRGB(235, 70, 70), {
        Name = "Close",
        ZIndex = 3,
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -18, 0.5, 0),
        Size = UDim2.fromOffset(86, 86)
    }, function() -- line: 171
        -- upvalues: t1 (copy)
        task.spawn(t1.close)
    end).Label.ZIndex = 4
    Kit.text(v33, "How do you like the game?", {
        Position = UDim2.fromOffset(26, 136),
        Size = UDim2.new(1, -52, 0, 40)
    })

    local v36 = 136 + 46

    for i = 1, 5 do
        local TextButton = Instance.new("TextButton")

        TextButton.Name = "Star" .. i
        TextButton.Text = ""
        TextButton.AutoButtonColor = false
        TextButton.BackgroundTransparency = 1
        TextButton.Position = UDim2.fromOffset((i - 1) * 102 + 164, v36)
        TextButton.Size = UDim2.fromOffset(84, 84)
        Kit.text(TextButton, "★", {
            Name = "Label",
            StrokeThickness = 4,
            Size = UDim2.fromScale(1, 1),
            TextColor3 = v5
        })
        TextButton.Parent = v33
        UIUtil.bindButton(TextButton, function() -- line: 198
            -- upvalues: i (copy), Style (copy), v4 (copy), v5 (copy), t2 (copy), v7 (ref), v9 (ref), t3 (copy), n1 (ref), v12 (ref)
            n1 = i

            local v37 = n1

            for v38, v39 in t3 do
                local Label = v39.Label

                if v38 <= v37 then
                    Label.TextColor3 = v4
                else
                    Label.TextColor3 = v5
                end
            end

            local v40 = v7

            if v37 > 0 then
                v40.Text = t2[v37]
            else
                v40.Text = "Tap a star to rate"
            end

            local v41 = v9

            if not (n1 > 0) or v12 then
                v41.BackgroundColor3 = Style.GREY
            else
                v41.BackgroundColor3 = Style.BUY
            end

            v9.Label.Text = v12 and "SENDING..." or "SEND ✉️"
        end)
        TextButton.MouseEnter:Connect(function() -- line: 203
            -- upvalues: i (copy), v4 (copy), v5 (copy), t2 (copy), v7 (ref), t3 (copy), n1 (ref)
            local v42 = i or n1

            for v43, v44 in t3 do
                local Label = v44.Label

                if v43 <= v42 then
                    Label.TextColor3 = v4
                else
                    Label.TextColor3 = v5
                end
            end

            local v45 = v7

            if v42 > 0 then
                v45.Text = t2[v42]
            else
                v45.Text = "Tap a star to rate"
            end
        end)
        TextButton.MouseLeave:Connect(function() -- line: 206
            -- upvalues: v4 (copy), v5 (copy), t2 (copy), v7 (ref), t3 (copy), n1 (ref)
            local v46 = n1

            for v47, v48 in t3 do
                local Label = v48.Label

                if v47 <= v46 then
                    Label.TextColor3 = v4
                else
                    Label.TextColor3 = v5
                end
            end

            local v49 = v7

            if v46 > 0 then
                v49.Text = t2[v46]
            else
                v49.Text = "Tap a star to rate"
            end
        end)
        TextButton.SelectionGained:Connect(function() -- line: 209
            -- upvalues: i (copy), v4 (copy), v5 (copy), t2 (copy), v7 (ref), t3 (copy), n1 (ref)
            local v50 = i or n1

            for v51, v52 in t3 do
                local Label = v52.Label

                if v51 <= v50 then
                    Label.TextColor3 = v4
                else
                    Label.TextColor3 = v5
                end
            end

            local v53 = v7

            if v50 > 0 then
                v53.Text = t2[v50]
            else
                v53.Text = "Tap a star to rate"
            end
        end)
        t3[i] = TextButton
    end

    local v54 = v36 + 88

    v7 = Style.text(v33, "", {
        Name = "Caption",
        Position = UDim2.fromOffset(26, v54),
        Size = UDim2.new(1, -52, 0, 30),
        TextColor3 = Style.SAND
    })

    local v55 = v54 + 42

    Kit.text(v33, "What's it about?", {
        Position = UDim2.fromOffset(26, v55),
        Size = UDim2.new(1, -52, 0, 36)
    })

    local v56 = v55 + 42

    for v57, v58 in Config.FeedbackTopics do
        local v59 = (v57 - 1) % 3
        local v60 = (v57 - 1) // 3

        t4[v58] = Kit.button(v33, v58, v6, {
            Name = "Topic" .. v57,
            Position = UDim2.fromOffset(26 + v59 * 260, v56 + v60 * 66),
            Size = UDim2.fromOffset(248, 54)
        }, function() -- line: 235
            -- upvalues: v58 (copy), TEAL (copy), v6 (copy), t4 (copy), v10 (ref)
            v10 = if v10 == v58 then nil else v58

            for v61, v62 in t4 do
                if v61 == v10 then
                    v62.BackgroundColor3 = TEAL
                else
                    v62.BackgroundColor3 = v6
                end
            end
        end)
    end

    local v63 = v56 + ((v2 - 1) * 66 + 72)
    local v64 = Kit.frame(v33, {
        Name = "NoteBox",
        BackgroundColor3 = Style.DEEP,
        Position = UDim2.fromOffset(26, v63),
        Size = UDim2.new(1, -52, 0, 140)
    })

    Kit.corner(v64, 14)
    Kit.stroke(v64, 4)
    TextBox = Instance.new("TextBox")
    TextBox.Name = "Note"
    TextBox.BackgroundTransparency = 1

    local TextBox2 = TextBox

    TextBox2.Position = UDim2.fromOffset(16, 12)

    local TextBox3 = TextBox

    TextBox3.Size = UDim2.new(1, -32, 1, -44)

    local TextBox4 = TextBox

    TextBox4.FontFace = Config.Font
    TextBox.TextSize = 28

    local TextBox5 = TextBox

    TextBox5.TextColor3 = Color3.new(1, 1, 1)
    TextBox.PlaceholderText = "Tell us more... (optional)"

    local TextBox6 = TextBox

    TextBox6.PlaceholderColor3 = Color3.fromRGB(140, 150, 175)
    TextBox.Text = ""
    TextBox.TextWrapped = true
    TextBox.MultiLine = true
    TextBox.ClearTextOnFocus = false

    local TextBox7 = TextBox

    TextBox7.TextXAlignment = Enum.TextXAlignment.Left

    local TextBox8 = TextBox

    TextBox8.TextYAlignment = Enum.TextYAlignment.Top
    TextBox.Parent = v64
    v8 = Kit.text(v64, "", {
        Name = "Counter",
        StrokeThickness = 2,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -12, 1, -6),
        Size = UDim2.fromOffset(110, 26),
        TextColor3 = Color3.fromRGB(160, 170, 195),
        TextXAlignment = Enum.TextXAlignment.Right
    })
    TextBox:GetPropertyChangedSignal("Text"):Connect(function() -- line: 276
        -- upvalues: Config (copy), TextBox (ref), v8 (ref)
        local v65 = utf8.len(TextBox.Text) or 0

        if Config.FeedbackMaxText < v65 then
            TextBox.Text = TextBox.Text:sub(1, utf8.offset(TextBox.Text, Config.FeedbackMaxText + 1) - 1)
        else
            v8.Text = ("%*/%*"):format(v65, Config.FeedbackMaxText)
        end
    end)

    local v67 = v8

    v67.Text = ("0/%*"):format(Config.FeedbackMaxText)

    local v68 = v63 + 158

    v9 = Kit.button(v33, "SEND ✉️", Style.GREY, {
        Name = "Send",
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, v68),
        Size = UDim2.fromOffset(320, 78)
    }, function() -- line: 292
        -- upvalues: send (copy)
        task.spawn(send)
    end)

    local ScreenGui3 = ScreenGui

    ScreenGui3.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local function buildBanner() -- line: 299
    -- upvalues: Kit (copy), Style (copy), LocalPlayer (copy), ScreenGui2 (ref)
    ScreenGui2 = Instance.new("ScreenGui")
    ScreenGui2.Name = "FeedbackBanner"
    ScreenGui2.ResetOnSpawn = false
    ScreenGui2.DisplayOrder = 50
    ScreenGui2.Enabled = false
    ScreenGui2.IgnoreGuiInset = true

    local v69 = Kit.frame(ScreenGui2, {
        Name = "Strip",
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0, 6),
        Size = UDim2.new(0.62, 0, 0, 46),
        BackgroundColor3 = Color3.new(1, 1, 1)
    })

    Kit.corner(v69, 14)
    Kit.stroke(v69, 4)
    Style.gradient(v69, ColorSequence.new(Style.TEAL, Style.OCEAN), 0)

    local UISizeConstraint = Instance.new("UISizeConstraint")

    UISizeConstraint.MaxSize = Vector2.new(700, 1e999)
    UISizeConstraint.Parent = v69
    Kit.text(v69, "💬 Leaving? Send us feedback so we can make the game better!", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, -20, 0, 30)
    })

    local ScreenGui = ScreenGui2

    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

function t1.isOpen() -- line: 328
    -- upvalues: ScreenGui (ref)
    return ScreenGui ~= nil and ScreenGui.Enabled
end

function t1.open(p2) -- line: 333
    -- upvalues: GuiService (copy), UserInputService (copy), UIUtil (copy), Style (copy), t1 (copy), v4 (copy), v5 (copy), t2 (copy), ScreenGui (ref), ScreenGui2 (ref), v7 (ref), v9 (ref), t3 (copy), n1 (ref), v11 (ref), v12 (ref)
    v11 = p2 or "Button"
    ScreenGui2.Enabled = v11 == "Menu"

    if t1.isOpen() then
        return
    end

    local v70 = n1

    for v71, v72 in t3 do
        local Label = v72.Label

        if v71 <= v70 then
            Label.TextColor3 = v4
        else
            Label.TextColor3 = v5
        end
    end

    local v73 = v7

    if v70 > 0 then
        v73.Text = t2[v70]
    else
        v73.Text = "Tap a star to rate"
    end

    local v74 = v9

    if not (n1 > 0) or v12 then
        v74.BackgroundColor3 = Style.GREY
    else
        v74.BackgroundColor3 = Style.BUY
    end

    v9.Label.Text = v12 and "SENDING..." or "SEND ✉️"
    UIUtil.openPanel(ScreenGui)

    if UserInputService:GetLastInputType().Name:find("^Gamepad") ~= nil then
        GuiService.SelectedObject = t3[3]
    end
end

function t1.close() -- line: 348
    -- upvalues: GuiService (copy), UIUtil (copy), ScreenGui (ref), ScreenGui2 (ref), TextBox (ref)
    ScreenGui2.Enabled = false

    local SelectedObject = GuiService.SelectedObject

    if SelectedObject and SelectedObject:IsDescendantOf(ScreenGui) then
        GuiService.SelectedObject = nil
    end

    TextBox:ReleaseFocus()
    UIUtil.closePanel(ScreenGui)
end

function t1.setBusyCheck(p3) -- line: 359
    -- upvalues: v15 (ref)
    v15 = p3
end

function t1.init(p4) -- line: 364
    -- upvalues: GuiService (copy), Style (copy), t1 (copy), v4 (copy), v5 (copy), t2 (copy), TEAL (copy), v6 (copy), v7 (ref), TextBox (ref), v9 (ref), t3 (copy), t4 (copy), n1 (ref), v10 (ref), v12 (ref), v13 (ref), v14 (ref), v15 (ref), build (copy), buildBanner (copy)
    build()
    buildBanner()
    n1 = 0
    v10 = nil
    TextBox.Text = ""

    local v75 = n1

    for v76, v77 in t3 do
        local Label = v77.Label

        if v76 <= v75 then
            Label.TextColor3 = v4
        else
            Label.TextColor3 = v5
        end
    end

    local v78 = v7

    if v75 > 0 then
        v78.Text = t2[v75]
    else
        v78.Text = "Tap a star to rate"
    end

    for v79, v80 in t4 do
        if v79 == v10 then
            v80.BackgroundColor3 = TEAL
        else
            v80.BackgroundColor3 = v6
        end
    end

    local v81 = v9

    if not (n1 > 0) or v12 then
        v81.BackgroundColor3 = Style.GREY
    else
        v81.BackgroundColor3 = Style.BUY
    end

    v9.Label.Text = v12 and "SENDING..." or "SEND ✉️"
    GuiService.MenuOpened:Connect(function() -- line: 369
        -- upvalues: p4 (copy), t1 (copy), v13 (ref), v14 (ref), v15 (ref)
        if v14 or v13 or t1.isOpen() or v15() then
            return
        end

        v14 = true
        p4("Menu")
    end)
end

return t1
