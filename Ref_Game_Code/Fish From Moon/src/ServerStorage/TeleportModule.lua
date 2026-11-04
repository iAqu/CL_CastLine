
local TeleportService = game:GetService("TeleportService")

local TeleportModule = {}

local RETRY_DELAY = 2
local MAX_WAIT = 10

function TeleportModule.teleportWithRetry(targetPlaceID, playersTable, teleportOptions)
	local currentWait = 0

	local function doTeleport(players, options)
		if currentWait < MAX_WAIT then
			local success, errorMessage = pcall(function()
				return TeleportService:TeleportAsync(targetPlaceID, players, options)
			end)
			if not success then
				warn(errorMessage)
				-- 在定义的延迟后重试传送
				wait(RETRY_DELAY)
				currentWait = currentWait + RETRY_DELAY
				doTeleport(players, teleportOptions)
			end
		else
			return true
		end
	end

	TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
		if teleportResult ~= Enum.TeleportResult.Success then
			warn(errorMessage)
			-- 在定义的延迟后重试传送
			wait(RETRY_DELAY)
			currentWait = currentWait + RETRY_DELAY
			doTeleport({player}, teleportOptions)
		end
	end)

	-- 触发初始传送
	doTeleport(playersTable, teleportOptions)
end

return TeleportModule