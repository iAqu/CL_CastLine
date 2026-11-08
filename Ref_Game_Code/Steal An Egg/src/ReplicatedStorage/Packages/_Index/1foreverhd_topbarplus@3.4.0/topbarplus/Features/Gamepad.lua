-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GamepadService = game:GetService("GamepadService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local DPadUp = Enum.KeyCode.DPadUp
local Gamepad = Enum.PreferredInput.Gamepad
local v1
local t1 = {}

function t1.start(p1) -- line: 26
    -- upvalues: GamepadService (copy), UserInputService (copy), GuiService (copy), DPadUp (copy), Gamepad (copy), t1 (copy), v1 (ref)
    v1 = p1

    local v2 = v1

    if v1.highlightKey ~= nil then
        v2.highlightKey = v1.highlightKey
    else
        v2.highlightKey = DPadUp
    end

    v1.highlightIcon = false
    task.delay(1, function() -- line: 35
        -- upvalues: GamepadService (copy), UserInputService (copy), GuiService (copy), DPadUp (copy), Gamepad (copy), t1 (copy), v1 (ref)
        local iconsDictionary = v1.iconsDictionary

        local function getIconFromSelectedObject() -- line: 38
            -- upvalues: iconsDictionary (copy), GuiService (copy)
            local SelectedObject = GuiService.SelectedObject
            local CorrespondingIconUID = SelectedObject and SelectedObject:GetAttribute("CorrespondingIconUID")

            return CorrespondingIconUID and iconsDictionary[CorrespondingIconUID]
        end

        local v3
        local v4 = DPadUp ~= v1.highlightKey
        local v5 = DPadUp ~= v1.highlightKey
        local Selection = require(script.Parent.Parent.Elements.Selection)

        local function updateSelectedObject() -- line: 50
            -- upvalues: iconsDictionary (copy), v3 (ref), v4 (ref), v5 (ref), Selection (copy), UserInputService (copy), GuiService (copy), Gamepad (copy), t1 (copy), v1 (ref)
            local SelectedObject = GuiService.SelectedObject
            local CorrespondingIconUID = SelectedObject and SelectedObject:GetAttribute("CorrespondingIconUID")
            local v6 = CorrespondingIconUID and iconsDictionary[CorrespondingIconUID]
            local v7 = UserInputService.PreferredInput == Gamepad

            if v6 then
                if v7 then
                    local ClickRegion = v6:getInstance("ClickRegion")
                    local selection = v6.selection

                    if not selection then
                        selection = v6.janitor:add(Selection(v1))
                        selection:SetAttribute("IgnoreVisibilityUpdater", true)
                        selection.Parent = v6.widget
                        v6.selection = selection
                        v6:refreshAppearance(selection)
                    end

                    ClickRegion.SelectionImageObject = selection.Selection
                end

                if v3 and v3 ~= v6 then
                    v3:setIndicator()
                end

                local ButtonB = if v7 and not v5 and not v6.parentIconUID then Enum.KeyCode.ButtonB else nil

                v3 = v6
                v1.lastHighlightedIcon = v6
                v6:setIndicator(ButtonB)
            else
                local v8 = if v7 then v4 else nil
                local highlightKey = if not v7 or v8 then nil else v1.highlightKey

                v3 = v3 or t1.getIconToHighlight()

                if highlightKey == v1.highlightKey then
                    v4 = true
                end

                if v3 then
                    v3:setIndicator(highlightKey)
                end
            end
        end

        GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(updateSelectedObject)

        local function preferredInputChanged() -- line: 93
            -- upvalues: v4 (ref), v5 (ref), updateSelectedObject (copy), UserInputService (copy), Gamepad (copy)
            if UserInputService.PreferredInput ~= Gamepad then
                v4 = false
                v5 = false
            end

            updateSelectedObject()
        end

        UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(preferredInputChanged)

        if UserInputService.PreferredInput ~= Gamepad then
            v4 = false
            v5 = false
        end

        updateSelectedObject()
        UserInputService.InputBegan:Connect(function(p2, _) -- line: 109
            -- upvalues: iconsDictionary (copy), GamepadService (copy), GuiService (copy), t1 (copy), v1 (ref)
            if p2.UserInputType == Enum.UserInputType.MouseButton1 then
                local SelectedObject = GuiService.SelectedObject
                local CorrespondingIconUID = SelectedObject and SelectedObject:GetAttribute("CorrespondingIconUID")

                if CorrespondingIconUID and iconsDictionary[CorrespondingIconUID] then
                    GuiService.SelectedObject = nil
                end
            elseif p2.KeyCode == v1.highlightKey then
                local v9 = t1.getIconToHighlight()

                if v9 then
                    if GamepadService.GamepadCursorEnabled then
                        task.wait(0.2)
                        GamepadService:DisableGamepadCursor()
                    end

                    GuiService.SelectedObject = v9:getInstance("ClickRegion")
                end
            end
        end)
    end)
end

function t1.getIconToHighlight() -- line: 136
    -- upvalues: v1 (ref)
    local iconsDictionary = v1.iconsDictionary
    local v10 = v1.highlightIcon or v1.lastHighlightedIcon

    if not v10 then
        local v11 = v10
        local X

        for _, v12 in pairs(iconsDictionary) do
            if not v12.parentIconUID then
                local X2 = v12.widget.AbsolutePosition.X

                if not X or X2 < X then
                    v11 = v12
                    X = v12.widget.AbsolutePosition.X
                end
            end

            v10 = v11
        end
    end

    return v10
end

function t1.registerButton(p4) -- line: 158
    -- upvalues: GamepadService (copy), UserInputService (copy), GuiService (copy)
    local connection = UserInputService.InputBegan:Connect(function(p5) -- line: 161
        -- upvalues: p4 (copy), GamepadService (copy), GuiService (copy)
        task.wait()

        local v13 = GuiService.SelectedObject == p4
        local t2 = {
            "ButtonB",
            "ButtonSelect"
        }
        local Name = p5.KeyCode.Name

        if table.find(t2, Name) and v13 and (Name ~= "ButtonSelect" or GamepadService.GamepadCursorEnabled) then
            GuiService.SelectedObject = nil
        end
    end)

    p4.Destroying:Once(function() -- line: 175
        -- upvalues: connection (copy)
        connection:Disconnect()
    end)
end

return t1
