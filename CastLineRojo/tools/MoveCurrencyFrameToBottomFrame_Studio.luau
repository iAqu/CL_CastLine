-- 一次性迁移：HomeGui.LeftFrame.CurrencyFrame → HomeGui.BottomFrame.CurrencyFrame
--
-- 用法（Roblox Studio 已打开 #AF_DEV）：
-- 1) Roblox Studio MCP execute_luau（datamodel_type: Edit）粘贴本文件全文；或
-- 2) 在 Studio 命令栏粘贴执行。

local StarterGui = game:GetService("StarterGui")
local homeGui = StarterGui:WaitForChild("HomeGui")
local bottomFrame = homeGui:WaitForChild("BottomFrame")
local leftFrame = homeGui:WaitForChild("LeftFrame")

if bottomFrame:FindFirstChild("CurrencyFrame") then
	return "CurrencyFrame already under BottomFrame"
end

local currencyFrame = leftFrame:FindFirstChild("CurrencyFrame")
if not currencyFrame then
	error("CurrencyFrame not found under LeftFrame or BottomFrame")
end

currencyFrame.Parent = bottomFrame

return ("Moved CurrencyFrame to %s"):format(currencyFrame:GetFullName())
