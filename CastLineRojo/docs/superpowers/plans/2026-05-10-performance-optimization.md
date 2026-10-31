# Performance Optimization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add tiered client-side build rendering so low-end Android devices use coarse construction visuals, mid-range devices use batched visuals, and high-end devices keep capped full effects.

**Architecture:** Add three focused client modules: `PerformanceProfileClient` decides the active tier, `BuildTemplateStats` caches building size/layer metadata, and `BuildVfxBudget` returns caps for VFX and reveal work. Then thread those budgets through `BuildController` and `BuildVfxUtil`, keeping server build progress exact while changing only client presentation cost.

**Tech Stack:** Roblox Luau, Knit services/controllers, Rojo-managed source, Roblox Studio MCP for instance-tree checks, existing `BuildController`, `BuildModelUtil`, `BuildVfxUtil`, `PlayerDataController`, `SettingsService`.

---

## File Structure

- Create `src/StarterPlayer/StarterPlayerScripts/Controllers/Build/PerformanceProfileClient.lua`
  - Owns `Auto / Battery / Quality` mode resolution and `Low / Medium / High` effective tier.
  - Samples frame time on the client and exposes `GetTier()`, `GetMode()`, `SetMode()`, `Start()`, and `Changed`.
- Create `src/StarterPlayer/StarterPlayerScripts/Controllers/Build/BuildTemplateStats.lua`
  - Caches per-building part counts, layer counts, layer part counts, and large-template flags.
  - Reads `ReplicatedStorage.Models.Building` and `BuildingsDataHelper`.
- Create `src/StarterPlayer/StarterPlayerScripts/Controllers/Build/BuildVfxBudget.lua`
  - Converts tier + building stats into reveal, VFX, polling, and other-player model limits.
  - Tracks live VFX counters used by `BuildVfxUtil`.
- Modify `src/ReplicatedStorage/Modules/Constants.lua`
  - Add `Constants.SETTINGS_ID.PERFORMANCE_MODE = "PerformanceMode"`.
- Modify `src/ReplicatedStorage/PlayerData/Template.lua`
  - Add default setting `[Constants.SETTINGS_ID.PERFORMANCE_MODE] = "Auto"`.
- Modify `src/ServerScriptService/Services/SettingsService.lua`
  - Allow string settings for `PerformanceMode` and keep existing boolean settings behavior.
- Modify `src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/SettingsGuiController.lua`
  - Add safe optional binding for a Studio-created `PerformanceModeFrame`.
- Modify `src/StarterPlayer/StarterPlayerScripts/Controllers/Build/BuildVfxUtil.lua`
  - Add budget-aware flying brick admission, Trail disabling, popup caps, shake throttle, and debug counters.
- Modify `src/StarterPlayer/StarterPlayerScripts/Controllers/BuildController.lua`
  - Require the new modules, use budgeted reveal batches, throttle Heartbeat lanes, and gate other-player detailed model clones.
- Test manually in Roblox Studio with `#DB_DEV`; verify counters and no lingering VFX objects.

## Task 1: Add Performance Setting Plumbing

**Files:**
- Modify: `src/ReplicatedStorage/Modules/Constants.lua`
- Modify: `src/ReplicatedStorage/PlayerData/Template.lua`
- Modify: `src/ServerScriptService/Services/SettingsService.lua`
- Modify: `src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/SettingsGuiController.lua`

- [ ] **Step 1: Add the setting id**

In `src/ReplicatedStorage/Modules/Constants.lua`, extend `Constants.SETTINGS_ID`:

```lua
Constants.SETTINGS_ID = {
    CURRENT_WORLD_TRAIN = "CurrentWorldTrain",
    CURRENT_WORLD_SMASH = "CurrentWorldSmash",
    MUSIC = "Music",
    SOUND = "Sound",
    TRADE = "Trade",
    AUTO_REBIRTH = "AutoRebirth",
    GLOBAL_MESSAGE = "GlobalMessage",
    PERFORMANCE_MODE = "PerformanceMode",
}
```

- [ ] **Step 2: Add the default player setting**

In `src/ReplicatedStorage/PlayerData/Template.lua`, extend `DEFAULT_SETTINGS`:

```lua
local DEFAULT_SETTINGS = {
    [Constants.SETTINGS_ID.MUSIC] = true,
    [Constants.SETTINGS_ID.SOUND] = true,
    [Constants.SETTINGS_ID.TRADE] = false,
    [Constants.SETTINGS_ID.AUTO_REBIRTH] = false,
    [Constants.SETTINGS_ID.GLOBAL_MESSAGE] = true,
    [Constants.SETTINGS_ID.PERFORMANCE_MODE] = "Auto",
}
```

- [ ] **Step 3: Validate server-side setting writes**

In `src/ServerScriptService/Services/SettingsService.lua`, add this helper near the top after constants:

```lua
local PERFORMANCE_MODES = {
    Auto = true,
    Battery = true,
    Quality = true,
}

local function sanitizeSettingValue(settingId: string, settingValue: any): any
    if settingId == Constants.SETTINGS_ID.PERFORMANCE_MODE then
        if type(settingValue) == "string" and PERFORMANCE_MODES[settingValue] then
            return settingValue
        end
        return "Auto"
    end

    return settingValue == true
end
```

Then replace the assignment in `self.Client.ChangeSetting:Connect` with:

```lua
local sanitizedValue = sanitizeSettingValue(settingId, settingValue)
profile.Data.Settings[settingId] = sanitizedValue

if settingId == Constants.SETTINGS_ID.TRADE then
    self.Client.ChangeSetting:FireAll(player, settingId, sanitizedValue)
else
    self.Client.ChangeSetting:Fire(player, settingId, sanitizedValue)
end
```

