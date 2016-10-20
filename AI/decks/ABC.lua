

function ABCStartup(deck)
  deck.Init                 = ABCInit
  deck.Card                 = ABCCard
  deck.Chain                = ABCChain
  deck.EffectYesNo          = ABCEffectYesNo
  deck.Position             = ABCPosition
  deck.YesNo                = ABCYesNo
  deck.BattleCommand        = ABCBattleCommand
  deck.AttackTarget         = ABCAttackTarget
  deck.AttackBoost          = ABCAttackBoost
  deck.Tribute              = ABCTribute
  deck.Option               = ABCOption
  deck.ChainOrder           = ABCChainOrder
  deck.Material             = ABCMaterial
  --[[
  deck.Sum 
  deck.DeclareCard
  deck.Number
  deck.Attribute
  deck.MonsterType
  ]]
  deck.ActivateBlacklist    = ABCActivateBlacklist
  deck.SummonBlacklist      = ABCSummonBlacklist
  deck.RepositionBlacklist  = ABCRepoBlacklist
  deck.SetBlacklist         = ABCSetBlacklist
  deck.Unchainable          = ABCUnchainable
  --[[
  
  ]]
  deck.PriorityList         = ABCPriorityList
  
  
end


ABCIdentifier = 01561110 -- ABC Dragon Buster

DECK_ABC = NewDeck("ABC",ABCIdentifier,ABCStartup) 

--[[
87979586, -- Angel Trumpeteer
46659709, -- Galaxy Soldier
30012506, -- A-Assault Core
55010259, -- Golden Gadget
77411244, -- B-Buster Drake
29021114, -- Silver Gadget
03405259,  -- C-Crush Wyvern
70271583, -- Karakuri Watchdog
66625883, -- Karakuri Strategist
81846636, -- Gem-Knight Lazuli

00911883, -- Unexpected Dai
05288597, -- Transmodify
73628505, -- Terraforming
43898403, -- Twin Twister
07394770, -- Brilliant Fusion
66399653, -- Union Hangar

05851097, -- Vanity
40605147, -- Strike
84749824, -- Warning

01561110, -- ABC Dragon Buster
03113836, -- Gem-Knight Seraphinite
74586817, -- Omega
66976526, -- Karakuri Bureido
23874409, -- Karakuri Burei
63767246, -- Titanic Galaxy
10443957, -- CyDra Infinity
56832966, -- Utopia Lightning
73964868, -- Pleiades
58069384, -- CyDra Nova
84013237, -- Utopia
28912357, -- Gear Giant X
82633039, -- Castel
]]
ABCActivateBlacklist={
46659709, -- Galaxy Soldier
30012506, -- A-Assault Core
55010259, -- Golden Gadget
77411244, -- B-Buster Drake
29021114, -- Silver Gadget
03405259,  -- C-Crush Wyvern
70271583, -- Karakuri Watchdog
66625883, -- Karakuri Strategist
81846636, -- Gem-Knight Lazuli

00911883, -- Unexpected Dai
05288597, -- Transmodify
07394770, -- Brilliant Fusion
66399653, -- Union Hangar

01561110, -- ABC Dragon Buster
74586817, -- Omega
66976526, -- Karakuri Bureido
23874409, -- Karakuri Burei
}
ABCSummonBlacklist={
87979586, -- Angel Trumpeteer
46659709, -- Galaxy Soldier
30012506, -- A-Assault Core
55010259, -- Golden Gadget
77411244, -- B-Buster Drake
29021114, -- Silver Gadget
03405259, -- C-Crush Wyvern
70271583, -- Karakuri Watchdog
66625883, -- Karakuri Strategist
81846636, -- Gem-Knight Lazuli

01561110, -- ABC Dragon Buster
03113836, -- Gem-Knight Seraphinite
66976526, -- Karakuri Bureido
23874409, -- Karakuri Burei

63767246, -- Titanic Galaxy
}
ABCSetBlacklist={
}
ABCRepoBlacklist={
}
ABCUnchainable={
01561110, -- ABC Dragon Buster
}

