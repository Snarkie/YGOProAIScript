-- Functions to check which deck the AI is playing

DECK_CHAOSDRAGON  = 1
DECK_FIREFIST     = 2
DECK_HERALDIC     = 3
DECK_GADGET       = 4
DECK_BUJIN        = 5
DECK_MERMAIL      = 6
DECK_SHADOLL      = 7
DECK_TELLARKNIGHT = 8

DeckIdent={ --card that identifies the deck
[1]=99365553, -- Lightpulsar Dragon
[2]=01662004, -- Firefist Spirit
[3]=82293134, -- Heraldic Beast Leo
[4]=05556499, -- Machina Fortress
[5]=32339440, -- Bujin Yamato
[6]=21954587, -- Mermail Abyssmegalo
[7]=44394295, -- Shaddoll Fusion
[8]=75878039, -- Satellarknight Deneb
}
Deck = nil
function DeckCheck(opt)
  if Deck == nil then
    PrioritySetup()
    for i=1,#DeckIdent do
      if HasID(UseLists({AIDeck(),AIHand()}),DeckIdent[i],true) then
        Deck = i
      end
    end
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
[51858306] = {5,3,3,2,9,0,0,0,9,9,WyvernCond},        -- Eclipse Wyvern
[33420078] = {2,1,6,2,6,0,0,0,3,1,PSZCond},           -- Plaguespreader Zombie
[10802915] = {5,2,3,2,2,1,0,0,8,3,TourGuideCond},     -- Tour Guide of the Underworld
[13700001] = {4,2,8,3,8,2,0,0,5,2,ScarmCond},         -- Scarm, Malebranche of the Burning Abyss
[00691925] = {8,3,0,0,3,0,0,0,0,0,nil},               -- Solar Recharge
[94886282] = {7,2,0,0,1,0,0,0,0,0,nil},               -- Charge of the Light Brigade
[01475311] = {5,3,0,0,4,0,0,0,0,0,nil},               -- Allure of Darkness
[81439173] = {4,2,0,0,2,0,0,0,0,0,nil},               -- Foolish Burial
[78474168] = {3,2,0,0,7,0,0,0,0,0,nil},               -- Breakthrough Skill

[13700002] = {0,0,0,0,5,2,0,0,8,0,DanteCond},         -- Dante, Traveler of the Burning Abyss
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
[21954587] = {6,3,5,3,4,1,5,1,1,1,MegaloCond},        -- Mermail Abyssmegalo
[22446869] = {7,3,4,2,2,1,1,1,1,1,TeusCond},           -- Mermail Abyssteus
[37781520] = {7,1,6,4,5,1,3,1,1,1,LeedCond},          -- Mermail Abyssleed
[58471134] = {4,2,8,2,2,1,1,1,1,1,PikeCond},          -- Mermail Abysspike
[22076135] = {4,2,7,2,2,1,1,1,1,1,TurgeCond},         -- Mermail Abyssturge
[69293721] = {7,5,0,0,0,0,7,0,0,0,GundeCond},         -- Mermail Abyssgunde
[23899727] = {5,2,3,2,1,1,1,1,1,1,LindeCond},         -- Mermail Abysslinde
[74298287] = {5,2,3,2,2,2,3,1,3,3,DineCond},          -- Mermail Abyssdine
[37104630] = {5,2,0,0,7,2,6,2,2,2,InfantryCond},      -- Atlantean Heavy Infantry
[00706925] = {4,2,5,1,7,2,6,2,2,2,MarksmanCond},      -- Atlantean Marksman
[74311226] = {7,5,2,1,8,4,6,4,1,1,nil},               -- Atlantean Dragoons
[26400609] = {6,3,4,2,6,4,5,4,0,0,TidalCond},         -- Tidal
[78868119] = {5,4,2,2,2,1,1,1,2,2,DivaCond},          -- Deep Sea Diva
[04904812] = {7,4,2,2,2,1,1,1,3,3,UndineCond},        -- Genex Undine
[68505803] = {2,1,2,2,3,1,3,1,5,5,ControllerCond},    -- Genex Controller

[60202749] = {3,3,1,1,1,1,1,1,1,1,nil},               -- Abyss-sphere
[34707034] = {4,2,1,1,1,1,1,1,1,1,SquallCond},        -- Abyss-squall
[37576645] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Reckless Greed
[84749824] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Solemn Warning
[29401950] = {1,1,1,1,1,1,1,1,1,1,nil},               -- Bottomless Trap Hole

[74371660] = {1,1,1,1,1,1,1,1,5,1,nil},               --  Mermail Abyssgaios
[22110647] = {1,1,1,1,1,1,1,1,1,1,nil},               --  Mecha Phantom Beast Dracossack
[80117527] = {1,1,1,1,1,1,1,1,1,1,nil},               --  Number 11 -  Big Eye
[21044178] = {1,1,1,1,1,1,1,1,5,1,nil},               --  Abyss Dweller
[00440556] = {1,1,1,1,1,1,1,1,5,1,nil},               --  Bahamut Shark
[46772449] = {1,1,1,1,1,1,1,1,1,1,nil},               --  Evilswarm Exciton Knight
[12014404] = {1,1,1,1,1,1,1,1,1,1,nil},               --  Gagaga Cowboy
[59170782] = {1,1,4,3,1,1,1,1,5,1,TriteCond},         --  Mermail Abysstrite
[15914410] = {1,1,1,1,1,1,1,1,1,1,nil},               --  Mechquipped Angineer
[95992081] = {1,1,1,1,1,1,1,1,5,1,nil},               --  Leviar the Sea Dragon
[50789693] = {1,1,5,2,1,1,1,1,5,1,KappaCond},         --  Armored Kappa
[65749035] = {1,1,1,1,1,1,1,1,5,1,nil},               --  Gugnir, Dragon of  the Ice Barrier
[70583986] = {1,1,1,1,1,1,1,1,5,1,nil},               --  Dewloren Tiger King of the Ice Barrier
[88033975] = {1,1,1,1,1,1,1,1,1,1,nil},               --  Armades keeper of Illusions
})
end



Prio = {}
function AddPriority(list)
  for i,v in pairs(list) do
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
    --if loc==PRIO_GRAVE and cards[i].location==LOCATION_ONFIELD then
      --cards[i].prio=cards[i].prio-1
    --end
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
  return result
end
