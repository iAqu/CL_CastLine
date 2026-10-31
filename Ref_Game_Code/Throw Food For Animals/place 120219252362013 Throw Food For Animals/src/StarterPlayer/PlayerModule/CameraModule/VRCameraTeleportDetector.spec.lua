-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CorePackages = game:GetService("CorePackages")
local JestGlobals = require(CorePackages.Packages.Dev.JestGlobals)
local describe, expect, it = JestGlobals.describe, JestGlobals.expect, JestGlobals.it
local VRCameraTeleportDetector = require(script.Parent.VRCameraTeleportDetector)
local shouldRecenter, JUMP_STUDS, SETTLED_STUDS, DEBOUNCE_SECONDS = VRCameraTeleportDetector.shouldRecenter, VRCameraTeleportDetector.JUMP_STUDS, VRCameraTeleportDetector.SETTLED_STUDS, VRCameraTeleportDetector.DEBOUNCE_SECONDS

describe("VRCameraTeleportDetector.shouldRecenter", function() -- line: 14
    -- upvalues: expect (copy), it (copy), shouldRecenter (copy), JUMP_STUDS (copy), SETTLED_STUDS (copy), DEBOUNCE_SECONDS (copy)
    it("fires on a discrete jump from rest (no prior step, never recentered)", function() -- line: 15
        -- upvalues: expect (copy), shouldRecenter (copy), JUMP_STUDS (copy)
        expect(shouldRecenter(nil, JUMP_STUDS + 10, nil, 100)).toBe(true)
    end)
    it("fires on a discrete jump preceded by a near-still frame", function() -- line: 19
        -- upvalues: expect (copy), shouldRecenter (copy), JUMP_STUDS (copy), SETTLED_STUDS (copy)
        expect(shouldRecenter(SETTLED_STUDS - 0.5, JUMP_STUDS + 10, nil, 100)).toBe(true)
    end)
    it("does not fire for sub-threshold motion", function() -- line: 23
        -- upvalues: expect (copy), shouldRecenter (copy), JUMP_STUDS (copy)
        expect(shouldRecenter(0, JUMP_STUDS - 0.1, nil, 100)).toBe(false)
        expect(shouldRecenter(0, 0, nil, 100)).toBe(false)
    end)
    it("does not fire when the previous frame was already moving (continuous motion)", function() -- line: 28
        -- upvalues: expect (copy), shouldRecenter (copy), JUMP_STUDS (copy), SETTLED_STUDS (copy)
        expect(shouldRecenter(SETTLED_STUDS + 0.1, JUMP_STUDS + 10, nil, 100)).toBe(false)
    end)
    it("does not fire within the debounce interval", function() -- line: 33
        -- upvalues: expect (copy), shouldRecenter (copy), JUMP_STUDS (copy), DEBOUNCE_SECONDS (copy)
        expect(shouldRecenter(nil, JUMP_STUDS + 10, 100, 100 + DEBOUNCE_SECONDS - 0.01)).toBe(false)
    end)
    it("fires again once the debounce interval has elapsed", function() -- line: 38
        -- upvalues: expect (copy), shouldRecenter (copy), JUMP_STUDS (copy), DEBOUNCE_SECONDS (copy)
        expect(shouldRecenter(nil, JUMP_STUDS + 10, 100, 100 + DEBOUNCE_SECONDS + 0.01)).toBe(true)
    end)
    it("does not retrigger every frame under continuous per-frame CFrame writes (oscillation guard)", function() -- line: 43
        -- upvalues: expect (copy), shouldRecenter (copy), JUMP_STUDS (copy)
        local v1 = JUMP_STUDS + 10
        local n1 = 0
        local v2, v3
        local n2 = 0

        for _ = 1, 120 do
            if shouldRecenter(v2, v1, v3, n1) then
                v3 = n1
                n2 += 1
            end

            v2 = v1
            n1 += 0.016666666666666666
        end

        expect(n2).toBe(1)
    end)
end)
