local file = assert(io.open("src/ReplicatedFirst/LoadingScreen.client.lua", "r"))
local source = file:read("*a")
file:close()

local first = assert(source:find("local function sampleEntryCameraTarget(", 1, true))
local last = assert(source:find("local function handoffEntryCamera(", first, true))
local loadSample = assert(loadstring(source:sub(first, last - 1) .. "\nreturn sampleEntryCameraTarget"))

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
setfenv(loadSample, setmetatable({
	CFrame = { new = function(value) return value end },
	Enum = { CameraType = cameraTypes, RenderPriority = { Camera = { Value = cameraPriority } } },
	RunService = runService,
	LOADING_FOV = 45,
	ENTRY_CAMERA_DEFAULT_STATE_BINDING_NAME = "Prepare",
	ENTRY_CAMERA_TARGET_SAMPLE_BINDING_NAME = "Sample",
	ENTRY_CAMERA_TARGET_SAMPLE_FRAMES = 2,
}, { __index = getfenv() }))

local sampleEntryCameraTarget = loadSample()
local humanoid = {}
local camera = { CFrame = "Loading", Focus = "LoadingFocus", FieldOfView = 45, CameraType = cameraTypes.Scriptable }
local request = coroutine.create(function()
	return sampleEntryCameraTarget(camera, humanoid, "Seed", "SeedFocus", "Loading", "LoadingFocus", 70)
end)
local function assertLoadingView()
	assert(camera.CFrame == "Loading" and camera.Focus == "LoadingFocus" and camera.FieldOfView == 45,
		"The camera available for rendering must still show the Loading view")
end

assert(coroutine.resume(request))
assertLoadingView()
assert(bindings.Prepare and bindings.Prepare.priority < cameraPriority, "Prepare before Roblox updates its camera")
assert(bindings.Sample and bindings.Sample.priority > cameraPriority, "Capture after Roblox updates its camera")
for frame = 1, 2 do
	bindings.Prepare.callback()
	assert(camera.CameraType == cameraTypes.Custom and camera.CameraSubject == humanoid,
		"Roblox must calculate the target with the local humanoid")
	assert(camera.CFrame == (if frame == 1 then "Seed" else "Default1"),
		"Initialize on the first frame and feed Roblox its previous output on the next")
	camera.CFrame, camera.Focus, camera.FieldOfView = "Default" .. frame, "DefaultFocus" .. frame, 70 + frame
	bindings.Sample.callback()
	assertLoadingView()

	-- Studio resumes RenderStepped waiters after the bound callbacks.
	local ok, result, focus, fov = coroutine.resume(request)
	assert(ok, tostring(result))
	assertLoadingView()
	if frame == 2 then
		assert(result == "Default2" and focus == "DefaultFocus2" and fov == 72, "Return the default camera's final sample")
		assert(camera.CameraType == cameraTypes.Scriptable, "Return control to the entry animation")
	end
end
assert(coroutine.status(request) == "dead" and next(bindings) == nil, "Sampling must clean up its render bindings")
