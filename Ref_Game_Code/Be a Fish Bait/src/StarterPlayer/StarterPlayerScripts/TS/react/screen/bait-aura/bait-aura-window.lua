-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useMemo, useRef, useState = react.useEffect, react.useMemo, react.useRef, react.useState
local useMotion = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useMotion
local useGlowPulse = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-glow-pulse").useGlowPulse
local useFreePurchaseModeEnabled = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-free-purchase-mode").useFreePurchaseModeEnabled
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local ContentProvider, ReplicatedStorage, RunService, SoundService = services.ContentProvider, services.ReplicatedStorage, services.RunService, services.SoundService
local Workspace = services.Workspace
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-button").default
local default3 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-button").default
local default4 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useFlameworkComponents = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-flamework-components").useFlameworkComponents
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local playClonedSound = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "vfx").playClonedSound
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local rarityColors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils").rarityColors
local default5 = RuntimeLib.import(script, script.Parent, "bait-aura-preview-rig").default
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "bait-aura-utils")
local baitAuraConfigs, baitAuraRerollPackPrices, baitAuraSlot2RobuxPrice, baitAuraSlot3RobuxPrice = v1.baitAuraConfigs, v1.baitAuraRerollPackPrices, v1.baitAuraSlot2RobuxPrice, v1.baitAuraSlot3RobuxPrice
local getBaitAuraConfig, getBaitAuraBuffDescriptions, getBaitAuraSlotRebirthRequirement, isBaitAuraSlotUsable = v1.getBaitAuraConfig, v1.getBaitAuraBuffDescriptions, v1.getBaitAuraSlotRebirthRequirement, v1.isBaitAuraSlotUsable

local function buildTwoToneGradient(p1) -- line: 38
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, p1:Lerp(Color3.new(1, 1, 1), 0.2)),
        ColorSequenceKeypoint.new(1, p1:Lerp(Color3.new(0, 0, 0), 0.2))
    })
end

local function buildShineGradient(p2) -- line: 43
    local v2 = p2:Lerp(Color3.new(1, 1, 1), 0.82)

    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, p2),
        ColorSequenceKeypoint.new(0.42, p2),
        ColorSequenceKeypoint.new(0.5, v2),
        ColorSequenceKeypoint.new(0.58, p2),
        ColorSequenceKeypoint.new(1, p2)
    })
end

local t1 = {
    epic = buildTwoToneGradient(rarityColors.epic),
    legendary = buildShineGradient(rarityColors.legendary),
    mythic = buildShineGradient(rarityColors.mythic)
}
local t2 = {
    legendary = true,
    mythic = true
}

local function getAuraRarityColor(p3, p4) -- line: 59
    -- upvalues: rarityColors (copy), getBaitAuraConfig (copy)
    local v3 = if p4 == nil then Color3.fromRGB(140, 140, 145) else p4
    local v4 = getBaitAuraConfig(p3)

    if v4 == nil then
        return v3
    end

    return rarityColors[v4.rarity]
end

local function getAuraRarityColorOrGradient(p5, p6) -- line: 66
    -- upvalues: rarityColors (copy), getBaitAuraConfig (copy), t1 (copy)
    local v5 = if p6 == nil then Color3.fromRGB(140, 140, 145) else p6
    local v6 = getBaitAuraConfig(p5)

    if v6 == nil then
        return v5
    end

    return t1[v6.rarity] or rarityColors[v6.rarity]
end

local function isAnimatedGradientRarity(p7) -- line: 76
    -- upvalues: getBaitAuraConfig (copy), t2 (copy)
    local v7 = getBaitAuraConfig(p7)
    local v8 = v7 ~= nil

    v8 = v8 and t2[v7.rarity] ~= nil

    return v8
end

local t3, t4

local function getRollPreviewAura(p8, p9) -- line: 86
    -- upvalues: baitAuraConfigs (copy), t3 (ref), t4 (ref)
    local v9 = if not (#t3 - 4 <= p8 and #t4 > 0) then baitAuraConfigs else t4

    if #v9 == 1 then
        return v9[1]
    end

    local v10 = v9[math.random(0, #v9 - 1) + 1]

    if v10.auraName == p9 then
        v10 = v9[((table.find(v9, v10) or 0) - 1 + 1) % #v9 + 1]
    end

    return v10
end

local v11 = Color3.fromRGB(55, 65, 90)
local v12 = Color3.fromRGB(80, 95, 130)
local v13 = Color3.fromRGB(30, 35, 55)
local v14 = Color3.fromRGB(70, 80, 110)
local v15 = Color3.fromRGB(33, 33, 33)
local v16 = Color3.fromRGB(255, 230, 80)
local v17 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 235, 59)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 170, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 87, 0))
})
local v18 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 220, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 175, 20))
})
local v19 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(62, 153, 213)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 94, 145))
})
local v20 = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(0.58, 0.28),
    NumberSequenceKeypoint.new(1, 1)
})

t3 = {
    0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055,
    0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055, 0.055,
    0.055, 0.055, 0.055, 0.055, 0.07, 0.08, 0.1, 0.13,
    0.17, 0.23, 0.48, 0.68
}

local function v21(p10, p11) -- line: 115
    return p10 + p11
end

local n1 = 0

for i = 1, #t3 do
    local v23 = t3[i]
    local _ = i - 1

    n1 += v23
end

local v24 = n1 + 0.12
local t5 = {
    frequency = 0.3,
    damping = 0.3
}
local t6 = {}

local function v25(p12) -- line: 137
    if p12.rarity == "epic" or p12.rarity == "legendary" then
        return true
    end

    return p12.rarity == "mythic"
end

local n2 = 0

for v26, v27 in baitAuraConfigs do
    local _ = v26 - 1

    if (v27.rarity == "epic" or v27.rarity == "legendary" or v27.rarity == "mythic") == true then
        n2 += 1
        t6[n2] = v27
    end
end

t4 = t6

local function getAuraRevealSoundName(p13) -- line: 149
    if p13 == "legendary" then
        return "AuraRevealLegend"
    end

    if p13 == "mythic" then
        return "AuraRevealMythic"
    end

    return "AuraReveal"
end

local function getBaitAuraArea() -- line: 158
    -- upvalues: Workspace (copy)
    local Map = Workspace:FindFirstChild("Map")

    if Map ~= nil then
        Map = Map:FindFirstChild("BaitAuraArea")
    end

    return Map
end

local function getBaitAuraBackgroundEmitter() -- line: 165
    -- upvalues: Workspace (copy)
    local Map = Workspace:FindFirstChild("Map")

    if Map ~= nil then
        Map = Map:FindFirstChild("BaitAuraArea")
    end

    if Map ~= nil then
        Map = Map:FindFirstChild("BGVFXPart")

        if Map ~= nil then
            Map = Map:FindFirstChild("BGVFXAttachment")

            if Map ~= nil then
                Map = Map:FindFirstChild("BGVFX")
            end
        end
    end

    return if if Map == nil then Map else Map:IsA("ParticleEmitter") then Map else nil
end

local function setBaitAuraBackgroundVfxVisible(p14, p15, p16) -- line: 183
    -- upvalues: getBaitAuraBackgroundEmitter (copy)
    local v28 = p16 ~= nil and p16
    local v29 = getBaitAuraBackgroundEmitter()

    if v29 == nil then
        return nil
    end

    v29.Enabled = p14
    v29.Transparency = NumberSequence.new(p14 and 0 or 1)

    if p15 ~= nil then
        v29.Color = ColorSequence.new(p15)
    end

    if p14 and v28 then
        local EmitCount = v29:GetAttribute("EmitCount")

        if EmitCount == nil then
            EmitCount = math.max(30, (math.floor(v29.Rate * 0.6)))
        end

        v29:Emit(EmitCount)
    end
