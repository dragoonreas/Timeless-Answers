--[[
    Timeless Answers: Auto-completes the 'A Timeless Question' daily quest on the Timeless Isle.
    Copyright (C) 2013 dragoonreas

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

-- Create frame
local frame = CreateFrame("FRAME", "TimelessAnswers");

-- Register frame with quest dialogue events
frame:RegisterEvent("GOSSIP_SHOW");
frame:RegisterEvent("QUEST_DETAIL");
frame:RegisterEvent("QUEST_COMPLETE");

-- Create question/answer table
local questions = {
    ["Draka's Fury."] = "This Horde ship was crafted by goblins. Originally intended to bring Thrall and Aggra to the Maelstrom, the ship was destroyed in a surprise attack by the Alliance.",
    ["Mur'ghouls."] = "Tell me, hero, what are undead murlocs called?",
    ["Mirador."] = "What is the name of Tirion Fordring's gray stallion?",
    ["Tiffin Ellerian Wrynn."] = "Which of these is the correct name for King Varian Wrynn's first wife?",
    ["Xavius."] = "Who was the first satyr to be created?",
    ["Calissa Harrington."] = "Before Ripsnarl became a worgen, he had a family. What was his wife's name?",
    ["Coilfang Reservoir."] = "This structure, located in Zangarmarsh, was controlled by naga who sought to drain a precious and limited resource: the water of Outland.",
    ["Mueh'zala."] = "One name for this loa is \"Night's Friend\".",
    ["Holia Sunshield."] = "This defender of the Scarlet Crusade was killed while slaying the dreadlord Beltheris.",
    ["Mag'har."] = "Brown-skinned orcs first began showing up on Azeroth several years after the Third War, when the Dark Portal was reactivated. What are these orcs called?",
    ["Sayaad."] = "Succubus demons revel in causing anguish, and they serve the Legion by conducting nightmarish interrogations. What species is the succubus?",
    ["Giles."] = "While working as a tutor, Stalvan Mistmantle became obsessed with one of his students, a young woman named Tilloa. What was the name of her younger brother?",
    ["Veranus."] = "Who was the mighty proto-dragon captured by Loken and transformed into Razorscale?",
    ["Tatai."] = "This emissary of the Horde felt that Silvermoon City was a little too bright and clean.",
    ["Queen Mia Greymane."] = "This queen oversaw the evacuation of her people after the Cataclysm struck and the Forsaken attacked her nation.",
    ["Talak."] = "Not long ago, this frail Zandalari troll sought to tame a direhorn. Although he journeyed to the Isle of Giants, he was slain in his quest. What was his name?",
    ["Acherus."] = "Arthas's death knights were trained in a floating citadel that was taken by force when many of them rebelled against the Lich King. What was the fortress's name?",
    ["Frostwolf clan."] = "White wolves were once the favored mounts of which orc clan?",
    ["Sharp claw."] = "In Taur-ahe, the language of the tauren, what does lar'korwi mean?",
    ["K'aresh."] = "Name the homeworld of the ethereals.",
    ["Teron Gorefiend."] = "Who was the first death knight to be created on Azeroth?",
    ["Mord'rethar."] = "In the assault on Icecrown, Horde forces dishonorably attacked Alliance soldiers who were busy fighting the Scourge and trying to capture this gate.",
    ["Tainted grain."] = "What evidence drove Prince Arthas to slaughter the people of Stratholme during the Third War?",
    ["Gelbin Mekkatorque."] = "Who is the current leader of the gnomish people?",
    ["Cenarion Circle."] = "Malfurion Stormrage helped found this group, which is the primary druidic organization of Azeroth.",
    ["Defective elekk turd."] = "The draenei like to joke that in the language of the naaru, the word Exodar has this meaning.",
    ["Sky'ree."] = "Thane Kurdran Wildhammer recently suffered a tragic loss when his valiant gryphon was killed in a fire. What was this gryphon's name?",
    ["Blue dragonflight."] = "Before she was raised from the dead by Arthas to serve the Scourge, Sindragosa was a part of what dragonflight?",
    ["Toothgnasher."] = "The Ironforge library features a replica of an unusually large ram's skeleton. What was the name of this legendary ram?",
    ["Norgannon."] = "Name the titan lore-keeper who was a member of the elite Pantheon.",
    ["Nordrassil."] = "What did the Dragon Aspects give the night elves after the War of the Ancients?",
    ["Nobundo."] = "Formerly a healthy paladin, this draenei fell ill after fighting the Burning Legion and becoming one of the Broken. He later became a powerful shaman.",
    ["Tenebron, Vesperon, and Shadron."] = "Who were the three young twilight drakes guarding twilight dragon eggs in the Obsidian Sanctum?",
    ["Belan shi."] = "What phrase means \"Thank you\" in Draconic, the language of dragons?",
    ["Red pox."] = "Before the original Horde formed, a highly contagious sickness began spreading rapidly among the orcs. What did the orcs call it?",
    ["Archdruid."] = "What is the highest rank bestowed on a druid?",
    ["King Terenas Menethil II."] = "Whose tomb includes the inscription \"May the bloodied crown stay lost and forgotten\"?",
};

-- Custom print function
local function Print(msg, isError)
	-- Append coloured prefix to output
	if isError then print(format("|cFFFFFF00TA -|r |cFFFF0000Error:|r %s", msg));
	else print(format("|cFFFFFF00TA -|r %s", msg)); end
end

-- Make function to call when regeistered events for quest dialogues are called
local function frame_OnEvent(self, event, ...)
    -- Check if Senior Historian Evelyna is targeted
    if UnitExists("target") and tonumber(UnitGUID("target"):sub(6, 10), 16) == 73570 then
        --Print(format("%s event fired.", event));
        -- Check event type
        if event == "QUEST_DETAIL" then
            -- Accept the quest
            AcceptQuest();
            --Print("A Timeless Question quest accepted.");
            
        elseif event == "GOSSIP_SHOW" then
            -- Check if we've yet to answer the question
            if GetNumGossipOptions() == 4 then
                -- Get the question and options if we haven't answered it yet
                local question = GetGossipText();
                local options = { ["text"] = {}, ["type"] = {} };
                options["text"][1], options["type"][1], options["text"][2], options["type"][2], options["text"][3], options["type"][3], options["text"][4], options["type"][4] = GetGossipOptions();
                
                -- Try and find the question so we can get the answer
                local qFound, aFound = false, false;
                for a, q in pairs(questions) do
                    if question == "Let us test your knowledge of history, then! " .. q then
                        qFound = true;
                        Print(format("|cFF00FF00Found Question:|r %s", q));
                        
                        -- Now that we know the answer, try and find it in the given options
                        for i, o in pairs(options["text"]) do
                            if o == a then
                                aFound = true;
                                -- Select the option with the correct answer
                                SelectGossipOption(i);
                                Print(format("|cFF00FF00Found Answer:|r Option %d. %s", i, o));
                                
                                break;
                            end
                        end
                        
                        -- Blizzard's changed the quest text since the PTR...
                        if aFound == false then Print(format("Answer of \"%s\" for question \"%s\" not found in gossip options.", a, q), true); end
                        
                        break;
                    end
                end
                
                -- Blizzard's added questions since the PTR...
                if qFound == false then Print(format("Question from \"%s\" not found.", question), true); end
                
            -- Check if we've already answered the question
            elseif GetGossipText() == "That is correct!" then
				-- Close the conglatulatory dialogue if the question's been answered (we cheated so we don't deserve it anyway)
				CloseGossip();
				--Print("Congratulatory message closed.");
               
            end
        elseif event == "QUEST_COMPLETE" and GetNumQuestChoices() == 0 then
			-- Complete the quest
			GetQuestReward();
			--Print("A Timeless Question quest completed.");
           
        end
    end
end

-- Set above function to be run when registered events for quest dialogues are called
frame:SetScript("OnEvent", frame_OnEvent);

-- Output that the addon has loaded
Print("Timeless Answers Loaded.");
