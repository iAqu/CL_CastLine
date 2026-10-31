# Build Fireworks Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Play Build A Bridge-style fireworks when build layers complete, using the reference Firework resource copied into `DB_DEV`.

**Architecture:** The Firework visual asset lives in Studio at `ReplicatedStorage.Assets.VFX.Firework` and is copied from the `Build A Bridge` Studio project through MCP. `BuildController` owns local playback because it already handles build reveal visuals and receives `FightService.BuildProgressEvent` delta payloads for both the local slot and other visible slots.

**Tech Stack:** Roblox Studio MCP, Rojo, Luau, Knit client controller, `TweenService`, `Debris`, `ReplicatedStorage` assets.

---

## File Structure

- Studio resource: create or replace `ReplicatedStorage.Assets.VFX.Firework` in `DB_DEV` by copying the complete instance tree from the `Build A Bridge` Studio project.
- Modify: `src/StarterPlayer/StarterPlayerScripts/Controllers/BuildController.lua`
  - Add Firework playback constants.
  - Add helper functions for template lookup, runtime container lookup, single firework playback, repeated firework playback, and scheduling from the final completed part.
  - Trigger the helper only from delta layer-completion payloads.
- Create: no repository asset file. The Firework resource is a Studio asset copied through MCP, not a Rojo-managed source file.

## Task 1: Copy Firework Resource Through MCP

**Files:**
- Studio Create/Modify: `DB_DEV.ReplicatedStorage.Assets.VFX.Firework`
- Reference: `Build A Bridge.ReplicatedStorage.Assets.VFX.Firework`

- [ ] **Step 1: Confirm connected Studios**

Use `user-Roblox_Studio.list_roblox_studios`.

Expected: one active or available Studio with name containing `DB_DEV`, and one available Studio with name containing `Build A Bridge`.

- [ ] **Step 2: Select the Build A Bridge reference Studio**

Use `user-Roblox_Studio.set_active_studio` with the Studio id whose name contains `Build A Bridge`.

Expected: active Studio becomes the reference project.

- [ ] **Step 3: Inspect the reference Firework resource**

Use `user-Roblox_Studio.inspect_instance` on:

`ReplicatedStorage.Assets.VFX.Firework`

Expected structure:

```text
Firework (Part)
  Fly (Sound)
  Explode (Sound)
  Attachment (Attachment)
    ParticleEmitter...
  Trail (Trail)
  A1 (Attachment)
  A2 (Attachment)
```

- [ ] **Step 4: Export the reference Firework tree**

Use `user-Roblox_Studio.execute_luau` in the reference Studio with this script. Keep the returned JSON string for Step 6.