end

local function getCameraCFrameFromInstance(p17) -- line: 205
    return if (if p17 == nil then p17 else p17:IsA("Camera")) or (if p17 == nil then p17 else p17:IsA("BasePart")) then p17.CFrame else nil
end

local function getBaitAuraCameraCFrame(p18) -- line: 222
    -- upvalues: Workspace (copy)
    local v32 = if p18 == nil then p18 else p18.Parent

    if v32 ~= nil then
        v32 = v32:FindFirstChild("BaitAuraCamera")
    end

    local v33 = if v32 == nil then v32 else v32:IsA("Camera")
    local v34, v35

    if v33 then
        v35 = true
    else
        v34 = if v32 ~= nil then v32:IsA("BasePart") else v32
        v35 = false
    end

    local CFrame = if v35 or v34 then v32.CFrame else nil

    if CFrame ~= nil then
        return CFrame
    end

    local Map = Workspace:FindFirstChild("Map")

    if Map ~= nil then
        Map = Map:FindFirstChild("BaitAuraArea")
    end

    if Map ~= nil then
        Map = Map:FindFirstChild("BaitAuraCamera")
    end

    local v36 = if Map == nil then Map else Map:IsA("Camera")
    local v37, v38

    if v36 then
        v38 = true
    else
        v37 = if Map ~= nil then Map:IsA("BasePart") else Map
        v38 = false
    end

    local CFrame2 = if v38 or v37 then Map.CFrame else nil

    if CFrame2 ~= nil then
        return CFrame2
    end

    local v39 = Workspace:FindFirstChild("BaitAuraCamera", true)

    return if (if v39 == nil then v39 else v39:IsA("Camera")) or (if v39 == nil then v39 else v39:IsA("BasePart")) then v39.CFrame else nil
end

local function useBaitAuraCamera(p19, p20, p21) -- line: 248
    -- upvalues: useEffect (copy), useRef (copy), useMotion (copy), RunService (copy), Workspace (copy), v24 (copy), t5 (copy), getBaitAuraCameraCFrame (copy)
    local _, v40 = useMotion(50)
    local v41 = useRef(50)

    useEffect(function() -- line: 251
        -- upvalues: v40 (copy), v41 (copy)
        return (v40:onStep(function(p22) -- line: 252
            -- upvalues: v41 (copy)
            v41.current = p22
        end))
    end, { v40 })
    useEffect(function() -- line: 257
        -- upvalues: p21 (copy), v40 (copy), v24 (copy), t5 (copy)
        if p21 then
            v40:tween(34, {
                direction = Enum.EasingDirection.Out,
                style = Enum.EasingStyle.Quad,
                time = v24
            })
        else
            v40:spring(50, t5)
        end
    end, { p21, v40 })
    useEffect(function() -- line: 268
        -- upvalues: p19 (copy), p20 (copy), v41 (copy), RunService (copy), Workspace (copy), getBaitAuraCameraCFrame (copy)
        if not p19 then
            return nil
        end

        local CurrentCamera = Workspace.CurrentCamera

        if CurrentCamera == nil then
            return nil
        end

        local CameraType, CameraSubject, CFrame, FieldOfView = CurrentCamera.CameraType, CurrentCamera.CameraSubject, CurrentCamera.CFrame, CurrentCamera.FieldOfView
        local v42 = getBaitAuraCameraCFrame(p20)
        local v43 = v42

        if v42 ~= nil then
            CurrentCamera.CameraType = Enum.CameraType.Scriptable
            CurrentCamera.CameraSubject = nil
            CurrentCamera.CFrame = v42
            CurrentCamera.FieldOfView = v41.current
        end

        local connection = RunService.RenderStepped:Connect(function() -- line: 290
            -- upvalues: CurrentCamera (copy), v43 (ref), p20 (copy), v41 (copy), getBaitAuraCameraCFrame (copy)
            v43 = getBaitAuraCameraCFrame(p20) or v43

            if v43 == nil then
                return
            end

            local v44 = v43

            CurrentCamera.CameraType = Enum.CameraType.Scriptable
            CurrentCamera.CameraSubject = nil
            CurrentCamera.CFrame = v44
            CurrentCamera.FieldOfView = v41.current
        end)

        return function() -- line: 296
            -- upvalues: CurrentCamera (copy), CameraType (copy), CameraSubject (copy), CFrame (copy), FieldOfView (copy), connection (copy)
            connection:Disconnect()
            CurrentCamera.CameraType = CameraType
            CurrentCamera.CameraSubject = CameraSubject
            CurrentCamera.CFrame = CFrame
            CurrentCamera.FieldOfView = FieldOfView
        end
    end, { p19, p20 })
end

