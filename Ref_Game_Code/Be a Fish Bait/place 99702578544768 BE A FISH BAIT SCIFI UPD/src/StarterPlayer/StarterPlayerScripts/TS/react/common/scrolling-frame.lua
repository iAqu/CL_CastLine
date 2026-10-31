-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local forwardRef = react.forwardRef
local GridLayout = RuntimeLib.import(script, script.Parent, "grid-layout").GridLayout
local Padding = RuntimeLib.import(script, script.Parent, "padding").Padding

local function calculateCanvasSize(p1, p2, _, p4, p5) -- line: 8
    if p1 == Enum.FillDirection.Horizontal then
        return (UDim2.new(0, 0, p2.Y.Scale * (p4 / p5), p2.Y.Offset * (p4 / p5) - 1))
    end

    return (UDim2.new(p2.X.Scale * (p4 / p5), p2.X.Offset * (p4 / p5) - 1, 0, 0))
end

return {
    calculateCanvasSize = calculateCanvasSize,
    default = forwardRef(function(p6, p7) -- line: 14
        -- upvalues: react (copy), GridLayout (copy), Padding (copy), calculateCanvasSize (copy)
        local v1 = p6.horizontalScrollBarInset or Enum.ScrollBarInset.ScrollBar
        local v2 = p6.verticalScrollBarInset or Enum.ScrollBarInset.ScrollBar
        local v3 = p6.verticalScrollBarPosition or Enum.VerticalScrollBarPosition.Right
        local slotBorderThicknessToAccountFor = p6.slotBorderThicknessToAccountFor

        if slotBorderThicknessToAccountFor == nil then
            slotBorderThicknessToAccountFor = 0
        end

        local listPaddingOffset = p6.listPaddingOffset

        if listPaddingOffset == nil then
            listPaddingOffset = 0
        end

        local v4 = p6.listPaddingScale or Vector2.new(0, 0)
        local cellsPerRow, rowsToBeVisible = p6.cellsPerRow, p6.rowsToBeVisible

        if rowsToBeVisible == nil then
            rowsToBeVisible = 1
        end

        local size = p6.size
        local v7 = math.max(rowsToBeVisible, (math.ceil(react.Children.count(p6.children) / cellsPerRow)))
        local v8 = calculateCanvasSize(p6.fillDirection, size, cellsPerRow, v7, rowsToBeVisible)
        local t1 = {}
        local padding = p6.padding

        if padding then
            for v9, v10 in padding do
                t1[v9] = v10
            end
        end

        return react.createElement("scrollingframe", {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = p6.anchorPoint,
            CanvasPosition = p6.canvasPosition,
            CanvasSize = v8,
            Change = p6.changed,
            ClipsDescendants = p6.clipsDescendants,
            HorizontalScrollBarInset = v1,
            Position = p6.position,
            ScrollBarImageColor3 = p6.scrollBarColor,
            ScrollBarThickness = p6.scrollBarThickness,
            ScrollingDirection = if p6.fillDirection == Enum.FillDirection.Horizontal then Enum.ScrollingDirection.Y else Enum.ScrollingDirection.X,
            Size = size,
            VerticalScrollBarInset = v2,
            VerticalScrollBarPosition = v3,
            ZIndex = p6.zIndex,
            ref = p7
        }, react.createElement(Padding, t1, react.createElement("frame", {
            BackgroundTransparency = 1,
            AnchorPoint = if p6.fillDirection == Enum.FillDirection.Horizontal then Vector2.new(0, 0.5) else Vector2.new(0.5, 0),
            Position = if p6.fillDirection == Enum.FillDirection.Horizontal then UDim2.new(0, slotBorderThicknessToAccountFor, 0.5, 0) else UDim2.new(0.5, 0, 0, slotBorderThicknessToAccountFor),
            Size = if p6.fillDirection == Enum.FillDirection.Horizontal then UDim2.new(1, -slotBorderThicknessToAccountFor, 1, -slotBorderThicknessToAccountFor * 2) else UDim2.new(1, -slotBorderThicknessToAccountFor * 2, 1, -slotBorderThicknessToAccountFor)
        }, react.createElement(GridLayout, {
            cellsPerRow = cellsPerRow,
            fillDirection = p6.fillDirection,
            horizontalAlignment = p6.horizontalAlignment,
            rowsToAccountFor = v7,
            slotBorderThicknessToAccountFor = slotBorderThicknessToAccountFor,
            slotListPaddingOffset = listPaddingOffset,
            slotListPaddingScale = v4,
            verticalAlignment = p6.verticalAlignment
        }), p6.children)))
    end)
}