- [ ] **Step 4: Add optional Settings GUI binding**

In `src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/SettingsGuiController.lua`, add after `HatchNotifButton`:

```lua
local PerformanceModeFrame = ScrollingFrame:FindFirstChild("PerformanceModeFrame")
local PerformanceModeButton = PerformanceModeFrame and PerformanceModeFrame:FindFirstChild("SwitchButton")
local PERFORMANCE_MODE_ORDER = { "Auto", "Battery", "Quality" }
```

Add this method below `SetButtonState`:

```lua
function SettingsGuiController:SetPerformanceModeButtonState(mode: string?)
    if not PerformanceModeButton or not PerformanceModeButton:IsA("GuiButton") then
        return
    end

    local label = PerformanceModeButton:FindFirstChild("ModeLabel")
    if label and label:IsA("TextLabel") then
        label.Text = mode or "Auto"
    end
end
```

Update `UpdateSettingButtons()`:

```lua
self:SetPerformanceModeButtonState(playerData.Settings[Constants.SETTINGS_ID.PERFORMANCE_MODE])
```

Add this method below `ChangeSetting`:

```lua
function SettingsGuiController:CyclePerformanceMode()
    local playerData = PlayerDataController:GetData()
    if not playerData then warn("No player data found!") return end

    local currentMode = playerData.Settings[Constants.SETTINGS_ID.PERFORMANCE_MODE]
    local currentIndex = table.find(PERFORMANCE_MODE_ORDER, currentMode) or 1
    local nextMode = PERFORMANCE_MODE_ORDER[(currentIndex % #PERFORMANCE_MODE_ORDER) + 1]

    playerData.Settings[Constants.SETTINGS_ID.PERFORMANCE_MODE] = nextMode
    Knit.GetService("SettingsService").ChangeSetting:Fire(Constants.SETTINGS_ID.PERFORMANCE_MODE, nextMode)
    self:UpdateSettingButtons()
end
```

In `KnitStart`, add:

```lua
if PerformanceModeButton and PerformanceModeButton:IsA("GuiButton") then
    PerformanceModeButton.MouseButton1Click:Connect(function()
        self:CyclePerformanceMode()
    end)
end
```

- [ ] **Step 5: Run syntax check**

Run:

```bash
git diff -- src/ReplicatedStorage/Modules/Constants.lua src/ReplicatedStorage/PlayerData/Template.lua src/ServerScriptService/Services/SettingsService.lua src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/SettingsGuiController.lua
```

Expected: only the setting id, default value, validation helper, and optional GUI binding changed.

- [ ] **Step 6: Commit**

```bash
git add src/ReplicatedStorage/Modules/Constants.lua src/ReplicatedStorage/PlayerData/Template.lua src/ServerScriptService/Services/SettingsService.lua src/StarterPlayer/StarterPlayerScripts/Controllers/GUI/SettingsGuiController.lua
git commit -m "feat(settings): add performance mode setting"
```

## Task 2: Add PerformanceProfileClient

**Files:**
- Create: `src/StarterPlayer/StarterPlayerScripts/Controllers/Build/PerformanceProfileClient.lua`

- [ ] **Step 1: Create the module**

Create `src/StarterPlayer/StarterPlayerScripts/Controllers/Build/PerformanceProfileClient.lua`:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")
local UserInputService = game:GetService("UserInputService")

local Signal = require(ReplicatedStorage.Packages.Signal)
local Constants = require(ReplicatedStorage.Modules.Constants)
local PlayerDataController = require(StarterPlayer.StarterPlayerScripts.Controllers.PlayerDataController)

local PerformanceProfileClient = {}

PerformanceProfileClient.TIER_LOW = "Low"
PerformanceProfileClient.TIER_MEDIUM = "Medium"
PerformanceProfileClient.TIER_HIGH = "High"

PerformanceProfileClient.MODE_AUTO = "Auto"
PerformanceProfileClient.MODE_BATTERY = "Battery"
PerformanceProfileClient.MODE_QUALITY = "Quality"

PerformanceProfileClient.Changed = Signal.new()

local SAMPLE_WINDOW_SECONDS = 8
local RESAMPLE_INTERVAL_SECONDS = 10
local LOW_AVG_FPS = 28
local MEDIUM_AVG_FPS = 50
local SPIKE_DT = 1 / 20
local SPIKE_RATIO_LOW = 0.16
local SPIKE_RATIO_MEDIUM = 0.08

local currentTier = PerformanceProfileClient.TIER_MEDIUM
local currentMode = PerformanceProfileClient.MODE_AUTO
local started = false
local sampleElapsed = 0
local resampleElapsed = 0
local sampleCount = 0
local totalDt = 0
local spikeCount = 0

local function isMobile(): boolean
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function sanitizeMode(mode: any): string
    if mode == PerformanceProfileClient.MODE_BATTERY
        or mode == PerformanceProfileClient.MODE_QUALITY
        or mode == PerformanceProfileClient.MODE_AUTO
    then
        return mode
    end
    return PerformanceProfileClient.MODE_AUTO
end

local function readSavedMode(): string
    local ok, playerData = pcall(function()
        return PlayerDataController:GetData()
    end)
    if ok and playerData and playerData.Settings then
        return sanitizeMode(playerData.Settings[Constants.SETTINGS_ID.PERFORMANCE_MODE])
    end
    return PerformanceProfileClient.MODE_AUTO
end

