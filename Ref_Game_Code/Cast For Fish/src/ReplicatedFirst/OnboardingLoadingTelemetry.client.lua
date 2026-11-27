-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local OnboardingLoadingHooks = require(script.Parent:WaitForChild("OnboardingLoadingHooks"))
local LocalPlayer = Players.LocalPlayer
local elapsed = os.clock()
local t1 = {}
local n1 = 0
local elapsed2 = os.clock()
local elapsed3, elapsed4

if game:IsLoaded() then
    elapsed4 = os.clock()
    elapsed3 = elapsed4
else
    elapsed3 = nil
end

local v1

local function since(p1) -- line: 28
    -- upvalues: elapsed (copy)
    return if p1 ~= nil then math.round((p1 - elapsed) * 100) / 100 else nil
end

local function push(p2) -- line: 35
    -- upvalues: elapsed (copy), t1 (ref)
    if #t1 >= 150 then
        return
    end

    p2.k = "Load"

    local elapsed2 = os.clock()

    if elapsed2 ~= nil then
        p2.t = math.round((elapsed2 - elapsed) * 100) / 100
    else
        p2.t = nil
    end

    table.insert(t1, p2)
end

local function memory() -- line: 44
    -- upvalues: Stats (copy)
    local function v4() -- line: 45
        -- upvalues: Stats (copy)
        return Stats:GetTotalMemoryUsageMb()
    end

    local ok, result = pcall(v4)

    if ok then
        return (math.round(result))
    end

    return -1
end

local function quality() -- line: 51
    local function v5() -- line: 52
        return UserSettings():GetService("UserGameSettings").SavedQualityLevel.Value
    end

    local ok, result = pcall(v5)

    return if ok then result else nil
end

local connection = RunService.RenderStepped:Connect(function() -- line: 58
    -- upvalues: n1 (ref)
    n1 += 1
end)

if elapsed4 == nil then
    task.spawn(function() -- line: 63
        -- upvalues: elapsed3 (ref)
        game.Loaded:Wait()
        elapsed3 = os.clock()
    end)
end

task.spawn(function() -- line: 68
    -- upvalues: LocalPlayer (copy), v1 (ref)
    LocalPlayer.CharacterAdded:Wait()
    v1 = v1 or os.clock()
end)

if LocalPlayer.Character ~= nil then
    v1 = os.clock()
end

local t3 = {
    phase = "start"
}

local function v6() -- line: 52
    return UserSettings():GetService("UserGameSettings").SavedQualityLevel.Value
end

local ok, result = pcall(v6)

t3.gfx = if not ok then nil else result

local function v7() -- line: 45
    -- upvalues: Stats (copy)
    return Stats:GetTotalMemoryUsageMb()
end

local ok2, result2 = pcall(v7)

t3.mem = if ok2 then math.round(result2) else -1

