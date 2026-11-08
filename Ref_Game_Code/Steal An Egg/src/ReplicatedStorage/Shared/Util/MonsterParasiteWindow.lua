-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MonsterParasite = require(ReplicatedStorage.Data.MonsterParasite)
local MonsterParasiteFlags = require(ReplicatedStorage.Shared.Flags.MonsterParasiteFlags)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Timer = require(ReplicatedStorage.Packages.Timer)
local t1 = {
    Changed = Signal.new()
}
local v1 = MonsterParasiteFlags.Enabled:Get()
local v2 = v1 and os.time() < MonsterParasite.EndsAt

function t1.IsActive() -- line: 27
    -- upvalues: v2 (ref)
    return v2
end

function t1.Refresh() -- line: 31
    -- upvalues: MonsterParasite (copy), MonsterParasiteFlags (copy), t1 (copy), v2 (ref)
    local v3 = MonsterParasiteFlags.Enabled:Get() and os.time() < MonsterParasite.EndsAt

    if v3 == v2 then
        return
    end

    v2 = v3
    t1.Changed:Fire(v2)
end

local v5 = Timer.new(1)

v5.Tick:Connect(t1.Refresh)
v5:Start()
MonsterParasiteFlags.Enabled.Changed:Connect(t1.Refresh)

return table.freeze(t1)
