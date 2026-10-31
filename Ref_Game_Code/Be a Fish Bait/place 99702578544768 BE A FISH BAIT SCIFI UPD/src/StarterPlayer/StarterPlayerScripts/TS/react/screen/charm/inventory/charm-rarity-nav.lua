-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local charmData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "charms").charmData
local rarityColors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").rarityColors
local t1 = {}

for _, v1 in charmData do
    local rarity = v1.rarity

    if table.find(t1, rarity) == nil then
        table.insert(t1, v1.rarity)
    end
end

local t2 = {
    "all"
}
local v2 = #t2

table.move(t1, 1, #t1, v2 + 1, t2)

local getRarityNavStyle

local function CharmRarityNav(p1) -- line: 21
    -- upvalues: react (copy), default (copy), useScreenSizeState (copy), t2 (copy), getRarityNavStyle (ref)
    local v3 = useScreenSizeState()
    local v4, v5

    if v3 == "sm" or v3 == "md" then
        v5 = 0.22
        v4 = 7
    else
        v5 = 0.2
        v4 = 8
    end

    local v6 = react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, v4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    })
    local v7 = table.create(#t2)

    local function v8(p2, p3) -- line: 35
        -- upvalues: p1 (copy), v5 (ref), react (copy), default (copy), getRarityNavStyle (ref)
        local v9 = p1.selectedRarity == p2
        local v10 = getRarityNavStyle(p2)

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = p3,
            Size = UDim2.fromScale(1, v5),
            ZIndex = 31 + p3,
            key = p2
        }, react.createElement(default, {
            gradientRotation = 90,
            color = v10.gradient,
            cornerRadius = v9 and 0.075 or 0.055,
            frameSize = UDim2.fromScale(v9 and 1.08 or 0.98, v9 and 1 or 0.92),
            label = if p2 == "all" then "ALL" else string.upper(p2),
            onClick = function() -- onClick | line: 51
                -- upvalues: p2 (copy), p1 (copy)
                return p1.onSelectedRarityChanged(p2)
            end,
            popoutColor = if v9 then Color3.fromRGB(18, 18, 18) else v10.popoutColor,
            zIndex = 32 + p3
        }))
    end

    for v11, v12 in t2 do
        v7[v11] = v8(v12, v11 - 1, t2)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 30,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(-0.018, 0.54),
        Size = UDim2.fromScale(0.18, 0.58)
    }, v6, v7)
end

function getRarityNavStyle(p4) -- line: 71
    -- upvalues: rarityColors (copy)
    local v13 = if p4 == "all" then Color3.fromRGB(160, 160, 160) else rarityColors[p4]
    local v14 = Color3.new(1, 1, 1)
    local v15 = Color3.new(0, 0, 0)

    return {
        gradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, v13:Lerp(v14, 0.3)),
            ColorSequenceKeypoint.new(1, v13:Lerp(v15, 0.28))
        }),
        popoutColor = v13:Lerp(v15, 0.68)
    }
end

return {
    default = CharmRarityNav
}
