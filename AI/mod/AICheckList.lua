---------------------------------------
-- AICheckList.lua
--
-- A set of functions to determine if a
-- card is part of an archetype or list.
---------------------------------------

-----------------------------
-- Checks if the card's ID is
-- of a Tribute Exception monster.
-----------------------------
function IsTributeException(CardId)
  if CardId == 64631466 or CardId == 63519819 or -- Relinquished, Thousand-Eyes Restrict 
     CardId == 10000000 or CardId == 10000020 or -- Obelisk the Tormentor, Slifer the Sky Dragon
     CardId == 10000010 then	                 -- The Winged Dragon of Ra		 
    return 1
  end
  return 0
end

function Is3TributeMonster(CardId)
  if CardId == 10000000 or CardId == 10000020 or -- Obelisk the Tormentor, Slifer the Sky Dragon
     CardId == 10000010 then	                 -- The Winged Dragon of Ra		 
    return 1
  end
  return 0
end

function LegitDWMonster(CardId)
  if CardId == 34230233 or CardId == 32619583 or 
     CardId == 33731070 or CardId == 79126789 then	 
    return 1
  end
  return 0
end

function IsUndestroyableByBattle(CardId)
  if CardId == 31305911 then -- Marshmallon 
    return 1
  end
  return 0
end

---------------------------------------------------------
-- Some cards shouldn't be banished
---------------------------------------------------------
function BanishBlacklist(CardId)
  if CardId == 65192027 or CardId == 88264978 or -- Dark Armed Dragon, REDMD
     CardId == 34230233 or CardId == 72989439 or -- Grapha, Black Luster Soldier
     CardId == 38495396 or CardId == 01662004 then  -- Constellar Ptolemy M7, FireFist Spirit  
	return 1
  end
    return 0
end

---------------------------------------------------------
-- Cards that benefit from being banished
---------------------------------------------------------
function BanishWhitelist(CardId)
  if CardId == 42216237 or CardId == 51858306   -- Angel of Zera, Eclipse Wyvern
  then
    return 1
  end
    return 0
end

-----------------------------
-- Checks if the card's ID is
-- of a Nordic Tuner monster.
-----------------------------
function IsNordicTuner(CardId)
  if CardId == 41788781 or CardId == 73417207 or   -- Guldfaxe, Mara
     CardId == 77060848 or CardId == 40844552 or   -- Svartalf, Valkyrie
     CardId == 61777313 then                       -- Vanadis
    return 1
  end
  return 0
end

-----------------------------
-- Checks if the card's ID is
-- of a "Gladiator Beast" archetype monster.
-----------------------------
function IsGladiatorArchetype(CardId)
  local AIMons  = AI.GetAIMonsterZones()
  for i=1,#AIMons do
  if AIMons[i] ~= false then
  if AIMons[i].id == CardId then
  if CardId == 42592719 or CardId == 90582719 or   -- Gladiator Beast Alexander, Gladiator Beast Andal
     CardId == 41470137 or CardId == 25924653 or   -- Gladiator Beast Bestiari, Gladiator Beast Darius
     CardId == 31247589 or CardId == 57731460 or   -- Gladiator Beast Dimacari, Gladiator Beast Equeste
     CardId == 73285669 or CardId == 90957527 or   -- Gladiator Beast Essedarii, Gladiator Beast Gaiodiaz
     CardId == 48156348 or CardId == 27346636 or   -- Gladiator Beast Gyzarus, Gladiator Beast Heraklinos
     CardId == 04253484 or CardId == 02067935 or   -- Gladiator Beast Hoplomus, Gladiator Beast Lanista
     CardId == 78868776 or CardId == 05975022 or   -- Gladiator Beast Laquari, Gladiator Beast Murmillo
     CardId == 29590752 or CardId == 00612115 or   -- Gladiator Beast Octavius, Gladiator Beast Retiari
     CardId == 02619149 or CardId == 77642288 or   -- Gladiator Beast Samnite, Gladiator Beast Secutor
     CardId == 79580323 or CardId == 65984457 or   -- Gladiator Beast Spartacus, Gladiator Beast Torax
     CardId == 50893987 and                        -- Gladiator Beast Tygerius
     (AIMons[i].position == POS_FACEUP_ATTACK or AIMons[i].position == POS_FACEUP_DEFENCE) then
    return 1
     end
      end
    end
  end
  return 0