function KarakuriFilter(c,exclude)
  local check = true
  if exclude then
    if type(exclude)=="table" then
      check = not CardsEqual(c,exclude)
    elseif type(exclude)=="number" then
      check = (c.id ~= exclude)
    end
  end
  return FilterSet(c,0x11) and check
end


function ACond(loc,c)
  local prio = 1
  if loc == PRIO_TOHAND then
    return not HasAccess(c.id)
  end
  if loc == PRIO_TOFIELD then
    return not HasAccess(c.id)
  end
  if loc == PRIO_TOGRAVE then
    if FilterLocation(c,LOCATION_REMOVED)
    and CardsMatchingFilter(AIBanish(),FilterID,c.id)==1
    and HasIDNotNegated(AIMon(),01561110,true)
    then
      return 0
    end
    if not HasID(AIGrave(),c.id,true) then
      prio = 3
    end
    if not HasAccess(c.id) then
      prio = 5
    end
    if FilterLocation(c,LOCATION_ONFIELD) 
    and CardsMatchingFilter(AIGrave(),AFilter)>0
    then
      prio = prio + 2
    end
    return prio
  end
  if loc ==  PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end
function BCond(loc,c)
  local prio = 1
  if loc == PRIO_TOHAND then
    return not HasAccess(c.id)
  end
  if loc == PRIO_TOFIELD then
    return not HasAccess(c.id)
  end
  if loc == PRIO_TOGRAVE then
    if FilterLocation(c,LOCATION_REMOVED)
    and CardsMatchingFilter(AIBanish(),FilterID,c.id)==1
    and HasIDNotNegated(AIMon(),01561110,true)
    then
      return 0
    end
    if not HasID(AIGrave(),c.id,true) then
      prio = 2
    end
    if not HasAccess(c.id) then
      prio = 5
    end
    if FilterLocation(c,LOCATION_ONFIELD) 
    then
      prio = prio + 2
    end
    return prio
  end
  if loc ==  PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end
function CCond(loc,c)
  local prio = 1
  if loc == PRIO_TOHAND then
    return not HasAccess(c.id)
  end
  if loc == PRIO_TOFIELD then
    return not HasAccess(c.id)
  end
  if loc == PRIO_TOGRAVE then
    if FilterLocation(c,LOCATION_REMOVED)
    and CardsMatchingFilter(AIBanish(),FilterID,c.id)==1
    and HasIDNotNegated(AIMon(),01561110,true)
    then
      return 0
    end
    if not HasID(AIGrave(),c.id,true) then
      prio = 2
    end
    if not HasAccess(c.id) then
      prio = 5
    end
    if FilterLocation(c,LOCATION_ONFIELD) 
    and CardsMatchingFilter(AIHand(),AFilter)>0
    and DualityCheck()
    and SpaceCheck()>0
    then
      prio = prio + 2
    end
    return prio
  end
  if loc ==  PRIO_BANISH then
    return FilterLocation(c,LOCATION_GRAVE)
  end
  return true
end
function WatchdogCond(loc,c)
  if loc == PRIO_TOFIELD then
    if (FieldCheck(4) > 0 or ChainCheck(03405259,player_ai)) -- C
    and CardsMatchingFilter(AIMon(),FilterTuner,4)==0
    then
      return true
    end
  end
end
function StrategistCond(loc,c)
  if loc == PRIO_TOFIELD then
    if HasIDNotNegated(AIMon(),66976526,true,FilterOPT) -- Bureido
    then
      return true
    end
  end
end
function GoldGagdetCond(loc,c)
  if loc == PRIO_TOHAND then
    if not HasID(AIHand(),c.id,true) then
      if FilterLocation(c,LOCATION_GRAVE) then 
        return 6
      end
      return true
    end
    return false
  end
  if loc == PRIO_TOFIELD then
    if FilterLocation(c,LOCATION_HAND) then
      return OPTCheck(c.id) and CardsMatchingFilter(AIHand(),FilterRace,RACE_MACHINE)>1
    end
    return true
  end
