ChaosDragon = nil
function ChaosDragonCheck()
  if ChaosDragon == nil then
    ChaosDragon = HasID(UseLists({AIDeck(),AIHand()}),99365553,true) -- check if the deck has Lightpulsar Dragon
    MergePriorities()
  end 
  return ChaosDragon
end
function AIField() 
  return UseLists({AIMon(),AIST()})
end
function OppField() 
  return UseLists({OppMon(),OppST()})
end
function OppGetStrongestAttDef()
  local cards=OppMon()
  local result=0
  ApplyATKBoosts(cards)
  for i=1,#cards do
    if cards[i] then
      if bit32.band(cards[i].position,POS_ATTACK)>0 and cards[i].attack>result then
        result=cards[i].attack-cards[i].bonus
      elseif bit32.band(cards[i].position,POS_DEFENCE)>0 and cards[i].defense>result 
      and (bit32.band(cards[i].position,POS_FACEUP)>0 or bit32.band(cards[i].status,STATUS_IS_PUBLIC)>0)
      then
        result=cards[i].defense
      end
    end
  end
  return result
end
function FilterAttribute(c,att)
  return bit32.band(c.type,TYPE_MONSTER)>0 and bit32.band(c.attribute,att)>0
end
function FilterRace(c,race)
  return bit32.band(c.type,TYPE_MONSTER)>0 and bit32.band(c.race,race)>0
end
function DarksInGrave()
  return CardsMatchingFilter(AIGrave(),FilterAttribute,ATTRIBUTE_DARK)
end
function LightsInGrave()
  return CardsMatchingFilter(AIGrave(),FilterAttribute,ATTRIBUTE_LIGHT)
end
function DestroyFilter(c)
  return c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0
  and bit32.band(c.status,STATUS_LEAVE_CONFIRMED)==0
  and c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0
  and not (DestroyBlacklist(c.id)
  and (bit32.band(c.position, POS_FACEUP)>0 
  or bit32.band(c.status,STATUS_IS_PUBLIC)>0))
end
function DestroyCheck(cards)
  return CardsMatchingFilter(cards,DestroyFilter)
end
function DADCond(loc,c)
  if loc == PRIO_TOFIELD then
    return DestroyCheck(OppField())>1 
    and PriorityCheck(AIGrave(),PRIO_BANISH,2,FilterAttribute,ATTRIBUTE_DARK)>4
  end
  if loc == PRIO_TOHAND then
    return DarksInGrave() <= 5
  end
  return true
end
function ChaosSummonCheck()
  return math.min(PriorityCheck(AIGrave(),PRIO_BANISH,1,FilterAttribute,ATTRIBUTE_DARK)
  ,PriorityCheck(AIGrave(),PRIO_BANISH,1,FilterAttribute,ATTRIBUTE_LIGHT))
end
function LightpulsarSummonCheck()
  return math.min(PriorityCheck(AIHand(),PRIO_TOGRAVE,1,FilterAttribute,ATTRIBUTE_DARK)
  ,PriorityCheck(AIHand(),PRIO_TOGRAVE,1,FilterAttribute,ATTRIBUTE_LIGHT))
end
function BLSCond(loc,c)
  if loc == PRIO_TOFIELD then
    return CardsMatchingFilter(UseLists({OppMon(),OppST()}),DADFilter)>0
  end
  if loc == PRIO_TOHAND then
    return ChaosSummonCheck()>4
  end
  return true
end

function REDMDCond(loc,c)
  if loc == PRIO_TOFIELD then
    return true
  end
  if loc == PRIO_TOHAND then
    return true
  end
  return true
end
function SorcFilter(c)
  return bit32.band(c.status,STATUS_LEAVE_CONFIRMED)==0
  and c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0
  and bit32.band(c.position, POS_FACEUP)>0 
end
function SorcCond(loc,c)
  if loc == PRIO_TOFIELD then
    return CardsMatchingFilter(OppMon(),SorcFilter)>0 and OverExtendCheck()
  end
  if loc == PRIO_TOHAND then
    return ChaosSummonCheck()>4
  end
  return true
