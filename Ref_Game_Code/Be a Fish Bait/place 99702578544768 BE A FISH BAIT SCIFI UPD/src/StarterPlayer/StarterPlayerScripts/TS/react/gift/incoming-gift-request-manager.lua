-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "cyt-style", "rounded-frame").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "common", "styled-text-label").default
local default3 = RuntimeLib.import(script, script.Parent.Parent, "common", "cyt-style", "cyt-button").default
local getBorderThickness = RuntimeLib.import(script, script.Parent.Parent, "utils", "responsive-utils").getBorderThickness
local useScreenSizeState = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-screen-size").useScreenSizeState
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent, "hooks", "reflex").useRootSelector
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils").localPlayerUserId
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent, "network").functions
local default4 = RuntimeLib.import(script, script.Parent.Parent, "common", "transition", "transition").default
local useTransitionMotion = RuntimeLib.import(script, script.Parent.Parent, "common", "transition", "use-transition-motion").useTransitionMotion

local function GiftRequestCardTransitionContent(p1) -- line: 16
    -- upvalues: react (copy), Players (copy), default (copy), default2 (copy), default3 (copy), getBorderThickness (copy), useScreenSizeState (copy), functions (copy), useTransitionMotion (copy)
    local request = p1.request
    local v1 = useScreenSizeState()
    local v2 = tonumber(request.gifterUserId)

    if v2 == nil then
        v2 = -1
    end

    local PlayerByUserId = Players:GetPlayerByUserId(v2)

    if PlayerByUserId ~= nil then
        PlayerByUserId = PlayerByUserId.DisplayName
    end

    if PlayerByUserId == nil then
        PlayerByUserId = "Unknown"
    end

    local itemName = request.itemName

    local function v3() -- line: 35
        -- upvalues: request (copy), functions (copy)
        functions.acceptGiftRequest(request.requestId)
    end

    local function v4() -- line: 38
        -- upvalues: request (copy), functions (copy)
        functions.rejectGiftRequest(request.requestId)
    end

    local v5 = useTransitionMotion({
        whenIn = UDim2.fromScale(0, 0),
        whenOut = UDim2.fromScale(1.5, 0)
    }, {
        motionType = "spring",
        springOptions = {
            damping = 0.8,
            frequency = 0.15
        }
    })[1]

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Position = v5,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default, {
        backgroundTransparency = 0.2,
        cornerRadius = 12,
        anchorPoint = Vector2.new(0.5, 0.5),
        backgroundColor3 = Color3.fromRGB(30, 30, 40),
        borderColor3 = Color3.fromRGB(80, 80, 100),
        borderThickness = getBorderThickness(v1, "sm"),
        position = UDim2.fromScale(0.5, 0.5),
        size = UDim2.fromScale(1, 1)
    }, react.createElement(default2, {
        hasStroke = true,
        overrideProps = {
            ZIndex = 2,
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.05),
            Size = UDim2.fromScale(0.9, 0.2)
        },
        strokeProps = {
            Thickness = getBorderThickness(v1, "sm")
        },
        text = ("Gift from %*"):format(PlayerByUserId),
        textColor3 = Color3.fromRGB(255, 215, 100)
    }), react.createElement(default2, {
        hasStroke = true,
        overrideProps = {
            ZIndex = 2,
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0.28),
            Size = UDim2.fromScale(0.9, 0.25)
        },
        strokeProps = {
            Thickness = getBorderThickness(v1, "sm")
        },
        text = itemName,
        textColor3 = Color3.fromRGB(255, 255, 255)
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        ZIndex = 2,
        AnchorPoint = Vector2.new(0.5, 1),
        Position = UDim2.fromScale(0.5, 0.95),
        Size = UDim2.fromScale(0.95, 0.4)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0.03, 0),
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement(default3, {
        cornerRadius = 10,
        borderThickness = getBorderThickness(v1, "sm"),
        onClick = v3,
        size = UDim2.fromScale(0.45, 0.85)
    }, react.createElement(default, {
        cornerRadius = 10,
        anchorPoint = Vector2.new(0.5, 0.5),
        backgroundColor3 = Color3.fromRGB(80, 200, 80),
        borderColor3 = Color3.fromRGB(0, 0, 0),
        borderThickness = getBorderThickness(v1, "sm"),
        position = UDim2.fromScale(0.5, 0.5),
        size = UDim2.fromScale(1, 1)
    }, react.createElement("uigradient", {
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 255, 120)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 200, 80)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 150, 50))
        })
    }), react.createElement(default2, {
        hasStroke = true,
        text = "Accept",
        overrideProps = {
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.9, 0.7)
        },
        strokeProps = {
            Thickness = getBorderThickness(v1, "sm")
        },
        textColor3 = Color3.fromRGB(255, 255, 255)
    }))), react.createElement(default3, {
        cornerRadius = 10,
        borderThickness = getBorderThickness(v1, "sm"),
        onClick = v4,
        size = UDim2.fromScale(0.45, 0.85)
    }, react.createElement(default, {
        cornerRadius = 10,
        anchorPoint = Vector2.new(0.5, 0.5),
        backgroundColor3 = Color3.fromRGB(200, 80, 80),
        borderColor3 = Color3.fromRGB(0, 0, 0),
        borderThickness = getBorderThickness(v1, "sm"),
        position = UDim2.fromScale(0.5, 0.5),
        size = UDim2.fromScale(1, 1)
    }, react.createElement("uigradient", {
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 120, 120)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 80, 80)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 50, 50))
        })
    }), react.createElement(default2, {
        hasStroke = true,
        text = "Reject",
        overrideProps = {
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.9, 0.7)
        },
        strokeProps = {
            Thickness = getBorderThickness(v1, "sm")
        },
        textColor3 = Color3.fromRGB(255, 255, 255)
    }))))))
end

local function GiftRequestCard(p2) -- line: 164
    -- upvalues: react (copy), default4 (copy), GiftRequestCardTransitionContent (copy)
    return react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement(default4, {
        doEnterTransitionOnFirstMount = true,
        ["in"] = true
    }, react.createElement(GiftRequestCardTransitionContent, {
        request = p2.request
    })))
end

return {
    default = function(_) -- IncomingGiftRequestManager | line: 181
        -- upvalues: react (copy), useRootSelector (copy), localPlayerUserId (copy), GiftRequestCard (copy)
        local v6 = useRootSelector(function(p4) -- line: 182
            return p4.giftRequests
        end)
        local t1 = {}

        for _, v7 in v6 do
            if v7.receiverUserId == localPlayerUserId then
                table.insert(t1, v7)
            end
        end

        table.sort(t1, function(p5, p6) -- line: 193
            return p5.timestamp < p6.timestamp
        end)

        if #t1 == 0 then
            return nil
        end

        local v8 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom
        })
        local v9 = table.create(#t1)

        local function v10(p7) -- line: 208
            -- upvalues: react (copy), GiftRequestCard (copy)
            return react.createElement(GiftRequestCard, {
                key = p7.requestId,
                request = p7
            })
        end

        for v11, v12 in t1 do
            local _ = v11 - 1

            v9[v11] = react.createElement(GiftRequestCard, {
                key = v12.requestId,
                request = v12
            })
        end

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.fromScale(0.99, 0.85),
            Size = UDim2.fromScale(0.25, 0.25)
        }, v8, v9)
    end
}
