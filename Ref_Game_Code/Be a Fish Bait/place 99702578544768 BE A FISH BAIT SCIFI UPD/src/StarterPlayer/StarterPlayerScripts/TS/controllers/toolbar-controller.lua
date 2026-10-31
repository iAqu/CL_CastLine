-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local UserInputService, Workspace = services.UserInputService, services.Workspace
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local functions = RuntimeLib.import(script, script.Parent.Parent, "network").functions
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent, "utils").localPlayerUserId
local getToolbarLayout = RuntimeLib.import(script, script.Parent.Parent, "react", "screen", "toolbar", "toolbar-layout-store").getToolbarLayout
local selectToolbarSlots = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectToolbarSlots
local selectIsCelebrationPlace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-config-snapshot.selectors").selectIsCelebrationPlace
local fishingMovementLockedAtom = RuntimeLib.import(script, script.Parent.Parent, "fishing-phase-atom").fishingMovementLockedAtom
local v1 = RuntimeLib.import(script, script.Parent.Parent, "react", "screen", "toolbar", "celebration-toolbar-utils")
local equipCelebrationSlotItem, selectLocalCelebrationToolbarSlots, toggleCelebrationSlotEquip = v1.equipCelebrationSlotItem, v1.selectLocalCelebrationToolbarSlots, v1.toggleCelebrationSlotEquip
local getToolbarSlotCountForViewportWidth = RuntimeLib.import(script, script.Parent.Parent, "react", "screen", "toolbar", "toolbar-metrics").getToolbarSlotCountForViewportWidth
local waterMovementHintVisibleAtom = RuntimeLib.import(script, script.Parent.Parent, "water-movement-ui-atom").waterMovementHintVisibleAtom
local t1 = {
    [Enum.KeyCode.One] = 0,
    [Enum.KeyCode.Two] = 1,
    [Enum.KeyCode.Three] = 2,
    [Enum.KeyCode.Four] = 3,
    [Enum.KeyCode.Five] = 4,
    [Enum.KeyCode.Six] = 5,
    [Enum.KeyCode.Seven] = 6,
    [Enum.KeyCode.Eight] = 7,
    [Enum.KeyCode.Nine] = 8
}
local t2 = {
    [Enum.KeyCode.ButtonL1] = -1,
    [Enum.KeyCode.ButtonR1] = 1
}
local v2 = selectToolbarSlots(localPlayerUserId)
local v3 = selectIsCelebrationPlace(localPlayerUserId)

local function getVisibleCelebrationSlotCount() -- line: 41
    -- upvalues: Workspace (copy), getToolbarSlotCountForViewportWidth (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera ~= nil then
        CurrentCamera = CurrentCamera.ViewportSize.X
    end

    if CurrentCamera == nil then
        CurrentCamera = 0
    end

    return getToolbarSlotCountForViewportWidth(CurrentCamera)
end

local function getVisibleCelebrationSlots(p1) -- line: 52
    -- upvalues: Workspace (copy), selectLocalCelebrationToolbarSlots (copy), getToolbarSlotCountForViewportWidth (copy)
    local v4 = selectLocalCelebrationToolbarSlots(p1)
    local t3 = {}
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera ~= nil then
        CurrentCamera = CurrentCamera.ViewportSize.X
    end

    if CurrentCamera == nil then
        CurrentCamera = 0
    end

    local v5 = getToolbarSlotCountForViewportWidth(CurrentCamera)
    local n1 = 0
    local v6 = false

    while true do
        if v6 then
            n1 += 1
        else
            v6 = true
        end

        if n1 < v5 and n1 < #v4 then
            table.insert(t3, v4[n1 + 1])
            continue
        end

        break
    end

    return t3
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 77
        return "ToolbarController"
    end
})

self.__index = self

function self.new(...) -- line: 82
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(_) -- line: 86
end

function self.onStart(p3) -- line: 88
    -- upvalues: UserInputService (copy)
    if not UserInputService.TouchEnabled then
        p3:_listenForKeyboardInput()
        p3:_listenForGamepadInput()
    end
end