local function resolveTierFromSamples(): string
    if currentMode == PerformanceProfileClient.MODE_BATTERY then
        return PerformanceProfileClient.TIER_LOW
    end
    if currentMode == PerformanceProfileClient.MODE_QUALITY then
        return PerformanceProfileClient.TIER_HIGH
    end

    if sampleCount <= 0 or totalDt <= 0 then
        return if isMobile() then PerformanceProfileClient.TIER_MEDIUM else PerformanceProfileClient.TIER_HIGH
    end

    local avgFps = sampleCount / totalDt
    local spikeRatio = spikeCount / sampleCount

    if isMobile() and (avgFps < LOW_AVG_FPS or spikeRatio >= SPIKE_RATIO_LOW) then
        return PerformanceProfileClient.TIER_LOW
    end
    if isMobile() or avgFps < MEDIUM_AVG_FPS or spikeRatio >= SPIKE_RATIO_MEDIUM then
        return PerformanceProfileClient.TIER_MEDIUM
    end
    return PerformanceProfileClient.TIER_HIGH
end

local function resetSamples()
    sampleElapsed = 0
    sampleCount = 0
    totalDt = 0
    spikeCount = 0
end

local function setTier(nextTier: string)
    if currentTier == nextTier then
        return
    end
    currentTier = nextTier
    PerformanceProfileClient.Changed:Fire(currentTier, currentMode)
end

function PerformanceProfileClient.Start()
    if started then
        return
    end
    started = true
    currentMode = readSavedMode()
    currentTier = if isMobile() then PerformanceProfileClient.TIER_MEDIUM else PerformanceProfileClient.TIER_HIGH

    RunService.Heartbeat:Connect(function(dt)
        currentMode = readSavedMode()
        sampleElapsed += dt
        resampleElapsed += dt
        sampleCount += 1
        totalDt += dt
        if dt >= SPIKE_DT then
            spikeCount += 1
        end

        if sampleElapsed >= SAMPLE_WINDOW_SECONDS or resampleElapsed >= RESAMPLE_INTERVAL_SECONDS then
            setTier(resolveTierFromSamples())
            resetSamples()
            resampleElapsed = 0
        end
    end)
end

function PerformanceProfileClient.GetTier(): string
    return currentTier
end

function PerformanceProfileClient.GetMode(): string
    currentMode = readSavedMode()
    return currentMode
end

function PerformanceProfileClient.SetMode(mode: string)
    currentMode = sanitizeMode(mode)
    setTier(resolveTierFromSamples())
end

function PerformanceProfileClient.GetDebugState()
    return {
        tier = currentTier,
        mode = currentMode,
        isMobile = isMobile(),
        sampleCount = sampleCount,
        avgFps = if totalDt > 0 then sampleCount / totalDt else 0,
        spikeRatio = if sampleCount > 0 then spikeCount / sampleCount else 0,
    }
end

return PerformanceProfileClient
```

- [ ] **Step 2: Verify syntax by requiring from a Luau context**

Run Rojo/Studio sync or use Studio command execution after sync:

```lua
local module = require(game.StarterPlayer.StarterPlayerScripts.Controllers.Build.PerformanceProfileClient)
print(module.GetTier(), module.GetMode())
```

Expected: prints a valid tier and mode without errors.

- [ ] **Step 3: Commit**

```bash
git add src/StarterPlayer/StarterPlayerScripts/Controllers/Build/PerformanceProfileClient.lua
git commit -m "feat(build): add client performance profile"
```

## Task 3: Add BuildTemplateStats

**Files:**
- Create: `src/StarterPlayer/StarterPlayerScripts/Controllers/Build/BuildTemplateStats.lua`

- [ ] **Step 1: Create the stats cache**

Create `src/StarterPlayer/StarterPlayerScripts/Controllers/Build/BuildTemplateStats.lua`:

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local BuildingsDataHelper = require(ReplicatedFirst.DataHelpers.BuildingsDataHelper)

local BuildTemplateStats = {}

export type LayerStats = {
    layerId: string,
    partCount: number,
}

export type Stats = {
    buildingId: string,
    modelName: string,
    totalParts: number,
    layerCount: number,
    layerPartCounts: { number },
    layers: { LayerStats },
    isLargeTemplate: boolean,
    isHugeTemplate: boolean,
}

local LARGE_PART_THRESHOLD = 2000
local HUGE_PART_THRESHOLD = 4000
local cache: { [string]: Stats } = {}

local function isBuildGameplayPart(part: BasePart): boolean
    return part.Name ~= "RootPart"
end

local function getTemplate(buildingId: string): Instance?
    local modelName = BuildingsDataHelper.GetModelName(buildingId)
    if modelName == "" then
        return nil
    end
    local modelsFolder = ReplicatedStorage:FindFirstChild("Models")
    local buildingRoot = modelsFolder and modelsFolder:FindFirstChild("Building")
    return buildingRoot and buildingRoot:FindFirstChild(modelName) or nil
end

local function collectLayerSources(template: Instance)
    local sources = {}
    for _, child in ipairs(template:GetChildren()) do
        if child:IsA("Model") then
            local layerNumber = tonumber(child.Name)
            if layerNumber and layerNumber >= 1 and layerNumber % 1 == 0 then
                table.insert(sources, {
                    layerId = child.Name,
                    layerNumber = layerNumber,
                    root = child,
                })
            end
        end
    end
    table.sort(sources, function(a, b)
        if a.layerNumber == b.layerNumber then
            return a.layerId < b.layerId
        end
        return a.layerNumber < b.layerNumber
    end)
    if #sources == 0 then
        table.insert(sources, {
            layerId = "1",
            layerNumber = 1,
            root = template,
        })
    end
    return sources
end

local function countBuildParts(root: Instance): number
    local count = 0
    for _, descendant in ipairs(root:GetDescendants()) do
        if descendant:IsA("BasePart") and isBuildGameplayPart(descendant) then
            count += 1
        end
    end
    return count
end

function BuildTemplateStats.Get(buildingId: string?): Stats?
    if type(buildingId) ~= "string" or buildingId == "" then
        return nil
    end
    if cache[buildingId] then
        return cache[buildingId]
    end

    local modelName = BuildingsDataHelper.GetModelName(buildingId)
    local template = getTemplate(buildingId)
    if not template then
        return nil
    end

    local layers = {}
    local layerPartCounts = {}
    local totalParts = 0
    for _, source in ipairs(collectLayerSources(template)) do
        local partCount = countBuildParts(source.root)
        totalParts += partCount
        table.insert(layerPartCounts, partCount)
        table.insert(layers, {
            layerId = source.layerId,
            partCount = partCount,
        })
    end

    local stats: Stats = {
        buildingId = buildingId,
        modelName = modelName,
        totalParts = totalParts,
        layerCount = #layers,
        layerPartCounts = layerPartCounts,
        layers = layers,
        isLargeTemplate = totalParts >= LARGE_PART_THRESHOLD,
        isHugeTemplate = totalParts >= HUGE_PART_THRESHOLD,
    }
    cache[buildingId] = stats
    return stats
end

function BuildTemplateStats.ClearCache()
    cache = {}
end

return BuildTemplateStats
```

