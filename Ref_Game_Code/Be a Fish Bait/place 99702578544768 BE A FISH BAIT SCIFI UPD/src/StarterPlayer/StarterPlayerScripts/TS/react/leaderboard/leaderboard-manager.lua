-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local reflex = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex")
local useRootSelector, useRootSelectorCreator = reflex.useRootSelector, reflex.useRootSelectorCreator
local useFlameworkComponents = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-flamework-components").useFlameworkComponents
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "scrolling-frame").default
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent, "network").functions
local selectCountryLeaderboard = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "country-leaderboard.selectors").selectCountryLeaderboard
local selectPlayerCountry = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-country.selectors").selectPlayerCountry
local createPortal = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox").createPortal
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, Workspace = services.Players, services.Workspace
local abbreviate = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "abbreviate").abbreviate
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local default2 = RuntimeLib.import(script, script.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local default3 = RuntimeLib.import(script, script.Parent.Parent, "common", "styled-text-label").default
local v1 = RuntimeLib.import(script, script.Parent.Parent, "common", "use-exclusive-gradient-rotation")
local exclusiveEditionGradient, useExclusiveGradientRotation = v1.exclusiveEditionGradient, v1.useExclusiveGradientRotation
local useTheme = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-theme").useTheme
local icyFingersTitleSequence = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "titles").icyFingersTitleSequence
local t1 = {
    LeaderboardCelebrationReactionSticks = "celebrationReactionSticksCaught",
    LeaderboardCelebrationObby = "celebrationObbyRunsCompleted",
    LeaderboardCelebrationRgl = "celebrationRglRunsCompleted",
    LeaderbaordGlobal = "money",
    LeaderboardLocal = "money_local",
    LeaderboardPlaytime = "playtime",
    LeaderboardPower = "power",
    LeaderboardWhale = "totalRobuxSpent",
    LeaderboardFrostwyrm = "frostwyrmCaught",
    LeaderboardUncthulu = "uncThuluCaught"
}

local function getLeaderboardNameFromInstance(p1) -- line: 41
    -- upvalues: t1 (copy)
    local v2 = t1[p1.Name]

    if v2 ~= nil then
        return v2
    end

    local name = p1:GetAttribute("name")

    if name == "obby" then
        return "celebrationObbyRunsCompleted"
    end

    if name == "rgl" then
        return "celebrationRglRunsCompleted"
    end

    if name == "rxnSticks" then
        return "celebrationReactionSticksCaught"
    end

    if name == "celebrationReactionSticksCaught" or name == "celebrationObbyRunsCompleted" or name == "celebrationRglRunsCompleted" then
        return name
    end

    if name == "money" then
        return "money"
    end

    if name == "money_local" then
        return "money_local"
    end

    if name == "playtime" then
        return "playtime"
    end

    if name == "power" then
        return "power"
    end

    if name == "totalRobuxSpent" then
        return "totalRobuxSpent"
    end

    if name == "frostwyrmCaught" then
        return "frostwyrmCaught"
    end

    return if name == "uncThuluCaught" then "uncThuluCaught" else nil
end

local function getLeaderboardBindingKey(p2) -- line: 89
    return (("%*:%*"):format(p2.name, (p2.instance:GetFullName())))
end

