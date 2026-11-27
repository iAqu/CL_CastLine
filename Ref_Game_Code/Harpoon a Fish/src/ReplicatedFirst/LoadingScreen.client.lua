-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ContentProvider = game:GetService("ContentProvider")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local t1 = {
    MIN_TIME = 6,
    EASE = 6,
    ART_IN = 0.35,
    HOLD = 0.25,
    OUT = 0.6,
    TILE = 0.63,
    WARM_MIN = 64,
    STAGES = {
        loaded = 0.1,
        character = 0.2,
        images = 0.2,
        world = 0.15,
        warm = 0.1,
        ground = 0.25
    }
}
local _ = {
    HARPOON = 1.209,
    TIP_X = 0.9951,
    TIP_Y = 0.1665,
    SIZE = 0.7,
    ROPE = 0.1,
    STROKE = 0.035,
    FISH = 0.85,
    BITE = 0.32
}
local LocalPlayer = Players.LocalPlayer
local clone = script:WaitForChild("LoadingGui"):Clone()

clone.Parent = LocalPlayer:WaitForChild("PlayerGui")
ReplicatedFirst:RemoveDefaultLoadingScreen()

local elapsed = os.clock()
local Back = clone:WaitForChild("Fade"):WaitForChild("Back")
local Tile = Back:WaitForChild("Tile")
local Center = Back:WaitForChild("Center")
local Logo = Center:WaitForChild("Logo")
local Bar = Center:WaitForChild("Bar")
local HarpoonLeft = Bar:WaitForChild("HarpoonLeft")
local HarpoonRight = Bar:WaitForChild("HarpoonRight")
local Green = Bar:WaitForChild("Green")
local Red = Bar:WaitForChild("Red")
local Fish = Bar:WaitForChild("Fish")
local Loading = Bar:WaitForChild("Loading")
local _ = {
    STEP = 0.35
}

Loading.Text = string.gsub(Loading.Text, "%.+$", "") .. "..."

local function letters() -- line: 77
    -- upvalues: Loading (copy)
    local LocalizedText = Loading.LocalizedText

    if LocalizedText == "" then
        LocalizedText = Loading.Text
    end

    local v1 = string.gsub(LocalizedText, "%.+$", "")

    if v1 == LocalizedText then
        return nil
    end

    local n1 = 0

    for _ in utf8.graphemes(v1) do
        n1 += 1
    end

    return n1
end

task.spawn(function() -- line: 86
    -- upvalues: Loading (copy)
    local n2 = 0

    while Loading.Parent do
        local LocalizedText = Loading.LocalizedText

        if LocalizedText == "" then
            LocalizedText = Loading.Text
        end

        local v2 = string.gsub(LocalizedText, "%.+$", "")
        local v3

        if v2 ~= LocalizedText then
            v3 = 0

            for _ in utf8.graphemes(v2) do
                v3 += 1
            end
        end

        local v4 = if v3 then v3 + n2 else nil

        Loading.MaxVisibleGraphemes = if not v3 or not v4 then -1 else v4
        n2 = (n2 + 1) % 4
        task.wait(0.35)
    end
end)

local v6 = Bar:GetAttribute("Aspect") or 6.5

local function fit() -- line: 99
    -- upvalues: t1 (copy), clone (copy), Tile (copy), Bar (copy), Green (copy), Red (copy)
    local Y = clone.AbsoluteSize.Y

    if Y > 0 then
        local v9 = math.max(16, (math.floor(Y * t1.TILE + 0.5)))

        Tile.TileSize = UDim2.fromOffset(v9, v9)
    end

    local Y2 = Bar.AbsoluteSize.Y

    for _, v10 in ipairs({ Green, Red }) do
        v10.UIStroke.Thickness = math.max(1, Y2 * 0.035)
    end
end

clone:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
Bar:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
fit()

local t2 = {
    Tile,
    Logo,
    HarpoonLeft,
    HarpoonRight,
    Fish
}

