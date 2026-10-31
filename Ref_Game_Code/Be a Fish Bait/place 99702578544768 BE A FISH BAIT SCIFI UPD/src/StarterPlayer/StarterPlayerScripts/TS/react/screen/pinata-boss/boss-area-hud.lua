-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useMemo = react.useEffect, react.useMemo
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useProgressBarFade = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "react", "hooks", "use-progress-bar-fade").useProgressBarFade
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate")
local abbreviate2, formatDuration = abbreviate.abbreviate, abbreviate.formatDuration
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-countdown").default
local v1 = Color3.fromRGB(220, 60, 60)
local v2 = Color3.fromRGB(255, 180, 60)
local v3 = Color3.fromRGB(180, 180, 180)
local v4 = Color3.fromRGB(214, 140, 0)
local v5 = Color3.fromRGB(230, 230, 230)
local v6 = Color3.fromRGB(0, 0, 0)

local function getPlayerName(p1) -- line: 23
    -- upvalues: Players (copy)
    local v7 = tonumber(p1)

    if v7 == nil then
        return "Empty"
    end

    local v8

    for v9, player in (Players:GetPlayers()) do
        local _ = v9 - 1

        if player.UserId == v7 == true then
            v8 = player
            break
        end

        v8 = nil
    end

    if v8 ~= nil then
        v8 = v8.Name
    end

    if v8 == nil then
        v8 = "Empty"
    end

    return v8
end

local function ProgressBarWithFade(p2) -- line: 52
    -- upvalues: react (copy)
    local bar, cornerRadius = p2.bar, p2.cornerRadius

    if cornerRadius == nil then
        cornerRadius = 0.5
    end

    local fadeColor, mainColor, mainGradient, minFill = p2.fadeColor, p2.mainColor, p2.mainGradient, p2.minFill
    local v10 = minFill

    if minFill == nil then
        v10 = 0.1
    end

    local showFade = p2.showFade
    local v11 = UDim.new(cornerRadius, 0)

    showFade = showFade and react.createElement("frame", {
        BorderSizePixel = 0,
        ZIndex = 1,
        BackgroundColor3 = fadeColor,
        Size = bar.fadeEnd:map(function(p3) -- line: 70
            return UDim2.fromScale(math.max(p3, 0.01), 1)
        end)
    }, react.createElement("uicorner", {
        CornerRadius = v11
    }))

    local v12 = react.createElement("uicorner", {
        CornerRadius = v11
    })

    if mainGradient then
        local t2 = {
            Color = ColorSequence.new({
                mainGradient.keypoints[1],
                mainGradient.keypoints[2]
            })
        }
        local rotation = mainGradient.rotation

        t2.Rotation = if rotation == nil then 90 else rotation
        mainGradient = react.createElement("uigradient", t2)
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, showFade, react.createElement("frame", {
        BorderSizePixel = 0,
        ZIndex = 2,
        BackgroundColor3 = mainColor,
        Size = bar.mainFill:map(function(p4) -- line: 98
            -- upvalues: v10 (ref)
            return UDim2.fromScale(math.max(p4, v10), 1)
        end)
    }, v12, mainGradient))
end

local function ContributorSlot(p5) -- line: 104
    -- upvalues: react (copy), useEffect (copy), Players (copy), default (copy), default2 (copy), abbreviate2 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), getPlayerName (copy)
    local rank, userId, damage = p5.rank, p5.userId, p5.damage
    local v14 = if userId == nil then "Empty" else getPlayerName(userId)
    local v15 = if damage == nil then "Empty" else abbreviate2(damage)
    local v16, v17 = react.useState("")
    local v18 = if rank == 1 then v2 elseif rank == 2 then v3 else v4

    useEffect(function() -- line: 113
        -- upvalues: userId (copy), v17 (copy), Players (copy)
        if userId == nil then
            v17("")

            return nil
        end

        local v19 = tonumber(userId)

        if v19 == nil then
            return nil
        end

        local v20 = task.spawn(function() -- line: 122
            -- upvalues: v19 (copy), v17 (copy), Players (copy)
            v17((Players:GetUserThumbnailAsync(v19, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size352x352)))
        end)

        return function() -- line: 126
            -- upvalues: v20 (copy)
            return task.cancel(v20)
        end
    end, { userId })

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = if rank == 1 then UDim2.fromScale(0.125, 0.625) else UDim2.fromScale(0.125, 0.5)
    }, react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 2,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.3, 0),
        Size = UDim2.fromScale(0.35, 0.25)
    }, react.createElement(default2, {
        color = v18,
        overrideProps = {
            TextScaled = true,
            Size = UDim2.fromScale(1, 1)
        },
        text = ("#%*"):format(rank)
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0.015, 0),
        VerticalAlignment = Enum.VerticalAlignment.Top
    }), react.createElement(default, {
        cornerRadius = 0.5,
        strokeThickness = 0.045,
        backgroundColor = v5,
        size = UDim2.fromScale(0.9, 0.5),
        strokeColor = v6
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    }), v16 ~= "" and react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        Image = v16,
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(1, 0)
    }))), react.createElement(default2, {
        color = Color3.fromRGB(255, 255, 255),
        overrideProps = {
            TextScaled = true,
            Size = UDim2.fromScale(1, 0.2)
        },
        text = v14
    }), react.createElement(default2, {
        color = v18,
        overrideProps = {
            TextScaled = true,
            Size = UDim2.fromScale(1, 0.2)
        },
        text = v15
    })))
