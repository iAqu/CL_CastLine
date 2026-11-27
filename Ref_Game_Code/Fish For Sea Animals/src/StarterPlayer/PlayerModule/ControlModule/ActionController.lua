-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local _ = {
    SERVER_AUTHORITY_CHANGED = "SERVER_AUTHORITY_CHANGED",
    ACTIONS_RELOADED = "ACTIONS_RELOADED"
}
local t1 = {}

t1.__index = t1

function t1.new() -- line: 19
    -- upvalues: t1 (copy)
    local self = setmetatable({}, t1)

    self.enabled = true

    return self
end

function t1:initializeActions() -- line: 26
    self.connectionUtil:trackConnection("SERVER_AUTHORITY_CHANGED", self.eventBus:subscribe("SERVER_AUTHORITY_CHANGED"):Connect(function() -- line: 29
        -- upvalues: self (copy)
        self.controlModule.actions = {}
    end))

    if not (self.controlModule.actions.MoveAction and self.controlModule.actions.JumpAction) and self.engineInterface.player then
        local function v2() -- line: 42
            -- upvalues: self (copy)
            local InputContexts = script.Parent.Parent.InputContexts

            if self.isServerAuthority then
                InputContexts = self.engineInterface.player.InputContexts
            end

            local CharacterContext = InputContexts.CharacterContext

            self.controlModule.actions = {
                MoveAction = CharacterContext.MoveAction,
                JumpAction = CharacterContext.JumpAction
            }
            self.eventBus:publish("ACTIONS_RELOADED")
        end

        pcall(v2)
    end
end

function t1:update() -- line: 58
    if not (self.controlModule.actions.MoveAction and self.controlModule.actions.JumpAction) then
        return
    end

    local ControlModule = self.playerModule.ControlModule

    self.controlModule.actions.MoveAction.Enabled = ControlModule.Enabled
    self.controlModule.actions.JumpAction.Enabled = ControlModule.Enabled
    self.controlModule.moveVector = self.controlModule.actions.MoveAction:GetState()
    self.controlModule.isJumping = self.controlModule.actions.JumpAction:GetState()
end

function t1.Enable(_, _) -- line: 72
end

return t1