end
function LightpulsarFilter(c)
  return bit32.band(c.race,RACE_DRAGON) and c:is_affected_by(EFFECT_SPSUMMON_CONDITION)>0 
  and bit32.band(c.attribute,ATTRIBUTE_DARK) and c.level>4
end
function LightpulsarCond(loc,c)
  if loc == PRIO_TOHAND then
    return ChaosSummonCheck()>4 
  end
  if loc == PRIO_TOFIELD then
    return CardsMatchingFilter(AIGrave(),LightpulsarFilter)>0
  end
  return true
end
function DarkflareCond(loc,c)
  if loc == PRIO_TOFIELD then
    return HasID(AIHand(),51858306,true)
  end
  return true
end
function MiniDragonCount(cards)
  local result = 0
  for i=1,#cards do
    if cards[i].id == 61901281 or cards[i].id == 99234526 then
      result = result + 1
    end
  end
  return result
end
function MiniDragonCond(loc,c)
  if loc == PRIO_BANISH then
    return bit32.band(c.location,LOCATION_HAND)==0 or MiniDragonCount(UseLists({AIMon(),AIHAnd()}))>1
  end
  return true
end
function RaidenCond(loc,c)
  if loc == PRIO_TOGRAVE and bit32.band(c.location,LOCATION_HAND) then
    return true
  end
  return true
end
function LylaCond(loc,c)
  return true
end
function LuminaCond(loc,c)
  if loc == PRIO_TOFIELD then
    return not HasID(AIMon(),95503687,true)
  end
  return true
end
function KuribanditCond(loc,c)
  if loc == PRIO_TOGRAVE then
    return #AIDeck()<20
  end
  return true
end
function WyvernCond(loc,c)
  if loc == PRIO_TOFIELD then
    return bit32.band(c.location,LOCATION_GRAVE)==0
  end
  return true
end
function PSZCond(loc,c)
  return true
end
function TourGuideCond(loc,c)
  if loc == PRIO_BANISH then
    return bit32.band(c.location,LOCATION_HAND)==0
  end
  return true
end
function DanteCond(loc,c)
  if loc == PRIO_TOGRAVE then
    return c.xyz_material_count==0 and (Duel.GetCurrentPhase()==PHASE_MAIN2 or c.attack<1500)
  end
  return true
end
function AngineerCond(loc,c)
  if loc == PRIO_TOGRAVE then
    return c.xyz_material_count==0
  end
  return true
end
function LeviairCond(loc,c)
  if loc == PRIO_TOGRAVE then
    return c.xyz_material_count==0
  end
  return true
end
function ChainCond(loc,c)
  if loc == PRIO_TOGRAVE then
    return c.xyz_material_count==0
  end
  return true
end
function SharkCond(loc,c)
  if loc == PRIO_TOGRAVE then
    return c.xyz_material_count==0
  end
  return true
end
function GauntletCond(loc,c)
  if loc == PRIO_TOGRAVE then
    return c.xyz_material_count==0
  end
  return true
end
function PtolemyCond(loc,c)
  if loc == PRIO_TOGRAVE then
    return c.xyz_material_count==0
  end
  return true
end
function ScarmCond(loc,c)
  return true
end
function CollapserpentCond(loc,c)
  if loc == PRIO_TOGRAVE and bit32.band(c.location,LOCATION_HAND)>0 then
    return MiniDragonCount(AIHand())>1
  end
  if loc == PRIO_TOHAND then
    return MiniDragonCount(AIHand())==0
  end
  return true
end
function WyverbusterCond(loc,c)
  if loc == PRIO_TOGRAVE and bit32.band(c.location,LOCATION_HAND)>0 then
    return MiniDragonCount(AIHand())>1
  end
  if loc == PRIO_TOHAND then
    return MiniDragonCount(AIHand())==0
  end
  return true