end

--------------------------------
-- Checks if the card's ID is of
-- a main deck Nordic monster.
--------------------------------
function IsNordicMonster(CardId)
  if IsNordicTuner(CardId) == 1 then
    return 1
  end
  if CardId == 13455953 or CardId == 88283496 or   -- Dverg, Garmr
     CardId == 40666140 or CardId == 76348260 or   -- Ljosalf, Mimir
     CardId == 15394083 or CardId == 14677495 or   -- Tanngrisnir,Tanngnjostr
     CardId == 02333365 then                       -- Tyr
    return 1
  end
  return 0
end


-------------------------------------------------------
-- Checks if the card's ID is a Dark World monster that
-- has an effect that activates when it is discarded
-- by an effect controlled by the AI.
-------------------------------------------------------
function IsDiscardEffDWMonster(CardId)
  if CardId == 33731070 or CardId == 79126789 or   -- Beiige, Broww
     CardId == 07623640 or CardId == 78004197 or   -- Ceruli, Goldd
     CardId == 34230233 or CardId == 51232472 or   -- Grapha, Gren
     CardId == 25847467 or CardId == 15667446 or   -- Kahkki, Latinum
     CardId == 32619583 or CardId == 60228941 then -- Sillva, Snoww
    return 1
  end
  return 0
end


--------------------------------
-- Checks if the card's ID is an
-- Elemental HERO monster.
--------------------------------
function IsEHeroMonster(CardId)
  if IsEHeroMainDeckMonster(CardId) == 1 or
     IsEHeroFusionMonster(CardId) == 1 then
    return 1
  end
  return 0
end


------------------------------------
-- Checks if the card's ID is a
-- main deck Elemental HERO monster.
------------------------------------
function IsEHeroMainDeckMonster(CardId)
  if CardId == 21844576 or CardId == 59793705 or   -- Avian, Bladedge
     CardId == 79979666 or CardId == 58932615 or   -- Bubbleman, Burstinatrix
     CardId == 80908502 or CardId == 84327329 or   -- Captain Gold, Clayman
     CardId == 69572169 or CardId == 98266377 or   -- Flash, Heat
     CardId == 41077745 or CardId == 62107981 or   -- Ice Edge, Knospe
     CardId == 95362816 or CardId == 89252153 or   -- Lady Heat, Necroshade
     CardId == 05285665 or CardId == 89943723 or   -- Neo Bubbleman, Neos
     CardId == 69884162 or CardId == 37195861 or   -- Neos Alius, Ocean
     CardId == 51085303 or CardId == 89312388 or   -- Poison Rose, Prisma
     CardId == 20721928 or CardId == 40044918 or   -- Sparkman, Stratos
     CardId == 09327502 or CardId == 86188410 or   -- Voltic, Wildheart
     CardId == 75434695 then                       -- Woodsman
    return 1
  end
  return 0
end

