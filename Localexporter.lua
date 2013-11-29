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
	["<question>"] = {"<incorrect_answer>" = <option_index>}, -- found question but no correct answer yet
	["<question>"] = "<correct_answer>", -- found question and correct answer
}
]]--
local questions = {};

--[[
The gossip text displayed after selecting an answer
{
	["incorrect"] = "<incorrect_response>",
	["correct"] = "<correct_reponse>",
}
]]--
local responses = {};

-- Table of responses and question strings for questions which have had their answers varified this session
local sessionChecked = {};

-- The response, question and answer currently being checked
local sessionChecking = {};

-- Function to get the length of a table
local function TableLength(table)

	-- Return -1 if the variable given's not a table
	if type(table) ~= "table" then return -1; end

	-- Count each pair stored in the table and return the length
	local length = 0;
	for key, value in pairs(table) do length = length + 1; end
	return length;
end

-- Function to output custom print messages
local function Print(msg, isError)

	-- Append coloured prefix to output
	if isError then print( format("|cFFFFFF00TA -|r |cFFFF0000Error:|r %s", msg) );
	else print( format("|cFFFFFF00TA -|r %s", msg) ); end
end

-- Function to check if Senior Historian Evelyna is targeted
local function WrongNPC() return not UnitExists("target") or tonumber( UnitGUID("target"):sub(6, 10), 16 ) ~= NPC_ID; end

-- Function to check the response of the NPC to see if the answer given was incorrect or correct
local function CheckResponse(event, questIndex)

	-- Check if we have all the info we need to check the response
	if not sessionChecking.question or not sessionChecking.answer or not sessionChecking.response then return; end

	-- True if the answer was correct, false if the answer was incorrect, nil if we can't tell
	local isCorrect;

	-- Try and tell if the answer was correct or not from the response
	if event == "GOSSIP_SHOW" then
		if sessionChecked.correct and sessionChecking.response == responses.correct then isCorrect = true;
		elseif sessionChecked.incorrect and sessionChecking.response == responses.incorrect then isCorrect = false; end

	-- Get the completion status of the quest
	elseif event == "UNIT_QUEST_LOG_CHANGED" then isCorrect = select(7, GetQuestLogTitle(questIndex)) == 1; end

	-- Don't clear the sessinoChecking table if we couldn't figure out if the answer was correct or not
	if isCorrect == nil then return isCorrect;

	-- Store the correct answer and that the question's answer has been checked this session
	elseif isCorrect then
		if type(questions[sessionChecking.question]) == "string" then Print(format("|cFF00FF00Unchecked Answer Correct:|r\nQuestion: \"%s\"\nAnswer: \"%s\"", sessionChecking.question, sessionChecking.answer));
		elseif type(questions[sessionChecking.question]) == "table" then Print(format("|cFF00FF00Guessed Answer Correct:|r\nQuestion: \"%s\"\nAnswer: \"%s\"", sessionChecking.question, sessionChecking.answer)); end
		questions[sessionChecking.question] = sessionChecking.answer;
		sessionChecked[sessionChecking.question] = true;

		-- Check if the correct response text has been saved
		if not sessionChecked.correct then
			responses.correct = sessionChecking.response;
			sessionChecked.correct = true;
		end

	-- The selected answer was incorrect
	else
		if type(questions[sessionChecking.question]) == "string" then
			Print(format("|cFFFF0000Unchecked Answer Incorrect:|r\nQuestion: \"%s\"\nAnswer: \"%s\"", sessionChecking.question, sessionChecking.answer));
			questions[sessionChecking.question] = {};
		elseif type(questions[sessionChecking.question]) == "table" then Print(format("|cFFFF0000Guessed Answer Incorrect:|r\nQuestion: \"%s\"\nAnswer: \"%s\"", sessionChecking.question, sessionChecking.answer)); end
		
		-- Check if the incorrect response text has been saved
		if not sessionChecked.incorrect then
			responses.incorrect = sessionChecking.response;
			sessionChecked.incorrect = true;
		end
	end

	-- Unregister the event if it's still registered since we can now tell if the answer was correct from the response given
	if frame:IsEventRegistered("UNIT_QUEST_LOG_CHANGED") == 1 and sessionChecked.incorrect and sessionChecked.correct then frame:UnregisterEvent("UNIT_QUEST_LOG_CHANGED"); end

	-- Clear the question, answer and response being checked
	sessionChecking = {};

	-- Return if the response was correct or not
	return isCorrect;
end

-- Function to convert a value to a string format
local function toStringFormat(value, formatType)
	return type(value) == "nil" and "nil" or 
		   type(value) == "boolean" and (value == false and "false" or value == true and "true") or 
		   type(value) == "number" and format("%" .. ((formatType == "c" or formatType == "E" or formatType == "e" or formatType == "f" or formatType == "g" or formatType == "G" or formatType == "o" or formatType == "u" or formatType == "X" or formatType == "x") and formatType or "d"), value) or 
		   type(value) == "string" and format("%" .. (formatType == "q" and "q" or "s"), value) or 
		   "<" .. type(value) .. ">";
