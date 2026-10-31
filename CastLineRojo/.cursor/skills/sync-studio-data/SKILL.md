---
name: sync-studio-data
description: Use when syncing Roblox Studio DB_DEV ReplicatedFirst Data, game.ReplicatedFirst.Data, Studio Data, ModuleScript data, or src/ReplicatedFirst/Data in this project.
---

# Sync Studio Data

## Overview

Use this project skill to sync ModuleScript data from the open `DB_DEV` Roblox Studio project at `game.ReplicatedFirst.Data` into the repository folder `src/ReplicatedFirst/Data`.

This is a one-way sync for repository reference. It must use Roblox Studio MCP for all Studio reads. With no filename argument, mirror the full Studio folder exactly. With a filename argument, sync only that one ModuleScript and leave other local files unchanged.

## Invocation

- `/sync-studio-data`: export all ModuleScripts and mirror `src/ReplicatedFirst/Data` to the Studio export.
- `/sync-studio-data FILENAME`: export only the matching ModuleScript and overwrite only that local file.

`FILENAME` is a path relative to `game.ReplicatedFirst.Data`. Accept both `AreasData` and `AreasData.lua`; for nested modules, accept slash paths such as `Folder/AreasData.lua`.

## Required Target

- Studio project: name contains `DB_DEV` or `#DB_DEV`
- Studio source folder: `game.ReplicatedFirst.Data`
- Repository destination: `src/ReplicatedFirst/Data`
- File rule: write each Studio `ModuleScript` as `<relativePath>.lua`
- Conflict rule: same local path is overwritten without asking
- Full-sync rule: local files missing from Studio export are deleted
- Single-file rule: only the named file is written; other local files are not deleted

## Workflow

1. Read MCP tool descriptors before using tools:
   - `mcps/user-Roblox_Studio/tools/list_roblox_studios.json`
   - `mcps/user-Roblox_Studio/tools/set_active_studio.json`
   - `mcps/user-Roblox_Studio/tools/execute_luau.json`
2. Call `list_roblox_studios`.
3. If the active Studio name does not contain `DB_DEV`, switch to the instance whose name contains `DB_DEV` using `set_active_studio`.
4. If no such Studio exists, stop and tell the user exactly:

```text
未找到 DB_DEV 工程的 Studio 实例，请确认 Roblox Studio 已打开该工程并安装了 MCP 插件。
```

5. Determine sync mode from the command:
   - No `FILENAME`: full sync.
   - Has `FILENAME`: single-file sync.
6. Export data from `game.ReplicatedFirst.Data` with `execute_luau`.
7. Write every returned ModuleScript source into `src/ReplicatedFirst/Data`.
8. For full sync only, delete local files under `src/ReplicatedFirst/Data` that are not present in the Studio export.
9. Verify the diff and report created, overwritten, and deleted counts.

## Luau Export

Use this with `execute_luau` to export ModuleScripts under `ReplicatedFirst.Data`. For full sync, set `targetFilename` to `nil`. For single-file sync, set it to the user's `FILENAME` argument as a string.

```lua
local HttpService = game:GetService("HttpService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local targetFilename = nil -- e.g. "AreasData.lua" for single-file sync

local dataFolder = ReplicatedFirst:FindFirstChild("Data")
if not dataFolder then
	error("ReplicatedFirst.Data not found")
end

local records = {}

local function normalizePath(path)
	path = path:gsub("\\", "/")
	path = path:gsub("^/+", "")
	path = path:gsub("/+$", "")

	if path ~= "" and not path:match("%.lua$") then
		path = path .. ".lua"
	end

	return path
end

local function relativePath(instance)
	local names = {}
	local current = instance

	while current and current ~= dataFolder do
		table.insert(names, 1, current.Name)
		current = current.Parent
	end

	return table.concat(names, "/")
end

local normalizedTarget = targetFilename and normalizePath(targetFilename) or nil

for _, descendant in ipairs(dataFolder:GetDescendants()) do
	if descendant:IsA("ModuleScript") then
		local modulePath = relativePath(descendant) .. ".lua"

		if not normalizedTarget or modulePath == normalizedTarget then
			table.insert(records, {
				path = modulePath,
				source = descendant.Source,
			})
		end
	end
end

if normalizedTarget and #records == 0 then
	error("ModuleScript not found under ReplicatedFirst.Data: " .. normalizedTarget)
end

table.sort(records, function(left, right)
	return left.path < right.path
end)

return HttpService:JSONEncode(records)
```

If the MCP response is too large, first export only module paths, then fetch sources in smaller batches with the same relative path logic.

## Local Write Rules

After decoding the JSON records:

1. Resolve each destination under `src/ReplicatedFirst/Data`.
2. Reject any record whose path is absolute or contains `..`.
3. Build the exported path set from every record.
4. For full sync only, delete every existing local file under `src/ReplicatedFirst/Data` whose relative path is not in the exported path set.
5. Create missing subdirectories under `src/ReplicatedFirst/Data`.
6. Write `source` exactly as returned by Studio.
7. Overwrite existing files with the same path.
8. For full sync only, remove empty subdirectories left behind by deleted files.

For many files, prefer a short Python script that reads the exported JSON and mirrors files with `pathlib`, because it is less error-prone than many manual edits.

## Verification

Before reporting completion:

- Confirm at least one ModuleScript was exported, unless Studio `Data` is intentionally empty.
- Run a diff scoped to `src/ReplicatedFirst/Data`.
- For full sync, report how many files were written and deleted, and list notable created, overwritten, or removed files.
- For single-file sync, report the one file written and do not report unrelated local files as candidates for deletion.
- For full sync, state that `src/ReplicatedFirst/Data` now mirrors the Studio export.
- For single-file sync, state which file was synced and that other local files were left unchanged.

Do not modify `default.project.json`; this repository intentionally ignores `src/ReplicatedFirst/Data` in Rojo sync.

## Common Mistakes

- Do not use filesystem inspection as a substitute for Studio MCP; Studio data is the source of truth.
- Do not switch to a Studio project whose name lacks `DB_DEV`.
- Do not preserve local-only files during full sync; delete them so the folder matches Studio.
- Do not delete unrelated files during single-file sync.
- Do not sync `ReplicatedFirst.Configs.Data`; the required source is `ReplicatedFirst.Data`.
