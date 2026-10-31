-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CommonUtils = require(script:WaitForChild("CommonUtils"))

if CommonUtils.get("FlagUtil").getUserFlag("UserControlModuleEnabledAPI") then
    return {
        ControlModule = {
            Enabled = true
        }
    }
end

local RunService = game:GetService("RunService")
local CharacterUtil = CommonUtils.get("CharacterUtil")
local ConnectionUtil = CommonUtils.get("ConnectionUtil")
local EventBus = CommonUtils.get("EventBus")
local CameraModule = require(script:WaitForChild("CameraModule"))
local ControlModule = require(script:WaitForChild("ControlModule"))
local ServerAuthority = require(script:WaitForChild("ServerAuthority"))
local _ = {
    BIND_TO_SIMULATION = "BIND_TO_SIMULATION",
    RENDERSTEPPED_INPUT = "PLAYERMODULE_RENDERSTEPPED_INPUT",
    RENDERSTEPPED_CAMERA = "PLAYERMODULE_RENDERSTEPPED_CAMERA",
    ONLOCALPLAYER = "ONLOCALPLAYER"
}
local t1 = {}

t1.__index = t1

function t1.new() -- line: 65
    -- upvalues: ConnectionUtil (copy), EventBus (copy), t1 (copy)
    return (setmetatable({
        data = {
            isJumping = false,
            player = nil,
            character = nil,
            isServerAuthority = false,
            moveVector = Vector2.new(),
            actions = {},
            connectionUtil = ConnectionUtil.new(),
            eventBus = EventBus.new()
        }
    }, t1))
end

function t1.start(p1) -- line: 82
    -- upvalues: RunService (copy), CharacterUtil (copy), CameraModule (copy), ControlModule (copy), ServerAuthority (copy)
    p1.data.connectionUtil:trackConnection("ONLOCALPLAYER", CharacterUtil.onLocalPlayer(function(p2) -- line: 84
        -- upvalues: p1 (copy), RunService (copy), CharacterUtil (copy), CameraModule (copy), ControlModule (copy), ServerAuthority (copy)
        p1.data.player = p2
        ServerAuthority.initialize(p1.data)
        ControlModule:initialize(p1.data)
        RunService:BindToRenderStep("PLAYERMODULE_RENDERSTEPPED_INPUT", Enum.RenderPriority.Input.Value, function(p3) -- line: 91
            -- upvalues: p1 (copy), CharacterUtil (copy), ControlModule (copy)
            p1.data.character = CharacterUtil.getCharacter()

            if p1.data.character then
                ControlModule:Update(p1.data, p3)
            end
        end)
        p1.data.connectionUtil:trackBoundFunction("PLAYERMODULE_RENDERSTEPPED_INPUT", function() -- line: 99
            -- upvalues: RunService (copy)
            RunService:UnbindFromRenderStep("PLAYERMODULE_RENDERSTEPPED_INPUT")
        end)
        RunService:BindToRenderStep("PLAYERMODULE_RENDERSTEPPED_CAMERA", Enum.RenderPriority.Camera.Value, function(p4) -- line: 104
            -- upvalues: p1 (copy), CameraModule (copy)
            CameraModule:Update(p1.data, p4)
        end)
        p1.data.connectionUtil:trackBoundFunction("PLAYERMODULE_RENDERSTEPPED_CAMERA", function() -- line: 107
            -- upvalues: RunService (copy)
            RunService:UnbindFromRenderStep("PLAYERMODULE_RENDERSTEPPED_CAMERA")
        end)
    end))
end

function t1.stop(p5) -- line: 113
    p5.data.connectionUtil:disconnectAll()
end

t1.new():start()

return {}