- [ ] **Step 2: Verify in Studio**

After Rojo sync, execute:

```lua
local stats = require(game.StarterPlayer.StarterPlayerScripts.Controllers.Build.BuildTemplateStats)
print(stats.Get("Building_106").totalParts)
```

Expected: prints a positive count near the Studio-observed `Burjkhalifa` count.

- [ ] **Step 3: Commit**

```bash
git add src/StarterPlayer/StarterPlayerScripts/Controllers/Build/BuildTemplateStats.lua
git commit -m "feat(build): add template stats cache"
```

## Task 4: Add BuildVfxBudget

**Files:**
- Create: `src/StarterPlayer/StarterPlayerScripts/Controllers/Build/BuildVfxBudget.lua`

- [ ] **Step 1: Create budget module**

Create `src/StarterPlayer/StarterPlayerScripts/Controllers/Build/BuildVfxBudget.lua`:

```lua
local BuildVfxBudget = {}

export type Budget = {
    tier: string,
    revealBatchPerFrame: number,
    otherRevealBatchPerFrame: number,
    buildStepInterval: number,
    buildBatchCount: number,
    flyBrickSampleRate: number,
    maxActiveFlyingBricks: number,
    maxFlyingBricksPerSecond: number,
    trailEnabled: boolean,
    popupMaxActive: number,
    shakeMinInterval: number,
    layerFireworkCount: number,
    buildingFireworkCount: number,
    otherDetailedBuildMax: number,
    buildZonePollInterval: number,
    uiPollInterval: number,
    invitePollInterval: number,
    unstuckPollInterval: number,
}

local counters = {
    activeFlyingBricks = 0,
    flyingBrickWindowStartedAt = 0,
    flyingBricksThisSecond = 0,
    activePopups = 0,
    lastShakeAt = 0,
}

local BASE_BY_TIER: { [string]: Budget } = {
    Low = {
        tier = "Low",
        revealBatchPerFrame = 120,
        otherRevealBatchPerFrame = 240,
        buildStepInterval = 0.08,
        buildBatchCount = 8,
        flyBrickSampleRate = 24,
        maxActiveFlyingBricks = 2,
        maxFlyingBricksPerSecond = 4,
        trailEnabled = false,
        popupMaxActive = 1,
        shakeMinInterval = 0.8,
        layerFireworkCount = 0,
        buildingFireworkCount = 2,
        otherDetailedBuildMax = 0,
        buildZonePollInterval = 0.25,
        uiPollInterval = 0.5,
        invitePollInterval = 0.5,
        unstuckPollInterval = 0.4,
    },
    Medium = {
        tier = "Medium",
        revealBatchPerFrame = 60,
        otherRevealBatchPerFrame = 120,
        buildStepInterval = 0.05,
        buildBatchCount = 3,
        flyBrickSampleRate = 6,
        maxActiveFlyingBricks = 6,
        maxFlyingBricksPerSecond = 10,
        trailEnabled = false,
        popupMaxActive = 2,
        shakeMinInterval = 0.35,
        layerFireworkCount = 2,
        buildingFireworkCount = 6,
        otherDetailedBuildMax = 1,
        buildZonePollInterval = 0.2,
        uiPollInterval = 0.35,
        invitePollInterval = 0.35,
        unstuckPollInterval = 0.25,
    },
    High = {
        tier = "High",
        revealBatchPerFrame = 30,
        otherRevealBatchPerFrame = 60,
        buildStepInterval = 0.04,
        buildBatchCount = 1,
        flyBrickSampleRate = 1,
        maxActiveFlyingBricks = 14,
        maxFlyingBricksPerSecond = 20,
        trailEnabled = true,
        popupMaxActive = 4,
        shakeMinInterval = 0.16,
        layerFireworkCount = 4,
        buildingFireworkCount = 12,
        otherDetailedBuildMax = 2,
        buildZonePollInterval = 0.15,
        uiPollInterval = 0.25,
        invitePollInterval = 0.25,
        unstuckPollInterval = 0.2,
    },
}

local function cloneBudget(source: Budget): Budget
    local copy = {}
    for key, value in pairs(source) do
        copy[key] = value
    end
    return copy :: Budget
end

function BuildVfxBudget.GetBudget(tier: string, stats): Budget
    local budget = cloneBudget(BASE_BY_TIER[tier] or BASE_BY_TIER.Medium)
    if stats and stats.isHugeTemplate then
        budget.flyBrickSampleRate = math.max(budget.flyBrickSampleRate, 12)
        budget.maxActiveFlyingBricks = math.min(budget.maxActiveFlyingBricks, 4)
        budget.maxFlyingBricksPerSecond = math.min(budget.maxFlyingBricksPerSecond, 8)
        budget.layerFireworkCount = math.min(budget.layerFireworkCount, 1)
        budget.buildingFireworkCount = math.min(budget.buildingFireworkCount, 4)
    elseif stats and stats.isLargeTemplate then
        budget.flyBrickSampleRate = math.max(budget.flyBrickSampleRate, 6)
        budget.maxActiveFlyingBricks = math.min(budget.maxActiveFlyingBricks, 8)
        budget.maxFlyingBricksPerSecond = math.min(budget.maxFlyingBricksPerSecond, 12)
    end
    return budget
end

function BuildVfxBudget.TryAcquireFlyingBrick(budget: Budget, sequenceIndex: number): boolean
    if budget.flyBrickSampleRate > 1 and ((sequenceIndex - 1) % budget.flyBrickSampleRate) ~= 0 then
        return false
    end

    local now = os.clock()
    if now - counters.flyingBrickWindowStartedAt >= 1 then
        counters.flyingBrickWindowStartedAt = now
        counters.flyingBricksThisSecond = 0
    end
    if counters.activeFlyingBricks >= budget.maxActiveFlyingBricks then
        return false
    end
    if counters.flyingBricksThisSecond >= budget.maxFlyingBricksPerSecond then
        return false
    end

    counters.activeFlyingBricks += 1
    counters.flyingBricksThisSecond += 1
    return true
end

function BuildVfxBudget.ReleaseFlyingBrick()
    counters.activeFlyingBricks = math.max(0, counters.activeFlyingBricks - 1)
end

function BuildVfxBudget.TryAcquirePopup(budget: Budget): boolean
    if counters.activePopups >= budget.popupMaxActive then
        return false
    end
    counters.activePopups += 1
    return true
end

function BuildVfxBudget.ReleasePopup()
    counters.activePopups = math.max(0, counters.activePopups - 1)
end

function BuildVfxBudget.CanShake(budget: Budget): boolean
    local now = os.clock()
    if now - counters.lastShakeAt < budget.shakeMinInterval then
        return false
    end
    counters.lastShakeAt = now
    return true
end

function BuildVfxBudget.GetDebugCounters()
    return {
        activeFlyingBricks = counters.activeFlyingBricks,
        flyingBricksThisSecond = counters.flyingBricksThisSecond,
        activePopups = counters.activePopups,
        lastShakeAt = counters.lastShakeAt,
    }
end

return BuildVfxBudget
```