local function getLeaderboardBindingsKey(p3) -- line: 92
    local v3 = table.create(#p3)

    for v4, v5 in p3 do
        local _ = v4 - 1

        v3[v4] = ("%*:%*"):format(v5.name, (v5.instance:GetFullName()))
    end

    table.sort(v3)

    return table.concat(v3, "|")
end

local function useKnownLeaderboardModels(p4, p5) -- line: 102
    -- upvalues: useEffect (copy), useState (copy), Workspace (copy), t1 (copy), getLeaderboardBindingsKey (copy)
    local v6, v7 = useState({})

    useEffect(function() -- line: 104
        -- upvalues: p4 (copy), v7 (copy), Workspace (copy), t1 (copy), getLeaderboardBindingsKey (copy)
        local Leaderboards = Workspace:FindFirstChild("Leaderboards")

        local function v8() -- line: 106
            -- upvalues: Leaderboards (copy), p4 (copy), v7 (copy), t1 (copy), getLeaderboardBindingsKey (copy)
            local t2 = {}

            for v9, v10 in t1 do
                local v11 = Leaderboards

                if Leaderboards ~= nil then
                    v11 = Leaderboards:FindFirstChild(v9)
                end

                if (if v11 == nil then v11 else v11:IsA("Model")) and p4[v11] == nil then
                    table.insert(t2, {
                        instance = v11,
                        name = v10
                    })
                end
            end

            local v12 = Leaderboards ~= nil
            local v13 = Leaderboards

            if Leaderboards ~= nil then
                v13 = Leaderboards:FindFirstChild("LeaderboardFrostwyrm")
            end

            local v14 = v13 ~= nil
            local v15 = table.create(#t2)

            local function v16(p6) -- line: 138
                return p6.name
            end

            for v17, v18 in t2 do
                local _ = v17 - 1

                v15[v17] = v18.name
            end

            print((("[FrostwyrmLeaderboard debug] Leaderboards folder found: %*, LeaderboardFrostwyrm model found: %*, bindings: %*"):format(v12, v14, (table.concat(v15, ", ")))))
            v7(function(p7) -- line: 146
                -- upvalues: t2 (copy), getLeaderboardBindingsKey (copy)
                if getLeaderboardBindingsKey(p7) == getLeaderboardBindingsKey(t2) then
                    return p7
                end

                return t2
            end)
        end

        v8()

        if not Leaderboards then
            return nil
        end

        local connection = Leaderboards.ChildAdded:Connect(v8)
        local connection2 = Leaderboards.ChildRemoved:Connect(v8)

        return function() -- line: 156
            -- upvalues: connection (copy), connection2 (copy)
            connection:Disconnect()
            connection2:Disconnect()
        end
    end, { p5 })

    return v6
end

local LeaderboardSurfaceGui

local function LeaderboardManager() -- line: 164
    -- upvalues: react (copy), useFlameworkComponents (copy), getLeaderboardNameFromInstance (copy), getLeaderboardBindingsKey (copy), useKnownLeaderboardModels (copy), LeaderboardSurfaceGui (ref)
    local v19 = useFlameworkComponents(function() -- line: 165
        return true
    end, "client/components/leaderboard-component@LeaderboardComponent")
    local t4 = {}
    local t5 = {}

    for _, v20 in v19 do
        local v21 = getLeaderboardNameFromInstance(v20.instance)

        if v21 ~= nil then
            t4[v20.instance] = true
            table.insert(t5, {
                instance = v20.instance,
                name = v21
            })
        end
    end

    local v23 = useKnownLeaderboardModels(t4, (getLeaderboardBindingsKey(t5)))
    local t7 = {}
    local v24 = #t7
    local v25 = #t5

    table.move(t5, 1, v25, v24 + 1, t7)

    local v26 = v24 + v25
    local t8 = {}
    local n1 = 0

    for v27, v28 in v23 do
        local _ = v27 - 1

        if t4[v28.instance] == nil == true then
            n1 += 1
            t8[n1] = v28
        end
    end

    table.move(t8, 1, #t8, v26 + 1, t7)

    local v29 = table.create(#t7)

    for v30, v31 in t7 do
        local _ = v30 - 1

        v29[v30] = react.createElement(LeaderboardSurfaceGui, {
            key = ("%*:%*"):format(v31.name, (v31.instance:GetFullName())),
            leaderboardBinding = v31
        })
    end

    return react.createElement(react.Fragment, nil, v29)
end

local t9 = {}

local function findDescendant(p8, p9, p10) -- line: 227
    if p8 then
        local v32 = p8:FindFirstChild(p9, true)

        if if v32 == nil then v32 else v32:IsA(p10) then
            return v32
        end
    end

    return nil
end

local function useDescendant(p11, p12, p13) -- line: 238
    -- upvalues: useEffect (copy), useState (copy)
    local v33, v34 = useState(function() -- line: 239
        -- upvalues: p11 (copy), p12 (copy), p13 (copy)
        if p11 then
            local v35 = p11:FindFirstChild(p12, true)

            if if v35 == nil then v35 else v35:IsA(p13) then
                return v35
            end
        end

        return nil
    end)

    useEffect(function() -- line: 242
        -- upvalues: p11 (copy), p12 (copy), p13 (copy), v33 (copy), v34 (copy)
        local v36

        if p11 then
            v36 = p11:FindFirstChild(p12, true)

            if not (if v36 == nil then v36 else v36:IsA(p13)) then
                v36 = nil
            end
        end

        v34(v36)

        if not p11 then
            return nil
        end

        local connection = p11.DescendantAdded:Connect(function(p14) -- line: 247
            -- upvalues: p12 (copy), p13 (copy), v34 (copy)
            if p14.Name == p12 and p14:IsA(p13) then
                v34(p14)
            end
        end)
        local connection2 = p11.DescendantRemoving:Connect(function(p15) -- line: 252
            -- upvalues: v33 (copy), v34 (copy)
            if p15 == v33 then
                v34(nil)
            end
        end)

        return function() -- line: 257
            -- upvalues: connection (copy), connection2 (copy)
            connection:Disconnect()
            connection2:Disconnect()
        end
    end, { p11, p12, p13, v33 })

    return v33
end

local function countryCodeToFlagEmoji(p16) -- line: 264
    local v37 = string.upper(p16)
    local v38 = #v37 - 1
    local v39 = ""

    for i = 0, v38 do
        local v40 = string.byte(v37, i + 1, i + 1)

        v39 ..= utf8.char(v40 + 127397)
    end

    return v39
end

local function formatPlaytime(p17) -- line: 275
    local v42 = math.floor(p17 / 3600)
    local v44 = math.floor(p17 % 3600 / 60)

    if p17 < 60 then
        return "<1m"
    end

    if v42 == 0 then
        return (("%*m"):format(v44))
    end

    return (("%*h %*m"):format(v42, v44))
end

local v45 = tostring(Players.LocalPlayer.UserId)
local v46 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 150, 10))
})
local v47 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 40, 190)),
    ColorSequenceKeypoint.new(0.35, Color3.fromRGB(50, 210, 130)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(30, 15, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 40, 190))
})

