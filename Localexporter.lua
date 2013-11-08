--[[
	Timeless Answers - Locale Exporter: Exports gossip strings required by the main Timeless Answers addon.
	Copyright (C) 2013 @project-author@

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]--

-- Get addon name
local ADDON_NAME, addon = ...;

-- Set to true to load the Locale Exporter, or false to load the main addon
addon.localexporter = true;

-- Check if we're using the main addon instead
if not addon.localexporter then return; end

-- Create frame
local frame = CreateFrame("FRAME");

-- Current game locale being used
local LOCALE = GetLocale();
if LOCALE == "enGB" then LOCALE = "enUS"; end

-- The quest id for the 'A Timeless Question' quest
local QUEST_ID = 33211;

-- NPC ID of Senior Historian Evelyna, the quest giver for the 'A Timeless Question' quest
local NPC_ID = 73570;

-- Total number of questions known to be asked in the gossip text
local NUM_OF_QUESTIONS = 37;

-- Total number of options given to choose from for each question
local NUM_OF_OPTIONS = 4;

--[[
To be filled with 37 questions and their answers at runtime
Need type check for table (no correct answer yet) or string (correct answer found) in pair value
NOTE: Question strings in the table keys include the "Let us test your knowledge of history, then! " part of the gossip text for the question, unlike the localised strings for the questions older versions of the main addon used which seperated the two stings
{
	["<question>"] = {"<wrong_answer>" = <option_index>, "<wrong_answer>" = <option_index>, "<wrong_answer>" = <option_index>}, -- found question but no correct answer yet
	["<question>"] = "<correct_answer", -- found question and correct answer
}
]]--
local questions = {};

-- Table of question strings for questions which have had their answers varified this session
local sessionChecked = {};

-- The question and answer currently being checked
local sessionChecking = nil;

-- The gossip text displayed after selecting a correct answer
local congratulatoryText = nil;

-- Get the length of a table
local function tableLength(table)

	-- Return nil if the variable given's not a table
	if type(table) ~= "table" then return nil; end

	-- Count each pair stored in the table and return the length
	local length = 0;
	for key, value in pairs(table) do length = length + 1; end
	return length;
end

-- Function to output custom print messages
local function Print(msg, isError)

	-- Append coloured prefix to output
	if isError then print( format( L["|cFFFFFF00TA -|r |cFFFF0000Error:|r %s"], msg ) );
	else print( format( L["|cFFFFFF00TA -|r %s"], msg ) ); end
end

-- Function to check if Senior Historian Evelyna is targeted
local function WrongNPC() return not UnitExists("target") or tonumber( UnitGUID("target"):sub(6, 10), 16 ) ~= NPC_ID; end

-- Table of functions to be run when their events are called
local events = {};

--[[
Database format:
TALocalexporterDB = {
	<LOCALE> = {
		questions = {
			[<localised question>] = <localised answer>
		}
		gossip = {
			congratulate = <localised congratulatory text>
		}
	}
}
]]--
-- Function to call when ADDON_LOADED event is fired
function events:ADDON_LOADED(self, ...)

	-- Only continue if it was this addon that was loaded
	if select(1, ...) ~= ADDON_NAME then return; end

	-- Check if database exists
	if not type(TALocalexporterDB) == "table" then TALocalexporterDB = {}; end

	-- Check if locale table exists
	if not type(TALocalexporterDB[LOCALE]) == "table" then TALocalexporterDB[LOCALE] = {}; end

	-- Load saved question / answer strings
	if TALocalexporterDB[LOCALE].questions then questions = TALocalexporterDB[LOCALE].questions;
	else TALocalexporterDB[LOCALE].questions = {}; end

	-- Check if gossip table exists
	if not type(TALocalexporterDB[LOCALE].gossip) == "table" then TALocalexporterDB[LOCALE].gossip = {}; end

	-- Load saved gossip strings
	if TALocalexporterDB[LOCALE].gossip.congratulate then congratulatoryText = TALocalexporterDB[LOCALE].gossip.congratulatoryText;
	else TALocalexporterDB[LOCALE].gossip.congratulate = ""; end

	-- Unregister the event since we don't need to know about any other addons being loaded
	frame:UnregisterEvent("ADDON_LOADED");
end

-- Function to call when GOSSIP_SHOW event is fired
function events:GOSSIP_SHOW(self, ...)

	-- Check if Senior Historian Evelyna is targeted
	if WrongNPC() then return; end

	-- Check if we're on the 'A Timeless Question' quest
	local questIndex = GetQuestLogIndexByID(QUEST_ID);
	if not questIndex or questIndex < 1 then return; end
	
	-- Check if we've yet to answer the question
	if GetNumGossipOptions() == NUM_OF_OPTIONS then

		-- Get the question and possible answer if we haven't answered it yet
		local question = GetGossipText();
        local answer = questions[question];

		-- If we've checked that the answer is still correct this session, close the gossip dialogue
		if sessionChecked[question] then
			CloseGossip();
			Print( format("|cFF00FF00Found Checked Question:|r %s", question) );
			return;
		else Print( format("|cFF00FF00Found Unchecked Question:|r %s", question) ); end

        -- Get the options we have to pick from for the answer
		local options = {};
        for index = 1, NUM_OF_OPTIONS * 2 - 1, 2 do options[select(index, GetGossipOptions())] = index; end

        -- Make sure we either have an assumed answer string or a table of wrong answer strings
        if not type(answer) == "string" and not type(answer) == "table" then answer = {}; end
		
		-- Check if we think we know the answer
		if type(answer) == "string" then

			-- Check if the assumed answer is an option
			if options[answer] then

				-- Select the option with the assumed answer, and keep track of the question to check if it was correct
				SelectGossipOption(options[answer]);
				sessionChecking = question;
				Print( format("|cFFFF8000Found Unchecked Answer:|r Option %d. %s", options[answer], answer) );
				return;

			-- The assumed answer wasn't avaliable, so make a table to put new guesses in
			else
				Print( format("|cFFFF0000Found Missing Answer:|r %s", answer) );
				answer = {};
			end
		end

		-- Check if we know any wrong answers, and make a guess
		if type(answer) == "table" then
			for option, index in pairs(options)
				if not answer[option] then
					SelectGossipOption(index);
					questions[question][option] = index;
					sessionChecking = { question, answer };
					Print( format("|cFFFF8000Guessing Answer:|r Option %d. %s", index, answer) );
					return;
				end
			end
		end
	end

	-- Check if we've answered the question correctly
	local title, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID, displayQuestID = GetQuestLogTitle(questIndex);
	if isComplete then

		-- Store the correct answer and that the question's answer has been checked this session
		if type(questions[sessionChecking[1]]) == "string" then Print( format("|cFF00FF00Unchecked Answer Correct:|r Question: \"%s\", Answer: \"%s\"", sessionChecking[1], sessionChecking[2]) );
		elseif type(questions[sessionChecking[1]]) == "table" then Print( format("|cFF00FF00Guessed Answer Correct:|r Question: \"%s\", Answer: \"%s\"", sessionChecking[1], sessionChecking[2]) ); end
		questions[sessionChecking[1]] = sessionChecking[2]
		sessionChecked[sessionChecking[1]] = true

		-- Check if the congratulatory text has been changed
		if not congratulatoryText or GetGossipText() ~= congratulatoryText then
			congratulatoryText = GetGossipText();
			Print("Congratulatory message saved and closed.");
		else Print("Congratulatory message closed."); end
	else

		-- The selected answer was incorrect
		if type(questions[sessionChecking[1]]) == "string" then Print( format("|cFFFF0000Unchecked Answer Incorrect:|r Question: \"%s\", Answer: \"%s\"", sessionChecking[1], sessionChecking[2]) );
		elseif type(questions[sessionChecking[1]]) == "table" then Print( format("|cFFFF0000Guessed Answer Incorrect:|r Question: \"%s\", Answer: \"%s\"", sessionChecking[1], sessionChecking[2]) ); end
	end

	-- Close the dialogue since the question's been answered
	CloseGossip();

	-- Clear the question and answer being checked
	sessionChecking = nil;
end

-- Function to call when QUEST_DETAIL event is fired
function events:QUEST_DETAIL(self, ...)

	-- Check if Senior Historian Evelyna is targeted
	if WrongNPC() then return; end
	
	-- Accept the quest
	AcceptQuest();
	Print("A Timeless Question quest accepted.");
end

-- Function to call when QUEST_COMPLETE event is fired
function events:QUEST_COMPLETE(self, ...)

	-- Check if Senior Historian Evelyna is targeted
	if WrongNPC() then return; end

	-- Check if we're on the 'A Timeless Question' quest
	local questIndex = GetQuestLogIndexByID(QUEST_ID);
	if not questIndex or questIndex < 1 then return; end

	-- Check if we need to abandon the quest so the rest of the localised strings can be collected
	if tableLength(sessionChecked) < NUM_OF_QUESTIONS then

		-- Get the index of the currently selected quest so we can switch back to it
		local selectedQuest = GetQuestLogSelection();

		-- Abandon the 'A Timeless Question' quest
		SelectQuestLogEntry(questIndex);
		SetAbandonQuest();
		AbandonQuest();

		-- Reselect the previously selected quest
		SelectQuestLogEntry(selectQuest());
	else

		-- Complete the quest
		if GetNumQuestChoices() == 0 then GetQuestReward(); end
		Print( format("Gossip text localisation for %s locale completed.", LOCALE) );

		-- Check if there are any old questions left in the table, and remove them
		if tableLength(questions) > NUM_OF_QUESTIONS then
			for question, answer in pairs(questions)
				if not sessionChecked[question] then questions[question] = nil; end
			end
		end
	end
end

-- Function to call when PLAYER_LOGOUT event is fired
function events:PLAYER_LOGOUT(self, ...)

	-- Save question / answer strings
	TALocalexporterDB[LOCALE].questions = questions;

	-- Save gossip strings
	TALocalexporterDB[LOCLAE].gossip.congratulate = congratulatoryText;
end

-- Set above function to be run when registered events for quest dialogues are called
frame:SetScript("OnEvent", function(self, event, ...) events[event](self, ...); end);

-- Register frame with quest dialogue events
for event, func in pairs(events) do frame:RegisterEvent(event); end

-- Output that the addon has loaded
Print("Timeless Answers Locale Exporter Loaded.");
