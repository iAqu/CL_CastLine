local ServerStorage = game:GetService("ServerStorage")

local PlotFenceGeometry = {}
local GEOMETRY_FOLDER = "StyleGeometry"
local PANEL_WIDTH = 9
local BAY_LENGTH = 11

local function getStyle(key)
	local styles = ServerStorage:FindFirstChild("PlotFenceStyles")
	return typeof(key) == "string" and styles and styles:FindFirstChild(key)
end

function PlotFenceGeometry.HasStyle(key)
	if key == "Wood" then
		return true
	end
	local style = getStyle(key)
	for _, name in { "Panel", "Post", "CornerPost", "EntrancePost" } do
		local model = style and style:FindFirstChild(name)
		if not model or not model:IsA("Model") or not model:FindFirstChildWhichIsA("BasePart") then
			return false
		end
	end
	return true
end

function PlotFenceGeometry.IsGenerated(part)
	return part:FindFirstAncestor(GEOMETRY_FOLDER) ~= nil
end

local function withX(position, x)
	return Vector3.new(x, position.Y, position.Z)
end

local function fitPart(part, frame, width)
	local position = frame.Position
	local ratio = width / PANEL_WIDTH
	local fit = part:GetAttribute("FenceFit")
	if fit == "Stretch" then
		local half = frame.RightVector * part.Size.X * 0.5
		local a, b = position - half, position + half
		a, b = withX(a, a.X * ratio), withX(b, b.X * ratio)
		local delta = b - a
		local direction = delta.Unit
		part.Size = withX(part.Size, delta.Magnitude)
		local midpoint = (a + b) * 0.5
		local targetTop = part:GetAttribute("FenceFitTop")
		if typeof(targetTop) == "number" then
			-- A diagonal changes angle as it spans wider bays.
			local top = math.max(a.Y, b.Y) + math.abs(direction.X) * part.Size.Y * 0.5
			midpoint += Vector3.new(0, targetTop - top, 0)
		end
		return CFrame.fromMatrix(midpoint, direction, Vector3.new(-direction.Y, direction.X, 0))
	elseif fit == "LeftLink" or fit == "RightLink" then
		local sign = if fit == "LeftLink" then -1 else 1
		local fixed = 2 * position.X - sign * PANEL_WIDTH * 0.5
		local edge = sign * width * 0.5
		part.Size = withX(part.Size, math.abs(edge - fixed))
		return CFrame.new(withX(position, (edge + fixed) * 0.5))
	end
	local anchor = part:GetAttribute("FenceFitAnchorX") or 0
	return frame + Vector3.new(anchor * (ratio - 1), 0, 0)
end

local function place(template, parent, frame, width, corner)
	local pivot = template:GetPivot()
	for _, source in template:GetChildren() do
		if source:IsA("BasePart") then
			local part = source:Clone()
			local offset = pivot:ToObjectSpace(source.CFrame)
			part.CFrame = frame * (if width then fitPart(part, offset, width) else offset)
			part:SetAttribute("FenceCorner", if corner and part:GetAttribute("SparkleAnchor") then true else nil)
			part.Parent = parent
		end
	end
end

local function getPosts(group)
	local posts = {}
	for _, part in group.Posts:GetDescendants() do
		if part:IsA("BasePart") and not part:GetAttribute("ExtensionPost") then
			table.insert(posts, part)
		end
	end
	return posts
end

local function findCorner(posts, side)
	for _, post in posts do
		if post:GetAttribute("FenceCorner") and post:GetAttribute("LayoutMode") == side then
			return post
		end
	end
end

local function bottom(post)
	return (post.CFrame * CFrame.new(0, -post.Size.Y * 0.5, 0)).Position
end