local function earliestExclusiveIndex(p18) -- line: 297
    if p18 == nil or #p18 == 0 then
        return 1e999
    end

    return (math.min(unpack(p18)))
end

local function sortByValueThenEarliestIndex(p19) -- line: 306
    local t10 = {}
    local v48 = #t10

    table.move(p19, 1, #p19, v48 + 1, t10)
    table.sort(t10, function(p20, p21) -- line: 310
        if p20.value ~= p21.value then
            return p20.value > p21.value
        end

        local exclusiveIndices = p20.exclusiveIndices
        local v49 = if exclusiveIndices == nil or #exclusiveIndices == 0 then 1e999 else math.min(unpack(exclusiveIndices))
        local exclusiveIndices2 = p21.exclusiveIndices

        return v49 < (if exclusiveIndices2 == nil or #exclusiveIndices2 == 0 then 1e999 else math.min(unpack(exclusiveIndices2)))
    end)

    return t10
end

local LeaderboardEntry, ExclusiveIndicesRow

local function buildExclusiveIndexBoardRows(p22, p23) -- line: 323
    -- upvalues: react (copy), sortByValueThenEarliestIndex (copy), LeaderboardEntry (ref), ExclusiveIndicesRow (ref)
    local v51 = sortByValueThenEarliestIndex(p22)
    local t11 = {}

    for i = 0, #v51 - 1 do
        local v52 = v51[i + 1]

        table.insert(t11, (react.createElement(LeaderboardEntry, {
            entry = v52,
            index = i + 1,
            key = ("%*-score"):format(v52.userId),
            layoutOrder = i * 2,
            statName = p23
        })))

        local createElement = react.createElement
        local ExclusiveIndicesRow2 = ExclusiveIndicesRow

        table.insert(t11, (createElement(ExclusiveIndicesRow2, {
            indices = v52.exclusiveIndices or {},
            key = ("%*-indices"):format(v52.userId),
            layoutOrder = i * 2 + 1
        })))
    end

    return t11
end

function LeaderboardSurfaceGui(p24) -- line: 345
    -- upvalues: RuntimeLib (copy), react (copy), useEffect (copy), useRef (copy), useState (copy), useRootSelector (copy), useRootSelectorCreator (copy), default (copy), functions (copy), selectCountryLeaderboard (copy), selectPlayerCountry (copy), createPortal (copy), default2 (copy), useExclusiveGradientRotation (copy), useTheme (copy), icyFingersTitleSequence (copy), t9 (copy), useDescendant (copy), countryCodeToFlagEmoji (copy), v45 (copy), v46 (copy), v47 (copy), LeaderboardEntry (ref), buildExclusiveIndexBoardRows (copy)
    local BasePart = useDescendant(p24.leaderboardBinding.instance, "Board", "BasePart")
    local BasePart2 = useDescendant(p24.leaderboardBinding.instance, "titleBoard", "BasePart")
    local name = p24.leaderboardBinding.name
    local v55 = useTheme()
    local v56 = name == "frostwyrmCaught"
    local v57 = name == "uncThuluCaught"
    local v58 = v56 or v57
    local v59 = useExclusiveGradientRotation(v58)
    local v60 = name == "money_local"
    local v61 = useRootSelector(function(p25) -- line: 355
        -- upvalues: name (copy), v60 (copy)
        return p25.leaderboard[if v60 then "money" else name]
    end) or t9
    local v62 = useRootSelectorCreator(selectPlayerCountry, v45)
    local v63 = useRootSelectorCreator(selectCountryLeaderboard, v62) or t9

    if not v60 then
        v63 = v61
    end

    local v64 = useRef()
    local v65, v66 = useState({})
    local v67, v68 = useState(nil)
    local v69 = useRef(false)

    useEffect(function() -- line: 377
        -- upvalues: v60 (copy), v66 (copy), v68 (copy)
        if v60 then
            v66({})
            v68(nil)
        end
    end, { v62 })

    local t13 = {}
    local v70 = #t13
    local v71 = #v63

    table.move(v63, 1, v71, v70 + 1, t13)

    local v72 = v70 + v71
    local t14 = {}

    local function v73(p26) -- line: 394
        -- upvalues: v63 (ref)
        local v74 = false

        for v75, v76 in v63 do
            local _ = v75 - 1

            if v76.userId == p26.userId then
                v74 = true
                break
            end
        end

        return not v74
    end

    local n2 = 0

    for v77, v78 in v65 do
        if v73(v78, v77 - 1, v65) == true then
            n2 += 1
            t14[n2] = v78
        end
    end

    table.move(t14, 1, #t14, v72 + 1, t13)

    local v79 = if v58 then 2 else 1

    local function v80() -- line: 420
        -- upvalues: name (copy), v64 (copy), v66 (copy), v67 (copy), v68 (copy), v69 (copy), t13 (copy), v63 (ref), v79 (copy), RuntimeLib (copy), functions (copy)
        local current = v64.current

        if current == nil or v69.current or v67 ~= nil and #t13 >= v67 then
            return nil
        end

        local v81 = #t13 * v79

        if v81 <= 0 then
            return nil
        end

        local v82 = current.AbsoluteCanvasSize.Y / v81

        if v82 <= 0 then
            return nil
        end

        if v81 - math.floor((current.CanvasPosition.Y + current.AbsoluteWindowSize.Y) / v82) <= v79 * 1 then
            v69.current = true
            task.spawn(RuntimeLib.async(function() -- line: 445
                -- upvalues: name (copy), v66 (copy), v68 (copy), v69 (copy), t13 (copy), v63 (ref), RuntimeLib (copy), functions (copy)
                local v84 = #t13 + 1
                local v85 = RuntimeLib.await(functions.requestLeaderboardEntries(name, v84, 15))

                v69.current = false
                v66(function(p27) -- line: 453
                    -- upvalues: v85 (copy), v63 (ref)
                    local t15 = {}

                    for _, v86 in v63 do
                        t15[v86.userId] = true
                    end

                    for _, v87 in p27 do
                        t15[v87.userId] = true
                    end

                    local entries = v85.entries
                    local t16 = {}
                    local n3 = 0

                    for v88, v89 in entries do
                        local _ = v88 - 1

                        if t15[v89.userId] == nil == true then
                            n3 += 1
                            t16[n3] = v89
                        end
                    end

                    local t17 = {}
                    local v90 = #t17
                    local v91 = #p27

                    table.move(p27, 1, v91, v90 + 1, t17)

                    local v92 = v90 + v91

                    table.move(t16, 1, #t16, v92 + 1, t17)

                    return t17
                end)
                v68(v85.totalCount)
            end))
        end
    end

    useEffect(function() -- line: 491
        -- upvalues: v80 (copy)
        v80()
    end, { v63, v65 })

    if name == "frostwyrmCaught" then
        print((("[FrostwyrmLeaderboard debug] instance=%*, board found=%*, titleBoard found=%*, entries=%*"):format(p24.leaderboardBinding.instance:GetFullName(), BasePart ~= nil, BasePart2 ~= nil, #v63)))
    end

    if not BasePart then
        return nil
    end

    local v93 = if name ~= "money_local" or v62 == nil then nil else countryCodeToFlagEmoji(v62)
    local v94

    if name == "celebrationReactionSticksCaught" then
        v94 = "Sticks Caught"
    elseif name == "celebrationObbyRunsCompleted" then
        v94 = "Obbies Completed"
    elseif name == "celebrationRglRunsCompleted" then
        v94 = "Runs Completed"
    elseif name == "money" then
        v94 = "Cash Kings"
    elseif name == "money_local" then
        v94 = if v62 ~= nil then ("  %* Elite"):format(v62) else "... Elites"
    elseif name == "playtime" then
        v94 = "Time Titans"
    elseif name == "power" then
        v94 = "Power Legends"
    elseif name == "totalRobuxSpent" then
        v94 = "Whale Lords"
    elseif name == "frostwyrmCaught" then
        v94 = "Frostwyrm Slayers"
    elseif name == "uncThuluCaught" then
        v94 = "Uncthulu Sons"
    end

    local v95, v96

    if v56 then
        v95 = icyFingersTitleSequence
        v96 = "No bait has tempted the Frostwyrm... yet."
    else
        v95 = if v57 then v47 else v46

        if v57 then
            v96 = "None have answered Unc's Calling... yet."
        end
    end

    local t18 = {
        TextScaled = true,
        ZIndex = 5,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Font = v55.textFont2,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.8, 0.6)
    }
    local v97 = v94 ~= nil and BasePart2 ~= nil

    if v97 then
        local t19 = {
            color = v95,
            gradientRotation = if v58 then v59 else nil
        }
        local v98 = table.clone(t18)

        setmetatable(v98, nil)
        v98.TextXAlignment = Enum.TextXAlignment.Center
        t19.overrideProps = v98
        t19.shadowYScale = 0.05
        t19.text = v94

        local v99 = react.createElement(default2, t19)
        local v100 = v93 ~= nil

        if v100 then
            local v101 = table.clone(t18)

            setmetatable(v101, nil)
            v101.BackgroundTransparency = 1
            v101.Text = v93
            v101.TextColor3 = Color3.fromRGB(255, 255, 255)
            v101.TextXAlignment = Enum.TextXAlignment.Left
            v101.ZIndex = 10
            v100 = react.createElement("textlabel", v101)
        end

        v97 = createPortal(react.createElement("surfacegui", {
            LightInfluence = 0,
            PixelsPerStud = 20,
            ResetOnSpawn = false,
            Adornee = BasePart2,
            Face = Enum.NormalId.Front,
            SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1)
        }, v99, v100)), BasePart2)
    end

    local v102

    if v96 ~= nil and #v63 == 0 then
        v102 = react.createElement("textlabel", {
            BackgroundTransparency = 1,
            TextScaled = true,
            TextWrapped = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Font = Enum.Font.FredokaOne,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.8, 0.4),
            Text = v96,
            TextColor3 = Color3.new(1, 1, 1),
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center
        }, react.createElement("uistroke", {
            Thickness = 1,
            Color = Color3.new(0, 0, 0)
        }))

        return react.createElement(react.Fragment, nil, v97, createPortal(react.createElement("surfacegui", {
            CanvasSize = Vector2.new(400, 500),
            Face = Enum.NormalId.Front
        }, v102), BasePart))
    end

    local v103

    if v58 then
        v103 = buildExclusiveIndexBoardRows(t13, name)
    else
        v103 = table.create(#t13)

        for v104, v105 in t13 do
            local v106 = v104 - 1

            v103[v104] = react.createElement(LeaderboardEntry, {
                entry = v105,
                index = v106 + 1,
                key = ("leaderboard-entry-%*"):format(v105.userId),
                statName = name
            })
        end
    end

    v102 = react.createElement(default, {
        cellsPerRow = 1,
        rowsToBeVisible = 6.5,
        slotBorderThicknessToAccountFor = 0,
        changed = {
            AbsoluteCanvasSize = function() -- AbsoluteCanvasSize | line: 593
                -- upvalues: v80 (copy)
                return v80()
            end,
            CanvasPosition = function() -- CanvasPosition | line: 596
                -- upvalues: v80 (copy)
                return v80()
            end
        },
        fillDirection = Enum.FillDirection.Horizontal,
        padding = {
            left = UDim.new(0, 4),
            right = UDim.new(0, 4)
        },
        ref = v64,
        size = UDim2.new(1, 0, 1, 0),
        verticalAlignment = Enum.VerticalAlignment.Top
    }, v103)

    return react.createElement(react.Fragment, nil, v97, createPortal(react.createElement("surfacegui", {
        CanvasSize = Vector2.new(400, 500),
        Face = Enum.NormalId.Front
    }, v102), BasePart))
end

function LeaderboardEntry(p28) -- line: 617
    -- upvalues: react (copy), useEffect (copy), useState (copy), Players (copy), abbreviate (copy), images (copy), countryCodeToFlagEmoji (copy)
    local entry = p28.entry
    local userId, value, playerName, countryCode = entry.userId, entry.value, entry.playerName, entry.countryCode
    local index, layoutOrder = p28.index, p28.layoutOrder

    if layoutOrder == nil then
        layoutOrder = index
    end

    local v107, v108 = useState("http://www.roblox.com/asset/?id=75046617156863")

    useEffect(function() -- line: 631
        -- upvalues: userId (copy), v108 (copy), Players (copy)
        local v109 = task.spawn(function() -- line: 632
            -- upvalues: userId (copy), v108 (copy), Players (copy)
            local UserThumbnailAsync, UserThumbnailAsync2 = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)

            if UserThumbnailAsync2 then
                v108(UserThumbnailAsync)
            end
        end)

        return function() -- line: 638
            -- upvalues: v109 (copy)
            return task.cancel(v109)
        end
    end, { userId })

    local v110 = if countryCode == nil or #countryCode ~= 2 then nil else countryCodeToFlagEmoji(countryCode)
    local createElement = react.createElement
    local t22 = {
        BackgroundTransparency = 0.3,
        BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
        LayoutOrder = layoutOrder,
        Size = UDim2.new(1, 0, 0, 80)
    }
    local v111 = react.createElement("uicorner", {
        CornerRadius = UDim.new(0.08, 0)
    })
    local v112 = react.createElement("uipadding", {
        PaddingBottom = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6),
        PaddingTop = UDim.new(0, 4)
    })
    local v113 = react.createElement("uilistlayout", {
        HorizontalFlex = "SpaceBetween",
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = UDim.new(0, 6),
        VerticalAlignment = Enum.VerticalAlignment.Center
    })
    local v114 = react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 78, 0, 78)
    }, react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0, 0),
        Image = v107,
        Position = UDim2.new(0, 0, 0, 0),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.new(0, 68, 0, 68)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.15, 0)
    })), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 2,
        AnchorPoint = Vector2.new(0, 1),
        Font = Enum.Font.FredokaOne,
        Position = UDim2.new(0, 0, 0.95, 0),
        Size = UDim2.new(0, 40, 0, 36),
        Text = tostring(index),
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left
    }, react.createElement("uistroke", {
        Thickness = 2,
        Color = Color3.new(0, 0, 0)
    })), v110 ~= nil and react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        ZIndex = 2,
        AnchorPoint = Vector2.new(1, 1),
        Font = Enum.Font.GothamBold,
        Position = UDim2.new(1.05, 0, 0.95, 0),
        Size = UDim2.new(0, 46, 0, 36),
        Text = v110,
        TextXAlignment = Enum.TextXAlignment.Center
    }))
    local v115 = react.createElement("textlabel", {
        BackgroundTransparency = 1,
        TextScaled = true,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.new(0, 190, 1, 0),
        Text = playerName,
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left
    }, react.createElement("uistroke", {
        Thickness = 1,
        Color = Color3.new(0, 0, 0)
    }))
    local v116

    if p28.statName == "totalRobuxSpent" then
        v116 = react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0.5),
            Size = UDim2.new(0, 90, 1, 0)
        }, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 2),
            VerticalAlignment = Enum.VerticalAlignment.Center
        }), react.createElement("textlabel", {
            BackgroundTransparency = 1,
            TextScaled = true,
            Font = Enum.Font.FredokaOne,
            Size = UDim2.new(0, 58, 1, 0),
            Text = abbreviate(value),
            TextColor3 = Color3.new(1, 1, 1),
            TextXAlignment = Enum.TextXAlignment.Right
        }, react.createElement("uistroke", {
            Thickness = 1,
            Color = Color3.new(0, 0, 0)
        })), react.createElement("imagelabel", {
            BackgroundTransparency = 1,
            Image = images.robuxIcon,
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.new(0, 28, 0, 28)
        }))
    else
        local createElement = react.createElement
        local t23 = {
            BackgroundTransparency = 1,
            TextScaled = true,
            AnchorPoint = Vector2.new(1, 0.5),
            Font = Enum.Font.FredokaOne,
            Size = UDim2.new(0, 90, 1, 0)
        }

        if p28.statName == "playtime" then
            local v118 = math.floor(value / 3600)
            local v120 = math.floor(value % 3600 / 60)

            t23.Text = if value < 60 then "<1m" elseif v118 == 0 then ("%*m"):format(v120) else ("%*h %*m"):format(v118, v120)
        else
            t23.Text = abbreviate(value)
        end

        t23.TextColor3 = Color3.new(1, 1, 1)
        t23.TextXAlignment = Enum.TextXAlignment.Right
        v116 = createElement("textlabel", t23, react.createElement("uistroke", {
            Thickness = 1,
            Color = Color3.new(0, 0, 0)
        }))
    end

    return createElement("frame", t22, v111, v112, v113, v114, v115, v116)