end

-- Function to extract event arguments
local function GetArguments(arg, ...)
    local argStr = "";
    arg.n = select('#', ...) or 0;
    for i = 1, arg.n do
        arg[i] = select(i, ...);
        argStr = argStr .. format("arg %d: %s" .. (i < arg.n and ", " or ""), 
				                  i,
				                  toStringFormat(arg[i], "q"));
    end
    return argStr;
end

-- Table of functions to be run when their events are called
local events = {};

--[[
Database format:
TALocalexporterDB = {
	<LOCALE> = {
		questions = {
			[<localised question>] = <localised answer>
		}
		responses = {
			correct = <localised correct answer response>
			incorrect = <localised incorrect answer response>
		}
	}
}
]]--
-- Function to call when ADDON_LOADED event is fired
function events:ADDON_LOADED(eventSelf, event, ...)

	-- Get event arguments
    local arg, argStr = {}, "";
    argStr = GetArguments(arg, ...);
    
    -- Check event arguments
    if arg.n ~= 1 then
    	Print(format("ADDON_LOADED event returned %d arguments where 1 was expected.\nArgs: %s", arg.n, argStr), true);
    	return;
    elseif type(arg[1]) ~= "string" then
    	Print(format("ADDON_LOADED event returned a %s for arg1 where a number was expected.\nArgs: %s", type(arg[1]), argStr), true);
    	return;

	-- Only continue if it was this addon that was loaded
	elseif arg[1] ~= ADDON_NAME then return; end

	-- Check if database exists
	if not (type(TALocalexporterDB) == "table") then TALocalexporterDB = {}; end

	-- Check if this locale table exists
	if not (type(TALocalexporterDB[LOCALE]) == "table") then TALocalexporterDB[LOCALE] = {}; end

	-- Load saved question / answer strings
	if type(TALocalexporterDB[LOCALE].questions) == "table" then questions = TALocalexporterDB[LOCALE].questions;
	else TALocalexporterDB[LOCALE].questions = {}; end

	-- Check if responses table exists
	if not (type(TALocalexporterDB[LOCALE].responses) == "table") then TALocalexporterDB[LOCALE].responses = {}; end

	-- Load saved responses strings
	if type(TALocalexporterDB[LOCALE].responses.correct) == "string" then responses.correct = TALocalexporterDB[LOCALE].responses.correct;
	else TALocalexporterDB[LOCALE].responses.correct = ""; end
	if type(TALocalexporterDB[LOCALE].responses.incorrect) == "string" then responses.incorrect = TALocalexporterDB[LOCALE].responses.incorrect;
	else TALocalexporterDB[LOCALE].responses.incorrect = ""; end

	-- Unregister the event since we don't need to know about any other addons being loaded
	frame:UnregisterEvent("ADDON_LOADED");
end

-- Function to call when QUEST_DETAIL event is fired
function events:QUEST_DETAIL(eventSelf, event, ...)

	-- Check if Senior Historian Evelyna is targeted
	if WrongNPC() then return; end
	
	-- Accept the quest
	AcceptQuest();
	Print("A Timeless Question quest accepted.");
end

-- Function to call when GOSSIP_SHOW event is fired
function events:GOSSIP_SHOW(eventSelf, event, ...)

	-- Check if Senior Historian Evelyna is targeted
	if WrongNPC() then return; end

	-- Check if we're on the 'A Timeless Question' quest
	local questIndex = GetQuestLogIndexByID(QUEST_ID);
	if not questIndex or questIndex < 1 then return; end

	-- Get the gossip text
	local gossipText = GetGossipText();

	-- Check if we've yet to answer the question
	if GetNumGossipOptions() == NUM_OF_OPTIONS then

		-- Check if we have all the info we need to check the response for a previous question that we must have got wrong
		if sessionChecking.question and sessionChecking.answer and sessionChecking.response then
			if type(questions[sessionChecking.question]) == "string" then Print(format("|cFFFF0000Unchecked Answer Incorrect:|r\nQuestion: \"%s\"\nAnswer: \"%s\"", sessionChecking.question, sessionChecking.answer));
			elseif type(questions[sessionChecking.question]) == "table" then Print(format("|cFFFF0000Guessed Answer Incorrect:|r\nQuestion: \"%s\"\nAnswer: \"%s\"", sessionChecking.question, sessionChecking.answer)); end
			
			-- Check if the incorrect response text has been saved
			if not sessionChecked.incorrect then
				responses.incorrect = sessionChecking.response;
				sessionChecked.incorrect = true;
			end
		end

		-- Get the question and possible answer if we haven't answered it yet
		local question = gossipText;
		if not questions[question] then questions[question] = {}; end
        local answer = questions[question];

		-- If we've checked that the answer is still correct this session, close the gossip dialogue
		if sessionChecked[question] then
			CloseGossip();
			Print(format("|cFF00FF00Found Checked Question:|r %s", question));
			return;
		else Print(format("|cFF00FF00Found Unchecked Question:|r %s", question)); end

        -- Get the options we have to pick from for the answer
		local options = {};
        for index = 1, NUM_OF_OPTIONS * 2 - 1, 2 do options[select(index, GetGossipOptions())] = (index + 1) / 2; end
		
		-- Check if we think we know the answer
		if type(answer) == "string" then

			-- Check if the assumed answer is an option
			if options[answer] then

				-- Select the option with the assumed answer, and keep track of the question to check if it was correct
				SelectGossipOption(options[answer]);
				sessionChecking = { ["question"]=question, ["answer"]=answer };
				Print(format("|cFFFF8000Found Unchecked Answer:|r Option %d. %s", options[answer], answer));
				return;

			-- The assumed answer wasn't avaliable, so make a table to put new guesses in
			else
				Print( format("|cFFFF0000Found Missing Answer:|r %s", answer) );
				answer = {};
			end
		end
		
		-- Check if we know any wrong answers, and make a guess
		if type(answer) == "table" then
			for option, index in pairs(options) do
				if not answer[option] then
					SelectGossipOption(index);
					questions[question][option] = index;
					sessionChecking = { ["question"]=question, ["answer"]=option };
					Print(format("|cFFFF8000Guessing Answer:|r Option %d. %s", index, option));
					return;
				end
			end
			
			-- If all answers are incorrect the answer table must have got corrupted somehow, so clear it so we can try again
			questions[question] = {};
			Print(format("All answers for question \"%s\" were incorrect.", question), true);
		end
	end

	-- Check the response
	sessionChecking.response = gossipText;
	CheckResponse("GOSSIP_SHOW");

	-- Close the dialogue since the question's been answered
	CloseGossip();
	Print("Response message closed.");
