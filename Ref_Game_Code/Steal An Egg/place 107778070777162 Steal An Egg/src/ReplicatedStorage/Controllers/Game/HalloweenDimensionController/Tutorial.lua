-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ButtonFX = require(ReplicatedStorage.Client.UI.VFX.ButtonFX)
local GUI = require(ReplicatedStorage.Client.GUI)
local HalloweenDimension = require(ReplicatedStorage.Shared.Util.HalloweenDimension)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local MenuNavigation = require(ReplicatedStorage.Client.MenuNavigation)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Transition = require(script.Parent.Transition)

require(ReplicatedStorage.Packages.Trove)

local LocalPlayer = Players.LocalPlayer
local Inside = HalloweenDimension.PlayerAttributes.Inside
local t1 = {}

local function isInside() -- line: 36
    -- upvalues: LocalPlayer (copy), Inside (copy)
    return LocalPlayer:GetAttribute(Inside) == true
end

local function hasSeen() -- line: 40
    -- upvalues: Save (copy)
    local v1 = Save.Await()

    if v1 == nil then
        return true
    end

    return v1.HalloweenDimension.TutorialSeen == true
end

local function peekSeen() -- line: 45
    -- upvalues: Save (copy)
    local v2 = Save.Peek()

    return v2 ~= nil and v2.HalloweenDimension.TutorialSeen == true
end

