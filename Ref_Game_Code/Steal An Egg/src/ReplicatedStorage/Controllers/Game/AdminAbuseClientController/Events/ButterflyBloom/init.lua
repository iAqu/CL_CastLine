-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local ButterflyCatalog = require(ReplicatedStorage.Shared.Modules.ButterflyCatalog)
local ButterflyFlags = require(ReplicatedStorage.Shared.Flags.ButterflyFlags)
local CatchFX = require(script.CatchFX)
local Net = require(script.Net)
local Player = require(ReplicatedStorage.Shared.Player)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Swarm = require(script.Swarm)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local Butterflies = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("VFX"):WaitForChild("Butterflies")
local v1 = Trove.new()
local v2 = Trove.new()
local v3 = false
local n1 = 0
local v4 = false
local v5 = false
local v6 = false
local n2 = 0
local t1 = {}

local function isEligible() -- line: 56
    -- upvalues: ButterflyFlags (copy), Save (copy)
    if ButterflyFlags.Enabled:Get() and Save.IsLoaded() then
        local v7 = Save.Peek()
        local Butterflies = if v7 then v7.Butterflies else nil

        if typeof(Butterflies) == "table" then
            return Butterflies.NetClaimed == true
        end

        return false
    end

    return false
end

local function findBounds() -- line: 65
    -- upvalues: Workspace (copy)
    local World = Workspace:FindFirstChild("World")
    local Areas = World and World:FindFirstChild("Areas")
    local ButterflyBloom = Areas and Areas:FindFirstChild("ButterflyBloom")
    local Bounds = ButterflyBloom and ButterflyBloom:FindFirstChild("Bounds")

    return if Bounds and Bounds:IsA("BasePart") then Bounds else nil
end

local function distanceOutside(p1, p2) -- line: 76
    local v8 = p1.CFrame:PointToObjectSpace(p2)
    local v9 = p1.Size / 2

    return Vector3.new(math.max(math.abs(v8.X) - v9.X, 0), 0, (math.max(math.abs(v8.Z) - v9.Z, 0))).Magnitude
end

local function buildGrade() -- line: 87
    -- upvalues: Lighting (copy), Butterflies (copy)
    local Grade = Butterflies:FindFirstChild("Grade")
    local v14 = if not (Grade and Grade:IsA("ColorCorrectionEffect")) then Instance.new("ColorCorrectionEffect") else Grade:Clone()

    v14.Name = "ButterflyBloomGrade"
    v14.Enabled = true
    v14.Parent = Lighting

    return v14
end

local function distanceFromForest(p3, p4) -- line: 98
    local n3 = 1e999

    for _, v15 in p3 do
        local v16 = v15.CFrame:PointToObjectSpace(p4)
        local v17 = v15.Size / 2

        n3 = math.min(n3, Vector3.new(math.max(math.abs(v16.X) - v17.X, 0), math.max(math.abs(v16.Y) - v17.Y, 0), (math.max(math.abs(v16.Z) - v17.Z, 0))).Magnitude)
    end

    return n3
end

local function fadeForest(p5, p6) -- line: 113
    for v24, v25 in p5 do
        local t2 = {}

        for _, v26 in v25.Keypoints do
            table.insert(t2, NumberSequenceKeypoint.new(v26.Time, 1 - (1 - v26.Value) * p6, v26.Envelope * p6))
        end

        v24.Transparency = NumberSequence.new(t2)
    end
end

