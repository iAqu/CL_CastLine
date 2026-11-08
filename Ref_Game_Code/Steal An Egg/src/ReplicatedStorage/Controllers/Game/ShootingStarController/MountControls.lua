-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local Assets = require(ReplicatedStorage.Data.Assets)
local ConsoleSignals = require(ReplicatedStorage.Client.ConsoleSignals)
local GUI = require(ReplicatedStorage.Client.GUI)
local InputIconsConfig = require(ReplicatedStorage.Client.InputIconsConfig)
local PlatformController = require(ReplicatedStorage.Client.PlatformController)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local LocalPlayer = Players.LocalPlayer
local ButtonB = Enum.KeyCode.ButtonB
local t1 = {}
local v1, v2, DismountHUD, v3, NameLabel, txt, txt2, UIScale, v4
local v5 = false
local v6 = false
local v7, v8, v9

local function session() -- line: 40
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local PetMountSession = Character and Character:FindFirstChild("PetMountSession")

    return if PetMountSession and PetMountSession:IsA("Model") then PetMountSession else nil
end

local function available() -- line: 46
    -- upvalues: GuiService (copy), UserInputService (copy), Tabs (copy)
    if Tabs.Active() == nil then
        return not GuiService.MenuIsOpen and UserInputService:GetFocusedTextBox() == nil
    end

    return false
end

local function petName(p1) -- line: 50
    -- upvalues: Assets (copy), Save (copy)
    local v10 = Save.Peek()
    local v11 = v10 and p1 and v10.Inventory[p1]
    local v12 = v11 and Assets.Directory[v11.Category]
    local v13 = if v12 then v12.DisplayName or v11.Category else "Your mount"

    if v11 and v13 == v11.Category then
        v13 = v13:gsub("(%l)(%u)", "%1 %2"):gsub("(%u)(%u%l)", "%1 %2"):gsub("_", " ")
    end

    return v13
end

local function nearest() -- line: 62
    -- upvalues: GuiService (copy), UserInputService (copy), Tabs (copy), LocalPlayer (copy), v7 (ref), v8 (ref)
    if not v7 or v8() ~= "Ride" or Tabs.Active() ~= nil or GuiService.MenuIsOpen or UserInputService:GetFocusedTextBox() ~= nil then
        return nil
    end

    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        local n1 = 1e999
        local v14

        for v15, v16 in v7() do
            local Prompt = v16.Prompt
            local PromptParent = Prompt.Parent

            if v16.Mode == "Ride" and Prompt.Enabled and PromptParent and PromptParent:IsA("BasePart") then
                local Magnitude = (HumanoidRootPart.Position - PromptParent.Position).Magnitude

                if Magnitude <= Prompt.MaxActivationDistance and (Magnitude < n1 or Magnitude == n1 and (v14 == nil or v15 < v14)) then
                    n1 = Magnitude
                    v14 = v15
                end
            end
        end

        return v14
    end

    return nil
end

local function dismount() -- line: 81
    -- upvalues: GuiService (copy), UserInputService (copy), Remotes (copy), Tabs (copy), LocalPlayer (copy), v6 (ref)
    if v6 then
        return
    end

    local Character = LocalPlayer.Character
    local PetMountSession = Character and Character:FindFirstChild("PetMountSession")

    if not (PetMountSession and PetMountSession:IsA("Model")) then
        PetMountSession = nil
    end

    if PetMountSession and Tabs.Active() == nil and not GuiService.MenuIsOpen and UserInputService:GetFocusedTextBox() == nil then
        v6 = true
        task.spawn(function() -- line: 84
            -- upvalues: Remotes (copy), v6 (ref)
            local function v17() -- line: 85
                -- upvalues: Remotes (copy)
                Remotes.PetMount.Request:InvokeServer("dismount")
            end

            pcall(v17)
            v6 = false
        end)
    end
end

local function setText(p2, p3) -- line: 90
    if p2 and p2.Text ~= p3 then
        p2.Text = p3
    end