- [ ] **Step 2: Verify module returns expected budgets**

After Rojo sync, execute:

```lua
local budget = require(game.StarterPlayer.StarterPlayerScripts.Controllers.Build.BuildVfxBudget)
print(budget.GetBudget("Low", { isLargeTemplate = true, isHugeTemplate = true }).flyBrickSampleRate)
```

Expected: prints `24` or a larger sampling value for Low huge templates.

- [ ] **Step 3: Commit**

```bash
git add src/StarterPlayer/StarterPlayerScripts/Controllers/Build/BuildVfxBudget.lua
git commit -m "feat(build): add vfx budgets"
```

## Task 5: Make BuildVfxUtil Budget-Aware

**Files:**
- Modify: `src/StarterPlayer/StarterPlayerScripts/Controllers/Build/BuildVfxUtil.lua`

- [ ] **Step 1: Require budget module and extend deps type**

At the top, after `BuildModelUtil`, add:

```lua
local BuildVfxBudget = require(script.Parent.BuildVfxBudget)
```

Extend `FlyingBrickDeps`:

```lua
export type FlyingBrickDeps = {
    rng: Random,
    lastFlyBrickSoundAtRef: { number },
    getBuildSpeedMultiplier: () -> number,
    flyBrickSoundPitchRef: { number },
    getBudget: (() -> BuildVfxBudget.Budget?)?,
}
```

- [ ] **Step 2: Budget camera shake**

Replace `function BuildVfxUtil.playBuildLandingCameraShake()` with:

```lua
function BuildVfxUtil.playBuildLandingCameraShake(budget: BuildVfxBudget.Budget?)
    if budget and not BuildVfxBudget.CanShake(budget) then
        return
    end
    local camera = Workspace.CurrentCamera
    if not camera then
        return
    end

    local shake = Shake.new()
    shake.FadeInTime = 0
    shake.FadeOutTime = BUILD_SHAKE.FADE_OUT
    shake.SustainTime = 0
    shake.Sustain = false
    shake.Frequency = BUILD_SHAKE.FREQUENCY
    shake.Amplitude = BUILD_SHAKE.AMPLITUDE
    shake.PositionInfluence = BUILD_SHAKE.POS_INFLUENCE
    shake.RotationInfluence = BUILD_SHAKE.ROT_INFLUENCE
    shake:Start()
    shake:BindToRenderStep(Shake.NextRenderName(), Enum.RenderPriority.Last.Value, function(pos, rot, _)
        local cam = Workspace.CurrentCamera
        if not cam then
            return
        end
        cam.CFrame *= CFrame.new(pos) * CFrame.Angles(rot.X, rot.Y, rot.Z)
    end)
end
```

- [ ] **Step 3: Budget reward popup**

Change the signature:

```lua
function BuildVfxUtil.spawnBuildRewardPopup(worldPosition: Vector3, amount: number, budget: BuildVfxBudget.Budget?)
```

Add after the amount guard:

```lua
if budget and not BuildVfxBudget.TryAcquirePopup(budget) then
    return
end
```

