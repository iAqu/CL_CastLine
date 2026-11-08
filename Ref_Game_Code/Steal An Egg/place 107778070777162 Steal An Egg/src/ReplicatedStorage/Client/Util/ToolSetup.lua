-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ToolCooldown = require(ReplicatedStorage.Shared.Util.ToolCooldown)
local ToolSession = require(ReplicatedStorage.Client.Util.ToolSession)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t = require(ReplicatedStorage.Packages.t)
local v1 = t.strict(t.array(t.string))
local LocalPlayer = Players.LocalPlayer

return {
    Attach = function(p1, p2) -- Attach | line: 24
        -- upvalues: ToolSession (copy), Trove (copy), v1 (copy), LocalPlayer (copy)
        local v2 = if type(p1) == "string" then { p1 } else p1

        v1(v2)

        local t2 = {
            grip = nil,
            held = nil,
            accepts = v2,
            hooks = p2 or {},
            spawns = Trove.new()
        }
        local Character = LocalPlayer.Character

        if Character then
            ToolSession.Follow(t2, Character)
        end

        t2.spawns:Add(LocalPlayer.CharacterAdded:Connect(function(p3) -- line: 37
            -- upvalues: t2 (copy), ToolSession (copy)
            ToolSession.Follow(t2, p3)
        end))

        return {
            GetCurrentTool = function() -- GetCurrentTool | line: 41
                -- upvalues: t2 (copy)
                return t2.held
            end,
            GetCurrentToolGearName = function() -- GetCurrentToolGearName | line: 42
                -- upvalues: t2 (copy), ToolSession (copy)
                return ToolSession.GearNameOf(t2.held)
            end,
            IsActive = function() -- IsActive | line: 43
                -- upvalues: t2 (copy)
                return t2.held ~= nil
            end,
            Cleanup = function() -- Cleanup | line: 44
                -- upvalues: t2 (copy), ToolSession (copy)
                ToolSession.Shut(t2)
            end
        }
    end,
    ApplyCooldown = function(p4, p5) -- ApplyCooldown | line: 48
        -- upvalues: ToolCooldown (copy)
        local CurrentTool = p4:GetCurrentTool()

        if CurrentTool and CurrentTool.Parent then
            ToolCooldown.Begin(CurrentTool, p5)
        end
    end
}
