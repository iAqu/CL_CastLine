-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local CosmicEvent = require(Shared.Data.CosmicEvent)
local Events = require(Shared.Data.Events)
local Zones = require(Shared.Data.Zones)
local UIKit = require(script.Parent.UIKit)
local TopBar = require(script.Parent.TopBar)
local Toasts = require(script.Parent.Toasts)
local LocalPlayer = Players.LocalPlayer
local fromRGB = Color3.fromRGB
local Colors = UIKit.Colors
local Left = Enum.TextXAlignment.Left
local v1 = Font.fromEnum(Enum.Font.LuckiestGuy)
local v2, v3, v4
local t2 = {
    CosmicEvent.LENGTH / 60,
    30, 10
}
local v5 = t2[1]
local t3 = {}
local v6 = false
local n1 = 0
local t1 = {}

t1.LastReply = nil

local function fmt(p1) -- line: 30
    return string.format("%d:%02d", math.floor(p1 / 60), (math.floor(p1 % 60)))
end

local t4 = {
    intro = "the opening",
    hunt = "THE FLOOD",
    battle = "KHAOS vs SERAPHION",
    cosmic = "COSMIC STORM",
    ending = "ending"
}

local function showStatus(p2) -- line: 35
    -- upvalues: v3 (ref), fmt (copy), t4 (copy)
    if not v3 or type(p2) ~= "table" then
        return
    end

    if not p2.on then
        v3.Text = "Status: <font color=\"#9AA0B4\">not running</font>"

        return
    end

    local v10 = "Status: <font color=\"#B48CFF\">%s</font>   %s left"
    local v11 = t4[p2.phase]

    if not v11 then
        v11 = tostring(p2.phase)
    end

    local v12 = v10:format(v11, fmt(p2.left or 0))
    local v13

    if p2.phase == "intro" or p2.phase == "hunt" then
        local v14 = p2.battleIn or 0

        v13 = v12 .. ("   (the fight in %s)\nDrops: %d let go, %d taken, %d out now"):format(string.format("%d:%02d", math.floor(v14 / 60), (math.floor(v14 % 60))), p2.laid or 0, p2.taken or 0, p2.live or 0)
    else
        v13 = if p2.phase == "battle" then v12 .. ("\nBets: Khaos %d, Seraphion %d"):format(p2.betsK or 0, p2.betsS or 0) else v12 .. ("\nBeams fired: %d   Fish turned Cosmic: %d"):format(p2.beams or 0, p2.mutated or 0)
    end

    v3.Text = v13
end

local function call(p3, p4) -- line: 54
    -- upvalues: ReplicatedStorage (copy), Toasts (copy), t1 (copy), v6 (ref), showStatus (copy)
    if v6 then
        return
    end

    v6 = true
    task.spawn(function() -- line: 59
        -- upvalues: p3 (copy), p4 (copy), ReplicatedStorage (copy), Toasts (copy), t1 (copy), v6 (ref), showStatus (copy)
        local function v18() -- line: 60
            -- upvalues: p3 (copy), p4 (copy), ReplicatedStorage (copy)
            return ReplicatedStorage.Remotes.CosmicAdmin:InvokeServer(p3, p4)
        end

        local ok, result = pcall(v18)

        v6 = false
        t1.LastReply = if ok then result else nil

        if not ok or type(result) ~= "table" then
            Toasts.Show("error", "The server did not answer")
        else
            showStatus(result)

            local Show, v19

            if result.msg and result.msg ~= "" then
                Show = Toasts.Show
                v19 = if result.ok then "success" else "error"
                Show(v19, result.msg)
            end
        end
    end)
end

local function command(p5) -- line: 76
    -- upvalues: ReplicatedStorage (copy), Toasts (copy), t1 (copy)
    task.spawn(function() -- line: 77
        -- upvalues: p5 (copy), ReplicatedStorage (copy), Toasts (copy), t1 (copy)
        local function v20() -- line: 78
            -- upvalues: p5 (copy), ReplicatedStorage (copy)
            return ReplicatedStorage.Remotes.AdminCommand:InvokeServer(p5)
        end

        local ok, result = pcall(v20)

        t1.LastReply = if ok then result else nil

        if not ok or type(result) ~= "string" then
            if not ok then
                Toasts.Show("error", "The server did not answer")
            end
        else
            Toasts.Show("info", result)
        end
    end)
end

local t5 = {
    { "30 SEC", 30 },
    { "1 MIN", 60 },
    { "FULL", 0 }
}
local n2 = 30
local t6 = {}

local function setEventSeconds(p6) -- line: 94
    -- upvalues: UIKit (copy), fromRGB (copy), n2 (ref), t6 (copy)
    n2 = p6

    for v21, v22 in pairs(t6) do
        local v23 = v21 == p6
        local setButtonColor = UIKit.setButtonColor
        local v25 = if v23 then fromRGB(110, 200, 255) else fromRGB(70, 74, 104)
        local v24 = if v23 then fromRGB(40, 120, 220) else fromRGB(40, 42, 64)

        setButtonColor(v22, v25, v24)
    end
end

local function pageCard(p7, p8, p9, p10, p11) -- line: 102
    -- upvalues: UIKit (copy)
    local v26 = UIKit.frame(p7, {
        Corner = 20,
        Stroke = 5,
        ZIndex = 12,
        Name = p8,
        Size = UDim2.new(1, 0, 1, -66),
        Position = UDim2.fromOffset(0, 66),
        Color = p9,
        Color2 = p10
    })

    UIKit.dress(v26, 20, p11)

    return v26
end