---------------------------------
-- Checks if the card's ID is an
-- Elemental HERO fusion monster.
---------------------------------
function IsEHeroFusionMonster(CardId)
  if CardId == 40854197 or CardId == 11502550 or   -- Absolute Zero, Air Neos
     CardId == 55171412 or CardId == 17032740 or   -- Aqua Neos, Chaos Neos
     CardId == 28677304 or CardId == 41517968 or   -- Dark Neos, Darkbright
     CardId == 31111109 or CardId == 29343734 or   -- Divine Neos, Electrum
     CardId == 33574806 or CardId == 35809262 or   -- Escuridao, Flame Wing
     CardId == 81566151 or CardId == 16304628 or   -- Flare Neos, Gaia
     CardId == 85507811 or CardId == 48996569 or   -- Glow Neos, Grand Neos
     CardId == 03642509 or CardId == 68745629 or   -- Great Tornado, Inferno
     CardId == 78512663 or CardId == 05128859 or   -- Magma Neos, Marine Neos
     CardId == 14225239 or CardId == 52031567 or   -- Mariner, Mudballman
     CardId == 81003500 or CardId == 72926163 or   -- Necroid Shaman, Neos K
     CardId == 01945387 or CardId == 41436536 or   -- Nova Master, Phoenix E
     CardId == 60493189 or CardId == 47737087 or   -- Plasma Vice, Rampart B
     CardId == 25366484 or CardId == 88820235 or   -- Sh.Flare, Sh.Phoenix
     CardId == 81197327 or CardId == 49352945 or   -- Steam Healer,Storm Neos
     CardId == 83121692 or CardId == 74711057 or   -- Tempest, Terra Firma
     CardId == 22061412 or CardId == 61204971 or   -- The Shining, Thunder G
     CardId == 13293158 or CardId == 55615891 or   -- Wild Cyclone, Wild Wing
     CardId == 10526791 then                       -- Wildedge
    return 1
  end
  return 0
end


-----------------------------
-- Checks if the card's ID is
-- a Synchron tuner monster.
-----------------------------
function IsSynchronTunerMonster(CardId)
  if CardId == 52840598 or CardId == 25652655 or   -- Bri, Changer
     CardId == 56286179 or CardId == 19642774 or   -- Drill, Fleur
     CardId == 50091196 or CardId == 40348946 or   -- Formula, Hyper
     CardId == 63977008 or CardId == 56897896 or   -- Junk, Mono
     CardId == 96182448 or CardId == 20932152 or   -- Nitro, Quickdraw
     CardId == 71971554 or CardId == 83295594 or   -- Road, Steam
     CardId == 67270095 or CardId == 15310033 then -- Turbo, Unknown
    return 1
  end
  return 0
end


--------------------------
-- Checks if the card's ID
-- is a Synchron monster.
--------------------------
function IsSynchronMonster(CardId)
  if IsSynchronTunerMonster(CardId) == 1 or
     CardId == 36643046 then                -- Synchron Explorer
    return 1
  end
  return 0
end


-----------------------------
-- Checks if the card's ID is
-- a Destiny HERO monster.
-----------------------------
function IsDHeroMonster(CardId)
  if CardId == 55461064  or CardId == 77608643 or    -- Blade M, Captain T
     CardId == 100000275 or CardId == 81866673 or    -- Celestial, Dasher
     CardId == 54749427  or CardId == 39829561 or    -- Defender, Departed
     CardId == 13093792  or CardId == 56570271 or    -- Diamond Dude, Disc
     CardId == 17132130  or CardId == 41613948 or    -- Dogma, Doom Lord
     CardId == 28355718  or CardId == 36625827 or    -- Double, Dread Serv
     CardId == 80744121  or CardId == 09411399 or    -- Fear Monger, Mali
     CardId == 83965310  or CardId == 100000274 then -- Plasma, The Dark A
    return 1
  end
  return 0
end

