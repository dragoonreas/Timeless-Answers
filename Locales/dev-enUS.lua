--[[
	English localisation strings for the developement version of Timeless Answers.
	
	Make sure to update http://www.wowace.com/addons/timeless-answers/localization/ for any phrase or namespace additions or changes.
	
	These translations are released under the Public Domain.
]]--

-- Get addon name
local addon = ...

-- Create the English localisation table
local L = LibStub("AceLocale-3.0"):NewLocale(addon, "enUS", true, false)
if not L then return; end

-- Messages output to the user's chat frame
L["Timeless Answers Loaded."] = true
L["Question from \"%s\" not found."] = true
L["Answer of \"%s\" for question \"%s\" not found in gossip options."] = true
L["Option"] = true
L["Error"] = true
L["Found Answer"] = true
L["Found Question"] = true
L["TA"] = true

-- Gossip from the NPC that's neither an answer nor a question
L["That is correct!"] = true
L["Let us test your knowledge of history, then! "] = true

-- The complete gossip text from when the NPC asks the question, excluding the "Let us test your knowledge of history, then! " prefix applied to all questions
L["Whose tomb includes the inscription \"May the bloodied crown stay lost and forgotten\"?"] = true
L["What is the highest rank bestowed on a druid?"] = true
L["Before the original Horde formed, a highly contagious sickness began spreading rapidly among the orcs. What did the orcs call it?"] = true
L["What phrase means \"Thank you\" in Draconic, the language of dragons?"] = true
L["Who were the three young twilight drakes guarding twilight dragon eggs in the Obsidian Sanctum?"] = true
L["Formerly a healthy paladin, this draenei fell ill after fighting the Burning Legion and becoming one of the Broken. He later became a powerful shaman."] = true
L["What did the Dragon Aspects give the night elves after the War of the Ancients?"] = true
L["Name the titan lore-keeper who was a member of the elite Pantheon."] = true
L["The Ironforge library features a replica of an unusually large ram's skeleton. What was the name of this legendary ram?"] = true
L["Before she was raised from the dead by Arthas to serve the Scourge, Sindragosa was a part of what dragonflight?"] = true
L["Thane Kurdran Wildhammer recently suffered a tragic loss when his valiant gryphon was killed in a fire. What was this gryphon's name?"] = true
L["The draenei like to joke that in the language of the naaru, the word Exodar has this meaning."] = true
L["Malfurion Stormrage helped found this group, which is the primary druidic organization of Azeroth."] = true
L["Who is the current leader of the gnomish people?"] = true
L["What evidence drove Prince Arthas to slaughter the people of Stratholme during the Third War?"] = true
L["In the assault on Icecrown, Horde forces dishonorably attacked Alliance soldiers who were busy fighting the Scourge and trying to capture this gate."] = true
L["Who was the first death knight to be created on Azeroth?"] = true
L["Name the homeworld of the ethereals."] = true
L["In Taur-ahe, the language of the tauren, what does lar'korwi mean?"] = true
L["White wolves were once the favored mounts of which orc clan?"] = true
L["Arthas's death knights were trained in a floating citadel that was taken by force when many of them rebelled against the Lich King. What was the fortress's name?"] = true
L["Not long ago, this frail Zandalari troll sought to tame a direhorn. Although he journeyed to the Isle of Giants, he was slain in his quest. What was his name?"] = true
L["This queen oversaw the evacuation of her people after the Cataclysm struck and the Forsaken attacked her nation."] = true
L["This emissary of the Horde felt that Silvermoon City was a little too bright and clean."] = true
L["Who was the mighty proto-dragon captured by Loken and transformed into Razorscale?"] = true
L["While working as a tutor, Stalvan Mistmantle became obsessed with one of his students, a young woman named Tilloa. What was the name of her younger brother?"] = true
L["Succubus demons revel in causing anguish, and they serve the Legion by conducting nightmarish interrogations. What species is the succubus?"] = true
L["Brown-skinned orcs first began showing up on Azeroth several years after the Third War, when the Dark Portal was reactivated. What are these orcs called?"] = true
L["This defender of the Scarlet Crusade was killed while slaying the dreadlord Beltheris."] = true
L["One name for this loa is \"Night's Friend\"."] = true
L["This structure, located in Zangarmarsh, was controlled by naga who sought to drain a precious and limited resource: the water of Outland."] = true
L["Before Ripsnarl became a worgen, he had a family. What was his wife's name?"] = true
L["Who was the first satyr to be created?"] = true
L["Which of these is the correct name for King Varian Wrynn's first wife?"] = true
L["What is the name of Tirion Fordring's gray stallion?"] = true
L["Tell me, hero, what are undead murlocs called?"] = true
L["This Horde ship was crafted by goblins. Originally intended to bring Thrall and Aggra to the Maelstrom, the ship was destroyed in a surprise attack by the Alliance."] = true

-- The complete gossip option text of the correct answer from when the NPC asks the question
L["King Terenas Menethil II."] = true
L["Archdruid."] = true
L["Red pox."] = true
L["Belan shi."] = true
L["Tenebron, Vesperon, and Shadron."] = true
L["Nobundo."] = true
L["Nordrassil."] = true
L["Norgannon."] = true
L["Toothgnasher."] = true
L["Blue dragonflight."] = true
L["Sky'ree."] = true
L["Defective elekk turd."] = true
L["Cenarion Circle."] = true
L["Gelbin Mekkatorque."] = true
L["Tainted grain."] = true
L["Mord'rethar."] = true
L["Teron Gorefiend."] = true
L["K'aresh."] = true
L["Sharp claw."] = true
L["Frostwolf clan."] = true
L["Acherus."] = true
L["Talak."] = true
L["Queen Mia Greymane."] = true
L["Tatai."] = true
L["Veranus."] = true
L["Giles."] = true
L["Sayaad."] = true
L["Mag'har."] = true
L["Holia Sunshield."] = true
L["Mueh'zala."] = true
L["Coilfang Reservoir."] = true
L["Calissa Harrington."] = true
L["Xavius."] = true
L["Tiffin Ellerian Wrynn."] = true
L["Mirador."] = true
L["Mur'ghouls."] = true
L["Draka's Fury."] = true
