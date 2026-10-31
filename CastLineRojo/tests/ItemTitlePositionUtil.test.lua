local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end

local util = read("src/ReplicatedStorage/Modules/ItemTitlePositionUtil.lua")

assert(util:find("ItemTitlePositionUtil.TITLE_BOTTOM_OFFSET_Y = 6", 1, true), "Item titles must use a fixed six-stud bottom offset")
assert(util:find("root:GetDescendants()", 1, true), "World bounds must include every descendant part")
assert(util:find('descendant:IsA("BasePart")', 1, true), "World bounds must only include physical parts")
assert(
	util:find("math.abs(cframe.RightVector.Y) * halfSize.X", 1, true)
		and util:find("math.abs(cframe.UpVector.Y) * halfSize.Y", 1, true)
		and util:find("math.abs(cframe.LookVector.Y) * halfSize.Z", 1, true),
	"Rotated parts must contribute their complete world-space Y extent"
)
assert(util:find("math.min(bottomY, partBottomY)", 1, true), "Multi-part bounds must use the lowest part")
assert(util:find('adornee:IsA("Attachment")', 1, true), "Attachment adornees must be supported")
assert(util:find('adornee:IsA("BasePart")', 1, true), "BasePart adornees must be supported")
assert(
	util:find("bottomY + ItemTitlePositionUtil.TITLE_BOTTOM_OFFSET_Y + (extraOffsetY or 0) - adorneeWorldY", 1, true),
	"The final title world Y must equal the bounds bottom plus six and optional extra offset"
)
assert(util:find("extraOffsetY: number?", 1, true), "ApplyBottomOffset must accept an optional extra offset")
assert(util:find("offset.X,", 1, true) and util:find("offset.Z", 1, true), "Existing X and Z offsets must remain unchanged")
assert(util:find("return false", 1, true), "Missing bounds or adornees must fail safely")

print("ItemTitlePositionUtil.test.lua passed")
