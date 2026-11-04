local FriendsHelper = {}

local FriendsConfig = require(script.FriendsConfig)

function FriendsHelper.GetFriends()
	return FriendsConfig
end
function FriendsHelper.GetFriendsImg(index,index2)
	return FriendsConfig[tonumber(index)][tonumber(index2)].img
end
function FriendsHelper.GetFriendsTxt(index,index2)
	return FriendsConfig[tonumber(index)][tonumber(index2)].num
end


return FriendsHelper