---------------------------------------------------------
-- Checks if the specified card ID is in this "blacklist"
-- of cards to never normal summon or set, and returns
-- True or False depending on if it's in the list.
---------------------------------------------------------
function NormalSummonBlacklist(CardId) 
  if CardId == 50933533 or CardId == 18964575 or   -- AGG Dragon, Scarecrow
     CardId == 19665973 or CardId == 98777036 or   -- Battle Fader, Trag
     CardId == 44330098 or CardId == 26400609 or   -- Gorz, Tidal
     CardId == 53804307 or CardId == 89399912 or   -- Blaster, Tempest
     CardId == 90411554 or CardId == 27415516 or   -- Redox, Stream
     CardId == 53797637 or CardId == 89185742 or   -- Burner, Lightning
     CardId == 91020571 or CardId == 33396948 or   -- Reactan, Exodia
     CardId == 07902349 or CardId == 70903634 or   -- Left Arm, Right Arm
     CardId == 44519536 or CardId == 08124921 or   -- Left Leg, Right Leg
     CardId == 70095154 or CardId == 88264978 or   -- CyDra, REDMD
     CardId == 83039729 or CardId == 63176202 or   -- Grandmaster, Shogun
     CardId == 74530899 or CardId == 37742478 or   -- Metaion, Honest
     CardId == 75498415 or CardId == 51945556 or   -- Sirocco, Zaborg the Thunder Monarch                      
     CardId == 40240595 or CardId == 40640057 or   -- Cocoon of Evolution, Kuriboh
     CardId == 57116033 or CardId == 00423585 or   -- Winged Kuriboh, Summoner Monk
     CardId == 74131780 or CardId == 91949988 or   -- Exiled Force, Gaia Dragon - the Thunder Charger
     CardId == 09748752 or CardId == 78364470 or   -- Caius the Shadow Monarch, Constellar Pollux    
     CardId == 45812361 or CardId == 37742478 or   -- Cardcar D, Honest
     CardId == 23434538 or CardId == 03534077 or   -- Maxx "C", Wolfbark
     CardId == 66762372 or CardId == 92572371 or   -- Boar, Buffalo
     CardId == 43748308 or CardId == 39699564 or   -- Dragon, Leopard
     CardId == 01662004 or CardId == 06353603 or   -- Spirit, Bear
     CardId == 70355994 or CardId == 17475251 or   -- Gorilla, Hawk
     CardId == 44860890 or CardId == 93294869 or   -- Raven, Wolf
     CardId == 97268402 or CardId == 41269771 or   -- Effect Veiler, Constellar Algiedi
     CardId == 80344569 or CardId == 30929786 or   -- Neo-Spacian Grand Mole, FF Chicken
     CardId == 82293134 or CardId == 60316373 or   -- Heraldic Beasts: Leo, Aberconway
     CardId == 87255382 or CardId == 19310321 or   -- Amphisbaena, Twin Eagle
     CardId == 45705025 or CardId == 82315772 or   -- Unicorn, Eale
     CardId == 56921677 -- Basilisk
     then 
	return 1 
  end
  return 0
end

------------------------------------------------
-- Checks if the card ID is in this "whitelist"
-- of cards to always normal summon, and returns
-- True or False depending on the result.
------------------------------------------------
function NormalSummonWhitelist(CardId)
  if CardId == 88241506 or                          -- Blue-Eyed Maiden
     CardId == 03657444 or CardId == 93816465  then -- Cyber Valley, 0 Gardna
    return 1
  end
  return 0
end

---------------------------------------------------
-- Prefer monsters that benefit from being tributed
---------------------------------------------------
function TributeWhitelist(id)
  if id == 03300267 or id == 77901552 -- Hieratic Dragons of Su, Tefnuit,
  or id == 31516413 or id == 78033100 -- Eset, Gebeb
  then
    return 1
  end
  return 0
end

---------------------------------------------------------
-- Checks if the specified card ID is in this "blacklist"
-- of cards to never special summon, and returns
-- True or False depending on if it's in the list.
---------------------------------------------------------
function SpecialSummonBlacklist(CardId)
  for i=1,#SSBL do
    if SSBL[i]==CardId then
      return 1
    end
  end
  return 0
end

