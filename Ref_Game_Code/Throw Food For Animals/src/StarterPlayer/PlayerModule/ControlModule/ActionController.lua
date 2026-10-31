-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local UserControlModuleEnabledAPI = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil").getUserFlag("UserControlModuleEnabledAPI")
local _ = {
    SERVER_AUTHORITY_CHANGED = "SERVER_AUTHORITY_CHANGED",
    ACTIONS_RELOADED = "ACTIONS_RELOADED"
}
local t1 = {}

t1.__index = t1

function t1.new() -- line: 23
    -- upvalues: t1 (copy)
    local self = setmetatable({}, t1)

    self.enabled = true

    return self
end

function t1:initializeActions() -- line: 31
    self.connectionUtil:trackConnection("SERVER_AUTHORITY_CHANGED", self.eventBus:subscribe("SERVER_AUTHORITY_CHANGED"):Connect(function() -- line: 33
        -- upvalues: self (copy)
        self.actions = {}
    end))

    if not (self.actions.MoveAction and self.actions.JumpAction) and self.player then
        local function v2() -- line: 42
            -- upvalues: self (copy)
            local InputContexts = script.Parent.Parent.InputContexts

            if self.isServerAuthority then
                InputContexts = self.player.InputContexts
            end

            local CharacterContext = InputContexts.CharacterContext

            self.actions = {
                MoveAction = CharacterContext.MoveAction,
                JumpAction = CharacterContext.JumpAction
            }
            self.eventBus:publish("ACTIONS_RELOADED")
        end

        pcall(v2)
    end
end

function t1:update() -- line: 58
    -- upvalues: UserControlModuleEnabledAPI (copy)
    if UserControlModuleEnabledAPI then
        if not (self.actions.MoveAction and self.actions.JumpAction) then
            return
        end

        local ControlModule = self.playerModule.ControlModule

        self.actions.MoveAction.Enabled = ControlModule.Enabled
        self.actions.JumpAction.Enabled = ControlModule.Enabled
    end

    self.moveVector = self.actions.MoveAction:GetState()
    self.isJumping = self.actions.JumpAction:GetState()
end

function t1.Enable(_, _) -- line: 74
end

return t1