end
Prio = {
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
[77558536] = {6,4,7,4,5,2,0,0,5,0,RaidenCond},        -- Lightsworn Raiden
[22624373] = {4,2,4,2,6,3,0,0,8,0,LylaCond},          -- Lightsworn Lyla
[95503687] = {5,3,8,3,4,3,0,0,7,0,LuminaCond},        -- Lightsworn Lumina
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
}
--{hand,hand+,field,field+,grave,grave+,other,other+,banish,banish+} 
function MergePriorities()
  --[[for i,line in pairs(BujinPrio) do
    local line2={}
    for j=1,6 do
      line2[j]=line[j]
    end
    line2[7]=0
    line2[8]=0
    line2[9]=line[7]
    line2[10]=0
    line2[11]=nil
    Prio[i]=line2
  end]]
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
function SSLightpulsar(c)
  if bit32.band(c.location,LOCATION_HAND)>0 then
    GlobalCardMode=4
    return ChaosSummonCheck()>4 and OverExtendCheck() and #OppMon()>0  --and LightpulsarSummonCheck()>4
  elseif bit32.band(c.location,LOCATION_GRAVE)>0 then
    GlobalCardMode=2
    return (LightpulsarSummonCheck()>4 or (LightpulsarSummonCheck()>2 
    and #AIHand()>4) and OverExtendCheck() and #OppMon()>0)
    and not (HasID(AIHand(),99365553,true) and ChaosSummonCheck()>4)
  end
end
function NSLightpulsar(c)
  return PriorityCheck(AIMon(),PRIO_TOGRAVE)>4 
end
function SummonDAD()
  return DADCond(PRIO_TOFIELD)
end
function UseDAD()
  return DestroyCheck(OppField())>0 
  and PriorityCheck(AIGrave(),PRIO_BANISH,2,FilterAttribute,ATTRIBUTE_DARK)>4
end
function SummonDante()
  return #AIDeck()>20
end
function LeviairFilter(c)
  return bit32.band(c.type,TYPE_MONSTER)>0 and c.level<5 and c:is_affected_by(EFFECT_SPSUMMON_CONDITION)==0
end
function SummonLeviair()
  return PriorityCheck(AIBanish(),PRIO_TOFIELD,1,LeviairFilter)>4 
end
function UseLeviair()
  return true
end
function UseChaosSorc()
  return CardsMatchingFilter(OppMon(),ChaosSorcFilter2)>0 or ((OppHasStrongestMonster() 
  or AI.GetCurrentPhase() == PHASE_MAIN2 or FieldCheck(6)>1 or HasID(AIMon(),33420078,false))
  and CardsMatchingFilter(OppMon(),ChaosSorcFilter)>0)
end
function SummonGauntletLauncher()
  return DestroyCheck(OppMon())>1 
end
function UseGauntletLauncher()
  return DestroyCheck(OppMon())>0 
end
function SummonPtolemy()
  return true
end
function UsePtolemy()
  return true
end
function SummonScrapDragon()
  return DestroyCheck(OppField())>0 and (HasID(AIMon(),34408491,true) or PriorityCheck(AIField(),PRIO_TOGRAVE,2)>4)
end
function UseScrapDragon()
  return DestroyCheck(OppField())>0 and (HasID(AIMon(),34408491,true) or (PriorityCheck(AIField(),PRIO_TOGRAVE)>4 and MP2Check()) or (HasID(AIMon(),99365553,true) and LightpulsarCond(PRIO_TOFIELD)))
end
function SummonBLS()
  return OverExtendCheck() and #OppMon()>0 and ChaosSummonCheck()>4
end
function BLSFilter(c)
  return bit32.band(c.status,STATUS_LEAVE_CONFIRMED)==0
  and c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0
end
function BLSFilter2(c)
  return BLSFilter(c)
  and (c.attack>=3000 or c:is_affected_by(EFFECT_CANNOT_BE_BATTLE_TARGET)==1 
  or c:is_affected_by(EFFECT_INDESTRUCTABLE)==1 or bit32.band(c.position,POS_FACEDOWN)>0)
end
function UseBLS()
  return CardsMatchingFilter(OppMon(),BLSFilter2)>0 or ((OppHasStrongestMonster() 
  or AI.GetCurrentPhase() == PHASE_MAIN2) and CardsMatchingFilter(OppMon(),BLSFilter)>0)
end
function REDMDFilter(c)
  return bit32.band(c.race,RACE_DRAGON)>0 and c:is_affected_by(EFFECT_SPSUMMON_CONDITION)==0 and c.id~=51858306
end
function SummonREDMD()
  return PriorityCheck(AIMon(),PRIO_BANISH,1,FilterRace,RACE_DRAGON)>4 and UseREDMD()
end
function UseREDMD()
  return CardsMatchingFilter(AIGrave(),REDMDFilter)>0
end
function UseTrag1() -- mindcontrol
  return PriorityCheck(AIHand(),PRIO_TOGRAVE)>4
end
function LevelFilter(c,level)
  return bit32.band(c.type,TYPE_MONSTER)>0 and c.level==level
end
function TragCheck(level)
  return CardsMatchingFilter(AIGrave(),LevelFilter,level)>0
end
function ExtraDeckCheck(type,level)
  local cards=AIExtra()
  local result = 0
  for i=1,#cards do
    if bit32.band(cards[i].type,type)>0 
    and (cards[i].level==level or cards[i].rank==level) then
      result = result + 1
    end
  end
  return result
end
function UseTrag2() -- change level
  if FieldCheck(6)>0 and TragCheck(6) and ExtraDeckCheck(TYPE_XYZ,6)>0 then
    GlobalCardMode=6
    return true
  elseif FieldCheck(4)>0 and TragCheck(4) and ExtraDeckCheck(TYPE_XYZ,4)>0 then
    GlobalCardMode=4
    return true
  elseif FieldCheck(3)>0 and TragCheck(3) and ExtraDeckCheck(TYPE_XYZ,3)>0 then
    GlobalCardMode=3
    return true
  elseif HasID(AIMon(),33420078,false) then
    if TragCheck(6) and ExtraDeckCheck(TYPE_SYNCHRO,8)>0 then
      GlobalCardMode=6
      return true
    elseif TragCheck(4) and ExtraDeckCheck(TYPE_SYNCHRO,6)>0 then
      GlobalCardMode=4
      return true
    elseif TragCheck(3) and ExtraDeckCheck(TYPE_SYNCHRO,5)>0 then
      GlobalCardMode=3
      return true
    end
  end
  return false
end
function SummonChaosSorc()
  return OverExtendCheck() and #OppMon()>0 and ChaosSummonCheck()>4
end
function ChaosSorcFilter(c)
  return bit32.band(c.status,STATUS_LEAVE_CONFIRMED)==0
  and c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0
  and bit32.band(c.position,POS_FACEUP)>0
end
function ChaosSorcFilter2(c)
  return ChaosSorcFilter(c)
  and (c.attack>=2300 or c:is_affected_by(EFFECT_CANNOT_BE_BATTLE_TARGET)==1 
  or c:is_affected_by(EFFECT_INDESTRUCTABLE)==1)
end
function SummonDarkflare()
  return ChaosSummonCheck()>4 and OverExtendCheck() and #OppMon()>0
end
function UseDarkflare()
  return false--PriorityCheck(AIHand(),PRIO_TOGRAVE,1,RaceFilter,RACE_DRAGON)>4 and #OppGrave()>0
end
function SummonMini()
  return HasID(AIMon(),77558536,true) and FieldCheck(4)==1 and ExtraDeckCheck(TYPE_SYNCHRO,8)>0 and #OppMon()>0 --and OppHasStrongestMonster()
  or OppHasStrongestMonster() and FieldCheck(4)==1 and ExtraDeckCheck(TYPE_XYZ,4)>0
  or HasID(AIMon(),33420078,true) and OppHasStrongestMonster() and FieldCheck(4)==0 and ExtraDeckCheck(TYPE_SYNCHRO,6)>0
  or HasID(AIHand(),99365553,true) and PriorityCheck(AIField(),PRIO_TOGRAVE)<4 and not Duel.CheckNormalSummonActivity(player_ai) and OverExtendCheck() and #OppMon()>0
  or HasID(AIHand(),88264978,true) and UseREDMD() and OverExtendCheck()
  or HasID(AIMon(),76774528,true) and DestroyCheck(OppField())>0 
end
function SummonCollapserpent()
  return PriorityCheck(AIGrave(),PRIO_BANISH,1,FilterAttribute,ATTRIBUTE_LIGHT)>4 and SummonMini()
end
function SummonWyverbuster()
  return PriorityCheck(AIGrave(),PRIO_BANISH,1,FilterAttribute,ATTRIBUTE_DARK)>4 and SummonMini()
end
function SetScarm()
  return (Duel.GetTurnCount()==1 or Duel.GetCurrentPhase() == PHASE_MAIN2) and #AIMon()==0
end
function LuminaFilter(c)
  return bit32.band(c.type,TYPE_MONSTER) and c.level<5 and IsSetCode(c.setcode,0x38)
end
function SummonLumina()
  return CardsMatchingFilter(AIGrave(),LuminaFilter)>0 and OverExtendCheck()
end
function UseLumina()
  return OverExtendCheck() and PriorityCheck(AIHand(),PRIO_TOGRAVE)>4
end
function SummonLyla()
  return CardsMatchingFilter(OppST(),DestroyFilter)>0 and OverExtendCheck()
end
function UseLyla()
  return CardsMatchingFilter(OppST(),DestroyFilter)>0 
  and (Duel.GetCurrentPhase()==PHASE_MAIN2 or FieldCheck(4)>1 
  or HasID(AIMon(),33420078,true) or HasID(AIHand(),99365553,true) 
  and not Duel.CheckNormalSummonActivity(player_ai))
end
function SummonRaiden()
  return OverExtendCheck()
end
function UseRaiden()
  return #AIDeck()>10
end
function SummonPSZ()
  return FieldCheck(6)==1 or FieldCheck(4)==1 and Duel.GetCurrentPhase==PHASE_MAIN1 
  and OppGetStrongestAttDef()<2800 and not HasID(AIMon(),77558536,false)
end
function UsePSZ()
  return SummonPSZ() and #AIHand()>4
end
function UseAllure()
  return PriorityCheck(AIHand(),PRIO_BANISH)>4
end
function TourguideFilter(c)
  return bit32.band(c.type,TYPE_MONSTER)>0 and bit32.band(c.race,RACE_FIEND)>0 and c.level==3
end
function SummonTourguide()
  return CardsMatchingFilter(UseLists({AIDeck(),AIHand()}),TourguideFilter)>1 and OverExtendCheck()
end
function SummonGoyoGuardian()
  return Duel.GetCurrentPhase==PHASE_MAIN1 and OppGetStrongestAttDef()<2800
end
function SummonKuribandit()
  return true
end
function UseDante()
  return #AIDeck()>10
end
function SummonBeelze()
  return true
end
function ChaosDragonOnSelectInit(cards, to_bp_allowed, to_ep_allowed)
  local Activatable = cards.activatable_cards
  local Summonable = cards.summonable_cards
  local SpSummonable = cards.spsummonable_cards
  local Repositionable = cards.repositionable_cards
  local SetableMon = cards.monster_setable_cards
  local SetableST = cards.st_setable_cards
  GlobalScepterOverride = 0
  if HasID(Activatable,94886282) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Activatable,00691925) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Activatable,01475311) and UseAllure() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(SpSummonable,65192027) and SummonDAD() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,65192027) and UseDAD() then
    GlobalCardMode = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Summonable,33420078) and SummonPSZ() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Activatable,33420078) and UsePSZ() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,77558536) and UseRaiden() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,22624373) and UseLyla() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,95503687) and UseLumina() then
    GlobalCardMode = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,09596126) and UseChaosSorc() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
    if HasID(SpSummonable,13700002) and SummonDante() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,13700002) and UseDante() then
    GlobalActivatedCardID = 13700002
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(SpSummonable,95992081) and SummonLeviair() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,95992081) and UseLeviair() then
    GlobalCardMode = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  --if HasIDNotNegated(Activatable,34086406) and UseLavalvalChain() then
  --  return {COMMAND_ACTIVATE,CurrentIndex}
  --end
  if HasID(SpSummonable,38495396) and SummonPtolemy() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,38495396) and UsePtolemy() then
    GlobalCardMode = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(SpSummonable,15561463) and SummonGauntletLauncher() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,15561463) and UseGauntletLauncher() then
    GlobalCardMode = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(SpSummonable,34408491) and SummonBeelze() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,07391448) and SummonGoyo() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  --if HasIDNotNegated(Activatable,04779823) and UseMichael() then
    --return {COMMAND_ACTIVATE,CurrentIndex}
  --end
  if HasID(SpSummonable,76774528) and SummonScrapDragon() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,76774528) and UseScrapDragon() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(SpSummonable,88264978) and SummonREDMD() then
    GlobalSSCardID = 88264978
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,88264978) and UseREDMD() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  for i=1,#SpSummonable do
    if SpSummonable[i].id == 99365553 and SSLightpulsar(SpSummonable[i]) then
      GlobalSSCardID = 99365553
      return {COMMAND_SPECIAL_SUMMON,i}
    end
  end
  if HasID(SpSummonable,09596126) and SummonChaosSorc() then
    GlobalSSCardID = 09596126
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end

  if HasID(SpSummonable,72989439) and SummonBLS() then
    GlobalCardMode=1
    GlobalSSCardID = 72989439
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,72989439) and UseBLS() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,98777036,false,1580432577) and UseTrag1() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,98777036,false,1580432578) and UseTrag2() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(SpSummonable,25460258) and SummonDarkflare() then
    GlobalCardMode=4
    GlobalSSCardID = 25460258
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,25460258) and UseDarkflare() then
    GlobalCardMode = 2
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(SpSummonable,61901281) and SummonCollapserpent() then
    GlobalSSCardID = 61901281
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,99234526) and SummonWyverbuster() then
    GlobalSSCardID = 99234526
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end

  if HasID(Summonable,10802915) and SummonTourguide() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Summonable,95503687) and SummonLumina() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Summonable,77558536) and SummonRaiden() then
    return {COMMAND_SUMMON,CurrentIndex}
  end

  if HasID(Summonable,99365553) and NSLightpulsar(Summonable[CurrentIndex]) then
    GlobalActivatedCardLevel=6
    GlobalActivatedCardAttack=2500
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Summonable,22624373) and SummonLyla() then
    return {COMMAND_SUMMON,CurrentIndex}
  end

  --if HasID(Activatable,13700001) and UseScarm() then
  --  return {COMMAND_ACTIVATE,CurrentIndex}
  --end
  if HasID(Summonable,16404809) and SummonKuribandit() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Summonable,95503687) and OverExtendCheck() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Summonable,22624373) and OverExtendCheck() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(SetableMon,13700001) and SetScarm() then
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  return nil
end
function DarkflareTarget(cards)
  if GlobalCardMode == 4 then
    GlobalCardMode = 3
    return Add(cards,PRIO_BANISH)
  elseif GlobalCardMode == 3 then
    GlobalCardMode = nil
    GlobalSSCardID = nil
    return Add(cards,PRIO_BANISH)
  elseif GlobalCardMode == 2 then
    GlobalCardMode = 1
    return Add(cards,PRIO_TOGRAVE)
  elseif GlobalCardMode == 1 then
    GlobalCardMode = nil
    return Add(cards,PRIO_TOGRAVE)
  else
    return BestTargets(cards,1,TARGET_BANISH)
  end
