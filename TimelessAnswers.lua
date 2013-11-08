--[[
    Timeless Answers: Auto-completes the 'A Timeless Question' daily quest on the Timeless Isle.
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

--@debug@
-- Check if we're using the Locale Exporter instead (not to be included in the CurseForge Packages)
if addon.localexporter then return; end
--@end-debug@

-- Create frame
local frame = CreateFrame("FRAME");

-- Get locale strings table
local L = LibStub("AceLocale-3.0"):GetLocale(ADDON_NAME);

-- NPC ID of Senior Historian Evelyna, the quest giver for the 'A Timeless Question' quest
local NPC_ID = 73570;

-- Total number of options given to choose from for each question
local NUM_OF_OPTIONS = 4;

-- Table of questions and their answers
local questions = {
    [ L["Let us test your knowledge of history, then! This Horde ship was crafted by goblins. Originally intended to bring Thrall and Aggra to the Maelstrom, the ship was destroyed in a surprise attack by the Alliance."] ] = L["Draka's Fury."],
    [ L["Let us test your knowledge of history, then! Tell me, hero, what are undead murlocs called?"] ] = L["Mur'ghouls."],
    [ L["Let us test your knowledge of history, then! What is the name of Tirion Fordring's gray stallion?"] ] = L["Mirador."],
    [ L["Let us test your knowledge of history, then! Which of these is the correct name for King Varian Wrynn's first wife?"] ] = L["Tiffin Ellerian Wrynn."],
    [ L["Let us test your knowledge of history, then! Who was the first satyr to be created?"] ] = L["Xavius."],
    [ L["Let us test your knowledge of history, then! Before Ripsnarl became a worgen, he had a family. What was his wife's name?"] ] = L["Calissa Harrington."],
    [ L["Let us test your knowledge of history, then! This structure, located in Zangarmarsh, was controlled by naga who sought to drain a precious and limited resource: the water of Outland."] ] = L["Coilfang Reservoir."],
    [ L["Let us test your knowledge of history, then! One name for this loa is \"Night's Friend\"."] ] = L["Mueh'zala."],
    [ L["Let us test your knowledge of history, then! This defender of the Scarlet Crusade was killed while slaying the dreadlord Beltheris."] ] = L["Holia Sunshield."],
    [ L["Let us test your knowledge of history, then! Brown-skinned orcs first began showing up on Azeroth several years after the Third War, when the Dark Portal was reactivated. What are these orcs called?"] ] = L["Mag'har."],
    [ L["Let us test your knowledge of history, then! Succubus demons revel in causing anguish, and they serve the Legion by conducting nightmarish interrogations. What species is the succubus?"] ] = L["Sayaad."],
    [ L["Let us test your knowledge of history, then! While working as a tutor, Stalvan Mistmantle became obsessed with one of his students, a young woman named Tilloa. What was the name of her younger brother?"] ] = L["Giles."],
    [ L["Let us test your knowledge of history, then! Who was the mighty proto-dragon captured by Loken and transformed into Razorscale?"] ] = L["Veranus."],
    [ L["Let us test your knowledge of history, then! This emissary of the Horde felt that Silvermoon City was a little too bright and clean."] ] = L["Tatai."],
    [ L["Let us test your knowledge of history, then! This queen oversaw the evacuation of her people after the Cataclysm struck and the Forsaken attacked her nation."] ] = L["Queen Mia Greymane."],
    [ L["Let us test your knowledge of history, then! Not long ago, this frail Zandalari troll sought to tame a direhorn. Although he journeyed to the Isle of Giants, he was slain in his quest. What was his name?"] ] = L["Talak."],
    [ L["Let us test your knowledge of history, then! Arthas's death knights were trained in a floating citadel that was taken by force when many of them rebelled against the Lich King. What was the fortress's name?"] ] = L["Acherus."],
    [ L["Let us test your knowledge of history, then! White wolves were once the favored mounts of which orc clan?"] ] = L["Frostwolf clan."],
    [ L["Let us test your knowledge of history, then! In Taur-ahe, the language of the tauren, what does lar'korwi mean?"] ] = L["Sharp claw."],
    [ L["Let us test your knowledge of history, then! Name the homeworld of the ethereals."] ] = L["K'aresh."],
    [ L["Let us test your knowledge of history, then! Who was the first death knight to be created on Azeroth?"] ] = L["Teron Gorefiend."],
    [ L["Let us test your knowledge of history, then! In the assault on Icecrown, Horde forces dishonorably attacked Alliance soldiers who were busy fighting the Scourge and trying to capture this gate."] ] = L["Mord'rethar."],
    [ L["Let us test your knowledge of history, then! What evidence drove Prince Arthas to slaughter the people of Stratholme during the Third War?"] ] = L["Tainted grain."],
    [ L["Let us test your knowledge of history, then! Who is the current leader of the gnomish people?"] ] = L["Gelbin Mekkatorque."],
    [ L["Let us test your knowledge of history, then! Malfurion Stormrage helped found this group, which is the primary druidic organization of Azeroth."] ] = L["Cenarion Circle."],
    [ L["Let us test your knowledge of history, then! The draenei like to joke that in the language of the naaru, the word Exodar has this meaning."] ] = L["Defective elekk turd."],
    [ L["Let us test your knowledge of history, then! Thane Kurdran Wildhammer recently suffered a tragic loss when his valiant gryphon was killed in a fire. What was this gryphon's name?"] ] = L["Sky'ree."],
    [ L["Let us test your knowledge of history, then! Before she was raised from the dead by Arthas to serve the Scourge, Sindragosa was a part of what dragonflight?"] ] = L["Blue dragonflight."],
    [ L["Let us test your knowledge of history, then! The Ironforge library features a replica of an unusually large ram's skeleton. What was the name of this legendary ram?"] ] = L["Toothgnasher."],
    [ L["Let us test your knowledge of history, then! Name the titan lore-keeper who was a member of the elite Pantheon."] ] = L["Norgannon."],
    [ L["Let us test your knowledge of history, then! What did the Dragon Aspects give the night elves after the War of the Ancients?"] ] = L["Nordrassil."],
    [ L["Let us test your knowledge of history, then! Formerly a healthy paladin, this draenei fell ill after fighting the Burning Legion and becoming one of the Broken. He later became a powerful shaman."] ] = L["Nobundo."],
    [ L["Let us test your knowledge of history, then! Who were the three young twilight drakes guarding twilight dragon eggs in the Obsidian Sanctum?"] ] = L["Tenebron, Vesperon, and Shadron."],
    [ L["Let us test your knowledge of history, then! What phrase means \"Thank you\" in Draconic, the language of dragons?"] ] = L["Belan shi."],
    [ L["Let us test your knowledge of history, then! Before the original Horde formed, a highly contagious sickness began spreading rapidly among the orcs. What did the orcs call it?"] ] = L["Red pox."],
    [ L["Let us test your knowledge of history, then! What is the highest rank bestowed on a druid?"] ] = L["Archdruid."],
    [ L["Let us test your knowledge of history, then! Whose tomb includes the inscription \"May the bloodied crown stay lost and forgotten\"?"] ] = L["King Terenas Menethil II."],
};

-- Custom print function
function Print(msg, isError)

	-- Append coloured prefix to output
	if isError then print( format( L["|cFFFFFF00TA -|r |cFFFF0000Error:|r %s"], msg ) );
	else print( format( L["|cFFFFFF00TA -|r %s"], msg ) ); end
end

-- Function to check if Senior Historian Evelyna is targeted
function WrongNPC() return not UnitExists("target") or tonumber( UnitGUID("target"):sub(6, 10), 16 ) ~= NPC_ID; end

-- Table of functions to be run when their events are called
local events = {};

-- Function to call when GOSSIP_SHOW event is fired
function events:GOSSIP_SHOW(self, ...)

	-- Check if Senior Historian Evelyna is targeted
	if WrongNPC() then return; end
	
    -- Check if we've yet to answer the question
    if GetNumGossipOptions() == NUM_OF_OPTIONS then

        -- Get the question and it's answer if we haven't answered it yet
        local question = GetGossipText();
        local answer = questions[question];
        
        -- Check that we know the question and thus have the answer and inform the user
        if not answer then
        	Print( format( L["Question from \"%s\" not found."], question ), true );
        	return; 
        else Print( format( L["|cFF00FF00Found Question:|r %s"], question ) ); end
        
        -- Get the options we have to pick from for the answer
        local options = {};
        for index = 1, GetNumGossipOptions() * 2 - 1, 2 do options[select(index, GetGossipOptions())] = index; end
        
        -- Try and find the answer in the given options
        if option[answer] then

            -- Select the option with the correct answer and inform the user
            SelectGossipOption(index);
            Print( format( L["|cFF00FF00Found Answer:|r Option %d. %s"], index, option ) );
            
            -- If we don't find the answer in the options and leave the function then an error message will be output to the user
            return;
        end
        
        -- Either Blizzard's changed the option text for the answer or our localised answer sting is incorrect
        Print( format( L["Answer of \"%s\" for question \"%s\" not found in gossip options."], answer, question ), true );
        
    -- Check if we've already answered the question
    elseif GetGossipText() == L["That is correct!"] then

		-- Close the congratulatory dialogue if the question's been answered (we cheated so we don't deserve it anyway)
		CloseGossip();
    end
end

-- Function to call when QUEST_DETAIL event is fired
function events:QUEST_DETAIL(self, ...)

	-- Check if Senior Historian Evelyna is targeted
	if WrongNPC() then return; end
	
	-- Accept the quest
	AcceptQuest();
end

-- Function to call when QUEST_COMPLETE event is fired
function events:QUEST_COMPLETE(self, ...)

	-- Check if Senior Historian Evelyna is targeted
	if WrongNPC() then return; end
	
	-- Complete the quest
	if GetNumQuestChoices() == 0 then GetQuestReward(); end
end

-- Set above function to be run when registered events for quest dialogues are called
frame:SetScript("OnEvent", function(self, event, ...) events[event](self, ...); end);

-- Register frame with quest dialogue events
for event, func in pairs(events) do frame:RegisterEvent(event); end

-- Inform the user that the addon has loaded
Print( L["Timeless Answers Loaded."] );
