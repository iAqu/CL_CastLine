-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local react = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")

return {
    GridLayout = function(p1) -- GridLayout | line: 5
        -- upvalues: react (copy)
        local fillDirection, cellsPerRow, rowsToAccountFor, slotListPaddingOffset = p1.fillDirection, p1.cellsPerRow, p1.rowsToAccountFor, p1.slotListPaddingOffset
        local slotBorderThicknessToAccountFor, horizontalAlignment, verticalAlignment, slotListPaddingScale = p1.slotBorderThicknessToAccountFor, p1.horizontalAlignment, p1.verticalAlignment, p1.slotListPaddingScale
        local v1 = if fillDirection == Enum.FillDirection.Horizontal then 1 / cellsPerRow else 1 / rowsToAccountFor
        local v2 = if fillDirection == Enum.FillDirection.Horizontal then 1 / rowsToAccountFor else 1 / cellsPerRow

        if slotListPaddingOffset == nil then
            slotListPaddingOffset = 0
        end

        local v3 = slotListPaddingScale or Vector2.new(0, 0)
        local v4 = if fillDirection == Enum.FillDirection.Horizontal then UDim2.new(v1 - v3.X + v3.X / cellsPerRow, -slotListPaddingOffset + math.floor(slotListPaddingOffset / cellsPerRow) - slotBorderThicknessToAccountFor / cellsPerRow, v2 - v3.Y + v3.Y / rowsToAccountFor, -slotListPaddingOffset + math.floor(slotListPaddingOffset / rowsToAccountFor) - slotBorderThicknessToAccountFor / rowsToAccountFor) else UDim2.new(v1 - v3.X + v3.X / rowsToAccountFor, -slotListPaddingOffset + math.floor(slotListPaddingOffset / rowsToAccountFor) - slotBorderThicknessToAccountFor / rowsToAccountFor, v2 - v3.Y + v3.Y / cellsPerRow, -slotListPaddingOffset + math.floor(slotListPaddingOffset / cellsPerRow) - slotBorderThicknessToAccountFor / cellsPerRow)

        return react.createElement("uigridlayout", {
            CellPadding = UDim2.new(v3.X, slotListPaddingOffset, v3.Y, slotListPaddingOffset),
            CellSize = v4,
            FillDirection = fillDirection,
            FillDirectionMaxCells = cellsPerRow,
            HorizontalAlignment = horizontalAlignment,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = verticalAlignment
        })
    end
}
