-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local mountFishData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "mount-fish").mountFishData
local default = RuntimeLib.import(script, script.Parent, "mount-card").default

return {
    default = function(p1) -- MountsTab | line: 12
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), mountFishData (copy), default (copy)
        local t1 = {}

        for _, v1 in mountFishData do
            table.insert(t1, v1)
        end

        local v2 = #t1 > 0
        local v3 = useRef()
        local v4, v5 = useState(0)

        useEffect(function() -- line: 25
            -- upvalues: v3 (copy), v5 (copy)
            local current = v3.current

            if current == nil then
                return nil
            end

            local function v6() -- line: 30
                -- upvalues: current (copy), v5 (copy)
                return v5(current.AbsoluteSize.Y)
            end

            v5(current.AbsoluteSize.Y)

            local connection = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(v6)

            return function() -- line: 35
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, {})

        local v7

        if not v2 then
            v7 = react.createElement("textlabel", {
                BackgroundTransparency = 1,
                Text = "No Mounts Available",
                TextScaled = true,
                TextWrapped = true,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Font = Enum.Font.GothamBold,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.8, 0.22),
                TextColor3 = Color3.fromRGB(225, 233, 242)
            })

            return react.createElement("frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1)
            }, v7)
        end

        local v8 = react.createElement("uipadding", {
            PaddingLeft = UDim.new(0.02, 0),
            PaddingRight = UDim.new(0.02, 0)
        })
        local v9 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0.025, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        })
        local v10 = table.create(#t1)

        local function v11(p2, p3) -- line: 53
            -- upvalues: p1 (copy), v4 (copy), react (copy), default (copy)
            local t2 = {
                data = p2,
                isActive = p1.activeMountName == p2.itemName,
                layoutOrder = p3,
                onBuy = function() -- onBuy | line: 58
                    -- upvalues: p2 (copy), p1 (copy)
                    return p1.onBuy(p2.itemName)
                end,
                onEquip = function() -- onEquip | line: 61
                    -- upvalues: p2 (copy), p1 (copy)
                    return p1.onEquip(p2.itemName)
                end,
                onPreview = function() -- onPreview | line: 64
                    -- upvalues: p2 (copy), p1 (copy)
                    return p1.onPreview(p2.itemName)
                end
            }
            local ownedMountNames = p1.ownedMountNames
            local itemName = p2.itemName

            t2.owned = table.find(ownedMountNames, itemName) ~= nil

            return react.createElement("frame", {
                BackgroundTransparency = 1,
                key = p2.itemName,
                LayoutOrder = p3,
                Size = UDim2.new(0, v4, 0, v4)
            }, react.createElement(default, t2))
        end

        for v12, v13 in t1 do
            v10[v12] = v11(v13, v12 - 1, t1)
        end

        v7 = react.createElement("scrollingframe", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            ScrollBarThickness = 4,
            AutomaticCanvasSize = Enum.AutomaticSize.X,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Position = UDim2.fromScale(0, 0),
            ScrollBarImageColor3 = Color3.fromRGB(97, 211, 232),
            ScrollingDirection = Enum.ScrollingDirection.X,
            Size = UDim2.fromScale(1, 1),
            ref = v3
        }, v8, v9, v10)

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1)
        }, v7)
    end
}