end
function DADTarget(cards)
  if GlobalCardMode==1 then
    GlobalCardMode=nil
    return Add(cards,PRIO_BANISH)
  else
    return BestTargets(cards,1,TARGET_DESTROY)
  end
end
function LuminaTarget(cards)
  if GlobalCardMode == 1 then
    GlobalCardMode = nil
    return Add(cards,PRIO_TOGRAVE)
  else
    return Add(cards,PRIO_TOFIELD)
  end
end
function DanteTarget(cards,c)
  if bit32.band(c.location,LOCATION_GRAVE)>0 then
    return Add(cards,PRIO_TOFIELD)
  else
    return Add(cards,PRIO_TOGRAVE)
  end
end
function LeviairTarget(cards)
  if GlobalCardMode == 1 then
    GlobalCardMode = nil
    return Add(cards,PRIO_TOGRAVE)
  else
    return Add(cards,PRIO_TOFIELD)
  end
end
function GauntletLauncherTarget(cards)
  if GlobalCardMode == 1 then
    GlobalCardMode = nil
    return Add(cards,PRIO_TOGRAVE)
  else
    return BestTargets(cards,1,TARGET_DESTROY)
  end
end
function PtolemyTarget(cards)
  if GlobalCardMode == 1 then
    GlobalCardMode = nil
    return Add(cards,PRIO_TOGRAVE)
  else
    return Add(cards,PRIO_TOHAND)
  end