local function startForest() -- line: 130
    -- upvalues: TweenService (copy), Workspace (copy), Butterflies (copy), v2 (copy), v5 (ref), distanceFromForest (copy), fadeForest (copy)
    local Forest = Butterflies:FindFirstChild("Forest")

    if v5 or Forest == nil then
        return
    end

    v5 = true

    local clone = Forest:Clone()
    local t3 = {}
    local t4 = {}
    local t5 = {}
    local n4 = 1.5
    local n5 = 1.5

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(t5, descendant)
        elseif descendant:IsA("Beam") then
            t3[descendant] = descendant.Transparency
        elseif descendant:IsA("ParticleEmitter") then
            table.insert(t4, descendant)
            n5 = math.max(n5, descendant.Lifetime.Max)
            n4 = n5
        end
    end

    local NumberValue = Instance.new("NumberValue")

    NumberValue.Changed:Connect(function(p7) -- line: 152
        -- upvalues: t3 (copy), fadeForest (copy)
        fadeForest(t3, p7)
    end)
    fadeForest(t3, 0)
    clone.Parent = Workspace
    TweenService:Create(NumberValue, TweenInfo.new(1.5), {
        Value = 1
    }):Play()
    v2:Add(task.spawn(function() -- line: 158
        -- upvalues: t4 (copy), t5 (copy), Workspace (copy), distanceFromForest (copy)
        local v30

        while true do
            local CurrentCamera = Workspace.CurrentCamera
            local v31 = CurrentCamera == nil or distanceFromForest(t5, CurrentCamera.CFrame.Position) <= 350

            if v31 ~= v30 then
                v30 = v31

                for _, v32 in t4 do
                    v30 = v31
                    v32.Enabled = v31
                end
            end

            task.wait(0.5)
        end
    end))
    v2:Add(function() -- line: 173
        -- upvalues: clone (copy), t4 (copy), n4 (ref), NumberValue (copy), TweenService (copy)
        for _, v33 in t4 do
            v33.Enabled = false
        end

        TweenService:Create(NumberValue, TweenInfo.new(1.5), {
            Value = 0
        }):Play()
        task.delay(n4, function() -- line: 178
            -- upvalues: clone (copy), NumberValue (copy)
            NumberValue:Destroy()
            clone:Destroy()
        end)
    end)
end

local function stopForest() -- line: 185
    -- upvalues: v2 (copy), v5 (ref)
    if v5 then
        v5 = false
        v2:Clean()
    end
end

local function addFlight(p8) -- line: 193
    -- upvalues: Swarm (copy), v4 (ref)
    if v4 then
        Swarm.Add(p8)
    end
end

local function fetchSwarm() -- line: 199
    -- upvalues: Remotes (copy), Swarm (copy), v4 (ref), n2 (ref)
    n2 += 1

    local v34 = n2

    task.spawn(function() -- line: 202
        -- upvalues: v34 (copy), Remotes (copy), Swarm (copy), v4 (ref), n2 (ref)
        local function v35() -- line: 203
            -- upvalues: Remotes (copy)
            return Remotes.Butterflies.AskSwarm:InvokeServer()
        end

        local ok, result = pcall(v35)

        if ok and v34 == n2 and v4 and typeof(result) == "table" then
            for _, v36 in result do
                if v4 then
                    Swarm.Add(v36)
                end
            end
        end
    end)
end

local function stopPresentation() -- line: 215
    -- upvalues: Net (copy), Swarm (copy), v1 (copy), v4 (ref)
    if not v4 then
        return
    end

    v4 = false
    Net.SetPresenting(false)
    v1:Clean()
    Swarm.Clear(false)
end

