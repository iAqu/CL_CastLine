-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local getTitleData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "titles").getTitleData
local selectPlayerEquippedTitle = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerEquippedTitle
local secretFrostwyrmActiveAtom = RuntimeLib.import(script, script.Parent.Parent, "secret-frostwyrm-active-atom").secretFrostwyrmActiveAtom
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local v1 = UDim2.fromScale(5.75, 3.5)
local v2 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 245, 170)),
    ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 183, 28)),
    ColorSequenceKeypoint.new(0.65, Color3.fromRGB(255, 250, 205)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(194, 105, 10))
})
local v3 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 226, 255)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(210, 70, 255)),
    ColorSequenceKeypoint.new(0.65, Color3.fromRGB(255, 65, 95)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 50, 255))
})
local t1 = {
    Color3.fromRGB(255, 211, 74),
    Color3.fromRGB(220, 232, 245),
    Color3.fromRGB(211, 132, 72)
}
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 31
        return "TitleNameplateController"
    end
})

self.__index = self

function self.new(...) -- line: 36
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 40
    p1._reflexController = p2
    p1._playerMaids = {}
    p1._billboards = {}
    p1._animatedGradients = {}
    p1._celebrationGradients = {}
    p1._prestigeRankEffects = {}
    p1._premiumEventEffects = {}
    p1._gradientRotation = 0
    p1._animationTime = 0
    p1._secretFrostwyrmActive = false
end

function self.onStart(p3) -- line: 52
    -- upvalues: subscribe (copy), Players (copy), secretFrostwyrmActiveAtom (copy)
    for _, player in Players:GetPlayers() do
        p3:_setupPlayer(player)
    end

    Players.PlayerAdded:Connect(function(p4) -- line: 56
        -- upvalues: p3 (copy)
        return p3:_setupPlayer(p4)
    end)
    Players.PlayerRemoving:Connect(function(p5) -- line: 59
        -- upvalues: p3 (copy)
        local v6 = p3._playerMaids[p5]

        if v6 ~= nil then
            v6:Destroy()
        end

        p3._playerMaids[p5] = nil
    end)
    subscribe(secretFrostwyrmActiveAtom, function(p6) -- line: 70
        -- upvalues: p3 (copy)
        p3._secretFrostwyrmActive = p6

        for v7 in p3._billboards do
            if v7.Parent then
                v7.Enabled = not p6
            else
                p3._billboards[v7] = nil
            end
        end
    end)
end

function self.onRender(p7, p8) -- line: 81
    p7._animationTime += p8
    p7._gradientRotation = (p7._gradientRotation + 90 * p8) % 360

    for v8 in p7._animatedGradients do
        if v8.Parent then
            v8.Rotation = p7._gradientRotation
        else
            p7._animatedGradients[v8] = nil
        end
    end

    for v9 in p7._celebrationGradients do
        if v9.Parent then
            v9.Rotation = 0
            v9.Offset = Vector2.new(math.sin(p7._animationTime * 0.85) * 0.22, 0)
        else
            p7._celebrationGradients[v9] = nil
        end
    end

    for v11, v12 in p7._prestigeRankEffects do
        if v11.Parent then
            local v14 = (math.sin(p7._animationTime * 3.2 + v12.phase) + 1) * 0.5

            v12.scale.Scale = v14 * 0.035 + 1
            v12.gradient.Offset = Vector2.new(math.sin(p7._animationTime * 1.8 + v12.phase) * 0.35, 0)
            v11.TextStrokeTransparency = v14 * 0.18 + 0.05
            continue
        end

        p7._prestigeRankEffects[v11] = nil
    end

    for v16, v17 in p7._premiumEventEffects do
        if v16.Parent and v17.container.Parent then
            local v19 = (math.sin(p7._animationTime * 2.1 + v17.phase) + 1) * 0.5
            local v20 = p7._animationTime - v17.startedAt
            local v22 = math.max(0, 1 - v20 * 2.5) * 0.065

            v17.scale.Scale = v19 * 0.025 + 1 + v22
            v17.hat.Rotation = math.sin(p7._animationTime * 1.7 + v17.phase) * 7

            for _, v24 in v17.pieces do
                local v25 = if v20 < 1.25 then math.clamp(v20 * 0.9 - v24.phase * 0.16, 0, 1) else (p7._animationTime * 0.2 + v24.phase) % 1
                local v28 = math.sin(v25 * 3.141592653589793)
                local v30 = math.sin(v25 * 3.141592653589793 * 2 + v24.phase * 3.141592653589793 * 2) * v24.wobble

                v24.object.Position = UDim2.fromScale(v24.originX + v24.xDirection * v25 * v24.horizontalDistance + v30, v24.originY - v28 * v24.arcHeight + v25 * v24.fallDistance)
                v24.object.Rotation = v25 * v24.rotationSpeed * v24.xDirection

                local v33 = math.clamp(math.abs(v25 - 0.5) * 0.95 + 0.02, 0.02, 0.58)

                if v24.object:IsA("Frame") then
                    v24.object.BackgroundTransparency = v33
                else
                    v24.object.ImageTransparency = v33
                end
            end

            continue
        end

        p7._premiumEventEffects[v16] = nil
    end
