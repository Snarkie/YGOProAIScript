-- Functions to check which deck the AI is playing

GlobalDeck = nil
Decks={}
function NewDeck(name,identifier,startup)
  local deck={}
  deck.ID=#Decks+1
  deck.Name=name
  deck.Identifier=identifier 
  deck.Startup=startup
  Decks[deck.ID]=deck
  return deck
end

DECK_SOMETHING    = 0
DECK_CHAOSDRAGON  = NewDeck("Chaos Dragon"    ,99365553) -- Lightpulsar Dragon
DECK_FIREFIST     = NewDeck("Fire Fist"       ,01662004) -- Firefist Spirit
DECK_HERALDIC     = NewDeck("Heraldic Beast"  ,82293134) -- Heraldic Beast Leo
DECK_GADGET       = NewDeck("Gadget"          ,05556499) -- Machina Fortress
DECK_BUJIN        = NewDeck("Bujin"           ,32339440) -- Bujin Yamato
DECK_MERMAIL      = NewDeck("Mermail"         ,21954587) -- Mermail Abyssmegalo
DECK_SHADOLL      = NewDeck("Shaddoll"        ,44394295) -- Shaddoll Fusion
DECK_TELLARKNIGHT = NewDeck("Satellarknight"  ,75878039) -- Satellarknight Deneb
DECK_HAT          = NewDeck("HAT"             ,45803070) -- Traptrix Dionaea
DECK_QLIPHORT     = NewDeck("Qliphort"        ,65518099) -- Qliphort Tool
DECK_NOBLEKNIGHT  = NewDeck("Noble Knight"    ,59057152) -- Noble Knight Medraut
DECK_NEKROZ       = NewDeck("Nekroz"          ,14735698) -- Nekroz Exomirror
DECK_BA           = NewDeck("Burning Abyss"   ,36006208) -- Fire Lake of the Burning Abyss
DECK_EXODIA       = NewDeck("Exodia"          ,33396948) -- Exodia the Forbidden One
DECK_DARKWORLD    = NewDeck("Dark World"      ,34230233) -- DW Grapha
DECK_CONSTELLAR   = NewDeck("Constellar"      ,78358521) -- Constellar Sombre
DECK_BLACKWING    = NewDeck("Blackwing"       ,91351370) -- Black Whirlwind
DECK_HARPIE       = NewDeck("Harpie"          ,19337371) -- Hysteric Sign
DECK_HERO         = NewDeck("HERO"            ,50720316) -- Shadow Mist

function IdentifierCheck(deck)
  if deck == nil or deck.Identifier == nil then return false end
  local ident = deck.Identifier
  if type(ident)=="table" then
    result = 0
    for i=1,#ident do
      local id = ident[i]
      if HasID(AIAll(),id,true) then
        result = result+1
      end
    end
    if result>=#ident then
      return true
    end
  else
    if HasID(AIAll(),ident,true) then
      return true
    end
  end
  return false
end
function DeckCheck(opt)
  if GlobalDeck == nil then
    for i=1,#Decks do
      local d = Decks[i]
      if IdentifierCheck(d) then
        GlobalDeck = i
      end
    end
    if GlobalDeck == nil then
      GlobalDeck = DECK_SOMETHING
      --print("AI deck is something else")
    else 
      print("AI deck is "..Decks[GlobalDeck].Name)
    end
    DeckSetup()
  end
  if opt then
    if type(opt) == "table" then
      return GlobalDeck==opt.ID
    end
    return GlobalDeck==opt
  else
    return GetDeck()
  end
end


function GetDeck()
  if GlobalDeck == 0 then
    return nil
  end
  return Decks[GlobalDeck]
end

function DeckSetup()
  local deck = GetDeck()
  if deck then
    if deck.Startup then
      deck.Startup(deck)
    end
    BlacklistSetup(deck)
  end
  PrioritySetup()
end

PRIO_TOHAND = 1
PRIO_TOFIELD = 3
PRIO_TOGRAVE = 5
PRIO_DISCARD,PRIO_TODECK,PRIO_EXTRA = 7,7,7
PRIO_BANISH = 9
-- priority lists for decks:
function PrioritySetup()

  DarkWorldPriority()
  ConstellarPriority()
  BlackwingPriority()
  HarpiePriority()
  MermailPriority()
  ChaosDragonPriority()
  QliphortPriority()
  SatellarknightPriority()
  HEROPriority()
  
