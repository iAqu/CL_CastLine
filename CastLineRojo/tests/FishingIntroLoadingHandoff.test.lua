local function read(path)
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return source
end
local loading = assert(load(read("src/ReplicatedFirst/LoadingAttributes.lua")))()
local source = read("src/ReplicatedFirst/LoadingScreen.client.lua")
local first = assert(source:find("local function restoreRuntimeState(", 1, true))
local last = assert(source:find("local function getLoadingTarget()", first, true))
local functions = source:sub(first, last - 1) .. "\nreturn { restore = restoreRuntimeState, handoff = handoffToIntro }"
local function fixture(initialState, prepare)
	local now, releases, objects = 0, {}, {}
	local attributes = { [loading.INTRO_STARTUP_STATE] = initialState }
	local camera = { CameraType = "Loading", FieldOfView = 45 }
	local player = { Parent = true, Character = {
		FindFirstChildOfClass = function() return {} end,
		FindFirstChild = function() return { Position = 100, CFrame = { LookVector = 1 } } end,
	} }
	function player:GetAttribute(name) return attributes[name] end
	function player:SetAttribute(name, value) attributes[name] = value end
	local environment = setmetatable({
		LoadingAttributes = loading,
		localPlayer = player,
		playerGui = {},
		runtimeRestored = false,
		getCurrentCamera = function() return camera end,
		originalFieldOfView = 70,
		originalPromptEnabled = true,
		ProximityPromptService = { Enabled = false },
		disconnectConnections = function() table.insert(releases, "camera") end,
		restoreCharacterAnchoring = function() table.insert(releases, "anchor") end,
		restoreLighting = function() table.insert(releases, "lighting") end,
		restoreOtherGuis = function() table.insert(releases, "gui") end,
		restoreSceneGuis = function()
			if releases[#releases] ~= "scene gui" then
				assert(objects[1] and not objects[1].destroyed, "Release scene UI under the intro cover")
				assert(not attributes[loading.LOADING_SCREEN_DONE], "Restore scene UI before signaling completion")
				table.insert(releases, "scene gui")
			end
		end,
		setCoreGuiEnabled = function() end,
		ENTRY_CAMERA_DISTANCE = 25,
		Enum = { CameraType = { Custom = "Custom" }, CoreGuiType = {} },
		CFrame = { lookAt = function() return "HomeFrame" end, new = function(value) return value end },
		Vector3 = { yAxis = 1 },
		UDim2 = { fromScale = function() return "Fullscreen" end },
		Color3 = { new = function() return "Black" end },
		Instance = { new = function(class)
			local object = { class = class, Destroy = function(self) self.destroyed = true end }
			table.insert(objects, object)
			return object
		end },
		os = { clock = function() return now end },
		warn = function() end,
		RunService = { RenderStepped = { Wait = function()
			now += 1
			if attributes[loading.INTRO_HANDOFF_READY] and prepare then
				assert(camera.CameraType == "Custom", "Loading must release its camera before intro captures it")
				assert(camera.FieldOfView == 70)
				assert(#releases == 4, "Loading must keep scene UI hidden until the intro is prepared")
				camera.CameraType, camera.FieldOfView = "Intro", 55
				attributes[loading.INTRO_STARTUP_STATE] = "Prepared"
			end
		end } },
	}, { __index = getfenv() })
	local operations = assert(load(functions, "Loading handoff", "t", environment))()
	return { ops = operations, player = player, camera = camera, attributes = attributes, releases = releases, objects = objects }
end

local ready = fixture("Preparing", true)
assert(ready.ops.handoff())
assert(ready.attributes[loading.LOADING_SCREEN_DONE] == true)
assert(ready.camera.CameraType == "Intro" and ready.camera.FieldOfView == 55,
	"Final loading cleanup must preserve intro camera ownership")
assert(#ready.releases == 5 and ready.releases[5] == "scene gui", "Scene UI restores at final completion")
assert(ready.objects[1].destroyed, "Cover must be removed after first-frame preparation")
ready.ops.restore()
assert(#ready.releases == 5 and ready.camera.CameraType == "Intro", "Repeated cleanup cannot override the intro")

local veteran = fixture("Skipped", false)
assert(not veteran.ops.handoff() and #veteran.objects == 0 and #veteran.releases == 0,
	"Veteran keeps the normal entry camera path")

local noController = fixture(nil, false)
assert(not noController.ops.handoff())
assert(noController.attributes[loading.INTRO_STARTUP_STATE] == "Skipped", "Missing startup state has a bounded wait")

local timedOut = fixture("Preparing", false)
assert(timedOut.ops.handoff())
assert(timedOut.attributes[loading.INTRO_STARTUP_STATE] == "Skipped")
assert(timedOut.attributes[loading.LOADING_SCREEN_DONE] == true and timedOut.objects[1].destroyed,
	"Preparation failure must release loading and its cover")
assert(timedOut.camera.CameraType == "Custom" and #timedOut.releases == 5)

local invalidCharacter = fixture("Preparing", false)
invalidCharacter.player.Character = nil
assert(invalidCharacter.ops.handoff())
assert(invalidCharacter.attributes[loading.INTRO_STARTUP_STATE] == "Skipped")
assert(invalidCharacter.attributes[loading.LOADING_SCREEN_DONE] == true and invalidCharacter.objects[1].destroyed,
	"An exception during handoff must clean up loading and the black cover")
assert(#invalidCharacter.releases == 5, "An exception must release scene UI")