local function startPresentation() -- line: 225
    -- upvalues: Lighting (copy), RunService (copy), TweenService (copy), Workspace (copy), Audio (copy), ButterflyCatalog (copy), CatchFX (copy), Net (copy), Player (copy), Remotes (copy), Swarm (copy), LocalPlayer (copy), Butterflies (copy), v1 (copy), n1 (ref), v4 (ref), v6 (ref), n2 (ref), findBounds (copy)
    if v4 then
        return
    end

    v4 = true
    Net.SetPresenting(true)

    local v37 = findBounds()
    local Grade = Butterflies:FindFirstChild("Grade")
    local v38 = if not (Grade and Grade:IsA("ColorCorrectionEffect")) then Instance.new("ColorCorrectionEffect") else Grade:Clone()

    v38.Name = "ButterflyBloomGrade"
    v38.Enabled = true
    v38.Parent = Lighting

    local TintColor, Saturation, Brightness, Contrast = v38.TintColor, v38.Saturation, v38.Brightness, v38.Contrast
    local n6 = 0

    v38.TintColor = Color3.new(1, 1, 1)
    v38.Saturation = 0
    v38.Brightness = 0
    v38.Contrast = 0
    v1:Add(function() -- line: 242
        -- upvalues: v38 (copy), TweenService (copy)
        local tween = TweenService:Create(v38, TweenInfo.new(1.2), {
            Saturation = 0,
            Brightness = 0,
            Contrast = 0,
            TintColor = Color3.new(1, 1, 1)
        })

        tween:Play()
        tween.Completed:Once(function() -- line: 250
            -- upvalues: v38 (copy)
            v38:Destroy()
        end)
    end)

    local v39 = Audio.Play(ButterflyCatalog.Sounds.Ambience, script, {
        Looped = true,
        Volume = 0
    })

    if v39 then
        v1:Add(function() -- line: 259
            -- upvalues: v39 (copy), TweenService (copy)
            local tween = TweenService:Create(v39, TweenInfo.new(1), {
                Volume = 0
            })

            tween:Play()
            tween.Completed:Once(function() -- line: 262
                -- upvalues: v39 (copy)
                v39:Destroy()
            end)
        end)
    end

    local n7 = -1

    v1:Connect(RunService.RenderStepped, function() -- line: 268
        -- upvalues: v37 (copy), v38 (copy), TintColor (copy), Saturation (copy), Brightness (copy), Contrast (copy), n6 (ref), v39 (copy), n7 (ref), Workspace (copy), CatchFX (copy), Net (copy), Player (copy), Swarm (copy), LocalPlayer (copy), n1 (ref), v6 (ref)
        local elapsed = os.clock()
        local ServerTimeNow = Workspace:GetServerTimeNow()

        Swarm.Step(ServerTimeNow, elapsed)
        Net.Step(elapsed)

        local v40 = Player.FindRootPart(LocalPlayer)
        local v41 = 0

        if v37 and v40 then
            local Position = v40.Position
            local v42 = v37.CFrame:PointToObjectSpace(Position)
            local v43 = v37.Size / 2

            v41 = 1 - math.clamp(Vector3.new(math.max(math.abs(v42.X) - v43.X, 0), 0, (math.max(math.abs(v42.Z) - v43.Z, 0))).Magnitude / 45, 0, 1)
        end

        n6 += (v41 - n6) * 0.06

        if math.abs(v41 - n6) < 0.001 then
            n6 = v41
        end

        if n6 ~= n7 then
            n7 = n6
            v38.TintColor = Color3.new(1, 1, 1):Lerp(TintColor, n6)
            v38.Saturation = Saturation * n6
            v38.Brightness = Brightness * n6
            v38.Contrast = Contrast * n6

            if v39 then
                v39.Volume = n6 * 1
            end
        end

        if not v6 and n1 - ServerTimeNow <= 30 then
            v6 = true
            CatchFX.Announce("Ending")
        end
    end)
    n2 += 1

    local v51 = n2

    task.spawn(function() -- line: 202
        -- upvalues: v51 (copy), Remotes (copy), Swarm (copy), v4 (ref), n2 (ref)
        local function v52() -- line: 203
            -- upvalues: Remotes (copy)
            return Remotes.Butterflies.AskSwarm:InvokeServer()
        end

        local ok, result = pcall(v52)

        if ok and v51 == n2 and v4 and typeof(result) == "table" then
            for _, v53 in result do
                if v4 then
                    Swarm.Add(v53)
                end
            end
        end
    end)
end