local function cardTitle(p12, p13, p14, p15) -- line: 108
    -- upvalues: UIKit (copy), fromRGB (copy), Left (copy), v1 (copy)
    local v27 = UIKit.text(p12, {
        Name = "Title",
        TextSize = 50,
        Stroke = 5,
        ZIndex = 14,
        Text = p13,
        Size = UDim2.new(1, -52, 0, 56),
        Position = UDim2.fromOffset(24, 14),
        XAlign = Left
    })

    v27.FontFace = v1
    UIKit.gradient(v27, fromRGB(255, 255, 255), p15)

    local v28 = UIKit.text(p12, {
        Name = "About",
        TextSize = 20,
        Stroke = 3,
        ZIndex = 14,
        Text = p14,
        Size = UDim2.new(1, -52, 0, 50),
        Position = UDim2.fromOffset(26, 70),
        XAlign = Left,
        Color = fromRGB(220, 225, 255)
    })

    v28.TextWrapped = true
    v28.TextYAlignment = Enum.TextYAlignment.Top
end

local function buildEvents(p16) -- line: 117
    -- upvalues: ReplicatedStorage (copy), Events (copy), UIKit (copy), Toasts (copy), t1 (copy), fromRGB (copy), Colors (copy), Left (copy), t5 (copy), n2 (ref), t6 (copy), setEventSeconds (copy), cardTitle (copy)
    cardTitle(p16, "LIVE EVENTS", "Start any weather event in this server. Pick a short length to check its effects quickly, or FULL for its normal length.", fromRGB(150, 210, 255))
    UIKit.text(p16, {
        Name = "LengthLabel",
        Text = "HOW LONG",
        TextSize = 20,
        Stroke = 3,
        ZIndex = 14,
        Size = UDim2.new(1, -52, 0, 24),
        Position = UDim2.fromOffset(26, 124),
        XAlign = Left,
        Color = fromRGB(180, 210, 255)
    })

    for v29, v30 in ipairs(t5) do
        local v31 = UIKit.button(p16, {
            Corner = 25,
            Stroke = 4,
            ZIndex = 14,
            Name = "Len" .. v30[2],
            Text = v30[1],
            Size = UDim2.fromOffset(200, 50),
            Position = UDim2.fromOffset(26 + (v29 - 1) * 212, 152),
            Color = fromRGB(70, 74, 104),
            Color2 = fromRGB(40, 42, 64),
            OnClick = function() -- OnClick | line: 121
                -- upvalues: v30 (copy), setEventSeconds (copy)
                setEventSeconds(v30[2])
            end
        })

        t6[v30[2]] = v31
    end

    setEventSeconds(n2)

    local t8 = {}

    for _, v32 in ipairs(Events.List) do
        if not v32.special then
            table.insert(t8, v32)
        end
    end

    for v33, v34 in ipairs(t8) do
        local v35 = (v33 - 1) % 3
        local v36 = (v33 - 1) // 3

        UIKit.button(p16, {
            Corner = 16,
            Stroke = 4,
            TextStroke = 3,
            ZIndex = 14,
            Name = "Event_" .. v34.id,
            Text = v34.icon .. " " .. string.upper(v34.name),
            Size = UDim2.new(0.3333333333333333, -22, 0, 62),
            Position = UDim2.new(v35 / 3, 26 - v35 * 15, 0, 218 + v36 * 74),
            Color = v34.Color,
            Color2 = v34.Color:Lerp(fromRGB(20, 20, 40), 0.45),
            OnClick = function() -- OnClick | line: 135
                -- upvalues: v34 (copy), ReplicatedStorage (copy), Toasts (copy), t1 (copy), n2 (ref)
                local v37 = if n2 > 0 then n2 else v34.duration
                local v38 = ";event " .. v34.id .. " " .. v37

                task.spawn(function() -- line: 77
                    -- upvalues: v38 (copy), ReplicatedStorage (copy), Toasts (copy), t1 (copy)
                    local function v39() -- line: 78
                        -- upvalues: v38 (copy), ReplicatedStorage (copy)
                        return ReplicatedStorage.Remotes.AdminCommand:InvokeServer(v38)
                    end

                    local ok, result = pcall(v39)

                    t1.LastReply = if ok then result else nil

                    if not ok or type(result) ~= "string" then
                        if not ok then
                            Toasts.Show("error", "The server did not answer")
                        end
                    else
                        Toasts.Show("info", result)
                    end
                end)
            end
        })
    end

    UIKit.button(p16, {
        Name = "StopEvent",
        Text = "END EVENT",
        Corner = 16,
        Stroke = 4,
        TextStroke = 3,
        ZIndex = 14,
        Size = UDim2.new(1, -52, 0, 56),
        Position = UDim2.new(0, 26, 1, -22),
        AnchorPoint = Vector2.new(0, 1),
        Color = Colors.Red,
        Color2 = Colors.RedDark,
        OnClick = function() -- OnClick | line: 140
            -- upvalues: ReplicatedStorage (copy), Toasts (copy), t1 (copy)
            local spawn = task.spawn
            local v40 = ";eventstop"

            spawn(function() -- line: 77
                -- upvalues: v40 (copy), ReplicatedStorage (copy), Toasts (copy), t1 (copy)
                local function v41() -- line: 78
                    -- upvalues: v40 (copy), ReplicatedStorage (copy)
                    return ReplicatedStorage.Remotes.AdminCommand:InvokeServer(v40)
                end

                local ok, result = pcall(v41)

                t1.LastReply = if ok then result else nil

                if not ok or type(result) ~= "string" then
                    if not ok then
                        Toasts.Show("error", "The server did not answer")
                    end
                else
                    Toasts.Show("info", result)
                end
            end)
        end
    })
end

