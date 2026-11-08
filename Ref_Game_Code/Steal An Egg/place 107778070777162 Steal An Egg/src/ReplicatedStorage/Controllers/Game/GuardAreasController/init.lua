-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local ForestGuardRuntime = require(script.ForestGuardRuntime)
local GuardComponent = require(script.GuardComponent)
local GuardEscapeSignController = require(script.GuardEscapeSignController)
local GuardTutorialController = require(script.GuardTutorialController)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Promise = require(ReplicatedStorage.Packages.Promise)
local t1 = {}
local t2 = {}
local t3 = {}

return {
    Start = function() -- Start | line: 32
        -- upvalues: Workspace (copy), ForestGuardRuntime (copy), GuardComponent (copy), GuardEscapeSignController (copy), GuardTutorialController (copy), Remotes (copy), Promise (copy), t1 (copy), t2 (copy), t3 (copy)
        local v1 = GuardTutorialController.new()

        task.spawn(function() -- line: 34
            -- upvalues: v1 (copy)
            v1:Start()
        end)

        local v2 = true
        local n1 = -1
        local World = Workspace:WaitForChild("World")

        assert(World:IsA("Folder"), "Workspace.World must be a Folder")

        local Areas = World:WaitForChild("Areas")

        assert(Areas:IsA("Folder"), "Workspace.World.Areas must be a Folder")

        local GuardAreas = Areas:WaitForChild("GuardAreas")

        assert(GuardAreas:IsA("Folder"), "Workspace.World.Areas.GuardAreas must be a Folder")

        local function applyGuardsEnabled(p1, p2) -- line: 47
            -- upvalues: v2 (ref), n1 (ref), t2 (copy)
            if p2 < n1 then
                return
            end

            v2 = p1
            n1 = p2

            for _, v3 in pairs(t2) do
                if v3 ~= nil and v3.ForestRuntime ~= nil then
                    v3.ForestRuntime:SetEnabled(p1)
                end
            end
        end

        local function setupAreaModel(p3) -- line: 64
            -- upvalues: v2 (ref), GuardAreas (copy), ForestGuardRuntime (copy), GuardComponent (copy), GuardEscapeSignController (copy), t1 (copy), t2 (copy), t3 (copy)
            if t1[p3] == nil then
                t1[p3] = GuardEscapeSignController.new(p3)
            end

            if t2[p3] ~= nil then
                return
            end

            local v4, v5

            if p3.Name == "Forest" then
                v4 = ForestGuardRuntime.new(p3)
                v5 = GuardComponent.new(p3)
                v4:SetWakeHandler(function(_) -- line: 79
                    -- upvalues: v5 (ref)
                    v5:PlayWakeUp()
                end)
            else
                v5 = GuardComponent.new(p3)
            end

            if p3.Parent == GuardAreas then
                t2[p3] = {
                    ForestRuntime = v4,
                    Guard = v5
                }
                t3[v5:GetGuardModel()] = v5

                if v4 ~= nil then
                    v4:SetEnabled(v2)
                    v4:Start()
                end
            else
                v5:Destroy()

                if v4 ~= nil then
                    v4:Destroy()
                end
            end
        end

        local function cleanupAreaModel(p5) -- line: 105
            -- upvalues: t1 (copy), t2 (copy), t3 (copy)
            local v7 = t1[p5]

            if v7 ~= nil then
                t1[p5] = nil
                v7:Destroy()
            end

            local v8 = t2[p5]

            if v8 == nil then
                return
            end

            t2[p5] = nil
            t3[v8.Guard:GetGuardModel()] = nil
            v8.Guard:Destroy()

            if v8.ForestRuntime ~= nil then
                v8.ForestRuntime:Destroy()
            end
        end

        GuardAreas.ChildAdded:Connect(function(p6) -- line: 128
            -- upvalues: setupAreaModel (copy)
            assert(p6:IsA("Model"), (("%* must be a guard area Model"):format((p6:GetFullName()))))
            setupAreaModel(p6)
        end)
        GuardAreas.ChildRemoved:Connect(function(p7) -- line: 136
            -- upvalues: cleanupAreaModel (copy)
            assert(p7:IsA("Model"), (("%* must be a guard area Model"):format((p7:GetFullName()))))
            cleanupAreaModel(p7)
        end)

        for _, child in ipairs(GuardAreas:GetChildren()) do
            assert(child:IsA("Model"), (("%* must be a guard area Model"):format((child:GetFullName()))))
            task.spawn(setupAreaModel, child)
        end

        Remotes.GuardPatrol.Rouse.OnClientEvent:Connect(function(p8) -- line: 152
            -- upvalues: t3 (copy)
            local v12 = t3[p8]

            if v12 ~= nil then
                v12:PlayWakeUp()
            end
        end)
        Remotes.GuardPatrol.EnabledShifted.OnClientEvent:Connect(applyGuardsEnabled)
        task.spawn(function() -- line: 162
            -- upvalues: n1 (ref), applyGuardsEnabled (copy), Remotes (copy), Promise (copy)
            local v13, v14

            while true do
                if n1 < 0 then
                    local v15

                    v15, v13, v14 = Promise.try(function() -- line: 164
                        -- upvalues: Remotes (copy)
                        return Remotes.GuardPatrol.AskEnabled:InvokeServer()
                    end):timeout(30):await()

                    if v15 and typeof(v13) == "boolean" and typeof(v14) == "number" then
                        break
                    end

                    task.wait(1)
                    continue
                end

                return
            end

            applyGuardsEnabled(v13, v14)
        end)
    end
}
