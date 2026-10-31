-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace

return {
    isPartOnAnotherPart = function(p1, p2, p3) -- isPartOnAnotherPart | line: 4
        -- upvalues: RuntimeLib (copy), Workspace (copy)
        local v1 = if p3 == nil then Vector3.new() else p3
        local CFrame, Size = p2.CFrame, p2.Size

        if (Size.X + Size.Y + Size.Z) / 3 + (p1.Size.X + p1.Size.Y + p1.Size.Z) / 3 + (v1.X + v1.Y + v1.Z) / 3 < (CFrame.Position - p1.Position).Magnitude then
            return false
        end

        local v2 = RaycastParams.new()

        v2.FilterType = Enum.RaycastFilterType.Include
        v2:AddToFilter(p2)

        local v3, v4 = RuntimeLib.try(function() -- line: 20
            -- upvalues: p1 (copy), v2 (copy), RuntimeLib (copy), Workspace (copy)
            if Workspace:Blockcast(p1.CFrame + Vector3.new(0, 15, 0), p1.Size - Vector3.new(0, p1.Size.Y - 1, 0), Vector3.new(0, -500, 0), v2) then
                return RuntimeLib.TRY_RETURN, { true }
            end

            return RuntimeLib.TRY_RETURN, { false }
        end, function(p4) -- line: 31
            -- upvalues: p1 (copy), p2 (copy), RuntimeLib (copy)
            warn("[src/shared/utils/detectable-utils.ts:33]", (("Error checking if part %* (%*) is on another part %* (%*): %*"):format(p1:GetFullName(), p1.CFrame, p2:GetFullName(), p2.CFrame, p4)))

            return RuntimeLib.TRY_RETURN, { false }
        end)

        if v3 then
            return unpack(v4)
        end
    end
}