task.spawn(function() -- line: 114
    -- upvalues: ContentProvider (copy), TweenService (copy), t1 (copy), clone (copy), Green (copy), Red (copy), Loading (copy), t2 (copy)
    ContentProvider:PreloadAsync(t2)

    if clone.Parent then
        local v12 = TweenInfo.new(t1.ART_IN, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

        for _, v13 in ipairs(t2) do
            TweenService:Create(v13, v12, {
                ImageTransparency = 0
            }):Play()
        end

        for _, v14 in ipairs({ Green, Red }) do
            TweenService:Create(v14, v12, {
                BackgroundTransparency = 0
            }):Play()
            TweenService:Create(v14.UIStroke, v12, {
                Transparency = 0
            }):Play()
        end

        TweenService:Create(Loading, v12, {
            TextTransparency = 0
        }):Play()

        local UIStroke = Loading:FindFirstChildOfClass("UIStroke")

        if UIStroke then
            TweenService:Create(UIStroke, v12, {
                Transparency = 0
            }):Play()
        end
    end
end)

local t3 = {
    loaded = 0,
    character = 0,
    images = 0,
    world = 0,
    warm = 0,
    ground = 0
}
local v15 = false
local n3 = 0
local v16 = 1 / v6
local v17 = 0.84215313 * v16
local v18 = 1 - v17
local v19 = 0.85 * v16 / 2
local v20 = v17 + v19 * 0.36
local v21 = v18 - v19 * 0.36

HarpoonLeft.Size = UDim2.fromScale(0.8463 * v16, 0.7)
HarpoonRight.Size = HarpoonLeft.Size
Fish.Size = UDim2.fromScale(0.85 * v16, 0.85)

for _, v22 in ipairs({ Green, Red }) do
    v22.Size = UDim2.fromScale(0, 0.1)
end

local connection = RunService.RenderStepped:Connect(function(p1) -- line: 142
    -- upvalues: t1 (copy), elapsed (copy), Green (copy), Red (copy), Fish (copy), t3 (copy), v15 (ref), n3 (ref), v17 (copy), v18 (copy), v20 (copy), v21 (copy)
    local v23 = os.clock() - elapsed
    local v26 = math.min(if v15 then 1 else t1.STAGES.loaded * t3.loaded + t1.STAGES.character * t3.character + t1.STAGES.images * t3.images + t1.STAGES.world * t3.world + t1.STAGES.warm * t3.warm + t1.STAGES.ground * t3.ground, v23 / t1.MIN_TIME)

    n3 += (v26 - n3) * (1 - math.exp(-t1.EASE * p1))

    local v30 = v20 + (v21 - v20) * n3

    Fish.Position = UDim2.fromScale(v30, 0.11655)
    Green.Position = UDim2.fromScale(v17, 0.11655)
    Green.Size = UDim2.fromScale(math.max(0, v30 - v17), 0.1)
    Red.Position = UDim2.fromScale(v30, 0.11655)
    Red.Size = UDim2.fromScale(math.max(0, v18 - v30), 0.1)
end)
local t4 = {}
local v33 = false
local v34

local function freeze(p2) -- line: 197
    -- upvalues: t4 (copy), v33 (ref)
    task.spawn(function() -- line: 198
        -- upvalues: p2 (copy), t4 (copy), v33 (ref)
        local v35 = p2:WaitForChild("HumanoidRootPart", 10)

        if not v35 or v33 then
            return
        end

        v35.Anchored = true
        t4[v35] = true
    end)
end

if LocalPlayer.Character then
    local Character = LocalPlayer.Character

    task.spawn(function() -- line: 198
        -- upvalues: t4 (copy), v33 (ref), Character (copy)
        local v36 = Character:WaitForChild("HumanoidRootPart", 10)

        if not v36 or v33 then
            return
        end

        v36.Anchored = true
        t4[v36] = true
    end)
end

local connection2 = LocalPlayer.CharacterAdded:Connect(freeze)

local function release() -- line: 208
    -- upvalues: LocalPlayer (copy), t4 (copy), v33 (ref), v34 (ref), connection2 (copy)
    v33 = true
    connection2:Disconnect()

    local v37 = LocalPlayer:GetAttribute("Cinematic") == true

    for v38 in pairs(t4) do
        if v38.Parent and not v37 then
            if v34() then
                v38.Anchored = false
            else
                task.spawn(function() -- line: 219
                    -- upvalues: v38 (copy), LocalPlayer (copy), v34 (ref)
                    local elapsed = os.clock()

                    while v38.Parent and not v34() and os.clock() - elapsed < 90 do
                        task.wait(0.25)
                    end

                    if v38.Parent and LocalPlayer:GetAttribute("Cinematic") ~= true then
                        v38.Anchored = false
                    end
                end)
            end
        end
    end

    table.clear(t4)
end

local v39 = RaycastParams.new()

v39.FilterType = Enum.RaycastFilterType.Exclude
v39.IgnoreWater = true

local function islandsUnder(p3) -- line: 236
    local t5 = {}
    local Islands = workspace:FindFirstChild("Islands")

    for _, v40 in ipairs(Islands and Islands:GetDescendants() or {}) do
        if v40:IsA("MeshPart") then
            local v41 = v40.CFrame:PointToObjectSpace(p3)

            if math.abs(v41.X) <= v40.Size.X / 2 and math.abs(v41.Z) <= v40.Size.Z / 2 then
                t5[#t5 + 1] = v40
            end
        end
    end

    return t5
end

v34 = function() -- line: 247
    -- upvalues: LocalPlayer (copy), v39 (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if not (HumanoidRootPart and workspace:FindFirstChild("Islands")) then
        return false
    end

    v39.FilterDescendantsInstances = { Character }

    local v42 = workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -60, 0), v39)

    if not v42 then
        return false
    end

    local Instance = v42.Instance

    return Instance:IsA("Terrain") or Instance:IsA("BasePart") and Instance.CanCollide
end

local t6 = {}

local function mark(p4) -- line: 262
    -- upvalues: elapsed (copy), t6 (copy)
    if not t6[p4] then
        t6[p4] = os.clock() - elapsed
    end
end

local function waitUntil(p5, p6, p7) -- line: 264
    -- upvalues: elapsed (copy)
    p7 = p7 or elapsed

    while not p5() and os.clock() - p7 < p6 do
        task.wait(0.1)
    end

    return p5()
end

local function onScreen(p8) -- line: 271
    while p8 and not p8:IsA("ScreenGui") do
        if p8:IsA("GuiObject") and not p8.Visible then
            return false
        end

        p8 = p8.Parent
    end

    return p8 ~= nil and p8.Enabled
end

local function myPlot() -- line: 279
    -- upvalues: LocalPlayer (copy)
    local Plots = workspace:FindFirstChild("Plots")

    for _, v45 in ipairs(Plots and Plots:GetChildren() or {}) do
        if v45:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
            return v45
        end
    end

    return nil
end

local ScreenGui
local t7 = {}

local function v46() -- line: 289
    -- upvalues: ContentProvider (copy), t1 (copy), LocalPlayer (copy), clone (copy), elapsed (copy), t3 (copy), v34 (ref), islandsUnder (copy), t6 (copy), waitUntil (copy), onScreen (copy), myPlot (copy), ScreenGui (ref), t7 (copy)
    waitUntil(function() -- line: 291
        return game:IsLoaded()
    end, 90)
    t3.loaded = 1

    if not t6.game then
        t6.game = os.clock() - elapsed
    end

    waitUntil(function() -- line: 294
        -- upvalues: LocalPlayer (copy)
        local Character = LocalPlayer.Character

        return Character ~= nil and Character:FindFirstChild("HumanoidRootPart") ~= nil
    end, 90)
    t3.character = 0.4

    if not t6.char then
        t6.char = os.clock() - elapsed
    end

    local Character = LocalPlayer.Character
    local v47 = false

    task.spawn(function() -- line: 304
        -- upvalues: v47 (ref), elapsed (copy), t3 (copy), v34 (ref), t6 (copy), waitUntil (copy)
        if waitUntil(v34, 30, os.clock()) and not t6.ground then
            t6.ground = os.clock() - elapsed
        end

        t3.ground = 1
        v47 = true
    end)

    local v48 = Character == nil

    task.spawn(function() -- line: 315
        -- upvalues: Character (copy), v48 (ref), ContentProvider (copy), elapsed (copy), t3 (copy), t6 (copy), waitUntil (copy)
        if Character then
            waitUntil(function() -- line: 317
                -- upvalues: Character (copy)
                return not Character.Parent or Character:GetAttribute("BodyApplied") == true
            end, 12)
            t3.character = 0.7

            local function v49() -- line: 319
                -- upvalues: Character (copy), ContentProvider (copy)
                ContentProvider:PreloadAsync({
                    Character
                })
            end

            pcall(v49)
            t3.character = 1

            if not t6.body then
                t6.body = os.clock() - elapsed
            end

            v48 = true
        end
    end)

    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local t8 = {}
    local t9 = {}
    local t10 = {}

    for _, child in ipairs(PlayerGui:GetChildren()) do
        if child:IsA("ScreenGui") and child ~= clone then
            for _, descendant in ipairs(child:GetDescendants()) do
                if (descendant:IsA("ImageLabel") or descendant:IsA("ImageButton")) and descendant.Image ~= "" then
                    if onScreen(descendant) then
                        if not t9[descendant.Image] then
                            t9[descendant.Image] = descendant
                            t8[#t8 + 1] = descendant.Image
                        end
                    elseif not t10[descendant.Image] then
                        t10[descendant.Image] = true
                    end
                end
            end
        end
    end

    for v50 in pairs(t10) do
        if not t9[v50] then
            t7[#t7 + 1] = v50
        end
    end

    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LoadingWarm"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = clone.DisplayOrder - 1
    ScreenGui.ScreenInsets = Enum.ScreenInsets.None

    for v51, v52 in pairs(t9) do
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = v51

        local AbsoluteSize = v52.AbsoluteSize

        ImageLabel.Size = UDim2.fromOffset(math.max(t1.WARM_MIN, AbsoluteSize.X), (math.max(t1.WARM_MIN, AbsoluteSize.Y)))
        ImageLabel.Parent = ScreenGui
    end

    ScreenGui.Parent = PlayerGui

    local v54 = #t8 == 0

    task.spawn(function() -- line: 365
        -- upvalues: t8 (copy), v54 (ref), ContentProvider (copy), elapsed (copy), t3 (copy), t6 (copy)
        local n4 = 0

        local function v55() -- line: 367
            -- upvalues: n4 (ref), t8 (copy), ContentProvider (copy), t3 (copy)
            ContentProvider:PreloadAsync(t8, function() -- line: 368
                -- upvalues: n4 (ref), t8 (copy), t3 (copy)
                n4 += 1

                local v57 = n4

                t3.images = math.min(1, v57 / #t8)
            end)
        end

        pcall(v55)
        t3.images = 1

        if not t6.images then
            t6.images = os.clock() - elapsed
        end

        v54 = true
    end)

    local t11 = {}
    local v58 = myPlot()

    if v58 then
        t11[#t11 + 1] = v58
    end

    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    for _, v59 in ipairs(HumanoidRootPart and islandsUnder(HumanoidRootPart.Position) or {}) do
        t11[#t11 + 1] = v59
    end

    local v60 = #t11 == 0

    task.spawn(function() -- line: 387
        -- upvalues: t11 (copy), v60 (ref), ContentProvider (copy), elapsed (copy), t3 (copy), t6 (copy)
        local function v61() -- line: 388
            -- upvalues: t11 (copy), ContentProvider (copy)
            ContentProvider:PreloadAsync(t11)
        end

        pcall(v61)
        t3.world = 1

        if not t6.world then
            t6.world = os.clock() - elapsed
        end

        v60 = true
    end)

    local v62 = false

    task.spawn(function() -- line: 396
        -- upvalues: v62 (ref), LocalPlayer (copy), elapsed (copy), t3 (copy), t6 (copy), waitUntil (copy)
        waitUntil(function() -- line: 397
            -- upvalues: LocalPlayer (copy), t3 (copy)
            local n5 = 0
            local n6 = 0

            for v63, v64 in pairs(LocalPlayer:GetAttributes()) do
                if string.sub(v63, 1, 5) == "Warm_" then
                    n5 += 1

                    if v64 ~= true then
                        n6 += 1
                    end
                end
            end

            t3.warm = if n5 == 0 then 1 else (n5 - n6) / n5

            return n6 == 0
        end, 12)

        if not t6.warm then
            t6.warm = os.clock() - elapsed
        end

        v62 = true
    end)
    t6.cut = waitUntil(function() -- line: 413
        -- upvalues: v48 (ref), v54 (ref), v60 (ref), v62 (ref)
        return v48 and v54 and v60 and v62
    end, 12) and 0 or 1
    waitUntil(function() -- line: 415
        -- upvalues: v47 (ref)
        return v47
    end, 31, os.clock())
end

local ok, result = pcall(v46)

if not ok then
    warn("[LoadingScreen] the wait failed, finishing anyway: " .. tostring(result))
    t6.err = 1
end

LocalPlayer:SetAttribute("LoadingDone", true)

if not t6.done then
    t6.done = os.clock() - elapsed
end

v15 = true
task.spawn(function() -- line: 427
    local v67 = game:GetService("ReplicatedStorage"):WaitForChild("Modules", 10)
    local v68 = v67 and v67:WaitForChild("Funnel", 10)

    if v68 then
        local function v69() -- line: 430
            -- upvalues: v68 (copy)
            require(v68).Report("loaded")
        end

        pcall(v69)
    end
end)

local elapsed2 = os.clock()

while n3 < 0.995 and os.clock() - elapsed2 < 2 do
    task.wait()
end

task.wait(t1.HOLD)

if ScreenGui then
    ScreenGui:Destroy()
end

local v70 = TweenInfo.new(t1.OUT, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

TweenService:Create(Back, v70, {
    BackgroundTransparency = 1
}):Play()

for _, v71 in ipairs(t2) do
    TweenService:Create(v71, v70, {
        ImageTransparency = 1
    }):Play()
end

for _, v72 in ipairs({ Green, Red }) do
    TweenService:Create(v72, v70, {
        BackgroundTransparency = 1
    }):Play()
    TweenService:Create(v72.UIStroke, v70, {
        Transparency = 1
    }):Play()
end

TweenService:Create(Loading, v70, {
    TextTransparency = 1
}):Play()

local UIStroke = Loading:FindFirstChildOfClass("UIStroke")

if UIStroke then
    TweenService:Create(UIStroke, v70, {
        Transparency = 1
    }):Play()
end

task.wait(t1.OUT)
connection:Disconnect()
clone:Destroy()
release()

if not t6.gone then
    t6.gone = os.clock() - elapsed
end

task.spawn(function() -- line: 451
    -- upvalues: t6 (copy)
    local v73 = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 30)
    local v74 = v73 and v73:WaitForChild("TelemetryReport", 30)

    if v74 then
        v74:FireServer("loading", t6)
    end
end)

if #t7 > 0 then
    local function v75() -- line: 457
        -- upvalues: ContentProvider (copy), t7 (copy)
        ContentProvider:PreloadAsync(t7)
    end

    pcall(v75)
end