local function getMusicSoundGroup() -- line: 305
    -- upvalues: ReplicatedStorage (copy), SoundService (copy)
    local v45 = SoundService:FindFirstChild("music", true) or ReplicatedStorage:FindFirstChild("music", true)

    if v45 ~= nil and v45:IsA("SoundGroup") then
        return v45
    end

    local t7 = {}
    local v46 = #t7
    local Descendants = SoundService:GetDescendants()
    local v47 = #Descendants

    table.move(Descendants, 1, v47, v46 + 1, t7)

    local v48 = v46 + v47
    local Descendants2 = ReplicatedStorage:GetDescendants()

    table.move(Descendants2, 1, #Descendants2, v48 + 1, t7)

    local function v49(p23) -- line: 320
        return p23:IsA("SoundGroup") and string.lower(p23.Name) == "music"
    end

    for v50, v51 in t7 do
        local _ = v50 - 1

        if v49(v51) == true then
            return v51
        end
    end

    return nil
end

local function useAuraUiMusicDuck(p24) -- line: 333
    -- upvalues: useEffect (copy), getMusicSoundGroup (copy)
    useEffect(function() -- line: 334
        -- upvalues: p24 (copy), getMusicSoundGroup (copy)
        if not p24 then
            return nil
        end

        local v52 = getMusicSoundGroup()

        if v52 == nil then
            return nil
        end

        local Volume = v52.Volume

        v52.Volume = Volume * 0.28

        return function() -- line: 344
            -- upvalues: v52 (copy), Volume (copy)
            v52.Volume = Volume
        end
    end, { p24 })
end

local function useBaitAuraBackgroundVfxPreload(p25) -- line: 349
    -- upvalues: useEffect (copy), ContentProvider (copy), getBaitAuraBackgroundEmitter (copy)
    useEffect(function() -- line: 350
        -- upvalues: p25 (copy), ContentProvider (copy), getBaitAuraBackgroundEmitter (copy)
        if not p25 then
            return nil
        end

        local v53 = getBaitAuraBackgroundEmitter()

        if v53 == nil then
            return nil
        end

        task.spawn(function() -- line: 358
            -- upvalues: v53 (copy), ContentProvider (copy)
            local function v54() -- line: 359
                -- upvalues: v53 (copy), ContentProvider (copy)
                return ContentProvider:PreloadAsync({ v53 })
            end

            pcall(v54)
        end)

        return function() -- line: 363
            -- upvalues: getBaitAuraBackgroundEmitter (copy)
            local v55 = getBaitAuraBackgroundEmitter()

            if v55 ~= nil then
                v55.Enabled = false
                v55.Transparency = NumberSequence.new(1)
            end
        end
    end, { p25 })
end

local function Label(p26) -- line: 368
    -- upvalues: react (copy), default4 (copy)
    local t8 = {
        anchorPoint = p26.anchorPoint,
        color = p26.color or Color3.fromRGB(255, 255, 255),
        gradientOffset = p26.gradientOffset,
        gradientRotation = p26.gradientRotation
    }
    local t9 = {
        TextScaled = true,
        TextWrapped = true,
        Font = p26.font or Enum.Font.FredokaOne,
        Size = p26.size or UDim2.fromScale(1, 1),
        TextXAlignment = p26.textXAlignment or Enum.TextXAlignment.Center
    }
    local zIndex = p26.zIndex

    t9.ZIndex = if zIndex == nil then 10 else zIndex
    t8.overrideProps = t9
    t8.position = p26.position
    t8.strokeProps = {
        Thickness = 0.075
    }
    t8.text = p26.text

    return react.createElement(default4, t8)
end

local function getAuraReelItem(p27, p28) -- line: 396
    -- upvalues: rarityColors (copy), getBaitAuraConfig (copy)
    local v56 = if p28 == nil then "None" else p28
    local v57 = getBaitAuraConfig(p27)
    local v58 = Color3.fromRGB(140, 140, 145)
    local v59 = getBaitAuraConfig(p27)

    if v59 ~= nil then
        v58 = rarityColors[v59.rarity]
    end

    local t10 = {
        color = v58,
        key = if v57 == nil then v56 else p27
    }

    if v57 ~= nil then
        v57 = v57.displayName
    end

    t10.text = if v57 ~= nil then v57 else v56

    return t10
end

local function getNextAuraReelItem(p29) -- line: 417
    -- upvalues: baitAuraConfigs (copy), getAuraReelItem (copy)
    if #baitAuraConfigs == 0 then
        return (getAuraReelItem(nil))
    end

    local v60 = baitAuraConfigs[math.random(0, #baitAuraConfigs - 1) + 1]

    if v60.auraName == p29 and #baitAuraConfigs > 1 then
        v60 = baitAuraConfigs[((table.find(baitAuraConfigs, v60) or 0) - 1 + 1) % #baitAuraConfigs + 1]
    end

    return (getAuraReelItem(v60.auraName))
end

local function AuraNameReel(p30) -- line: 429
    -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), useMotion (copy), default4 (copy), rarityColors (copy), getBaitAuraConfig (copy), t1 (copy), t2 (copy), getAuraReelItem (copy), getNextAuraReelItem (copy)
    local v61 = getAuraReelItem(p30.auraName)
    local v62 = useRef(p30.auraName)
    local v63, v64 = useState(function() -- line: 432
        -- upvalues: p30 (copy), v61 (copy), getNextAuraReelItem (copy)
        return {
            v61,
            (getNextAuraReelItem(p30.auraName))
        }
    end)
    local v65, v66 = useMotion(0)

    useEffect(function() -- line: 436
        -- upvalues: p30 (copy), v62 (copy), v64 (copy), v66 (copy), getAuraReelItem (copy), getNextAuraReelItem (copy)
        local v67 = getAuraReelItem(v62.current)
        local v68 = getAuraReelItem(p30.auraName)

        v62.current = p30.auraName

        if not p30.isRolling then
            v66:set(0)
            v64({
                v68,
                (getNextAuraReelItem(p30.auraName))
            })

            return nil
        end

        if v67.key == v68.key then
            v64({
                v68,
                (getNextAuraReelItem(p30.auraName))
            })
            v66:set(0)

            return nil
        end

        v64({ v67, v68 })
        v66:set(0)
        v66:tween(1, {
            direction = Enum.EasingDirection.Out,
            style = Enum.EasingStyle.Quart,
            time = if p30.isRolling then p30.transitionTime else 0.28
        })
    end, {
        p30.auraName,
        p30.isRolling,
        p30.transitionTime,
        v66
    })

    if p30.isRolling then
        local v69 = table.create(#v63)

        local function v70(p31, p32) -- line: 493
            -- upvalues: p30 (copy), v65 (copy), react (copy)
            local v71 = v65:map(function(p33) -- line: 494
                -- upvalues: p32 (copy)
                return UDim2.fromScale(0.5, 0.42 + (p32 - p33) * 0.42)
            end)
            local v72 = v65:map(function(p34) -- line: 497
                -- upvalues: p32 (copy)
                if p32 == 0 then
                    return (math.clamp(p34 * 1.15, 0, 1))
                end

                return (math.clamp((1 - p34) * 0.5, 0, 0.5))
            end)
            local v75 = v65:map(function(p35) -- line: 503
                -- upvalues: p32 (copy)
                local v76 = if p32 == 0 then 1 - math.clamp(p35, 0, 1) else math.clamp(p35, 0, 1)

                return UDim2.fromScale(v76 * 0.18 + 0.9, v76 * 0.14 + 0.28)
            end)

            return react.createElement("textlabel", {
                BackgroundTransparency = 1,
                TextScaled = true,
                TextStrokeTransparency = 0,
                TextWrapped = true,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Font = Enum.Font.FredokaOne,
                Position = v71,
                Size = v75,
                Text = p31.text,
                TextColor3 = p31.color,
                TextStrokeColor3 = Color3.fromRGB(0, 0, 0),
                TextTransparency = v72,
                ZIndex = p30.zIndex,
                key = ("%*-%*"):format(p31.key, p32)
            })
        end

        for v77, v78 in v63 do
            v69[v77] = v70(v78, v77 - 1, v63)
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = p30.position,
            Size = p30.size,
            ZIndex = p30.zIndex
        }, v69)
    end

    local auraName = p30.auraName
    local v79 = Color3.fromRGB(140, 140, 145)
    local v80 = getBaitAuraConfig(auraName)

    if v80 ~= nil then
        v79 = t1[v80.rarity] or rarityColors[v80.rarity]
    end

    local v81 = getBaitAuraConfig(p30.auraName)
    local v82 = v81 ~= nil

    v82 = v82 and t2[v81.rarity] ~= nil

    local v83, shineOffset

    if v82 then
        shineOffset = p30.shineOffset
        v83 = 0
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = p30.position,
        Size = p30.size,
        ZIndex = p30.zIndex
    }, react.createElement(default4, {
        shadowYScale = 0.05,
        anchorPoint = Vector2.new(0.5, 0.5),
        color = v79,
        gradientOffset = shineOffset,
        gradientRotation = v83,
        overrideProps = {
            TextScaled = true,
            TextWrapped = true,
            Font = Enum.Font.FredokaOne,
            Size = UDim2.fromScale(1.08, 0.42),
            ZIndex = p30.zIndex
        },
        position = UDim2.fromScale(0.5, 0.42),
        strokeProps = {
            Thickness = 0.09
        },
        text = v61.text
    }))
end

local function CloseXButton(p36) -- line: 538
    -- upvalues: react (copy), default2 (copy), default4 (copy)
    return react.createElement("frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 140,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromScale(0.975, 0.025),
        Size = UDim2.fromScale(0.055, 0.085)
    }, react.createElement(default2, {
        aspectRatio = 1,
        cornerRadius = 0.1,
        zIndex = 140,
        anchorPoint = Vector2.new(0.5, 0.5),
        color = Color3.fromRGB(255, 43, 43),
        onClick = function() -- onClick | line: 551
            -- upvalues: p36 (copy)
            if not p36.disabled then
                p36.onClick()
            end
        end,
        popoutColor = Color3.fromRGB(122, 31, 31),
        position = UDim2.fromScale(0.5, 0.5),
        size = UDim2.fromScale(1, 1),
        strokeColor = Color3.fromRGB(255, 179, 179)
    }, react.createElement(default4, {
        shadowYScale = 0.075,
        text = "X",
        anchorPoint = Vector2.new(0.5, 0.5),
        color = Color3.new(1, 1, 1),
        overrideProps = {
            TextScaled = true,
            ZIndex = 144,
            Font = Enum.Font.FredokaOne,
            Size = UDim2.fromScale(0.78, 0.78)
        },
        position = UDim2.fromScale(0.5, 0.5)
    })))