end

function ExclusiveIndicesRow(p29) -- line: 752
    -- upvalues: react (copy), default3 (copy), exclusiveEditionGradient (copy), useExclusiveGradientRotation (copy)
    local v121 = useExclusiveGradientRotation()
    local t24 = {}
    local v122 = #t24
    local indices = p29.indices

    table.move(indices, 1, #indices, v122 + 1, t24)
    table.sort(t24, function(p30, p31) -- line: 758
        return p30 < p31
    end)

    local t25 = {}
    local n4 = 0
    local v123 = false

    while true do
        if v123 then
            n4 += 1
        else
            v123 = true
        end

        if n4 < math.min(3, #t24) then
            table.insert(t25, t24[n4 + 1])
            continue
        end

        break
    end

    local v126 = table.create(#t25)

    local function v127(p32) -- line: 781
        return (("#%*"):format(p32))
    end

    for v128, v129 in t25 do
        local _ = v128 - 1

        v126[v128] = ("#%*"):format(v129)
    end

    local v130 = table.concat(v126, ", ") .. (if #t24 > 3 then ", …" else "")

    return react.createElement("frame", {
        BackgroundTransparency = 0.3,
        BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
        LayoutOrder = p29.layoutOrder,
        Size = UDim2.new(1, 0, 0, 80)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.08, 0)
    }), react.createElement("uipadding", {
        PaddingBottom = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 6),
        PaddingTop = UDim.new(0, 4)
    }), react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        Padding = UDim.new(0, 12),
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("textlabel", {
        BackgroundTransparency = 1,
        Text = "Owns:",
        TextScaled = true,
        Font = Enum.Font.FredokaOne,
        Size = UDim2.new(0, 70, 1, 0),
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Left
    }, react.createElement("uistroke", {
        Thickness = 1,
        Color = Color3.new(0, 0, 0)
    })), react.createElement(default3, {
        color = exclusiveEditionGradient,
        gradientRotation = v121,
        overrideProps = {
            Size = UDim2.new(1, -82, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        strokeProps = {
            Thickness = 0.1,
            Color = Color3.new(0, 0, 0)
        },
        text = v130
    }))
end

return {
    default = LeaderboardManager
}
