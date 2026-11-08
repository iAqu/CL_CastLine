-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local AnimationAssets = require(ReplicatedStorage.Shared.Utils.AnimationAssets)
local BanjoCricket = require(ReplicatedStorage.Data.BanjoCricket)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t1 = {}
local t2 = {}

local function unbind(p1) -- line: 17
    -- upvalues: t1 (copy)
    local v1 = t1[p1]

    if v1 then
        t1[p1] = nil
        v1:Destroy()
    end
end

local function bind(p2) -- line: 25
    -- upvalues: Workspace (copy), AnimationAssets (copy), BanjoCricket (copy), Trove (copy), t1 (copy)
    if not t1[p2] and p2:IsA("Model") and p2:IsDescendantOf(Workspace) then
        local v2 = p2:FindFirstChildWhichIsA("Animator", true)

        if v2 == nil then
            return
        end

        local v3 = Trove.new()

        t1[p2] = v3
        v3:Connect(p2.Destroying, function() -- line: 39
            -- upvalues: p2 (copy), t1 (copy)
            local v4 = t1[p2]

            if v4 then
                t1[p2] = nil
                v4:Destroy()
            end
        end)

        local v5 = BanjoCricket.PerformerAnimations[p2.Name]

        assert(v5 ~= nil, (("No Banjo Cricket performer animation for %*"):format(p2.Name)))

        local v8 = AnimationAssets.Get(v5)

        local function v9() -- line: 45
            -- upvalues: v2 (copy), v8 (copy)
            return v2:LoadAnimation(v8)
        end

        local ok, result = pcall(v9)

        if ok then
            if t1[p2] == v3 then
                v3:Add(result)
                result.Looped = true
                result.Priority = Enum.AnimationPriority.Idle
                result:Play(0.15)
            else
                result:Destroy()
            end
        else
            local v10 = t1[p2]

            if v10 then
                t1[p2] = nil
                v10:Destroy()
            end

            warn((("Could not load %*'s animation: %*"):format(p2.Name, result)))
        end
    end
end

function t2.Start() -- line: 63
    -- upvalues: CollectionService (copy), BanjoCricket (copy), unbind (copy), bind (copy)
    local Performer = BanjoCricket.Tags.Performer

    CollectionService:GetInstanceAddedSignal(Performer):Connect(bind)
    CollectionService:GetInstanceRemovedSignal(Performer):Connect(unbind)

    for _, v11 in CollectionService:GetTagged(Performer) do
        bind(v11)
    end
end

return table.freeze(t2)
