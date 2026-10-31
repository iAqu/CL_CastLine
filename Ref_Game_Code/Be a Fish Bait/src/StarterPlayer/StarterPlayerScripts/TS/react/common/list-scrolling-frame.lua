-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local Padding = RuntimeLib.import(script, script.Parent, "padding").Padding

return {
    default = function(p1) -- ListScrollingFrame | line: 13
        -- upvalues: react (copy), Padding (copy)
        local itemPaddingScale = p1.itemPaddingScale

        if itemPaddingScale == nil then
            itemPaddingScale = 0
        end

        local v1 = p1.automaticCanvasSize == true
        local t1 = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = p1.anchorPoint
        }

        if v1 then
            t1.AutomaticCanvasSize = Enum.AutomaticSize.Y
            t1.CanvasSize = UDim2.fromScale(0, 0)
        else
            t1.AutomaticCanvasSize = Enum.AutomaticSize.None
            t1.CanvasSize = UDim2.fromScale(0, p1.canvasHeightScale)
        end

        local clipsDescendants = p1.clipsDescendants

        t1.ClipsDescendants = clipsDescendants == nil or clipsDescendants
        t1.Position = p1.position
        t1.ScrollBarImageColor3 = p1.scrollBarColor
        t1.ScrollBarThickness = p1.scrollBarThickness
        t1.ScrollingDirection = Enum.ScrollingDirection.Y
        t1.Size = p1.size
        t1.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
        t1.ZIndex = p1.zIndex
        t1.ref = p1.scrollFrameRef

        local t2 = {}
        local padding = p1.padding

        if padding then
            for v2, v3 in padding do
                t2[v2] = v3
            end
        end

        t2.overrideProps = {
            Size = UDim2.fromScale(1, if v1 then 1 else 1 / p1.canvasHeightScale)
        }

        return react.createElement("scrollingframe", t1, react.createElement(Padding, t2, react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = p1.horizontalAlignment or Enum.HorizontalAlignment.Center,
            Padding = UDim.new(itemPaddingScale, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = p1.verticalAlignment or Enum.VerticalAlignment.Top
        }), p1.children))
    end
}