local function placeSide(style, folder, posts, sortDirection, up)
	table.sort(posts, function(a, b)
		return a.Position:Dot(sortDirection) < b.Position:Dot(sortDirection)
	end)
	for index = 2, #posts do
		local first, second = bottom(posts[index - 1]), bottom(posts[index])
		local direction = (second - first).Unit
		local distance = (second - first).Magnitude
		local bays = math.max(1, math.round(distance / BAY_LENGTH))
		local step = distance / bays
		for bay = 1, bays do
			local center = first + direction * ((bay - 0.5) * step)
			place(style.Panel, folder, CFrame.fromMatrix(center, direction, up), step - 1)
			if bay < bays then
				local position = first + direction * (bay * step)
				place(style.Post, folder, CFrame.fromMatrix(position, direction, up))
			end
		end
	end
end

function PlotFenceGeometry.Build(plot, key)
	local geometry = {}
	if key == "Wood" then
		return geometry
	end
	local style = assert(getStyle(key))
	local ground = plot.Ground.CFrame
	local right, back, up = ground.RightVector, -ground.LookVector, ground.UpVector
	local fence = plot.Fence
	local postsByGroup = {}
	for _, group in fence:GetChildren() do
		if group:IsA("Model") and group:FindFirstChild("Posts") then
			local folder = Instance.new("Folder")
			folder.Name = GEOMETRY_FOLDER
			geometry[group] = folder
			local posts = getPosts(group)
			postsByGroup[group.Name] = posts
			local ordinary = if group.Name == "Entrance" then style.EntrancePost else style.Post
			for _, post in posts do
				local corner = post:GetAttribute("FenceCorner")
				local model = if corner then style.CornerPost else ordinary
				place(model, folder, CFrame.fromMatrix(bottom(post), right, up), nil, corner)
			end
		end
	end

	local entrance = postsByGroup.Entrance
	table.sort(entrance, function(a, b)
		return a.Position:Dot(right) < b.Position:Dot(right)
	end)
	local frontLeft, frontRight = postsByGroup.FrontLeft, postsByGroup.FrontRight
	local rear = postsByGroup.Back
	assert(#entrance == 2, "Expected two fence entrance posts")
	table.insert(frontLeft, entrance[1])
	table.insert(frontRight, entrance[2])
	local frontLeftCorner, backLeftCorner = findCorner(frontLeft, "MoveLeft"), findCorner(rear, "MoveLeft")
	local frontRightCorner, backRightCorner = findCorner(frontRight, "MoveRight"), findCorner(rear, "MoveRight")
	assert(frontLeftCorner and backLeftCorner and frontRightCorner and backRightCorner, "Missing fence corner")
	table.insert(postsByGroup.Left, frontLeftCorner)
	table.insert(postsByGroup.Left, backLeftCorner)
	table.insert(postsByGroup.Right, frontRightCorner)
	table.insert(postsByGroup.Right, backRightCorner)
	for side, direction in { FrontLeft = right, FrontRight = right, Right = back, Back = -right, Left = -back } do
		placeSide(style, geometry[fence[side]], postsByGroup[side], direction, up)
	end
	return geometry
end

function PlotFenceGeometry.Apply(plot, key, geometry)
	local useOriginal = key == "Wood"
	for _, group in plot.Fence:GetChildren() do
		local previous = group:FindFirstChild(GEOMETRY_FOLDER)
		if previous then
			previous:Destroy()
		end
		for _, part in group:GetDescendants() do
			if part:IsA("BasePart") then
				local transparency = part:GetAttribute("FenceBaseTransparency")
				local canQuery = part:GetAttribute("FenceBaseCanQuery")
				if transparency == nil then
					transparency = part.Transparency
					canQuery = part.CanQuery
					part:SetAttribute("FenceBaseTransparency", transparency)
					part:SetAttribute("FenceBaseCanQuery", canQuery)
				end
				part.Transparency = if useOriginal then transparency else 1
				part.CanQuery = useOriginal and canQuery
			end
		end
		local replacement = geometry[group]
		if replacement then
			replacement.Parent = group
		end
	end
end

return PlotFenceGeometry
