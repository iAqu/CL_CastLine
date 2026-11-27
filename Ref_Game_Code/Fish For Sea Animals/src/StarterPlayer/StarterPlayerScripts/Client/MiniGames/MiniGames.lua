-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Kit = require(script.Parent.Kit)
local Podium = require(script.Parent.Podium)
local LocalPlayer = Players.LocalPlayer
local t1 = {
    require(script.Parent.BlockBlast),
    require(script.Parent.WaterSort),
    require(script.Parent.SeaMerge)
}
local t2 = {}
local ScreenGui, clone, Header, Body, clone2, clone3
local t3 = {}
local v1 = nil
local n1 = 0
local v2 = Color3.fromRGB(140, 255, 120)

local function setTitle(p1) -- line: 31
    -- upvalues: Header (ref)
    Header.Title.Text = p1
end

local function setCount(p2) -- line: 35
    -- upvalues: Header (ref)
    Header.Count.Text = p2
end

local function bestOf(p3) -- line: 39
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("MG_" .. p3.Id) or 0
end

local function clearBody() -- line: 44
    -- upvalues: Body (ref), v1 (ref), n1 (ref)
    n1 += 1

    if v1 then
        v1.area.Visible = false
        v1.setPaused(true)
        v1 = nil
    end

    for _, child in Body:GetChildren() do
        if child:IsA("GuiObject") and child.Name ~= "Studs" and not child:GetAttribute("Session") then
            child:Destroy()
        end
    end
end

local t4 = {}

local function sendBest(p4, p5) -- line: 69
    -- upvalues: Remotes (copy), t4 (copy)
    t4[p4.Id] = p5
    task.delay(1, function() -- line: 71
        -- upvalues: p4 (copy), p5 (copy), Remotes (copy), t4 (copy)
        if t4[p4.Id] ~= p5 then
            return
        end

        t4[p4.Id] = nil
        Remotes.MiniGameScore:FireServer(p4.Id, p5)
    end)
end

local function play(p6) -- line: 79
    -- upvalues: Remotes (copy), UIUtil (copy), Kit (copy), LocalPlayer (copy), Header (ref), Body (ref), clone2 (ref), t3 (copy), v1 (ref), clearBody (copy), t4 (copy)
    clearBody()

    local Name = p6.Name

    Header.Title.Text = Name
    clone2.Visible = true

    local v3 = t3[p6.Id]

    local function showScore() -- line: 84
        -- upvalues: p6 (copy), v3 (ref), LocalPlayer (copy), Header (ref)
        local v5 = ("Score: %*   Best: %*"):format(v3.score, (math.max(LocalPlayer:GetAttribute("MG_" .. p6.Id) or 0, v3.best)))

        Header.Count.Text = v5
    end

    if v3 then
        v3.area.Visible = true
        v3.setPaused(false)
    else
        local v6 = Kit.frame(Body, {
            BackgroundTransparency = 1,
            Name = p6.Id,
            Size = UDim2.fromScale(1, 1)
        })

        v6:SetAttribute("Session", true)
        v3 = {
            score = 0,
            best = 0,
            area = v6
        }
        t3[p6.Id] = v3

        local function report(p7) -- line: 99
            -- upvalues: p6 (copy), v3 (ref), Remotes (copy), UIUtil (copy), LocalPlayer (copy), Header (ref), v1 (ref), t4 (copy)
            v3.score = p7

            if p7 == 0 then
                v3.cheered = false
            end

            local v8 = math.max(LocalPlayer:GetAttribute("MG_" .. p6.Id) or 0, v3.best)

            if v8 < p7 then
                if v8 > 0 and not v3.cheered then
                    v3.cheered = true
                    UIUtil.sound("GoodCast", 0.6, 1.2)
                    UIUtil.toast(("🏆 New best in %*!"):format(p6.Name), "purchase")
                    UIUtil.pop(Header.Count, 1.4)
                end

                v3.best = p7
                t4[p6.Id] = p7
                task.delay(1, function() -- line: 71
                    -- upvalues: p7 (copy), p6 (copy), Remotes (copy), t4 (copy)
                    if t4[p6.Id] ~= p7 then
                        return
                    end

                    t4[p6.Id] = nil
                    Remotes.MiniGameScore:FireServer(p6.Id, p7)
                end)
            end

            if v1 ~= v3 then
                return
            end

            local v10 = ("Score: %*   Best: %*"):format(v3.score, (math.max(LocalPlayer:GetAttribute("MG_" .. p6.Id) or 0, v3.best)))

            Header.Count.Text = v10
        end

        local v11, v12 = p6.start(v6, report)
        local v13 = v3

        v13.stop = v11
        v13.setPaused = v12 or function() -- line: 123
        end
    end

    v1 = v3

    local v15 = ("Score: %*   Best: %*"):format(v3.score, (math.max(LocalPlayer:GetAttribute("MG_" .. p6.Id) or 0, v3.best)))

    Header.Count.Text = v15