AddPriority({
-- test
[89631139] = {1,1,1,1,1,1,1,1,1,1,nil},         -- BEWD

-- Burning Abyss
[57143342] = {7,2,7,3,7,1,1,1,2,1,CirCond},      -- BA Cir
[73213494] = {3,2,3,1,3,3,1,1,6,1,CalcabCond},   -- BA Calcab
[47728740] = {2,2,3,1,3,3,1,1,6,1,AlichCond},    -- BA Alich
[20758643] = {6,2,8,2,8,2,1,1,5,1,GraffCond},    -- BA Graff
[10802915] = {8,2,3,2,2,1,4,1,8,3,TourGuideCond},-- Tour Guide
[84764038] = {5,2,5,4,5,2,6,1,4,2,ScarmCond},    -- BA Scarm
[00734741] = {4,2,6,3,3,3,1,1,6,1,RubicCond},    -- BA Rubic
[36553319] = {4,2,4,1,4,3,1,1,6,1,FarfaCond},    -- BA Farfa
[09342162] = {3,2,6,1,6,3,1,1,6,1,CagnaCond},    -- BA Cagna
[62957424] = {3,2,3,1,3,3,1,1,6,1,LibicCond},    -- BA Libic
[00005497] = {8,2,1,1,2,2,1,1,5,1,MalacodaCond}, -- BA Malacoda

[73680966] = {5,1,1,1,1,1,1,1,1,1,TBOTECond},    -- The Beginning of the End
[62835876] = {9,1,1,1,5,1,1,1,1,1,GECond},       -- BA Good&Evil
[36006208] = {8,2,1,1,4,1,1,1,1,1,FireLakeCond}, -- BA Fire Lake
[63356631] = {1,1,1,1,1,1,1,1,1,1,PWWBCond},     -- PWWB
[71587526] = {1,1,1,1,1,1,1,1,1,1,KarmaCutCond}, -- Karma Cut

[00601193] = {1,1,10,1,1,1,1,1,1,1,VirgilCond},   -- BA Virgil
[72167543] = {1,1,1,1,1,1,1,1,1,1},              -- Downerd Magician
[81330115] = {1,1,1,1,1,1,1,1,1,1},              -- Acid Golem of Destruction
[31320433] = {1,1,1,1,1,1,1,1,1,1},              -- Nightmare Shark
[47805931] = {1,1,1,1,1,1,1,1,1,1},              -- Giga-Brillant
[75367227] = {1,1,1,1,1,1,1,1,1,1},              -- Ghostrick Alucard
[68836428] = {1,1,1,1,1,1,1,1,1,1},              -- Tri-Edge Levia
[52558805] = {1,1,1,1,1,1,1,1,1,1},              -- Temptempo the Percussion Djinn
[78156759] = {1,1,1,1,1,1,1,1,1,1},              -- Wind-Up Zenmaines
[83531441] = {1,1,9,1,5,2,1,1,5,1,DanteCond},    -- BA Dante
[16259549] = {1,1,1,1,1,1,1,1,1,1},              -- Fortune Tune
[26563200] = {1,1,1,1,1,1,1,1,1,1},              -- Muzurythm the String Djinn
})
AddPriority({
-- Nekroz: 

[90307777] = {6,3,1,1,1,1,1,1,1,1,ShritCond},         -- Shrit, Caster of Nekroz
[52738610] = {3,2,1,1,7,1,1,1,8,1,PrincessCond},      -- Nekroz Dance Princess

[25857246] = {6,2,3,1,3,1,1,1,3,1,ValkCond},          -- The Nekroz of Valkyrus
[99185129] = {12,2,4,1,5,1,1,1,2,1,ClausCond},        -- The Nekroz of Clausolas
[89463537] = {8,1,7,1,4,1,1,1,6,1,UniCond},           -- The Nekroz of Unicore
[26674724] = {9,3,4,1,4,1,1,1,4,1,BrioCond},          -- The Nekroz of Brionac
[74122412] = {4,2,3,1,4,1,1,1,7,1,GungCond},          -- The Nekroz of Gungnir
[52068432] = {7,2,6,1,3,1,1,1,5,1,TrishCond},         -- The Nekroz of Trishula
[88240999] = {5,2,5,1,1,1,1,1,3,1,ArmorCond},         -- The Nekroz of Decisive Armor
[08903700] = {3,1,1,1,9,2,1,1,1,1,ReleaserCond},      -- Djinn Releaser of Rituals
[95492061] = {10,1,1,1,5,1,1,1,1,1,ManjuCond},        -- Manju of the Ten Thousand Hands
[23401839] = {9,1,1,1,6,1,1,1,1,1,SenjuCond},         -- Senju of the Thousand Hands
[13974207] = {3,1,1,1,6,1,1,1,1,1,SekkaCond},         -- Denkou Sekka
[30312361] = {2,1,1,1,7,1,1,1,1,1,nil},               -- Phantom of Chaos

[96729612] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Preparation of Rites
[14735698] = {10,3,1,1,3,1,1,1,1,1,ExoCond},          -- Nekroz Exomirror
[51124303] = {11,2,1,1,3,1,1,1,1,1,KaleidoCond},      -- Nekroz Kaleidomirror
[97211663] = {11,2,1,1,3,1,1,1,1,1,CycleCond},        -- Nekroz Cycle

[35952884] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Shooting Quasar Dragon
[24696097] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Shooting Star Dragon
[79606837] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Herald of Rainbow Light
[15240268] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Mist Bird Clausolas
[95113856] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Phantom Fortress Enterblathnir
[44505297] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Inzektor Exa-Beetle
[08809344] = {1,1,1,1,6,3,1,1,1,1,NyarlaCond},        -- Outer God Nyarla
[31563350] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Zubaba General
[86346643] = {1,1,1,1,5,1,1,1,1,1,nil},               -- Rainbow Neos
[63465535] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Underground Arachnid
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
[83519853] = {1,1,6,1,1,1,1,1,1,1,nil},               -- High Sally
[68618157] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Amaterasu
[73289035] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Tsukuyomi
})




