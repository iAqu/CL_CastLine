-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CorePackages = game:GetService("CorePackages")
local JestGlobals = require(CorePackages.Packages.Dev.JestGlobals)
local describe, expect, it = JestGlobals.describe, JestGlobals.expect, JestGlobals.it
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local ConnectionUtil = require(script.Parent.ConnectionUtil)

describe("ConnectionUtil", function() -- line: 13
    -- upvalues: expect (copy), it (copy), Signal (copy), ConnectionUtil (copy)
    it("should instantiate", function() -- line: 14
        -- upvalues: expect (copy), ConnectionUtil (copy)
        expect((ConnectionUtil.new())).never.toBeNil()
    end)
    it("should track a connection", function() -- line: 20
        -- upvalues: expect (copy), Signal (copy), ConnectionUtil (copy)
        local v2 = ConnectionUtil.new()
        local v3 = Signal.new()
        local v4 = ""

        v2:trackConnection("Signal", v3:Connect(function(p1) -- line: 27
            -- upvalues: v4 (ref)
            v4 = p1
        end))
        v3:fire("Testing")
        expect(v4).toBe("Testing")
    end)
    it("should disconnect from signal", function() -- line: 36
        -- upvalues: expect (copy), Signal (copy), ConnectionUtil (copy)
        local v5 = ConnectionUtil.new()
        local v6 = Signal.new()
        local v7 = ""

        v5:trackConnection("Signal", v6:Connect(function(p2) -- line: 43
            -- upvalues: v7 (ref)
            v7 = p2
        end))
        v5:disconnect("Signal")
        v6:fire("Testing")
        expect(v7).toBe("")
    end)
    it("should disconnect from all", function() -- line: 53
        -- upvalues: expect (copy), Signal (copy), ConnectionUtil (copy)
        local v8 = ConnectionUtil.new()
        local v9 = Signal.new()
        local v10 = Signal.new()
        local v11 = Signal.new()
        local v12 = ""
        local v13 = ""
        local v14 = ""

        v8:trackConnection("Signal", v9:Connect(function(p3) -- line: 65
            -- upvalues: v12 (ref)
            v12 = p3
        end))
        v8:trackConnection("Signal1", v10:Connect(function(p4) -- line: 71
            -- upvalues: v13 (ref)
            v13 = p4
        end))
        v8:trackConnection("Signal2", v11:Connect(function(p5) -- line: 77
            -- upvalues: v14 (ref)
            v14 = p5
        end))
        v8:disconnectAll()
        v9:fire("TestingPrimary")
        v9:fire("TestingSecondary")
        v9:fire("TestingTertiary")
        expect(v12).toBe("")
        expect(v13).toBe("")
        expect(v14).toBe("")
    end)
    it("should call manual disconnect", function() -- line: 92
        -- upvalues: expect (copy), ConnectionUtil (copy)
        local v15 = ConnectionUtil.new()
        local v16 = ""

        v15:trackBoundFunction("Manual", function() -- line: 96
            -- upvalues: v16 (ref)
            v16 = "Disconnected"
        end)
        v15:disconnect("Manual")
        expect(v16).toBe("Disconnected")
    end)
end)
