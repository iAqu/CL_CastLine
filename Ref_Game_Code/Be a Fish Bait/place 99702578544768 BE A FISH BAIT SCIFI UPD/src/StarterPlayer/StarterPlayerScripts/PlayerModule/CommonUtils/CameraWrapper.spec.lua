-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CorePackages = game:GetService("CorePackages")
local JestGlobals = require(CorePackages.Packages.Dev.JestGlobals)
local describe, expect, it = JestGlobals.describe, JestGlobals.expect, JestGlobals.it
local waitForEvents = require(CorePackages.Workspace.Packages.TestUtils).DeferredLuaHelpers.waitForEvents
local CameraWrapper = require(script.Parent.CameraWrapper)

describe("CameraWrapper", function() -- line: 12
    -- upvalues: expect (copy), it (copy), waitForEvents (copy), CameraWrapper (copy)
    it("should instantiate", function() -- line: 13
        -- upvalues: expect (copy), CameraWrapper (copy)
        expect((CameraWrapper.new())).never.toBeNil()
    end)
    it("should return updated camera", function() -- line: 19
        -- upvalues: expect (copy), waitForEvents (copy), CameraWrapper (copy)
        local v2 = CameraWrapper.new()

        v2:Enable()

        local Camera = Instance.new("Camera")

        Camera.Parent = game.Workspace
        expect(v2:getCamera()).toBe(game.Workspace.CurrentCamera)
        expect(v2:getCamera()).never.toBe(Camera)
        game.Workspace.CurrentCamera = Camera
        waitForEvents()
        expect(v2:getCamera()).toBe(game.Workspace.CurrentCamera)
        expect(v2:getCamera()).toBe(Camera)
    end)
end)