end

local function dismountCaption() -- line: 96
    -- upvalues: InputIconsConfig (copy), PlatformController (copy), ButtonB (copy)
    if PlatformController.IsConsole() then
        if InputIconsConfig.Image(ButtonB) then
            return "Dismount"
        end

        return (if InputIconsConfig.Vendor() == "sony" then "[O]" else "[B]") .. " Dismount"
    end

    if PlatformController.IsMobile() then
        return "Dismount"
    end

    return "[F] Dismount"
end

function t1.Refresh() -- line: 104
    -- upvalues: ContextActionService (copy), GuiService (copy), UserInputService (copy), InputIconsConfig (copy), PlatformController (copy), Remotes (copy), Tabs (copy), LocalPlayer (copy), ButtonB (copy), v1 (ref), v2 (ref), DismountHUD (ref), v3 (ref), NameLabel (ref), txt (ref), txt2 (ref), UIScale (ref), v4 (ref), v5 (ref), v6 (ref), petName (copy), nearest (copy)
    if not (v1 and v2 and DismountHUD and v3 and NameLabel) then
        return
    end

    local Character = LocalPlayer.Character
    local PetMountSession = Character and Character:FindFirstChild("PetMountSession")

    if not (PetMountSession and PetMountSession:IsA("Model")) then
        PetMountSession = nil
    end

    if PetMountSession ~= nil ~= v5 then
        v5 = PetMountSession ~= nil
        ContextActionService:UnbindAction("StarMountDismount")

        if v5 then
            ContextActionService:BindAction("StarMountDismount", function(_, p5) -- line: 111
                -- upvalues: GuiService (copy), UserInputService (copy), Remotes (copy), Tabs (copy), LocalPlayer (copy), v6 (ref)
                if p5 ~= Enum.UserInputState.Begin then
                    return Enum.ContextActionResult.Pass
                end

                local v19 = Tabs.Active() == nil and not GuiService.MenuIsOpen and UserInputService:GetFocusedTextBox() == nil
                local v20 = false
                local v21 = false
                local v22 = false
                local v23 = false
                local v24 = false

                if v19 then
                    v20 = true
                else
                    v24 = true
                end

                if v20 then
                    if v6 then
                        v24 = false
                    else
                        v21 = true
                    end
                end

                v20 = false

                local Character, v25

                if v21 then
                    Character = LocalPlayer.Character

                    if Character then
                        v20 = true
                    else
                        v25 = Character
                        v22 = true
                    end
                end

                v21 = false

                if v20 then
                    v25 = Character:FindFirstChild("PetMountSession")
                    v22 = true
                end

                v20 = false

                if v22 then
                    if v25 then
                        v20 = true
                    else
                        v21 = true
                    end
                end

                v22 = false

                if v20 then
                    if v25:IsA("Model") then
                        v22 = true
                    else
                        v21 = true
                    end
                end

                v20 = false

                if v21 then
                    v20 = true
                end

                v21 = false

                local v26

                if v22 then
                    v26 = v25
                    v20 = true
                end

                v22 = false

                if v20 then
                    if v26 then
                        v22 = true
                    else
                        v24 = false
                    end
                end

                v20 = false

                local v27

                if v22 then
                    if Tabs.Active() ~= nil then
                        v27 = false
                        v21 = true
                    else
                        v20 = true
                    end
                end

                v22 = false

                if v20 then
                    local v28 = not GuiService.MenuIsOpen

                    if v28 then
                        v22 = true
                    else
                        v27 = v28
                        v21 = true
                    end
                end

                v20 = false

                if v22 then
                    if UserInputService:GetFocusedTextBox() ~= nil then
                        v20 = true
                    else
                        v23 = true
                    end
                end

                if v20 then
                    v27 = false
                    v21 = true
                end

                if v23 then
                    v27 = true
                    v21 = true
                end

                v23 = false

                if v21 then
                    if v27 then
                        v23 = true
                    else
                        v24 = false
                    end
                end

                if v23 then
                    v6 = true
                    v24 = false
                    task.spawn(function() -- line: 84
                        -- upvalues: Remotes (copy), v6 (ref)
                        local function v29() -- line: 85
                            -- upvalues: Remotes (copy)
                            Remotes.PetMount.Request:InvokeServer("dismount")
                        end

                        pcall(v29)
                        v6 = false
                    end)
                end

                if not v24 then
                    return Enum.ContextActionResult.Sink
                end

                return Enum.ContextActionResult.Pass
            end, false, Enum.KeyCode.F, ButtonB)
        end
    end

    v4 = nearest()

    local v30 = Tabs.Active() == nil and not GuiService.MenuIsOpen and UserInputService:GetFocusedTextBox() == nil and (PetMountSession ~= nil or PlatformController.IsMobile() and v4 ~= nil)

    DismountHUD.Visible = v30
    v1.Visible = v30 and PetMountSession == nil
    v2.Visible = v30 and PetMountSession ~= nil
    v3.Visible = v30

    if v30 then
        local NameLabel2 = NameLabel
        local v34 = petName(if PetMountSession then PetMountSession:GetAttribute("UID") else v4)

        if NameLabel2 and NameLabel2.Text ~= v34 then
            NameLabel2.Text = v34
        end
    end

    local txt3 = txt

    if txt3 and txt3.Text ~= "Mount" then
        txt3.Text = "Mount"
    end

    local txt4 = txt2
    local v35 = if PlatformController.IsConsole() then if InputIconsConfig.Image(ButtonB) then "Dismount" else (if InputIconsConfig.Vendor() == "sony" then "[O]" else "[B]") .. " Dismount" elseif PlatformController.IsMobile() then "Dismount" else "[F] Dismount"

    if txt4 and txt4.Text ~= v35 then
        txt4.Text = v35
    end

    if UIScale then
        UIScale.Scale = PlatformController.IsConsole() and 0.8 or 1
    end