end
function LightpulsarTarget(cards)
  if GlobalCardMode == 4 then
    GlobalCardMode = 3
    return Add(cards,PRIO_BANISH)
  elseif GlobalCardMode == 3 then
    GlobalCardMode = nil
    GlobalSSCardID = nil
    return Add(cards,PRIO_BANISH)
  elseif GlobalCardMode == 2 then
    GlobalCardMode = 1
    return Add(cards,PRIO_TOGRAVE)
  elseif GlobalCardMode == 1 then
    GlobalCardMode = nil
    GlobalSSCardID = nil
    return Add(cards,PRIO_TOGRAVE)
  else
    GlobalSSCardID = nil
    return Add(cards,PRIO_TOFIELD)
  end
end
function TragTarget(cards)
  local result={}
  if GlobalCardMode and GlobalCardMode>0 then
    for i=1,#cards do
      if cards[i].level==GlobalcardMode then
        result[1]=i
      end
    end
  else
    result = BestTargets(cards)
  end
  GlobalCardMode=nil
  if #result~=1 then result={math.random(#cards)} end
  return result
end
function BLSTarget(cards)
  if GlobalCardMode == 2 then
    GlobalCardMode = 1
    return Add(cards,PRIO_BANISH)
  elseif GlobalCardMode == 1 then
    GlobalCardMode = nil
    GlobalSSCardID = nil
    return Add(cards,PRIO_BANISH)
  else
    return BestTargets(cards,1,TARGET_BANISH)
  end 