local function buildTesting(p17) -- line: 145
    -- upvalues: ReplicatedStorage (copy), Zones (copy), UIKit (copy), Toasts (copy), t1 (copy), fromRGB (copy), Colors (copy), Left (copy), cardTitle (copy)
    cardTitle(p17, "ZONES & VFX", "UNLOCK EVERYTHING gives every zone, bait, rod and dumbbell. Tap a zone to set your Cast Power so your next cast lands in it, to see that zone's effects.", fromRGB(140, 255, 170))
    UIKit.button(p17, {
        Name = "UnlockAll",
        Text = "UNLOCK EVERYTHING",
        Corner = 16,
        Stroke = 4,
        TextStroke = 3,
        ZIndex = 14,
        Size = UDim2.new(0.3333333333333333, -26, 0, 58),
        Position = UDim2.fromOffset(26, 126),
        Color = Colors.Green,
        Color2 = Colors.GreenDark,
        OnClick = function() -- OnClick | line: 147
            -- upvalues: ReplicatedStorage (copy), Toasts (copy), t1 (copy)
            local spawn = task.spawn
            local v42 = ";maxout"

            spawn(function() -- line: 77
                -- upvalues: v42 (copy), ReplicatedStorage (copy), Toasts (copy), t1 (copy)
                local function v43() -- line: 78
                    -- upvalues: v42 (copy), ReplicatedStorage (copy)
                    return ReplicatedStorage.Remotes.AdminCommand:InvokeServer(v42)
                end

                local ok, result = pcall(v43)

                t1.LastReply = if ok then result else nil

                if not ok or type(result) ~= "string" then
                    if not ok then
                        Toasts.Show("error", "The server did not answer")
                    end
                else
                    Toasts.Show("info", result)
                end
            end)
        end
    })
    UIKit.button(p17, {
        Name = "Dock",
        Text = "GO TO THE DOCK",
        Corner = 16,
        Stroke = 4,
        TextStroke = 3,
        ZIndex = 14,
        Size = UDim2.new(0.3333333333333333, -26, 0, 58),
        Position = UDim2.new(0.3333333333333333, 13, 0, 126),
        Color = fromRGB(110, 200, 255),
        Color2 = fromRGB(40, 120, 220),
        OnClick = function() -- OnClick | line: 150
            -- upvalues: ReplicatedStorage (copy), Toasts (copy), t1 (copy)
            local spawn = task.spawn
            local v44 = ";dock"

            spawn(function() -- line: 77
                -- upvalues: v44 (copy), ReplicatedStorage (copy), Toasts (copy), t1 (copy)
                local function v45() -- line: 78
                    -- upvalues: v44 (copy), ReplicatedStorage (copy)
                    return ReplicatedStorage.Remotes.AdminCommand:InvokeServer(v44)
                end

                local ok, result = pcall(v45)

                t1.LastReply = if ok then result else nil

                if not ok or type(result) ~= "string" then
                    if not ok then
                        Toasts.Show("error", "The server did not answer")
                    end
                else
                    Toasts.Show("info", result)
                end
            end)
        end
    })
    UIKit.button(p17, {
        Name = "ResetTutorial",
        Text = "RESET TUTORIAL",
        Corner = 16,
        Stroke = 4,
        TextStroke = 3,
        ZIndex = 14,
        Size = UDim2.new(0.3333333333333333, -26, 0, 58),
        Position = UDim2.new(0.6666666666666666, 0, 0, 126),
        Color = Colors.Orange,
        Color2 = Colors.OrangeDark,
        OnClick = function() -- OnClick | line: 153
            -- upvalues: ReplicatedStorage (copy), Toasts (copy), t1 (copy)
            local spawn = task.spawn
            local v46 = ";resettutorial"

            spawn(function() -- line: 77
                -- upvalues: v46 (copy), ReplicatedStorage (copy), Toasts (copy), t1 (copy)
                local function v47() -- line: 78
                    -- upvalues: v46 (copy), ReplicatedStorage (copy)
                    return ReplicatedStorage.Remotes.AdminCommand:InvokeServer(v46)
                end

                local ok, result = pcall(v47)

                t1.LastReply = if ok then result else nil

                if not ok or type(result) ~= "string" then
                    if not ok then
                        Toasts.Show("error", "The server did not answer")
                    end
                else
                    Toasts.Show("info", result)
                end
            end)
        end
    })
    UIKit.text(p17, {
        Name = "ZoneLabel",
        Text = "CAST INTO ZONE",
        TextSize = 20,
        Stroke = 3,
        ZIndex = 14,
        Size = UDim2.new(1, -52, 0, 24),
        Position = UDim2.fromOffset(26, 196),
        XAlign = Left,
        Color = fromRGB(180, 255, 200)
    })

    for v48, v49 in ipairs(Zones.List) do
        local v50 = (v48 - 1) % 5
        local v51 = (v48 - 1) // 5

        UIKit.button(p17, {
            Corner = 12,
            Stroke = 3,
            TextStroke = 3,
            ZIndex = 14,
            Name = "Zone" .. v48,
            Text = v48 .. ". " .. v49.name,
            Size = UDim2.new(0.2, -14, 0, 50),
            Position = UDim2.new(v50 / 5, 26 - v50 * 9.5, 0, 224 + v51 * 60),
            Color = v49.Color,
            Color2 = v49.Color:Lerp(fromRGB(20, 20, 40), 0.5),
            OnClick = function() -- OnClick | line: 159
                -- upvalues: v48 (copy), ReplicatedStorage (copy), Toasts (copy), t1 (copy)
                local v52 = ";zone " .. v48

                task.spawn(function() -- line: 77
                    -- upvalues: v52 (copy), ReplicatedStorage (copy), Toasts (copy), t1 (copy)
                    local function v53() -- line: 78
                        -- upvalues: v52 (copy), ReplicatedStorage (copy)
                        return ReplicatedStorage.Remotes.AdminCommand:InvokeServer(v52)
                    end

                    local ok, result = pcall(v53)

                    t1.LastReply = if ok then result else nil

                    if not ok or type(result) ~= "string" then
                        if not ok then
                            Toasts.Show("error", "The server did not answer")
                        end
                    else
                        Toasts.Show("info", result)
                    end
                end)
            end
        })
    end