```lua
local HttpService = game:GetService("HttpService")
local root = game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("VFX"):WaitForChild("Firework")

local PROPERTY_BY_CLASS = {
	BasePart = {
		"Anchored", "CanCollide", "CanQuery", "CanTouch", "CastShadow", "Color", "Material",
		"Massless", "Reflectance", "Size", "Transparency", "Shape", "TopSurface", "BottomSurface",
		"LeftSurface", "RightSurface", "FrontSurface", "BackSurface",
	},
	Sound = {
		"SoundId", "Volume", "PlaybackSpeed", "Looped", "RollOffMode", "RollOffMinDistance",
		"RollOffMaxDistance", "PlaybackRegionsEnabled", "PlaybackRegion", "LoopRegion",
	},
	Attachment = {
		"CFrame", "Axis", "SecondaryAxis", "Visible",
	},
	Trail = {
		"Attachment0", "Attachment1", "Color", "Enabled", "FaceCamera", "Lifetime", "LightEmission",
		"LightInfluence", "MaxLength", "MinLength", "Texture", "TextureLength", "TextureMode",
		"Transparency", "WidthScale",
	},
	ParticleEmitter = {
		"Acceleration", "Brightness", "Color", "Drag", "EmissionDirection", "Enabled", "FlipbookLayout",
		"FlipbookMode", "FlipbookStartRandom", "Lifetime", "LightEmission", "LightInfluence",
		"LockedToPart", "Orientation", "Rate", "RotSpeed", "Rotation", "Shape", "ShapeInOut",
		"ShapePartial", "ShapeStyle", "Size", "Speed", "SpreadAngle", "Squash", "Texture",
		"TimeScale", "Transparency", "VelocityInheritance", "WindAffectsDrag", "ZOffset",
	},
}

local function encodeValue(value)
	local valueType = typeof(value)
	if valueType == "Vector3" then
		return { t = "Vector3", x = value.X, y = value.Y, z = value.Z }
	elseif valueType == "Vector2" then
		return { t = "Vector2", x = value.X, y = value.Y }
	elseif valueType == "Color3" then
		return { t = "Color3", r = value.R, g = value.G, b = value.B }
	elseif valueType == "CFrame" then
		return { t = "CFrame", values = { value:GetComponents() } }
	elseif valueType == "NumberRange" then
		return { t = "NumberRange", min = value.Min, max = value.Max }
	elseif valueType == "NumberSequence" then
		local keypoints = {}
		for _, keypoint in ipairs(value.Keypoints) do
			table.insert(keypoints, { time = keypoint.Time, value = keypoint.Value, envelope = keypoint.Envelope })
		end
		return { t = "NumberSequence", keypoints = keypoints }
	elseif valueType == "ColorSequence" then
		local keypoints = {}
		for _, keypoint in ipairs(value.Keypoints) do
			table.insert(keypoints, {
				time = keypoint.Time,
				value = encodeValue(keypoint.Value),
			})
		end
		return { t = "ColorSequence", keypoints = keypoints }
	elseif valueType == "EnumItem" then
		return { t = "EnumItem", enumType = tostring(value.EnumType), name = value.Name }
	elseif valueType == "Instance" then
		return { t = "InstancePath", path = value:GetFullName() }
	end
	return value
end

local function getProperties(instance)
	local properties = {}
	local names = {}
	for className, classProperties in pairs(PROPERTY_BY_CLASS) do
		if instance:IsA(className) then
			for _, propertyName in ipairs(classProperties) do
				names[propertyName] = true
			end
		end
	end
	for propertyName in pairs(names) do
		local ok, value = pcall(function()
			return instance[propertyName]
		end)
		if ok then
			properties[propertyName] = encodeValue(value)
		end
	end
	return properties
end

local function serialize(instance)
	local children = {}
	for _, child in ipairs(instance:GetChildren()) do
		table.insert(children, serialize(child))
	end
	return {
		name = instance.Name,
		className = instance.ClassName,
		properties = getProperties(instance),
		attributes = instance:GetAttributes(),
		children = children,
	}
end

return HttpService:JSONEncode(serialize(root))
```

Expected: the MCP result is a JSON string whose root has `name = "Firework"` and `className = "Part"`.

- [ ] **Step 5: Switch back to DB_DEV**

Use `user-Roblox_Studio.set_active_studio` with the Studio id whose name contains `DB_DEV`.

Expected: active Studio becomes `DB_DEV`.

- [ ] **Step 6: Recreate the Firework tree in DB_DEV**

Use `user-Roblox_Studio.execute_luau` in `DB_DEV`. Paste the JSON string from Step 4 into `payloadJson`.