end

local showBoard

local function showPicker() -- line: 132
    -- upvalues: UIUtil (copy), Kit (copy), LocalPlayer (copy), t1 (copy), Header (ref), Body (ref), clone2 (ref), t3 (copy), v1 (ref), v2 (copy), clearBody (copy), play (copy), showBoard (ref)
    if v1 then
        UIUtil.toast("Game saved! Come back any time to keep playing 🎮", "success")
    end

    clearBody()
    Header.Title.Text = "Mini Games"
    Header.Count.Text = ""
    clone2.Visible = false

    for v16, v17 in t1 do
        local v18 = t3[v17.Id] ~= nil
        local v19 = Kit.frame(Body, {
            Name = v17.Id,
            BackgroundColor3 = v17.Color,
            Position = UDim2.fromOffset(22 + (v16 - 1) * 254, 22),
            Size = UDim2.new(0, 236, 1, -44)
        })

        Kit.corner(v19, 14)
        Kit.stroke(v19, 4)
        Kit.shade(v19, 0.6)
        Kit.studs(v19, 0.35, 44, 14)

        local v20 = Kit.frame(v19, {
            BackgroundTransparency = 0.7,
            BackgroundColor3 = Color3.new(0, 0, 0),
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 18),
            Size = UDim2.fromOffset(170, 170)
        })

        Kit.corner(v20, 85)
        Kit.text(v20, v17.Icon, {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.72, 0.72)
        }).UIStroke.Enabled = false
        Kit.text(v19, v17.Name, {
            StrokeThickness = 4,
            Position = UDim2.fromOffset(10, 200),
            Size = UDim2.new(1, -20, 0, 48)
        })
        Kit.text(v19, ("Best: %*"):format(LocalPlayer:GetAttribute("MG_" .. v17.Id) or 0), {
            Position = UDim2.fromOffset(10, 256),
            Size = UDim2.new(1, -20, 0, 34),
            TextColor3 = Color3.fromRGB(255, 225, 90)
        })

        if v18 then
            Kit.text(v19, "✔ Game saved", {
                Position = UDim2.fromOffset(10, 298),
                Size = UDim2.new(1, -20, 0, 30),
                TextColor3 = v2
            })
        end

        Kit.button(v19, "🏆 LEADERBOARD", Color3.fromRGB(255, 190, 40), {
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, 0, 1, -112),
            Size = UDim2.new(1, -36, 0, 62)
        }, function() -- line: 186
            -- upvalues: v17 (copy), showBoard (ref)
            showBoard(v17)
        end)
        Kit.button(v19, if v18 then "CONTINUE" else "PLAY", Color3.fromRGB(110, 225, 60), {
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, 0, 1, -18),
            Size = UDim2.new(1, -36, 0, 80)
        }, function() -- line: 193
            -- upvalues: v17 (copy), play (copy)
            play(v17)
        end)
    end
end

function showBoard(p8) -- line: 200
    -- upvalues: Remotes (copy), Kit (copy), Podium (copy), LocalPlayer (copy), Header (ref), Body (ref), clone2 (ref), n1 (ref), clearBody (copy)
    clearBody()

    local Name = p8.Name

    Header.Title.Text = Name
    Header.Count.Text = "🏆 Top 10"
    clone2.Visible = true

    local v21 = n1
    local v22 = Kit.text(Body, "Loading...", {
        Name = "Loading",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(300, 50)
    })

    task.spawn(function() -- line: 212
        -- upvalues: p8 (copy), v21 (copy), v22 (copy), Remotes (copy), Kit (copy), Podium (copy), LocalPlayer (copy), Body (ref), n1 (ref)
        local InvokeServer = Remotes.MiniGameBoard.InvokeServer
        local MiniGameBoard = Remotes.MiniGameBoard
        local Id = p8.Id
        local ok, result = pcall(InvokeServer, MiniGameBoard, Id)

        if n1 == v21 then
            v22:Destroy()

            if not ok or type(result) ~= "table" then
                Kit.text(Body, "Couldn't load the leaderboard, try again!", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromOffset(560, 44)
                })
            else
                Podium.build(Body, result.Top, math.max(result.Mine or 0, LocalPlayer:GetAttribute("MG_" .. p8.Id) or 0), p8.Color)
            end
        end
    end)
