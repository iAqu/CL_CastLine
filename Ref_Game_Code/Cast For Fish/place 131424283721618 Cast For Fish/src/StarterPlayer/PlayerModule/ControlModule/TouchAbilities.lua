-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local CommonUtils = require(script.Parent.Parent:WaitForChild("CommonUtils"))
local v1 = require(script.Parent:WaitForChild("AvatarAbilitiesInterface")).get(Players.LocalPlayer)
local InputSlots = require(script.Parent:WaitForChild("InputSlots"))
local AbilityButton = require(script.Parent:WaitForChild("AbilityButton"))
local UserAbilitiesUserInterfaceA = CommonUtils.get("FlagUtil").getUserFlag("UserAbilitiesUserInterfaceA")
local t1 = {
    {
        small = { 72, 60, 60 },
        large = { 92, 112, 112 }
    },
    {
        small = { 44, 132, 132 },
        large = { 56, 200, 200 }
    },
    {
        small = { 44, 132, 16 },
        large = { 56, 200, 60 }
    },
    {
        small = { 44, 16, 132 },
        large = { 56, 60, 200 }
    },
    {
        small = { 44, 156, 74 },
        large = { 56, 228, 130 }
    },
    {
        small = { 44, 74, 156 },
        large = { 56, 130, 228 }
    },
    {
        small = { 44, 16, 16 },
        large = { 56, 60, 60 }
    }
}
local t2 = {}

t2.__index = t2

function t2.new(p1) -- line: 52
    -- upvalues: t2 (copy)
    local self = setmetatable({}, t2)

    self.parentUIFrame = p1
    self.managedButtons = {}
    self.connections = {}
    self.created = false
    self.enabled = false
    self.enabledChangedEvent = Instance.new("BindableEvent")

    return self
end

function t2:Enable(p3) -- line: 66
    if self.enabled == p3 then
        return
    end

    self.enabled = p3

    if p3 and not self.created then
        self:Create()
        self.created = true
    end

    self.enabledChangedEvent:Fire()
end

function t2:Create() -- line: 80
    -- upvalues: v1 (copy), InputSlots (copy), AbilityButton (copy), UserAbilitiesUserInterfaceA (copy), t1 (copy)
    if self.parentUIFrame then
        local function CreateButtons() -- line: 85
            -- upvalues: self (copy), v1 (copy), InputSlots (copy), AbilityButton (copy), UserAbilitiesUserInterfaceA (copy), t1 (copy)
            for _, v3 in self.managedButtons do
                v3:Destroy()
            end

            self.managedButtons = {}

            if v1:isEnabled() then
                for v4, v5 in (InputSlots.GetSlotMap()) do
                    local v6 = InputSlots.GetActionInSlot(v4)

                    if v5 and v6 and v4 <= #t1 and (UserAbilitiesUserInterfaceA or v4 == 1) then
                        local AbilityConfig = v1:GetAbilityConfig(v5)

                        table.insert(self.managedButtons, AbilityButton.create(self, v5, AbilityConfig, v6, t1[v4], false))
                    end
                end
            end
        end

        CreateButtons()
        table.insert(self.connections, InputSlots.GetSlotMapChangedSignal():Connect(CreateButtons))
        table.insert(self.connections, v1:GetEnabledChangedSignal():Connect(CreateButtons))
    end
end

function t2:Destroy() -- line: 122
    for _, v9 in self.connections do
        v9:Disconnect()
    end

    self.connections = {}

    for _, v10 in self.managedButtons do
        v10:Destroy()
    end

    self.managedButtons = {}
    self.enabledChangedEvent:Destroy()
    self.created = false
    self.enabled = false
end

return t2