```lua
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local payloadJson = [[PASTE_FIREWORK_JSON_HERE]]
local payload = HttpService:JSONDecode(payloadJson)

local function ensureFolder(parent, name)
	local folder = parent:FindFirstChild(name)
	if folder and not folder:IsA("Folder") then
		folder.Name = name .. "_Backup_" .. os.time()
		folder = nil
	end
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = name
		folder.Parent = parent
	end
	return folder
end

local assets = ensureFolder(ReplicatedStorage, "Assets")
local vfx = ensureFolder(assets, "VFX")
local existing = vfx:FindFirstChild("Firework")
if existing then
	existing.Name = "Firework_Backup_" .. os.time()
end

local createdByPath = {}

local function decodeValue(value)
	if type(value) ~= "table" or type(value.t) ~= "string" then
		return value
	end
	if value.t == "Vector3" then
		return Vector3.new(value.x, value.y, value.z)
	elseif value.t == "Vector2" then
		return Vector2.new(value.x, value.y)
	elseif value.t == "Color3" then
		return Color3.new(value.r, value.g, value.b)
	elseif value.t == "CFrame" then
		return CFrame.new(table.unpack(value.values))
	elseif value.t == "NumberRange" then
		return NumberRange.new(value.min, value.max)
	elseif value.t == "NumberSequence" then
		local keypoints = {}
		for _, keypoint in ipairs(value.keypoints) do
			table.insert(keypoints, NumberSequenceKeypoint.new(keypoint.time, keypoint.value, keypoint.envelope))
		end
		return NumberSequence.new(keypoints)
	elseif value.t == "ColorSequence" then
		local keypoints = {}
		for _, keypoint in ipairs(value.keypoints) do
			table.insert(keypoints, ColorSequenceKeypoint.new(keypoint.time, decodeValue(keypoint.value)))
		end
		return ColorSequence.new(keypoints)
	elseif value.t == "EnumItem" then
		local enumName = string.match(value.enumType, "^Enum%.(.+)$")
		if enumName and Enum[enumName] then
			return Enum[enumName][value.name]
		end
	elseif value.t == "InstancePath" then
		return value
	end
	return nil
end

local deferredInstanceProperties = {}

local function createNode(node, parent, path)
	local instance = Instance.new(node.className)
	instance.Name = node.name
	instance.Parent = parent
	local nodePath = path .. "." .. node.name
	createdByPath[nodePath] = instance

	for propertyName, encodedValue in pairs(node.properties or {}) do
		if type(encodedValue) == "table" and encodedValue.t == "InstancePath" then
			table.insert(deferredInstanceProperties, {
				instance = instance,
				propertyName = propertyName,
				sourcePath = encodedValue.path,
			})
		else
			local decoded = decodeValue(encodedValue)
			if decoded ~= nil then
				pcall(function()
					instance[propertyName] = decoded
				end)
			end
		end
	end

	for attributeName, attributeValue in pairs(node.attributes or {}) do
		instance:SetAttribute(attributeName, attributeValue)
	end

	for _, childNode in ipairs(node.children or {}) do
		createNode(childNode, instance, nodePath)
	end
	return instance
end

local firework = createNode(payload, vfx, "ReplicatedStorage.Assets.VFX")

for _, item in ipairs(deferredInstanceProperties) do
	local relativePath = string.gsub(item.sourcePath, "^ReplicatedStorage%.Assets%.VFX%.Firework", "ReplicatedStorage.Assets.VFX.Firework")
	local target = createdByPath[relativePath]
	if target then
		pcall(function()
			item.instance[item.propertyName] = target
		end)
	end
end

return {
	path = firework:GetFullName(),
	descendants = #firework:GetDescendants(),
}
```

Expected: result path is `ReplicatedStorage.Assets.VFX.Firework`, descendants count is at least 13.

- [ ] **Step 7: Validate the copied resource**

Use `user-Roblox_Studio.inspect_instance` on:

`ReplicatedStorage.Assets.VFX.Firework`

Expected: `Firework` exists in `DB_DEV` with `Fly`, `Explode`, `Attachment`, `Trail`, `A1`, and `A2`.

## Task 2: Add Firework Playback Helpers

**Files:**
- Modify: `src/StarterPlayer/StarterPlayerScripts/Controllers/BuildController.lua`

- [ ] **Step 1: Add constants near the existing build visual constants**

Add after `local LAYER_BUILD_RESUME_DELAY = 0.5`:

```lua
local FIREWORK_ASCEND_HEIGHT = 14
local FIREWORK_ASCEND_TIME = 0.7
local FIREWORK_EMIT_COUNT = 20
local FIREWORK_CLEANUP_TIME = 5
local FIREWORK_REPEAT_MIN_DELAY = 0.3
local FIREWORK_REPEAT_MAX_DELAY = 0.8
```

Expected: constants are grouped with the other build celebration values.

- [ ] **Step 2: Add Firework helper state and functions before `playLayerCompletionEffect`**

Insert before `local function playLayerCompletionEffect(layer)`:

