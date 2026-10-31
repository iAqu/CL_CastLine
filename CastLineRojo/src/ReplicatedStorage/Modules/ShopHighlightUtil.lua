local ShopHighlightUtil = {}

ShopHighlightUtil.FILL_TRANSPARENCY = 0.6

function ShopHighlightUtil.Apply(highlight: Highlight, adornee: Instance)
	highlight.Adornee = adornee
	highlight.FillColor = Color3.new(1, 1, 1)
	highlight.FillTransparency = ShopHighlightUtil.FILL_TRANSPARENCY
	highlight.OutlineColor = Color3.new(1, 1, 1)
	highlight.OutlineTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.Occluded
end

return ShopHighlightUtil
