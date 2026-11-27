-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

game:GetService("GuiService")
game:GetService("UserInputService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local UIKit = require(script.Parent.UIKit)
local DataClient = require(script.Parent.DataClient)
local SoundPlayer = require(script.Parent.SoundPlayer)

require(script.Parent.HUD)

local Pad = require(script.Parent.Pad)
local GroupService = game:GetService("GroupService")
local t1 = {
    CodeResult = ""
}
local Colors = UIKit.Colors
local fromRGB = Color3.fromRGB
local Left = Enum.TextXAlignment.Left
local t2 = {
    {
        key = "MusicVolume",
        name = "Music",
        color = fromRGB(255, 110, 190)
    },
    {
        key = "SfxVolume",
        name = "Sound Effects",
        color = fromRGB(255, 190, 50)
    },
    {
        key = "AmbienceVolume",
        name = "Ocean & Weather",
        color = fromRGB(80, 190, 255)
    }
}
local t3 = {
    {
        key = "Weather",
        name = "Weather Effects",
        hint = "Rain, snow and screen tint during events. Turn off if the game feels slow"
    },
    {
        key = "HideOthersFish",
        name = "Hide Other Players' Fish",
        hint = "Hides the fish in other players' ponds and hands. Turn on if the game feels slow"
    },
    {
        key = "TradeRequests",
        name = "Trade Requests",
        hint = "Lets other players send you trade requests"
    },
    {
        key = "SkipCutscenes",
        name = "Skip Cutscenes",
        hint = "Needs the pass. On: straight to your catch. Off: watch, with a SKIP button",
        pass = "SkipCutscene",
        owns = "OwnsSkipCutscene"
    }
}
local t4 = {
    {
        id = "pov",
        name = "Fish's-Eye View"
    },
    {
        id = "hunt",
        name = "The Hunt"
    },
    {
        id = "eyes",
        name = "Eyes in the Dark"
    },
    {
        id = "chase",
        name = "Scatter"
    },
    {
        id = "drag",
        name = "Towed"
    },
    {
        id = "whirl",
        name = "Whirlpool"
    }
}

local function save(p1, p2) -- line: 44
    -- upvalues: Remotes (copy)
    task.spawn(function() -- line: 45
        -- upvalues: p1 (copy), p2 (copy), Remotes (copy)
        local function v1() -- line: 46
            -- upvalues: p1 (copy), p2 (copy), Remotes (copy)
            Remotes.SetSetting:InvokeServer(p1, p2)
        end

        pcall(v1)
    end)
end

local function setting(p3) -- line: 52
    -- upvalues: DataClient (copy)
    return (DataClient.Get("Settings") or {})[p3]
end

local function card(p4, p5, p6, p7) -- line: 59
    -- upvalues: UIKit (copy), fromRGB (copy)
    local v2 = UIKit.frame(p4, {
        Corner = 16,
        Stroke = 4,
        ZIndex = 12,
        Name = p5,
        Size = UDim2.new(1, -10, 0, p6),
        Position = UDim2.fromOffset(5, p7),
        Color = fromRGB(66, 82, 156),
        Color2 = fromRGB(30, 36, 80)
    })

    UIKit.dress(v2, 16, fromRGB(170, 190, 255))

    return v2
end

local function heading(p8, p9, p10, p11, p12) -- line: 66
    -- upvalues: UIKit (copy), Colors (copy)
    local v3 = UIKit.frame(p8, {
        Corner = 10,
        Stroke = 3,
        ZIndex = 12,
        Name = p9,
        Size = UDim2.fromOffset(0, 30),
        Position = UDim2.fromOffset(5, p11),
        Color = p12,
        Color2 = p12:Lerp(Color3.new(), 0.3)
    })

    v3.AutomaticSize = Enum.AutomaticSize.X

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingLeft = UDim.new(0, 14)
    UIPadding.PaddingRight = UDim.new(0, 14)
    UIPadding.Parent = v3
    UIKit.text(v3, {
        Name = "Label",
        TextSize = 22,
        Stroke = 3,
        ZIndex = 13,
        Text = p10,
        Size = UDim2.fromScale(0, 1)
    }).AutomaticSize = Enum.AutomaticSize.X

    local v4 = game:GetService("TextService"):GetTextSize(p10, 22, UIKit.Font, Vector2.new(1000, 100)).X + 28
    local v5 = UIKit.frame(p8, {
        Corner = 2,
        ZIndex = 12,
        Name = p9 .. "Line",
        Size = UDim2.new(1, -(v4 + 30), 0, 4),
        Position = UDim2.fromOffset(v4 + 18, p11 + 13),
        Color = p12
    })

    UIKit.gradient(v5, Colors.White, Colors.White, 0).Transparency = NumberSequence.new(0.3, 1)

    return v3
end

local function sliderRow(p13, p14, p15) -- line: 82
    -- upvalues: Remotes (copy), UIKit (copy), DataClient (copy), SoundPlayer (copy), Pad (copy), Colors (copy), Left (copy), card (copy)
    local v6 = card(p13, p14.key, 96, p15)

    UIKit.text(v6, {
        Name = "Label",
        TextSize = 32,
        Stroke = 4,
        ZIndex = 13,
        Text = p14.name,
        Size = UDim2.new(1, -150, 0, 38),
        Position = UDim2.fromOffset(20, 8),
        XAlign = Left
    })

    local v7 = UIKit.text(v6, {
        Name = "Percent",
        Text = "100%",
        TextSize = 30,
        Stroke = 4,
        ZIndex = 13,
        Size = UDim2.fromOffset(110, 38),
        Position = UDim2.new(1, -20, 0, 8),
        AnchorPoint = Vector2.new(1, 0),
        XAlign = Enum.TextXAlignment.Right,
        Color = p14.color
    })
    local v8 = UIKit.frame(v6, {
        Class = "TextButton",
        Name = "Track",
        Corner = 10,
        ZIndex = 13,
        Size = UDim2.new(1, -56, 0, 20),
        Position = UDim2.fromOffset(28, 58),
        Color = Colors.Dark
    })

    v8.Text = ""
    v8.AutoButtonColor = false
    UIKit.stroke(v8, 4).ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local v9 = UIKit.frame(v8, {
        Name = "Fill",
        Corner = 10,
        ZIndex = 14,
        Size = UDim2.fromScale(1, 1),
        Color = p14.color:Lerp(Colors.White, 0.25),
        Color2 = p14.color
    })
    local v10 = UIKit.frame(v8, {
        Name = "Knob",
        Corner = 18,
        Stroke = 5,
        ZIndex = 15,
        Size = UDim2.fromOffset(36, 36),
        Position = UDim2.fromScale(1, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Color = Colors.White
    })
    local n1 = 1
    local v11 = false

    local function show(p16) -- line: 96
        -- upvalues: v7 (copy), v9 (copy), v10 (copy), n1 (ref)
        n1 = math.clamp(p16, 0, 1)
        v9.Size = UDim2.fromScale(n1, 1)
        v10.Position = UDim2.fromScale(n1, 0.5)
        v7.Text = math.floor(n1 * 100 + 0.5) .. "%"
    end

    Pad.Slider(v8, {
        step = 0.05,
        hit = Vector2.new(20, 20),
        get = function() -- get | line: 106
            -- upvalues: n1 (ref)
            return n1
        end,
        set = function(p17) -- set | line: 109
            -- upvalues: p14 (copy), v7 (copy), v9 (copy), v10 (copy), n1 (ref), v11 (ref), SoundPlayer (copy)
            v11 = true

            local v14 = math.floor(math.clamp(p17, 0, 1) * 20 + 0.5) / 20

            if v14 == n1 then
                return
            end

            n1 = math.clamp(v14, 0, 1)
            v9.Size = UDim2.fromScale(n1, 1)
            v10.Position = UDim2.fromScale(n1, 0.5)
            v7.Text = math.floor(n1 * 100 + 0.5) .. "%"
            SoundPlayer.SetVolume(p14.key, v14)
        end,
        grab = function() -- grab | line: 117
            -- upvalues: v10 (copy), UIKit (copy)
            UIKit.pop(v10, 1.25)
        end,
        done = function() -- done | line: 120
            -- upvalues: p14 (copy), n1 (ref), v11 (ref), Remotes (copy), UIKit (copy)
            v11 = false

            local key = p14.key
            local v16 = n1

            task.spawn(function() -- line: 45
                -- upvalues: key (copy), v16 (copy), Remotes (copy)
                local function v17() -- line: 46
                    -- upvalues: key (copy), v16 (copy), Remotes (copy)
                    Remotes.SetSetting:InvokeServer(key, v16)
                end

                pcall(v17)
            end)

            if p14.key == "SfxVolume" then
                UIKit.sound("Click")
            end
        end
    })
    DataClient.Observe("Settings", function(p18) -- line: 128
        -- upvalues: p14 (copy), v7 (copy), v9 (copy), v10 (copy), n1 (ref), v11 (ref)
        if v11 then
            return
        end

        local v18 = p18 and p18[p14.key]

        if type(v18) ~= "number" then
            v18 = 1
        end

        n1 = math.clamp(v18, 0, 1)
        v9.Size = UDim2.fromScale(n1, 1)
        v10.Position = UDim2.fromScale(n1, 0.5)
        v7.Text = math.floor(n1 * 100 + 0.5) .. "%"
    end)
end

local function switchRow(p19, p20, p21) -- line: 137
    -- upvalues: ReplicatedStorage (copy), Remotes (copy), UIKit (copy), DataClient (copy), Colors (copy), fromRGB (copy), Left (copy), card (copy)
    local v20 = card(p19, p20.key, 92, p21)

    UIKit.text(v20, {
        Name = "Label",
        TextSize = 32,
        Stroke = 4,
        ZIndex = 13,
        Text = p20.name,
        Size = UDim2.new(1, -180, 0, 38),
        Position = UDim2.fromOffset(20, 8),
        XAlign = Left
    })
    UIKit.text(v20, {
        Name = "Hint",
        TextSize = 19,
        Stroke = 3,
        ZIndex = 13,
        Text = p20.hint,
        Size = UDim2.new(1, -190, 0, 40),
        Position = UDim2.fromOffset(20, 46),
        XAlign = Left,
        YAlign = Enum.TextYAlignment.Top,
        Color = fromRGB(200, 210, 240)
    }).TextWrapped = true

    local v21 = UIKit.frame(v20, {
        Class = "TextButton",
        Name = "Switch",
        Corner = 29,
        Stroke = 5,
        ZIndex = 13,
        Size = UDim2.fromOffset(128, 58),
        Position = UDim2.new(1, -18, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Color = Colors.Green,
        Color2 = Colors.GreenDark
    })

    v21.Text = ""
    v21:FindFirstChildOfClass("UIStroke").ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIKit.frame(v21, {
        Name = "Shine",
        Transparency = 0.65,
        Corner = 5,
        ZIndex = 14,
        Size = UDim2.new(1, -24, 0, 10),
        Position = UDim2.fromOffset(12, 6),
        Color = Colors.White
    })

    local v22 = UIKit.text(v21, {
        Name = "Label",
        Text = "ON",
        TextSize = 24,
        Stroke = 3,
        ZIndex = 14,
        Size = UDim2.new(0.55, 0, 1, 0),
        Position = UDim2.fromScale(0.08, 0)
    })
    local v23 = UIKit.frame(v21, {
        Name = "Knob",
        Corner = 23,
        Stroke = 4,
        ZIndex = 15,
        Size = UDim2.fromOffset(46, 46),
        Position = UDim2.new(1, -6, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Color = Colors.White,
        Color2 = fromRGB(214, 220, 236)
    })
    local LocalPlayer = game:GetService("Players").LocalPlayer

    local function owned() -- line: 149
        -- upvalues: p20 (copy), LocalPlayer (copy)
        if p20.owns == nil then
            return true
        end

        return LocalPlayer:GetAttribute(p20.owns) == true
    end

    UIKit.bindPress(v21, function() -- line: 152
        -- upvalues: p20 (copy), LocalPlayer (copy), ReplicatedStorage (copy), Remotes (copy), DataClient (copy)
        if p20.owns == nil or LocalPlayer:GetAttribute(p20.owns) == true then
            local key, key2 = p20.key, p20.key
            local v24 = (DataClient.Get("Settings") or {})[key2] ~= true

            task.spawn(function() -- line: 45
                -- upvalues: key (copy), v24 (copy), Remotes (copy)
                local function v25() -- line: 46
                    -- upvalues: key (copy), v24 (copy), Remotes (copy)
                    Remotes.SetSetting:InvokeServer(key, v24)
                end

                pcall(v25)
            end)
        else
            local Products = require(ReplicatedStorage:WaitForChild("Shared").Data.Products)

            for _, v26 in ipairs(Products.Gamepasses) do
                if v26.key == p20.pass then
                    game:GetService("MarketplaceService"):PromptGamePassPurchase(LocalPlayer, v26.id)
                end
            end
        end
    end)

    local v27 = true

    local function paint(p22) -- line: 165
        -- upvalues: p20 (copy), v21 (copy), v22 (copy), v23 (copy), LocalPlayer (copy), v27 (ref), UIKit (copy), Colors (copy), fromRGB (copy)
        local v28 = (p20.owns == nil or LocalPlayer:GetAttribute(p20.owns) == true) and p22 and p22[p20.key] == true

        v22.Text = v28 and "ON" or "OFF"
        v22.Position = UDim2.fromScale(v28 and 0.08 or 0.37, 0)

        local setButtonColor = UIKit.setButtonColor
        local v30 = if v28 then Colors.Green else fromRGB(130, 136, 156)
        local v29 = if v28 then Colors.GreenDark else fromRGB(76, 80, 98)

        setButtonColor(v21, v30, v29)

        local t6 = if v28 then {
            UDim2.new(1, -6, 0.5, 0),
            Vector2.new(1, 0.5)
        } else {
            UDim2.new(0, 6, 0.5, 0),
            Vector2.new(0, 0.5)
        }

        v23.AnchorPoint = t6[2]

        if v27 then
            v23.Position = t6[1]
            v27 = false
        else
            UIKit.tween(v23, 0.18, {
                Position = t6[1]
            }, Enum.EasingStyle.Back)
        end
    end

    DataClient.Observe("Settings", paint)

    if p20.owns then
        LocalPlayer:GetAttributeChangedSignal(p20.owns):Connect(function() -- line: 181
            -- upvalues: paint (copy), DataClient (copy)
            paint(DataClient.Get("Settings"))
        end)
    end
end

local function cutsceneRow(p23, p24, p25) -- line: 190
    -- upvalues: Remotes (copy), UIKit (copy), DataClient (copy), t1 (copy), Colors (copy), fromRGB (copy), Left (copy), t4 (copy), card (copy)
    local v31 = card(p23, "Cutscenes", 92, p24)

    UIKit.text(v31, {
        Name = "Label",
        Text = "Cutscenes",
        TextSize = 32,
        Stroke = 4,
        ZIndex = 13,
        Size = UDim2.new(1, -210, 0, 38),
        Position = UDim2.fromOffset(20, 8),
        XAlign = Left
    })

    local v32 = UIKit.text(v31, {
        Name = "Hint",
        Text = "",
        TextSize = 19,
        Stroke = 3,
        ZIndex = 13,
        Size = UDim2.new(1, -220, 0, 40),
        Position = UDim2.fromOffset(20, 46),
        XAlign = Left,
        YAlign = Enum.TextYAlignment.Top,
        Color = fromRGB(200, 210, 240)
    })

    v32.TextWrapped = true

    local v33 = UIKit.frame(p25 or p23, {
        Name = "CutscenePanel",
        Corner = 18,
        Stroke = 4,
        ZIndex = 30,
        Size = UDim2.fromScale(1, 1),
        Color = fromRGB(40, 48, 104),
        Color2 = fromRGB(16, 18, 44)
    })

    UIKit.dress(v33, 18, fromRGB(170, 190, 255))
    v33.Active = true
    v33.Visible = false
    UIKit.text(v33, {
        Name = "Title",
        Text = "CHOOSE YOUR CUTSCENES",
        TextSize = 34,
        Stroke = 4,
        ZIndex = 31,
        Size = UDim2.new(1, -32, 0, 40),
        Position = UDim2.fromOffset(16, 12),
        XAlign = Left,
        Color = Colors.Gold
    })

    local v34 = UIKit.text(v33, {
        Name = "Note",
        Text = "",
        TextSize = 21,
        Stroke = 3,
        ZIndex = 31,
        Size = UDim2.new(1, -32, 0, 28),
        Position = UDim2.fromOffset(16, 54),
        XAlign = Left,
        Color = Colors.Grey
    })

    v34.Text = "Switch off the ones you don't want to see."

    local function isOn(p26) -- line: 204
        -- upvalues: DataClient (copy)
        local v35 = "Cut_" .. p26

        return (DataClient.Get("Settings") or {})[v35] ~= false
    end

    for v36, v37 in ipairs(t4) do
        local v38 = (v36 - 1) % 2
        local v40 = math.floor((v36 - 1) / 2)
        local v41 = UIKit.frame(v33, {
            Corner = 14,
            Stroke = 3,
            ZIndex = 31,
            Name = v37.id,
            Size = UDim2.new(0.5, -22, 0, 74),
            Position = UDim2.new(v38 * 0.5, v38 == 0 and 16 or 6, 0, v40 * 82 + 96),
            Color = fromRGB(66, 82, 156),
            Color2 = fromRGB(30, 36, 80)
        })

        UIKit.dress(v41, 14, fromRGB(170, 190, 255))
        UIKit.text(v41, {
            Name = "Label",
            TextSize = 23,
            Stroke = 3,
            ZIndex = 32,
            Text = v37.name,
            Size = UDim2.new(1, -124, 1, 0),
            Position = UDim2.fromOffset(12, 0),
            XAlign = Left
        })

        local v51, v52 = UIKit.button(v41, {
            Name = "Switch",
            Text = "ON",
            Corner = 12,
            Stroke = 4,
            TextStroke = 4,
            ZIndex = 32,
            Size = UDim2.fromOffset(100, 52),
            Position = UDim2.new(1, -10, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            Color = Colors.Green,
            Color2 = Colors.GreenDark,
            OnClick = function() -- OnClick | line: 213
                -- upvalues: v34 (copy), v37 (copy), Remotes (copy), UIKit (copy), DataClient (copy), Colors (copy), t4 (copy)
                local v42 = "Cut_" .. v37.id
                local v43 = (DataClient.Get("Settings") or {})[v42] ~= false
                local v44

                if v43 then
                    local n2 = 0

                    for _, v45 in ipairs(t4) do
                        if v45.id ~= v37.id then
                            local v46 = "Cut_" .. v45.id

                            if (DataClient.Get("Settings") or {})[v46] ~= false then
                                n2 += 1
                            end
                        end
                    end

                    v44 = n2 == 0
                end

                if not v43 or not v44 then
                    v34.Text = "Switch off the ones you don't want to see."
                    v34.TextColor3 = Colors.Grey

                    local v47 = "Cut_" .. v37.id
                    local v48 = "Cut_" .. v37.id
                    local v49 = (DataClient.Get("Settings") or {})[v48] == false

                    task.spawn(function() -- line: 45
                        -- upvalues: v47 (copy), v49 (copy), Remotes (copy)
                        local function v50() -- line: 46
                            -- upvalues: v47 (copy), v49 (copy), Remotes (copy)
                            Remotes.SetSetting:InvokeServer(v47, v49)
                        end

                        pcall(v50)
                    end)
                else
                    v34.Text = "At least one cutscene has to stay on!"
                    v34.TextColor3 = Colors.Red
                    UIKit.pop(v34, 1.1)
                end
            end
        })

        DataClient.Observe("Settings", function(p27) -- line: 232
            -- upvalues: v37 (copy), v51 (copy), v52 (copy), UIKit (copy), Colors (copy)
            local v53 = not (p27 and p27["Cut_" .. v37.id] == false)

            v52.Text = v53 and "ON" or "OFF"

            local setButtonColor = UIKit.setButtonColor
            local v55 = if v53 then Colors.Green else Colors.Red
            local v54 = if v53 then Colors.GreenDark else Colors.RedDark

            setButtonColor(v51, v55, v54)
        end)
    end

    local v57 = math.ceil(#t4 / 2) * 82 + 96 + 8

    UIKit.button(v33, {
        Name = "AllOn",
        Text = "ALL ON",
        Corner = 12,
        Stroke = 4,
        TextStroke = 4,
        ZIndex = 31,
        Size = UDim2.new(0.5, -22, 0, 58),
        Position = UDim2.new(0, 16, 0, v57),
        Color = Colors.Green,
        Color2 = Colors.GreenDark,
        OnClick = function() -- OnClick | line: 240
            -- upvalues: v34 (copy), Remotes (copy), DataClient (copy), Colors (copy), t4 (copy)
            for _, v58 in ipairs(t4) do
                local v59 = "Cut_" .. v58.id

                if (DataClient.Get("Settings") or {})[v59] == false then
                    local v60 = "Cut_" .. v58.id
                    local spawn = task.spawn
                    local v61 = true

                    spawn(function() -- line: 45
                        -- upvalues: v60 (copy), v61 (copy), Remotes (copy)
                        local function v62() -- line: 46
                            -- upvalues: v60 (copy), v61 (copy), Remotes (copy)
                            Remotes.SetSetting:InvokeServer(v60, v61)
                        end

                        pcall(v62)
                    end)
                end
            end

            v34.Text = "Switch off the ones you don't want to see."
            v34.TextColor3 = Colors.Grey
        end
    })
    UIKit.button(v33, {
        Name = "Back",
        Text = "BACK",
        Corner = 12,
        Stroke = 4,
        TextStroke = 4,
        ZIndex = 31,
        Size = UDim2.new(0.5, -22, 0, 58),
        Position = UDim2.new(0.5, 6, 0, v57),
        Color = Colors.Red,
        Color2 = Colors.RedDark,
        OnClick = function() -- OnClick | line: 249
            -- upvalues: v33 (copy)
            v33.Visible = false
        end
    })
    UIKit.button(v31, {
        Name = "Choose",
        Text = "CHOOSE",
        Corner = 14,
        Stroke = 5,
        TextStroke = 4,
        ZIndex = 13,
        Size = UDim2.fromOffset(170, 60),
        Position = UDim2.new(1, -18, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Color = Colors.Green,
        Color2 = Colors.GreenDark,
        OnClick = function() -- OnClick | line: 252
            -- upvalues: v33 (copy), v34 (copy), Colors (copy)
            v34.Text = "Switch off the ones you don't want to see."
            v34.TextColor3 = Colors.Grey
            v33.Visible = true
        end
    })
    DataClient.Observe("Settings", function(p28) -- line: 257
        -- upvalues: v32 (copy), t4 (copy)
        local n3 = 0

        for _, v63 in ipairs(t4) do
            if not p28 or p28["Cut_" .. v63.id] ~= false then
                n3 += 1
            end
        end

        v32.Text = ("Pick which catch cutscenes you see. %d of %d on"):format(n3, #t4)
    end)
    t1.CutscenePanel = v33
end

local function buildGear(p29) -- line: 270
    -- upvalues: UIKit (copy), t1 (copy)
    local v64 = require(script.Parent.TopBar).RoundButton("Gear", 30)
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Icon"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://100876611167014"
    ImageLabel.ScaleType = Enum.ScaleType.Fit
    ImageLabel.Size = UDim2.fromOffset(32, 32)
    ImageLabel.Position = UDim2.fromScale(0.5, 0.5)
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.ZIndex = 2
    ImageLabel.Parent = v64
    UIKit.bindPress(v64, function() -- line: 284
        -- upvalues: p29 (copy)
        p29.Toggle()
    end)
    game:GetService("RunService").RenderStepped:Connect(function(p30) -- line: 288
        -- upvalues: p29 (copy), ImageLabel (copy)
        if p29.IsOpen then
            ImageLabel.Rotation = (ImageLabel.Rotation + p30 * 90) % 360
        end
    end)
    t1.Button = v64
end

function t1.Init() -- line: 296
    -- upvalues: Remotes (copy), UIKit (copy), GroupService (copy), t1 (copy), Colors (copy), fromRGB (copy), Left (copy), t2 (copy), t3 (copy), heading (copy), sliderRow (copy), switchRow (copy), cutsceneRow (copy), buildGear (copy)
    local Settings = UIKit.Windows.Settings
    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Name = "List"
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Size = UDim2.fromScale(1, 1)
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollingFrame.ScrollBarThickness = 10
    ScrollingFrame.ScrollBarImageColor3 = Colors.Grey
    ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    ScrollingFrame.ZIndex = 12
    ScrollingFrame.Parent = Settings.Content
    heading(ScrollingFrame, "Head1", "VOLUME", 4, fromRGB(255, 110, 190))

    local n4 = 42

    for _, v65 in ipairs(t2) do
        sliderRow(ScrollingFrame, v65, n4)
        n4 += 104
    end

    heading(ScrollingFrame, "Head2", "GAMEPLAY", n4 + 4, fromRGB(80, 190, 255))

    local v66 = n4 + 42

    for _, v67 in ipairs(t3) do
        switchRow(ScrollingFrame, v67, v66)
        v66 += 100
    end

    cutsceneRow(ScrollingFrame, v66, Settings.Content)

    local v68 = v66 + 100

    heading(ScrollingFrame, "Head3", "CODES", v68 + 4, fromRGB(255, 196, 50))

    local v70 = v68 + 42
    local v71 = UIKit.frame(ScrollingFrame, {
        Name = "Codes",
        Corner = 16,
        Stroke = 4,
        ZIndex = 12,
        Size = UDim2.new(1, -10, 0, 148),
        Position = UDim2.fromOffset(5, v70),
        Color = fromRGB(150, 104, 30),
        Color2 = fromRGB(70, 42, 14)
    })

    UIKit.dress(v71, 16, fromRGB(255, 226, 150))
    UIKit.text(v71, {
        Name = "Hint",
        Text = "Like the game and join the group to redeem!",
        TextSize = 23,
        Stroke = 3,
        ZIndex = 13,
        Size = UDim2.new(1, -32, 0, 28),
        Position = UDim2.fromOffset(16, 8),
        XAlign = Left,
        Color = Colors.Gold
    })

    local TextBox = Instance.new("TextBox")

    TextBox.Name = "Box"
    TextBox.Size = UDim2.new(1, -196, 0, 56)
    TextBox.Position = UDim2.fromOffset(16, 44)
    TextBox.BackgroundColor3 = Color3.fromRGB(26, 20, 14)
    TextBox.BackgroundTransparency = 0.15
    TextBox.TextColor3 = Color3.new(1, 1, 1)
    TextBox.PlaceholderText = "Enter code here"
    TextBox.PlaceholderColor3 = Color3.fromRGB(130, 136, 160)
    TextBox.Text = ""
    TextBox.Font = Enum.Font.FredokaOne
    TextBox.TextSize = 28
    TextBox.ClearTextOnFocus = false
    TextBox.ZIndex = 13

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = TextBox

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Thickness = 4
    UIStroke.Color = Color3.fromRGB(20, 22, 34)
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = TextBox
    TextBox.Parent = v71

    local v72 = UIKit.text(v71, {
        Name = "Result",
        Text = "",
        TextSize = 21,
        Stroke = 3,
        ZIndex = 13,
        Size = UDim2.new(1, -32, 0, 30),
        Position = UDim2.fromOffset(16, 108),
        XAlign = Left
    })

    local function show(p31, p32) -- line: 356
        -- upvalues: v72 (copy), UIKit (copy), t1 (copy)
        v72.Text = p31
        v72.TextColor3 = p32
        t1.CodeResult = p31
        UIKit.pop(v72, 1.1)
    end

    local v73 = false

    local function redeem(p33) -- line: 363
        -- upvalues: TextBox (copy), v72 (copy), v73 (ref), redeem (copy), Remotes (copy), UIKit (copy), GroupService (copy), t1 (copy), Colors (copy)
        local Text = TextBox.Text

        if v73 or Text:gsub("%s", "") == "" then
            return
        end

        v73 = true

        local function v74() -- line: 369
            -- upvalues: p33 (copy), Text (copy), Remotes (copy)
            return Remotes.RedeemCode:InvokeServer(Text, p33 == true)
        end

        local ok, result = pcall(v74)

        v73 = false

        if not ok or type(result) ~= "table" then
            local Red = Colors.Red

            v72.Text = "Something went wrong. Try again."
            v72.TextColor3 = Red
            t1.CodeResult = "Something went wrong. Try again."
            UIKit.pop(v72, 1.1)
        elseif not result.needGroup or p33 then
            local v75 = tostring(result.message)
            local v76 = if result.ok then Colors.Green else Colors.Red

            v72.Text = v75
            v72.TextColor3 = v76
            t1.CodeResult = v75
            UIKit.pop(v72, 1.1)

            if result.ok then
                TextBox.Text = ""
                UIKit.sound("ToastGold")
            end
        else
            local Gold = Colors.Gold

            v72.Text = "Join the group to redeem codes!"
            v72.TextColor3 = Gold
            t1.CodeResult = "Join the group to redeem codes!"
            UIKit.pop(v72, 1.1)

            local function v77() -- line: 379
                -- upvalues: result (copy), GroupService (copy)
                return GroupService:PromptJoinAsync(result.groupId)
            end

            local ok, result2 = pcall(v77)

            if ok and (result2 == Enum.GroupMembershipStatus.Joined or result2 == Enum.GroupMembershipStatus.AlreadyMember) then
                redeem(true)
            else
                if not ok or result2 ~= Enum.GroupMembershipStatus.JoinRequestPending then
                    local Gold = Colors.Gold

                    v72.Text = "Join the group, then press REDEEM again."
                    v72.TextColor3 = Gold
                    t1.CodeResult = "Join the group, then press REDEEM again."
                else
                    local Gold = Colors.Gold

                    v72.Text = "Your request to join is waiting. Try the code again once you're in!"
                    v72.TextColor3 = Gold
                    t1.CodeResult = "Your request to join is waiting. Try the code again once you're in!"
                end

                UIKit.pop(v72, 1.1)
            end
        end
    end

    t1.Redeem = function(p34) -- line: 397
        -- upvalues: TextBox (copy), redeem (copy)
        TextBox.Text = p34
        redeem()
    end

    UIKit.button(v71, {
        Name = "Redeem",
        Text = "REDEEM",
        Corner = 12,
        Stroke = 4,
        TextStroke = 4,
        ZIndex = 13,
        Size = UDim2.fromOffset(160, 56),
        Position = UDim2.new(1, -16, 0, 44),
        AnchorPoint = Vector2.new(1, 0),
        Color = Colors.Green,
        Color2 = Colors.GreenDark,
        OnClick = function() -- OnClick | line: 401
            -- upvalues: redeem (copy)
            redeem()
        end
    })
    TextBox.FocusLost:Connect(function(p35) -- line: 404
        -- upvalues: redeem (copy)
        if p35 then
            redeem()
        end
    end)

    local v78 = v70 + 162

    ScrollingFrame.CanvasSize = UDim2.fromOffset(0, v78)

    local v79 = v78 + 88 + 10

    Settings.Frame.Size = UDim2.fromOffset(640, v79)

    Settings.FitHeight = function(p36) -- line: 415
        -- upvalues: Settings (copy), v79 (copy)
        Settings.Frame.Size = UDim2.fromOffset(640, (math.clamp(p36, 560, v79)))
    end

    buildGear(Settings)
end

return t1