end

return {
    default = function(p6) -- BossAreaHud | line: 186
        -- upvalues: react (copy), useMemo (copy), default (copy), default2 (copy), useProgressBarFade (copy), formatDuration (copy), default3 (copy), v1 (copy), ProgressBarWithFade (copy), ContributorSlot (copy)
        local damageContributions, despawnTimestamp, hp, maxHp = p6.damageContributions, p6.despawnTimestamp, p6.hp, p6.maxHp
        local v26 = math.round(hp * 100) / 100
        local v28 = math.round(maxHp * 100) / 100
        local v31 = useProgressBarFade(if v28 > 0 then math.clamp(v26 / v28, 0, 1) else 0, {
            fadeDuration = 0.5
        })

        if not (despawnTimestamp > 0) then
            despawnTimestamp = nil
        end

        local v32 = default3(despawnTimestamp).secondsLeft:map(function(p7) -- line: 200
            -- upvalues: formatDuration (copy)
            if p7 > 0 then
                return (("%*"):format((formatDuration(p7))))
            end

            return ""
        end)
        local v33 = useMemo(function() -- line: 203
            -- upvalues: damageContributions (copy)
            local t6 = {}

            for v34, v35 in damageContributions do
                table.insert(t6, {
                    v34,
                    v35
                })
            end

            local t8 = {}

            for _, v36 in t6 do
                table.insert(t8, v36)
            end

            table.sort(t8, function(p8, p9) -- line: 213
                return p8[2] > p9[2]
            end)

            return {
                t8[1],
                t8[2],
                t8[3]
            }
        end, { damageContributions })
        local v37 = v33[1]
        local v38 = v33[2]
        local v39 = v33[3]
        local v40 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.1, 0),
            VerticalAlignment = Enum.VerticalAlignment.Top
        })
        local v41 = react.createElement(default, {
            cornerRadius = 0.5,
            strokeThickness = 0.045,
            backgroundColor = Color3.fromRGB(60, 60, 60),
            size = UDim2.fromScale(1, 0.1425),
            strokeColor = Color3.fromRGB(40, 40, 40)
        }, react.createElement(ProgressBarWithFade, {
            cornerRadius = 0.5,
            minFill = 0.1,
            bar = v31,
            fadeColor = Color3.fromRGB(255, 180, 180),
            mainColor = Color3.fromRGB(255, 120, 120),
            mainGradient = {
                rotation = 90,
                keypoints = {
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 150, 150)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 80, 80))
                }
            },
            showFade = v31.showFade
        }), react.createElement(default2, {
            color = v1,
            overrideProps = {
                TextScaled = true,
                ZIndex = 2,
                Position = UDim2.fromScale(0, 0),
                Size = UDim2.fromScale(1, 1)
            },
            text = ("%* / %* HP"):format(v26, v28)
        }), react.createElement(default2, {
            color = Color3.fromRGB(0, 255, 250),
            overrideProps = {
                TextScaled = true,
                ZIndex = 2,
                Position = UDim2.fromScale(0.38, 0),
                Size = UDim2.fromScale(1, 1)
            },
            text = v32
        }))
        local v42 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.02, 0),
            VerticalAlignment = Enum.VerticalAlignment.Top
        })
        local t9 = {
            damage = if v38 == nil then v38 else v38[2],
            rank = 2,
            userId = if v38 ~= nil then v38[1] else v38
        }
        local v43 = react.createElement(ContributorSlot, t9)
        local t10 = {
            damage = if v37 == nil then v37 else v37[2],
            rank = 1,
            userId = if v37 ~= nil then v37[1] else v37
        }
        local v44 = react.createElement(ContributorSlot, t10)
        local t11 = {
            damage = if v39 == nil then v39 else v39[2],
            rank = 3,
            userId = if v39 ~= nil then v39[1] else v39
        }

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 10,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.02),
            Size = UDim2.fromScale(0.6, 0.35)
        }, v40, v41, react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0.7)
        }, v42, v43, v44, react.createElement(ContributorSlot, t11)))
    end
}