local function refresh() -- line: 301
    -- upvalues: ButterflyFlags (copy), Net (copy), Save (copy), Swarm (copy), v1 (copy), v3 (ref), v4 (ref), startPresentation (copy)
    if v3 and ButterflyFlags.Enabled:Get() and Save.IsLoaded() then
        local v54 = Save.Peek()
        local Butterflies = if v54 then v54.Butterflies else nil

        if typeof(Butterflies) == "table" and Butterflies.NetClaimed == true then
            startPresentation()

            return
        end
    end

    if not v4 then
        return
    end

    v4 = false
    Net.SetPresenting(false)
    v1:Clean()
    Swarm.Clear(false)
end

function t1.StartEvent(_, p10, _) -- line: 313
    -- upvalues: Workspace (copy), ButterflyFlags (copy), Net (copy), Save (copy), Swarm (copy), v1 (copy), v3 (ref), n1 (ref), v4 (ref), v6 (ref), startForest (copy), startPresentation (copy)
    v3 = true
    n1 = Workspace:GetServerTimeNow() + p10
    v6 = p10 <= 30
    startForest()

    if v3 and ButterflyFlags.Enabled:Get() and Save.IsLoaded() then
        local v55 = Save.Peek()
        local Butterflies = if v55 then v55.Butterflies else nil

        if typeof(Butterflies) == "table" and Butterflies.NetClaimed == true then
            startPresentation()

            return
        end
    end

    if not v4 then
        return
    end

    v4 = false
    Net.SetPresenting(false)
    v1:Clean()
    Swarm.Clear(false)
end

function t1.StopEvent(_) -- line: 321
    -- upvalues: Net (copy), Swarm (copy), v1 (copy), v2 (copy), v3 (ref), v4 (ref), v5 (ref)
    v3 = false

    if v5 then
        v5 = false
        v2:Clean()
    end

    if not v4 then
        return
    end

    v4 = false
    Net.SetPresenting(false)
    v1:Clean()
    Swarm.Clear(false)
end

Net.Start()
Remotes.Butterflies.Spawned.OnClientEvent:Connect(addFlight)
Remotes.Butterflies.Escaped.OnClientEvent:Connect(function(p13) -- line: 335
    -- upvalues: Swarm (copy), v4 (ref)
    if v4 then
        Swarm.Update(p13)
    end
end)
Remotes.Butterflies.Removed.OnClientEvent:Connect(function(p14, p15, p16) -- line: 342
    -- upvalues: Swarm (copy), LocalPlayer (copy)
    if p16 ~= LocalPlayer.UserId or p15 ~= "Caught" then
        Swarm.Remove(p14)
    end
end)
Remotes.Butterflies.Announce.OnClientEvent:Connect(function(p17) -- line: 350
    -- upvalues: ButterflyFlags (copy), CatchFX (copy), Save (copy)
    if p17 ~= "Start" and p17 ~= "End" and p17 ~= "Golden" then
        return
    end

    if ButterflyFlags.Enabled:Get() and Save.IsLoaded() then
        local v56 = Save.Peek()
        local Butterflies = if v56 then v56.Butterflies else nil

        if typeof(Butterflies) == "table" and Butterflies.NetClaimed == true then
            CatchFX.Announce(p17)
        end
    end
end)
Remotes.Butterflies.NetClaimed.OnClientEvent:Connect(function() -- line: 358
    -- upvalues: refresh (copy)
    task.defer(refresh)
end)
Save.WatchFields("Butterflies", refresh)
Save.Loaded:Connect(function(p18) -- line: 363
    -- upvalues: ButterflyFlags (copy), Net (copy), Save (copy), Swarm (copy), LocalPlayer (copy), v1 (copy), v3 (ref), v4 (ref), startPresentation (copy)
    if p18 ~= LocalPlayer then
        return
    end

    if v3 and ButterflyFlags.Enabled:Get() and Save.IsLoaded() then
        local v57 = Save.Peek()
        local Butterflies = if v57 then v57.Butterflies else nil

        if typeof(Butterflies) == "table" and Butterflies.NetClaimed == true then
            startPresentation()

            return
        end
    end

    if not v4 then
        return
    end

    v4 = false
    Net.SetPresenting(false)
    v1:Clean()
    Swarm.Clear(false)
end)

return t1