AddPriority({
-- Shaddoll
[37445295] = {6,3,3,1,7,1,6,1,1,1,FalconCond},        -- Shadoll Falcon
[04939890] = {5,2,2,1,5,4,5,4,1,1,HedgehogCond},      -- Shadoll Hedgehog
[30328508] = {4,1,5,1,9,1,9,1,1,1,LizardCond},        -- Shadoll Lizard/Squamata
[77723643] = {3,1,4,1,7,1,7,1,1,1,DragonCond},        -- Shadoll Dragon
[03717252] = {2,1,6,1,5,1,8,1,1,1,BeastCond},         -- Shadoll Beast
[24062258] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Secret Sect Druid Dru
[73176465] = {1,1,1,1,6,5,1,1,1,1,FelisCond},         -- Lightsworn Felis
[41386308] = {1,1,1,1,1,1,1,1,1,1,MathCond},          -- Mathematician

[05318639] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Mystical Space Typhoon
[44394295] = {9,5,1,1,1,1,1,1,1,1,ShadollFusionCond}, -- Shadoll Fusion
[06417578] = {8,6,1,1,1,1,1,1,1,1,ElFusionCond},      -- El-Shadoll Fusion
[60226558] = {7,4,1,1,1,1,1,1,1,1,NephFusionCond},    -- Nepheshadoll Fusion
[77505534] = {3,1,1,1,1,1,1,1,1,1,nil},               -- Facing the Shadows
[04904633] = {4,2,1,1,9,1,9,1,1,1,RootsCond},         -- Shadoll Roots


[20366274] = {1,1,6,4,2,1,2,1,1,1,ConstructCond},     -- El-Shadoll Construct
[94977269] = {1,1,7,3,2,1,2,1,1,1,WindaCond},         -- El-Shadoll Winda
[74822425] = {1,1,1,1,1,1,1,1,1,1,ShekinagaCond},     -- El-Shadoll Shekinaga
[48424886] = {1,1,1,1,1,1,1,1,1,1,EgrystalCond},      -- El-Shadoll Egrystal
[82044279] = {1,1,1,1,1,1,1,1,1,1,ClearWingCond},     -- Clear Wing Synchro Dragon
[72959823] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Panzer Dragon
[29669359] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Number 61: Volcasaurus
[82633039] = {1,1,1,1,6,1,1,1,1,1,CastelCond},        -- Skyblaster Castel
[00581014] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Daigusto Emeral
[33698022] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Moonlight Rose Dragon
[31924889] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Arcanite Magician
[08561192] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Leoh, Keeper of the Sacred Tree
})