```lua
local hasWarnedMissingFirework = false

local function getRunningVfxContainer(): Instance
	local runningVfx = Workspace:FindFirstChild("RunningVFX")
	if runningVfx then
		return runningVfx
	end

	local folder = Instance.new("Folder")
	folder.Name = "RunningVFX"
	folder.Parent = Workspace
	return folder
end

local function getFireworkTemplate(): BasePart?
	local assets = ReplicatedStorage:FindFirstChild("Assets")
	local vfx = assets and assets:FindFirstChild("VFX")
	local firework = vfx and vfx:FindFirstChild("Firework")
	if firework and firework:IsA("BasePart") then
		return firework
	end

	if not hasWarnedMissingFirework then
		hasWarnedMissingFirework = true
		warn("[BuildController] Missing ReplicatedStorage.Assets.VFX.Firework")
	end
	return nil
end

local function emitFireworkParticles(firework: Instance)
	local attachment = firework:FindFirstChild("Attachment")
	if not attachment then
		return
	end

	for _, child in ipairs(attachment:GetChildren()) do
		if child:IsA("ParticleEmitter") then
			child:Emit(FIREWORK_EMIT_COUNT)
		end
	end
end

local function playFireworkAt(position: Vector3)
	local template = getFireworkTemplate()
	if not template then
		return
	end

	local firework = template:Clone()
	firework.Parent = getRunningVfxContainer()
	firework.Position = position

	TweenService:Create(
		firework,
		TweenInfo.new(FIREWORK_ASCEND_TIME),
		{ Position = position + Vector3.new(0, FIREWORK_ASCEND_HEIGHT, 0) }
	):Play()

	local flySound = firework:FindFirstChild("Fly")
	if flySound and flySound:IsA("Sound") then
		flySound.TimePosition = 1
		flySound:Play()
	end

	task.delay(FIREWORK_ASCEND_TIME, function()
		if not firework.Parent then
			return
		end

		if flySound and flySound:IsA("Sound") then
			flySound:Stop()
		end

		local explodeSound = firework:FindFirstChild("Explode")
		if explodeSound and explodeSound:IsA("Sound") then
			explodeSound:Play()
		end

		emitFireworkParticles(firework)
	end)

	Debris:AddItem(firework, FIREWORK_CLEANUP_TIME)
end

local function playFireworksAt(position: Vector3, count: number)
	local safeCount = math.max(1, math.floor(count))
	task.spawn(function()
		for index = 1, safeCount do
			playFireworkAt(position)
			if index < safeCount then
				task.wait(buildRng:NextNumber(FIREWORK_REPEAT_MIN_DELAY, FIREWORK_REPEAT_MAX_DELAY))
			end
		end
	end)
end

local function scheduleFireworksForCompletedPart(
	partByKey: { [string]: BasePart },
	completedPartKeys,
	fireworkCount: number
)
	if type(completedPartKeys) ~= "table" or #completedPartKeys <= 0 then
		return
	end

	local lastPartKey = completedPartKeys[#completedPartKeys]
	if type(lastPartKey) ~= "string" or lastPartKey == "" then
		return
	end

	task.delay(LAYER_CELEBRATION_DELAY, function()
		local part = partByKey[lastPartKey]
		if not part or not part.Parent then
			return
		end

		playFireworksAt(part.Position, fireworkCount)
	end)
end
```

Expected: `BuildController.lua` has no global variables except the new local warning flag.

## Task 3: Trigger Fireworks For Local Build Delta

**Files:**
- Modify: `src/StarterPlayer/StarterPlayerScripts/Controllers/BuildController.lua`

- [ ] **Step 1: Add trigger inside the local `completedLayerId` block**

Find the local-player block where it handles:

```lua
local completedLayerId = resolvedPayload.completedLayerId
if type(completedLayerId) == "string" and completedLayerId ~= "" then
```

After the existing `if layer then ... end` block that schedules `playLayerCompletionEffect`, add:

```lua
local completedCount = tonumber(resolvedPayload.completedCount) or 0
local totalCount = tonumber(resolvedPayload.totalCount) or 0
local fireworkCount = if totalCount > 0 and completedCount >= totalCount then 5 else 1
scheduleFireworksForCompletedPart(currentBuildPartByKey, completedPartKeys, fireworkCount)
```

Expected: local layer completion always schedules fireworks when a final completed part exists.

