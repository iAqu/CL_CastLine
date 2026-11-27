-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalizationService = game:GetService("LocalizationService")
local ContentProvider = game:GetService("ContentProvider")
local FishMotionConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("FishMotionConfig"))
local LocalPlayer = Players.LocalPlayer
local TelemetryReport = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("TelemetryReport")
local t1 = {
    "ShopGui",
    "IndexGui",
    "CratesGui",
    "XPGui",
    "SettingsGui",
    "AquariumGui",
    "FeedGui",
    "FeedbackGui",
    "GroupRewardGui",
    "PlaytimeGui"
}
local GuiService = game:GetService("GuiService")

local function v1() -- line: 25
    -- upvalues: GuiService (copy)
    return GuiService:IsTenFootInterface()
end

local ok, result = pcall(v1)
local v2 = ok and result == true

local function deviceKind() -- line: 27
    -- upvalues: UserInputService (copy), v2 (copy)
    if not v2 then
        if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
            return "Mobile"
        end

        if not UserInputService.GamepadEnabled or UserInputService.KeyboardEnabled then
            return "PC"
        end
    end

    return "Console"
end

local function v3() -- line: 33
    -- upvalues: LocalizationService (copy)
    return LocalizationService.RobloxLocaleId
end

local ok2, result2 = pcall(v3)
local v4 = if v2 then "Console"
    elseif UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then "Mobile"
    elseif not UserInputService.GamepadEnabled or UserInputService.KeyboardEnabled then "PC"
    else "Console"

if not ok2 or not result2 then
    result2 = "?"
end

TelemetryReport:FireServer("device", v4, result2)

local Stats = game:GetService("Stats")
local t2 = {
    "RenderCPUFrameTime",
    "RenderGPUFrameTime",
    "HeartbeatTime"
}
local t3 = {}

for v5, v6 in ipairs(t2) do
    local function v7() -- line: 44
        -- upvalues: Stats (copy), v6 (copy)
        return Stats[v6]
    end

    t3[v5] = pcall(v7)
end

task.spawn(function() -- line: 45
    -- upvalues: RunService (copy), TelemetryReport (copy), Stats (copy), t2 (copy), t3 (copy)
    while true do
        local n1 = 0
        local elapsed = os.clock()
        local t4 = {
            0, 0, 0
        }
        local connection = RunService.Heartbeat:Connect(function() -- line: 49
            -- upvalues: n1 (ref), t4 (copy), Stats (copy), t2 (copy), t3 (copy)
            n1 += 1

            for v8, v9 in ipairs(t2) do
                if t3[v8] then
                    t4[v8] += Stats[v9]
                end
            end
        end)

        task.wait(3)
        connection:Disconnect()

        local t5 = {}

        for i = 1, #t2 do
            local v10, v11

            if t3[i] and n1 > 0 then
                local v12 = t4[i] / n1 * 1000

                if v12 then
                    v10 = v12
                    v11 = true
                else
                    v11 = false
                end
            else
                v11 = false
            end

            if not v11 then
                v10 = nil
            end

            t5[i] = v10
        end

        local v13 = os.clock() - elapsed

        TelemetryReport:FireServer("fps", n1 / v13, t5[1], t5[2], t5[3])
        task.wait(12)
    end
end)
task.spawn(function() -- line: 70
    -- upvalues: FishMotionConfig (copy), TelemetryReport (copy), Stats (copy)
    while true do
        local recvBytes = FishMotionConfig.recvBytes
        local elapsed = os.clock()
        local n2 = 0
        local n3 = 0

        for _ = 1, 60 do
            task.wait(1)

            local function v14() -- line: 76
                -- upvalues: Stats (copy)
                return Stats.DataReceiveKbps
            end

            local ok, result = pcall(v14)

            if ok and type(result) == "number" then
                n2 += result
                n3 += 1
            end
        end

        local function v15() -- line: 82
            -- upvalues: Stats (copy)
            return Stats:GetTotalMemoryUsageMb()
        end

        local ok, result = pcall(v15)
        local v16 = n3 > 0
        local v17 = if v16 then n2 / n3 else nil
        local v18 = if not v16 or not v17 then nil else v17
        local v19 = (FishMotionConfig.recvBytes - recvBytes) / 1024 / (os.clock() - elapsed)

        if not ok or not result then
            result = nil
        end

        TelemetryReport:FireServer("net", v18, v19, result)
    end
end)

local v20 = false
local t6 = {}
local t7 = {}

UserInputService.InputBegan:Connect(function(p1) -- line: 95
    -- upvalues: UserInputService (copy), TelemetryReport (copy), GuiService (copy), v2 (copy), v20 (ref), t6 (copy), t7 (copy)
    if p1.UserInputType ~= Enum.UserInputType.Gamepad1 then
        return
    end

    local KeyCode = p1.KeyCode

    if KeyCode.Name:sub(1, 6) == "Button" or KeyCode.Name:sub(1, 4) == "DPad" then
        if not v20 then
            v20 = true

            local function v21() -- line: 101
                -- upvalues: UserInputService (copy)
                return UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonA)
            end

            local ok, result = pcall(v21)
            local v22 = ok and type(result) == "string" and result:lower() or ""

            TelemetryReport:FireServer("pad", if v22:find("playstation") then "ps" elseif v22:find("xbox") then "xbox" else "other", v2)
        end

        local elapsed = os.clock()
        local v24 = t6[KeyCode] or {}

        t6[KeyCode] = v24
        table.insert(v24, elapsed)

        while v24[1] and elapsed - v24[1] > 2 do
            table.remove(v24, 1)
        end

        if #v24 >= 4 and elapsed - (t7[KeyCode] or (-1e999)) > 30 then
            t7[KeyCode] = elapsed
            table.clear(v24)

            local SelectedObject = GuiService.SelectedObject

            TelemetryReport:FireServer("padmash", KeyCode.Name, SelectedObject and SelectedObject.Name or false)
        end
    end