if not (#t1 >= 150) then
    t3.k = "Load"

    local elapsed2 = os.clock()

    t3.t = if elapsed2 == nil then nil else math.round((elapsed2 - elapsed) * 100) / 100
    table.insert(t1, t3)
end

local v9 = false

local function trySendDevice() -- line: 80
    -- upvalues: GuiService (copy), UserInputService (copy), Workspace (copy), elapsed (copy), t1 (ref), v9 (ref)
    local CurrentCamera = Workspace.CurrentCamera

    if v9 or CurrentCamera == nil or CurrentCamera.ViewportSize.X < 10 then
        return
    end

    v9 = true

    local t5 = {
        phase = "device",
        touch = UserInputService.TouchEnabled,
        mouse = UserInputService.MouseEnabled,
        pad = UserInputService.GamepadEnabled,
        tenFoot = GuiService:IsTenFootInterface(),
        vx = math.round(CurrentCamera.ViewportSize.X),
        vy = math.round(CurrentCamera.ViewportSize.Y)
    }

    local function v10() -- line: 52
        return UserSettings():GetService("UserGameSettings").SavedQualityLevel.Value
    end

    local ok, result = pcall(v10)

    t5.gfx = if not ok then nil else result

    if #t1 >= 150 then
        return
    end

    t5.k = "Load"

    local elapsed2 = os.clock()

    t5.t = if elapsed2 == nil then nil else math.round((elapsed2 - elapsed) * 100) / 100
    table.insert(t1, t5)
end

local v12

task.spawn(function() -- line: 99
    -- upvalues: ReplicatedStorage (copy), v12 (ref)
    local v13 = ReplicatedStorage:WaitForChild("OnboardingKit", 60)

    v12 = v13 and v13:WaitForChild("Push", 60)
end)

local function flush() -- line: 104
    -- upvalues: LocalPlayer (copy), elapsed (copy), t1 (ref), v12 (ref)
    if v12 == nil or #t1 == 0 or LocalPlayer:GetAttribute("OnboardingRecording") ~= true then
        return
    end

    local t7 = t1

    t1 = {}

    local function v14() -- line: 110
        -- upvalues: t7 (copy), elapsed (copy), v12 (ref)
        local v15 = v12
        local t8 = {
            src = "load"
        }
        local elapsed2 = os.clock()

        t8.now = if elapsed2 == nil then nil else math.round((elapsed2 - elapsed) * 100) / 100
        t8.events = t7
        v15:FireServer(t8)
    end

    pcall(v14)
end

local function closedAt() -- line: 115
    -- upvalues: OnboardingLoadingHooks (copy), elapsed3 (ref), v1 (ref)
    if OnboardingLoadingHooks.closedAt ~= nil then
        return OnboardingLoadingHooks.closedAt
    end

    return if not OnboardingLoadingHooks.used and elapsed3 ~= nil and v1 ~= nil and os.clock() - v1 >= 2 then math.max(elapsed3, v1) else nil
end

local n2 = 0
local v18 = false
local n3 = 0

while true do
    if os.clock() - elapsed < 180 then
        task.wait(0.25)

        local elapsed4 = os.clock()

        trySendDevice()

        local v19, t9, v20
        local elapsed5 = elapsed2
        local v21 = n2

        if v18 then
        elseif elapsed4 - elapsed2 >= 2 then
            elapsed5 = elapsed4
            v19 = elapsed4 - elapsed2
            t9 = {
                phase = "tick",
                assets = OnboardingLoadingHooks.assetsLoaded,
                total = OnboardingLoadingHooks.assetsTotal
            }
            v20 = elapsed3 ~= nil
            t9.gameLoaded = v20
            t9.ready = OnboardingLoadingHooks.appReadyAt ~= nil

            local v22 = math.max(v19, 0.001)

            t9.fps = math.round(n1 / v22)

            local function v24() -- line: 45
                -- upvalues: Stats (copy)
                return Stats:GetTotalMemoryUsageMb()
            end

            local ok, result = pcall(v24)

            if ok then
                t9.mem = math.round(result)
            else
                t9.mem = -1
            end

            if not (#t1 >= 150) then
                t9.k = "Load"

                local elapsed2 = os.clock()

                if elapsed2 == nil then
                    t9.t = nil
                else
                    t9.t = math.round((elapsed2 - elapsed) * 100) / 100
                end

                table.insert(t1, t9)
            end

            n1 = 0
            v21 = 0
        end

        local v26 = if OnboardingLoadingHooks.closedAt ~= nil then OnboardingLoadingHooks.closedAt elseif not OnboardingLoadingHooks.used and elapsed3 ~= nil and v1 ~= nil and os.clock() - v1 >= 2 then math.max(elapsed3, v1) else nil

        if not v18 and v26 ~= nil then
            local t11 = {
                phase = "done",
                screen = OnboardingLoadingHooks.used
            }
            local elapsed2 = elapsed3

            t11.gameLoadedAt = if elapsed2 == nil then nil else math.round((elapsed2 - elapsed) * 100) / 100

            local v29 = v1

            t11.characterAt = if v29 == nil then nil else math.round((v29 - elapsed) * 100) / 100

            local appReadyAt = OnboardingLoadingHooks.appReadyAt

            t11.appReadyAt = if appReadyAt == nil then nil else math.round((appReadyAt - elapsed) * 100) / 100
            t11.closedAt = if v26 == nil then nil else math.round((v26 - elapsed) * 100) / 100
            t11.assets = OnboardingLoadingHooks.assetsLoaded
            t11.total = OnboardingLoadingHooks.assetsTotal
            t11.skipped = OnboardingLoadingHooks.skipped
            t11.timedOut = OnboardingLoadingHooks.timedOut

            local function v33() -- line: 45
                -- upvalues: Stats (copy)
                return Stats:GetTotalMemoryUsageMb()
            end

            local ok, result = pcall(v33)

            t11.mem = if ok then math.round(result) else -1

            if not (#t1 >= 150) then
                t11.k = "Load"

                local elapsed2 = os.clock()

                t11.t = if elapsed2 == nil then nil else math.round((elapsed2 - elapsed) * 100) / 100
                table.insert(t1, t11)
            end

            v18 = true
        end

        if elapsed4 - n3 >= 3.5 then
            n3 = elapsed4
            flush()
        end

        if not v18 or #t1 ~= 0 then
            n2 = v21
            elapsed2 = elapsed5
            continue
        end
    end

    break
end

connection:Disconnect()