AddPriority({
-- HAT
[91812341] = {6,3,5,1,1,1,1,1,1,1,MyrmeleoCond},      -- Traptrix Myrmeleo
[45803070] = {7,4,4,1,1,1,1,1,1,1,DionaeaCond},       -- Traptrix Dionaea
[68535320] = {5,2,2,1,1,1,1,1,1,1,FireHandCond},      -- Fire Hand
[95929069] = {4,2,2,1,1,1,1,1,1,1,IceHandCond},       -- Ice Hand
[85103922] = {4,1,6,4,3,1,3,1,1,1,MoralltachCond},    -- Artifact Moralltach
[12697630] = {5,1,7,3,5,1,5,1,1,1,BeagalltachCond},   -- Artifact Beagalltach
[20292186] = {4,1,5,3,4,1,4,1,1,1,ScytheCond},        -- Artifact Scythe

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

[44519536] = {1,1,-1,-1,-1,-1,-1,-1,1,1,nil},
[08124921] = {1,1,-1,-1,-1,-1,-1,-1,1,1,nil},
[07902349] = {1,1,-1,-1,-1,-1,-1,-1,1,1,nil},         -- Exodia pieces
[70903634] = {1,1,-1,-1,-1,-1,-1,-1,1,1,nil},
[33396948] = {1,1,-1,-1,-1,-1,-1,-1,1,1,nil},

[05133471] = {1,1,1,1,4,1,1,1,1,1,nil},               -- Galaxy Cyclone
})

  local deck = GetDeck()
  if deck and deck.PriorityList then
    AddPriority(deck.PriorityList,true)
  end
  
end

Prio = {}
function AddPriority(list,override)
  for i,v in pairs(list) do
    if Prio[i] and not override then print("warning: duplicate priority entry for ID: "..i) end
    Prio[i]=v
  end
end
function GetPriority(card,loc)
  local id=card.id      
  if id == 76812113 then
    id=card.original_id
  end
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
    if checklist[11] and checklist[11](loc,card) 
    and type(checklist[11](loc,card))=="number"  
    then
      result = checklist[11](loc,card)
    end
  else
    --print("no priority defined for id: "..id..", defaulting to 0")
  end
  return result
end
function AssignPriority(cards,loc,filter,opt)
  local index = 0
  Multiple = nil
  for i=1,#cards do
    local c = cards[i]
    c.index=i
    c.prio=GetPriority(c,loc)
    if loc==PRIO_TOFIELD and c.location==LOCATION_DECK then
      c.prio=c.prio+2
    end
    if loc==PRIO_TOGRAVE and c.location==LOCATION_DECK then
      c.prio=c.prio+2
    end
    if loc==PRIO_TOFIELD and c.location==LOCATION_GRAVE then
      c.prio=c.prio+1
    end
    if loc==PRIO_TOFIELD and c.location==LOCATION_EXTRA then
      c.prio=c.prio+5
    end
    if loc==PRIO_TOGRAVE and bit32.band(c.location,LOCATION_ONFIELD)>0
    and c.equip_count and c.equip_count>0 and HasID(c:get_equipped_cards(),17639150,true) 
    then
      c.prio=10
    end
    if loc==PRIO_TOGRAVE and FilterLocation(c,LOCATION_ONFIELD)
    then
      if Negated(c) then 
        c.prio=c.prio+3
      end
      if FilterPosition(c,POS_DEFENCE)
      and c.turnid==Duel.GetTurnCount()
      and c.attack>c.defense
      then
        c.prio=c.prio+2
      end
      if FilterType(c,TYPE_XYZ)
      and c.xyz_material_count==0 
      then
        c.prio=c.prio+2
      end
    end
    if loc==PRIO_TOHAND and bit32.band(c.location,LOCATION_ONFIELD)>0 
    and not DeckCheck(DECK_HARPIE) -- temp
    then
      c.prio=-1
    end
    if c.owner==2 then
      c.prio=-1*c.prio
    end
    if not TargetCheck(c) then
      c.prio=-1
    end
    if loc==PRIO_TOGRAVE and not MacroCheck() then
      c.prio=-1*c.prio
    end
    if not FilterCheck(c,filter,opt) then
      c.prio=c.prio-9999
    end
    SetMultiple(c.original_id)
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
  --print("priority list:")
  for i=1,#cards do
    --print(cards[i].original_id..", prio:"..cards[i].prio)
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
