-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReleaseConfig = require(ReplicatedStorage.Config.ReleaseConfig)
local ReleaseReach = require(ReplicatedStorage.Shared.ReleaseReach)
local Signal = require(ReplicatedStorage.Shared.Signal)
local DataController = require(script.Parent.DataController)
local t1 = {
    MapReady = Signal.new()
}
local LocalPlayer = Players.LocalPlayer
local t2 = {}
local t3 = {}
local t4 = {}

function t1.SetTestCountdown(p1, p2) -- line: 48
    -- upvalues: t2 (copy)
    t2[p1] = p2 and os.clock() + p2 or nil
end

local function countdownText(p3) -- line: 52
    -- upvalues: ReleaseConfig (copy), t2 (copy)
    local v2 = t2[p3]

    if v2 then
        return ReleaseConfig.FormatTime((math.max(0, v2 - os.clock())))
    end

    local v4 = ReleaseConfig.TimeLeft(p3)

    if v4 == nil then
        return "SOON"
    end

    return ReleaseConfig.FormatTime(v4)
end

local function resolve(p4) -- line: 65
    local v5

    for match in string.gmatch(p4 or "", "[^%.]+") do
        if v5 ~= nil then
            v5 = v5:FindFirstChild(match) or v5:WaitForChild(match, 10)
        else
            local GetService = game.GetService
            local _game = game
            local ok, result = pcall(GetService, _game, match)

            v5 = ok and result or nil
        end

        if not v5 then
            return nil
        end
    end

    return v5
end

local function watchSlot(p5) -- line: 79
    -- upvalues: t4 (copy), resolve (copy)
    if p5:IsA("Folder") then
        local Name = p5.Parent and p5.Parent.Name or "?"
        local v6

        local function place(p6) -- line: 83
            -- upvalues: p5 (copy), Name (copy), v6 (ref), t4 (copy), resolve (copy)
            v6 = v6 or resolve(p5:GetAttribute("Into"))

            if v6 then
                t4[Name] = t4[Name] or {}
                table.insert(t4[Name], p6)
                p6.Parent = v6

                return
            end

            warn("[ReleaseController] no place for " .. p6.Name .. " (" .. tostring(p5:GetAttribute("Into")) .. ")")
        end

        p5.ChildAdded:Connect(function(p7) -- line: 93
            -- upvalues: place (copy)
            task.spawn(place, p7)
        end)

        for _, child in ipairs(p5:GetChildren()) do
            task.spawn(place, child)
        end
    end
end

local function watchGroup(p8) -- line: 97
    -- upvalues: t1 (copy), t3 (copy), watchSlot (copy)
    if p8:IsA("Folder") then
        local Name = p8.Name

        t3[Name] = "Arriving"
        p8.ChildAdded:Connect(watchSlot)

        for _, child in ipairs(p8:GetChildren()) do
            watchSlot(child)
        end

        local function check() -- line: 103
            -- upvalues: p8 (copy), Name (copy), t1 (copy), t3 (copy)
            if p8:GetAttribute("Complete") and t3[Name] ~= "Ready" then
                task.delay(0.5, function() -- line: 106
                    -- upvalues: Name (copy), t1 (copy), t3 (copy)
                    t3[Name] = "Ready"
                    t1.MapReady:Fire(Name)
                end)
            end
        end

        p8:GetAttributeChangedSignal("Complete"):Connect(check)

        if p8:GetAttribute("Complete") and t3[Name] ~= "Ready" then
            task.delay(0.5, function() -- line: 106
                -- upvalues: Name (copy), t1 (copy), t3 (copy)
                t3[Name] = "Ready"
                t1.MapReady:Fire(Name)
            end)
        end
    end
end

local function hookContainer(p9) -- line: 116
    -- upvalues: watchGroup (copy)
    p9.ChildAdded:Connect(watchGroup)

    for _, child in ipairs(p9:GetChildren()) do
        watchGroup(child)
    end
end

local function sentByProgress(p10) -- line: 122
    -- upvalues: ReleaseConfig (copy)
    return ReleaseConfig.ByProgress[p10] ~= nil and not ReleaseConfig.IsDevOpen(p10)
end

function t1.HasMap(p11) -- line: 126
    -- upvalues: ReleaseConfig (copy), t3 (copy)
    if not ReleaseConfig.IsUnlocked(p11) then
        return false
    end

    if ReleaseConfig.ByProgress[p11] ~= nil and not ReleaseConfig.IsDevOpen(p11) then
        return t3[p11] == "Ready"
    end

    return true
end

function t1.WaitForMap(p12, p13) -- line: 134
    -- upvalues: ReleaseConfig (copy), ReleaseReach (copy), DataController (copy), t1 (copy)
    local v8 = os.clock() + (p13 or 30)

    while true do
        if t1.HasMap(p12) then
            return true
        end

        if v8 < os.clock() then
            break
        end

        if ReleaseConfig.ByProgress[p12] ~= nil and not ReleaseConfig.IsDevOpen(p12) and ReleaseConfig.IsUnlocked(p12) then
            local v9 = ReleaseConfig.ByProgress[p12]

            if not ReleaseReach.Reaches(DataController:Get("Level") or 1, v9.FromArea) then
                return false
            end
        end

        task.wait(0.25)
    end

    return false
end

function t1.ClearGroup(p14) -- line: 148
    -- upvalues: t3 (copy), t4 (copy)
    for _, v10 in ipairs(t4[p14] or {}) do
        v10:Destroy()
    end

    t4[p14] = nil
    t3[p14] = nil
end

function t1.GetPlaced(p15) -- line: 157
    -- upvalues: t4 (copy)
    return t4[p15] or {}
end

function t1.Init() -- line: 161
    -- upvalues: CollectionService (copy), RunService (copy), ReleaseConfig (copy), LocalPlayer (copy), t2 (copy), hookContainer (copy)
    local n1 = 0

    RunService.Heartbeat:Connect(function() -- line: 163
        -- upvalues: n1 (ref), CollectionService (copy), ReleaseConfig (copy), t2 (copy)
        local elapsed = os.clock()

        if not (elapsed - n1 < 0.25) then
            n1 = elapsed

            for _, v11 in ipairs(CollectionService:GetTagged("ReleaseCountdown")) do
                local ReleaseKey = v11:GetAttribute("ReleaseKey")

                if ReleaseKey and (v11:IsA("TextLabel") or v11:IsA("TextButton")) then
                    local v12 = t2[ReleaseKey]

                    if v12 then
                        v11.Text = ReleaseConfig.FormatTime((math.max(0, v12 - os.clock())))
                    else
                        local v14 = ReleaseConfig.TimeLeft(ReleaseKey)

                        if v14 ~= nil then
                            v11.Text = ReleaseConfig.FormatTime(v14)
                        else
                            v11.Text = "SOON"
                        end
                    end
                end
            end
        end
    end)
    task.spawn(function() -- line: 174
        -- upvalues: LocalPlayer (copy), hookContainer (copy)
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
        local ReleaseMaps = PlayerGui:FindFirstChild("ReleaseMaps")

        if ReleaseMaps then
            hookContainer(ReleaseMaps)
        end

        PlayerGui.ChildAdded:Connect(function(p16) -- line: 178
            -- upvalues: hookContainer (copy)
            if p16.Name == "ReleaseMaps" then
                hookContainer(p16)
            end
        end)
    end)
end

return t1