end

-- Function to call when UNIT_QUEST_LOG_CHANGED event is fired
function events:UNIT_QUEST_LOG_CHANGED(eventSelf, event, ...)

	-- Check if we're on the 'A Timeless Question' quest
	local questIndex = GetQuestLogIndexByID(QUEST_ID);
	if not questIndex or questIndex < 1 then return; end

	-- Get event arguments
    local arg, argStr = {}, "";
    argStr = GetArguments(arg, ...);

    -- Check event arguments
    if arg.n ~= 1 then Print(format("%s event returned %d arguments where 1 was expected.\nArgs: %s", event, arg.n, argStr), true);
    elseif type(arg[1]) ~= "string" then Print(format("%s event returned a %s for argument one where a string was expected.\nArgs: %s", event, type(arg[1])), argStr, true);
	else

		-- Check if the update was for the player
		if arg[1] == "player" then

			-- Check the response
			CheckResponse(event, questIndex);
		end
	end
end

-- Function to call when QUEST_COMPLETE event is fired
function events:QUEST_COMPLETE(eventSelf, event, ...)

	-- Check if Senior Historian Evelyna is targeted
	if WrongNPC() then return; end

	-- Check if we're on the 'A Timeless Question' quest
	local questIndex = GetQuestLogIndexByID(QUEST_ID);
	if not questIndex or questIndex < 1 then return; end

	-- Check if we need to abandon the quest so the rest of the localised strings can be collected
	if TableLength(sessionChecked) < NUM_OF_QUESTIONS + 2 then
		Print(format("%d / %d questions localised for %s locale.", TableLength(sessionChecked) - (sessionChecked.correct and 1 or 0) - (sessionChecked.incorrect and 1 or 0), NUM_OF_QUESTIONS, LOCALE));

		-- Abandon the 'A Timeless Question' quest
		SelectQuestLogEntry(questIndex);
		SetAbandonQuest();
		AbandonQuest();

		-- Close the dialogue since we still need to check more questions
		CloseQuest();
	else

		-- Complete the quest
		--if GetNumQuestChoices() == 0 then GetQuestReward(); end
		Print(format("Gossip text localisation for %s locale completed.", LOCALE));

		-- Check if there are any old questions left in the table, and remove them
		if TableLength(questions) > NUM_OF_QUESTIONS then
			for question, answer in pairs(questions) do
				if not sessionChecked[question] then questions[question] = nil; end
			end
		end
	end
end

-- Function to call when PLAYER_LOGOUT event is fired
function events:PLAYER_LOGOUT(eventSelf, event, ...)

	-- Save question / answer strings
	TALocalexporterDB[LOCALE].questions = questions;

	-- Save gossip strings
	TALocalexporterDB[LOCALE].responses = responses;
end

-- Set above function to be run when registered events for quest dialogues are called
frame:SetScript("OnEvent", function(eventSelf, event, ...) events[event](nil, eventSelf, event, ...); end); -- TODO: Find out why the first argument isn't set (hence the hack-fix of sending nil as the first argument)

-- Register frame with quest dialogue events
for event, func in pairs(events) do frame:RegisterEvent(event); end

-- Output that the addon has loaded
Print("Timeless Answers Locale Exporter Loaded.");
