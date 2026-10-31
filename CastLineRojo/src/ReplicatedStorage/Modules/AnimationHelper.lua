local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TMmoduleV2 = require(ReplicatedStorage.Libs.TMmoduleV2)

local AnimationHelper = {}

local carAndDummyOriginalPosition = {}
local playingAnimationObjects = {}
local carAndDummyOriginalSize = {}
local carAndDummyOriginalRotation = {}

local totalAnimaTracks = {}

return AnimationHelper
