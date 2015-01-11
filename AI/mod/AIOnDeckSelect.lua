-- Functions to check which deck the AI is playing

DECK_SOMETHING    = 0
DECK_CHAOSDRAGON  = 1
DECK_FIREFIST     = 2
DECK_HERALDIC     = 3
DECK_GADGET       = 4
DECK_BUJIN        = 5
DECK_MERMAIL      = 6
DECK_SHADOLL      = 7
DECK_TELLARKNIGHT = 8
DECK_HAT          = 9
DECK_QLIPHORT     = 10
DECK_NOBLEKNIGHT  = 11
DECK_NECLOTH      = 12
DECK_BA           = 13

DeckIdent={ --card that identifies the deck
[1]   = 99365553, -- Lightpulsar Dragon
[2]   = 01662004, -- Firefist Spirit
[3]   = 82293134, -- Heraldic Beast Leo
[4]   = 05556499, -- Machina Fortress
[5]   = 32339440, -- Bujin Yamato
[6]   = 21954587, -- Mermail Abyssmegalo
[7]   = 44394295, -- Shaddoll Fusion
[8]   = 75878039, -- Satellarknight Deneb
[9]   = 45803070, -- Traptrix Dionaea
[10]  = 65518099, -- Qliphort Tool
[11]  = 59057152, -- Noble Knight Medraut
[12]  = 14735698, -- Necloth Exomirror
[13]  = 36006208, -- Fire Lake of the Burning Abyss
}
Deck = nil
DeckName={
[0]   = "Not Supported",
[1]   = "Chaos Dragon",
[2]   = "Fire Fist",
[3]   = "Heraldic Beast", 
[4]   = "Gadget",
[5]   = "Bujin",
[6]   = "Mermail",
[7]   = "Shaddoll",
[8]   = "Satellarknight",
[9]   = "HAT",
[10]  = "Qliphort",
[11]  = "Noble Knight",
[12]  = "Necloth",
[13]  = "Burning Abyss",
}
function DeckCheck(opt)
  if Deck == nil then
    PrioritySetup()
    for i=1,#DeckIdent do
      if HasID(UseLists({AIDeck(),AIHand()}),DeckIdent[i],true) then
        Deck = i
        print("AI deck is "..DeckName[i])
      end
    end
  end
  if Deck == nil then
    Deck = DECK_SOMETHING
  end
  if opt then
    return Deck==opt
  else
    return Deck
  end
end