end
function HangarCond(loc,c)
  if loc == PRIO_TOGRAVE then
    if FilterLocation(c,LOCATION_HAND)
    and CardsMatchingFilter(UseLists(AIST(),AIHand()),FilterID,c.id)>1
    then
      return true
    end
    return false
  end
  return true
end
function DaiFilter(c)
  return FilterType(c,TYPE_MONSTER)
  and FilterType(c,TYPE_NORMAL)
  and FilterLevelMax(c,4)
end
function DaiCond(loc,c)
  if loc == PRIO_TOGRAVE then
    if FilterLocation(c,LOCATION_HAND)
    and CardsMatchingFilter(AIDeck(),DaiFilter)==0
    then
      return true
    end
    return false
  end
  return true
end
function BrilliantFusionCond(loc,c)
  if loc == PRIO_TOGRAVE then
    if FilterLocation(c,LOCATION_HAND)
    and CardsMatchingFilter(AIDeck(),FilterSet,0x1047)==0 -- Gem-Knight
    then
      return true
    end
    return false
  end
  return true
end
ABCPriorityList={                      
--[12345678] = {1,1,1,1,1,1,1,1,1,1,XXXCond},  -- Format

-- ABC

[30012506] = {6,1,6,1,6,1,1,1,4,1,ACond}, -- A-Assault Core
[77411244] = {7,1,7,1,5,1,1,1,4,1,BCond}, -- B-Buster Drake
[03405259] = {8,1,8,1,5,1,1,1,4,1,CCond}, -- C-Crush Wyvern

[55010259] = {5,3,5,3,3,1,1,1,1,1,}, -- Golden Gadget
[29021114] = {4,2,4,2,3,1,1,1,1,1,}, -- Silver Gadget

[70271583] = {1,1,5,1,5,1,1,1,1,1,WatchdogCond}, -- Karakuri Watchdog
[66625883] = {1,1,4,1,5,1,1,1,1,1,StrategistCond}, -- Karakuri Strategist

[87979586] = {1,1,1,1,5,1,1,1,1,1,}, -- Angel Trumpeteer
[46659709] = {1,1,1,1,4,1,1,1,1,1,}, -- Galaxy Soldier

[81846636] = {1,1,1,1,9,1,1,1,1,1,}, -- Gem-Knight Lazuli

[00911883] = {1,1,1,1,8,1,1,1,1,1,DaiCond}, -- Unexpected Dai
[05288597] = {1,1,1,1,8,1,1,1,1,1,TransmodifyCond}, -- Transmodify
[07394770] = {1,1,1,1,8,1,1,1,1,1,BrilliantFusionCond}, -- Brilliant Fusion
[66399653] = {1,1,1,1,4,2,1,1,1,1,HangarCond}, -- Union Hangar

[01561110] = {1,1,1,1,1,1,1,1,1,1,}, -- ABC Dragon Buster
[03113836] = {1,1,1,1,1,1,1,1,1,1,}, -- Gem-Knight Seraphinite
[66976526] = {1,1,1,1,1,1,1,1,1,1,}, -- Karakuri Bureido
[23874409] = {1,1,1,1,1,1,1,1,1,1,}, -- Karakuri Burei

} 
ABCDragons={
30012506, -- A-Assault Core
77411244, -- B-Buster Drake
03405259, -- C-Crush Wyvern
}
function UseDai(c,mode)
  return true
end
function EnableABC(cards,count)
  -- checks, if the list has the remaining cards to allow ABC Buster to be summoned
  count = count or 1
  cards = cards or AIHand()
  local available = UseLists(AIField(),AIGrave())
  local result = 0
  local result2 = 0
  for i,id in pairs(ABCDragons) do
    if HasID(available,id,true) then 
      result = result + 1
    else
      if HasID(cards,id,true) then
        result2  = result2 + 1 
      end
    end
  end
  return result + result2 ==3 and result2==count
  and HasID(AIExtra(),01561110,true)
  and not HasID(AIMon(),01561110,true)
end
function UseBrilliantFusion(c,mode)
  if mode == 1
  and (FilterLocation(c,LOCATION_HAND)
  or FilterPosition(c,POS_FACEDOWN))
  then
    GlobalActivatedCardID = c.id
    return true
  end