SSBL={
01710476,00598988,09433350, -- Sin End, Sin Bow, Sin Blue
36521459,55343236,95992081, -- Sin Dust, Sin Red, Leviair
80117527,34230233,33347467, -- No.11, Grapha, Ghost Ship
41269771,48579379,14536035, -- Constellar Algiedi, PU Great Moth, Dark Grepher
72989439,09596126,99365553, -- BLS, Chaos Sorcerer, Lightpulsar
98012938,58504745,96381979, -- Vulcan, Cardinal, Tiger King
74168099,37057743,88264978, -- Horse Prince, Lion Emperor, REDMD 
47387961,23649496,02407234, -- Number 8, Number 18, Number 69
11398059,22653490,34086406, -- King of the Feral Imps, Chidori, Lavalval Chain
12014404,46772449,48739166, -- Gagaga Cowboy, Evilswarm Exciton Knight, SHArk Knight
89856523,38495396,00001042, -- Kirin, Constellar Ptolemy M7, Ragna Zero
61344030,82315772 -- Starliege Paladynamo, Heraldic Beast Eale
}

---------------------------------------------------------
-- Checks if the specified card ID is in this "blacklist"
-- of cards to never set in the Spell&Trap zone
---------------------------------------------------------
function SetBlacklist(CardId)
  for i=1,#SSBL do
    if SetBL[i]==CardId then
      return 1
    end
  end
  return 0
end

SetBL={
  61314842,92365601,84220251 -- Advanced Heraldry Art, Rank-Up Magic - Limited Barian's Force, Heraldry Reborn
}
-----------------------------------------------------
-- Checks if the card's ID is in a list of spell/trap
-- cards that work well when multiple copies are
-- activated in the same chain.
-----------------------------------------------------
function MultiActivationOK(CardId)
  if CardId == 39526584 or CardId == 21466326 or   -- Gift Card, Blast Ruins
     CardId == 50470982 or CardId == 18807108 then -- The Paths of Destiny
    return 1
  end
  return 0
end