PRIO_TOHAND = 1
PRIO_TOFIELD = 3
PRIO_TOGRAVE = 5
PRIO_DISCARD,PRIO_TODECK,PRIO_EXTRA = 7,7,7
PRIO_BANISH = 9
-- priority lists for decks:
function PrioritySetup()
AddPriority({
-- Burning Abyss

[57143342] = {1,1,1,1,1,1,1,1,1,1,CirCond},      -- BA Cir
[73213494] = {1,1,1,1,1,1,1,1,1,1,CalcabCond},   -- BA Calcab
[47728740] = {1,1,1,1,1,1,1,1,1,1,AlichCond},    -- BA Alich
[20758643] = {1,1,1,1,1,1,1,1,1,1,GraffCond},    -- BA Graff
[10802915] = {1,1,1,1,1,1,1,1,1,1,TourGuideCond},-- Tour Guide
[84764038] = {1,1,1,1,1,1,1,1,1,1,ScarmCond},    -- BA Scarm
[00734714] = {1,1,1,1,1,1,1,1,1,1,RubicCond},    -- BA Rubic

[36006208] = {1,1,1,1,1,1,1,1,1,1,FireLakeCond}, -- BA Fire Lake
[63356631] = {1,1,1,1,1,1,1,1,1,1,PWWBCond},     -- PWWB
[71587526] = {1,1,1,1,1,1,1,1,1,1,KarmaCutCond}, -- Karma Cut

[00601193] = {1,1,1,1,1,1,1,1,1,1,VirgilCond},   -- BA Virgil
[72167543] = {1,1,1,1,1,1,1,1,1,1},              -- Downerd Magician
[81330115] = {1,1,1,1,1,1,1,1,1,1},              -- Acid Golem of Destruction
[31320433] = {1,1,1,1,1,1,1,1,1,1},              -- Nightmare Shark
[47805931] = {1,1,1,1,1,1,1,1,1,1},              -- Giga-Brillant
[75367227] = {1,1,1,1,1,1,1,1,1,1},              -- Ghostrick Alucard
[68836428] = {1,1,1,1,1,1,1,1,1,1},              -- Tri-Edge Levia
[52558805] = {1,1,1,1,1,1,1,1,1,1},              -- Temptempo the Percussion Djinn
[78156759] = {1,1,1,1,1,1,1,1,1,1},              -- Wind-Up Zenmaines
[83531441] = {1,1,1,1,1,1,1,1,1,1,DanteCond},    -- BA Dante
[16259549] = {1,1,1,1,1,1,1,1,1,1},              -- Fortune Tune
})
AddPriority({
-- Necloth: 

[90307777] = {6,3,1,1,1,1,1,1,1,1,ShritCond},         -- Shrit, Caster of Necloth
[99185129] = {12,2,3,1,1,1,1,1,2,1,ClausCond},        -- The Necloth of Clausolas
[89463537] = {8,1,7,1,1,1,1,1,6,1,UniCond},           -- The Necloth of Unicore
[26674724] = {9,3,4,1,1,1,1,1,3,1,BrioCond},          -- The Necloth of Brionac
[13700028] = {4,2,3,1,1,1,1,1,7,1,GungCond},          -- The Necloth of Gungnir
[52068432] = {7,2,6,1,1,1,1,1,5,1,TrishCond},         -- The Necloth of Trishula
[88240999] = {6,2,5,1,1,1,1,1,4,1,ArmorCond},         -- The Necloth of Decisive Armor
[08903700] = {3,1,1,1,9,1,1,1,1,1,nil},               -- Djinn Releaser of Rituals
[95492061] = {4,1,1,1,1,1,1,1,1,1,nil},               -- Manju of the Ten Thousand Hands
[23401839] = {5,1,1,1,1,1,1,1,1,1,nil},               -- Senju of the Thousand Hands
[13974207] = {3,1,1,1,1,1,1,1,1,1,nil},               -- Denkou Sekka

[96729612] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Preparation of Rites
[14735698] = {10,3,1,1,3,1,1,1,1,1,ExoCond},          -- Necloth Exomirror
[51124303] = {11,2,1,1,3,1,1,1,1,1,KaleidoCond},      -- Necloth Kaleidomirror

[35952884] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Shooting Quasar Dragon
[24696097] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Shooting Star Dragon
[79606837] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Herald of Rainbow Light
[15240268] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Mist Bird Clausolas
[95113856] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Phantom Fortress Enterblathnir
[44505297] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Inzektor Exa-Beetle
[08809344] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Outer God Nyarla
[31563350] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Zubaba General
})

