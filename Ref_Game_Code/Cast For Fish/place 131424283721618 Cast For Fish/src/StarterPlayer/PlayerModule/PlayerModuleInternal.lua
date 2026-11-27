-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local CommonUtils = require(script.Parent:WaitForChild("CommonUtils"))

require(script.Parent.Types)

local CharacterUtil = CommonUtils.get("CharacterUtil")
local ConnectionUtil = CommonUtils.get("ConnectionUtil")
local EventBus = CommonUtils.get("EventBus")
local UserPlayerModuleEngineAPI = CommonUtils.get("FlagUtil").getUserFlag("UserPlayerModuleEngineAPI")
local Parent = require(script.Parent)
local CameraModule = require(script.Parent:WaitForChild("CameraModule"))
local ControlModule = require(script.Parent:WaitForChild("ControlModule"))
local EngineInterface = require(script.Parent:WaitForChild("EngineInterface"))
local InputSampler = require(script.Parent:WaitForChild("InputSampler"))
local ServerAuthority = require(script.Parent:WaitForChild("ServerAuthority"))
local _ = {
    BIND_TO_SIMULATION = "BIND_TO_SIMULATION",
    RENDERSTEPPED_INPUT = "PLAYERMODULE_RENDERSTEPPED_INPUT",
    RENDERSTEPPED_CAMERA = "PLAYERMODULE_RENDERSTEPPED_CAMERA",
    ONLOCALPLAYER = "ONLOCALPLAYER"
}
local t1 = {}

t1.__index = t1

function t1.new() -- line: 51
    -- upvalues: ConnectionUtil (copy), EventBus (copy), Parent (copy), InputSampler (copy), t1 (copy)
    return (setmetatable({
        data = {
            isServerAuthority = false,
            playerModule = Parent,
            controlModule = {
                isJumping = false,
                enabled = true,
                moveVector = Vector2.new(),
                worldMoveVector = Vector3.new(),
                actions = {}
            },
            engineInterface = {
                player = nil,
                character = nil,
                humanoid = nil,
                characterChanged = false
            },
            connectionUtil = ConnectionUtil.new(),
            eventBus = EventBus.new()
        },
        inputSampler = InputSampler.new()
    }, t1))
end

function t1.start(p1) -- line: 78
    -- upvalues: RunService (copy), CharacterUtil (copy), UserPlayerModuleEngineAPI (copy), CameraModule (copy), ControlModule (copy), EngineInterface (copy), ServerAuthority (copy)
    p1.data.connectionUtil:trackConnection("ONLOCALPLAYER", CharacterUtil.onLocalPlayer(function(p2) -- line: 82
        -- upvalues: p1 (copy), RunService (copy), CharacterUtil (copy), UserPlayerModuleEngineAPI (copy), CameraModule (copy), ControlModule (copy), EngineInterface (copy), ServerAuthority (copy)
        if UserPlayerModuleEngineAPI then
            EngineInterface.update(p1.data)
            ServerAuthority.initialize(p1.data)
            ControlModule:initialize(p1.data)
            RunService:BindToRenderStep("PLAYERMODULE_RENDERSTEPPED_INPUT", Enum.RenderPriority.Input.Value, function(p3) -- line: 92
                -- upvalues: p1 (copy), ControlModule (copy), EngineInterface (copy)
                EngineInterface.update(p1.data)
                ControlModule:Update(p1.data, p3)
            end)
            RunService:BindToRenderStep("PLAYERMODULE_RENDERSTEPPED_CAMERA", Enum.RenderPriority.Camera.Value, function(p4) -- line: 102
                -- upvalues: p1 (copy), CameraModule (copy), EngineInterface (copy)
                CameraModule:Update(p1.data, p4)
                p1.inputSampler:Update(p1.data)
                EngineInterface.cleanDirty(p1.data)
            end)
        else
            p1.data.engineInterface.player = p2
            ServerAuthority.initialize(p1.data)
            ControlModule:initialize(p1.data)
            RunService:BindToRenderStep("PLAYERMODULE_RENDERSTEPPED_INPUT", Enum.RenderPriority.Input.Value, function(p5) -- line: 118
                -- upvalues: p1 (copy), CharacterUtil (copy), ControlModule (copy)
                p1.data.engineInterface.character = CharacterUtil.getCharacter()

                if p1.data.engineInterface.character then
                    ControlModule:Update(p1.data, p5)
                end
            end)
            p1.data.connectionUtil:trackBoundFunction("PLAYERMODULE_RENDERSTEPPED_INPUT", function() -- line: 127
                -- upvalues: RunService (copy)
                RunService:UnbindFromRenderStep("PLAYERMODULE_RENDERSTEPPED_INPUT")
            end)
            RunService:BindToRenderStep("PLAYERMODULE_RENDERSTEPPED_CAMERA", Enum.RenderPriority.Camera.Value, function(p6) -- line: 135
                -- upvalues: p1 (copy), CameraModule (copy)
                CameraModule:Update(p1.data, p6)
                p1.inputSampler:Update(p1.data)
            end)
            p1.data.connectionUtil:trackBoundFunction("PLAYERMODULE_RENDERSTEPPED_CAMERA", function() -- line: 140
                -- upvalues: RunService (copy)
                RunService:UnbindFromRenderStep("PLAYERMODULE_RENDERSTEPPED_CAMERA")
            end)
        end
    end))
end

if not UserPlayerModuleEngineAPI then
    function t1.stop(p7) -- line: 149
        p7.data.connectionUtil:disconnectAll()
    end
end

return t1
