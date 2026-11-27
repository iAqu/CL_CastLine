-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local OnboardingKit = ReplicatedStorage:WaitForChild("OnboardingKit")
local Config = require(OnboardingKit:WaitForChild("Config"))
local Protocol = require(OnboardingKit:WaitForChild("Protocol"))
local t1 = {
    [Enum.KeyCode.W] = true,
    [Enum.KeyCode.A] = true,
    [Enum.KeyCode.S] = true,
    [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true,
    [Enum.KeyCode.Down] = true,
    [Enum.KeyCode.Left] = true,
    [Enum.KeyCode.Right] = true,
    [Enum.KeyCode.Thumbstick1] = true,
    [Enum.KeyCode.Thumbstick2] = true
}
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local v1 = OnboardingKit:WaitForChild(Protocol.RemoteName)
local t2 = {}
local self = setmetatable({}, {
    __mode = "k"
})
local t5 = {}
local v3 = {}
local n1 = 0
local n2 = 0
local v4 = false
local v5 = false
local elapsed
local v6 = false
local v7, v8
local n3 = 0

local function round2(p1) -- line: 49
    return math.round(p1 * 100) / 100
end

local function now() -- line: 53
    -- upvalues: n2 (ref)
    return math.round((os.clock() - n2) * 100) / 100
end

local function push(p2) -- line: 57
    -- upvalues: v3 (ref), n1 (ref), n2 (ref), v4 (ref)
    if v4 then
        if #v3 >= 600 then
            n1 += 1
        else
            p2.t = math.round((os.clock() - n2) * 100) / 100
            table.insert(v3, p2)
        end
    end
end

local function flush() -- line: 69
    -- upvalues: Protocol (copy), v1 (copy), v3 (ref), n1 (ref), n2 (ref)
    if #v3 == 0 then
        return
    end

    local v14 = math.min(#v3, Protocol.MaxEventsPerBatch)
    local v15 = table.move(v3, 1, v14, 1, {})

    v3 = table.move(v3, v14 + 1, #v3, 1, {})

    if n1 > 0 then
        v15[#v15].dropped = n1
        n1 = 0
    end

    local function v16() -- line: 80
        -- upvalues: v15 (copy), v1 (copy), n2 (ref)
        v1:FireServer({
            now = math.round((os.clock() - n2) * 100) / 100,
            events = v15
        })
    end

    pcall(v16)
end

local function guiLabel(p3) -- line: 85
    if p3 == nil then
        return nil
    end

    local LayerCollector = p3:FindFirstAncestorWhichIsA("LayerCollector")
    local Parent = p3.Parent
    local v18 = if Parent == nil or Parent == LayerCollector then "" else Parent.Name .. "/"

    return ("%s/%s%s"):format(if LayerCollector == nil then "?" else LayerCollector.Name, v18, p3.Name)
end

local function describeHit(p4) -- line: 95
    -- upvalues: Workspace (copy), Config (copy)
    local v20 = false
    local v22 = p4
    local v21
    local v19

    while v22 ~= nil and v22 ~= Workspace do
        local v23 = v19

        if v19 == nil and Config.TargetAttribute ~= nil then
            local Attribute = v22:GetAttribute(Config.TargetAttribute)

            if type(Attribute) == "string" or type(Attribute) == "number" then
                v23 = tostring(Attribute)
            end
        end

        if not (v20 or Config.TutorialHighlightName == nil or v22:FindFirstChild(Config.TutorialHighlightName) == nil) then
            v20 = true
        end

        if v21 == nil and v22:IsA("Model") then
            v21 = v22
        end

        v19 = v23
        v22 = v22.Parent
    end

    if v21 == nil then
        return v19, v20, nil
    end

    return v19, v20, v21.Name
end

local function pickGui(p5) -- line: 118
    local v24, v25, v26, v27

    for _, v28 in ipairs(p5) do
        if v28.Visible then
            if v24 == nil and (v28.BackgroundTransparency < 1 or not v28:IsA("Frame")) then
                v24 = v28
            end

            if v25 == nil and v28:IsA("GuiButton") and v28.Active then
                v25 = v28
            end

            if v24 ~= nil and v25 ~= nil then
                v26 = v24
                v27 = v25
                break
            end
        end

        v27 = v25
        v26 = v24
    end

    return v26, v27
end

local function readQuality() -- line: 137
    local function v29() -- line: 138
        return UserSettings():GetService("UserGameSettings").SavedQualityLevel.Value
    end

    local ok, result = pcall(v29)

    return if ok then result else nil
end

local function raycast(p6, p7) -- line: 144
    -- upvalues: Workspace (copy), LocalPlayer (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil then
        return nil, nil
    end

    local v30 = CurrentCamera:ScreenPointToRay(p6, p7)
    local t7 = {}

    if LocalPlayer.Character ~= nil then
        table.insert(t7, LocalPlayer.Character)
    end

    local v31 = RaycastParams.new()

    v31.FilterType = Enum.RaycastFilterType.Exclude

    local v32

    for _ = 1, 4 do
        v31.FilterDescendantsInstances = t7

        local v33 = Workspace:Raycast(v30.Origin, v30.Direction * 500, v31)

        if v33 == nil then
            return v32, nil
        end

        local v34 = if v32 == nil then v33 else v32

        if v33.Instance.Transparency < 1 then
            return v34, v33
        end

        v32 = v34
        table.insert(t7, v33.Instance)
    end

    return v32, nil
end

local function describePoint(p8, p9, p10) -- line: 175
    -- upvalues: PlayerGui (copy), describeHit (copy), pickGui (copy), raycast (copy)
    p8.x = math.round(p9)
    p8.y = math.round(p10)

    local function v35() -- line: 178
        -- upvalues: p9 (copy), p10 (copy), PlayerGui (copy)
        return PlayerGui:GetGuiObjectsAtPosition(p9, p10)
    end

    local ok, result = pcall(v35)

    if ok then
        local v36, v37 = pickGui(result)

        if v36 ~= nil then
            local LayerCollector = v36:FindFirstAncestorWhichIsA("LayerCollector")
            local Parent = v36.Parent
            local v38 = if Parent == nil or Parent == LayerCollector then "" else Parent.Name .. "/"

            p8.ui = ("%s/%s%s"):format(if LayerCollector == nil then "?" else LayerCollector.Name, v38, v36.Name)
        else
            p8.ui = nil
        end

        if v37 ~= nil then
            local LayerCollector = v37:FindFirstAncestorWhichIsA("LayerCollector")
            local Parent = v37.Parent
            local v39 = if Parent == nil or Parent == LayerCollector then "" else Parent.Name .. "/"

            p8.uiBtn = ("%s/%s%s"):format(if LayerCollector == nil then "?" else LayerCollector.Name, v39, v37.Name)
        else
            p8.uiBtn = nil
        end
    end

    local v40, v41 = raycast(p9, p10)

    if v40 ~= nil then
        local v42, v43, v44 = describeHit(v40.Instance)

        p8.hit = v40.Instance.Name
        p8.model = v44
        p8.tid = v42
        p8.tut = v43
        p8.dist = math.round(v40.Distance)

        if v40.Instance.Transparency >= 1 then
            p8.inv = true
        end
    end

    if v41 ~= nil and v41 ~= v40 then
        p8.vis = v41.Instance.Name
        p8.visTid = describeHit(v41.Instance)
    end
end

local function classify(p11) -- line: 204
    -- upvalues: UserInputService (copy), t1 (copy)
    local UserInputType = p11.UserInputType

    if UserInputType == Enum.UserInputType.MouseButton1 then
        return "Mouse", "L"
    end

    if UserInputType == Enum.UserInputType.MouseButton2 then
        return "Mouse", "R"
    end

    if UserInputType == Enum.UserInputType.Touch then
        return "Touch", "T"
    end

    if UserInputType == Enum.UserInputType.Keyboard then
        if t1[p11.KeyCode] or UserInputService:GetFocusedTextBox() ~= nil then
            return nil, nil
        end

        return "Key", p11.KeyCode.Name
    end

    if string.find(UserInputType.Name, "Gamepad", 1, true) == nil or t1[p11.KeyCode] then
        return nil, nil
    end

    return "Pad", p11.KeyCode.Name
end

local function onInputBegan(p12, p13) -- line: 226
    -- upvalues: t5 (copy), v3 (ref), n1 (ref), n2 (ref), v4 (ref), describePoint (copy), classify (copy)
    local v45, v46 = classify(p12)

    if v45 == nil or v45 == "Key" and p13 then
        return
    end

    local t8 = {
        k = "Input",
        dev = v45,
        btn = v46,
        gpe = p13
    }

    if v45 == "Mouse" or v45 == "Touch" then
        describePoint(t8, p12.Position.X, p12.Position.Y)
        t5[if v45 == "Touch" then p12 else p12.UserInputType] = {
            t = os.clock(),
            x = p12.Position.X,
            y = p12.Position.Y
        }
    end

    if v4 then
        if #v3 >= 600 then
            n1 += 1
        else
            t8.t = math.round((os.clock() - n2) * 100) / 100
            table.insert(v3, t8)
        end
    end
end

local function onInputEnded(p14, p15) -- line: 244
    -- upvalues: t5 (copy), v3 (ref), n1 (ref), n2 (ref), v4 (ref), describePoint (copy), classify (copy)
    local v50, v51 = classify(p14)

    if v50 ~= "Mouse" and v50 ~= "Touch" then
        return
    end

    local v52 = if v50 == "Touch" then p14 else p14.UserInputType
    local v53 = t5[v52]

    if v53 == nil then
        return
    end

    t5[v52] = nil

    local v54 = p14.Position.X - v53.x
    local v55 = p14.Position.Y - v53.y
    local t9 = {
        k = "Release",
        dev = v50,
        btn = v51,
        gpe = p15,
        dur = math.round((os.clock() - v53.t) * 100) / 100,
        drag = math.round((math.sqrt(v54 * v54 + v55 * v55)))
    }

    if t9.drag > 12 then
        describePoint(t9, p14.Position.X, p14.Position.Y)
    end

    if v4 then
        if #v3 >= 600 then
            n1 += 1
        else
            t9.t = math.round((os.clock() - n2) * 100) / 100
            table.insert(v3, t9)
        end
    end
end

local function watchButton(p16) -- line: 271
    -- upvalues: self (copy), v3 (ref), n1 (ref), n2 (ref), v4 (ref)
    if p16:IsA("GuiButton") and self[p16] == nil then
        self[p16] = p16.Activated:Connect(function(p17) -- line: 275
            -- upvalues: p16 (copy), v3 (ref), n1 (ref), n2 (ref), v4 (ref)
            local t10 = {
                k = "Button"
            }

            if p16 ~= nil then
                local LayerCollector = p16:FindFirstAncestorWhichIsA("LayerCollector")
                local Parent = p16.Parent
                local v61 = if Parent == nil or Parent == LayerCollector then "" else Parent.Name .. "/"

                t10.ui = ("%s/%s%s"):format(if LayerCollector == nil then "?" else LayerCollector.Name, v61, p16.Name)
            else
                t10.ui = nil
            end

            if p17 ~= nil then
                t10.dev = p17.UserInputType.Name
            end

            if v4 then
                if #v3 >= 600 then
                    n1 += 1
                else
                    t10.t = math.round((os.clock() - n2) * 100) / 100
                    table.insert(v3, t10)
                end
            end
        end)
    end
end

local function recordViewport() -- line: 284
    -- upvalues: Workspace (copy), PlayerGui (copy), v3 (ref), n1 (ref), n2 (ref), v4 (ref), v8 (ref)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil then
        return
    end

    local ViewportSize = CurrentCamera.ViewportSize
    local v64 = ("%dx%d"):format(ViewportSize.X, ViewportSize.Y)

    if v64 == v8 then
        return
    end

    v8 = v64

    local t11 = {
        k = "Viewport",
        vx = math.round(ViewportSize.X),
        vy = math.round(ViewportSize.Y),
        orient = PlayerGui.CurrentScreenOrientation.Name
    }

    if v4 then
        if #v3 >= 600 then
            n1 += 1
        else
            t11.t = math.round((os.clock() - n2) * 100) / 100
            table.insert(v3, t11)
        end
    end
end

local function watchCharacter(p18) -- line: 303
    -- upvalues: t2 (copy), v3 (ref), n1 (ref), n2 (ref), v4 (ref)
    table.insert(t2, p18.ChildAdded:Connect(function(p19) -- line: 304
        -- upvalues: v3 (ref), n1 (ref), n2 (ref), v4 (ref)
        if not p19:IsA("Tool") then
            return
        end

        local t12 = {
            k = "Tool",
            on = true,
            tool = p19.Name
        }

        if v4 then
            if #v3 >= 600 then
                n1 += 1
            else
                t12.t = math.round((os.clock() - n2) * 100) / 100
                table.insert(v3, t12)
            end
        end
    end))
    table.insert(t2, p18.ChildRemoved:Connect(function(p20) -- line: 309
        -- upvalues: v3 (ref), n1 (ref), n2 (ref), v4 (ref)
        if not p20:IsA("Tool") then
            return
        end

        local t13 = {
            k = "Tool",
            on = false,
            tool = p20.Name
        }

        if v4 then
            if #v3 >= 600 then
                n1 += 1
            else
                t13.t = math.round((os.clock() - n2) * 100) / 100
                table.insert(v3, t13)
            end
        end
    end))
end

local function watchHint() -- line: 316
    -- upvalues: Config (copy), PlayerGui (copy), t2 (copy), v3 (ref), n1 (ref), n2 (ref), v4 (ref), v7 (ref)
    local HintLabelPath = Config.HintLabelPath

    if type(HintLabelPath) == "table" and #HintLabelPath ~= 0 then
        task.spawn(function() -- line: 321
            -- upvalues: HintLabelPath (copy), PlayerGui (copy), t2 (copy), v3 (ref), n1 (ref), n2 (ref), v4 (ref), v7 (ref)
            local v73 = PlayerGui

            for _, v74 in ipairs(HintLabelPath) do
                v73 = v73 and v73:WaitForChild(v74, 30)
            end

            local v75, v76

            if v73 ~= nil then
                if v73:IsA("TextLabel") and v4 then
                    local v77 = v73

                    local function record() -- line: 330
                        -- upvalues: v77 (copy), v3 (ref), n1 (ref), n2 (ref), v4 (ref), v7 (ref)
                        local v78 = if v77.Visible then v77.Text else ""

                        if v78 == v7 then
                            return
                        end

                        v7 = v78

                        local t14 = {
                            k = "Stage",
                            hint = v78
                        }

                        if v4 then
                            if #v3 >= 600 then
                                n1 += 1
                            else
                                t14.t = math.round((os.clock() - n2) * 100) / 100
                                table.insert(v3, t14)
                            end
                        end
                    end

                    table.insert(t2, v73:GetPropertyChangedSignal("Text"):Connect(record))
                    table.insert(t2, v73:GetPropertyChangedSignal("Visible"):Connect(record))
                    v75 = if v73.Visible then v73.Text else ""
                    v76 = false
                else
                    v76 = true
                end
            else
                v76 = true
            end

            if v76 or v75 == v7 then
                return
            end

            v7 = v75

            local t15 = {
                k = "Stage",
                hint = v75
            }

            if v4 then
                if #v3 >= 600 then
                    n1 += 1
                else
                    t15.t = math.round((os.clock() - n2) * 100) / 100
                    table.insert(v3, t15)
                end
            end
        end)
    end
end

local function sampleMovement() -- line: 343
    -- upvalues: Protocol (copy), LocalPlayer (copy), v3 (ref), n1 (ref), n2 (ref), v4 (ref), v5 (ref), elapsed (ref), v6 (ref)
    local Character = LocalPlayer.Character
    local v83 = Character

    if Character then
        v83 = Character:FindFirstChildOfClass("Humanoid")
        Character = Character:FindFirstChild("HumanoidRootPart")
    end

    if v83 ~= nil and Character ~= nil then
        local elapsed2 = os.clock()
        local v84 = v83.MoveDirection.Magnitude > 0.1

        if v84 ~= v5 then
            v5 = v84

            local t16 = {
                k = "Move",
                on = v84,
                px = math.round(Character.Position.X),
                pz = math.round(Character.Position.Z)
            }

            if v4 then
                if #v3 >= 600 then
                    n1 += 1
                else
                    t16.t = math.round((os.clock() - n2) * 100) / 100
                    table.insert(v3, t16)
                end
            end

            if v84 then
                elapsed = nil
                v6 = false
            else
                elapsed = elapsed2
            end
        end

        if v84 or elapsed == nil or v6 or not (elapsed2 - elapsed >= Protocol.IdleSeconds) then
            return
        end

        v6 = true

        local t17 = {
            k = "Idle",
            secs = math.round((elapsed2 - elapsed) * 100) / 100
        }

        if not v4 then
            return
        end

        if #v3 >= 600 then
            n1 += 1
        else
            t17.t = math.round((os.clock() - n2) * 100) / 100
            table.insert(v3, t17)
        end
    end
end

local function samplePerf(p21) -- line: 368
    -- upvalues: Stats (copy), LocalPlayer (copy), v3 (ref), n1 (ref), n2 (ref), v4 (ref), n3 (ref)
    local v91 = n3
    local v90 = v91 / math.max(p21, 0.001)

    n3 = 0

    local function v92() -- line: 371
        -- upvalues: LocalPlayer (copy)
        return LocalPlayer:GetNetworkPing()
    end

    local ok, result = pcall(v92)
    local t18 = {
        k = "Perf",
        fps = math.round(v90),
        ping = if ok then math.round(result * 1000) else nil,
        mem = math.round((Stats:GetTotalMemoryUsageMb()))
    }

    if v4 then
        if #v3 >= 600 then
            n1 += 1
        else
            t18.t = math.round((os.clock() - n2) * 100) / 100
            table.insert(v3, t18)
        end
    end
end

local function begin() -- line: 382
    -- upvalues: GuiService (copy), LocalizationService (copy), ProximityPromptService (copy), RunService (copy), UserInputService (copy), Workspace (copy), Config (copy), Protocol (copy), LocalPlayer (copy), PlayerGui (copy), t2 (copy), self (copy), v3 (ref), n1 (ref), n2 (ref), v4 (ref), v5 (ref), elapsed (ref), v6 (ref), v7 (ref), n3 (ref), flush (copy), onInputBegan (copy), onInputEnded (copy), watchButton (copy), recordViewport (copy), watchCharacter (copy), sampleMovement (copy), samplePerf (copy)
    v4 = true
    n2 = os.clock()
    elapsed = os.clock()
    v6 = false
    v5 = false

    local t19 = {
        k = "Start",
        touch = UserInputService.TouchEnabled,
        mouse = UserInputService.MouseEnabled,
        keyboard = UserInputService.KeyboardEnabled,
        pad = UserInputService.GamepadEnabled,
        tenFoot = GuiService:IsTenFootInterface(),
        last = UserInputService:GetLastInputType().Name,
        inset = math.round(GuiService:GetGuiInset().Y),
        boot = math.round(time() * 100) / 100,
        locale = LocalizationService.RobloxLocaleId,
        sysLocale = LocalizationService.SystemLocaleId
    }

    local function v97() -- line: 138
        return UserSettings():GetService("UserGameSettings").SavedQualityLevel.Value
    end

    local ok, result = pcall(v97)

    t19.gfx = if not ok then nil else result

    if v4 then
        if #v3 >= 600 then
            n1 += 1
        else
            t19.t = math.round((os.clock() - n2) * 100) / 100
            table.insert(v3, t19)
        end
    end

    recordViewport()
    task.delay(2, function() -- line: 405
        -- upvalues: v4 (ref), recordViewport (copy)
        if v4 then
            recordViewport()
        end
    end)

    local function add(p22) -- line: 411
        -- upvalues: t2 (copy)
        table.insert(t2, p22)
    end

    table.insert(t2, (UserInputService.InputBegan:Connect(onInputBegan)))
    table.insert(t2, (UserInputService.InputEnded:Connect(onInputEnded)))
    table.insert(t2, (UserInputService.LastInputTypeChanged:Connect(function(p23) -- line: 416
        -- upvalues: v3 (ref), n1 (ref), n2 (ref), v4 (ref)
        if p23 ~= Enum.UserInputType.Touch and p23 ~= Enum.UserInputType.MouseButton1 and not string.find(p23.Name, "Gamepad", 1, true) then
            return
        end

        local t20 = {
            k = "Focus",
            lastInput = p23.Name
        }

        if v4 then
            if #v3 >= 600 then
                n1 += 1
            else
                t20.t = math.round((os.clock() - n2) * 100) / 100
                table.insert(v3, t20)
            end
        end
    end)))
    table.insert(t2, (UserInputService.WindowFocusReleased:Connect(function() -- line: 421
        -- upvalues: v3 (ref), n1 (ref), n2 (ref), v4 (ref), flush (copy)
        local t21 = {
            k = "Focus",
            on = false
        }

        if v4 then
            if #v3 >= 600 then
                n1 += 1
            else
                t21.t = math.round((os.clock() - n2) * 100) / 100
                table.insert(v3, t21)
            end
        end

        flush()
    end)))
    table.insert(t2, (UserInputService.WindowFocused:Connect(function() -- line: 425
        -- upvalues: v3 (ref), n1 (ref), n2 (ref), v4 (ref)
        local t22 = {
            k = "Focus",
            on = true
        }

        if v4 then
            if #v3 >= 600 then
                n1 += 1
            else
                t22.t = math.round((os.clock() - n2) * 100) / 100
                table.insert(v3, t22)
            end
        end
    end)))
    table.insert(t2, (ProximityPromptService.PromptTriggered:Connect(function(p24) -- line: 428
        -- upvalues: v3 (ref), n1 (ref), n2 (ref), v4 (ref)
        local t23 = {
            k = "Prompt",
            action = p24.ActionText,
            obj = if p24.Parent == nil then nil else p24.Parent.Name
        }

        if v4 then
            if #v3 >= 600 then
                n1 += 1
            else
                t23.t = math.round((os.clock() - n2) * 100) / 100
                table.insert(v3, t23)
            end
        end
    end)))

    if Workspace.CurrentCamera ~= nil then
        table.insert(t2, (Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(recordViewport)))
    end

    table.insert(t2, (PlayerGui.DescendantAdded:Connect(watchButton)))

    for _, descendant in ipairs(PlayerGui:GetDescendants()) do
        if descendant:IsA("GuiButton") and self[descendant] == nil then
            self[descendant] = descendant.Activated:Connect(function(p25) -- line: 275
                -- upvalues: descendant (copy), v3 (ref), n1 (ref), n2 (ref), v4 (ref)
                local t24 = {
                    k = "Button"
                }

                if descendant ~= nil then
                    local LayerCollector = descendant:FindFirstAncestorWhichIsA("LayerCollector")
                    local Parent = descendant.Parent
                    local v108 = if Parent == nil or Parent == LayerCollector then "" else Parent.Name .. "/"

                    t24.ui = ("%s/%s%s"):format(if LayerCollector == nil then "?" else LayerCollector.Name, v108, descendant.Name)
                else
                    t24.ui = nil
                end

                if p25 ~= nil then
                    t24.dev = p25.UserInputType.Name
                end

                if v4 then
                    if #v3 >= 600 then
                        n1 += 1
                    else
                        t24.t = math.round((os.clock() - n2) * 100) / 100
                        table.insert(v3, t24)
                    end
                end
            end)
        end
    end

    table.insert(t2, (LocalPlayer.CharacterAdded:Connect(function(p26) -- line: 442
        -- upvalues: v3 (ref), n1 (ref), n2 (ref), v4 (ref), watchCharacter (copy)
        local t25 = {
            k = "Move",
            spawn = true
        }

        if v4 then
            if #v3 >= 600 then
                n1 += 1
            else
                t25.t = math.round((os.clock() - n2) * 100) / 100
                table.insert(v3, t25)
            end
        end

        watchCharacter(p26)
    end)))

    if LocalPlayer.Character ~= nil then
        watchCharacter(LocalPlayer.Character)
    end

    local HintLabelPath = Config.HintLabelPath

    if type(HintLabelPath) == "table" and #HintLabelPath ~= 0 then
        task.spawn(function() -- line: 321
            -- upvalues: HintLabelPath (copy), PlayerGui (copy), t2 (copy), v3 (ref), n1 (ref), n2 (ref), v4 (ref), v7 (ref)
            local v113 = PlayerGui

            for _, v114 in ipairs(HintLabelPath) do
                v113 = v113 and v113:WaitForChild(v114, 30)
            end

            local v115, v116

            if v113 ~= nil then
                if v113:IsA("TextLabel") and v4 then
                    local v117 = v113

                    local function record() -- line: 330
                        -- upvalues: v3 (ref), n1 (ref), n2 (ref), v4 (ref), v7 (ref), v117 (copy)
                        local v118 = if v117.Visible then v117.Text else ""

                        if v118 == v7 then
                            return
                        end

                        v7 = v118

                        local t26 = {
                            k = "Stage",
                            hint = v118
                        }

                        if v4 then
                            if #v3 >= 600 then
                                n1 += 1
                            else
                                t26.t = math.round((os.clock() - n2) * 100) / 100
                                table.insert(v3, t26)
                            end
                        end
                    end

                    table.insert(t2, v113:GetPropertyChangedSignal("Text"):Connect(record))
                    table.insert(t2, v113:GetPropertyChangedSignal("Visible"):Connect(record))
                    v115 = if v113.Visible then v113.Text else ""
                    v116 = false
                else
                    v116 = true
                end
            else
                v116 = true
            end

            if v116 or v115 == v7 then
                return
            end

            v7 = v115

            local t27 = {
                k = "Stage",
                hint = v115
            }

            if v4 then
                if #v3 >= 600 then
                    n1 += 1
                else
                    t27.t = math.round((os.clock() - n2) * 100) / 100
                    table.insert(v3, t27)
                end
            end
        end)
    end

    n3 = 0
    table.insert(t2, (RunService.RenderStepped:Connect(function() -- line: 452
        -- upvalues: n3 (ref)
        n3 += 1
    end)))
    task.spawn(function() -- line: 456
        -- upvalues: Protocol (copy), v4 (ref), flush (copy), sampleMovement (copy), samplePerf (copy)
        local elapsed = os.clock()
        local elapsed2 = os.clock()

        while v4 do
            task.wait(Protocol.MoveSampleSeconds)

            if not v4 then
                break
            end

            sampleMovement()

            local elapsed3 = os.clock()

            if elapsed3 - elapsed2 >= Protocol.PerfSampleSeconds then
                samplePerf(elapsed3 - elapsed2)
                elapsed2 = elapsed3
            end

            if elapsed3 - elapsed >= Protocol.ClientFlushSeconds then
                elapsed = elapsed3
                flush()
            end
        end
    end)
end

local function stop() -- line: 478
    -- upvalues: t2 (copy), self (copy), t5 (copy), v3 (ref), v4 (ref), flush (copy)
    flush()
    v4 = false

    for _, v123 in ipairs(t2) do
        v123:Disconnect()
    end

    table.clear(t2)

    for _, v124 in pairs(self) do
        v124:Disconnect()
    end

    table.clear(self)
    table.clear(t5)
    table.clear(v3)
end

local function sync() -- line: 493
    -- upvalues: Protocol (copy), LocalPlayer (copy), v4 (ref), begin (copy), stop (copy)
    local v125 = LocalPlayer:GetAttribute(Protocol.RecordingAttribute) == true

    if not v125 or v4 then
        if not v125 and v4 then
            stop()
        end
    else
        begin()
    end
end

if not Config.Enabled then
    return
end

LocalPlayer:GetAttributeChangedSignal(Protocol.RecordingAttribute):Connect(sync)

local v126 = LocalPlayer:GetAttribute(Protocol.RecordingAttribute) == true

if not v126 or v4 then
    if not v126 and v4 then
        stop()
    end
else
    begin()
end
