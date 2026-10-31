-- 一次性迁移：将挂在 UIGradient 下的旧 Moving 类 LocalScript/Script 换为
-- 名为 GUI_MovingRainbowGradient 的 Configuration + CollectionService tag「LocalScriptAttach」
--
-- 用法（Roblox Studio 已打开 #DB_DEV 且 Rojo 已同步本仓库后）：
-- 1) 通过 Cursor Roblox Studio MCP 的 execute_luau 整段粘贴执行；或
-- 2) 在 Studio 命令栏或插件中执行本文件内容。
--
-- 不会处理：父级非 UIGradient 的脚本；ReplicatedStorage.LocalAttachTemplate 下的模板源脚本。

local CollectionService = game:GetService("CollectionService")

local TAG = "LocalScriptAttach"
local MARKER_NAME = "GUI_MovingRainbowGradient"
local CANDIDATE_NAMES = {
	Moving = true,
	MovingRainbow = true,
	MovingGradient = true,
	-- 旧版可能把模板整份放在场景里
	GUI_MovingRainbowGradient = true,
}

local function isLocalAttachTemplateSource(inst)
	local folder = game.ReplicatedStorage and game.ReplicatedStorage:FindFirstChild("LocalAttachTemplate")
	if folder and inst:IsDescendantOf(folder) then
		return true
	end
	return false
end

local report = {
	migrated = {},
	skipped = {},
}

for _, d in game:GetDescendants() do
	if (d:IsA("LocalScript") or d:IsA("Script"))
		and not isLocalAttachTemplateSource(d)
		and CANDIDATE_NAMES[d.Name]
	then
		local parent = d.Parent
		if not parent or not parent:IsA("UIGradient") then
			table.insert(
				report.skipped,
				string.format("%s (parent is %s, not UIGradient)", d:GetFullName(), parent and parent.ClassName or "nil")
			)
		elseif parent:FindFirstChild(MARKER_NAME) then
			table.insert(
				report.skipped,
				string.format(
					"%s (marker %s already exists, removed duplicate script only)",
					d:GetFullName(),
					MARKER_NAME
				)
			)
			d:Destroy()
		else
			local marker = Instance.new("Configuration")
			marker.Name = MARKER_NAME
			marker.Parent = parent
			CollectionService:AddTag(marker, TAG)
			d:Destroy()
			table.insert(
				report.migrated,
				string.format("%s -> %s under %s", d.Name, MARKER_NAME, parent:GetFullName())
			)
		end
	end
end

print("[MigrateMovingRainbowGui] done. Migrated:", #report.migrated, " Skipped:", #report.skipped)
for _, line in report.migrated do
	print("  MIGRATED:", line)
end
for _, line in report.skipped do
	print("  SKIP:", line)
end

return report
