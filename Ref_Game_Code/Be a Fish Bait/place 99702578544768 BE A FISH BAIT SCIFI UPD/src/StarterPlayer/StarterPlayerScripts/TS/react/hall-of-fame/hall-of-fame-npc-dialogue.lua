-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useEffect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react").useEffect
local getHallOfFameNpcData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "hall-of-fame-npc-dialogue").getHallOfFameNpcData

return {
    default = function(p1) -- HallOfFameNpcDialogueInner | line: 15
        -- upvalues: useEffect (copy), getHallOfFameNpcData (copy)
        local instance = p1.instance
        local v1 = getHallOfFameNpcData(p1.npcId)

        useEffect(function() -- line: 19
            -- upvalues: instance (copy), v1 (copy)
            if not v1 then
                return nil
            end

            local Dialog = Instance.new("Dialog")

            Dialog.Purpose = Enum.DialogPurpose.Help
            Dialog.Tone = Enum.DialogTone.Friendly
            Dialog.GoodbyeChoiceActive = true
            Dialog.InitialPrompt = v1.quotes[math.random(0, #v1.quotes - 1) + 1]
            Dialog.Parent = instance

            local connection = Dialog:GetPropertyChangedSignal("InUse"):Connect(function() -- line: 29
                -- upvalues: Dialog (copy), v1 (copy)
                if Dialog.InUse then
                    Dialog.InitialPrompt = v1.quotes[math.random(0, #v1.quotes - 1) + 1]
                end
            end)

            return function() -- line: 34
                -- upvalues: Dialog (copy), connection (copy)
                connection:Disconnect()
                Dialog:Destroy()
            end
        end, { instance, v1 })

        return nil
    end
}