end
function ScrapDragonTarget(cards)
  if HasID(cards,99365553) and LightpulsarCond(PRIO_TOFIELD) then
    return {CurrentIndex}
  end
  return BestTargets(cards,1,TARGET_DESTROY)
end
function ChaosDragonOnSelectCard(cards, minTargets, maxTargets,triggeringID,triggeringCard)
  local ID 
  local result=nil
  if triggeringCard then
    ID = triggeringCard.id
  else
    ID = triggeringID
  end
  --print("selecting target")
  --if ID then print("ID: "..ID) end
  --if GlobalSSCardID then print("GlobalSSID: "..GlobalSSCardID) end
  --if GlobalActivatedCardID then print("GlobalCardID: "..GlobalActivatedCardID) end
  if ID == 65192027 then -- DAD
    return DADTarget(cards)
  end
  if GlobalSSCardID == 72989439 then -- BLS
    return BLSTarget(cards)
  end
  if ID == 72989439 then -- BLS
    return BestTargets(cards,1,TARGET_BANISH)
  end
  if ID == 88264978 then -- REDMD
    return Add(cards,PRIO_TOFIELD)
  end
  if GlobalSSCardID == 88264978 then -- REDMD
    GlobalSSCardID = nil
    return BestTargets(cards,1,TARGET_BANISH)
  end
  if ID == 98777036 then
    return TragTarget(cards)
  end
  if ID == 09596126 then -- Chaos Sorc
    return BestTargets(cards,1,TARGET_BANISH)
  end
  if GlobalSSCardID == 09596126 then -- Chaos Sorc
    GlobalSSCardID = nil
    return BestTargets(cards,1,TARGET_BANISH)
  end
  if ID == 99365553 then -- Lightpulsar
    return Add(cards,PRIO_TOFIELD)
  end
  if GlobalSSCardID == 99365553 then -- Lightpulsar
    return LightpulsarTarget(cards)
  end
  if ID == 25460258 then -- Darkflare
    return DarkflareTarget(cards)
  end
  if GlobalSSCardID == 25460258 then -- Darkflare
    return DarkflareTarget(cards)
  end
  if GlobalSSCardID == 61901281 or GlobalSSCardID == 99234526  then -- Collapserpent, Wyverbuster
    GlobalSSCardID = nil
    return Add(cards,PRIO_BANISH)
  end
  if ID == 22624373 then -- Lyla
    return BestTargets(cards,1,TARGET_DESTROY)
  end
  if ID == 95503687 then
    return LuminaTarget(cards)
  end
  if ID == 33420078 then -- PSZ
    return Add(cards,PRIO_DISCARD)
  end
  if ID == 51858306 or ID == 13700001 or ID == 94886282 then -- Eclipse Wyvern, Scarm, Charge of the Light Brigade
    return Add(cards)
  end
  if ID == 10802915 then -- Tour Guide
    return Add(cards,PRIO_TOFIELD)
  end
  if ID == 00691925 then -- Solar Recharge
    return Add(cards,PRIO_TOGRAVE)
  end
  if ID == 01475311 then -- Allure
    return Add(cards,PRIO_BANISH)
  end
  if ID == 81439173 then -- Foolish
    return Add(cards,PRIO_TOGRAVE)
  end
  if ID == 13700002 then 
    return DanteTarget(cards,triggeringCard)
  end
  if ID == 95992081 then 
    return LeviairTarget(cards)
  end
  if ID == 15561463 then 
    return GauntletLauncherTarget(cards)
  end
  if ID == 38495396 then 
    return PtolemyTarget(cards)
  end
  if ID == 76774528 then 
    return ScrapDragonTarget(cards)
  end
  return nil