After `Debris:AddItem(...)`, add:

```lua
if budget then
    task.delay(math.max(BUILD_POPUP.RISE_TIME + BUILD_POPUP.TEXT_FADE_DELAY, BUILD_POPUP.PART_LIFETIME) + 0.25, function()
        BuildVfxBudget.ReleasePopup()
    end)
end
```

- [ ] **Step 4: Budget flying brick creation**

At the start of `createFlyingBrick`, after parameters are available, add:

```lua
local budget = deps.getBudget and deps.getBudget() or nil
if budget and not BuildVfxBudget.TryAcquireFlyingBrick(budget, sequenceIndex) then
    if winsAmount and winsAmount > 0 then
        BuildVfxUtil.spawnBuildRewardPopup(endPos, winsAmount, budget)
    end
    if onArrive then
        task.defer(onArrive)
    end
    return
end
```

Wrap Trail creation:

```lua
if not budget or budget.trailEnabled then
    local attach0 = Instance.new("Attachment")
    attach0.Position = Vector3.new(0, 0, 0.45)
    attach0.Parent = brick

    local attach1 = Instance.new("Attachment")
    attach1.Position = Vector3.new(0, 0, -0.45)
    attach1.Parent = brick

    local trail = Instance.new("Trail")
    trail.Attachment0 = attach0
    trail.Attachment1 = attach1
    trail.Color = ColorSequence.new(color:Lerp(Color3.new(1, 1, 1), 0.25), color)
    trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 1),
    })
    trail.Lifetime = 0.12
    trail.MinLength = 0.05
    trail.FaceCamera = true
    trail.Parent = brick
end
```

Remove the old unconditional `Attachment` and `Trail` block.

In `tween.Completed`, replace the shake and popup calls:

```lua
BuildVfxUtil.playBuildLandingCameraShake(budget)
if winsAmount and winsAmount > 0 then
    BuildVfxUtil.spawnBuildRewardPopup(endPos, winsAmount, budget)
end
```

Before destroying the brick, release the counter:

```lua
if budget then
    BuildVfxBudget.ReleaseFlyingBrick()
end
brick:Destroy()
```

- [ ] **Step 5: Add debug API**

Before `return BuildVfxUtil`, add:

```lua
function BuildVfxUtil.getBudgetDebugCounters()
    return BuildVfxBudget.GetDebugCounters()
end
```

- [ ] **Step 6: Verify no old Trail block remains**

Run:

```bash
rg -n "local attach0|local trail|playBuildLandingCameraShake\\(|spawnBuildRewardPopup\\(" src/StarterPlayer/StarterPlayerScripts/Controllers/Build/BuildVfxUtil.lua
```

Expected: `attach0` and `trail` only appear inside the `if not budget or budget.trailEnabled` block; shake and popup calls pass `budget`.

- [ ] **Step 7: Commit**

```bash
git add src/StarterPlayer/StarterPlayerScripts/Controllers/Build/BuildVfxUtil.lua
git commit -m "feat(build): cap construction vfx"
```

## Task 6: Integrate Budgets Into BuildController

**Files:**
- Modify: `src/StarterPlayer/StarterPlayerScripts/Controllers/BuildController.lua`

- [ ] **Step 1: Require new modules**

Near existing build requires, add:

```lua
local PerformanceProfileClient = require(script.Parent.Build.PerformanceProfileClient)
local BuildTemplateStats = require(script.Parent.Build.BuildTemplateStats)
local BuildVfxBudget = require(script.Parent.Build.BuildVfxBudget)
```

- [ ] **Step 2: Add current stats and budget helpers**

Near `flyingBrickDeps`, add:

```lua
local currentBuildStats = nil
local currentBuildBudget = BuildVfxBudget.GetBudget(PerformanceProfileClient.GetTier(), nil)

local function refreshBuildBudget()
    currentBuildBudget = BuildVfxBudget.GetBudget(PerformanceProfileClient.GetTier(), currentBuildStats)
    return currentBuildBudget
end

local function getCurrentBuildBudget()
    return currentBuildBudget or refreshBuildBudget()
end
```

Add to `flyingBrickDeps`:

```lua
getBudget = getCurrentBuildBudget,
```

- [ ] **Step 3: Start profile sampling**

At the top of `BuildController:KnitStart()`, before connecting Heartbeat:

```lua
PerformanceProfileClient.Start()
refreshBuildBudget()
PerformanceProfileClient.Changed:Connect(function()
    refreshBuildBudget()
end)
```

- [ ] **Step 4: Refresh stats when build model changes**

In `ensureBuildModel`, after `currentBuildingId = targetBuildingId`, add:

```lua
currentBuildStats = BuildTemplateStats.Get(targetBuildingId)
refreshBuildBudget()
```

In the branch that destroys `currentBuildModel`, also reset:

```lua
currentBuildStats = nil
refreshBuildBudget()
```

- [ ] **Step 5: Use budget for reveal batches**

Replace:

```lua
local revealBatch = math.min(REVEAL_BATCH_PER_FRAME, #pendingRevealKeys)
```

with:

```lua
local budget = getCurrentBuildBudget()
local revealBatch = math.min(budget.revealBatchPerFrame, #pendingRevealKeys)
```

Replace:

```lua
local revealBatch = math.min(OTHER_REVEAL_BATCH_PER_FRAME, #slotState.pendingRevealKeys)
```

with:

```lua
local budget = getCurrentBuildBudget()
local revealBatch = math.min(budget.otherRevealBatchPerFrame, #slotState.pendingRevealKeys)
```

- [ ] **Step 6: Use budget for build request cadence**

Replace:

```lua
local buildPartKeys = collectBuildablePartKeys(BUILD_BATCH_COUNT)
```