AddPriority({
-- Noble Knight:
[95772051] = {4,0,9,2,9,2,1,1,1,1,BlackSallyCond},    -- Black Sally
[93085839] = {4,0,8,2,10,2,1,1,1,1,EachtarCond},      -- Eachtar
[19680539] = {4,2,2,1,4,2,3,2,4,2,GawaynCond},        -- Gawayn
[53550467] = {3,3,3,3,6,3,3,2,3,2,DrystanCond},       -- Drystan
[59057152] = {7,2,7,2,4,2,5,3,3,2,MedrautCond},       -- Medraut
[47120245] = {6,1,5,3,4,3,3,2,3,2,BorzCond},          -- Borz
[13391185] = {5,2,4,2,5,2,3,2,5,2,ChadCond},          -- Chad
[57690191] = {4,3,3,2,5,3,3,2,2,2,BrothersCond},      -- Brothers
[19748583] = {8,1,1,1,11,3,1,1,1,1,GwenCond},         -- Gwen
[10736540] = {6,0,1,1,12,3,1,1,1,1,LadyCond},         -- Lady

[92125819] = {1,0,2,1,8,1,3,2,3,1,ArtorigusCond},     -- Artorigus
[73359475] = {3,3,3,3,7,3,3,2,3,2,PeredurCond},       -- Peredur
[03580032] = {9,2,4,2,3,2,1,1,1,1,nil},               -- Merlin
[30575681] = {5,2,6,2,3,2,3,2,3,1,BedwyrCond},        -- Bedwyr

[66970385] = {8,5,1,1,1,1,9,1,1,1,nil},               -- Chapter
[07452945] = {7,1,7,1,4,1,2,1,1,1,RequipArmsCond},    -- Destiny
[14745409] = {4,1,4,1,5,1,2,1,1,1,RequipArmsCond},    -- Gallatin
[23562407] = {6,1,6,1,7,1,2,1,1,1,RequipArmsCond},    -- Caliburn
[46008667] = {5,2,5,1,5,1,1,1,1,1,ExcaliburnCond},    -- Excaliburn
[83438826] = {3,1,3,1,6,2,3,1,1,1,ArfCond},           -- Arfeudutyr
[55742055] = {9,2,1,1,1,1,7,1,1,1,TableCond},         -- Table
[92512625] = {4,1,1,1,1,1,1,1,1,1,nil},               -- Advice

[48009503] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Gandiva
[82944432] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Blade Armor Ninja
[60645181] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Excalibur
[21223277] = {1,1,1,1,1,1,5,1,3,1,nil},               -- R4torigus
[10613952] = {1,1,1,1,3,1,6,1,3,1,R5torigusCond},     -- R5torigus
[83519853] = {1,1,8,1,1,1,1,1,1,1,nil},               -- High Sally
[68618157] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Amaterasu
[73289035] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Tsukuyomi
})

AddPriority({
--Qliphort:
[65518099] = {9,4,1,1,5,1,7,5,1,1,ToolCond},          -- Qliphort Tool
[27279764] = {7,2,1,1,1,1,1,1,1,1,KillerCond},        -- Apoqliphort Killer
[90885155] = {6,2,4,2,2,1,3,1,1,1,ShellCond},         -- Qliphort Shell
[64496451] = {7,2,4,2,2,1,4,1,1,1,DiskCond},          -- Qliphort Disk
[37991342] = {5,3,7,4,8,4,1,1,1,1,GenomeCond},        -- Qliphort Genome
[91907707] = {5,3,6,3,9,4,2,1,1,1,ArchiveCond},       -- Qliphort Archive
[16178681] = {7,2,1,1,1,1,1,1,1,1,OddEyesCond},       -- Odd-Eyes Pendulum Dragon
[43241495] = {5,1,1,1,1,1,1,1,1,1,LynxCond},          -- Performapal Trampolynx

[79816536] = {9,4,1,1,1,1,1,1,1,1,SummonersCond},     -- Summoners Art
[17639150] = {8,2,1,1,1,1,1,1,1,1,SacrificeCond},     -- Qliphort Sacrifice
[04450854] = {5,2,1,1,1,1,1,1,1,1,ApoCond},           -- Apoqliphort
[05851097] = {2,1,1,1,1,1,1,1,1,1,nil},               -- Vanitys Emptiness
[82732705] = {2,1,1,1,1,1,1,1,1,1,nil},               -- Skill Drain
})

