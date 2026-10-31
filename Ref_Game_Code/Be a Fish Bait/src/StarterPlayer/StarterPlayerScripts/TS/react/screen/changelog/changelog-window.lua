-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out")
local useBindingState, useViewport = out.useBindingState, out.useViewport
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-window").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local changelogEntries = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "changelog-utils").changelogEntries

local function joinList(p1) -- line: 14
    return table.concat(p1, " | ")
end

local function getChangelogDetailText(p2) -- line: 17
    return (string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(p2, "\"OFFICIAL\"", "<font color=\"#FFD84D\"><b>\"OFFICIAL\"</b></font>"), "\"SHARDS\"", "<font color=\"#FFD84D\"><b>\"SHARDS\"</b></font>"), "\"HOOLALALA\"", "<font color=\"#FFD84D\"><b>\"HOOLALALA\"</b></font>"), "BAITAURA", "<font color=\"#FFD84D\"><b>BAITAURA</b></font>"), "%+15%% cash", "<font color=\"#6CFF72\"><b>+15%% cash</b></font>"), "%+20%% mutation luck", "<font color=\"#6CFF72\"><b>+20%% mutation luck</b></font>"), "93%% OFF", "<font color=\"#FFD84D\"><b>93%% OFF</b></font>"))
end

local function getRelativeUpdateDate(p3) -- line: 20
    local v3 = math.max(0, (math.floor((DateTime.now().UnixTimestamp - p3.UnixTimestamp) / 86400)))

    if v3 == 0 then
        return "Today"
    end

    return (("%* %* ago"):format(v3, if v3 == 1 then "Day" else "Days"))
end

local function InnerBox(p4) -- line: 29
    -- upvalues: react (copy)
    return react.createElement("frame", {
        AutomaticSize = p4.automaticSize,
        BackgroundColor3 = Color3.fromRGB(48, 64, 68),
        LayoutOrder = p4.layoutOrder,
        Position = p4.position,
        Size = p4.size
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.08, 0)
    }), react.createElement("uistroke", {
        Thickness = 2,
        Transparency = 0.05,
        Color = Color3.fromRGB(28, 28, 28)
    }), p4.children)
end

local function TitleText(p5) -- line: 44
    -- upvalues: react (copy), default3 (copy)
    local t1 = {
        color = p5.color,
        gradientRotation = p5.gradientRotation
    }
    local t2 = {
        AnchorPoint = Vector2.new(0.5, 0.5),
        LayoutOrder = p5.layoutOrder,
        Position = p5.position or UDim2.fromScale(0.5, 0.5),
        Size = p5.size
    }
    local textScaled = p5.textScaled

    t2.TextScaled = textScaled == nil or textScaled
    t2.TextSize = p5.textSize

    local textWrapped = p5.textWrapped

    t2.TextWrapped = textWrapped == nil or textWrapped
    t2.TextXAlignment = p5.textXAlignment or Enum.TextXAlignment.Center
    t1.overrideProps = t2
    t1.popoutColor = Color3.fromRGB(35, 35, 35)
    t1.shadowYScale = 0.1
    t1.strokeProps = {
        Thickness = 0.06,
        Color = Color3.fromRGB(35, 35, 35),
        StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    }
    t1.text = p5.text

    return react.createElement(default3, t1)
end

local v4 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 247, 117)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 181, 67)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 92, 92))
})
local v5 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 121, 221)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 45, 160)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 98))
})
local t3 = {
    lg = 24,
    md = 18,
    sm = 14
}
local t4 = {
    lg = 18,
    md = 15,
    sm = 12
}
local t5 = {
    lg = 20,
    md = 16,
    sm = 14
}
local v6 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(92, 223, 255)),
    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(80, 154, 255)),
    ColorSequenceKeypoint.new(0.42, Color3.fromRGB(71, 235, 214)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(71, 235, 214))
})

