local function readFile(path)
	local file = assert(io.open(path, "r"))
	local contents = file:read("*a")
	file:close()
	return contents
end

local notificationClient = readFile("src/ReplicatedStorage/Modules/NotificationClient.lua")

assert(
	notificationClient:find("RunService.Heartbeat", 1, true),
	"NotificationClient should use Heartbeat-driven expiration"
)

assert(
	notificationClient:find("MAX_ACTIVE = 4", 1, true),
	"NotificationClient should cap active notifications at 4"
)

assert(
	notificationClient:find("function module.IconNotify(", 1, true),
	"NotificationClient should expose IconNotify"
)

assert(
	notificationClient:find("function module.NotifyGotAnimal(", 1, true),
	"NotificationClient should expose NotifyGotAnimal"
)

assert(
	notificationClient:find("function module.NotifyGotEgg(", 1, true),
	"NotificationClient should expose NotifyGotEgg"
)

assert(
	notificationClient:find("formatNotificationText", 1, true),
	"NotificationClient should merge duplicate notifications"
)

assert(
	notificationClient:find("bumpNotification", 1, true),
	"NotificationClient should bump merged notifications"
)

assert(
	not notificationClient:find("task.wait(duration)", 1, true),
	"NotificationClient should not block on task.wait for duration"
)

print("NotificationClient.spec.lua passed")