end

local v54 = "server"
local t11 = {}
local TextBox, v55
local v56 = false

local function setScope(p18) -- line: 171
    -- upvalues: UIKit (copy), fromRGB (copy), v54 (ref), t11 (copy)
    v54 = p18

    for v57, v58 in pairs(t11) do
        local v59 = v57 == p18
        local v60 = if v57 == "global" then fromRGB(255, 120, 220) else fromRGB(255, 200, 90)
        local v61 = if v57 == "global" then fromRGB(200, 50, 160) else fromRGB(210, 130, 30)
        local setButtonColor = UIKit.setButtonColor

        if not v59 then
            v60 = fromRGB(70, 74, 104)
            v61 = fromRGB(40, 42, 64)
        end

        setButtonColor(v58, v60, v61)
    end
end

local function sendAnnouncement() -- line: 181
    -- upvalues: ReplicatedStorage (copy), Toasts (copy), t1 (copy), v54 (ref), TextBox (ref), v56 (ref)
    local v62 = v56

    if not v62 and TextBox then
        local v63 = string.gsub(string.gsub(TextBox.Text, "[\r\n]+", " "), "^%s*(.-)%s*$", "%1")

        if v63 == "" then
            Toasts.Show("error", "Type a message first")
        else
            v56 = true

            local v64 = if v54 == "global" then ";announce " else ";serverannounce "

            task.spawn(function() -- line: 192
                -- upvalues: v63 (copy), v64 (copy), ReplicatedStorage (copy), Toasts (copy), t1 (copy), TextBox (ref), v56 (ref)
                local function v65() -- line: 193
                    -- upvalues: v63 (copy), v64 (copy), ReplicatedStorage (copy)
                    return ReplicatedStorage.Remotes.AdminCommand:InvokeServer(v64 .. v63)
                end

                local ok, result = pcall(v65)

                v56 = false
                t1.LastReply = if ok then result else nil

                if ok and type(result) == "string" then
                    if string.sub(result, 1, 9) == "Announced" or string.sub(result, 1, 5) == "Shown" then
                        TextBox.Text = ""
                    else
                        Toasts.Show("error", result)
                    end
                else
                    Toasts.Show("error", "The server did not answer")
                end
            end)
        end
    end
end

local function buildAnnounce(p19) -- line: 211
    -- upvalues: UIKit (copy), fromRGB (copy), Colors (copy), Left (copy), cardTitle (copy), v54 (ref), t11 (copy), TextBox (ref), v55 (ref), setScope (copy), sendAnnouncement (copy)
    cardTitle(p19, "ANNOUNCEMENTS", "Send a banner to every player. SERVER shows it only in this server, GLOBAL shows it in every server of the game.", fromRGB(255, 220, 120))
    UIKit.text(p19, {
        Name = "ScopeLabel",
        Text = "SEND TO",
        TextSize = 20,
        Stroke = 3,
        ZIndex = 14,
        Size = UDim2.new(1, -52, 0, 24),
        Position = UDim2.fromOffset(26, 124),
        XAlign = Left,
        Color = fromRGB(255, 225, 160)
    })

    for v66, v67 in ipairs({
            { "server", "SERVER" },
            { "global", "GLOBAL" }
        }) do
        local v68 = v67[1]

        t11[v68] = UIKit.button(p19, {
            Corner = 25,
            Stroke = 4,
            ZIndex = 14,
            Name = "Scope_" .. v67[2],
            Text = v67[2],
            Size = UDim2.fromOffset(200, 50),
            Position = UDim2.fromOffset(26 + (v66 - 1) * 212, 152),
            Color = fromRGB(70, 74, 104),
            Color2 = fromRGB(40, 42, 64),
            OnClick = function() -- OnClick | line: 216
                -- upvalues: v68 (copy), setScope (copy)
                setScope(v68)
            end
        })
    end

    setScope(v54)

    local TextBox2 = Instance.new("TextBox")

    TextBox2.Name = "Message"
    TextBox2.Size = UDim2.new(1, -52, 1, -350)
    TextBox2.Position = UDim2.fromOffset(26, 222)
    TextBox2.BackgroundColor3 = fromRGB(16, 14, 30)
    TextBox2.BackgroundTransparency = 0.15
    TextBox2.TextColor3 = fromRGB(255, 255, 255)
    TextBox2.PlaceholderText = "Type your announcement here..."
    TextBox2.PlaceholderColor3 = fromRGB(130, 136, 160)
    TextBox2.Text = ""
    TextBox2.Font = Enum.Font.FredokaOne
    TextBox2.TextSize = 28
    TextBox2.TextWrapped = true
    TextBox2.MultiLine = true
    TextBox2.ClearTextOnFocus = false
    TextBox2.TextXAlignment = Left
    TextBox2.TextYAlignment = Enum.TextYAlignment.Top
    TextBox2.ZIndex = 14

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0, 14)
    UICorner.Parent = TextBox2

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 4
    UIStroke.Color = fromRGB(20, 22, 34)
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = TextBox2

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingLeft = UDim.new(0, 14)
    UIPadding.PaddingRight = UDim.new(0, 14)
    UIPadding.PaddingTop = UDim.new(0, 10)
    UIPadding.PaddingBottom = UDim.new(0, 10)
    UIPadding.Parent = TextBox2
    TextBox2.Parent = p19
    TextBox = TextBox2
    v55 = UIKit.text(p19, {
        Name = "Count",
        TextSize = 20,
        Stroke = 3,
        ZIndex = 14,
        Text = "0 / " .. 200,
        Size = UDim2.new(1, -52, 0, 24),
        Position = UDim2.new(0, 26, 1, -122),
        XAlign = Enum.TextXAlignment.Right,
        Color = fromRGB(200, 205, 230)
    })
    TextBox2:GetPropertyChangedSignal("Text"):Connect(function() -- line: 256
        -- upvalues: TextBox2 (copy), v55 (ref)
        local v69 = utf8.len(TextBox2.Text) or #TextBox2.Text

        if v69 > 200 then
            TextBox2.Text = string.sub(TextBox2.Text, 1, utf8.offset(TextBox2.Text, 201) - 1)
        else
            v55.Text = v69 .. " / " .. 200
        end
    end)
    UIKit.button(p19, {
        Name = "Send",
        Text = "ANNOUNCE",
        Corner = 18,
        Stroke = 5,
        TextStroke = 4,
        ZIndex = 14,
        Size = UDim2.new(0.6, 0, 0, 64),
        Position = UDim2.new(0.5, 0, 1, -22),
        AnchorPoint = Vector2.new(0.5, 1),
        Color = Colors.Green,
        Color2 = Colors.GreenDark,
        OnClick = sendAnnouncement
    })