end

function t1.Bind(p6, p7, p8) -- line: 136
    -- upvalues: GuiService (copy), RunService (copy), UserInputService (copy), ButtonFX (copy), ConsoleSignals (copy), GUI (copy), InputIconsConfig (copy), PlatformController (copy), Remotes (copy), Tabs (copy), LocalPlayer (copy), t1 (copy), v1 (ref), v2 (ref), DismountHUD (ref), v3 (ref), NameLabel (ref), txt (ref), txt2 (ref), UIScale (ref), v4 (ref), v6 (ref), v7 (ref), v8 (ref), v9 (ref), nearest (copy), dismount (copy)
    if v1 then
        return
    end

    v7 = p6
    v8 = p7
    v9 = p8

    local HUD = GUI.Get("HUD")
    local GameHUD = HUD and HUD:FindFirstChild("GameHUD")
    local DismountHUD2 = GameHUD and GameHUD:FindFirstChild("DismountHUD")
    local v36, v37, v38

    if DismountHUD2 then
        v37 = DismountHUD2:FindFirstChild("Mount")
        v38 = DismountHUD2:FindFirstChild("Dismount")
        v36 = DismountHUD2:FindFirstChild("AnimalNameHolder")
    else
        v36 = DismountHUD2
        v37 = DismountHUD2
        v38 = DismountHUD2
    end

    local NameLabel2 = v36 and v36:FindFirstChild("NameLabel")

    if not DismountHUD2
        or not DismountHUD2:IsA("Frame")
        or not v37
        or not v37:IsA("ImageButton")
        or not v38
        or not v38:IsA("ImageButton")
        or not v36
        or not v36:IsA("GuiObject")
        or not NameLabel2
        or not NameLabel2:IsA("TextLabel") then
        warn("Mount controls require HUD.GameHUD.DismountHUD")

        return
    end

    DismountHUD = DismountHUD2
    v1 = v37
    v2 = v38
    v3 = v36
    NameLabel = NameLabel2

    local txt3 = v37:FindFirstChild("txt")

    if not txt3 or not txt3:IsA("TextLabel") then
        txt3 = nil
    end

    txt = txt3

    local txt4 = v38:FindFirstChild("txt")

    if not (txt4 and txt4:IsA("TextLabel")) then
        txt4 = nil
    end

    txt2 = txt4

    local UIScale2 = Instance.new("UIScale")

    UIScale2.Parent = DismountHUD2
    UIScale = UIScale2
    ButtonFX(v38, nil, dismount)

    local ButtonUp = ConsoleSignals.ButtonUp
    local v39 = v38

    ButtonUp:Connect(function(p9) -- line: 167
        -- upvalues: v39 (copy), GuiService (copy), UserInputService (copy), Remotes (copy), Tabs (copy), LocalPlayer (copy), v6 (ref)
        if p9 == v39 and not v6 then
            local Character = LocalPlayer.Character
            local PetMountSession = Character and Character:FindFirstChild("PetMountSession")

            if not (PetMountSession and PetMountSession:IsA("Model")) then
                PetMountSession = nil
            end

            if PetMountSession then
                if Tabs.Active() ~= nil or GuiService.MenuIsOpen or UserInputService:GetFocusedTextBox() ~= nil then
                    return
                end

                v6 = true
                task.spawn(function() -- line: 84
                    -- upvalues: Remotes (copy), v6 (ref)
                    local function v40() -- line: 85
                        -- upvalues: Remotes (copy)
                        Remotes.PetMount.Request:InvokeServer("dismount")
                    end

                    pcall(v40)
                    v6 = false
                end)
            end
        end
    end)
    ButtonFX(v37, nil, function() -- line: 170
        -- upvalues: GuiService (copy), UserInputService (copy), Remotes (copy), Tabs (copy), LocalPlayer (copy), t1 (copy), v4 (ref), v6 (ref), v9 (ref), nearest (copy)
        if v6 or Tabs.Active() ~= nil or GuiService.MenuIsOpen or UserInputService:GetFocusedTextBox() ~= nil then
            return
        end

        local Character = LocalPlayer.Character
        local PetMountSession = Character and Character:FindFirstChild("PetMountSession")

        if not (PetMountSession and PetMountSession:IsA("Model")) then
            PetMountSession = nil
        end

        if PetMountSession then
            if not v6 then
                local Character = LocalPlayer.Character
                local PetMountSession = Character and Character:FindFirstChild("PetMountSession")

                if not (PetMountSession and PetMountSession:IsA("Model")) then
                    PetMountSession = nil
                end

                if PetMountSession then
                    if Tabs.Active() ~= nil or GuiService.MenuIsOpen or UserInputService:GetFocusedTextBox() ~= nil then
                        return
                    end

                    v6 = true
                    task.spawn(function() -- line: 84
                        -- upvalues: Remotes (copy), v6 (ref)
                        local function v41() -- line: 85
                            -- upvalues: Remotes (copy)
                            Remotes.PetMount.Request:InvokeServer("dismount")
                        end

                        pcall(v41)
                        v6 = false
                    end)
                end
            end
        else
            local v42 = nearest()

            if v42 ~= nil and v42 == v4 then
                v6 = true

                local v43 = v9
                local ok, result = pcall(v43, v42)

                v6 = false

                if not ok then
                    warn("Mount request failed: " .. tostring(result))
                end

                return
            end

            t1.Refresh()
        end
    end)

    local n2 = 0

    RunService.Heartbeat:Connect(function(p10) -- line: 181
        -- upvalues: n2 (ref), t1 (copy)
        n2 += p10

        if not (n2 < 0.1) then
            n2 = 0
            t1.Refresh()
        end
    end)
    PlatformController.Changed:Connect(t1.Refresh)
    InputIconsConfig.Changed:Connect(t1.Refresh)
    t1.Refresh()
end

return t1