with:

```lua
local budget = getCurrentBuildBudget()
local buildPartKeys = collectBuildablePartKeys(budget.buildBatchCount)
```

Replace:

```lua
buildCooldown = BUILD_STEP_INTERVAL / getBuildSpeedMultiplier()
```

with:

```lua
buildCooldown = budget.buildStepInterval / getBuildSpeedMultiplier()
```

- [ ] **Step 7: Gate other-player detailed models**

Add helper near `ensureOtherBuildModel`:

```lua
local function countOtherDetailedBuilds(): number
    local count = 0
    for _, state in pairs(otherBuildStates) do
        if state.buildModel and state.buildModel:IsDescendantOf(Workspace) then
            count += 1
        end
    end
    return count
end
```

At the start of `ensureOtherBuildModel`, after the self-slot check:

```lua
local budget = getCurrentBuildBudget()
local existing = otherBuildStates[slotId]
if not existing and countOtherDetailedBuilds() >= budget.otherDetailedBuildMax then
    return false
end
```

- [ ] **Step 8: Add debug accessor**

Before `return BuildController`, add:

```lua
function BuildController:GetBuildPerformanceDebug()
    local budget = getCurrentBuildBudget()
    return {
        tier = PerformanceProfileClient.GetTier(),
        mode = PerformanceProfileClient.GetMode(),
        buildingId = currentBuildingId,
        totalParts = currentBuildStats and currentBuildStats.totalParts or 0,
        pendingRevealCount = #pendingRevealKeys,
        otherBuildStateCount = countOtherDetailedBuilds(),
        budget = budget,
        vfxCounters = BuildVfxUtil.getBudgetDebugCounters(),
    }
end
```

- [ ] **Step 9: Verify references**

Run:

```bash
rg -n "PerformanceProfileClient|BuildTemplateStats|BuildVfxBudget|GetBuildPerformanceDebug|getBudget" src/StarterPlayer/StarterPlayerScripts/Controllers/BuildController.lua
```

Expected: all new modules and debug function are referenced.

- [ ] **Step 10: Commit**

```bash
git add src/StarterPlayer/StarterPlayerScripts/Controllers/BuildController.lua
git commit -m "feat(build): apply performance budgets"
```

## Task 7: Throttle BuildController Heartbeat Lanes

**Files:**
- Modify: `src/StarterPlayer/StarterPlayerScripts/Controllers/BuildController.lua`

- [ ] **Step 1: Add lane timers**

Near existing cooldown variables, add:

```lua
local buildZonePollCooldown = 0
local uiPollCooldown = 0
local invitePollCooldown = 0
```

- [ ] **Step 2: Replace unconditional polling in Heartbeat**

Inside `RunService.Heartbeat:Connect(function(deltaTime)`, replace:

```lua
detectBuildProximityZone()
detectEmptyFarmInvitePrompt()
detectBuildProgressDisplayZone()
updateUnstuckState(deltaTime)
```

with:

```lua
local budget = getCurrentBuildBudget()

buildZonePollCooldown -= deltaTime
if buildZonePollCooldown <= 0 then
    buildZonePollCooldown = budget.buildZonePollInterval
    detectBuildProximityZone()
end

invitePollCooldown -= deltaTime
if invitePollCooldown <= 0 then
    invitePollCooldown = budget.invitePollInterval
    detectEmptyFarmInvitePrompt()
end

uiPollCooldown -= deltaTime
if uiPollCooldown <= 0 then
    uiPollCooldown = budget.uiPollInterval
    detectBuildProgressDisplayZone()
end

updateUnstuckState(deltaTime)
```

- [ ] **Step 3: Make unstuck interval budget-aware**

In `updateUnstuckState`, replace:

```lua
unstuckCheckCooldown = UNSTUCK_CHECK_INTERVAL
```

with:

```lua
local budget = getCurrentBuildBudget()
unstuckCheckCooldown = budget.unstuckPollInterval or UNSTUCK_CHECK_INTERVAL
```

Replace:

```lua
surroundedDuration += UNSTUCK_CHECK_INTERVAL
```

with:

```lua
surroundedDuration += budget.unstuckPollInterval or UNSTUCK_CHECK_INTERVAL
```

- [ ] **Step 4: Verify behavior in Studio**

After Rojo sync, enter and leave the build zone in `#DB_DEV`.

Expected:

- Build starts within about 0.25 seconds.
- Build progress UI still appears near the farm.
- Empty farm invite prompt still appears near empty farms.
- No errors in Studio output.

- [ ] **Step 5: Commit**

```bash
git add src/StarterPlayer/StarterPlayerScripts/Controllers/BuildController.lua
git commit -m "perf(build): throttle build controller polling"
```

## Task 8: Tune Layer Fireworks and Completion Effects by Budget

**Files:**
- Modify: `src/StarterPlayer/StarterPlayerScripts/Controllers/Build/BuildVfxUtil.lua`
- Modify: `src/StarterPlayer/StarterPlayerScripts/Controllers/BuildController.lua`

- [ ] **Step 1: Add budget parameters to firework schedulers**

In `BuildVfxUtil.lua`, change signatures:

```lua
function BuildVfxUtil.scheduleLayerFireworks(layer, scheduleState: FireworkScheduleState?, rng: Random, budget: BuildVfxBudget.Budget?)
```

```lua
function BuildVfxUtil.scheduleBuildingFireworks(buildParts: { BasePart }, scheduleState: FireworkScheduleState?, rng: Random, budget: BuildVfxBudget.Budget?)
```

Inside `scheduleLayerFireworks`, replace:

```lua
local picks = pickRandomParts(rng, layer.parts, LAYER_FIREWORK_COUNT)
```