end

local function SideFocusBackdrop() -- line: 575
    -- upvalues: react (copy), v20 (copy)
    return react.createElement(react.Fragment, nil, react.createElement("frame", {
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0,
        ZIndex = 101,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.fromScale(0, 0),
        Size = UDim2.fromScale(0.42, 1)
    }, react.createElement("uigradient", {
        Rotation = 0,
        Transparency = v20
    })), react.createElement("frame", {
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0,
        ZIndex = 101,
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.fromScale(1, 0),
        Size = UDim2.fromScale(0.42, 1)
    }, react.createElement("uigradient", {
        Rotation = 180,
        Transparency = v20
    })), react.createElement("frame", {
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0,
        ZIndex = 101,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.fromScale(0, 0),
        Size = UDim2.fromScale(1, 0.22)
    }, react.createElement("uigradient", {
        Rotation = 90,
        Transparency = v20
    })), react.createElement("frame", {
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0,
        ZIndex = 101,
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.fromScale(0, 1),
        Size = UDim2.fromScale(1, 0.22)
    }, react.createElement("uigradient", {
        Rotation = 270,
        Transparency = v20
    })))
end

local function RerollShopPopup(p37) -- line: 620
    -- upvalues: react (copy), useFreePurchaseModeEnabled (copy), default (copy), default2 (copy), default4 (copy), baitAuraRerollPackPrices (copy), v11 (copy), v12 (copy), v13 (copy), v14 (copy), Label (copy)
    local v84 = useFreePurchaseModeEnabled()
    local t14 = {
        {
            amount = 1,
            label = "Buy 1 Reroll",
            price = baitAuraRerollPackPrices[1]
        },
        {
            amount = 5,
            label = "Buy 5 Rerolls",
            price = baitAuraRerollPackPrices[5]
        },
        {
            amount = 10,
            label = "Buy 10 Rerolls",
            price = baitAuraRerollPackPrices[10]
        }
    }
    local v85 = react.createElement(Label, {
        text = "Reroll Shop",
        zIndex = 164,
        anchorPoint = Vector2.new(0, 0),
        font = Enum.Font.GothamBlack,
        position = UDim2.fromScale(0.07, 0.05),
        size = UDim2.fromScale(0.6, 0.14),
        textXAlignment = Enum.TextXAlignment.Left
    })
    local v86 = react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 165,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromScale(0.94, 0.06),
        Size = UDim2.fromScale(0.12, 0.14)
    }, react.createElement(default2, {
        aspectRatio = 1,
        cornerRadius = 0.1,
        zIndex = 165,
        anchorPoint = Vector2.new(0.5, 0.5),
        color = Color3.fromRGB(255, 43, 43),
        onClick = p37.onClose,
        popoutColor = Color3.fromRGB(122, 31, 31),
        position = UDim2.fromScale(0.5, 0.5),
        size = UDim2.fromScale(1, 1),
        strokeColor = Color3.fromRGB(255, 179, 179)
    }, react.createElement(default4, {
        shadowYScale = 0.08,
        text = "X",
        anchorPoint = Vector2.new(0.5, 0.5),
        color = Color3.new(1, 1, 1),
        overrideProps = {
            TextScaled = true,
            ZIndex = 167,
            Font = Enum.Font.GothamBlack,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.7, 0.7)
        }
    })))
    local v87 = react.createElement("uilistlayout", {
        Padding = UDim.new(0.08, 0),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    local v88 = table.create(#t14)

    local function v89(p38, p39) -- line: 680
        -- upvalues: p37 (copy), v84 (copy), react (copy), default (copy), v13 (copy), v14 (copy), Label (copy)
        return react.createElement(default, {
            cornerRadius = 0.08,
            strokeThickness = 0.008,
            transparency = 0.5,
            zIndex = 163,
            backgroundColor = v13,
            key = ("reroll-pack-%*"):format(p38.amount),
            layoutOrder = p39,
            size = UDim2.fromScale(1, 0.28),
            strokeColor = v14
        }, react.createElement(Label, {
            zIndex = 165,
            anchorPoint = Vector2.new(0, 0.5),
            font = Enum.Font.GothamBold,
            position = UDim2.fromScale(0.07, 0.5),
            size = UDim2.fromScale(0.52, 0.58),
            text = p38.label,
            textXAlignment = Enum.TextXAlignment.Left
        }), react.createElement(default, {
            cornerRadius = 0.025,
            strokeThickness = 0.008,
            transparency = 0,
            zIndex = 165,
            anchorPoint = Vector2.new(0, 0.5),
            backgroundColor = Color3.fromRGB(97, 43, 150),
            position = UDim2.fromScale(0.6, 0.5),
            size = UDim2.fromScale(0.33, 0.82),
            strokeColor = v14
        }, react.createElement(Label, {
            zIndex = 166,
            anchorPoint = Vector2.new(0.5, 0.5),
            font = Enum.Font.GothamBlack,
            position = UDim2.fromScale(0.5, 0.5),
            size = UDim2.fromScale(0.82, 0.62),
            text = if v84 then "FREE" else ("R$%*"):format(p38.price)
        })), react.createElement("textbutton", {
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 170,
            Event = {
                Activated = function() -- Activated | line: 719
                    -- upvalues: p38 (copy), p37 (copy)
                    p37.onBuyReroll(p38.amount)
                    p37.onClose()
                end
            },
            Font = Enum.Font.FredokaOne,
            Size = UDim2.fromScale(1, 1)
        }))
    end

    for v92, v93 in t14 do
        v88[v92] = v89(v93, v92 - 1, t14)
    end

    return react.createElement(default, {
        cornerRadius = 0.025,
        isStudded = true,
        strokeThickness = 0.005,
        textureTransparency = 0.9,
        transparency = 0,
        zIndex = 160,
        anchorPoint = Vector2.new(0.5, 1),
        backgroundColor = v11,
        position = UDim2.fromScale(0.705, 0.875),
        size = UDim2.fromScale(0.19, 0.235),
        strokeColor = v12
    }, v85, v86, react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 162,
        Position = UDim2.fromScale(0.06, 0.24),
        Size = UDim2.fromScale(0.88, 0.7)
    }, v87, v88))
end

local function SlotButton(p40) -- line: 753
    -- upvalues: react (copy), useFreePurchaseModeEnabled (copy), default (copy), default4 (copy), images (copy), rarityColors (copy), baitAuraSlot2RobuxPrice (copy), baitAuraSlot3RobuxPrice (copy), getBaitAuraConfig (copy), t1 (copy), t2 (copy), v13 (copy), v14 (copy)
    local v94 = getBaitAuraConfig(p40.auraName)
    local v95 = p40.slotIndex + 1
    local auraName = p40.auraName
    local v96 = Color3.fromRGB(140, 140, 145)
    local v97 = getBaitAuraConfig(auraName)

    if v97 ~= nil then
        v96 = t1[v97.rarity] or rarityColors[v97.rarity]
    end

    local v98 = getBaitAuraConfig(p40.auraName)
    local v99 = v98 ~= nil

    v99 = v99 and t2[v98.rarity] ~= nil

    local shineOffset, v100

    if v99 then
        shineOffset = p40.shineOffset
        v100 = 0
    end

    local v101 = useFreePurchaseModeEnabled()
    local v102 = if p40.slotIndex == 1 then baitAuraSlot2RobuxPrice else baitAuraSlot3RobuxPrice

    local function v103() -- line: 762
        -- upvalues: p40 (copy)
        if p40.isUsable then
            p40.onClick()
        else
            p40.onRobuxUnlock()
        end
    end

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 35,
        LayoutOrder = v95,
        Size = UDim2.fromScale(0.31, 1)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1,
        DominantAxis = Enum.DominantAxis.Width
    }), react.createElement(default, {
        cornerRadius = 0.08,
        strokeThickness = 0.008,
        zIndex = 35,
        backgroundColor = v13,
        size = UDim2.fromScale(1, 1),
        strokeColor = v14,
        transparency = p40.isSelected and 0.15 or 0.3
    }, react.createElement("textbutton", {
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 36,
        Event = {
            Activated = v103
        },
        Position = UDim2.fromScale(0, 0),
        Size = UDim2.fromScale(1, 1)
    }), if p40.isUsable then react.createElement(default4, {
        shadowYScale = 0.05,
        anchorPoint = Vector2.new(0.5, 0.5),
        color = if v94 == nil then Color3.fromRGB(255, 255, 255) else v96,
        gradientOffset = shineOffset,
        gradientRotation = v100,
        overrideProps = {
            TextScaled = true,
            TextWrapped = true,
            ZIndex = 37,
            Font = Enum.Font.GothamBlack,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.84, 0.76),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        strokeProps = {
            Thickness = 0.06
        },
        text = if v94 == nil then ("Slot %*"):format(v95) else v94.displayName
    }) else react.createElement(react.Fragment, nil, react.createElement(default4, {
        anchorPoint = Vector2.new(0.5, 0),
        color = Color3.fromRGB(190, 190, 200),
        overrideProps = {
            TextScaled = true,
            TextWrapped = true,
            ZIndex = 37,
            Font = Enum.Font.GothamBlack,
            Position = UDim2.fromScale(0.5, 0.05),
            Size = UDim2.fromScale(0.88, 0.18),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        strokeProps = {
            Thickness = 0.06
        },
        text = ("Rebirth %*"):format(p40.rebirthRequirement)
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ZIndex = 37,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = images.lockIcon,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.51, 0.51)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    })), react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 37,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.fromScale(0.48, 0.75),
        Size = UDim2.fromScale(1.05, 0.21)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0.04, 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        ZIndex = 38,
        Image = images.robuxIcon,
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.34, 1)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    })), react.createElement(default4, {
        anchorPoint = Vector2.new(0, 0.5),
        color = Color3.fromRGB(255, 255, 255),
        overrideProps = {
            LayoutOrder = 2,
            TextScaled = true,
            ZIndex = 38,
            AutomaticSize = Enum.AutomaticSize.X,
            Font = Enum.Font.GothamBlack,
            Size = UDim2.fromScale(0, 1),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        strokeProps = {
            Thickness = 0.07
        },
        text = if v101 then "FREE" else tostring(v102)
    })))), p40.isSelected and react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 40,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uicorner", {
        CornerRadius = UDim.new(0.08, 0)
    }), react.createElement("uistroke", {
        Thickness = 0.05,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Color3.fromRGB(255, 255, 255),
        StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    })))
