-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Parent = script.Parent
local v1 = Parent:WaitForChild("Pipe drip source"):WaitForChild("Underside attachment"):WaitForChild("Pipe droplet")
local v2 = Parent:WaitForChild("Water impact"):WaitForChild("Impact attachment")
local v3 = v2:WaitForChild("Landing ring")
local v4 = v2:WaitForChild("Small splash droplets")
local v5 = Random.new()

local function emitDrop() -- line: 10
    -- upvalues: Parent (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy)
    if Parent:IsDescendantOf(workspace) then
        v1:Emit(1)
        task.delay(Parent:GetAttribute("FallTime") or 0.72, function() -- line: 15
            -- upvalues: v2 (copy), v3 (copy), v4 (copy), v5 (copy)
            if v2:IsDescendantOf(workspace) then
                v3:Emit(1)
                v4:Emit(v5:NextInteger(2, 4))
            end
        end)
    end
end

task.wait(v5:NextNumber(0.3, 1))

while Parent:IsDescendantOf(workspace) do
    emitDrop()

    if v5:NextNumber() < 0.22 then
        task.wait(v5:NextNumber(0.16, 0.4))
        emitDrop()
    end

    local v6 = v5:NextNumber(0.8, 2.4)

    if v5:NextNumber() < 0.15 then
        v6 = v5:NextNumber(3.3, 4.8)
    end

    task.wait(v6)
end