end)

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local v26 = false

ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ReelState").OnClientEvent:Connect(function(p2) -- line: 126
    -- upvalues: RunService (copy), TelemetryReport (copy), PlayerGui (copy), v26 (ref)
    if type(p2) ~= "table" or p2.action ~= "start" or v26 then
        return
    end

    v26 = true

    local elapsed = os.clock()

    task.spawn(function() -- line: 130
        -- upvalues: elapsed (copy), RunService (copy), TelemetryReport (copy), PlayerGui (copy), v26 (ref)
        local v27

        while true do
            if os.clock() - elapsed < 3 then
                local ReelGui = PlayerGui:FindFirstChild("ReelGui")

                if ReelGui then
                    local Circle = ReelGui:FindFirstChild("Circle")

                    if ReelGui.Enabled and Circle and Circle.Visible and Circle.AbsoluteSize.X > 4 then
                        v27 = math.floor((os.clock() - elapsed) * 1000)
                        break
                    end
                end

                RunService.RenderStepped:Wait()
                continue
            end

            v27 = -1
            break
        end

        v26 = false
        TelemetryReport:FireServer("reelshow", v27)
    end)
end)

local t8 = {}

local function fetchFailed(p3) -- line: 160
    -- upvalues: ContentProvider (copy)
    if type(p3) == "string" and p3 ~= "" then
        local function v29() -- line: 162
            -- upvalues: p3 (copy), ContentProvider (copy)
            return ContentProvider:GetAssetFetchStatus(p3)
        end

        local result
        local ok

        ok, result = pcall(v29)

        if ok then
            ok = result == Enum.AssetFetchStatus.Failure or result == Enum.AssetFetchStatus.TimedOut
        end

        return ok
    end

    return false
end

task.spawn(function() -- line: 165
    -- upvalues: FishMotionConfig (copy), TelemetryReport (copy), t8 (copy), fetchFailed (copy)
    local t9 = {
        secs = 0,
        held = 0,
        gone = 0,
        unsent = 0,
        gap = 0,
        near = 0,
        worst = 0,
        lag = 0
    }
    local elapsed = os.clock()

    while true do
        task.wait(1)

        local CurrentCamera = workspace.CurrentCamera
        local entries = FishMotionConfig.entries

        if CurrentCamera and entries then
            local CFramePosition = CurrentCamera.CFrame.Position
            local v30 = workspace:GetServerTimeNow() - FishMotionConfig.renderLag()
            local v31 = FishMotionConfig.holdSince ~= nil and os.clock() - FishMotionConfig.holdSince > 0.5
            local n4 = 0
            local n5 = 0
            local n6 = 0
            local n7 = 0

            for _, v32 in pairs(entries) do
                local attrs, mesh = v32.attrs, v32.mesh

                if v32.model.Parent and mesh.Parent and not (attrs.GoneAt or attrs.FadeOut) and (mesh.Position - CFramePosition).Magnitude < 150 then
                    n4 += 1

                    local samples = v32.samples
                    local v33 = samples[#samples]

                    if v33 then
                        if v30 - v33.t > FishMotionConfig.STALE + 1 then
                            n6 += 1
                        elseif v31 or v30 - v33.t > FishMotionConfig.MAX_EXTRAP + 0.5 then
                            n5 += 1
                        end
                    elseif os.clock() - (v32.at or os.clock()) > 3 then
                        n7 += 1
                    end

                    local Name = v32.model.Name

                    if not t8[Name] and mesh:IsA("MeshPart") then
                        t8[Name] = true

                        if fetchFailed(mesh.MeshId) then
                            TelemetryReport:FireServer("assetfail", Name, "mesh")
                        end

                        if fetchFailed(mesh.TextureID) then
                            TelemetryReport:FireServer("assetfail", Name, "texture")
                        end
                    end
                end
            end

            if n4 > 0 then
                t9.secs += 1
                t9.near += n4

                if n5 > 0 then
                    t9.held += 1
                end

                if n6 > 0 then
                    t9.gone += 1
                end

                if n7 > 0 then
                    t9.unsent += 1
                end

                t9.worst = math.max(t9.worst, n5 / n4)
                t9.gap = math.max(t9.gap, os.clock() - (FishMotionConfig.lastPacket or os.clock()))
                t9.lag = math.max(t9.lag, FishMotionConfig.renderLag())
            end
        end

        if os.clock() - elapsed >= 60 then
            elapsed = os.clock()

            if t9.secs > 0 then
                t9.near /= t9.secs
                t9.gap = math.min(t9.gap, 600)
                TelemetryReport:FireServer("fishhealth", t9)
            end

            t9 = {
                secs = 0,
                held = 0,
                gone = 0,
                unsent = 0,
                gap = 0,
                near = 0,
                worst = 0,
                lag = 0
            }
        end
    end
end)

for _, v36 in ipairs(t1) do
    task.spawn(function() -- line: 221
        -- upvalues: TelemetryReport (copy), PlayerGui (copy), v36 (copy)
        local v37 = PlayerGui:WaitForChild(v36, 60)
        local v38 = v37 and v37:WaitForChild("Panel", 10)

        if v38 then
            v38:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 225
                -- upvalues: v38 (copy), TelemetryReport (copy), v36 (copy)
                if v38.Visible then
                    TelemetryReport:FireServer("panel", v36)
                end
            end)
        end
    end)
end
