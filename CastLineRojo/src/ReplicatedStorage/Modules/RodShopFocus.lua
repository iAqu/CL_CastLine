local Focus = {}

function Focus.CanvasOffset(
	currentY: number,
	cardTop: number,
	cardHeight: number,
	windowTop: number,
	windowHeight: number,
	canvasHeight: number
): number
	local center = currentY + cardTop - windowTop + cardHeight / 2 - windowHeight / 2
	return math.clamp(center, 0, math.max(0, canvasHeight - windowHeight))
end

return Focus
