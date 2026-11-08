-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Policy = require(ReplicatedStorage.Client.Policy)
local Signal = require(ReplicatedStorage.Packages.Signal)
local TreadmillFlags = require(ReplicatedStorage.Shared.Flags.TreadmillFlags)
local t1 = {
    Changed = Signal.new(),
    IsVideoPlayerDisabled = function() -- IsVideoPlayerDisabled | line: 22
        -- upvalues: Policy (copy), TreadmillFlags (copy)
        if TreadmillFlags.VideoPlayerDisabled:Get() then
            return true
        end

        if TreadmillFlags.PolicyServiceVideoEnabled:Get() then
            return not Policy.IsEndlessContentLoadAllowed()
        end

        return false
    end
}
local v1 = t1.IsVideoPlayerDisabled()

local function update() -- line: 38
    -- upvalues: t1 (copy), v1 (ref)
    local v2 = t1.IsVideoPlayerDisabled()

    if v2 ~= v1 then
        v1 = v2
        t1.Changed:Fire(v2)
    end
end

TreadmillFlags.VideoPlayerDisabled.Changed:Connect(update)
TreadmillFlags.PolicyServiceVideoEnabled.Changed:Connect(update)
Policy.Loaded:Connect(update)

return t1
