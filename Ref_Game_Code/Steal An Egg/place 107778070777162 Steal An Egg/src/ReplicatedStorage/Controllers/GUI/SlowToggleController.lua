-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local Hud = require(ReplicatedStorage.Client.Hud)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Save = require(ReplicatedStorage.Shared.Save)
local v1 = Color3.fromRGB(0, 255, 0)
local v2 = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local LocalPlayer = Players.LocalPlayer

return {
    Start = function() -- Start | line: 26
        -- upvalues: TweenService (copy), Constants (copy), Hud (copy), Remotes (copy), Save (copy), v1 (copy), v2 (copy), LocalPlayer (copy)
        local SlowToggle = Hud.Get("SlowToggle")
        local SlowToggleKnob = Hud.Get("SlowToggleKnob")
        local SlowToggleHitbox = Hud.Get("SlowToggleHitbox")
        local BackgroundColor3 = SlowToggle.BackgroundColor3
        local Y = SlowToggleKnob.Position.Y
        local v3 = false
        local v4 = Constants.BASE_WALK_SPEED
        local v5, v6, connection

        local function setToggleVisuals(p1) -- line: 47
            -- upvalues: SlowToggle (copy), SlowToggleKnob (copy), BackgroundColor3 (copy), Y (copy), TweenService (copy), v1 (copy), v2 (copy)
            SlowToggle.BackgroundColor3 = if p1 then v1 else BackgroundColor3
            TweenService:Create(SlowToggleKnob, v2, {
                Position = UDim2.new(p1 and 0.615 or 0.05, 0, Y.Scale, Y.Offset)
            }):Play()
        end

        local function reconcileSlowToggleState(p2) -- line: 59
            -- upvalues: v3 (ref), setToggleVisuals (copy)
            v3 = p2
            setToggleVisuals(p2)
        end

        local function updateSlowToggleVisibility(p3) -- line: 64
            -- upvalues: SlowToggle (copy), v3 (ref), v5 (ref)
            local v8 = v5 == nil and (v3 or p3 > 50)

            SlowToggle.Visible = v8

            return v8
        end

        local function resolveVisibleWalkSpeed() -- line: 70
            -- upvalues: v4 (ref), v6 (ref)
            local v9 = v6

            if v9 ~= nil and v9.Parent ~= nil and v9.Health > 0 then
                return v9.WalkSpeed
            end

            return v4
        end

        local function refreshVisibilityFromCurrentWalkSpeed() -- line: 79
            -- upvalues: SlowToggle (copy), v3 (ref), v4 (ref), v5 (ref), v6 (ref)
            local v10 = v6
            local v11 = if v10 ~= nil and v10.Parent ~= nil and v10.Health > 0 then v10.WalkSpeed else v4

            SlowToggle.Visible = v5 == nil and (v3 or v11 > 50)
        end

        local function applyServerSlowToggleState(p4, p5) -- line: 83
            -- upvalues: SlowToggle (copy), v3 (ref), v4 (ref), v5 (ref), v6 (ref), setToggleVisuals (copy)
            v4 = p5
            v3 = p4
            setToggleVisuals(p4)

            local v13 = v6
            local v14 = if v13 ~= nil and v13.Parent ~= nil and v13.Health > 0 then v13.WalkSpeed else v4

            SlowToggle.Visible = v5 == nil and (v3 or v14 > 50)
        end

        local function syncSlowToggleStateFromServer() -- line: 89
            -- upvalues: SlowToggle (copy), v3 (ref), v4 (ref), v5 (ref), v6 (ref), setToggleVisuals (copy), Remotes (copy)
            local v16, v17 = Remotes.Treadmill.AskSlowToggle:InvokeServer()

            assert(typeof(v16) == "boolean", "Expected slow-toggle enabled state from server")
            assert(typeof(v17) == "number", "Expected slow-toggle restored walk speed from server")
            v4 = v17
            v3 = v16
            setToggleVisuals(v16)

            local v20 = v6
            local v21 = if v20 ~= nil and v20.Parent ~= nil and v20.Health > 0 then v20.WalkSpeed else v4

            SlowToggle.Visible = v5 == nil and (v3 or v21 > 50)
        end

        local function setSlowToggleEnabled(p6) -- line: 99
            -- upvalues: SlowToggle (copy), v3 (ref), v4 (ref), v5 (ref), v6 (ref), setToggleVisuals (copy), Remotes (copy)
            local v23, v24 = Remotes.Treadmill.AskSlowToggleSet:InvokeServer(p6)

            assert(typeof(v23) == "boolean", "Expected slow-toggle enabled state from server")
            assert(typeof(v24) == "number", "Expected slow-toggle restored walk speed from server")
            v4 = v24
            v3 = v23
            setToggleVisuals(v23)

            local v27 = v6
            local v28 = if v27 ~= nil and v27.Parent ~= nil and v27.Health > 0 then v27.WalkSpeed else v4

            SlowToggle.Visible = v5 == nil and (v3 or v28 > 50)
        end

        local function bindHumanoid(p7) -- line: 109
            -- upvalues: SlowToggle (copy), v3 (ref), v4 (ref), v5 (ref), v6 (ref), connection (ref)
            if connection ~= nil then
                connection:Disconnect()
                connection = nil
            end

            v6 = p7
            connection = p7:GetPropertyChangedSignal("WalkSpeed"):Connect(function() -- line: 117
                -- upvalues: SlowToggle (copy), v3 (ref), v4 (ref), v5 (ref), v6 (ref)
                local v30 = v6
                local v31 = if v30 ~= nil and v30.Parent ~= nil and v30.Health > 0 then v30.WalkSpeed else v4

                SlowToggle.Visible = v5 == nil and (v3 or v31 > 50)
            end)

            local v33 = v6
            local v34 = if v33 ~= nil and v33.Parent ~= nil and v33.Health > 0 then v33.WalkSpeed else v4

            SlowToggle.Visible = v5 == nil and (v3 or v34 > 50)
        end

        local function connectCharacter(p8) -- line: 122
            -- upvalues: SlowToggle (copy), v3 (ref), v4 (ref), v5 (ref), v6 (ref), setToggleVisuals (copy), bindHumanoid (copy), Remotes (copy)
            bindHumanoid((p8:WaitForChild("Humanoid")))

            local v36, v37 = Remotes.Treadmill.AskSlowToggle:InvokeServer()

            assert(typeof(v36) == "boolean", "Expected slow-toggle enabled state from server")
            assert(typeof(v37) == "number", "Expected slow-toggle restored walk speed from server")
            v4 = v37
            v3 = v36
            setToggleVisuals(v36)

            local v40 = v6
            local v41 = if v40 ~= nil and v40.Parent ~= nil and v40.Health > 0 then v40.WalkSpeed else v4

            SlowToggle.Visible = v5 == nil and (v3 or v41 > 50)
        end

        SlowToggleHitbox.Activated:Connect(function() -- line: 132
            -- upvalues: SlowToggle (copy), v3 (ref), v4 (ref), v5 (ref), v6 (ref), setToggleVisuals (copy), Remotes (copy)
            local v43 = not v3
            local v44, v45 = Remotes.Treadmill.AskSlowToggleSet:InvokeServer(v43)

            assert(typeof(v44) == "boolean", "Expected slow-toggle enabled state from server")
            assert(typeof(v45) == "number", "Expected slow-toggle restored walk speed from server")
            v4 = v45
            v3 = v44
            setToggleVisuals(v44)

            local v48 = v6
            local v49 = if v48 ~= nil and v48.Parent ~= nil and v48.Health > 0 then v48.WalkSpeed else v4

            SlowToggle.Visible = v5 == nil and (v3 or v49 > 50)
        end)

        if Save.IsLoaded() then
            local v51, v52 = Remotes.Treadmill.AskSlowToggle:InvokeServer()

            assert(typeof(v51) == "boolean", "Expected slow-toggle enabled state from server")
            assert(typeof(v52) == "number", "Expected slow-toggle restored walk speed from server")
            v4 = v52
            v3 = v51
            setToggleVisuals(v51)

            local v55 = v6
            local v56 = if v55 ~= nil and v55.Parent ~= nil and v55.Health > 0 then v55.WalkSpeed else v4

            SlowToggle.Visible = v5 == nil and (v3 or v56 > 50)
        else
            Save.Loaded:Connect(syncSlowToggleStateFromServer)
        end

        Remotes.Treadmill.AssignedBeltShifted.OnClientEvent:Connect(function(p9) -- line: 146
            -- upvalues: SlowToggle (copy), v3 (ref), v4 (ref), v5 (ref), v6 (ref)
            v5 = p9

            local v58 = v6
            local v59 = if v58 ~= nil and v58.Parent ~= nil and v58.Health > 0 then v58.WalkSpeed else v4

            SlowToggle.Visible = v5 == nil and (v3 or v59 > 50)
        end)

        if LocalPlayer.Character ~= nil then
            bindHumanoid((LocalPlayer.Character:WaitForChild("Humanoid")))

            local v61, v62 = Remotes.Treadmill.AskSlowToggle:InvokeServer()

            assert(typeof(v61) == "boolean", "Expected slow-toggle enabled state from server")
            assert(typeof(v62) == "number", "Expected slow-toggle restored walk speed from server")
            v4 = v62
            v3 = v61
            setToggleVisuals(v61)

            local v65 = v6
            local v66 = if v65 ~= nil and v65.Parent ~= nil and v65.Health > 0 then v65.WalkSpeed else v4

            SlowToggle.Visible = v5 == nil and (v3 or v66 > 50)
        end

        LocalPlayer.CharacterAdded:Connect(connectCharacter)
    end
}