end

local function setMinutes(p20) -- line: 267
    -- upvalues: UIKit (copy), fromRGB (copy), v5 (ref), t3 (copy)
    v5 = p20

    for v72, v73 in pairs(t3) do
        local v74 = v72 == p20
        local setButtonColor = UIKit.setButtonColor
        local v76 = if v74 then fromRGB(190, 120, 255) else fromRGB(70, 74, 104)
        local v75 = if v74 then fromRGB(110, 50, 210) else fromRGB(40, 42, 64)

        setButtonColor(v73, v76, v75)
    end
end

local function build() -- line: 275
    -- upvalues: ReplicatedStorage (copy), CosmicEvent (copy), UIKit (copy), TopBar (copy), Toasts (copy), t1 (copy), LocalPlayer (copy), fromRGB (copy), Colors (copy), Left (copy), v1 (copy), v2 (ref), v3 (ref), v4 (ref), t2 (copy), v5 (ref), t3 (copy), v6 (ref), n1 (ref), showStatus (copy), pageCard (copy), buildEvents (copy), buildTesting (copy), buildAnnounce (copy), setMinutes (copy)
    local Windows = LocalPlayer.PlayerGui:WaitForChild("Windows")

    v2 = UIKit.window(Windows, {
        Name = "Admin",
        Title = "Admin Panel",
        GradientRotation = 0,
        Size = UDim2.fromOffset(760, 700),
        HeaderColor = fromRGB(170, 110, 255),
        HeaderColor2 = fromRGB(70, 40, 180)
    })

    local Content = v2.Content
    local v77 = pageCard(Content, "Cosmic", fromRGB(60, 34, 130), fromRGB(18, 10, 44), fromRGB(200, 160, 255))
    local v78 = pageCard(Content, "Events", fromRGB(30, 70, 140), fromRGB(10, 18, 44), fromRGB(160, 210, 255))
    local v79 = pageCard(Content, "Testing", fromRGB(30, 110, 70), fromRGB(8, 30, 20), fromRGB(160, 255, 190))
    local v80 = pageCard(Content, "Announce", fromRGB(120, 80, 30), fromRGB(40, 22, 8), fromRGB(255, 220, 150))

    buildEvents(v78)
    buildTesting(v79)
    buildAnnounce(v80)

    local t13 = {}

    local function showTab(p21) -- line: 288
        -- upvalues: t13 (copy), UIKit (copy), fromRGB (copy)
        for v81, v82 in pairs(t13) do
            local v83 = v81 == p21

            v82.card.Visible = v83

            local setButtonColor = UIKit.setButtonColor
            local button = v82.button
            local v85 = if v83 then v82.color else fromRGB(70, 74, 104)
            local v84 = if v83 then v82.color:Lerp(fromRGB(0, 0, 0), 0.35) else fromRGB(40, 42, 64)

            setButtonColor(button, v85, v84)
        end
    end

    for v86, v87 in ipairs({
            {
                "Cosmic",
                "COSMIC FLOOD",
                v77,
                fromRGB(190, 120, 255)
            },
            {
                "Events",
                "LIVE EVENTS",
                v78,
                fromRGB(110, 200, 255)
            },
            {
                "Testing",
                "ZONES & VFX",
                v79,
                fromRGB(120, 228, 120)
            },
            {
                "Announce",
                "ANNOUNCE",
                v80,
                fromRGB(255, 200, 90)
            }
        }) do
        local v88 = UIKit.button(Content, {
            Corner = 16,
            Stroke = 4,
            TextStroke = 3,
            ZIndex = 14,
            Name = "Tab" .. v87[1],
            Text = v87[2],
            Size = UDim2.new(0.25, -9, 0, 54),
            Position = UDim2.new((v86 - 1) / 4, (v86 - 1) * 3, 0, 0),
            Color = fromRGB(70, 74, 104),
            Color2 = fromRGB(40, 42, 64),
            OnClick = function() -- OnClick | line: 296
                -- upvalues: showTab (copy), v87 (copy)
                showTab(v87[1])
            end
        })

        t13[v87[1]] = {
            button = v88,
            card = v87[3],
            color = v87[4]
        }
    end

    showTab("Cosmic")

    local v89 = UIKit.backdrop(v77, 20, 12)

    UIKit.rays(v89, {
        Transparency = 0.86,
        ZIndex = 12,
        Speed = 6,
        Size = UDim2.fromOffset(700, 700),
        Position = UDim2.new(1, -90, 0, 70),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    UIKit.eggPicture(v77, CosmicEvent.EGG_KEY, {
        ZIndex = 14,
        Size = UDim2.fromOffset(150, 150),
        Position = UDim2.new(1, -92, 0, 82)
    })

    local v90 = UIKit.text(v77, {
        Name = "Title",
        Text = "COSMIC FLOOD",
        TextSize = 50,
        Stroke = 5,
        ZIndex = 14,
        Size = UDim2.new(1, -200, 0, 56),
        Position = UDim2.fromOffset(24, 14),
        XAlign = Left
    })

    v90.FontFace = v1
    UIKit.gradient(v90, fromRGB(255, 255, 255), fromRGB(190, 150, 255))

    local v91 = UIKit.text(v77, {
        Name = "About",
        Text = "An hour and a half: the sea floods the lobby and Khaos drops Lucky Casts, potions and Cosmic Eggs (20 min), then KHAOS vs SERAPHION while everyone bets, then the Cosmic Storm: Khaos's beams can turn pen fish COSMIC x300.",
        TextSize = 20,
        Stroke = 3,
        ZIndex = 14,
        Size = UDim2.new(1, -210, 0, 78),
        Position = UDim2.fromOffset(26, 70),
        XAlign = Left,
        Color = fromRGB(220, 210, 255)
    })

    v91.TextWrapped = true
    v91.TextYAlignment = Enum.TextYAlignment.Top
    UIKit.text(v77, {
        Name = "LengthLabel",
        Text = "HOW LONG (the shorter ones are test runs of all three acts)",
        TextSize = 20,
        Stroke = 3,
        ZIndex = 14,
        Size = UDim2.new(1, -52, 0, 24),
        Position = UDim2.fromOffset(26, 152),
        XAlign = Left,
        Color = fromRGB(200, 180, 255)
    })

    for v92, v93 in ipairs(t2) do
        t3[v93] = UIKit.button(v77, {
            Corner = 25,
            Stroke = 4,
            ZIndex = 14,
            Name = "Len" .. v93,
            Text = if v92 == 1 then v93 .. " MIN" else v93 .. " MIN TEST",
            Size = UDim2.fromOffset(200, 50),
            Position = UDim2.fromOffset(26 + (v92 - 1) * 212, 180),
            Color = fromRGB(70, 74, 104),
            Color2 = fromRGB(40, 42, 64),
            OnClick = function() -- OnClick | line: 314
                -- upvalues: v93 (copy), setMinutes (copy)
                setMinutes(v93)
            end
        })
    end

    setMinutes(v5)
    UIKit.button(v77, {
        Name = "StartHere",
        Text = "START IN THIS SERVER",
        Corner = 18,
        Stroke = 5,
        TextStroke = 4,
        ZIndex = 14,
        Size = UDim2.new(0.5, -32, 0, 64),
        Position = UDim2.fromOffset(26, 244),
        Color = fromRGB(190, 120, 255),
        Color2 = fromRGB(110, 50, 210),
        OnClick = function() -- OnClick | line: 321
            -- upvalues: ReplicatedStorage (copy), Toasts (copy), t1 (copy), v5 (ref), v6 (ref), showStatus (copy)
            local v95 = v5 * 60

            if v6 then
                return
            end

            v6 = true

            local spawn = task.spawn
            local v96 = "start"

            spawn(function() -- line: 59
                -- upvalues: v95 (copy), v96 (copy), ReplicatedStorage (copy), Toasts (copy), t1 (copy), v6 (ref), showStatus (copy)
                local function v97() -- line: 60
                    -- upvalues: v95 (copy), v96 (copy), ReplicatedStorage (copy)
                    return ReplicatedStorage.Remotes.CosmicAdmin:InvokeServer(v96, v95)
                end

                local ok, result = pcall(v97)

                v6 = false
                t1.LastReply = if ok then result else nil

                if not ok or type(result) ~= "table" then
                    Toasts.Show("error", "The server did not answer")
                else
                    showStatus(result)

                    local Show, v98

                    if result.msg and result.msg ~= "" then
                        Show = Toasts.Show
                        v98 = if result.ok then "success" else "error"
                        Show(v98, result.msg)
                    end
                end
            end)
        end
    })

    local _, v99 = UIKit.button(v77, {
        Name = "StartAll",
        Text = "START IN EVERY SERVER",
        Corner = 18,
        Stroke = 5,
        TextStroke = 4,
        ZIndex = 14,
        Size = UDim2.new(0.5, -32, 0, 64),
        Position = UDim2.new(0.5, 6, 0, 244),
        Color = fromRGB(255, 120, 220),
        Color2 = fromRGB(200, 50, 160),
        OnClick = function() -- OnClick | line: 324
            -- upvalues: ReplicatedStorage (copy), Toasts (copy), t1 (copy), v5 (ref), v6 (ref), n1 (ref), showStatus (copy)
            if os.clock() > n1 then
                n1 = os.clock() + 3
            else
                n1 = 0

                local v100 = v5 * 60

                if not v6 then
                    v6 = true

                    local spawn = task.spawn
                    local v101 = "startAll"

                    spawn(function() -- line: 59
                        -- upvalues: v100 (copy), v101 (copy), ReplicatedStorage (copy), Toasts (copy), t1 (copy), v6 (ref), showStatus (copy)
                        local function v102() -- line: 60
                            -- upvalues: v100 (copy), v101 (copy), ReplicatedStorage (copy)
                            return ReplicatedStorage.Remotes.CosmicAdmin:InvokeServer(v101, v100)
                        end

                        local ok, result = pcall(v102)

                        v6 = false
                        t1.LastReply = if ok then result else nil

                        if not ok or type(result) ~= "table" then
                            Toasts.Show("error", "The server did not answer")
                        else
                            showStatus(result)

                            local Show, v103

                            if result.msg and result.msg ~= "" then
                                Show = Toasts.Show
                                v103 = if result.ok then "success" else "error"
                                Show(v103, result.msg)
                            end
                        end
                    end)
                end
            end
        end
    })

    UIKit.button(v77, {
        Name = "SkipBattle",
        Text = "SKIP TO THE FIGHT",
        Corner = 16,
        Stroke = 4,
        TextStroke = 3,
        ZIndex = 14,
        Size = UDim2.new(0.5, -32, 0, 52),
        Position = UDim2.fromOffset(26, 320),
        Color = fromRGB(255, 200, 90),
        Color2 = fromRGB(210, 130, 30),
        OnClick = function() -- OnClick | line: 333
            -- upvalues: ReplicatedStorage (copy), Toasts (copy), t1 (copy), v6 (ref), showStatus (copy)
            if v6 then
                return
            end

            v6 = true

            local spawn = task.spawn
            local v104 = "skipBattle"
            local v105

            spawn(function() -- line: 59
                -- upvalues: v104 (copy), v105 (copy), ReplicatedStorage (copy), Toasts (copy), t1 (copy), v6 (ref), showStatus (copy)
                local function v106() -- line: 60
                    -- upvalues: v104 (copy), v105 (copy), ReplicatedStorage (copy)
                    return ReplicatedStorage.Remotes.CosmicAdmin:InvokeServer(v104, v105)
                end

                local ok, result = pcall(v106)

                v6 = false
                t1.LastReply = if ok then result else nil

                if not ok or type(result) ~= "table" then
                    Toasts.Show("error", "The server did not answer")
                else
                    showStatus(result)

                    local Show, v107

                    if result.msg and result.msg ~= "" then
                        Show = Toasts.Show
                        v107 = if result.ok then "success" else "error"
                        Show(v107, result.msg)
                    end
                end
            end)
        end
    })
    UIKit.button(v77, {
        Name = "SkipCosmic",
        Text = "SKIP TO THE STORM",
        Corner = 16,
        Stroke = 4,
        TextStroke = 3,
        ZIndex = 14,
        Size = UDim2.new(0.5, -32, 0, 52),
        Position = UDim2.new(0.5, 6, 0, 320),
        Color = fromRGB(120, 170, 255),
        Color2 = fromRGB(60, 90, 210),
        OnClick = function() -- OnClick | line: 336
            -- upvalues: ReplicatedStorage (copy), Toasts (copy), t1 (copy), v6 (ref), showStatus (copy)
            if v6 then
                return
            end

            v6 = true

            local spawn = task.spawn
            local v108 = "skipCosmic"
            local v109

            spawn(function() -- line: 59
                -- upvalues: v108 (copy), v109 (copy), ReplicatedStorage (copy), Toasts (copy), t1 (copy), v6 (ref), showStatus (copy)
                local function v110() -- line: 60
                    -- upvalues: v108 (copy), v109 (copy), ReplicatedStorage (copy)
                    return ReplicatedStorage.Remotes.CosmicAdmin:InvokeServer(v108, v109)
                end

                local ok, result = pcall(v110)

                v6 = false
                t1.LastReply = if ok then result else nil

                if not ok or type(result) ~= "table" then
                    Toasts.Show("error", "The server did not answer")
                else
                    showStatus(result)

                    local Show, v111

                    if result.msg and result.msg ~= "" then
                        Show = Toasts.Show
                        v111 = if result.ok then "success" else "error"
                        Show(v111, result.msg)
                    end
                end
            end)
        end
    })
    UIKit.button(v77, {
        Name = "Stop",
        Text = "END IT NOW",
        Corner = 16,
        Stroke = 4,
        TextStroke = 3,
        ZIndex = 14,
        Size = UDim2.new(0.5, -32, 0, 52),
        Position = UDim2.fromOffset(26, 384),
        Color = Colors.Red,
        Color2 = Colors.RedDark,
        OnClick = function() -- OnClick | line: 339
            -- upvalues: ReplicatedStorage (copy), Toasts (copy), t1 (copy), v6 (ref), showStatus (copy)
            if v6 then
                return
            end

            v6 = true

            local spawn = task.spawn
            local v112 = "stop"
            local v113

            spawn(function() -- line: 59
                -- upvalues: v112 (copy), v113 (copy), ReplicatedStorage (copy), Toasts (copy), t1 (copy), v6 (ref), showStatus (copy)
                local function v114() -- line: 60
                    -- upvalues: v112 (copy), v113 (copy), ReplicatedStorage (copy)
                    return ReplicatedStorage.Remotes.CosmicAdmin:InvokeServer(v112, v113)
                end

                local ok, result = pcall(v114)

                v6 = false
                t1.LastReply = if ok then result else nil

                if not ok or type(result) ~= "table" then
                    Toasts.Show("error", "The server did not answer")
                else
                    showStatus(result)

                    local Show, v115

                    if result.msg and result.msg ~= "" then
                        Show = Toasts.Show
                        v115 = if result.ok then "success" else "error"
                        Show(v115, result.msg)
                    end
                end
            end)
        end
    })
    UIKit.button(v77, {
        Name = "StopAll",
        Text = "END IN EVERY SERVER",
        Corner = 16,
        Stroke = 4,
        TextStroke = 3,
        ZIndex = 14,
        Size = UDim2.new(0.5, -32, 0, 52),
        Position = UDim2.new(0.5, 6, 0, 384),
        Color = fromRGB(200, 70, 90),
        Color2 = fromRGB(140, 30, 50),
        OnClick = function() -- OnClick | line: 342
            -- upvalues: ReplicatedStorage (copy), Toasts (copy), t1 (copy), v6 (ref), showStatus (copy)
            if v6 then
                return
            end

            v6 = true

            local spawn = task.spawn
            local v116 = "stopAll"
            local v117

            spawn(function() -- line: 59
                -- upvalues: v116 (copy), v117 (copy), ReplicatedStorage (copy), Toasts (copy), t1 (copy), v6 (ref), showStatus (copy)
                local function v118() -- line: 60
                    -- upvalues: v116 (copy), v117 (copy), ReplicatedStorage (copy)
                    return ReplicatedStorage.Remotes.CosmicAdmin:InvokeServer(v116, v117)
                end

                local ok, result = pcall(v118)

                v6 = false
                t1.LastReply = if ok then result else nil

                if not ok or type(result) ~= "table" then
                    Toasts.Show("error", "The server did not answer")
                else
                    showStatus(result)

                    local Show, v119

                    if result.msg and result.msg ~= "" then
                        Show = Toasts.Show
                        v119 = if result.ok then "success" else "error"
                        Show(v119, result.msg)
                    end
                end
            end)
        end
    })
    v3 = UIKit.text(v77, {
        Name = "Status",
        Text = "",
        TextSize = 21,
        Stroke = 3,
        ZIndex = 14,
        Size = UDim2.new(1, -52, 0, 54),
        Position = UDim2.fromOffset(26, 446),
        XAlign = Left,
        Color = fromRGB(230, 225, 255)
    })
    v3.RichText = true

    local v120 = v3

    v120.TextYAlignment = Enum.TextYAlignment.Top
    game:GetService("RunService").Heartbeat:Connect(function() -- line: 349
        -- upvalues: v99 (copy), v2 (ref), n1 (ref)
        if v2.IsOpen then
            v99.Text = os.clock() < n1 and "TAP AGAIN TO CONFIRM" or "START IN EVERY SERVER"
        end
    end)

    local v122 = v2

    v122.OnOpen = function() -- line: 355
        -- upvalues: ReplicatedStorage (copy), Toasts (copy), t1 (copy), v6 (ref), showStatus (copy)
        if v6 then
            return
        end

        v6 = true

        local spawn = task.spawn
        local v123 = "status"
        local v124

        spawn(function() -- line: 59
            -- upvalues: v123 (copy), v124 (copy), ReplicatedStorage (copy), Toasts (copy), t1 (copy), v6 (ref), showStatus (copy)
            local function v125() -- line: 60
                -- upvalues: v123 (copy), v124 (copy), ReplicatedStorage (copy)
                return ReplicatedStorage.Remotes.CosmicAdmin:InvokeServer(v123, v124)
            end

            local ok, result = pcall(v125)

            v6 = false
            t1.LastReply = if ok then result else nil

            if not ok or type(result) ~= "table" then
                Toasts.Show("error", "The server did not answer")
            else
                showStatus(result)

                local Show, v126

                if result.msg and result.msg ~= "" then
                    Show = Toasts.Show
                    v126 = if result.ok then "success" else "error"
                    Show(v126, result.msg)
                end
            end
        end)
    end

    task.spawn(function() -- line: 358
        -- upvalues: ReplicatedStorage (copy), v2 (ref), v6 (ref), showStatus (copy)
        while true do
            task.wait(1)

            if v2.IsOpen and not v6 then
                local function v127() -- line: 362
                    -- upvalues: ReplicatedStorage (copy)
                    return ReplicatedStorage.Remotes.CosmicAdmin:InvokeServer("status")
                end

                local ok, result = pcall(v127)

                if ok then
                    showStatus(result)
                end
            end
        end
    end)
    showStatus({
        on = false
    })
    v4 = TopBar.RoundButton("Admin", 40)
    UIKit.text(v4, {
        Name = "Crown",
        Text = "ADMIN",
        TextSize = 13,
        Stroke = 2,
        ZIndex = 2,
        Size = UDim2.fromScale(1, 1),
        Color = fromRGB(255, 214, 90)
    }).FontFace = v1
    UIKit.bindPress(v4, function() -- line: 377
        -- upvalues: v2 (ref)
        v2.Toggle()
    end)
end

function t1.Open() -- line: 382
    -- upvalues: v2 (ref)
    if v2 then
        v2.Open()
    end
end

function t1.Announce(p22, p23) -- line: 388
    -- upvalues: TextBox (ref), setScope (copy), sendAnnouncement (copy)
    if TextBox then
        setScope(p22)
        TextBox.Text = p23
        sendAnnouncement()
    end
end

function t1.Call(p24, p25) -- line: 397
    -- upvalues: ReplicatedStorage (copy), Toasts (copy), t1 (copy), v6 (ref), showStatus (copy)
    if v6 then
        return
    end

    v6 = true
    task.spawn(function() -- line: 59
        -- upvalues: p24 (copy), p25 (copy), ReplicatedStorage (copy), Toasts (copy), t1 (copy), v6 (ref), showStatus (copy)
        local function v128() -- line: 60
            -- upvalues: p24 (copy), p25 (copy), ReplicatedStorage (copy)
            return ReplicatedStorage.Remotes.CosmicAdmin:InvokeServer(p24, p25)
        end

        local ok, result = pcall(v128)

        v6 = false
        t1.LastReply = if ok then result else nil

        if not ok or type(result) ~= "table" then
            Toasts.Show("error", "The server did not answer")
        else
            showStatus(result)

            local Show, v129

            if result.msg and result.msg ~= "" then
                Show = Toasts.Show
                v129 = if result.ok then "success" else "error"
                Show(v129, result.msg)
            end
        end
    end)
end

function t1.Init() -- line: 401
    -- upvalues: LocalPlayer (copy), v2 (ref), build (copy)
    local function check() -- line: 402
        -- upvalues: LocalPlayer (copy), v2 (ref), build (copy)
        if LocalPlayer:GetAttribute("IsAdmin") == true and not v2 then
            build()
        end
    end

    LocalPlayer:GetAttributeChangedSignal("IsAdmin"):Connect(check)

    if LocalPlayer:GetAttribute("IsAdmin") == true and not v2 then
        build()
    end
end

return t1