with:

```lua
local count = if budget then budget.layerFireworkCount else LAYER_FIREWORK_COUNT
if count <= 0 then
    return
end
local picks = pickRandomParts(rng, layer.parts, count)
```

Inside `scheduleBuildingFireworks`, replace:

```lua
local picks = pickRandomParts(rng, buildParts, BUILDING_FIREWORK_COUNT)
```

with:

```lua
local count = if budget then budget.buildingFireworkCount else BUILDING_FIREWORK_COUNT
if count <= 0 then
    return
end
local picks = pickRandomParts(rng, buildParts, count)
```

- [ ] **Step 2: Pass budget from BuildController**

Replace calls:

```lua
BuildVfxUtil.scheduleBuildingFireworks(currentBuildParts, localFireworkScheduleState, buildRng)
```

with:

```lua
BuildVfxUtil.scheduleBuildingFireworks(currentBuildParts, localFireworkScheduleState, buildRng, getCurrentBuildBudget())
```

Replace calls:

```lua
BuildVfxUtil.scheduleLayerFireworks(layer, localFireworkScheduleState, buildRng)
```

with:

```lua
BuildVfxUtil.scheduleLayerFireworks(layer, localFireworkScheduleState, buildRng, getCurrentBuildBudget())
```

For other-player state calls, pass `getCurrentBuildBudget()` as well.

- [ ] **Step 3: Verify all scheduler calls pass budget**

Run:

```bash
rg -n "scheduleLayerFireworks|scheduleBuildingFireworks" src/StarterPlayer/StarterPlayerScripts/Controllers/BuildController.lua src/StarterPlayer/StarterPlayerScripts/Controllers/Build/BuildVfxUtil.lua
```

Expected: every `BuildController` call includes `getCurrentBuildBudget()`.

- [ ] **Step 4: Commit**

```bash
git add src/StarterPlayer/StarterPlayerScripts/Controllers/Build/BuildVfxUtil.lua src/StarterPlayer/StarterPlayerScripts/Controllers/BuildController.lua
git commit -m "perf(build): budget completion effects"
```

## Task 9: Manual QA and Instrumentation

**Files:**
- Modify only if needed after QA: `src/StarterPlayer/StarterPlayerScripts/Controllers/BuildController.lua`
- Modify only if needed after QA: `src/StarterPlayer/StarterPlayerScripts/Controllers/Build/BuildVfxUtil.lua`

- [ ] **Step 1: Start Rojo**

Run:

```bash
./RojoScripts/rojo-manager.sh start
```

Expected: Rojo starts successfully for the project.

- [ ] **Step 2: Verify Studio instance**

Use Roblox Studio MCP:

```text
list_roblox_studios
```

Expected: active or selectable Studio name contains `DB_DEV`.

- [ ] **Step 3: Force Low mode and inspect debug**

In Studio command execution:

```lua
local Knit = require(game.ReplicatedStorage.Packages.Knit)
local BuildController = Knit.GetController("BuildController")
print(BuildController:GetBuildPerformanceDebug().tier)
```

Expected: prints `Low`, `Medium`, or `High` and does not error.

- [ ] **Step 4: Build a large template**

Use the existing building selection flow or dev command to select `Building_106`, enter the build zone, and build for at least 60 seconds.

Expected:

- No Output errors.
- `Workspace` does not accumulate `BuildFlyBrick` after effects finish.
- `Workspace.RunningVFX` does not grow without cleanup.
- Low mode shows coarse/limited effects.
- High mode still shows visible effects but with capped concurrency.

- [ ] **Step 5: Check debug counters during build**

In Studio command execution:

```lua
local Knit = require(game.ReplicatedStorage.Packages.Knit)
local debugState = Knit.GetController("BuildController"):GetBuildPerformanceDebug()
print(debugState.tier, debugState.totalParts, debugState.pendingRevealCount, debugState.vfxCounters.activeFlyingBricks)
```

Expected: counters print numbers; `activeFlyingBricks` stays below the active budget cap.

- [ ] **Step 6: Commit QA fixes if any**

If manual QA required code changes:

```bash
git add src/StarterPlayer/StarterPlayerScripts/Controllers/BuildController.lua src/StarterPlayer/StarterPlayerScripts/Controllers/Build/BuildVfxUtil.lua
git commit -m "fix(build): stabilize performance budget qa"
```

If no code changes were needed, do not create an empty commit.

## Task 10: Final Verification

**Files:**
- No planned code changes.

- [ ] **Step 1: Check git diff**

Run:

```bash
git status --short
```

Expected: only unrelated pre-existing user/runtime changes remain unstaged.

- [ ] **Step 2: Review committed history**

Run:

```bash
git log --oneline -8
```

Expected: the performance optimization commits appear above the spec commits.

- [ ] **Step 3: Summarize verification evidence**

Collect:

- Rojo status.
- Studio Output errors, if any.
- Debug tier and budget counter output.
- Whether `BuildFlyBrick` and `RunningVFX` cleanup passed.

## Self-Review

- Spec coverage: covered performance tiering, player setting plumbing, building stats cache, local reveal budgets, other-player detailed build limits, Heartbeat throttling, VFX caps, debug counters, and manual QA. Server spectator-specific throttling and MeshPart LOD remain explicitly out of scope.
- Completeness scan: no unfinished steps are included. Each code-changing task includes concrete paths and code snippets.
- Type consistency: `PerformanceProfileClient.GetTier()`, `BuildTemplateStats.Get()`, `BuildVfxBudget.GetBudget()`, `BuildController:GetBuildPerformanceDebug()`, and `BuildVfxUtil.getBudgetDebugCounters()` are introduced before later tasks reference them.