end

function self._setupPlayer(p9, p10) -- line: 134
    -- upvalues: Maid (copy), getTitleData (copy), selectPlayerEquippedTitle (copy), images (copy), v1 (copy), v2 (copy), v3 (copy), t1 (copy)
    local v34 = Maid.new()

    p9._playerMaids[p10] = v34

    local v35 = p9._reflexController:getClientProducer()
    local v36 = tostring(p10.UserId)
    local TextLabel = nil
    local v37, v38, UIGradient, Frame, UIScale

    local function v39() -- line: 164
        -- upvalues: p9 (copy), p10 (copy), TextLabel (ref), Frame (ref), UIScale (ref), images (copy)
        if not TextLabel then
            return nil
        end

        if TextLabel then
            p9._premiumEventEffects[TextLabel] = nil
        end

        local Frame2 = Frame

        if Frame2 ~= nil then
            Frame2:Destroy()
        end

        Frame = nil

        local UIScale2 = UIScale

        if UIScale2 ~= nil then
            UIScale2:Destroy()
        end

        UIScale = nil

        local Frame3 = Instance.new("Frame")

        Frame3.Name = "OGPrimeCelebration"
        Frame3.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame3.BackgroundTransparency = 1
        Frame3.Position = UDim2.fromScale(0.5, 0.5)
        Frame3.Size = UDim2.fromScale(1.2, 2.1)
        Frame3.ZIndex = 2
        Frame3.Parent = TextLabel
        Frame = Frame3

        local UIScale3 = Instance.new("UIScale")

        UIScale3.Parent = TextLabel
        UIScale = UIScale3

        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = images.eventIcon
        ImageLabel.Position = UDim2.fromScale(0.185, 0.48)
        ImageLabel.ScaleType = Enum.ScaleType.Fit
        ImageLabel.Size = UDim2.fromScale(0.105, 0.68)
        ImageLabel.ZIndex = 10
        ImageLabel.Parent = Frame3

        local t5 = {
            Color3.fromRGB(255, 235, 70),
            Color3.fromRGB(255, 65, 195),
            Color3.fromRGB(70, 240, 255),
            Color3.fromRGB(190, 95, 255),
            Color3.fromRGB(255, 255, 235)
        }
        local t6 = {}
        local v40 = Random.new(p10.UserId)

        for i = 0, 7 do
            local v41 = i == 1 or i == 4 or i == 6
            local v42 = if v41 then Instance.new("ImageLabel") else Instance.new("Frame")

            v42.AnchorPoint = Vector2.new(0.5, 0.5)
            v42.BackgroundTransparency = 1
            v42.Size = UDim2.fromScale(v41 and 0.075 or 0.03, v41 and 0.31 or 0.17)
            v42.ZIndex = 9

            if v42:IsA("ImageLabel") then
                v42.Image = images.sparkleIcon
                v42.ImageColor3 = t5[i % #t5 + 1]
                v42.ScaleType = Enum.ScaleType.Fit
            else
                v42.BackgroundColor3 = t5[i % #t5 + 1]
                v42.BackgroundTransparency = 0.2

                local UICorner = Instance.new("UICorner")

                UICorner.CornerRadius = UDim.new(0.25, 0)
                UICorner.Parent = v42

                local UIStroke = Instance.new("UIStroke")

                UIStroke.Color = Color3.fromRGB(255, 255, 255)
                UIStroke.Thickness = 1
                UIStroke.Transparency = 0.12
                UIStroke.Parent = v42
            end

            v42.Parent = Frame3

            local v43 = if v40:NextNumber() < 0.5 then -1 else 1

            table.insert(t6, {
                arcHeight = v40:NextNumber(0.34, 0.78),
                fallDistance = v40:NextNumber(0.04, 0.2),
                horizontalDistance = v40:NextNumber(0.2, 0.48),
                object = v42,
                originX = v40:NextNumber(0.28, 0.72),
                originY = v40:NextNumber(0.42, 0.7),
                phase = i / 8,
                rotationSpeed = v40:NextNumber(150, 420),
                wobble = v40:NextNumber(0.015, 0.07),
                xDirection = v43
            })
        end

        local _premiumEventEffects = p9._premiumEventEffects
        local TextLabel2 = TextLabel

        _premiumEventEffects[TextLabel2] = {
            container = Frame3,
            hat = ImageLabel,
            phase = p10.UserId % 13,
            pieces = t6,
            scale = UIScale3,
            startedAt = p9._animationTime
        }
    end

    local function v44(p11, p12, p13) -- line: 246
        -- upvalues: p9 (copy), p10 (copy), t1 (copy)
        if not p11 then
            return nil
        end

        local v45

        if p12 ~= nil then
            v45 = -1

            for v46, v47 in p12 do
                local _ = v46 - 1

                if v47.userId == p10.UserId == true then
                    v45 = v46 - 1
                    break
                end

                v45 = -1
            end
        else
            v45 = p12
        end

        if v45 == nil then
            v45 = -1
        end

        local v48 = v45 >= 0 and v45 < 5

        if v48 then
            local v49 = v45 + 1

            p11.Text = ("#%* %*"):format(v49, (string.upper(p13)))

            local v50 = p9._prestigeRankEffects[p11]

            if v50 then
                v50.plaqueBorder.Color = t1[v45 + 1] or v50.baseAccentColor

                local plaqueBorder = v50.plaqueBorder

                if v49 == 1 then
                    plaqueBorder.Thickness = 3
                elseif v49 <= 3 then
                    plaqueBorder.Thickness = 2.6
                else
                    plaqueBorder.Thickness = 2.25
                end
            end
        else
            p11.Text = ""
        end

        p11.Visible = v48

        return if v48 then v45 + 1 else nil
    end

    local function v51() -- line: 288
        -- upvalues: v35 (copy), v37 (ref), v38 (ref), v44 (copy)
        local v52 = v35:getState()
        local v53 = v44(v37, v52.leaderboard.money, "Cash King")
        local v54 = v44(v38, v52.leaderboard.power, "Power Legend")

        if not (v37 and v38) then
            return
        end

        local v55 = v54 ~= nil and (v53 == nil or v54 < v53)
        local v56 = v37

        v56.LayoutOrder = v55 and -1 or -2

        local v57 = v38

        v57.LayoutOrder = v55 and -2 or -1
    end

    local function v58(p14) -- line: 298
        -- upvalues: p9 (copy), v34 (copy), TextLabel (ref), UIGradient (ref), Frame (ref), UIScale (ref), v39 (copy), getTitleData (copy)
        if not TextLabel then
            return nil
        end

        local v59 = if p14 == nil then nil else getTitleData(p14)

        if v59 then
            local TextLabel2 = TextLabel

            TextLabel2.Text = v59.displayName
            TextLabel.Visible = true

            if v59.animatedColor then
                local TextLabel2 = TextLabel

                TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)

                if not UIGradient then
                    UIGradient = Instance.new("UIGradient")
                    UIGradient.Parent = TextLabel
                    v34:GiveTask(UIGradient)
                end

                local UIGradient2 = UIGradient

                UIGradient2.Color = v59.animatedColor

                if v59.id == "markOfTheOg" or v59.visualTier == "premiumEvent" then
                    p9._animatedGradients[UIGradient] = nil
                    p9._celebrationGradients[UIGradient] = true
                else
                    p9._celebrationGradients[UIGradient] = nil
                    p9._animatedGradients[UIGradient] = true
                end

                if v59.visualTier == "premiumEvent" then
                    v39()
                else
                    if TextLabel then
                        p9._premiumEventEffects[TextLabel] = nil
                    end

                    local Frame2 = Frame

                    if Frame2 ~= nil then
                        Frame2:Destroy()
                    end

                    Frame = nil

                    local UIScale2 = UIScale

                    if UIScale2 ~= nil then
                        UIScale2:Destroy()
                    end

                    UIScale = nil
                end
            else
                local TextLabel2 = TextLabel

                TextLabel2.TextColor3 = v59.color

                if UIGradient then
                    p9._animatedGradients[UIGradient] = nil
                    p9._celebrationGradients[UIGradient] = nil
                    UIGradient:Destroy()
                    UIGradient = nil
                end

                if TextLabel then
                    p9._premiumEventEffects[TextLabel] = nil
                end

                local Frame2 = Frame

                if Frame2 ~= nil then
                    Frame2:Destroy()
                end

                Frame = nil

                local UIScale2 = UIScale

                if UIScale2 ~= nil then
                    UIScale2:Destroy()
                end

                UIScale = nil
            end

            return
        end

        TextLabel.Text = ""
        TextLabel.Visible = false

        if UIGradient then
            p9._animatedGradients[UIGradient] = nil
            p9._celebrationGradients[UIGradient] = nil
            UIGradient:Destroy()
            UIGradient = nil
        end

        if TextLabel then
            p9._premiumEventEffects[TextLabel] = nil
        end

        local Frame2 = Frame

        if Frame2 ~= nil then
            Frame2:Destroy()
        end

        Frame = nil

        local UIScale2 = UIScale

        if UIScale2 ~= nil then
            UIScale2:Destroy()
        end

        UIScale = nil

        return nil
    end

    local function v60(p15) -- line: 364
        -- upvalues: p9 (copy), p10 (copy), v34 (copy), v35 (copy), v36 (copy), TextLabel (ref), v37 (ref), v38 (ref), UIGradient (ref), Frame (ref), UIScale (ref), v51 (copy), v58 (copy), selectPlayerEquippedTitle (copy), v1 (copy), v2 (copy), v3 (copy)
        if UIGradient then
            p9._animatedGradients[UIGradient] = nil
            p9._celebrationGradients[UIGradient] = nil
            UIGradient = nil
        end

        if TextLabel then
            p9._premiumEventEffects[TextLabel] = nil
        end

        local Frame2 = Frame

        if Frame2 ~= nil then
            Frame2:Destroy()
        end

        Frame = nil

        local UIScale2 = UIScale

        if UIScale2 ~= nil then
            UIScale2:Destroy()
        end

        UIScale = nil

        local v61 = p15:WaitForChild("Head", 5)

        if not v61 then
            return nil
        end

        local Humanoid = p15:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        end

        local BillboardGui = Instance.new("BillboardGui")

        BillboardGui.Name = "PlayerTitleNameplate"
        BillboardGui.Size = v1
        BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 2.55, 0)
        BillboardGui.AlwaysOnTop = true
        BillboardGui.MaxDistance = 200
        BillboardGui.Adornee = v61
        BillboardGui.Enabled = not p9._secretFrostwyrmActive
        BillboardGui.Parent = v61
        p9._billboards[BillboardGui] = true
        v34:GiveTask(function() -- line: 395
            -- upvalues: BillboardGui (copy), p9 (copy)
            local _billboards = p9._billboards
            local v62 = _billboards[BillboardGui] ~= nil

            _billboards[BillboardGui] = nil

            return v62
        end)
        v34:GiveTask(BillboardGui)

        local UIListLayout = Instance.new("UIListLayout")

        UIListLayout.FillDirection = Enum.FillDirection.Vertical
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Parent = BillboardGui

        local TextLabel2 = Instance.new("TextLabel")

        TextLabel2.Size = UDim2.fromScale(1, 0.24)
        TextLabel2.BackgroundTransparency = 1
        TextLabel2.Font = Enum.Font.GothamBlack
        TextLabel2.TextScaled = true
        TextLabel2.TextStrokeTransparency = 0
        TextLabel2.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        TextLabel2.Text = ""
        TextLabel2.Visible = false
        TextLabel2.LayoutOrder = 0
        TextLabel2.Parent = BillboardGui
        TextLabel = TextLabel2

        local function v63(p16, p17, p18, p19, p20, p21) -- line: 422
            -- upvalues: BillboardGui (copy), p9 (copy), v34 (copy)
            local TextLabel = Instance.new("TextLabel")

            TextLabel.Size = UDim2.fromScale(p20, 0.4)
            TextLabel.BackgroundTransparency = 1
            TextLabel.Font = Enum.Font.GothamBlack
            TextLabel.TextScaled = true
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextStrokeTransparency = 0
            TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            TextLabel.Text = ""
            TextLabel.Visible = false
            TextLabel.LayoutOrder = p16
            TextLabel.ZIndex = 3
            TextLabel.Parent = BillboardGui

            local Frame = Instance.new("Frame")

            Frame.AnchorPoint = Vector2.new(0.5, 0.5)
            Frame.BackgroundColor3 = p19
            Frame.BackgroundTransparency = 0.04
            Frame.Position = UDim2.fromScale(0.5, 0.5)
            Frame.Size = UDim2.fromScale(1.12, 0.84)
            Frame.ZIndex = 1
            Frame.Parent = TextLabel

            local UICorner = Instance.new("UICorner")

            UICorner.CornerRadius = UDim.new(0.16, 0)
            UICorner.Parent = Frame

            local UIStroke = Instance.new("UIStroke")

            UIStroke.Color = p21
            UIStroke.Thickness = 2.25
            UIStroke.Transparency = 0.08
            UIStroke.Parent = Frame

            local UIGradient = Instance.new("UIGradient")

            UIGradient.Color = p17
            UIGradient.Rotation = 10
            UIGradient.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.45),
                NumberSequenceKeypoint.new(0.5, 0.72),
                NumberSequenceKeypoint.new(1, 0.45)
            })
            UIGradient.Parent = Frame

            local UIGradient2 = Instance.new("UIGradient")

            UIGradient2.Color = p17
            UIGradient2.Rotation = 8
            UIGradient2.Parent = TextLabel

            local UIScale = Instance.new("UIScale")

            UIScale.Scale = 1
            UIScale.Parent = TextLabel
            p9._prestigeRankEffects[TextLabel] = {
                baseAccentColor = p21,
                gradient = UIGradient2,
                phase = p18,
                plaqueBorder = UIStroke,
                scale = UIScale
            }
            v34:GiveTask(function() -- line: 473
                -- upvalues: TextLabel (copy), p9 (copy)
                local _prestigeRankEffects = p9._prestigeRankEffects
                local v64 = _prestigeRankEffects[TextLabel] ~= nil

                _prestigeRankEffects[TextLabel] = nil

                return v64
            end)

            local UIStroke2 = Instance.new("UIStroke")

            UIStroke2.Color = Color3.fromRGB(0, 0, 0)
            UIStroke2.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
            UIStroke2.Thickness = 0.1
            UIStroke2.Transparency = 0
            UIStroke2.Parent = TextLabel
            v34:GiveTask(UIStroke2)
            v34:GiveTask(Frame)
            v34:GiveTask(UIGradient2)
            v34:GiveTask(UIScale)
            v34:GiveTask(TextLabel)

            return TextLabel
        end

        v37 = v63(-2, v2, 0, Color3.fromRGB(83, 45, 4), 0.94, Color3.fromRGB(255, 197, 45))
        v38 = v63(-1, v3, 3.141592653589793, Color3.fromRGB(54, 12, 72), 1.36, Color3.fromRGB(255, 91, 203))

        local UIStroke = Instance.new("UIStroke")

        UIStroke.Color = Color3.fromRGB(0, 0, 0)
        UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        UIStroke.Thickness = 0.1
        UIStroke.Transparency = 0
        UIStroke.Parent = TextLabel2
        v34:GiveTask(UIStroke)

        local TextLabel3 = Instance.new("TextLabel")

        TextLabel3.Size = UDim2.fromScale(1, 0.18)
        TextLabel3.BackgroundTransparency = 1
        TextLabel3.Font = Enum.Font.GothamBold
        TextLabel3.TextScaled = true
        TextLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel3.TextStrokeTransparency = 0
        TextLabel3.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        TextLabel3.Text = p10.DisplayName
        TextLabel3.LayoutOrder = 1
        TextLabel3.Parent = BillboardGui
        v34:GiveTask(TextLabel3)

        local UIStroke2 = Instance.new("UIStroke")

        UIStroke2.Color = Color3.fromRGB(0, 0, 0)
        UIStroke2.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
        UIStroke2.Thickness = 0.035
        UIStroke2.Transparency = 0
        UIStroke2.Parent = TextLabel3
        v34:GiveTask(UIStroke2)
        v58(selectPlayerEquippedTitle(v36)(v35:getState()))
        v51()
    end

    if p10.Character then
        v60(p10.Character)
    end

    v34:GiveTask(p10.CharacterAdded:Connect(function(p22) -- line: 528
        -- upvalues: v60 (copy)
        return v60(p22)
    end))
    v34:GiveTask(v35:subscribe(selectPlayerEquippedTitle(v36), function(p23) -- line: 531
        -- upvalues: v58 (copy)
        v58(p23)
    end))
    v34:GiveTask(v35:subscribe(function(p24) -- line: 534
        return p24.leaderboard.money
    end, function() -- line: 536
        -- upvalues: v51 (copy)
        return v51()
    end))
    v34:GiveTask(v35:subscribe(function(p25) -- line: 539
        return p25.leaderboard.power
    end, function() -- line: 541
        -- upvalues: v51 (copy)
        return v51()
    end))
end

Reflect.defineMetadata(self, "identifier", "client/controllers/title-nameplate-controller@TitleNameplateController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/reflex-controller@ReflexController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnRender" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    TitleNameplateController = self
}
