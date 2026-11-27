-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LiveOps = require(ReplicatedStorage.Shared.LiveOps)
local UIUtil = require(script.Parent.UIUtil)
local t1 = {}

local function chat(p1) -- line: 11
    -- upvalues: TextChatService (copy)
    local function v1() -- line: 12
        -- upvalues: p1 (copy), TextChatService (copy)
        local TextChannels = TextChatService:FindFirstChild("TextChannels")

        TextChannels = TextChannels and (TextChannels:FindFirstChild("RBXSystem") or TextChannels:FindFirstChild("RBXGeneral"))

        if TextChannels then
            TextChannels:DisplaySystemMessage((("<font color=\"#FFC850\"><b>%*</b></font>"):format(p1)))
        end
    end

    pcall(v1)
end

local function announce(p2) -- line: 21
    -- upvalues: TextChatService (copy), UIUtil (copy)
    local v2 = ("💪 2x STRENGTH STARTED! %* min left"):format(p2)

    UIUtil.toast(v2, "purchase")
    UIUtil.sound("LevelUp", 0.8, 1.1)

    local function v3() -- line: 12
        -- upvalues: v2 (copy), TextChatService (copy)
        local TextChannels = TextChatService:FindFirstChild("TextChannels")

        TextChannels = TextChannels and (TextChannels:FindFirstChild("RBXSystem") or TextChannels:FindFirstChild("RBXGeneral"))

        if TextChannels then
            TextChannels:DisplaySystemMessage((("<font color=\"#FFC850\"><b>%*</b></font>"):format(v2)))
        end
    end

    pcall(v3)
end

function t1.init() -- line: 28
    -- upvalues: TextChatService (copy), LiveOps (copy), UIUtil (copy)
    task.spawn(function() -- line: 29
        -- upvalues: TextChatService (copy), LiveOps (copy), UIUtil (copy)
        task.wait(8)

        local v4 = false

        while true do
            local v5 = LiveOps.strengthLeft(workspace:GetServerTimeNow())
            local v6 = v5 > 0

            if not v6 or v4 then
                if v4 and not v6 then
                    UIUtil.toast("💪 2x Strength ended! Back tomorrow at 8PM", "info")
                end
            else
                local v8 = ("💪 2x STRENGTH STARTED! %* min left"):format((math.ceil(v5 / 60)))

                UIUtil.toast(v8, "purchase")
                UIUtil.sound("LevelUp", 0.8, 1.1)

                local function v9() -- line: 12
                    -- upvalues: v8 (copy), TextChatService (copy)
                    local TextChannels = TextChatService:FindFirstChild("TextChannels")

                    TextChannels = TextChannels and (TextChannels:FindFirstChild("RBXSystem") or TextChannels:FindFirstChild("RBXGeneral"))

                    if TextChannels then
                        TextChannels:DisplaySystemMessage((("<font color=\"#FFC850\"><b>%*</b></font>"):format(v8)))
                    end
                end

                pcall(v9)
            end

            v4 = v6
            task.wait(1)
        end
    end)
end

return t1