end

function t2.isOpen() -- line: 230
    -- upvalues: ScreenGui (ref)
    return ScreenGui ~= nil and ScreenGui.Enabled
end

function t2.open() -- line: 234
    -- upvalues: UIUtil (copy), ScreenGui (ref), showPicker (copy)
    showPicker()
    UIUtil.openPanel(ScreenGui)
end

function t2.close() -- line: 239
    -- upvalues: UIUtil (copy), t2 (copy), ScreenGui (ref), v1 (ref), clearBody (copy)
    if not t2.isOpen() then
        return
    end

    if v1 then
        UIUtil.toast("Game saved! Come back any time to keep playing 🎮", "success")
    end

    clearBody()
    UIUtil.closePanel(ScreenGui)
end

function t2.setAvailable(p9) -- line: 249
    -- upvalues: UIUtil (copy), t2 (copy), clone3 (ref)
    if not p9 or clone3.Visible then
        if not p9 then
            clone3.Visible = false
            task.spawn(t2.close)
        end
    else
        clone3.Visible = true
        UIUtil.pop(clone3, 0.6)
    end
end

local function buildGui() -- line: 259
    -- upvalues: UIUtil (copy), t2 (copy), ScreenGui (ref), clone (ref), Header (ref), Body (ref), clone2 (ref), showPicker (copy)
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MiniGames"
    ScreenGui.ResetOnSpawn = false

    local ScreenGui2 = ScreenGui

    ScreenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 5
    ScreenGui.Enabled = false
    clone = UIUtil.gui("RebirthPanel"):WaitForChild("Panel"):Clone()

    local clone3 = clone

    clone3.Size = UDim2.fromOffset(820, 700)
    Header = clone.Header
    Header.UIGradient.Color = ColorSequence.new(Color3.fromRGB(110, 80, 255), Color3.fromRGB(80, 175, 255))
    Body = clone.Body

    for _, child in Body:GetChildren() do
        if child:IsA("GuiObject") and child.Name ~= "Studs" then
            child:Destroy()
        end
    end

    local Count = Header.Count

    Count.AnchorPoint = Vector2.new(1, 0.5)
    Count.Position = UDim2.new(1, -192, 0.5, 0)
    Count.Size = UDim2.fromOffset(300, 36)
    Count.TextXAlignment = Enum.TextXAlignment.Right
    clone2 = Header.Close:Clone()
    clone2.Name = "Back"

    local clone4 = clone2

    clone4.Position = Header.Close.Position - UDim2.fromOffset(92, 0)

    local clone5 = clone2

    clone5.BackgroundColor3 = Color3.fromRGB(60, 140, 255)
    clone2.Label.Text = "<"
    clone2.Parent = Header
    clone.Parent = ScreenGui

    local ScreenGui3 = ScreenGui

    ScreenGui3.Parent = UIUtil.gui("HUD").Parent
    UIUtil.bindButton(Header.Close, function() -- line: 289
        -- upvalues: t2 (copy)
        task.spawn(t2.close)
    end)
    UIUtil.bindButton(clone2, showPicker)
end

local function buildHudButton() -- line: 295
    -- upvalues: UIUtil (copy), t2 (copy), clone3 (ref)
    local LeftButtons = UIUtil.gui("HUD"):WaitForChild("LeftButtons")

    clone3 = LeftButtons:WaitForChild("ExitButton"):Clone()
    clone3.Name = "MiniGamesButton"

    local clone = clone3

    clone.Position = UDim2.new(0, 0, -1, -14)

    local clone2 = clone3

    clone2.BackgroundColor3 = Color3.fromRGB(140, 90, 255)
    clone3.Label.Text = "🎮 GAMES"
    clone3.Visible = false
    clone3.Parent = LeftButtons
    UIUtil.bindButton(clone3, function() -- line: 304
        -- upvalues: t2 (copy)
        if t2.isOpen() then
            task.spawn(t2.close)
        else
            t2.open()
        end
    end)
end

function t2.init() -- line: 313
    -- upvalues: buildGui (copy), buildHudButton (copy)
    buildGui()
    buildHudButton()
end

return t2
