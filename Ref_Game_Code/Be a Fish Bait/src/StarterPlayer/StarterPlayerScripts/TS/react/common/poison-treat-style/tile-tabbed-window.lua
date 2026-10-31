-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent, "tile-window").default
local default2 = RuntimeLib.import(script, script.Parent, "tile-button").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme
local useScreenSize = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-screen-size").useScreenSize
local default3 = RuntimeLib.import(script, script.Parent.Parent, "styled-text-label").default

return {
    default = function(p1) -- TileTabbedWindow | line: 10
        -- upvalues: react (copy), default (copy), default2 (copy), useTheme (copy), useScreenSize (copy), default3 (copy)
        useTheme()

        local v1 = useScreenSize()
        local v2 = v1:map(function(p2) -- line: 13
            if p2 == "sm" then
                return 2
            end

            if p2 == "md" then
                return 3
            end

            return 4
        end)
        local v3 = v1:map(function(p3) -- line: 16
            if p3 == "sm" then
                return 14
            end

            if p3 == "md" then
                return 22
            end

            return 28
        end)
        local v4

        for v5, v6 in p1.navItems do
            local _ = v5 - 1

            if v6.index == p1.currentPage == true then
                v4 = v6
                break
            end

            v4 = nil
        end

        local pageContent, currentPage = p1.pageContent, p1.currentPage

        if currentPage == nil then
            currentPage = p1.defaultPage
        end

        local v7 = pageContent[currentPage]

        if v4 == nil then
            warn("[src/client/react/common/poison-treat-style/tile-tabbed-window.tsx:48]", "Current nav item is undefined")

            return nil
        end

        local v8 = react.createElement("uiaspectratioconstraint", {
            AspectRatio = 1.35
        })
        local v9 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Top,
            VerticalFlex = Enum.UIFlexAlignment.SpaceEvenly
        })
        local navItems = p1.navItems
        local v10 = table.create(#navItems)

        local function v11(p4) -- line: 57
            -- upvalues: p1 (copy), v2 (copy), v3 (copy), react (copy), default2 (copy), default3 (copy)
            return react.createElement(default2, {
                uiAspectRatio = 1,
                borderColor = p4.borderColor,
                colorSequence = p4.backgroundColor,
                disabled = p4.disabled,
                key = p4.index,
                layoutOrder = p4.index,
                onClick = function() -- onClick | line: 64
                    -- upvalues: p4 (copy), p1 (copy)
                    if p4.disabled then
                        return nil
                    end

                    local onPageChange = p1.onPageChange

                    if onPageChange ~= nil then
                        onPageChange(p4.index)
                    end
                end,
                size = UDim2.fromScale(0.8, 0.25)
            }, react.createElement("imagelabel", {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0.5, 0),
                Image = p4.imageId,
                Position = UDim2.fromScale(0.5, 0.025),
                Size = UDim2.fromScale(0.7, 0.7)
            }, react.createElement("uiaspectratioconstraint", {
                AspectRatio = 1
            })), react.createElement(default3, {
                overrideProps = {
                    BackgroundTransparency = 1,
                    TextScaled = true,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.fromScale(0.5, 0.45),
                    Size = UDim2.fromScale(1, 0.7),
                    Text = p4.title,
                    TextXAlignment = Enum.TextXAlignment.Center
                },
                strokeProps = {
                    Color = Color3.new(0, 0, 0),
                    Thickness = v2
                },
                text = p4.title
            }, react.createElement("uitextsizeconstraint", {
                MaxTextSize = v3
            })))
        end

        for v12, v13 in navItems do
            v10[v12] = v11(v13, v12 - 1, navItems)
        end

        local v14 = react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0, 0),
            Position = UDim2.fromScale(0.1, 0.2),
            Size = UDim2.fromScale(0.2, 0.8)
        }, v9, v10)
        local t2 = {
            aspectRatio = p1.aspectRatio,
            bodyColorSequence = p1.bodyColorSequence
        }
        local headerColor = p1.headerColor

        t2.headerColor = headerColor ~= nil and headerColor
        t2.headerColorSequence = v4.backgroundColor
        t2.imageId = if v4 == nil then v4 else v4.imageId
        t2.onClose = p1.onClose
        t2.size = UDim2.fromScale(1, 1)

        if v4 ~= nil then
            v4 = v4.title
        end

        t2.title = if v4 == nil then p1.title else v4

        return react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.475, 0.5),
            Size = UDim2.fromScale(0.6, 0.7)
        }, v8, v14, react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.fromScale(1, 0.5),
            Size = UDim2.fromScale(0.7, 1)
        }, react.createElement(default, t2, v7)))
    end
}
