-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useMemo = react.useMemo
local default = RuntimeLib.import(script, script.Parent, "brainrot-style", "popout-text-two").default
local v1 = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-timeskip-reward")
local getTimeskipRewardDisplay, useTimeskipReward = v1.getTimeskipRewardDisplay, v1.useTimeskipReward
local moneyGradient = RuntimeLib.import(script, script.Parent.Parent, "screen", "hud", "stats-utils").moneyGradient
local playtimeSpinWheelAssets = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "playtime-spin-wheel-config").playtimeSpinWheelAssets

local function TimeSkipText(p1) -- line: 12
    -- upvalues: react (copy), default (copy)
    return react.createElement(default, {
        shadowYScale = 0.08,
        color = p1.color or Color3.fromRGB(255, 255, 255),
        overrideProps = {
            TextScaled = true,
            TextWrapped = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Font = Enum.Font.FredokaOne,
            Position = p1.position,
            Size = p1.size,
            ZIndex = p1.zIndex
        },
        strokeProps = {
            Thickness = 0.14,
            Color = Color3.fromRGB(0, 0, 0),
            StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        },
        text = p1.text,
        textTransparency = p1.transparency
    })
end

local function TimeskipRewardInner(p2) -- line: 34
    -- upvalues: react (copy), moneyGradient (copy), playtimeSpinWheelAssets (copy), TimeSkipText (copy)
    local zIndex = p2.zIndex

    if zIndex == nil then
        zIndex = 1
    end

    local iconImage = p2.iconImage

    if iconImage == nil then
        iconImage = playtimeSpinWheelAssets.TimeSkipIcon
    end

    local showMinutes = p2.showMinutes

    if showMinutes == nil then
        showMinutes = true
    end

    local n1 = 0.5
    local v2, v3

    if showMinutes then
        v2 = 0.86
        v3 = UDim2.fromScale(0.9, 0.2)
    else
        v2 = 0.2
        v3 = UDim2.fromScale(0.78, 0.2)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        LayoutOrder = p2.layoutOrder,
        Position = p2.position,
        Size = p2.size or UDim2.fromScale(1, 1),
        ZIndex = zIndex
    }, react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = iconImage,
        ImageTransparency = if iconImage == "" then 1 else p2.transparency,
        Position = UDim2.fromScale(0.5, n1),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.55, 0.55),
        ZIndex = zIndex
    }), iconImage == "" and react.createElement("textlabel", {
        BackgroundTransparency = 0.08,
        BorderSizePixel = 0,
        Text = "$",
        TextScaled = true,
        TextStrokeTransparency = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(31, 170, 61),
        Font = Enum.Font.FredokaOne,
        Position = UDim2.fromScale(0.5, n1),
        Size = UDim2.fromScale(0.48, 0.48),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
        TextTransparency = p2.transparency,
        ZIndex = zIndex
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(1, 0)
    }), react.createElement("uistroke", {
        Thickness = 3,
        Color = Color3.fromRGB(0, 0, 0)
    })), showMinutes and react.createElement(TimeSkipText, {
        position = UDim2.fromScale(0.5, 0.18),
        size = UDim2.fromScale(1.08, 0.22),
        text = p2.minutesText,
        transparency = p2.transparency,
        zIndex = zIndex + 1
    }), react.createElement(TimeSkipText, {
        color = moneyGradient,
        position = UDim2.fromScale(0.5, v2),
        size = v3,
        text = p2.cashText,
        transparency = p2.transparency,
        zIndex = zIndex + 1
    }))
end

return {
    default = function(p3) -- TimeskipReward | line: 105
        -- upvalues: react (copy), useMemo (copy), getTimeskipRewardDisplay (copy), TimeskipRewardInner (copy)
        local v4 = useMemo(function() -- line: 106
            -- upvalues: p3 (copy), getTimeskipRewardDisplay (copy)
            local minutes, totalMps = p3.minutes, p3.totalMps

            if totalMps == nil then
                totalMps = 0
            end

            return getTimeskipRewardDisplay(minutes, totalMps)
        end, {
            p3.minutes,
            p3.totalMps
        })
        local v5 = table.clone(p3)

        setmetatable(v5, nil)

        local cashText = p3.cashText

        v5.cashText = if cashText == nil then v4.cashText else cashText
        v5.minutesText = v4.minutesText

        return react.createElement(TimeskipRewardInner, v5)
    end,
    LiveTimeskipReward = function(p4) -- LiveTimeskipReward | line: 124
        -- upvalues: react (copy), useTimeskipReward (copy), TimeskipRewardInner (copy)
        local v6 = useTimeskipReward(p4.minutes)
        local v7 = table.clone(p4)

        setmetatable(v7, nil)
        v7.cashText = v6.cashText
        v7.minutesText = v6.minutesText

        return react.createElement(TimeskipRewardInner, v7)
    end
}