function self._listenForKeyboardInput(p4) -- line: 95
    -- upvalues: UserInputService (copy), clientProducer (copy), functions (copy), t1 (copy)
    UserInputService.InputBegan:Connect(function(p5, p6) -- line: 96
        -- upvalues: p4 (copy), clientProducer (copy), functions (copy), t1 (copy)
        if p6 or p5.UserInputType ~= Enum.UserInputType.Keyboard then
            return nil
        end

        if p5.KeyCode == Enum.KeyCode.G then
            clientProducer.windowToggled({
                currentWindow = "backpack"
            })

            return nil
        end

        if p5.KeyCode == Enum.KeyCode.M then
            functions.toggleMount():catch(function(p7) -- line: 112
                warn("[src/client/controllers/toolbar-controller.ts:81]", (("Toggle mount request failed: %*"):format(p7)))
            end)

            return nil
        end

        local v10 = t1[p5.KeyCode]

        if v10 == nil then
            return nil
        end

        p4:_handleSlotKeyPress(v10)
    end)
end

function self._handleSlotKeyPress(_, p9) -- line: 125
    -- upvalues: clientProducer (copy), functions (copy), getToolbarLayout (copy), fishingMovementLockedAtom (copy), toggleCelebrationSlotEquip (copy), v2 (copy), v3 (copy), getVisibleCelebrationSlots (copy)
    if fishingMovementLockedAtom() then
        return nil
    end

    local v11 = clientProducer:getState()

    if v3(v11) then
        local v12 = getVisibleCelebrationSlots(v11)

        if not (#v12 <= p9) then
            local v13 = v12[p9 + 1]

            if v13 ~= nil then
                toggleCelebrationSlotEquip(v13)
            end
        end

        return nil
    end

    local toolbarSlots = getToolbarLayout().toolbarSlots

    if not (#toolbarSlots > 0) then
        toolbarSlots = v2(v11)
    end

    if #toolbarSlots <= p9 then
        return nil
    end

    local v14 = toolbarSlots[p9 + 1]

    if v14 == nil or v14 == false then
        return nil
    end

    if v14.isEquipped then
        functions.unequipInventoryItem(v14.itemId)
    else
        functions.equipInventoryItem(v14.itemId)
    end
end

function self._listenForGamepadInput(p10) -- line: 157
    -- upvalues: UserInputService (copy), waterMovementHintVisibleAtom (copy), t2 (copy)
    UserInputService.InputBegan:Connect(function(p11, p12) -- line: 158
        -- upvalues: p10 (copy), waterMovementHintVisibleAtom (copy), t2 (copy)
        if p12 or p11.KeyCode == Enum.KeyCode.ButtonR1 and waterMovementHintVisibleAtom() then
            return nil
        end

        local v15 = t2[p11.KeyCode]

        if v15 == nil then
            return nil
        end

        p10:_cycleEquippedToolbarSlot(v15)
    end)
end

function self._cycleEquippedToolbarSlot(_, p14) -- line: 173
    -- upvalues: clientProducer (copy), functions (copy), getToolbarLayout (copy), fishingMovementLockedAtom (copy), equipCelebrationSlotItem (copy), v2 (copy), v3 (copy), getVisibleCelebrationSlots (copy)
    if fishingMovementLockedAtom() then
        return nil
    end

    local v16 = clientProducer:getState()

    if v3(v16) then
        local v17 = getVisibleCelebrationSlots(v16)
        local v18 = #v17

        if not (v18 <= 0) then
            local n2 = 0
            local v19 = false

            while true do
                if v19 then
                    n2 += 1
                else
                    v19 = true
                end

                if n2 < v18 then
                    if v17[n2 + 1].isEquipped then
                        break
                    end

                    continue
                end

                n2 = -1
                break
            end

            if n2 == -1 then
                n2 = 0
            end

            local v20 = v17[(n2 + p14 + v18) % v18 + 1]

            if not v20.isEquipped then
                equipCelebrationSlotItem(v20)
            end
        end
    else
        local toolbarSlots = getToolbarLayout().toolbarSlots

        if not (#toolbarSlots > 0) then
            toolbarSlots = v2(v16)
        end

        local v21 = #toolbarSlots

        if not (v21 <= 0) then
            local n3 = 0
            local v22 = false

            while true do
                if v22 then
                    n3 += 1
                else
                    v22 = true
                end

                if n3 < v21 then
                    local v23 = toolbarSlots[n3 + 1]

                    if v23 ~= nil and v23 ~= false and v23.isEquipped then
                        break
                    end

                    continue
                end

                n3 = -1
                break
            end

            if n3 == -1 then
                n3 = 0
            end

            local v24 = toolbarSlots[(n3 + p14 + v21) % v21 + 1]

            if v24 ~= nil and v24 ~= false then
                if not v24.isEquipped then
                    functions.equipInventoryItem(v24.itemId)
                end

                return
            end
        end
    end

    return nil
end

Reflect.defineMetadata(self, "identifier", "client/controllers/toolbar-controller@ToolbarController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    ToolbarController = self
}
