-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local UIUtil = require(script.Parent.UIUtil)
local LocalPlayer = Players.LocalPlayer
local UpdateLog
local t1 = {
    isOpen = function() -- isOpen | line: 14
        -- upvalues: UpdateLog (ref)
        return UpdateLog ~= nil and UpdateLog.Enabled
    end,
    open = function() -- open | line: 18
        -- upvalues: UIUtil (copy), UpdateLog (ref)
        if UpdateLog and not UpdateLog.Enabled then
            UIUtil.openPanel(UpdateLog)
        end
    end,
    close = function() -- close | line: 24
        -- upvalues: UIUtil (copy), UpdateLog (ref)
        if UpdateLog then
            UIUtil.closePanel(UpdateLog)
        end
    end
}

function t1.init() -- line: 30
    -- upvalues: UIUtil (copy), LocalPlayer (copy), t1 (copy), UpdateLog (ref)
    UpdateLog = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("UpdateLog")
    UpdateLog.Enabled = false
    UIUtil.bindButton(UpdateLog.Panel.Header.Close, function() -- line: 33
        -- upvalues: t1 (copy)
        task.spawn(t1.close)
    end)
end

return t1