local function ChangelogDetailLine(p6) -- line: 103
    -- upvalues: react (copy), getChangelogDetailText (copy)
    return react.createElement("textlabel", {
        BackgroundTransparency = 1,
        LineHeight = 1.15,
        RichText = true,
        TextScaled = false,
        TextWrapped = true,
        AutomaticSize = Enum.AutomaticSize.Y,
        Font = Enum.Font.GothamBold,
        LayoutOrder = p6.layoutOrder,
        Size = UDim2.new(1, 0, 0, p6.textSize + 4),
        Text = ("%* %*"):format(utf8.char(8226), (getChangelogDetailText(p6.text))),
        TextColor3 = Color3.fromRGB(242, 242, 242),
        TextSize = p6.textSize,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    }, react.createElement("uipadding", {
        PaddingLeft = UDim.new(0, p6.indent)
    }), react.createElement("uistroke", {
        Thickness = 1.3,
        Transparency = 0.05,
        Color = Color3.fromRGB(25, 25, 25)
    }), p6.gradient ~= nil and react.createElement("uigradient", {
        Rotation = 0,
        Color = p6.gradient
    }))
end

local function ChangelogDetailRow(p7) -- line: 130
    -- upvalues: react (copy), v5 (copy), v6 (copy), ChangelogDetailLine (copy)
    local detail = p7.detail
    local children = detail.children

    if children == nil then
        children = {}
    end

    local highlight, text = detail.highlight, detail.text
    local v8 = math.round(p7.textSize * 1.4)
    local v9 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = UDim.new(0, 1),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top
    })
    local v10 = react.createElement(ChangelogDetailLine, {
        indent = 0,
        layoutOrder = 1,
        gradient = if highlight == "major" then v5 elseif highlight == "feature" then v6 else nil,
        text = text,
        textSize = p7.textSize
    })
    local v11 = table.create(#children)

    for v12, v13 in children do
        local v14 = v12 - 1

        v11[v12] = react.createElement(ChangelogDetailLine, {
            indent = v8,
            key = ("%*-%*"):format(v14, v13),
            layoutOrder = v14 + 2,
            text = v13,
            textSize = p7.textSize
        })
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = p7.layoutOrder,
        Size = UDim2.new(1, 0, 0, 0)
    }, v9, v10, v11)
end

local function ChangelogUpdateButton(p8) -- line: 175
    -- upvalues: react (copy), default2 (copy), InnerBox (copy), TitleText (copy), v4 (copy), v5 (copy)
    local entry, isSelected, layoutOrder, onSelect = p8.entry, p8.isSelected, p8.layoutOrder, p8.onSelect
    local v15 = entry.isMajor == true
    local createElement = react.createElement
    local t7 = {
        cornerRadius = 0.04,
        isStudded = true,
        textureTransparency = 0.6,
        tileSize = 80,
        transparency = 0.4,
        backgroundColor = if isSelected then Color3.fromRGB(117, 123, 125) else Color3.fromRGB(82, 86, 88),
        layoutOrder = layoutOrder,
        size = UDim2.fromScale(0.92, 0.22),
        strokeColor = Color3.fromRGB(36, 36, 36),
        strokeThickness = isSelected and 0.016 or 0.01
    }
    local v16 = react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 4,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.025, 0)
    }), react.createElement("uistroke", {
        Thickness = 0.01,
        Transparency = 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Color3.fromRGB(12, 12, 12),
        StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    }))
    local createElement2 = react.createElement
    local t8 = {
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 3,
        Event = {
            Activated = onSelect
        },
        Size = UDim2.fromScale(1, 1)
    }
    local createElement3 = react.createElement
    local t9 = {
        position = UDim2.fromScale(0.06, 0.12),
        size = UDim2.fromScale(0.88, 0.76)
    }
    local v17 = react.createElement(TitleText, {
        gradientRotation = 0,
        color = if v15 then v5 else v4,
        position = UDim2.fromScale(0.5, 0.38),
        size = UDim2.fromScale(0.86, 0.42),
        text = ("Update %*"):format(entry.version),
        textXAlignment = Enum.TextXAlignment.Left
    })
    local createElement5 = react.createElement
    local t11 = {
        color = Color3.fromRGB(178, 232, 255),
        position = UDim2.fromScale(0.5, 0.76),
        size = UDim2.fromScale(0.86, 0.28)
    }
    local date = entry.date
    local v20 = math.max(0, (math.floor((DateTime.now().UnixTimestamp - date.UnixTimestamp) / 86400)))

    t11.text = if v20 == 0 then "Today" else ("%* %* ago"):format(v20, v20 == 1 and "Day" or "Days")
    t11.textXAlignment = Enum.TextXAlignment.Left

    return createElement(default2, t7, v16, createElement2("textbutton", t8, createElement3(InnerBox, t9, v17, createElement5(TitleText, t11))))
