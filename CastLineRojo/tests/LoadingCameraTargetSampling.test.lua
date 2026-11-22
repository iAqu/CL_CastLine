local file = assert(io.open("src/ReplicatedFirst/LoadingScreen.client.lua", "r"))
local source = file:read("*a")
file:close()

local first = assert(source:find("local function animateEntryCamera(", 1, true))
local last = assert(source:find("local function playEntryCamera(", first, true))
local loadAnimation = assert(loadstring(source:sub(first, last - 1) .. "\nreturn animateEntryCamera"))

local vectorOps = {}
local function vector(x, y, z)
	return setmetatable({ X = x, Y = y, Z = z, Magnitude = math.sqrt(x * x + y * y + z * z) }, vectorOps)
end
function vectorOps.__add(a, b)
	return vector(a.X + b.X, a.Y + b.Y, a.Z + b.Z)
end
function vectorOps.__mul(v, n)
	return vector(v.X * n, v.Y * n, v.Z * n)
end
vectorOps.__index = {
	Lerp = function(a, b, alpha)
		return a * (1 - alpha) + b * alpha
	end,
}
local frameOps = {}
local function cframe(position, angle)
	return setmetatable({
		Position = position,
		Rotation = {
			Value = angle or 0,
			Lerp = function(a, b, alpha)
				return { Value = a.Value + (b.Value - a.Value) * alpha }
			end,
		},
	}, frameOps)
end
function frameOps.__mul(frame, rotation)
	return cframe(frame.Position, rotation.Value)
end
frameOps.__index = {
	Lerp = function(a, b, alpha)
		return cframe(a.Position:Lerp(b.Position, alpha))
	end,
}

local cameraPriority = 200
local bindings = {}
local runService = { RenderStepped = { Wait = coroutine.yield } }
function runService:BindToRenderStep(name, priority, callback)
	bindings[name] = { priority = priority, callback = callback }
end
function runService:UnbindFromRenderStep(name)
	bindings[name] = nil
end
local cameraTypes = { Scriptable = "Scriptable", Custom = "Custom" }
local start = cframe(vector(0, 50, 0), 0)
local seed = cframe(vector(15, 5, 0), 100)
local seedFocus = cframe(vector(0, 0, 0))
local camera = { CFrame = start, Focus = start, FieldOfView = 45, CameraType = cameraTypes.Scriptable }
setfenv(loadAnimation, setmetatable({
	CFrame = { new = cframe },
	Vector3 = { new = vector, yAxis = vector(0, 1, 0) },
	Enum = {
		CameraType = cameraTypes,
		RenderPriority = { Camera = { Value = cameraPriority } },
		EasingStyle = { Sine = "Sine" },
		EasingDirection = { InOut = "InOut" },
	},
	TweenService = { GetValue = function(_, alpha) return alpha end },
	RunService = runService,
	Workspace = { CurrentCamera = camera },
	ENTRY_CAMERA_DEFAULT_STATE_BINDING_NAME = "Prepare",
	ENTRY_CAMERA_BINDING_NAME = "Animate",
	ENTRY_CAMERA_DURATION_SECONDS = 1.25,
	ENTRY_CAMERA_MIN_ARC_HEIGHT = 4,
	ENTRY_CAMERA_MAX_ARC_HEIGHT = 10,
}, { __index = getfenv() }))

local animate = loadAnimation()
local humanoid = {}
local request = coroutine.create(function()
	animate(camera, humanoid, seed, seedFocus, 70)
end)
local function close(a, b)
	return math.abs(a - b) < 1e-6
end

assert(coroutine.resume(request))
assert(camera.CFrame == start and camera.Focus == start and camera.FieldOfView == 45,
	"Taking control of the default camera must leave the Loading pose visible")
assert(bindings.Prepare and bindings.Prepare.priority < cameraPriority, "Prepare before Roblox updates its camera")
assert(bindings.Animate and bindings.Animate.priority > cameraPriority, "Compute the visible arc after Roblox updates its camera")

local defaultPose, defaultFocus, defaultFov = seed, seedFocus, 70
for frame = 1, 5 do
	bindings.Prepare.callback()
	assert(camera.CameraType == cameraTypes.Custom and camera.CameraSubject == humanoid,
		"PlayerModule must keep ownership for the whole transition")
	assert(camera.CFrame == defaultPose and camera.Focus == defaultFocus and camera.FieldOfView == defaultFov,
		"Feed PlayerModule its previous raw result each frame")
	defaultPose = cframe(vector(15 + 2 * frame, 5, 0), 100 + frame)
	defaultFocus = cframe(vector(0, frame, 0))
	defaultFov = 65 + frame
	camera.CFrame, camera.Focus, camera.FieldOfView = defaultPose, defaultFocus, defaultFov
	bindings.Animate.callback(0.25)
	local visiblePose = camera.CFrame
	local alpha = frame / 5
	if frame < 5 then
		assert(visiblePose ~= defaultPose and close(visiblePose.Position.X, defaultPose.Position.X * alpha),
			"Blend toward the current default camera distance while descending")
		assert(close(visiblePose.Position.Y, 50 * (1 - alpha) + 5 * alpha + 8 * alpha * (1 - alpha)),
			"Keep the vertical arc during the pullback")
		assert(close(visiblePose.Rotation.Value, defaultPose.Rotation.Value * alpha)
			and close(camera.FieldOfView, 45 + (defaultFov - 45) * alpha)
			and close(camera.Focus.Position.Y, 50 * (1 - alpha) + frame * alpha),
			"Interpolate rotation, field of view, and focus as part of the arc")
	else
		assert(visiblePose == defaultPose and camera.Focus == defaultFocus and camera.FieldOfView == defaultFov,
			"The terminal frame must be PlayerModule's current result")
	end

	-- Studio resumes RenderStepped waiters after the bound callbacks.
	local ok, err = coroutine.resume(request)
	assert(ok, tostring(err))
	assert(camera.CFrame == visiblePose, "A render waiter must not expose the unblended camera")
end
assert(camera.CameraType == cameraTypes.Custom and coroutine.status(request) == "dead" and next(bindings) == nil,
	"Leave the default camera running and remove both wrappers at the end")