AddPriority({

--Chaos Dragons
[65192027] = {8,5,8,2,1,0,0,0,2,0,DADCond},           -- Dark Armed Dragon 
[72989439] = {9,5,6,3,1,0,0,0,2,0,BLSCond},           -- BLS Envoy
[88264978] = {9,5,7,0,2,0,0,0,0,0,REDMDCond},         -- REDMD
[98777036] = {2,1,0,0,4,0,0,0,8,0,nil},               -- Tragoedia
[09596126] = {8,4,6,3,1,0,0,0,3,0,SorcCond},          -- Chaos Sorcerer
[44330098] = {2,1,0,0,4,0,0,0,8,0,nil},               -- Gorz
[99365553] = {6,4,5,4,4,3,0,0,1,0,LightpulsarCond},   -- Lightpulsar Dragon
[25460258] = {5,3,4,3,5,3,0,0,1,0,DarkflareCond},     -- Darkflare Dragon
[61901281] = {6,3,6,2,6,2,0,0,8,3,CollapserpentCond}, -- Black Dragon Collapserpent
[99234526] = {6,3,6,2,6,2,0,0,8,3,WyverbusterCond},   -- Light Dragon Wyverbuster
[77558536] = {5,4,7,4,5,2,0,0,5,0,RaidenCond},        -- Lightsworn Raiden
[22624373] = {3,2,4,2,6,3,0,0,8,0,LylaCond},          -- Lightsworn Lyla
[95503687] = {4,3,8,3,4,3,0,0,7,0,LuminaCond},        -- Lightsworn Lumina
[16404809] = {3,2,4,2,6,3,0,0,8,0,KuribanditCond},    -- Kuribandit
[51858306] = {5,0,3,0,9,0,0,0,9,9,WyvernCond},        -- Eclipse Wyvern
[33420078] = {2,1,6,2,6,0,0,0,3,1,PSZCond},           -- Plaguespreader Zombie
--[10802915] = {5,2,3,2,2,1,0,0,8,3,TourGuideCond},     -- Tour Guide of the Underworld
--[84764038] = {4,2,8,3,8,2,0,0,5,2,ScarmCond},         -- Scarm, Malebranche of the Burning Abyss
[00691925] = {8,3,0,0,3,0,0,0,0,0,nil},               -- Solar Recharge
[94886282] = {7,2,0,0,1,0,0,0,0,0,nil},               -- Charge of the Light Brigade
[01475311] = {5,3,0,0,4,0,0,0,0,0,nil},               -- Allure of Darkness
[81439173] = {4,2,0,0,2,0,0,0,0,0,nil},               -- Foolish Burial

--[83531441] = {0,0,0,0,5,2,0,0,8,0,DanteCond},         -- BA Dante
[15914410] = {0,0,0,0,5,2,0,0,8,0,AngineerCond},      -- Mechquipped Angineer
[95992081] = {0,0,0,0,5,2,0,0,8,0,LeviairCond},       -- Leviair the Sea Dragon
[34086406] = {0,0,0,0,5,2,0,0,8,0,ChainCond},         -- Lavalval Chain
[48739166] = {0,0,0,0,5,2,0,0,8,0,SharkCond},         -- SHArk
[15561463] = {0,0,0,0,4,2,0,0,8,0,GauntletCond},      -- Gauntlet Launcher
[38495396] = {0,0,0,0,4,2,0,0,8,0,PtolemyCond},       -- Constellar Ptolemy M7
[07391448] = {0,0,0,0,2,0,0,0,8,0,nil},               -- Goyo Guardian
[04779823] = {0,0,8,0,2,0,0,0,5,0,nil},               -- Michael, Lightsworn Ark
[44508094] = {0,0,8,0,2,0,0,0,5,0,nil},               -- Stardust Dragon
[76774528] = {0,0,7,0,2,0,0,0,5,0,nil},               -- Scrap Dragon
[34408491] = {0,0,9,0,2,0,0,0,4,0,nil},               -- Beelze of the Diabolic Dragons
})
AddPriority({
-- Mermail
[21954587] = {6,4,5,3,4,1,5,1,1,1,MegaloCond},        -- Mermail Abyssmegalo
[22446869] = {7,3,4,2,2,1,1,1,1,1,TeusCond},          -- Mermail Abyssteus
[37781520] = {7,1,6,4,5,1,4,1,1,1,LeedCond},          -- Mermail Abyssleed
[58471134] = {4,2,8,2,2,1,1,1,1,1,PikeCond},          -- Mermail Abysspike
[22076135] = {4,2,7,2,2,1,1,1,1,1,TurgeCond},         -- Mermail Abyssturge
[69293721] = {7,5,0,0,0,0,7,0,0,0,GundeCond},         -- Mermail Abyssgunde
[23899727] = {5,2,3,2,1,1,1,1,1,1,LindeCond},         -- Mermail Abysslinde
[74298287] = {5,2,3,2,2,2,4,1,3,3,DineCond},          -- Mermail Abyssdine
[37104630] = {5,2,0,0,7,2,6,2,2,2,InfantryCond},      -- Atlantean Heavy Infantry
[00706925] = {4,2,5,1,7,2,6,2,2,2,MarksmanCond},      -- Atlantean Marksman
[74311226] = {7,5,2,1,8,4,6,4,1,1,nil},               -- Atlantean Dragoons
[26400609] = {6,3,4,2,6,4,5,4,0,0,TidalCond},         -- Tidal
[78868119] = {5,3,2,2,2,1,1,1,2,2,DivaCond},          -- Deep Sea Diva
[04904812] = {7,2,2,2,2,1,5,1,3,3,UndineCond},        -- Genex Undine
[68505803] = {2,1,2,2,3,1,4,1,5,5,ControllerCond},    -- Genex Controller

[60202749] = {3,3,1,1,1,1,1,1,1,1,nil},               -- Abyss-sphere
[34707034] = {4,2,1,1,1,1,1,1,1,1,SquallCond},        -- Abyss-squall
[37576645] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Reckless Greed

[74371660] = {1,1,1,1,1,1,1,1,5,1,nil},               --  Mermail Abyssgaios
[22110647] = {1,1,1,1,1,1,1,1,1,1,nil},               --  Mecha Phantom Beast Dracossack
[80117527] = {1,1,1,1,1,1,1,1,1,1,nil},               --  Number 11 -  Big Eye
[21044178] = {1,1,1,1,1,1,1,1,5,1,nil},               --  Abyss Dweller
[00440556] = {1,1,1,1,1,1,1,1,5,1,nil},               --  Bahamut Shark
[46772449] = {1,1,1,1,1,1,1,1,1,1,nil},               --  Evilswarm Exciton Knight
[12014404] = {1,1,1,1,1,1,1,1,1,1,nil},               --  Gagaga Cowboy
[59170782] = {1,1,4,3,1,1,1,1,5,1,TriteCond},         --  Mermail Abysstrite
[50789693] = {1,1,5,2,1,1,1,1,5,1,KappaCond},         --  Armored Kappa
[65749035] = {1,1,1,1,1,1,1,1,5,1,nil},               --  Gugnir, Dragon of  the Ice Barrier
[70583986] = {1,1,1,1,1,1,1,1,5,1,nil},               --  Dewloren Tiger King of the Ice Barrier
[88033975] = {1,1,1,1,1,1,1,1,1,1,nil},               --  Armades keeper of Illusions
})
AddPriority({
-- Shaddoll
[37445295] = {6,3,3,1,6,1,6,1,1,1,FalconCond},        -- Shadoll Falcon
[04939890] = {5,2,2,1,5,4,5,4,1,1,HedgehogCond},      -- Shadoll Hedgehog
[30328508] = {4,1,5,1,9,1,9,1,1,1,LizardCond},        -- Shadoll Lizard
[77723643] = {3,1,4,1,7,1,7,1,1,1,DragonCond},        -- Shadoll Dragon
[03717252] = {2,1,6,1,8,1,8,1,1,1,BeastCond},         -- Shadoll Beast
[24062258] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Secret Sect Druid Dru

[05318639] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Mystical Space Typhoon
[44394295] = {9,5,1,1,1,1,1,1,1,1,ShadollFusionCond}, -- Shadoll Fusion
[77505534] = {3,1,1,1,1,1,1,1,1,1,nil},               -- Facing the Shadows
[04904633] = {4,2,1,1,9,1,9,1,1,1,RootsCond},         -- Shadoll Roots


[20366274] = {1,1,6,4,2,1,2,1,1,1,NephilimCond},      -- El-Shadoll Nephilim
[94977269] = {1,1,7,3,2,1,2,1,1,1,MidrashCond},       -- El-Shadoll Midrash
[72959823] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Panzer Dragon
[73964868] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Constellar Pleiades
[29669359] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Number 61: Volcasaurus
[82633039] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Skyblaster Castel
[00581014] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Daigusto Emeral
[33698022] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Moonlight Rose Dragon
[31924889] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Arcanite Magician
[08561192] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Leoh, Keeper of the Sacred Tree
})