end

local function ChangelogDetails(p9) -- line: 232
    -- upvalues: react (copy), useBindingState (copy), useViewport (copy), default2 (copy), useScreenSizeState (copy), InnerBox (copy), TitleText (copy), v4 (copy), v5 (copy), t3 (copy), t4 (copy), t5 (copy), ChangelogDetailRow (copy)
    local entry = p9.entry
    local v21 = useScreenSizeState()
    local v22 = useBindingState(useViewport()).Y < 600
    local v23, v24, v25, v26, v27, v28

    if v22 then
        v23 = 13
        v24 = 12
        v28 = 13
        v25 = 4
        v26 = 42
        v27 = 30
    else
        v23 = t3[v21]
        v24 = t4[v21]
        v28 = t5[v21]
        v25 = 8
        v26 = math.round(v23 * 2.4)
        v27 = math.round(v24 * 2.1)
    end

    local v31 = entry.isMajor == true
    local v32 = react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 4,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.025, 0)
    }), react.createElement("uistroke", {
        Thickness = 0.01,
        Transparency = 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Color3.fromRGB(12, 12, 12),
        StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    }))
    local v33 = react.createElement("uipadding", {
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 4),
        PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 4)
    })
    local v34 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = UDim.new(0, v25),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top
    })
    local v35 = react.createElement(InnerBox, {
        layoutOrder = 1,
        size = UDim2.new(1, 0, 0, v26)
    }, react.createElement(TitleText, {
        gradientRotation = 0,
        textScaled = false,
        color = if v31 then v5 else v4,
        size = UDim2.new(0.92, 0, 1, -8),
        text = ("Update %* - %*"):format(entry.version, entry.mainName),
        textSize = v23,
        textXAlignment = Enum.TextXAlignment.Left
    }))
    local createElement3 = react.createElement
    local t14 = {
        layoutOrder = 2,
        textScaled = false,
        color = Color3.fromRGB(178, 232, 255),
        size = UDim2.new(1, 0, 0, v27)
    }
    local categories = entry.categories

    t14.text = table.concat(categories, " | ")
    t14.textSize = v24
    t14.textXAlignment = Enum.TextXAlignment.Left

    local v36 = createElement3(TitleText, t14)
    local v37 = react.createElement("uipadding", {
        PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 10)
    })
    local v38 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = UDim.new(0, v22 and 4 or 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top
    })
    local details = entry.details
    local v39 = table.create(#details)

    for v40, v41 in details do
        local v42 = v40 - 1

        v39[v40] = react.createElement(ChangelogDetailRow, {
            detail = v41,
            key = ("%*-%*-%*"):format(entry.version, v42, v41.text),
            layoutOrder = v42 + 1,
            textSize = v28
        })
    end

    return react.createElement(default2, {
        cornerRadius = 0.025,
        isStudded = true,
        strokeThickness = 0.01,
        textureTransparency = 0.6,
        tileSize = 80,
        transparency = 0.4,
        backgroundColor = Color3.fromRGB(99, 99, 99),
        size = UDim2.fromScale(1, 1),
        strokeColor = Color3.fromRGB(36, 36, 36)
    }, v32, react.createElement("scrollingframe", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ScrollBarThickness = 6,
        ZIndex = 5,
        AnchorPoint = Vector2.new(0.5, 0.5),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
        Position = UDim2.fromScale(0.5, 0.5),
        ScrollBarImageColor3 = Color3.fromRGB(10, 10, 10),
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Size = UDim2.fromScale(0.92, 0.9)
    }, v33, v34, v35, v36, react.createElement(InnerBox, {
        layoutOrder = 3,
        automaticSize = Enum.AutomaticSize.Y,
        size = UDim2.new(1, 0, 0, 0)
    }, v37, v38, v39)))
