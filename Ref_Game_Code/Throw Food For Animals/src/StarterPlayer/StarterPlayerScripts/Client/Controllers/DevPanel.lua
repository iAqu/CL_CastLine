-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReleaseConfig = require(ReplicatedStorage.Config.ReleaseConfig)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Parent = script.Parent
local UIKit = require(Parent.UIKit)
local t1 = {}
local LocalPlayer = Players.LocalPlayer
local t2 = {
    Color3.fromRGB(255, 170, 40),
    Color3.fromRGB(235, 110, 20)
}
local t3 = {
    Color3.fromRGB(170, 110, 255),
    Color3.fromRGB(110, 60, 220)
}
local t4 = {
    Color3.fromRGB(110, 230, 90),
    Color3.fromRGB(40, 170, 60)
}
local t5 = {
    Color3.fromRGB(120, 120, 130),
    Color3.fromRGB(80, 80, 90)
}
local t6 = {
    Color3.fromRGB(70, 220, 210),
    Color3.fromRGB(20, 150, 160)
}

local function build(p1) -- line: 44
    -- upvalues: ReleaseConfig (copy), Remotes (copy), Parent (copy), UIKit (copy), LocalPlayer (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy)
    local v1 = UIKit.ScreenGui("DevPanel", 40, true)

    if p1 then
        UIKit.Text({
            Name = "DevTag",
            Text = "DEV SERVER - test saves",
            MaxTextSize = 18,
            Parent = v1,
            Size = UDim2.new(0.4, 0, 0, 20),
            Position = UDim2.new(0.5, 0, 0, 6),
            AnchorPoint = Vector2.new(0.5, 0),
            Color = Color3.fromRGB(255, 200, 80)
        })
    end

    if not ReleaseConfig.IsDeveloper(LocalPlayer) then
        return
    end

    local v2 = workspace:GetAttribute("NewAnimalsServer") == true
    local v3 = not v2 and workspace:GetAttribute("ReservedNoNote") == true

    if v3 then
        UIKit.Text({
            Name = "NoNoteTag",
            Text = "RESERVED SERVER",
            MaxTextSize = 18,
            Parent = v1,
            Size = UDim2.new(0.4, 0, 0, 20),
            Position = UDim2.new(0.5, 0, 0, p1 and 28 or 6),
            AnchorPoint = Vector2.new(0.5, 0),
            Color = Color3.fromRGB(255, 200, 80)
        })
    end

    if v2 then
        UIKit.Text({
            Name = "NewAnimalsTag",
            Text = "NEW ANIMALS SERVER",
            MaxTextSize = 18,
            Parent = v1,
            Size = UDim2.new(0.4, 0, 0, 20),
            Position = UDim2.new(0.5, 0, 0, p1 and 28 or 6),
            AnchorPoint = Vector2.new(0.5, 0),
            Color = Color3.fromRGB(120, 240, 230)
        })
    end

    local Frame = Instance.new("Frame")

    Frame.Name = "Holder"
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(0, 190, 0, 300)
    Frame.Position = UDim2.new(1, -12, 0, 64)
    Frame.AnchorPoint = Vector2.new(1, 0)
    Frame.Parent = v1

    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Name = "List"
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Size = UDim2.new(1, 0, 1, -48)
    ScrollingFrame.Position = UDim2.new(0, 0, 0, 48)
    ScrollingFrame.CanvasSize = UDim2.new()
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.ScrollBarThickness = 4
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollingFrame.Visible = false
    ScrollingFrame.Parent = Frame

    local UISizeConstraint = Instance.new("UISizeConstraint")

    UISizeConstraint.Parent = Frame

    local function fitHeight() -- line: 100
        -- upvalues: UISizeConstraint (copy)
        local CurrentCamera = workspace.CurrentCamera
        local Y = CurrentCamera and CurrentCamera.ViewportSize.Y or 600

        UISizeConstraint.MaxSize = Vector2.new(1e999, (math.max(140, Y - 64 - 20)))
    end

    local CurrentCamera = workspace.CurrentCamera
    local Y = CurrentCamera and CurrentCamera.ViewportSize.Y or 600

    UISizeConstraint.MaxSize = Vector2.new(1e999, (math.max(140, Y - 64 - 20)))

    if workspace.CurrentCamera then
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitHeight)
    end

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.Padding = UDim.new(0, 6)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ScrollingFrame

    local v6 = false

    local function action(p2, p3) -- line: 114
        -- upvalues: v6 (ref), Remotes (copy)
        if v6 then
            return
        end

        v6 = true

        local Invoke = Remotes.Invoke
        local ok, result = pcall(Invoke, "Dev_Action", p2, p3)

        v6 = false

        if ok and type(result) == "table" and result.Ok then
            return
        end

        local _warn = warn
        local v7, v8

        if ok and type(result) == "table" then
            local Reason = result.Reason

            if Reason then
                v7 = Reason
                v8 = true
            else
                v8 = false
            end
        else
            v8 = false
        end

        if not v8 then
            v7 = result
        end

        _warn("[DevPanel] " .. p2 .. " failed: " .. tostring(v7))
    end

    local n1 = 0

    local function addButton(p4, p5, p6) -- line: 125
        -- upvalues: ScrollingFrame (copy), n1 (ref), UIKit (copy)
        n1 += 1

        local v9, v10 = UIKit.Button({
            Name = "Dev" .. n1,
            Parent = ScrollingFrame,
            Text = p4,
            Colors = p5,
            Size = UDim2.new(1, 0, 0, 40),
            OnClick = p6
        })

        v9.LayoutOrder = n1

        return v9, v10
    end

    local function addConfirmButton(p7, p8, p9) -- line: 136
        -- upvalues: ScrollingFrame (copy), addButton (copy)
        local n2 = 0
        local v11
        local v12, v13 = addButton(p7, p8, function() -- line: 140
            -- upvalues: p7 (copy), p9 (copy), n2 (ref), v11 (ref), ScrollingFrame (copy)
            if os.clock() < n2 then
                n2 = 0
                v11.Text = p7
                ScrollingFrame.Visible = false
                p9()
            else
                n2 = os.clock() + 4
                v11.Text = "Tap again: all rejoin"
                task.delay(4, function() -- line: 150
                    -- upvalues: p7 (copy), n2 (ref), v11 (ref)
                    if os.clock() >= n2 and v11.Parent then
                        v11.Text = p7
                    end
                end)
            end
        end)

        v11 = v13

        return v12
    end

    local function addNewAnimalButtons() -- line: 158
        -- upvalues: v2 (copy), v3 (copy), ScrollingFrame (copy), action (copy), addButton (copy), UIKit (copy), LocalPlayer (copy), t2 (copy), t5 (copy), t6 (copy)
        if v2 then
            local function v14() -- line: 160
                -- upvalues: action (copy)
                action("NormalServer")
            end

            local n3 = 0
            local v15
            local v16 = "Normal Animals (all rejoin)"
            local _, v17 = addButton("Normal Animals (all rejoin)", t2, function() -- line: 140
                -- upvalues: v14 (copy), n3 (ref), v15 (ref), v16 (copy), ScrollingFrame (copy)
                if os.clock() < n3 then
                    n3 = 0
                    v15.Text = v16
                    ScrollingFrame.Visible = false
                    v14()
                else
                    n3 = os.clock() + 4
                    v15.Text = "Tap again: all rejoin"
                    task.delay(4, function() -- line: 150
                        -- upvalues: n3 (ref), v15 (ref), v16 (copy)
                        if os.clock() >= n3 and v15.Parent then
                            v15.Text = v16
                        end
                    end)
                end
            end)

            v15 = v17

            return 1
        end

        local v18 = 2

        if v3 then
            local function v19() -- line: 165
                -- upvalues: action (copy)
                action("NormalServer")
            end

            local n4 = 0
            local v20
            local v21 = "Normal Servers (all rejoin)"
            local _, v22 = addButton("Normal Servers (all rejoin)", t2, function() -- line: 140
                -- upvalues: v19 (copy), n4 (ref), v20 (ref), v21 (copy), ScrollingFrame (copy)
                if os.clock() < n4 then
                    n4 = 0
                    v20.Text = v21
                    ScrollingFrame.Visible = false
                    v19()
                else
                    n4 = os.clock() + 4
                    v20.Text = "Tap again: all rejoin"
                    task.delay(4, function() -- line: 150
                        -- upvalues: n4 (ref), v20 (ref), v21 (copy)
                        if os.clock() >= n4 and v20.Parent then
                            v20.Text = v21
                        end
                    end)
                end
            end)

            v20 = v22
            v18 = 3
        end

        local function v23() -- line: 168
            -- upvalues: action (copy)
            action("NewAnimalsServer")
        end

        local n5 = 0
        local v24
        local v25 = "New Animals Server (all rejoin)"
        local _, v26 = addButton("New Animals Server (all rejoin)", t6, function() -- line: 140
            -- upvalues: v23 (copy), n5 (ref), v24 (ref), v25 (copy), ScrollingFrame (copy)
            if os.clock() < n5 then
                n5 = 0
                v24.Text = v25
                ScrollingFrame.Visible = false
                v23()
            else
                n5 = os.clock() + 4
                v24.Text = "Tap again: all rejoin"
                task.delay(4, function() -- line: 150
                    -- upvalues: n5 (ref), v24 (ref), v25 (copy)
                    if os.clock() >= n5 and v24.Parent then
                        v24.Text = v25
                    end
                end)
            end
        end)

        v24 = v26

        local v27, v28 = addButton("See New Animals: OFF", t5, function() -- line: 170
            -- upvalues: action (copy), LocalPlayer (copy)
            action("SeeNewAnimals", LocalPlayer:GetAttribute("SeeNewAnimals") ~= true)
        end)

        local function showView() -- line: 173
            -- upvalues: v27 (copy), v28 (copy), UIKit (copy), LocalPlayer (copy), t5 (copy), t6 (copy)
            local v29 = LocalPlayer:GetAttribute("SeeNewAnimals") == true

            v28.Text = v29 and "See New Animals: ON" or "See New Animals: OFF"
            UIKit.SetButtonColors(v27, v29 and t6 or t5)
        end

        LocalPlayer:GetAttributeChangedSignal("SeeNewAnimals"):Connect(showView)

        local v30 = LocalPlayer:GetAttribute("SeeNewAnimals") == true

        v28.Text = v30 and "See New Animals: ON" or "See New Animals: OFF"
        UIKit.SetButtonColors(v27, v30 and t6 or t5)

        return v18
    end

    UIKit.Button({
        Name = "DevToggle",
        Text = "DEV",
        Parent = Frame,
        Colors = t2,
        Size = UDim2.new(0, 84, 0, 40),
        Position = UDim2.new(1, 0, 0, 0),
        AnchorPoint = Vector2.new(1, 0),
        OnClick = function() -- OnClick | line: 186
            -- upvalues: ScrollingFrame (copy)
            ScrollingFrame.Visible = not ScrollingFrame.Visible
        end
    })

    if p1 then
        task.spawn(function() -- line: 198
            -- upvalues: Frame (copy), ScrollingFrame (copy), action (copy), addButton (copy), addNewAnimalButtons (copy), ReleaseConfig (copy), Remotes (copy), Parent (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy)
            local Invoke = Remotes.Invoke
            local Areas, Areas2 = pcall(Invoke, "Dev_Action", "Areas")
            local v31, v32

            if Areas and type(Areas2) == "table" then
                local Areas = Areas2.Areas

                if Areas then
                    v31 = Areas
                    v32 = true
                else
                    v32 = false
                end
            else
                v32 = false
            end

            if not v32 then
                v31 = {}
            end

            for _, v33 in ipairs(v31) do
                addButton("Go to " .. v33.Name, t3, function() -- line: 202
                    -- upvalues: v33 (copy), action (copy)
                    action("Jump", v33.Key)
                end)
            end

            addButton("Money x100", t4, function() -- line: 204
                -- upvalues: action (copy)
                action("Money")
            end)
            addButton("Max Throw Power", t5, function() -- line: 205
                -- upvalues: action (copy)
                action("MaxPower")
            end)

            local ReleaseShow = require(Parent.ReleaseShow)
            local n6 = 0

            for v35 in pairs(ReleaseConfig.Show) do
                local v36 = n6

                for _, v37 in ipairs({ "Cutscene", "Big", "Small" }) do
                    v36 += 1
                    n6 = v36
                    addButton("Test Release: " .. v37, t3, function() -- line: 212
                        -- upvalues: ReleaseShow (copy), v37 (copy), v35 (copy), ScrollingFrame (copy)
                        ScrollingFrame.Visible = false
                        task.spawn(ReleaseShow.Test, v35, v37)
                    end)
                end
            end

            local v39 = addNewAnimalButtons()

            addButton("Back to Normal Server", t2, function() -- line: 219
                -- upvalues: action (copy)
                action("Leave")
            end)
            Frame.Size = UDim2.new(0, 190, 0, 48 + (#v31 + 3 + n6 + v39) * 46)
        end)
    else
        addButton("Open Dev Server", t3, function() -- line: 191
            -- upvalues: action (copy)
            action("OpenDevServer")
        end)

        local v40 = addNewAnimalButtons()

        Frame.Size = UDim2.new(0, 190, 0, 48 + (1 + v40) * 46)
    end
end

function t1.Init() -- line: 224
    -- upvalues: ReleaseConfig (copy), LocalPlayer (copy), build (copy)
    local v41 = ReleaseConfig.IsDevServer()

    if v41 or ReleaseConfig.IsDeveloper(LocalPlayer) then
        build(v41)

        if ReleaseConfig.IsDeveloper(LocalPlayer) then
            local function rebuild() -- line: 230
                -- upvalues: v41 (copy), LocalPlayer (copy), build (copy)
                local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
                local DevPanel = PlayerGui and PlayerGui:FindFirstChild("DevPanel")

                if DevPanel then
                    DevPanel:Destroy()
                end

                build(v41)
            end

            workspace:GetAttributeChangedSignal("NewAnimalsServer"):Connect(rebuild)
            workspace:GetAttributeChangedSignal("ReservedNoNote"):Connect(rebuild)
        end
    end
end

return t1