end
function ChainGorz()
  return true
end
function ChainTrag()
  return true
end
function ChaosDragonOnSelectChain(cards,only_chains_by_player)
  if HasIDNotNegated(cards,34408491) then -- Beelze
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,61901281) then -- Collapserpent
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,99234526) then -- Wyverbuster
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,99365553) then -- Lightpulsar Dragon
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,72989439) then -- BLS
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,16404809) then -- Kuribandit
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,10802915) then -- Tour Guide
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,13700001) then -- Scarm
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,51858306) then -- Eclipse Wyvern
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,07391448) then -- Goyo Guardian
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,13700002) then -- Dante
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,44330098) and ChainGorz() then
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,98777036) and ChainTrag() then
    return {1,CurrentIndex}
  end
  return nil
end
function ChaosDragonOnSelectEffectYesNo(id,card)
  local result = nil
  local field = bit32.band(card.location,LOCATION_ONFIELD)>0
  local grave = bit32.band(card.location,LOCATION_GRAVE)>0
  if id==34408491 or id==61901281 or id==99234526 or id==99365553 -- Beelze, Collapserpent, Wyverbuster, Lightpulsar
  or id==72989439 or id==16404809 or id==10802915 or id==13700001 -- BLS, Kuribandit, Tour Guide, Scarm
  or id==51858306 or id==07391448 or id==13700002 -- Eclipse Wyvern, Goyo Guardian, Dante
  and NotNegated(card) 
  then
    result = 1
  end
  if id == 44330098 and ChainGorz() then
    result = 1
  end
  if id == 98777036 and ChainTrag() then
    result = 1
  end
  return result
end
ChaosDragonAtt={
  44330098,09596126,22624373,95992081
}
ChaosDragonDef={
  98777036,13700001,16404809,33420078,
  10802915
}
function ChaosDragonOnSelectPosition(id, available)
  result = nil
  for i=1,#ChaosDragonAtt do
    if ChaosDragonAtt[i]==id then result=POS_FACEUP_ATTACK end
  end
  for i=1,#ChaosDragonDef do
    if ChaosDragonDef[i]==id then result=POS_FACEUP_DEFENCE end
  end
  if id == 13700002 then -- Dante
    if GlobalBPAllowed and Duel.GetCurrentPhase()==PHASE_MAIN1 and OppGetStrongestAttDef()<2500 then
      result=POS_FACEUP_ATTACK
    else
      result=POS_FACEUP_DEFENCE
    end
  end
  return result
end