end

return {
    default = function(p10) -- ChangelogWindow | line: 349
        -- upvalues: react (copy), useState (copy), useBindingState (copy), useViewport (copy), default (copy), changelogEntries (copy), ChangelogUpdateButton (copy), ChangelogDetails (copy)
        local v43 = changelogEntries[1]

        if v43 ~= nil then
            v43 = v43.version
        end

        local v44, v45 = useState(v43)
        local v46 = useBindingState(useViewport()).Y < 600
        local v47

        for v48, v49 in changelogEntries do
            local _ = v48 - 1

            if v49.version == v44 == true then
                v47 = v49
                break
            end

            v47 = nil
        end

        if v47 == nil then
            v47 = changelogEntries[1]
        end

        local v50 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(v46 and 0.015 or 0.025, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        })
        local v51 = react.createElement("uicorner", {
            CornerRadius = UDim.new(0.025, 0)
        })
        local v52 = react.createElement("uistroke", {
            Thickness = 2,
            Transparency = 0.05,
            Color = Color3.fromRGB(28, 28, 28)
        })
        local v53 = react.createElement("uipadding", {
            PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 4),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 8)
        })
        local v54 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.025, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Top
        })
        local v55 = table.create(#changelogEntries)

        local function v56(p11, p12) -- line: 404
            -- upvalues: v44 (copy), v45 (copy), react (copy), ChangelogUpdateButton (copy)
            return react.createElement(ChangelogUpdateButton, {
                entry = p11,
                isSelected = v44 == p11.version,
                key = p11.version,
                layoutOrder = p12 + 1,
                onSelect = function() -- onSelect | line: 410
                    -- upvalues: p11 (copy), v45 (copy)
                    return v45(p11.version)
                end
            })
        end

        for v57, v58 in changelogEntries do
            v55[v57] = v56(v58, v57 - 1, changelogEntries)
        end

        return react.createElement(default, {
            aspectRatio = 1.55,
            title = "Update Log",
            bodyBg = Color3.fromRGB(60, 60, 60),
            headerBg = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(177, 177, 177)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(152, 152, 152)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(121, 121, 121))
            }),
            onClose = p10.onClose,
            size = UDim2.fromScale(0.78, 0.55)
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.54),
            Size = UDim2.fromScale(0.94, 0.82)
        }, v50, react.createElement("scrollingframe", {
            BorderSizePixel = 0,
            ClipsDescendants = true,
            LayoutOrder = 1,
            ScrollBarThickness = 5,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Color3.fromRGB(48, 64, 68),
            CanvasSize = UDim2.new(),
            ScrollBarImageColor3 = Color3.fromRGB(10, 10, 10),
            ScrollingDirection = Enum.ScrollingDirection.Y,
            Size = UDim2.fromScale(v46 and 0.29 or 0.34, 1)
        }, v51, v52, v53, v54, v55, react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = #changelogEntries + 1,
            Size = UDim2.new(1, 0, 0, 64)
        })), react.createElement("frame", {
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            Size = UDim2.fromScale(v46 and 0.695 or 0.64, 1)
        }, v47 and react.createElement(ChangelogDetails, {
            entry = v47
        }))))
    end
}