function t1.Start(p1) -- line: 54
    -- upvalues: GuiService (copy), ButtonFX (copy), GUI (copy), HiddenUIHandler (copy), MenuNavigation (copy), Remotes (copy), Save (copy), Tabs (copy), Transition (copy), LocalPlayer (copy), Inside (copy)
    local v3, HalloweenEventTutorialFrame, Ok, v4
    local v5 = false
    local n1 = 0
    local v6 = Save.Peek()
    local v7 = false

    if v6 ~= nil then
        v7 = v6.HalloweenDimension.TutorialSeen == true
    end

    local function hide() -- line: 63
        -- upvalues: v3 (ref), v4 (ref), GuiService (copy), MenuNavigation (copy)
        local v8 = v3
        local v9 = true

        if v8 ~= nil then
            if v8.Enabled then
                v8.Enabled = false
                MenuNavigation.SetOverride("HalloweenTutorial", nil)

                local SelectedObject = GuiService.SelectedObject

                if SelectedObject ~= nil and SelectedObject:IsDescendantOf(v8) then
                    GuiService.SelectedObject = nil
                end

                v9 = false
            end
        end

        if v9 then
            return
        end

        local v10 = v4

        v4 = nil

        if v10 ~= nil then
            v10()
        end
    end

    local function acknowledge() -- line: 81
        -- upvalues: v3 (ref), v5 (ref), hide (copy), Remotes (copy)
        local v11 = v3

        if v11 ~= nil and v11.Enabled then
            v5 = true
            hide()
            task.spawn(function() -- line: 88
                -- upvalues: Remotes (copy)
                local function v12() -- line: 89
                    -- upvalues: Remotes (copy)
                    Remotes.HalloweenDimension.AskTutorialSeen:InvokeServer()
                end

                pcall(v12)
            end)
        end
    end

    local function bind() -- line: 95
        -- upvalues: p1 (copy), v3 (ref), HalloweenEventTutorialFrame (ref), Ok (ref), acknowledge (copy), ButtonFX (copy), GUI (copy)
        local v13 = v3

        if v13 ~= nil then
            return v13
        end

        local v14 = GUI.HalloweenEventTutorialFrame()

        assert(v14:IsA("ScreenGui"), "HalloweenEventTutorialFrame must be a ScreenGui")

        local HalloweenEventTutorialFrame2 = v14:FindFirstChild("HalloweenEventTutorialFrame")

        assert(HalloweenEventTutorialFrame2 ~= nil and HalloweenEventTutorialFrame2:IsA("Frame"), "HalloweenEventTutorialFrame.HalloweenEventTutorialFrame must be a Frame")

        local Ok2 = HalloweenEventTutorialFrame2:FindFirstChild("Ok")

        assert(Ok2 ~= nil and Ok2:IsA("ImageButton"), "HalloweenEventTutorialFrame.Ok must be an ImageButton")
        p1:Add(GUI.OnActivated(Ok2, acknowledge), "Disconnect")
        p1:Add(ButtonFX(Ok2))
        HalloweenEventTutorialFrame = HalloweenEventTutorialFrame2
        Ok = Ok2
        v3 = v14

        return v14
    end

    local function show() -- line: 114
        -- upvalues: HalloweenEventTutorialFrame (ref), Ok (ref), v4 (ref), acknowledge (copy), bind (copy), HiddenUIHandler (copy), MenuNavigation (copy), Tabs (copy)
        local v17 = bind()

        if v17.Enabled then
            return
        end

        Tabs.Deactivate({
            instant = true
        })
        v4 = HiddenUIHandler.Acquire()
        v17.Enabled = true
        MenuNavigation.SetOverride("HalloweenTutorial", HalloweenEventTutorialFrame, Ok, acknowledge, 1000, true, true)
    end

    local function arrive() -- line: 133
        -- upvalues: v5 (ref), n1 (ref), show (copy), Save (copy), Transition (copy), LocalPlayer (copy), Inside (copy)
        n1 += 1

        local v18 = n1

        task.spawn(function() -- line: 136
            -- upvalues: v18 (copy), v5 (ref), n1 (ref), show (copy), Save (copy), Transition (copy), LocalPlayer (copy), Inside (copy)
            if v5 then
                return
            end

            local v19 = Save.Await()

            if v19 ~= nil and v19.HalloweenDimension.TutorialSeen ~= true then
                local elapsed = os.clock()

                while Transition.IsCovering() and os.clock() - elapsed < 30 do
                    task.wait()
                end

                task.wait(0.9)

                if v18 == n1 and not v5 then
                    local v20 = LocalPlayer:GetAttribute(Inside) == true

                    if v20 then
                        local v21 = Save.Await()

                        if v21 ~= nil and v21.HalloweenDimension.TutorialSeen ~= true then
                            show()
                        end
                    end
                end
            end
        end)
    end

    local function depart() -- line: 152
        -- upvalues: n1 (ref), hide (copy)
        n1 += 1
        hide()
    end

    local function syncInside() -- line: 157
        -- upvalues: v5 (ref), n1 (ref), hide (copy), show (copy), Save (copy), Transition (copy), LocalPlayer (copy), Inside (copy)
        if LocalPlayer:GetAttribute(Inside) ~= true then
            n1 += 1
            hide()

            return
        end

        n1 += 1

        local v22 = n1

        task.spawn(function() -- line: 136
            -- upvalues: v22 (copy), v5 (ref), n1 (ref), show (copy), Save (copy), Transition (copy), LocalPlayer (copy), Inside (copy)
            if v5 then
                return
            end

            local v23 = Save.Await()

            if v23 ~= nil and v23.HalloweenDimension.TutorialSeen ~= true then
                local elapsed = os.clock()

                while Transition.IsCovering() and os.clock() - elapsed < 30 do
                    task.wait()
                end

                task.wait(0.9)

                if v22 == n1 and not v5 then
                    local v24 = LocalPlayer:GetAttribute(Inside) == true

                    if v24 then
                        local v25 = Save.Await()

                        if v25 ~= nil and v25.HalloweenDimension.TutorialSeen ~= true then
                            show()
                        end
                    end
                end
            end
        end)
    end

    p1:Connect(LocalPlayer:GetAttributeChangedSignal(Inside), syncInside)
    p1:Connect(LocalPlayer.CharacterAdded, depart)
    p1:Add(Save.WatchFields("HalloweenDimension", function() -- line: 167
        -- upvalues: v5 (ref), v7 (ref), Save (copy)
        local v26 = Save.Peek()
        local v27 = v26 ~= nil and v26.HalloweenDimension.TutorialSeen == true

        if v7 and not v27 then
            v5 = false
        end

        v7 = v27
    end))
    p1:Add(depart)

    if LocalPlayer:GetAttribute(Inside) ~= true then
        return
    end

    n1 += 1

    local v28 = n1

    task.spawn(function() -- line: 136
        -- upvalues: v5 (ref), n1 (ref), show (copy), v28 (copy), Save (copy), Transition (copy), LocalPlayer (copy), Inside (copy)
        if v5 then
            return
        end

        local v29 = Save.Await()

        if v29 ~= nil and v29.HalloweenDimension.TutorialSeen ~= true then
            local elapsed = os.clock()

            while Transition.IsCovering() and os.clock() - elapsed < 30 do
                task.wait()
            end

            task.wait(0.9)

            if v28 == n1 and not v5 then
                local v30 = LocalPlayer:GetAttribute(Inside) == true

                if v30 then
                    local v31 = Save.Await()

                    if v31 ~= nil and v31.HalloweenDimension.TutorialSeen ~= true then
                        show()
                    end
                end
            end
        end
    end)
end

return table.freeze(t1)
