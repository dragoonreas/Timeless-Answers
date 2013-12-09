--[[
	Traditional Chinese localisation strings for Timeless Answers.
	
	Translation Credits: http://wow.curseforge.com/addons/timeless-answers/localization/translators/
	
	Please update http://www.wowace.com/addons/timeless-answers/localization/zhTW/ for any translation additions or changes.
	Once reviewed, the translations will be automatically incorperated in the next build by the localization application.
	
	These translations are released under the Public Domain.
]]--

-- Get addon name
local addon = ...

-- Create the Traditional Chinese localisation table
local L = LibStub("AceLocale-3.0"):NewLocale(addon, "zhTW", false)
if not L then return; end

-- Messages output to the user's chat frame
--@localization(locale="zhTW", format="lua_additive_table", handle-unlocalized="english", same-key-is-true=true, namespace="Message2")@

-- Gossip from the NPC that's neither an answer nor a question
--@localization(locale="zhTW", format="lua_additive_table", handle-unlocalized="english", same-key-is-true=true, namespace="Gossip")@

-- The complete gossip text from when the NPC asks the question
--@localization(locale="zhTW", format="lua_additive_table", handle-unlocalized="english", same-key-is-true=true, namespace="Question2")@

-- The complete gossip option text of the correct answer from when the NPC asks the question
--@localization(locale="zhTW", format="lua_additive_table", handle-unlocalized="english", same-key-is-true=true, namespace="Answer")@