end
function HangarFilter(c)
  return FilterAttribute(c,ATTRIBUTE_LIGHT)
  and FilterRace(c,RACE_MACHINE)
  and FilterType(c,TYPE_UNION)
end
function UseHangar(c,mode)
  if mode == 1
  and CardsMatchingFilter(AIST(),FilterType,TYPE_FIELD)==0
  then
    return true
  end
  if mode == 2
  and CardsMatchingFilter(AIDeck(),HangarFilter)>0
  then
    return true
  end
end
function SummonA(c,mode)
  if mode == 1 
  and CanXYZSummon()
  and NormalSummonsAvailable()>1
  and FieldCheck(4)==0
  and HandCheck(4)>1
  then
    return true
  end
  if mode == 2
  and CanXYZSummon()
  and FieldCheck(4)==1
  then
    return true
  end
  if mode == 3
  and HasIDNotNegated(UseLists(AIHand(),AIST()),05288597,true) -- Transmodify
  and CardsMatchingFilter(UseLists(AIHand(),AIDeck()),FilterID,46659709)>1 -- Galaxy Soldier
  and (CardsMatchingFilter(AIHand(),FilterAttribute,ATTRIBUTE_LIGHT)>1
  or c.id == 77411244 -- B
  or c.id == 30012506 and CardsMatchingFilter(AIGrave(),HangarFilter)>0) -- A
  then
    return true
  end
  if mode == 4
  and HasIDNotNegated(AIST(),66399653,true) -- Hangar
  then
    return true
  end
end
function UseA(c)
  if FilterLocation(c,LOCATION_SZONE)
  then
    return true
  end
  if FilterLocation(c,LOCATION_MZONE)
  then
    return false
  end
end
function SummonB(c,mode)
  return SummonA(c,mode)
end
function UseB(c)
  return UseA(c)
end
function SummonC(c,mode)
  if mode == 5 
  and CanXYZSummon()
  and FieldCheck(4,FilterTuner)==1
  and CardsMatchingFilter(AIHand(),HangarFilter)>1
  then
    return true
  end
  if mode == 6
  and HasIDNotNegated(UseLists(AIHand(),AIST()),05288597,true) -- Transmodify
  and CardsMatchingFilter(UseLists(AIHand(),AIDeck()),FilterID,46659709)>1 -- Galaxy Soldier
  and CardsMatchingFilter(AIHand(),FilterAttribute,ATTRIBUTE_LIGHT)>2
  and CardsMatchingFilter(AIHand(),HangarFilter)>1
  then
    return true
  end
  return SummonA(c,mode)
end
function UseC(c)
  return UseA(c)
end
function ABCMaterials(cards)
  cards = cards or UseLists(AIField(),AIGrave())
  if HasID(cards,30012506,true)   -- A
  and HasID(cards,77411244,true)  -- B
  and HasID(cards,03405259,true)  -- C
  then
    return true
  end
  return false
end
function SummonABC(c,mode)
  if mode == 1
  and ABCMaterials(AIGrave())
  then
    GlobalMaterial = true
    GlobalSSCardID = c.id
    return true
  end
  if mode == 2
  then
    GlobalMaterial = true
    GlobalSSCardID = c.id
    return true
  end
end
function ABCFilter(c)
  return Affected(c,TYPE_MONSTER,4)
  and Targetable(c,TYPE_MONSTER)
  and ShouldRemove(c)