- [ ] **Step 2: Confirm sync paths do not trigger fireworks**

Check that the code from Step 1 remains inside the non-`sync` branch and inside the `completedLayerId` block.

Expected: `mode == "sync"` and `mode == "reset_sync"` cannot reach the firework scheduling code.

## Task 4: Trigger Fireworks For Other Visible Slots

**Files:**
- Modify: `src/StarterPlayer/StarterPlayerScripts/Controllers/BuildController.lua`

- [ ] **Step 1: Add trigger inside the other-slot `completedLayerId` block**

Find the other-player block where it handles:

```lua
local completedLayerId = resolvedPayload.completedLayerId
if type(completedLayerId) == "string" and completedLayerId ~= "" then
```

After the existing `if layer then ... end` block that schedules `playLayerCompletionEffect(layer)`, add:

```lua
local completedCount = tonumber(resolvedPayload.completedCount) or 0
local totalCount = tonumber(resolvedPayload.totalCount) or 0
local fireworkCount = if totalCount > 0 and completedCount >= totalCount then 5 else 1
scheduleFireworksForCompletedPart(otherState.partByKey, completedPartKeys, fireworkCount)
```

Expected: other visible slots play the same local firework effect at their final completed brick.

- [ ] **Step 2: Confirm unavailable models are safe**

Review `scheduleFireworksForCompletedPart` and confirm it returns if the part table, final key, or part is unavailable.

Expected: other slot model initialization races do not throw.

## Task 5: Verify In Code And Studio

**Files:**
- Verify: `src/StarterPlayer/StarterPlayerScripts/Controllers/BuildController.lua`
- Verify: `DB_DEV.ReplicatedStorage.Assets.VFX.Firework`

- [ ] **Step 1: Run lints for the edited controller**

Use Cursor `ReadLints` on:

`src/StarterPlayer/StarterPlayerScripts/Controllers/BuildController.lua`

Expected: no new diagnostics from the firework changes.

- [ ] **Step 2: Run Selene on the edited controller if available**

Run:

```bash
selene "src/StarterPlayer/StarterPlayerScripts/Controllers/BuildController.lua"
```

Expected: exit code 0, or the command is unavailable in the local environment. If unavailable, record that verification gap.

- [ ] **Step 3: Start or confirm Rojo sync**

Use the existing project entry from `RojoScripts/rojo-projects.conf`:

```bash
./RojoScripts/rojo-manager.sh status
```

Expected: the `DigToBuild` Rojo project is running on port `34872`, or start it with:

```bash
./RojoScripts/rojo-manager.sh start DigToBuild
```

- [ ] **Step 4: Confirm DB_DEV active before Studio verification**

Use `user-Roblox_Studio.list_roblox_studios`, then `set_active_studio` if the active Studio name does not contain `DB_DEV`.

Expected: active Studio is `#DB_DEV` or another name containing `DB_DEV`.

- [ ] **Step 5: Inspect copied Firework in DB_DEV**

Use `user-Roblox_Studio.inspect_instance`:

`ReplicatedStorage.Assets.VFX.Firework`

Expected: `Firework` exists and has the reference child structure.

- [ ] **Step 6: Manual gameplay verification**

Run in Studio and build through at least one complete layer and one complete building.

Expected:

- Completing a non-final layer plays exactly one firework at the final brick position.
- Completing the whole building plays exactly five fireworks at the final brick position.
- Joining with existing progress does not replay fireworks.
- Resetting progress does not play fireworks.

## Self-Review

- Spec coverage: Task 1 covers copying the full reference resource into `DB_DEV`; Tasks 2-4 cover client playback, final brick positioning, one versus five fireworks, local and other slot handling; Task 5 covers verification and non-replay checks.
- Placeholder scan: no unresolved implementation placeholders remain. `PASTE_FIREWORK_JSON_HERE` is an execution-time value produced by Task 1 Step 4 and consumed by Task 1 Step 6.
- Type consistency: helper names and payload fields match existing `BuildController` variables: `currentBuildPartByKey`, `otherState.partByKey`, `completedPartKeys`, `completedLayerId`, `completedCount`, and `totalCount`.
