-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local LogService = game:GetService("LogService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ScriptContext = game:GetService("ScriptContext")
local UserInputService = game:GetService("UserInputService")
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Controls = require(script.Parent.Controls)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local t2 = {}
local t3 = {}
local n1 = 0
local n2 = (-1e999)

local function device() -- line: 29
    -- upvalues: UserInputService (copy)
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        return "Touch"
    end

    if not UserInputService.GamepadEnabled or UserInputService.KeyboardEnabled then
        return "Keyboard"
    end

    return "Gamepad"
end

function t1.addState(p1, p2) -- line: 39
    -- upvalues: t3 (copy)
    table.insert(t3, {
        p1,
        p2
    })
end

local function blockersAt(p3, p4) -- line: 44
    -- upvalues: LocalPlayer (copy)
    local t5 = {}

    local function v1() -- line: 46
        -- upvalues: p3 (copy), p4 (copy), LocalPlayer (copy)
        return LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(p3, p4)
    end

    local ok, result = pcall(v1)

    if not ok then
        return "?"
    end

    for _, v2 in result do
        if (v2.Active or v2:IsA("GuiButton")) and v2.Visible then
            local LayerCollector = v2:FindFirstAncestorWhichIsA("LayerCollector")

            table.insert(t5, (if LayerCollector then LayerCollector.Name .. "." else "") .. v2.Name)

            if #t5 >= 3 then
                break
            end
        end
    end

    if #t5 > 0 then
        return (table.concat(t5, "|"))
    end

    return "-"
end

function t1.snapshot() -- line: 64
    -- upvalues: UserInputService (copy), Controls (copy), LocalPlayer (copy), t2 (copy), t3 (copy), blockersAt (copy)
    local t6 = {
        "dev=" .. (if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then "Touch" elseif not UserInputService.GamepadEnabled or UserInputService.KeyboardEnabled then "Keyboard" else "Gamepad")
    }
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        table.insert(t6, string.format("ws=%g jh=%g ar=%s hp=%d ps=%s", Humanoid.WalkSpeed, Humanoid.JumpHeight, tostring(Humanoid.AutoRotate), Humanoid.Health, (tostring(Humanoid.PlatformStand))))

        local RootPart = Humanoid.RootPart

        if RootPart and RootPart.Anchored then
            table.insert(t6, "anchored")
        end
    else
        table.insert(t6, "nochar")
    end

    local CurrentCamera = workspace.CurrentCamera
    local CameraSubject = CurrentCamera.CameraSubject

    table.insert(t6, (("cam=%*/%*"):format(CurrentCamera.CameraType.Name, if CameraSubject then CameraSubject.Name else "nil")))
    table.insert(t6, "locks=" .. Controls.describe())
    table.insert(t6, "hist=" .. Controls.history())

    for _, v9 in t3 do
        local v10 = v9[2]
        local ok, result = pcall(v10)

        if ok and result ~= nil and result ~= "" then
            table.insert(t6, (("%*=%*"):format(v9[1], result)))
        end
    end

    local ViewportSize = CurrentCamera.ViewportSize

    table.insert(t6, "stick=" .. blockersAt(ViewportSize.X * 0.2, ViewportSize.Y * 0.75))
    table.insert(t6, "mid=" .. blockersAt(ViewportSize.X * 0.5, ViewportSize.Y * 0.5))

    if #t2 > 0 then
        table.insert(t6, "err=" .. table.concat(t2, " || "))
    end

    local v15 = table.concat(t6, " ")

    if #v15 > 900 then
        return (string.sub(v15, 1, 900))
    end

    return v15
end

function t1.report(p5) -- line: 99
    -- upvalues: Remotes (copy), t1 (copy), n1 (ref), n2 (ref)
    local elapsed = os.clock()

    if n1 >= 3 or elapsed - n2 < 30 then
        return
    end

    n1 += 1
    n2 = elapsed
    Remotes.Diag:FireServer(string.sub(p5, 1, 80), t1.snapshot())
end

local function remember(p6) -- line: 109
    -- upvalues: t2 (copy)
    table.insert(t2, (string.sub(p6, 1, 140)))

    if #t2 > 4 then
        table.remove(t2, 1)
    end
end

function t1.init() -- line: 116
    -- upvalues: LogService (copy), ScriptContext (copy), Controls (copy), t1 (copy), t2 (copy)
    ScriptContext.Error:Connect(function(p7, p8, p9) -- line: 117
        -- upvalues: t2 (copy)
        local v17 = string.match(p8 or "", "([%w_]+:%d+)") or ""

        table.insert(t2, (string.sub(("%* %*: %*"):format(if p9 then p9.Name else "?", v17, p7), 1, 140)))

        if #t2 > 4 then
            table.remove(t2, 1)
        end
    end)
    LogService.MessageOut:Connect(function(p10, p11) -- line: 123
        -- upvalues: t2 (copy)
        if p11 == Enum.MessageType.MessageWarning and string.find(string.lower(p10), "error", 1, true) then
            table.insert(t2, (string.sub("warn: " .. p10, 1, 140)))

            if #t2 > 4 then
                table.remove(t2, 1)
            end
        end
    end)
    Controls.setWatchdogHandler(function(p12) -- line: 128
        -- upvalues: t1 (copy)
        warn("Controls watchdog freed the player: " .. p12)
        t1.report("watchdog " .. p12)
    end)
    Controls.init()
end

return t1