AddPriority({
-- Satellarknight
[75878039] = {8,1,5,4,8,5,4,2,1,1,DenebCond},         -- Satellarknight Deneb
[02273734] = {6,4,7,1,3,1,6,1,1,1,AltairCond},        -- Satellarknight Altair
[38667773] = {5,3,8,3,4,1,5,1,1,1,VegaCond},          -- Satellarknight Vega
[63274863] = {7,2,6,2,6,1,1,1,1,1,SiriusCond},        -- Satellarknight Sirius
[38331564] = {8,4,9,4,3,1,1,1,1,1,ScepterCond},       -- Star Seraph Scepter
[91110378] = {7,3,4,0,4,1,1,1,1,1,SovereignCond},     -- Star Seraph Sovereign
[37742478] = {6,4,5,0,1,1,1,1,1,1,HonestCond},        -- Honest

[32807846] = {9,3,1,1,1,1,1,1,1,1,nil},               -- RotA
[01845204] = {4,1,1,1,1,1,1,1,1,1,nil},               -- Instant Fusion
[54447022] = {5,1,1,1,1,1,1,1,1,1,SoulChargeCond},    -- Soul Charge
[25789292] = {3,1,1,1,1,1,1,1,1,1,nil},               -- Forbidden Chalice

[41510920] = {6,2,1,1,1,1,1,1,1,1,nil},               -- Celestial Factor
[34507039] = {3,1,1,1,1,1,1,1,1,1,nil},               -- Wiretap

[63504681] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Heroic Champion - Rhongomiant
[21501505] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Cairngorgon, Antiluminescent Knight
[93568288] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Number 80: Rhapsody in Berserk
[94380860] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Number 103: Ragnazero
[34076406] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Lavalval Chain
[42589641] = {1,1,1,1,6,2,8,1,1,1,nil},               -- Stellarknight Triveil
[56638325] = {1,1,1,1,8,8,7,1,1,1,nil},               -- Stellarknight Delteros
[17412721] = {1,1,6,1,1,1,1,1,1,1,NodenCond},         -- Elder God Noden
})
AddPriority({
-- HAT
[91812341] = {6,3,5,1,1,1,1,1,1,1,MyrmeleoCond},      -- Traptrix Myrmeleo
[45803070] = {7,4,4,1,1,1,1,1,1,1,DionaeaCond},       -- Traptrix Dionaea
[68535320] = {5,2,2,1,1,1,1,1,1,1,FireHandCond},      -- Fire Hand
[95929069] = {4,2,2,1,1,1,1,1,1,1,IceHandCond},       -- Ice Hand
[85103922] = {4,1,6,4,3,1,3,1,1,1,MoralltachCond},    -- Artifact Moralltach
[12697630] = {5,1,7,3,4,1,4,1,1,1,BeagalltachCond},   -- Artifact Beagalltach

[14087893] = {2,1,1,1,1,1,1,1,1,1,nil},               -- Book of Moon
[98645731] = {2,1,1,1,1,1,1,1,1,1,nil},               -- Pot of Duality
[29616929] = {2,1,1,1,1,1,1,1,1,1,nil},               -- Traptrix Trap Hole Nightmare
[53582587] = {2,1,1,1,1,1,1,1,1,1,nil},               -- Torrential Tribute
[29401950] = {3,1,1,1,1,1,1,1,1,1,nil},               -- Bottomless Trap Hole
[84749824] = {3,1,1,1,1,1,1,1,1,1,nil},               -- Solemn Warning
[94192409] = {2,1,1,1,1,1,1,1,1,1,nil},               -- Compulsory Evacuation Device
[12444060] = {5,1,1,1,1,1,1,1,1,1,SanctumCond},       -- Artifact Sanctum
[29223325] = {4,1,1,1,1,1,1,1,1,1,IgnitionCond},      -- Artifact Ignition
[97077563] = {3,1,1,1,1,1,1,1,1,1,COTHCond},          -- Call of the Haunted
[78474168] = {2,1,1,1,4,1,4,1,1,1,nil},               -- Breakthrough Skill

[91949988] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Gaia Dragon, the Thunder Charger
[91499077] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Gagaga Samurai
[63746411] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Giant Hand
})
AddPriority({
--for backwards compatibility
[05361647] = {1,1,1,1,9,1,1,1,1,1,nil},               -- Battlin' Boxer Glassjaw
[68144350] = {1,1,1,1,5,1,1,1,1,1,nil},               -- Battlin' Boxer Switchhitter
})
end