end

return {
    default = function(p41) -- BaitAuraWindow | line: 888
        -- upvalues: react (copy), useEffect (copy), useMemo (copy), useRef (copy), useState (copy), useMotion (copy), useGlowPulse (copy), ContentProvider (copy), default (copy), default3 (copy), default4 (copy), useFlameworkComponents (copy), useTheme (copy), playClonedSound (copy), rarityColors (copy), default5 (copy), baitAuraConfigs (copy), getBaitAuraConfig (copy), getBaitAuraBuffDescriptions (copy), getBaitAuraSlotRebirthRequirement (copy), isBaitAuraSlotUsable (copy), t1 (copy), t2 (copy), t3 (ref), getRollPreviewAura (copy), v11 (copy), v12 (copy), v13 (copy), v14 (copy), v15 (copy), v16 (copy), v17 (copy), v18 (copy), v19 (copy), v24 (copy), getBaitAuraBackgroundEmitter (copy), setBaitAuraBackgroundVfxVisible (copy), useBaitAuraCamera (copy), getMusicSoundGroup (copy), Label (copy), AuraNameReel (copy), CloseXButton (copy), SideFocusBackdrop (copy), RerollShopPopup (copy), SlotButton (copy)
        local v111 = useTheme()
        local v112, v113 = useState(function() -- line: 890
            -- upvalues: p41 (copy)
            local t25 = {}
            local v114 = #t25
            local auraSlots = p41.auraSlots

            table.move(auraSlots, 1, #auraSlots, v114 + 1, t25)

            return t25
        end)
        local v115 = v112[p41.equippedSlotIndex + 1]
        local v116 = getBaitAuraConfig(v115)
        local v117, v118 = useState(p41.equippedSlotIndex)
        local v119, v120 = useState(v116 or baitAuraConfigs[1])
        local v121, v122 = useState(false)
        local v123, v124 = useState(false)
        local v125, v126 = useState(0.18)
        local v127, v128 = useState(false)
        local v129, v130 = useMotion(-1)
        local v131 = v129:map(function(p42) -- line: 906
            return Vector2.new(p42, 0)
        end)
        local v132 = useGlowPulse():map(function(p43) -- line: 910
            -- upvalues: v15 (copy), v16 (copy)
            return v15:Lerp(v16, p43)
        end)
        local v133 = useRef(0)
        local v134 = useRef(nil)
        local v135 = useRef({})
        local v136 = useRef(nil)
        local v137 = getBaitAuraSlotRebirthRequirement(v117)
        local v138 = isBaitAuraSlotUsable(p41.unlockedSlots, v117, p41.rebirthCount)
        local v139 = v112[v117 + 1]

        if v121 then
            v115 = v119.auraName
        elseif v139 ~= "" then
            v115 = v139
        end

        getBaitAuraConfig(v115)

        local v140 = getBaitAuraConfig(v139)
        local v141 = Color3.fromRGB(180, 180, 180)

        if v141 == nil then
            v141 = Color3.fromRGB(140, 140, 145)
        end

        local v142 = getBaitAuraConfig(v115)

        if v142 ~= nil then
            v141 = rarityColors[v142.rarity]
        end

        v142 = Color3.fromRGB(200, 200, 200)

        if v142 == nil then
            v142 = Color3.fromRGB(140, 140, 145)
        end

        local v143 = getBaitAuraConfig(v139)

        if v143 ~= nil then
            v142 = rarityColors[v143.rarity]
        end

        v143 = Color3.fromRGB(200, 200, 200)

        if v143 == nil then
            v143 = Color3.fromRGB(140, 140, 145)
        end

        local v144 = getBaitAuraConfig(v139)

        if v144 ~= nil then
            v143 = t1[v144.rarity] or rarityColors[v144.rarity]
        end

        v144 = getBaitAuraConfig(v139)

        local v145 = v144 ~= nil
        local v146

        if v145 then
            v146 = v144.rarity
            v145 = t2[v146] ~= nil
        end

        if v145 then
            v144 = v131
            v146 = 0
        else
            v144 = nil
            v146 = nil
        end

        local v147 = getBaitAuraBuffDescriptions(v139)
        local v148

        if v138 then
            v139 = if v140 ~= nil then ("%* Perks"):format(v140.displayName) else "Aura Perks"
            v148 = if v140 ~= nil then v140.description else v140

            if v148 == nil then
                v148 = "Select or roll an aura to view its special buffs here."
            end

            v147 = if v140 == nil then "No aura selected." elseif #v147 > 0 then table.concat(v147, "\n") else "Special buff details coming soon."
        else
            v139 = "Locked"
            v148 = "Locked"
            v147 = ("Reach Rebirth %* or unlock with Robux to use this slot."):format(v137)
        end

        local v149 = p41.disableSceneCamera ~= true
        local v150 = v121 or v123

        v123 = useFlameworkComponents(function() -- line: 954
            return true
        end, "client/components/bait-aura-preview-rig-component@BaitAuraPreviewRigComponent")[1]

        if v123 ~= nil then
            v123 = v123.instance
        end

        useBaitAuraCamera(v149, v123, v121)
        useEffect(function() -- line: 334
            -- upvalues: v149 (copy), getMusicSoundGroup (copy)
            if not v149 then
                return nil
            end

            local v151 = getMusicSoundGroup()

            if v151 == nil then
                return nil
            end

            local Volume = v151.Volume

            v151.Volume = Volume * 0.28

            return function() -- line: 344
                -- upvalues: v151 (copy), Volume (copy)
                v151.Volume = Volume
            end
        end, { v149 })
        useEffect(function() -- line: 350
            -- upvalues: v149 (copy), ContentProvider (copy), getBaitAuraBackgroundEmitter (copy)
            if not v149 then
                return nil
            end

            local v152 = getBaitAuraBackgroundEmitter()

            if v152 == nil then
                return nil
            end

            task.spawn(function() -- line: 358
                -- upvalues: ContentProvider (copy), v152 (copy)
                local function v153() -- line: 359
                    -- upvalues: ContentProvider (copy), v152 (copy)
                    return ContentProvider:PreloadAsync({ v152 })
                end

                pcall(v153)
            end)

            return function() -- line: 363
                -- upvalues: getBaitAuraBackgroundEmitter (copy)
                local v154 = getBaitAuraBackgroundEmitter()

                if v154 ~= nil then
                    v154.Enabled = false
                    v154.Transparency = NumberSequence.new(1)
                end
            end
        end, { v149 })

        local v155 = useMemo(function() -- line: 965
            -- upvalues: baitAuraConfigs (copy)
            local t26 = {}
            local v156 = #t26

            table.move(baitAuraConfigs, 1, #baitAuraConfigs, v156 + 1, t26)
            table.sort(t26, function(p44, p45) -- line: 969
                return p44.chancePercent > p45.chancePercent
            end)

            return t26
        end, {})

        useEffect(function() -- line: 974
            -- upvalues: p41 (copy), v113 (copy), v121 (copy), v135 (copy)
            if v121 then
                return nil
            end

            v113(function() -- line: 978
                -- upvalues: p41 (copy), v135 (copy)
                local t27 = {}
                local v157 = #t27
                local auraSlots = p41.auraSlots

                table.move(auraSlots, 1, #auraSlots, v157 + 1, t27)

                for v158, v159 in v135.current do
                    if p41.auraSlots[v158 + 1] == v159 then
                        v135.current[v158] = nil
                    else
                        t27[v158 + 1] = v159
                    end
                end

                return t27
            end)
        end, {
            p41.auraSlots,
            v121
        })
        useEffect(function() -- line: 997
            -- upvalues: v115 (ref), v120 (copy), v121 (copy), baitAuraConfigs (copy), getBaitAuraConfig (copy)
            if not v121 then
                v120(getBaitAuraConfig(v115) or baitAuraConfigs[1])
            end
        end, { v115, v121 })
        useEffect(function() -- line: 1002
            -- upvalues: v136 (copy)
            return function() -- line: 1003
                -- upvalues: v136 (copy)
                if v136.current ~= nil then
                    task.cancel(v136.current)
                end
            end
        end, {})
        useEffect(function() -- line: 1009
            -- upvalues: v130 (copy)
            v130:linear(1, {
                speed = 1.4
            })

            local v161 = v130:onComplete(function() -- line: 1016
                -- upvalues: v130 (copy)
                v130:immediate(-1)
                v130:linear(1, {
                    speed = 1.4
                })
            end)

            return function() -- line: 1020
                -- upvalues: v161 (copy)
                return v161()
            end
        end, { v130 })
        useEffect(function() -- line: 1024
            -- upvalues: v115 (ref), v119 (copy), v120 (copy), v121 (copy), v126 (copy), v133 (copy), v134 (copy), playClonedSound (copy), rarityColors (copy), baitAuraConfigs (copy), getBaitAuraConfig (copy), t3 (ref), getRollPreviewAura (copy), setBaitAuraBackgroundVfxVisible (copy)
            if not v121 then
                return nil
            end

            local current = v133.current
            local t28 = {}
            local n3 = 0
            local auraName = v119.auraName
            local t29 = t3

            for v162, v163 in t29 do
                local v164 = v162 - 1

                n3 += v163
                table.insert(t28, (task.delay(n3, function() -- line: 1035
                    -- upvalues: current (copy), auraName (ref), v164 (copy), v163 (copy), v120 (copy), v126 (copy), v133 (copy), v134 (copy), playClonedSound (copy), rarityColors (copy), getBaitAuraConfig (copy), t3 (ref), getRollPreviewAura (copy), setBaitAuraBackgroundVfxVisible (copy)
                    if v133.current ~= current then
                        return nil
                    end

                    local current2 = if v164 == #t3 - 1 then v134.current else nil
                    local v167 = current2 ~= nil and getBaitAuraConfig(current2) or getRollPreviewAura(v164, auraName)

                    auraName = v167.auraName
                    v126((math.max(0.12, v163 * (if v164 >= #t3 - 2 then 0.96 else 0.88))))
                    v120(v167)

                    local auraName2 = v167.auraName
                    local v170 = Color3.fromRGB(140, 140, 145)
                    local v171 = getBaitAuraConfig(auraName2)

                    if v171 ~= nil then
                        v170 = rarityColors[v171.rarity]
                    end

                    setBaitAuraBackgroundVfxVisible(true, v170)
                    playClonedSound("AuraRolling")
                end)))
            end

            return function() -- line: 1055
                -- upvalues: current (copy), t28 (copy), v115 (ref), v120 (copy), v133 (copy), baitAuraConfigs (copy), getBaitAuraConfig (copy)
                local function v172(p46) -- line: 1057
                    return task.cancel(p46)
                end

                for v173, v174 in t28 do
                    local _ = v173 - 1

                    task.cancel(v174)
                end

                if v133.current == current then
                    v120(getBaitAuraConfig(v115) or baitAuraConfigs[1])
                end
            end
        end, { v121 })

        local function v176() -- line: 1069
            -- upvalues: p41 (copy), v113 (copy), v117 (copy), v120 (copy), v121 (copy), v122 (copy), v124 (copy), v126 (copy), v133 (copy), v134 (copy), v135 (copy), v136 (copy), v138 (copy), v141 (ref), playClonedSound (copy), rarityColors (copy), baitAuraConfigs (copy), getBaitAuraConfig (copy), v24 (copy), getBaitAuraBackgroundEmitter (copy), setBaitAuraBackgroundVfxVisible (copy)
            if v121 or not v138 then
                return nil
            end

            if p41.rerolls <= 0 then
                p41.onBuyReroll(1)

                return nil
            end

            v133.current += 1

            local current = v133.current

            v134.current = nil
            setBaitAuraBackgroundVfxVisible(true, v141, true)
            v126(0.12)
            v124(false)
            v122(true)

            if v136.current ~= nil then
                task.cancel(v136.current)
            end

            v136.current = task.delay(1, function() -- line: 1090
                -- upvalues: current (copy), v133 (copy), v136 (copy), playClonedSound (copy)
                v136.current = nil

                if v133.current == current then
                    playClonedSound("AuraRiser", {
                        timePosition = 1.65
                    })
                end
            end)
            p41.onRollAura(v117):andThen(function(p47) -- line: 1098
                -- upvalues: current (copy), v113 (copy), v117 (copy), v120 (copy), v122 (copy), v124 (copy), v133 (copy), v134 (copy), v135 (copy), playClonedSound (copy), rarityColors (copy), baitAuraConfigs (copy), getBaitAuraConfig (copy), v24 (copy), getBaitAuraBackgroundEmitter (copy), setBaitAuraBackgroundVfxVisible (copy)
                v134.current = if p47 == nil then p47 else p47.auraName
                task.delay(v24, function() -- line: 1104
                    -- upvalues: p47 (copy), current (copy), v113 (copy), v117 (copy), v120 (copy), v122 (copy), v124 (copy), v133 (copy), v135 (copy), playClonedSound (copy), rarityColors (copy), baitAuraConfigs (copy), getBaitAuraConfig (copy), getBaitAuraBackgroundEmitter (copy), setBaitAuraBackgroundVfxVisible (copy)
                    if v133.current ~= current then
                        return nil
                    end

                    if p47 ~= nil then
                        local v179 = getBaitAuraConfig(p47.auraName) or baitAuraConfigs[1]
                        local rarity = p47.rarity

                        playClonedSound(if rarity == "legendary" then "AuraRevealLegend" elseif rarity == "mythic" then "AuraRevealMythic" else "AuraReveal", {
                            timePosition = 0.1
                        })
                        v120(v179)

                        local auraName = p47.auraName
                        local v181 = Color3.fromRGB(140, 140, 145)
                        local v182 = getBaitAuraConfig(auraName)

                        if v182 ~= nil then
                            v181 = rarityColors[v182.rarity]
                        end

                        setBaitAuraBackgroundVfxVisible(true, v181)
                        v135.current[v117] = p47.auraName
                        v113(function(p48) -- line: 1118
                            -- upvalues: p47 (copy), v117 (copy)
                            local t30 = {}
                            local v183 = #t30

                            table.move(p48, 1, #p48, v183 + 1, t30)
                            t30[v117 + 1] = p47.auraName

                            return t30
                        end)
                        v122(false)
                        v124(true)
                        task.delay(0.05, function() -- line: 1128
                            -- upvalues: current (copy), v124 (copy), v133 (copy), getBaitAuraBackgroundEmitter (copy)
                            if v133.current ~= current then
                                return
                            end

                            v124(false)

                            local v184 = getBaitAuraBackgroundEmitter()

                            if v184 == nil then
                                return
                            end

                            v184.Enabled = false
                            v184.Transparency = NumberSequence.new(1)
                        end)
                    else
                        local v178 = getBaitAuraBackgroundEmitter()

                        if v178 ~= nil then
                            v178.Enabled = false
                            v178.Transparency = NumberSequence.new(1)
                        end

                        v122(false)
                    end
                end)
            end)
        end

        local v185 = react.createElement
        local v186 = {
            active = v149
        }

        if v121 then
            v186.auraName = nil
        else
            v186.auraName = v115
        end

        v186.isRolling = v121
        v186.rigInstance = v123
        v186.rollingColor = v141
        v185 = v185(default5, v186)

        local v187 = react.createElement("screengui", {
            DisplayOrder = -1000,
            ResetOnSpawn = false,
            ScreenInsets = Enum.ScreenInsets.None
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1)
        }, react.createElement(SideFocusBackdrop)))

        v123 = not v150 and react.createElement(CloseXButton, {
            onClick = p41.onClose
        })

        local v188 = react.createElement(Label, {
            text = "Current Bait Aura:",
            zIndex = 130,
            anchorPoint = Vector2.new(0.5, 0),
            color = Color3.fromRGB(235, 235, 235),
            position = UDim2.fromScale(0.5, 0.03),
            size = UDim2.fromScale(0.28, 0.055)
        })

        v186 = react.createElement(AuraNameReel, {
            zIndex = 130,
            auraName = v115,
            isRolling = v121,
            position = UDim2.fromScale(0.5, 0.072),
            shineOffset = v131,
            size = UDim2.fromScale(0.38, 0.12),
            transitionTime = v125
        })
        v125 = not v150

        local v189, t31, createElement, t32

        if v125 then
            v189 = react.createElement(Label, {
                text = "Aura Slots",
                zIndex = 124,
                anchorPoint = Vector2.new(0, 0),
                font = Enum.Font.GothamBlack,
                position = UDim2.fromScale(0.06, 0.03),
                size = UDim2.fromScale(0.85, 0.09),
                textXAlignment = Enum.TextXAlignment.Left
            })

            local v190 = react.createElement("uilistlayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0.035, 0),
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center
            })

            t31 = {
                0, 1, 2
            }

            local v191 = table.create(#t31)

            local function v192(p49) -- line: 1197
                -- upvalues: p41 (copy), v112 (copy), v117 (copy), v118 (copy), v131 (copy), react (copy), getBaitAuraSlotRebirthRequirement (copy), isBaitAuraSlotUsable (copy), SlotButton (copy)
                local v193 = getBaitAuraSlotRebirthRequirement(p49)
                local v194 = isBaitAuraSlotUsable(p41.unlockedSlots, p49, p41.rebirthCount)

                return react.createElement(SlotButton, {
                    auraName = v112[p49 + 1],
                    isSelected = v117 == p49,
                    isUsable = v194,
                    key = ("slot-%*"):format(p49),
                    onClick = function() -- onClick | line: 1205
                        -- upvalues: p49 (copy), v194 (copy), p41 (copy), v112 (copy), v118 (copy)
                        if not v194 then
                            return nil
                        end

                        v118(p49)

                        if v112[p49 + 1] ~= "" then
                            p41.onEquipSlot(p49)
                        end
                    end,
                    onRobuxUnlock = function() -- onRobuxUnlock | line: 1214
                        -- upvalues: p49 (copy), p41 (copy)
                        return p41.onBuySlotWithRobux(p49)
                    end,
                    rebirthRequirement = v193,
                    shineOffset = v131,
                    slotIndex = p49
                })
            end

            for v195, v196 in t31 do
                v191[v195] = v192(v196, v195 - 1, t31)
            end

            local createElement2 = react.createElement
            local t34 = {
                cornerRadius = 0.025,
                isStudded = true,
                strokeThickness = 0.005,
                textureTransparency = 0.9,
                transparency = 0.3,
                zIndex = 120,
                backgroundColor = v11,
                position = UDim2.fromScale(0.035, 0.15),
                size = UDim2.fromScale(0.24, 0.66),
                strokeColor = v12
            }
            local v197 = react.createElement("frame", {
                BackgroundTransparency = 1,
                ZIndex = 125,
                Position = UDim2.fromScale(0.06, 0.17),
                Size = UDim2.fromScale(0.88, 0.25)
            }, v190, v191)

            createElement = react.createElement
            t32 = {
                cornerRadius = 0.08,
                strokeThickness = 0.01,
                transparency = 0.15,
                zIndex = 125,
                backgroundColor = v13,
                position = UDim2.fromScale(0.06, 0.44),
                size = UDim2.fromScale(0.88, 0.48)
            }

            if v140 == nil then
                v142 = v14
            end

            t32.strokeColor = v142

            local createElement3 = react.createElement
            local t35 = {
                zIndex = 128,
                anchorPoint = Vector2.new(0, 0)
            }

            if not v138 then
                v143 = Color3.fromRGB(190, 190, 200)
            end

            t35.color = v143
            t35.font = Enum.Font.GothamBlack
            t35.gradientOffset = v144
            t35.gradientRotation = v146
            t35.position = UDim2.fromScale(0.05, 0.06)
            t35.size = UDim2.fromScale(0.9, 0.12)
            t35.text = v139
            t35.textXAlignment = Enum.TextXAlignment.Left
            v125 = createElement2(default, t34, v189, v197, createElement(default, t32, createElement3(Label, t35), react.createElement("textlabel", {
                BackgroundTransparency = 1,
                TextScaled = true,
                TextWrapped = true,
                ZIndex = 128,
                Font = Enum.Font.GothamBold,
                Position = UDim2.fromScale(0.07, 0.23),
                Size = UDim2.fromScale(0.86, 0.2),
                Text = v148,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top
            }, react.createElement("uistroke", {
                Thickness = 1,
                Color = Color3.fromRGB(0, 0, 0)
            })), react.createElement("frame", {
                BackgroundTransparency = 0.88,
                BorderSizePixel = 0,
                ZIndex = 128,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Position = UDim2.fromScale(0.07, 0.49),
                Size = UDim2.fromScale(0.86, 0.006)
            }), react.createElement("textlabel", {
                BackgroundTransparency = 1,
                TextScaled = true,
                TextWrapped = true,
                ZIndex = 128,
                Font = Enum.Font.GothamBold,
                Position = UDim2.fromScale(0.07, 0.56),
                Size = UDim2.fromScale(0.86, 0.34),
                Text = v147,
                TextColor3 = Color3.fromRGB(190, 190, 200),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top
            }, react.createElement("uistroke", {
                Thickness = 1,
                Color = Color3.fromRGB(0, 0, 0)
            }))))
        end

        v148 = not v150

        if v148 then
            v189 = react.createElement(Label, {
                text = "Aura Chances",
                zIndex = 124,
                anchorPoint = Vector2.new(0, 0),
                font = Enum.Font.GothamBlack,
                position = UDim2.fromScale(0.08, 0.03),
                size = UDim2.fromScale(0.84, 0.09),
                textXAlignment = Enum.TextXAlignment.Left
            })

            local v198 = react.createElement("uilistlayout", {
                Padding = UDim.new(0.012, 0),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            local v199 = table.create(#v155)

            v142 = function(p50) -- line: 1318
                -- upvalues: v131 (copy), react (copy), default4 (copy), rarityColors (copy), t1 (copy), t2 (copy)
                local v200 = t1[p50.rarity] or rarityColors[p50.rarity]
                local rarity = p50.rarity
                local v201, v202

                if t2[rarity] ~= nil then
                    v202 = v131
                    v201 = 0
                end

                return react.createElement("frame", {
                    BackgroundTransparency = 1,
                    ZIndex = 125,
                    LayoutOrder = 1000 - p50.chancePercent * 10,
                    Size = UDim2.fromScale(1, 0.085),
                    key = ("chance-%*"):format(p50.auraName)
                }, react.createElement(default4, {
                    color = v200,
                    gradientOffset = v202,
                    gradientRotation = v201,
                    overrideProps = {
                        TextScaled = true,
                        ZIndex = 126,
                        Font = Enum.Font.FredokaOne,
                        Position = UDim2.fromScale(0, 0),
                        Size = UDim2.fromScale(1, 0.88),
                        TextXAlignment = Enum.TextXAlignment.Left
                    },
                    strokeProps = {
                        Thickness = 0.05
                    },
                    text = ("• %* (%*%%)"):format(p50.displayName, p50.chancePercent)
                }), react.createElement("frame", {
                    BackgroundTransparency = 0.88,
                    BorderSizePixel = 0,
                    ZIndex = 126,
                    AnchorPoint = Vector2.new(0.5, 1),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Position = UDim2.fromScale(0.5, 1),
                    Size = UDim2.fromScale(1, 0.035)
                }))
            end

            for v203, v204 in v155 do
                v199[v203] = v142(v204, v203 - 1, v155)
            end

            v148 = react.createElement(default, {
                cornerRadius = 0.025,
                isStudded = true,
                strokeThickness = 0.005,
                textureTransparency = 0.9,
                transparency = 0.3,
                zIndex = 120,
                backgroundColor = v11,
                position = UDim2.fromScale(0.725, 0.15),
                size = UDim2.fromScale(0.24, 0.66),
                strokeColor = v12
            }, v189, react.createElement("frame", {
                BackgroundTransparency = 1,
                ZIndex = 125,
                Position = UDim2.fromScale(0.08, 0.145),
                Size = UDim2.fromScale(0.86, 0.81)
            }, v198, v199))
        end

        v189 = react.createElement
        t31 = {
            BackgroundTransparency = 1,
            ZIndex = 100,
            Size = UDim2.fromScale(1, 1)
        }
        createElement = not v150

        if createElement then
            if v127 then
                createElement = react.createElement
                t32 = {
                    onBuyReroll = p41.onBuyReroll
                }

                function t32.onClose() -- line: 1384
                    -- upvalues: v128 (copy)
                    return v128(false)
                end

                v127 = createElement(RerollShopPopup, t32)
            end
        else
            v127 = createElement
        end

        local v205 = not v150

        if v205 then
            local createElement = react.createElement
            local t36 = {
                BackgroundTransparency = 1,
                ZIndex = 130,
                AnchorPoint = Vector2.new(0.5, 1),
                Position = UDim2.fromScale(0.5, 0.97),
                Size = UDim2.fromScale(0.42, 0.15)
            }
            local v206 = react.createElement("textlabel", {
                BackgroundTransparency = 1,
                TextScaled = true,
                ZIndex = 132,
                AnchorPoint = Vector2.new(0.5, 0),
                Font = Enum.Font.FredokaOne,
                Position = UDim2.fromScale(0.5, 0.12),
                Size = UDim2.fromScale(0.36, 0.22),
                Text = ("Rerolls: %*"):format(p41.rerolls),
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }, react.createElement("uistroke", {
                Thickness = 0.1,
                Color = Color3.fromRGB(0, 0, 0),
                StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
            }))
            local createElement2 = react.createElement
            local t37 = {
                cornerRadius = 0.1,
                isStudded = true,
                shadowYScale = 0.085,
                zIndex = 130,
                anchorPoint = Vector2.new(0.5, 1),
                color = if v138 then v17 else v19,
                font = v111.textFont2,
                frameSize = UDim2.fromScale(0.46, 0.56),
                label = v150 and "Rolling" or "Reroll",
                onClick = function() -- onClick | line: 1415
                    -- upvalues: v150 (copy), v176 (copy)
                    if v150 then
                        return nil
                    end

                    v176()
                end,
                popoutColor = if v138 then Color3.fromRGB(143, 51, 5) else Color3.fromRGB(40, 55, 68),
                position = UDim2.fromScale(0.5, 1)
            }

            if not (p41.rerolls > 0) then
                v132 = nil
            end

            t37.strokeColor = v132
            createElement2 = createElement2(default3, t37)
            v205 = createElement("frame", t36, v206, createElement2, react.createElement(default3, {
                cornerRadius = 0.1,
                isStudded = true,
                label = "Buy Rerolls",
                shadowYScale = 0.085,
                zIndex = 130,
                anchorPoint = Vector2.new(0, 1),
                color = v18,
                font = v111.textFont2,
                frameSize = UDim2.fromScale(0.34, 0.42),
                onClick = function() -- onClick | line: 1434
                    -- upvalues: v128 (copy)
                    return v128(function(p51) -- line: 1435
                        return not p51
                    end)
                end,
                popoutColor = Color3.fromRGB(10, 120, 10),
                position = UDim2.fromScale(0.75, 0.94),
                size = UDim2.fromScale(0.8, 0.7)
            }))
        end

        return v189("frame", t31, v185, v187, v123, v188, v186, v125, v148, v127, v205)
    end
}