end
function UseABC(c,mode)
  local targets = SubGroup(OppField(),ABCFilter)
  local prio = SubGroup(targets,FilterPriorityTarget)
  local discards = AIHand()
  if mode == 1
  and (#prio>0
  or #targets>0 
  and (PriorityCheck(discards)>4
  or #discards>3))
  then
    return true
  end
end
function GoldGadgetFilter(c)
  return FilterLevel(c,4) and FilterRace(c,RACE_MACHINE)
end
function SummonGoldGadget(c,mode)
  if mode == 1
  and CardsMatchingFilter(AIHand(),GoldGadgetFilter)>1
  and OPTCheck(c.id)
  and DualityCheck()
  then
    return true
  end
  if mode == 2
  and CanXYZSummon()
  and FieldCheck(4)==1
  then
    return true
  end
end
function SummonSilverGadget(c,mode)
  return SummonGoldGadget(c,mode)
end
function SummonBureido(c,mode)
  if mode == 1
  and (FieldCheck(4)>2
  or HasID(AIMon(),03405259,true) and CardsMatchingFilter(AIHand(),HangarFilter)>0)
  and CardsMatchingFilter(AIDeck(),FilterID,70271583)>0 -- Watchdog
  and CardsMatchingFilter(AIExtra(),FilterID,c.id)>0
  then
    return true
  end
  if mode == 2
  and CardsMatchingFilter(AIMon(),FilterID,c.id)>0
  then
    return true
  end
  if mode == 3
  and CardsMatchingFilter(AIDeck(),FilterID,66625883)>0 -- Strategist
  then
    return true
  end
end
function UseTransmodify(c,mode)
  if mode == 1
  and (HasID(AIMon(),77411244,true) -- B
  or HasID(AIMon(),30012506,true) and CardsMatchingFilter(AIGrave(),HangarFilter)>1 -- A
  or CardsMatchingFilter(AIHand(),FilterAttribute,ATTRIBUTE_LIGHT)>0)
  and CardsMatchingFilter(UseLists(AIHand(),AIDeck()),FilterID,46659709)>1 -- Galaxy Soldier
  then
    return true
  end
end
function UseGalaxySoldier(c,mode)
  if mode == 1
  and FieldCheck(5,FilterRace,RACE_MACHINE)==1
  then
    return true
  end
  if mode == 2
  and FilterOPT(c)
  and CardsMatchingFilter(AIHand(),FilterAttribute,ATTRIBUTE_LIGHT)>2
  then
    return true
  end
  if mode == 3
  and CardsMatchingFilter(AIMon(),FilterTuner,3)>0
  then
    return true
  end
  if mode == 4
  and EnableABC()
  then
    return true
  end
end
function SummonTrumpeteer(c,mode)
  if mode == 1
  and CanXYZSummon()
  and FieldCheck(4,FilterNonTuner)==1
  then
    return true
  end
  if mode == 2
  then
    return true
  end
end
function SummonWatchdog(c,mode)
  if mode == 1
  and CanXYZSummon()
  and FieldCheck(4,FilterNonTuner)==1
  then
    return true
  end
  if mode == 2
  and CanXYZSummon()
  and FieldCheck(4)==1
  then
    return true
  end
end
function SetB(c)
  return true
end
function SetC(c)
  return true
end
function MaterialFilter(c,level) 
  -- don't use Omega or ABC Buster as materials. TODO: unless they are crippled
  level = level or 4
  return FilterLevel(c,level)
  and ExcludeID(c,01561110) -- ABC Buster
  and ExcludeID(c,74586817) -- Omega
end
function SummonTitanicABC(c)
  local mats = SubGroup(AIMon(),MaterialFilter,8)
  return #mats>1
  and MP2Check()
end
function ABCInit(cards)
  local Act = cards.activatable_cards
  local Sum = cards.summonable_cards
  local SpSum = cards.spsummonable_cards
  local Rep = cards.repositionable_cards
  local SetMon = cards.monster_setable_cards
  local SetST = cards.st_setable_cards
  if HasID(SpSum,10443957,SummonInfinity) then
    return XYZSummon()
  end
  if HasID(SpSum,58069384,SummonNova) then
    return XYZSummon()
  end
  if HasID(Act,73628505) then -- Terraforming
    return Activate()
  end
  if HasID(Act,01561110,UseABC,1) then
    return Activate()
  end
  if HasID(Act,00911883,UseDai,1) then
    return Activate()
  end
  if HasID(Act,07394770,UseBrilliantFusion,1) then
    return Activate()
  end
  if HasID(Act,66399653,UseHangar,1) then
    return Activate()
  end
  if HasID(Act,66399653,UseHangar,2) then
    return Activate()
  end
  if HasID(Act,05288597,UseTransmodify,1) then
    return Activate()
  end
  if HasID(Sum,55010259,SummonGoldGadget,1) then
    return Summon()
  end
  if HasID(Sum,29021114,SummonSilverGadget,1) then
    return Summon()
  end
  if HasID(Sum,30012506,UseA,1) then
    return Summon()
  end
  if HasID(Sum,77411244,UseB,1) then
    return Summon()
  end
  if HasID(Sum,03405259,UseC,1) then
    return Summon()
  end
  if HasID(Sum,03405259,SummonC,5) then
    return Summon()
  end
  if HasID(Sum,30012506,SummonA,2) then
    return Summon()
  end
  if HasID(Sum,77411244,SummonB,2) then
    return Summon()
  end
  if HasID(Sum,03405259,SummonC,2) then
    return Summon()
  end
  if HasID(SpSum,66976526,SummonBureido,1) then
    return SynchroSummon()
  end
  if HasID(SpSum,66976526,SummonBureido,2) then
    return SynchroSummon()
  end
  if HasIDNotNegated(SpSum,74586817,SummonOmega,3) then
    return XYZSummon()
  end
  if HasID(SpSum,66976526,SummonBureido,3) then
    return SynchroSummon()
  end
  if HasIDNotNegated(SpSum,63767246,SummonTitanicABC) then
    return XYZSummon()
  end
  if HasID(Act,46659709,UseGalaxySoldier,2) then
    return Activate()
  end
  if HasID(Sum,03405259,SummonC,6) then
    return Summon()
  end
  if HasID(Sum,77411244,SummonB,1) then
    return Summon()
  end
  if HasID(Sum,30012506,SummonA,1) then
    return Summon()
  end
  if HasID(Sum,03405259,SummonC,1) then
    return Summon()
  end
  if HasID(Sum,87979586,SummonTrumpeteer,1) then
    return Summon()
  end
  if HasID(Sum,70271583,SummonWatchdog,1) then
    return Summon()
  end
  if HasID(Sum,30012506,SummonB,3) then
    return Summon()
  end
  if HasID(Sum,77411244,SummonA,3) then
    return Summon()
  end
  if HasID(Sum,03405259,SummonC,3) then
    return Summon()
  end
  if HasID(Sum,55010259,SummonGoldGadget,2) then
    return Summon()
  end
  if HasID(Sum,29021114,SummonSilverGadget,2) then
    return Summon()
  end
  if HasID(Sum,30012506,SummonA,4) then
    return Summon()
  end
  if HasID(Sum,77411244,SummonB,4) then
    return Summon()
  end
  if HasID(Sum,03405259,SummonC,4) then
    return Summon()
  end
  if HasIDNotNegated(Act,46659709,UseGalaxySoldier,1) then
    return Activate()
  end
  if HasID(Act,46659709,UseGalaxySoldier,3) then
    return Activate()
  end
  if HasID(SpSum,23874409,SummonBurei,1) then
    return SynchroSummon()
  end
  if HasID(SpSum,01561110,SummonABC,1) then
    return SpSummon()
  end
  if HasID(Sum,87979586,SummonTrumpeteer,2) then
    return Summon()
  end
  if HasID(Sum,30012506) then -- A
    return Summon()
  end
  if HasID(Act,46659709,UseGalaxySoldier,4) then
    return Activate()
  end
  if HasID(SetMon,77411244,SetB) then
    return Set()
  end
  if HasID(SetMon,03405259,SetC) then
    return Set()
  end
  if HasID(SpSum,01561110,SummonABC,2) then
    return SpSummon()
  end
  return nil
end
function ATarget(cards)
  return Add(cards,PRIO_TOHAND)
end
function BTarget(cards)
  return Add(cards,PRIO_TOHAND)
end
function CTarget(cards)
  return Add(cards,PRIO_TOFIELD)
end
function ABCTarget(cards,c,min)
  if LocCheck(cards,LOCATION_REMOVED) then
    return Add(cards,PRIO_TOFIELD,min)
  end
  if LocCheck(cards,LOCATION_HAND) then
    return Add(cards,PRIO_TOGRAVE)
  end
  return BestTargets(cards,min,TARGET_BANISH)
end
function GoldGadgetTarget(cards)
  return Add(cards,PRIO_TOFIELD)
end
function SilverGadgetTarget(cards)
  return Add(cards,PRIO_TOFIELD)
end
function GalaxySoldierTarget(cards)
  if LocCheck(cards,LOCATION_HAND) then
    return Add(cards,PRIO_TOGRAVE)
  end
  return Add(cards)
end
function BrilliantFusionTarget(cards,c,min)
  if LocCheck(cards,LOCATION_DECK) then
    return Add(cards,PRIO_TOGRAVE)
  end
  return Add(cards,PRIO_TOFIELD)
end
function TransmodifyTarget(cards)
  if LocCheck(cards,LOCATION_MZONE) then
    return Add(cards,PRIO_TOGRAVE)
  end
  return Add(cards,PRIO_TOFIELD)
end
function BureiTarget(cards)
  if LocCheck(cards,LOCATION_DECK) then
    return Add(cards,PRIO_TOFIELD)
  end
  return BestTargets(cards,1,TARGET_OTHER)
end
function BureidoTarget(cards)
  return Add(cards,PRIO_TOFIELD)
end
function StrategistFilter(c)
  return FilterSet(c,0x11)
  and FilterController(c,1)
end
function StrategistTarget(cards)
  if HasIDNotNegated(AIMon(),66976526,true) then
    return BestTargets(cards,1,TARGET_OTHER,StrategistFilter)
  end
  return BestTargets(cards,1,TARGET_OTHER)
end
function DaiTarget(cards)
  return Add(cards,PRIO_TOFIELD)
end
function HangarTarget(cards)
  if GlobalCardMode == 1 then
    GlobalCardMode = nil
    return Add(cards)
  end
  GlobalEquip = true
  return Add(cards,PRIO_TOFIELD)
end
ABCTargetFunctions = {
[46659709] = GalaxySoldierTarget,     -- Galaxy Soldier
[30012506] = ATarget,                 -- A-Assault Core
[77411244] = BTarget,                 -- B-Buster Drake
[03405259] = CTarget,                 -- C-Crush Wyvern
[55010259] = GoldGadgetTarget,        -- Golden Gadget
[29021114] = SilverGadgetTarget,      -- Silver Gadget
[66625883] = StrategistTarget,        -- Karakuri Strategist

[00911883] = DaiTarget,               -- Unexpected Dai
[05288597] = TransmodifyTarget,       -- Transmodify
[07394770] = BrilliantFusionTarget,   -- Brilliant Fusion
[66399653] = HangarTarget,            -- Union Hangar

[01561110] = ABCTarget,               -- ABC Dragon Buster
[66976526] = BureidoTarget,           -- Karakuri Bureido
[23874409] = BureiTarget,             -- Karakuri Burei   
}
function ABCCard(cards,min,max,id,c)
  for i,v in pairs(ABCTargetFunctions) do
    if id == i then
      return v(cards,c,min,max)
    end
  end
  return nil
end
function ChainABC(c,mode)
  if mode == 1 -- banish
  then 
    local targets = SubGroup(OppField(),ABCFilter)
    local prio = SubGroup(OppField(),FilterPriorityTarget)
    local discards = AIHand()
    if (RemovalCheckCard(c)
    or NegateCheckCard(c))
    and #targets>0
    then
      return true
    end
    if #prio>0
    and Duel.GetTurnPlayer()==1-player_ai
    then
      return true
    end
    if Duel.CheckTiming(TIMING_END_PHASE)
    and #targets>0
    and (PriorityCheck(discards,PRIO_TOGRAVE)>3
    or #discards>3)
    and Duel.GetCurrentChain()==0
    then
      return true
    end
  end
  if mode == 2 then -- spsummon
    if RemovalCheckCard(c) 
    or NegateCheckCard(c)
    then
      return true
    end
    if Duel.CheckTiming(TIMING_END_PHASE)
    and CardsMatchingFilter(AIExtra(),FilterID,c.id)>0
    and Duel.GetCurrentChain()==0
    then
      return true
    end
  end
end
function ChainA(c)
  return true -- TODO: not disable ABC summon
end
function ChainB(c)
  return true
end
function ChainC(c)
  return true
end
function ChainGoldGadget(c)
  OPTSet(c.id)
  return true
end
function ChainSilverGadget(c)
  OPTSet(c.id)
  return true
end
function ChainGalaxySoldier(c)
  return true
end
function ChainBureido(c)
  return true
end
function ChainBurei(c)
  return true
end
function ChainHangar(c)
  return true
end
function ChainLazuli(c)
  return true
end
function ChainOmegaABC(c)
  if Duel.GetCurrentPhase()==PHASE_STANDBY then
    return #AIBanish()>0 and not HasID(AIMon(),01561110,true)
    or #AIBanish()~=3
  end
  if RemovalCheckCard(c) or NegateCheckCard(c) then
    return true
  end
  if Duel.CheckTiming(TIMING_MAIN_END) 
  and BattlePhaseCheck()
  and OppHasStrongestMonster()
  then
    return true
  end
end
ABCChainFunctions={
[30012506] = ChainA,              -- A-Assault Core
[77411244] = ChainB,              -- B-Buster Drake
[03405259] = ChainC,              -- C-Crush Wyvern
[55010259] = ChainGoldGadget,     -- Golden Gadget
[29021114] = ChainSilverGadget,   -- Silver Gadget
[46659709] = ChainGalaxySoldier,  -- Galaxy Soldier
[66976526] = ChainBureido,        -- Bureido
[23874409] = ChainBurei,          -- Burei
[66399653] = ChainHangar,         -- Union Hangar
[81846636] = ChainLazuli,         -- Gem-Knight Lazuli
[74586817] = ChainOmegaABC,         -- Omega
}
function ABCChain(cards)
  if HasID(cards,01561110,false,01561110*16,ChainABC,1) then
    return Chain()
  end
  if HasID(cards,01561110,false,01561110*16+1,ChainABC,2) then
    return Chain()
  end
  for id,v in pairs(ABCChainFunctions) do
    if HasID(cards,id,v) then
      return Chain()
    end
  end
  return nil
end
function ABCEffectYesNo(id,card)
  for i,v in pairs(ABCChainFunctions) do
    if id == i then
      return v(card)
    end
  end
  return nil
end
function ABCMaterial(cards,min,max,id)
  if id == 01561110 then
    return Add(cards,PRIO_BANISH,min,FilterLocation,LOCATION_GRAVE)
  end
end
function ABCYesNo(desc)
end
function ABCTribute(cards,min, max)
end
function ABCBattleCommand(cards,targets,act)
end
function ABCAttackTarget(cards,attacker)
end
function ABCAttackBoost(cards)
end
function ABCOption(options)
end
function ABCChainOrder(cards)
end
ABCAtt={
46659709, -- Galaxy Soldier
70271583, -- Karakuri Watchdog
66625883, -- Karakuri Strategist

01561110, -- ABC Dragon Buster
03113836, -- Gem-Knight Seraphinite
74586817, -- Omega
66976526, -- Karakuri Bureido
23874409, -- Karakuri Burei
63767246, -- Titanic Galaxy
}
ABCVary={
30012506, -- A-Assault Core
77411244, -- B-Buster Drake
03405259, -- C-Crush Wyvern
55010259, -- Golden Gadget
29021114, -- Silver Gadget
}
ABCDef={
81846636, -- Gem-Knight Lazuli
}
function ABCPosition(id,available)
  result = nil
  for i=1,#ABCAtt do
    if ABCAtt[i]==id 
    then 
      result=POS_FACEUP_ATTACK
    end
  end
  for i=1,#ABCVary do
    if ABCVary[i]==id 
    then 
      if (BattlePhaseCheck() or IsBattlePhase())
      and Duel.GetTurnPlayer()==player_ai 
      then 
        result=POS_FACEUP_ATTACK
      else 
        result=POS_FACEUP_DEFENSE 
      end
    end
  end
  for i=1,#ABCDef do
    if ABCDef[i]==id 
    then 
      result=POS_FACEUP_DEFENSE 
    end
  end
  return result
end