-----------------------------------------------------
-- List of cards that shouldn't be activated when Necrovalley is on field.
-----------------------------------------------------
function isUnactivableWithNecrovalley(CardId)
  if CardId == 83764718 or --Reborn
     CardId == 97077563 or --Call of the Haunted
     CardId == 67169062 or --Pot of Adarice
     CardId == 95503687 or --Lumina
     CardId == 74848038 or --Monster-Reinkarnation
     CardId == 61962135 or --Glourise Illusion
     CardId == 45906428 or --Miraclefusion
     CardId == 37412656 or --Hero Blast
     CardId == 13391185 or --Noble Knight Gwalchavad
     CardId == 14943837 or --Debris Dragon
     CardId == 30312361 or --Phantom of Chaos
     CardId == 13504844 or --Gottoms`Emercency Call
     CardId == 02204140 or --Book of Life
     CardId == 17259470 then -- Zombymaster
    return 1
  end
  return 0
end

-----------------------------------------------------
-- List of cards that shouldn't be activated in a same chain
-----------------------------------------------------
function isUnchainableTogether(CardId)
  if CardId == 44095762 or -- Mirror force
     CardId == 70342110 or -- Dimensional prison
     CardId == 56120475 or -- Sakuretsu armor
     CardId == 73964868 or -- Constellar Pleiades
	   CardId == 55713623 or -- Shrink
     CardId == 08698851 or -- D-Counter
     CardId == 21481146 or -- Radiant mirror force
     CardId == 62271284 or -- Justi-break
     CardId == 77754944 or -- Widespread Ruin
     CardId == 79178930 or -- Karakuri klock
     CardId == 89041555 or -- Blast held by a tribut
     CardId == 73178098 or -- Ego boost
     CardId == 10759529 or -- Kid guard
     CardId == 25642998 or -- Poseidon wave
     CardId == 29590905 or -- Super junior confrontation
     CardId == 43250041 or -- Draining shiled
     CardId == 43452193 or -- Mirror gate
     CardId == 57115864 or -- Lumenize 
     CardId == 60080151 or -- Memory of an Adversary
     CardId == 62279055 or -- Magic cylinder
     CardId == 75987257 or -- Butterflyoke
     CardId == 23171610 or -- Limiter removal
     CardId == 37390589 or -- Kunai with chain
     CardId == 01005587 or -- Void trap hole
     CardId == 04206964 or -- Trap hole
     CardId == 28654932 or -- Deep dark trap hole
     CardId == 94192409 or -- Compulsory Evacuation Device
	   CardId == 29401950 or -- Bottomless trap hole
     CardId == 62325062 or -- Adhesion trap hole
     CardId == 80723580 or -- Giant trap hole
     CardId == 99590524 or -- Treacherous trap hole
     CardId == 11593137 or -- Chaos trap hole
     CardId == 19230407 or -- Offerings to the doomed
     CardId == 33846209 or -- Gemini spark
     CardId == 04178474 or -- Raigeki-breaker
     CardId == 15083728 or -- House of adhesive tape
     CardId == 30127518 or -- Dark trap hole
     CardId == 39765115 or -- Splash capture
     CardId == 42578427 or -- Eatgaboon
     CardId == 46656406 or -- Mirror of oaths
     CardId == 58990631 or -- Automatic laser
     CardId == 72287557 or -- Chthonian Polymer
     CardId == 86871614 or -- Cloning
     CardId == 84749824 or -- Solem warning
     CardId == 37412656 or -- Hero blast
     CardId == 53582587 then -- Torrential tribute   
	return 1
  end
  return 0
end

----------------------------------------------------
-- Checks if the selected card searches the deck for
-- another card, simply by comparing it to a list of
-- often-used search cards. A work-in-progress, but
-- it gets the job done for now.
----------------------------------------------------
function CardIsASearchCard(CardId)
  local Result = 0
  if CardId == 73628505 or CardId == 32807846 or   -- Terraforming, ROTA
     CardId == 00213326 or CardId == 25377819 or   -- E-Call, Convocation
     CardId == 54031490 or CardId == 94886282 or   -- SSS, Charge
     CardId == 96363153 or CardId == 57103969 or   -- Tuning, FF Tenki
     CardId == 74968065 or CardId == 12171659 or   -- Hecatrice, Zeradias
     CardId == 17393207 or CardId == 51435705 or   -- Commandant, Skull
     CardId == 75064463 or CardId == 48675364 or   -- Harpie Q, ArchF Gen
     CardId == 03431737 or CardId == 43797906 or   -- Assault B, Atlantis
     CardId == 89739383 or CardId == 89997728 then -- Secrets, Toon Table
    Result = 1
  end
  return Result
end

------------------------------------
-- Checks if every card in the index
-- is that of a specified archetype.
------------------------------------
function AllCardsArchetype(Cards,SetCode)
  for i=1,#Cards do
    if Cards[i] ~= false then
      if Cards[i].setcode ~= SetCode then
        return 0
      end
    end
  end
  return 1
end

----------------------------------------------------
-- Checks if the selected card is already scripted 
-- in "OnSelectInitCommand" or "SelectChain" functions.
----------------------------------------------------
function CardIsScripted(CardId)
  if CardId == 27970830 or CardId == 54031490 or  -- Gateway of the Six, Shien's Smoke Signal
     CardId == 15259703 or CardId == 79875176 or  -- Toon World, Toon Cannon Soldier 
     CardId == 58775978 or CardId == 82878489 or  -- Nightmare's Steelcage, Shine Palace
     CardId == 41426869 or CardId == 14536035 or  -- Black Illusion Ritual, Dark Grepher
     CardId == 33420078 or CardId == 09411399 or  -- Plaguespreader Zombie, Destiny Hero - Malicious
     CardId == 65192027 or CardId == 15561463 or  -- Dark Armed Dragon, Gauntlet Launcher
     CardId == 06353603 or CardId == 73964868 or  -- Brotherhood of the Fire Fist - Bear, Constellar Pleiades
     CardId == 38495396 or CardId == 44635489 or  -- Constellar Ptolemy M7, Constellar Siat
     CardId == 70908596 or CardId == 41142615 or  -- Constellar Kaust, The Cheerful Coffin
     CardId == 68597372 or CardId == 47217354 or  -- Wind-Up Zenmaister, Fabled Raven
     CardId == 74131780 or CardId == 36916401 or  -- Exiled Force, Burnin' Boxin' Spirit
     CardId == 12014404 or CardId == 34086406 or  -- Gagaga Gunman, Lavalval Chain
     CardId == 00423585 or CardId == 40640057 or  -- Summoner Monk, Kuriboh
     CardId == 95727991 or CardId == 71413901 or  -- Catapult Turtle, Breaker the Magical Warrior
     CardId == 83133491 or CardId == 18807108 or  -- Zero Gravity, Spellbinding Circle
     CardId == 87880531 or CardId == 72302403 or  -- Diffusion Wave-Motion, Swords of Revealing Light
     CardId == 83746708 or CardId == 25774450 or  -- Mage Power, Mystic Box
     CardId == 78156759 or CardId == 72892473 or  -- Wind-Up Zenmaines, Number 61: Volcasaurus		   
     CardId == 72892473 or CardId == 72892473 or  -- Tiras, Keeper of Genesis, Card Destruction		   
     CardId == 22110647 or CardId == 16435215 or  -- Mecha Phantom Beast Dracossack, Dragged Down into the Grave		   
     CardId == 93554166 or CardId == 74117290 or  -- Dark World Lightning, Dark World Dealings		   
     CardId == 81439173 or CardId == 40240595 or  -- Foolish Burial, Cocoon of Evolution		    		   
     CardId == 72989439 or CardId == 23265313 or  -- Black Luster Soldier - Envoy of the Beginning, Cost Down		   
     CardId == 68005187 or CardId == 98045062 or  -- Soul Exchange, Enemy Controller		   
     CardId == 43973174 or CardId == 22046459 or  -- The Flute of Summoning Dragon, Megamorph		   
     CardId == 55713623 or CardId == 05758500 or  -- Shrink, Soul Release		   
     CardId == 70231910 or CardId == 59385322 or  -- Dark Core, Core Blaster 		   
     CardId == 46910446 or CardId == 12607053 or  -- Chthonian Alliance, Waboku		   
     CardId == 27174286 or CardId == 94192409 or  -- Return from the Different Dimension, Compulsory Evacuation Device  		   
     CardId == 46009906 or CardId == 91595718 or  -- Beast Fangs, Book of Secret Arts           
     CardId == 53610653 or CardId == 69243953 or  -- Bound Wand, Butterfly Dagger - Elma          
     CardId == 19596712 or CardId == 72932673 or  -- Abyss-scale of Cetus, Abyss-scale of the Mizuchi         
     CardId == 08719957 or CardId == 86198326 or  -- Abyss-scale of the Kraken, 7 Completed         
     CardId == 63851864 or CardId == 88190790 or  -- Break! Draw!, Assault Armor         
     CardId == 79965360 or CardId == 84740193 or  -- Amazoness Heirloom, Buster Rancher         
     CardId == 40830387 or CardId == 37457534 or  -- Ancient Gear Fist, Ancient Gear Tank             
     CardId == 00303660 or CardId == 53586134 or  -- Amplifier, Bubble Blaster           
     CardId == 05183693 or CardId == 90374791 or  -- Amulet of Ambition, Armed Changer         
     CardId == 00242146 or CardId == 61127349 or  -- Ballista of Rampart Smashing, Big Bang Shot        
     CardId == 65169794 or CardId == 40619825 or  -- Black Pendant, Axe of Despair                
     CardId == 18937875 or CardId == 24668830 or  -- Burning Spear, Germ Infection          
     CardId == 50152549 or CardId == 41587307 or  -- Paralyzing Potion, Broken Bamboo Sword          
     CardId == 46967601 or CardId == 56948373 or  -- Cursed Bill, Mask of the accursed            
     CardId == 75560629 or CardId == 39897277 or  -- Flint, Elf's Light       
     CardId == 05318639 or CardId == 19613556 or  -- Mystical Space Typhoon, Heavy Storm          
     CardId == 53129443 or CardId == 07165085 or  -- Dark Hole, Bait Doll           
     CardId == 09596126 or CardId == 01475311 or  -- Chaos Sorcerer, Allure of darkness          
     CardId == 31036355 or CardId == 93816465 or  -- Swap, Zero Gardna        
     CardId == 04178474 or CardId == 16255442 or  -- Raigeki Break, Beckoning          
     CardId == 53567095 or CardId == 74848038 or  -- Icarus, Monster Reincarnation                 
     CardId == 95503687 or CardId == 22624373 or  -- Lumina, Lyla         
     CardId == 47387961 or CardId == 82732705 or  -- #8 Genome, Sin Truth         
     CardId == 37742478 or CardId == 94283662 or  -- Honest, Trance          
     CardId == 51452091 or CardId == 10026986 or  -- Royal Decree, Worm King         
     CardId == 55794644 or CardId == 500000090 or -- Hyperion, Toon Kingdom        
     CardId == 57774843 or CardId == 53582587 or  -- Judgment Dragon, Torrential Tribute
     CardId == 84013237 or CardId == 96216229 or  -- Number 39: Utopia, Gladiator Beast War Chariotthen
     CardId == 41420027 or CardId == 84749824 or  -- Solemn Judgment, Solemn Warning
     CardId == 44508094 or CardId == 58120309 or  -- Stardust Dragon, Starlight Road
     CardId == 61257789 or CardId == 35952884 or  -- Stardust Dragon/Assault Mode, Shooting Quasar Dragon
     CardId == 24696097 or CardId == 50091196 or  -- Shooting Star Dragon,Formula Synchron
     CardId == 50078509 or CardId == 14315573 or  -- Fiendish Chain, Negate Attack   
     CardId == 29267084 or CardId == 59616123 or  -- Shadow Spell, Trap Stun
     CardId == 44095762 or CardId == 67987611 or  -- Mirror Force, Amazoness Archers	 
     CardId == 39699564 or CardId == 30929786 or  -- FireFist Leopard, Chicken
     CardId == 70355994 or CardId == 10719350 or  -- FireFormation Tenken, FireFist Gorilla
     CardId == 44920699 or CardId == 70329348 or  -- FireFormation Tensen 
     CardId == 21350571 or CardId == 23434538 or  -- Horn of the Phantom Beast, Maxx "C"
     CardId == 96381979 or CardId == 19059929 or  -- FireFist Tiger King, FireFormation Gyokko
     CardId == 43748308 or CardId == 97268402 or  -- FireFist Dragon, Effect Veiler
     CardId == 92572371 or CardId == 78474168 or  -- FireFist Buffalo, Breakthrough Skill
     CardId == 58504745 or CardId == 36499284 or  -- FireFist Cardinal, FireFormation Yoko
     CardId == 77538567 or CardId == 70342110 or  -- Dark Bribe, Dimensional Prison 
     CardId == 46772449 or CardId == 58504745 or  -- Noblswarm Belzebuth, FireFist Cardinal                       
     CardId == 60316373 or CardId == 87255382 or  -- Heraldic Beasts: Aberconway, Amphisbaena
     CardId == 19310321 or CardId == 45705025 or  -- Twin Eagle, Unicorn
     CardId == 61314842 or CardId == 84220251 or  -- Advanced Heraldry Art, Heraldry Reborn
     CardId == 59048135 or CardId == 81439173 or  -- Heraldry Augmentation, Foolish Burial
     CardId == 47387961 or CardId == 23649496 or  -- Number 8: Heraldic King Genom-Heritage, Number 18: heraldic Progenitor Plain-Coat
     CardId == 38296564 or CardId == 92365601 or  -- Safe Zone, Rank-Up Magic: Limited Barian's Force       
     CardId == 27243130 or CardId == 94656263  -- Forbidden Lance, Kagetokage
     then  
	return 1
  end
  return 0
end