Prio = {}
function AddPriority(list)
  for i,v in pairs(list) do
    if Prio[i] then print("warning: duplicate priority entry for ID: "..i) end
    Prio[i]=v
  end
end
function GetPriority(card,loc)
  local id=card.id
  local checklist = nil
  local result = 0
  if loc == nil then
    loc = PRIO_TOHAND
  end
  checklist = Prio[id]
  if checklist then
    if checklist[11] and not(checklist[11](loc,card)) then
      loc = loc + 1
    end
    result = checklist[loc]
  end
  return result
end
function AssignPriority(cards,loc,filter,opt)
  local index = 0
  Multiple = nil
  for i=1,#cards do
    cards[i].index=i
    cards[i].prio=GetPriority(cards[i],loc)
    if filter then
      if opt then
        if not filter(cards[i],opt) then 
          cards[i].prio=-1
        end
      else
        if not filter(cards[i]) then 
          cards[i].prio=-1
        end
      end
    end
    if loc==PRIO_TOFIELD and cards[i].location==LOCATION_DECK then
      cards[i].prio=cards[i].prio+2
    end
    if loc==PRIO_TOFIELD and cards[i].location==LOCATION_EXTRA then
      cards[i].prio=cards[i].prio+5
    end
    if loc==PRIO_TOGRAVE and bit32.band(cards[i].location,LOCATION_ONFIELD)>0
    and cards[i].equip_count and cards[i].equip_count>0 and HasID(cards[i]:get_equipped_cards(),17639150,true) 
    then
      cards[i].prio=10
    end
    if loc==PRIO_TOHAND and bit32.band(cards[i].location,LOCATION_ONFIELD)>0 then
      cards[i].prio=-1
    end
    if cards[i].owner==2 then
      cards[i].prio=-1*cards[i].prio
    end
    SetMultiple(cards[i].id)
  end
end
function PriorityCheck(cards,loc,count,filter,opt)
  if count == nil then count = 1 end
  if loc==nil then loc=PRIO_TOHAND end
  if cards==nil or #cards<count then return -1 end
  AssignPriority(cards,loc,filter,opt)
  table.sort(cards,function(a,b) return a.prio>b.prio end)
  return cards[count].prio
end
function Add(cards,loc,count,filter,opt)
  local result={}
  if count==nil then count=1 end
  if loc==nil then loc=PRIO_TOHAND end
  local compare = function(a,b) return a.prio>b.prio end
  AssignPriority(cards,loc,filter,opt)
  table.sort(cards,compare)
  for i=1,#cards do
    --print(cards[i].id..", prio:"..cards[i].prio)
  end
  for i=1,count do
    result[i]=cards[i].index
  end
  if #result<count then 
    for i=#result+1,count do
      result[i]=i
    end
  end
  return result
end
