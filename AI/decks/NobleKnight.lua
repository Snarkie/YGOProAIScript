function NobleFilter(c,exclude)
  return IsSetCode(c.setcode,0x107a) and (exclude == nil or c.id~=exclude)
end
function NobleMonsterFilter(c,exclude)
  return bit32.band(c.type,TYPE_MONSTER)>0 and NobleFilter(c,exclude)
end
function ArmsFilter(c,exclude)
  return IsSetCode(c.setcode,0x207a) and (exclude == nil or c.id~=exclude)
end
function UseableArmsFilter(c,exclude)
  return ArmsFilter(c,exclude) and (bit32.band(c.location,LOCATION_SZONE)==0 
  or bit32.band(c.position,POS_FACEDOWN)>0)
end
function NobleOrArmsFilter(c,exclude)
  return NobleFilter(c,exclude) or ArmsFilter(c,exclude)
end
function ArmsCount(cards,requip,skipgwen,raw)
  local result = 0
  if requip then
    for i=1,#cards do
      if (cards[i].id == 07452945 and OPTCheck(07452945)
      or cards[i].id == 14745409 and OPTCheck(14745409)
      or cards[i].id == 23562407 and OPTCheck(23562407)
      or cards[i].id == 83438826 and OPTCheck(83438826))
      and (bit32.band(cards[i].location,LOCATION_SZONE)==0 
      or bit32.band(cards[i].position,POS_FACEDOWN)>0 or raw)
      then
        result = result + 1
      end
    end
  else
    result = CardsMatchingFilter(cards,UseableArmsFilter,19748583)
    if not skipgwen and OPTCheck(19748583) 
    and HasID(UseLists({AIHand(),AIGrave()}),19748583,true)
    then
      result = result+1
    end
    if raw then
      result = CardsMatchingFilter(cards,ArmsFilter)
    end
  end
  return result
end
function ArmsAvailable(requip,skipgwen,raw,grave)
  local cards = UseLists({AIHand(),AIST()})
  if grave then
    cards = UseLists({AIHand(),AIST(),AIGrave()})
  end
  result = ArmsCount(cards,requip,skipgwen,raw)
  return result
end
function ArmsRequip()
  return ArmsCount(AIST(),true,false,true)>0
end
function KnightCount(cards)
  return CardsMatchingFilter(cards,NobleFilter)
end
function EquipCheck(c)
  return c.equip_count and c.equip_count>0 
  and CardsMatchingFilter(c:get_equipped_cards(),ArmsFilter)>0
end
function DarkCheck(id)
  return id==95772051 or id==93085839 or id==59057152 
  or id==47120245 or id==73359475 or id==83519853 
end
function GwenCheck()
  return HasID(UseLists({AIHand(),AIGrave()}),19748583,true) and OPTCheck(19748583)
end
function NobleATKBoost(mode)
  -- calculates the maximum ATK boost for available arms
  local result = 0
  local cards = AIHand()
  local gallatin = false
  local caliburn = false
  local destiny = false
  if mode then
    if mode == 1 then
      -- for High Sally
      if HasID(AIDeck(),14745409,true) then
        result = result + 1000
      elseif HasID(AIDeck(),23562407,true) then
        result = result + 500
      elseif HasID(AIDeck(),07452945,true) then
        result = result + 1
      end
      if HasID(cards,07452945,true) and result ~= 1 then
        result = result + 1
      end
      if HasID(cards,23562407,true) and result ~= 500 and result ~= 501 then
        result = result + 500
      end
      if HasID(cards,14745409,true) and result<1000 then
        result = result + 1000
      end
      if GwenCheck() then
        result = result + 300
      end
      return result
    elseif mode == 2 then
      -- for a King
      cards = UseLists({AIHand(),AIGrave()})
    end
  end
  if HasID(cards,07452945,true) then
    result = result + 1
  end
  if HasID(cards,23562407,true) then
    result = result + 500
  end
  if HasID(cards,14745409,true) then
    result = result + 1000
  end
end
function ArmsByAtk(cards,baseatk)
  local atk=OppGetStrongestAttDef()
  if GwenCheck() then
    baseatk = baseatk + 300
  end
  if GetMultiple(14745409)>0 then
    baseatk = baseatk + 1000
  end
  if GetMultiple(23562407)>0 then
    baseatk = baseatk + 500
  end
  if GetMultiple(07452945)>0 then
    baseatk = baseatk + 1
  end
  if atk==baseatk and HasID(cards,07452945,true) and GetMultiple(07452945)==0 then
    SetMultiple(07452945)
    return {IndexByID(cards,07452945)}
  elseif atk>=baseatk and atk<baseatk+500 and HasID(cards,23562407,true) and GetMultiple(23562407)==0 then
    SetMultiple(23562407)
    return {IndexByID(cards,23562407)}
  elseif atk>=baseatk and HasID(cards,14745409,true) and GetMultiple(14745409)==0 then
    SetMultiple(14745409)
    return {IndexByID(cards,14745409)}
  elseif atk>=baseatk and HasID(cards,23562407,true) and GetMultiple(23562407)==0 then
    SetMultiple(23562407)
    return {IndexByID(cards,23562407)}
  elseif atk>=baseatk and HasID(cards,07452945,true) and GetMultiple(07452945)==0 then
    SetMultiple(07452945)
    return {IndexByID(cards,07452945)}
  else
    return Add(cards,PRIO_TOFIELD)
  end
end
function TableCount()
  local cards = UseLists({AIField(),AIGrave()})
  local result = 0
  local check = {}
  for i=1,#cards do
    if NobleFilter(cards[i]) and not check[cards[i].id] then
      result = result +1
      check[cards[i].id]=true
    end
  end
  return result
end
function KingArmsCount()
  local cards = AIGrave()
  local result = 0
  local check = {}
  for i=1,#cards do
    if ArmsFilter(cards[i],19748583) and not check[cards[i].id] then
      result = result +1
      check[cards[i].id]=true
    end
  end
  return result
end
function EquipFilter(c)
  if (c.id == 59057152 and UseMedraut()
  or c.id == 47120245 and ArmsCount(AIDeck())>2
  or c.id == 13391185 and UseChad()
  or c.id == 00000999 and UseBedwyr()
  or c.id == 53550467 and OPTCheck(53550467)
  and DestroyCheck(OppField(),false,FilterPosition,POS_FACEUP)>0
  or c.id == 73359475)
  and not EquipCheck(c) then
    return true
  end
  return false
end
function NobleSSCheck()
  return GlobalNobleSS ~= Duel.GetTurnCount()
end
function BlackCheck(c)
  return NotNegated(c) and (c.id == 59057152 or c.id == 47120245 or c.id == 73359475)
end
function Lvl5Check()
  return HasID(UseLists({AIHand(),AIGrave()}),true) 
  and CardsMatchingFilter(AIMon(),BlackSallyFilter)>0
  or CardsMatchingFilter(AIMon(),BlackCheck)>0 and ArmsAvailable()>0
end
GlobalGallatinTurn={}
GlobalTableDump=0
GlobalNobleSS = 0
function MedrautCond(loc,c)
  if loc == PRIO_TOHAND then
    return SummonMedraut() and not HasID(AIHand(),59057152,true) 
    and ArmsAvailable(true)>0 or ArmsAvailable()>1
  end
  if loc == PRIO_TOFIELD then
    return SummonMedraut(true) and Duel.GetCurrentPhase()~=PHASE_END
  end
  if loc == PRIO_TOGRAVE and bit32.band(c.location,LOCATION_DECK)>0 then
    return not HasID(AIGrave(),59057152,true) 
  end
  return true
end
function BorzCond(loc,c)
  if loc == PRIO_TOHAND then
    return SummonBorz() and not HasID(AIHand(),47120245,true)
  end
  if loc == PRIO_TOFIELD then
    return SummonBorz(true) and Duel.GetCurrentPhase()~=PHASE_END
  end
  if loc == PRIO_TOGRAVE and bit32.band(c.location,LOCATION_DECK)>0 then
    return not HasID(AIGrave(),47120245,true) 
  end
  return true
end
function ChadCond(loc,c)
  if loc == PRIO_TOHAND then
    return SummonChad() and not HasID(AIHand(),13391185,true) or bit32.band(c.location,LOCATION_REMOVED)>0
  end
  if loc == PRIO_TOFIELD then
    return SummonChad(true) and Duel.GetCurrentPhase()~=PHASE_END
  end
  if loc == PRIO_TOGRAVE and bit32.band(c.location,LOCATION_DECK)>0 then
    return not HasID(AIGrave(),13391185,true) 
  end
  return true
end
function BedwyrCond(loc,c)
  if loc == PRIO_TOHAND then
    return SummonBedwyr() and not HasID(AIHand(),00000999,true) or bit32.band(c.location,LOCATION_REMOVED)>0
  end
  if loc == PRIO_TOFIELD then
    return SummonBedwyr(true) and Duel.GetCurrentPhase()~=PHASE_END
  end
  if loc == PRIO_TOGRAVE and bit32.band(c.location,LOCATION_DECK)>0 then
    return not HasID(AIGrave(),00000999,true) 
  end
  return true
end
function DrystanCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(AIHand(),53550467,true)
  end
  if loc == PRIO_TOFIELD then
    return SummonDrystan(true) or Duel.GetCurrentPhase()==PHASE_END
  end
  if loc == PRIO_TOGRAVE and bit32.band(c.location,LOCATION_DECK)>0 then
    return not HasID(AIGrave(),53550467,true) 
  end
end
function PeredurCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(AIHand(),73359475,true)
  end
  if loc == PRIO_TOFIELD then
    return bit32.band(c.location,LOCATION_HAND)>0 or Duel.GetCurrentPhase()==PHASE_END
  end
  if loc == PRIO_TOGRAVE then
    if bit32.band(c.location,LOCATION_DECK)>0 then
      return not HasID(AIGrave(),73359475,true) 
    end
    if bit32.band(c.location,LOCATION_MZONE)>0 and EquipCheck(c) then
      return true
    end
  end
end
function GawaynCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(AIHand(),19680539,true) or bit32.band(c.location,LOCATION_REMOVED)>0
  end
  if loc == PRIO_TOFIELD then
    return not Duel.GetCurrentPhase()==PHASE_END
  end
  if loc == PRIO_TOGRAVE and bit32.band(c.location,LOCATION_DECK)>0 then
    return not HasID(AIGrave(),19680539,true) 
  end
end
function BlackSallyCond(loc,c)
  if loc == PRIO_TOFIELD then
    return bit32.band(c.location,LOCATION_HAND+LOCATION_REMOVED)>0 or (ArmsAvailable(false,false,false,true)==0 and not ArmsRequip())
    or Duel.GetCurrentPhase()==PHASE_END
  end
  if loc == PRIO_TOGRAVE and bit32.band(c.location,LOCATION_DECK)>0 then
    return not HasID(AIGrave(),95772051,true) 
  end
  return true
end
function EachtarCond(loc,c)
  if loc == PRIO_TOFIELD then
    return bit32.band(c.location,LOCATION_HAND+LOCATION_REMOVED)>0 or Duel.GetCurrentPhase()==PHASE_END
  end
  if loc == PRIO_TOGRAVE and bit32.band(c.location,LOCATION_DECK)>0 then
    return not HasID(AIGrave(),93085839,true) 
  end
  return true
end
function ArtorigusCond(loc,c)
  if loc == PRIO_TOFIELD then
    return bit32.band(c.location,LOCATION_HAND+LOCATION_REMOVED)>0
  end
  if loc == PRIO_TOGRAVE then
    if bit32.band(c.location,LOCATION_DECK)>0 then
      return not HasID(AIGrave(),92125819,true) 
    end
    if bit32.band(c.location,LOCATION_MZONE)>0 then
      return true
    end
  end
  return true
end
function BrothersCond(loc,c)
  if loc == PRIO_TOHAND then
    return SummonBrothers() or bit32.band(c.location,LOCATION_REMOVED)>0 or Duel.GetCurrentPhase()==PHASE_END
  end
  if loc == PRIO_TOFIELD then
    return SummonBrothers(ss) or Duel.GetCurrentPhase()==PHASE_END
  end
  if loc == PRIO_TOGRAVE and bit32.band(c.location,LOCATION_DECK)>0 then
    return not HasID(AIGrave(),57690191,true) 
  end
  return true
end
function ExcaliburnCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasAccess(c.id) and GetMultiple(c.id)==0
  end
  return true
end
function GwenCond(loc,c)
  if loc == PRIO_TOHAND then
    local cards=UseLists({AIHand(),AIMon()})
    return not HasAccess(c.id) and GetMultiple(c.id)==0 and OPTCheck(19748583)
    and not ((HasID(cards,59057152,true) or HasID(AIHand(),00000997,true)) 
    and not HasID(AIMon(),47120245,true))
    and not FilterLocation(c,LOCATION_GRAVE)
  end
  if loc == PRIO_TOGRAVE then
    if bit32.band(c.location,LOCATION_SZONE)==0 then 
      return ArmsAvailable()==0 and OPTCheck(19748583)
    else
      return not ArmsRequip() or OPTCheck(19748583)
    end
  end
  return true
end
function RequipArmsCond(loc,c)
  if loc == PRIO_TOGRAVE then
    if bit32.band(c.location,LOCATION_SZONE)>0 then
      return OPTCheck(c.id)
    end
  end
  if loc == PRIO_TOFIELD then
    return GetMultiple(c.id)==0
  end
  if loc == PRIO_TOHAND then
    return not HasAccess(c.id) and GetMultiple(c.id)==0
  end
  return true
end
function ArfFilter(c)
  return bit32.band(c.position,POS_FACEDOWN)>0 and DestroyCheck(c)
end
function ArfCond(loc,c)
  if loc == PRIO_TOGRAVE then
    if bit32.band(c.location,LOCATION_SZONE)>0 then
      return OPTCheck(c.id) and CardsMatchingFilter(OppField(),ArfFilter)>0
    end
  end
  if loc == PRIO_TOFIELD then
    return GetMultiple(c.id)==0
  end
  if loc == PRIO_TOHAND then
    return not HasAccess(c.id) and GetMultiple(c.id)==0
  end
  return true
end
function LadyCond(loc,c)
  if loc == PRIO_TOGRAVE then
    return (FieldCheck(5,NobleFilter)>0 or Lvl5Check()) and SummonHighSally() and NobleSSCheck()
  end
  if loc == PRIO_TOHAND then
    return HasID(AIGrave(),92125819,true)
  end
end
function R5torigusCond(loc,c)
  if loc == PRIO_TOGRAVE then
    return c.xyz_material_count==0 and PriorityCheck(AIGrave(),PRIO_TOFIELD,1,NobleMonsterFilter)>4
  end
end
function TableCond(loc,c)
  if loc == PRIO_TOHAND then
    return not HasID(UseLists({AIHand(),AIST()}),55742055,true)
  end
end

function GawaynCheck()
  return HasID(AIHand(),19680539,true) and DualityCheck() and Duel.GetCurrentPhase()~=PHASE_END and not UseMedraut()
end

function SummonBorz(ss)
  return (((ArmsAvailable()>0 or ArmsRequip()) and OPTCheck(47120245) 
  and ArmsCount(AIDeck(),false,false,true)>3
  and (ss or not Duel.CheckNormalSummonActivity(player_ai))) or GawaynCheck() and not ss
  or ArmsAvailable()>0 and FieldCheck(5,NobleMonsterFilter,9577205)==1 and SummonR5torigus())
  and not UseMedraut()
end
function SummonMedraut(ss)
  return ((ArmsAvailable(true)>0 or ArmsAvailable()>1 or (ArmsAvailable()>0 and not ss 
  and not HasID(AIHand(),47120245,true) and not HasID(AIHand(),00000997,true)))
  and #AIMon()==0 and OPTCheck(59057152) and DualityCheck()
  and (ss or not Duel.CheckNormalSummonActivity(player_ai))) or GawaynCheck() and not ss
  or ArmsAvailable()>0 and FieldCheck(5,NobleMonsterFilter,9577205)==1 and SummonR5torigus()
end
function SummonChad(ss)
  return (((OPTCheck(13391185) and (ss or not Duel.CheckNormalSummonActivity(player_ai)))
  and ArmsAvailable()>0 and PriorityCheck(AIGrave(),PRIO_TOHAND,1,NobleMonsterFilter)>2) 
  or GawaynCheck()) and not UseMedraut()
end
function SummonBedwyr(ss)
  return (((OPTCheck(00000999) and (ss or not Duel.CheckNormalSummonActivity(player_ai)))
  and (ArmsAvailable()>0 and PriorityCheck(AIBanish(),PRIO_TOHAND,1,NobleOrArmsFilter)>0
  or ArmsAvailable()>0 and HasID(AIBanish(),19680539,true))) or GawaynCheck())
  and not UseMedraut()
end
function SummonPeredur(ss)
  return (ArmsAvailable()>0 and (ss or not Duel.CheckNormalSummonActivity(player_ai))
  or FieldCheck(5,NobleMonsterFilter,9577205)==1 and SummonR5torigus())
  and not UseMedraut()
end
function BlackSallyFilter(c)
  return NobleMonsterFilter(c) and bit32.band(c.type,TYPE_NORMAL)>0
end
function UseBlackSally()
  return MP2Check() and (ArmsAvailable()==0 or PriorityCheck(AIMon(),PRIO_TOGRAVE,1,NobleMonsterFilter)>2)
end
function SummonBlackSally()
  return (HasID(AIGrave(),10736540,true) and SummonHighSally() 
  and FieldCheck(5,NobleMonsterFilter)==0 and not (HasID(AIMon(),47120245,true) and UseBorz()
  or HasID(AIMon(),73359475,true) and ArmsAvailable>0 and ArmsCount(AIGrave,false,true,true)>0)
  or FieldCheck(5,NobleMonsterFilter,83519853)==1 and SummonR5torigus()
  or ArmsAvailable()==0 and not ArmsRequip() and not OPTCheck(19748583)
  and not (FieldCheck(4,NobleMonsterFilter)==2 and SummonR4torigus()))
  and not UseMedraut()
end
function UseBrothers()
  return PriorityCheck(AIGrave(),PRIO_TODECK,3,NobleFilter)>1 and OPTCheck(57690191)
end
function ChainBrothers()
  return HasID(AIHand(),95772051,true) or HasID(AIHand(),93085839,true) 
  or CardsMatchingFilter(AIHand(),LevelFilter,4)>1 and SummonR4torigus()
end
function SummonBrothers()
  return OPTCheck(57690191) and (PriorityCheck(AIGrave(),PRIO_TODECK,6,NobleFilter)>1
  or PriorityCheck(AIGrave(),PRIO_TODECK,3,NobleFilter)>4 or ChainBrothers() and not ss)
  and (ss or not Duel.CheckNormalSummonActivity(player_ai))
  and not UseMedraut()
end
function SetBrothers()
  return (Duel.GetTurnCount()==1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
  and (not HasID(AIST(),55742055,true) or TableCount()<6)
end
function UseArfDestroy()
  return CardsMatchingFilter(OppField(),ArfFilter)>0
end
function SummonEachtar()
  return (HasID(AIMon(),00000999,true) or PriorityCheck(AIGrave(),PRIO_BANISH,2,NobleMonsterFilter)>2)
  and (FieldCheck(5)==1 and SummonR5torigus() or HasID(AIGrave(),10736540,true) and SummonHighSally() 
  or #AIMon()==0 ) and not UseMedraut()
end

function UseCaliburn()
  return EquipTargetCheck(AIMon()) or ArmsCount(AIHand(),false,true)>1
  or OppHasStrongestMonster()
end
function UseArf()
  return UseArfDestroy() or (EquipTargetCheck(AIMon()) and ArmsCount(AIHand(),true,true)==1)
end
function UseDestiny()
  return (ArmsCount(AIHand(),false,true)>1 or EquipTargetCheck(AIMon()))
  and CardsMatchingFilter(AIMon(),FilterRace,RACE_WARRIOR)>0
end
function UseGallatin()
  return (ArmsCount(AIHand(),false,true)>1 or EquipTargetCheck(AIMon())
  or OppHasStrongestMonster())
  and CardsMatchingFilter(AIMon(),FilterRace,RACE_WARRIOR)>0
end
function UseGwen()
  return true
end
function UseExcaliburn()
  return (ArmsCount(AIHand(),false,true)>1 or EquipTargetCheck(AIMon()))
  and CardsMatchingFilter(AIMon(),FilterRace,RACE_WARRIOR)>0
end

function BorzFilter(c)
  return c.id == 47120245 and c.equip_count>0 
  and CardsMatchingFilter(c:get_equipped_cards(),ArmsFilter)>0
end
function UseBorz()
  return OPTCheck(47120245) and (HasID(AIMon(),47120245,true,nil,nil,nil,BedwyrFilter) 
  or ArmsAvailable()>0 or skiparms) and CardsMatchingFilter(AIDeck(),ArmsFilter)>2
end
function UseChad(skiparms)
  return OPTCheck(13391185) 
  and PriorityCheck(AIGrave(),PRIO_TOHAND,1,NobleMonsterFilter)>1
end
function BedwyrFilter(c)
  return c.id == 00000999 and c.equip_count>0 
  and CardsMatchingFilter(c:get_equipped_cards(),ArmsFilter)>0
end
function UseBedwyr(skiparms)
  return OPTCheck(00000999) and (HasID(AIMon(),00000999,true,nil,nil,nil,BedwyrFilter)
  or ArmsAvailable()>0 or skiparms) and CardsMatchingFilter(AIBanish(),NobleOrArmsFilter)>0
end
function SummonMerlin()
  return DualityCheck() and OPTCheck(00000997) and not UseMedraut()
  and not (HasID(AIHand(),59057152,true) and SummonMedraut())
  and not (HasID(AIHand(),47120245,true) and SummonBorz() and not SummonMedraut(true))
end
function SummonDrystan()
  return ArmsAvailable()>0 and OPTCheck(53550467) 
  and DestroyCheck(OppField(),false,FilterPosition,POS_FACEUP)>0
  and not UseMedraut()
end
function HighSallyFilter(c)
  return c:is_affected_by(EFFECT_INDESTRUCTABLE_BATTLE)==0
  and c:is_affected_by(EFFECT_CANNOT_BE_BATTLE_TARGET)==0
  and c:is_affected_by(EFFECT_INDESTRUCTABLE_COUNT)==0
  and bit32.band(c.type,TYPE_PENDULUM)==0
end
function HighSallySummonFilter(c)
  return HighSallyFilter(c) and c.attack<2100+NobleATKBoost(1)
end
function UseHighSally()
  ApplyATKBoosts(OppMon())
  return GlobalBPAllowed and CardsMatchingFilter(OppMon(),HighSallySummonFilter,true)>0
end
function SummonHighSally()
  return DualityCheck() and HasID(AIExtra(),83519853,true) and UseHighSally()
end
function SummonLady()
  return (FieldCheck(4,NobleKnightFilter)==1 or HasID(AIGrave(),92125819,true))
  and SummonHighSally() and not UseMedraut()
end
function UseLady()
  return FieldCheck(5,NobleKnightFilter)>0 and not UseMedraut() 
end
function UseMedraut(skiparms,skipmon)
  return DualityCheck() and OPTCheck(59057152)
  and (skipmon or  #AIMon()==1 and HasID(AIMon(),59057152,true)
  and (skiparms or ArmsAvailable()>0 or #AIMon()==1 and EquipCheck(AIMon()[1])))  
end
function SummonGawayn()
  return ((SummonR4torigus() or SummonChainNoble()) and FieldCheck(4,NobleFilter)==1 
  or SummonHighSally() and HasID(AIDeck(),10736540,true) and HasID(AIExtra(),34086406,true) 
  and (FieldCheck(5,NobleFilter)>0 and FieldCheck(4,NobleFilter)==1
  or ((HasID(AIMon(),47120245,true) or HasID(AIMon(),59057152,true) 
  and (FieldCheck(4,NobleFilter)==2 or FieldCheck(4,NobleFilter)==1 and CardsMatchingFilter(AIHand(),FilterID,19680539)>1))
  and (HasID(UseLists({AIHand(),AIGrave()}),95772051,true) or ArmsAvailable()>0))))
  and not UseMedraut()
end
function SummonR4torigus()
  return HasID(AIExtra(),21223277,true) and ArmsCount(UseLists({AIST(),AIGrave()}),false,true,true)>2
  and (OppHasStrongestMonster() or #OppST()>1)
  and not (HasID(AIMon(),13391185,true) and ArmsAvailable()>0 and UseChad())
  and not (HasID(AIMon(),00000999,true) and ArmsAvailable()>0 and UseBedwyr()
  and not SummonGawayn())
end
function UseR4torigus()
  return DestroyCheck(OppST())>0
  and not (HasID(AIMon(),13391185,true) and UseChad() and ArmsAvailable()>0)
  and not (HasID(AIMon(),00000999,true) and UseBedwyr() and ArmsAvailable()>0)
end
function SummonR5torigus()
  return HasID(AIExtra(),10613952,true) and ArmsCount(AIGrave(),false,true)>1
  and OppHasStrongestMonster() and DestroyCheck(OppMon())
end
function UseR5torigus()
  return DestroyCheck(OppMon())>0
end
function UseTable()
  return not HasID(AIST(),55742055,true) and CardsMatchingFilter(UseLists({AIField(),AIGrave()}),NobleFilter)>1
end

function SummonChainNoble()
  return HasID(AIExtra(),34086406,true) and NobleSSCheck() 
  and (SummonHighSally() and HasID(AIDeck(),10736540,true) and (FieldCheck(5,NobleFilter)>0 
  or (FieldCheck(4,NobleFilter)>2 and Lvl5Check()))
  or HasID(AIDeck(),19748583,true) and OPTCheck(19748583) and ArmsAvailable(false,false,false,true)==0)
end
function UseChapter()
  return HasID(AIGrave(),83519853,true)
  or HasID(AIGrave(),59057152,true) and UseMedraut(true,true)
  or HasID(AIGrave(),13391185,true) and UseChad(true)
  or HasID(AIGrave(),00000999,true) and UseBedwyr(true)
  or HasID(AIGrave(),00000999,true) and ArmsCount(AIDeck(),false,false,true)>3
end
function NobleInit(cards)
  local Act = cards.activatable_cards
  local Sum = cards.summonable_cards
  local SpSum = cards.spsummonable_cards
  local Rep = cards.repositionable_cards
  local SetMon = cards.monster_setable_cards
  local SetST = cards.st_setable_cards
  if HasID(Act,00691925) then -- test
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,23562407,false,nil,LOCATION_ONFIELD) then -- Caliburn LP Recovery
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,83438826,false,nil,LOCATION_ONFIELD) and UseArfDestroy() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,00000998) and UseChapter() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,34086406,false,545382497) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,10736540) and UseLady() then 
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Sum,10736540) and SummonLady() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Act,21223277) and UseR4torigus() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,10613952) and UseR5torigus() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,00000997) then -- Merlin
    OPTSet(00000997)
    GlobalNobleSS = Duel.GetTurnCount()
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,59057152) and UseMedraut() then -- Medraut
    GlobalMedraut = 1
    OPTSet(59057152)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,47120245) then -- Borz
    OPTSet(47120245)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(SpSum,34086406) and SummonChainNoble() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,83519853) and SummonHighSally() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(Act,13391185) and UseChad() then
    OPTSet(13391185)
    GlobalCardMode = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,00000999) and UseBedwyr() then
    OPTSet(00000999)
    GlobalCardMode = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,57690191) and UseBrothers() then
    OPTSet(57690191)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,95772051,false,nil,LOCATION_HAND+LOCATION_GRAVE) and SummonBlackSally() then
    GlobalCardMode = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Sum,00000997) and SummonMerlin() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,59057152) and SummonMedraut() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,47120245) and SummonBorz() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,13391185) and SummonChad() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,00000999) and SummonBedwyr() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,53550467) and SummonDrystan() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,19680539) and SummonGawayn() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,21223277) and SummonR4torigus() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,10613952) and SummonR5torigus() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(Sum,57690191) and SummonBrothers() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Act,95772051,false,nil,LOCATION_MZONE) and UseBlackSally() then
    GlobalCardMode = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,83438826,false,nil,nil,POS_FACEDOWN) and UseArf() then
    GlobalCardMode = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,83438826,false,nil,LOCATION_HAND) and UseArf() then
    GlobalCardMode = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,23562407,false,nil,nil,POS_FACEDOWN) and UseCaliburn() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,23562407,false,nil,LOCATION_HAND) and UseCaliburn() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,07452945) and UseDestiny() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,14745409) and UseGallatin() then
    GlobalGallatinTurn[Act[CurrentIndex].cardid]=Duel.GetTurnCount()
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,46008667,false,nil,LOCATION_HAND) and UseExcaliburn() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,46008667,false,nil,nil,POS_FACEDOWN) and UseExcaliburn() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,19748583,false,nil,LOCATION_GRAVE) and UseGwen() then
    OPTSet(19748583)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,19748583,false,nil,LOCATION_HAND) and UseGwen() then
    OPTSet(19748583)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Sum,73359475) and #AIMon() < 2 then -- Peredur
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,92125819) and #AIMon() < 2 then -- Artorigus
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Sum,19680539) and #AIMon() == 0 then -- Gawayn
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Act,93085839) and SummonEachtar() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,55742055) and UseTable() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(SetMon,57690191) and SetBrothers() then
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  return nil
end
function MedrautTarget(cards)
  if GlobalMedraut == 1 then
    GlobalMedraut = nil
    return Add(cards,PRIO_TOFIELD)
  else
    return Add(cards,PRIO_TOGRAVE)
  end
end
function EquipTargetCheckFunc(cards,id,func,opt,skipeqcheck)
  for i=1,#cards do
    if (((id== nil or cards[i].id == id and (opt==nil and func() or opt and func(opt))) and GetMultiple(cards[i].cardid)==0) 
    and (skipeqcheck or not EquipCheck(cards[i])))
    and CurrentMonOwner(cards[i].cardid) == 1
    then
      SetMultiple(cards[i].cardid)
      return {i}
    end
  end
  return nil
end
function EquipTargetCheck(cards)
  local result = nil
  result = EquipTargetCheckFunc(cards,59057152,UseMedraut,true)
  if result then return result end
  result = EquipTargetCheckFunc(cards,47120245,function() return ArmsCount(AIDeck())>3 end,true) 
  if result then return result end
  result = EquipTargetCheckFunc(cards,13391185,UseChad,true) 
  if result then return result end
  result = EquipTargetCheckFunc(cards,00000999,UseBedwyr,true) 
  if result then return result end
  result = EquipTargetCheckFunc(cards,47120245,function() return DestroyCheck(OppField(),false,FilterPosition,POS_FACEUP)>0 and OPTCheck(53550467) end,nil,true) 
  if result then return result end
  result = EquipTargetCheckFunc(cards,73359475,function() return true end) 
  if result then return result end
  if OppHasStrongestMonster() then
    
  end
  return nil
end
function EquipTarget(cards,id)
  result = EquipTargetCheck(cards) 
  if result then return result end
  result = EquipTargetCheckFunc(cards) 
  if result then return result end
  for i=1,#cards do
    if CurrentMonOwner(cards[i].cardid) == 1 then
      return {i}
    end
  end
  return {math.random(#cards)}
end
function BorzTarget(cards,min)
  if min == 3 then
    return Add(cards,PRIO_TOHAND,3)
  else
    return {math.random(#cards)}
  end
end
function ArfTarget(cards,c)
  if GlobalCardMode == 1 then
    GlobalCardMode = nil
    return EquipTarget(cards)
  else
    return BestTargets(cards)
  end
end
function ExcaliburnTarget(cards,c)
  if ArmsFilter(cards[1]) then
    return EquipTarget(cards)
  end
  return Add(cards,PRIO_TOFIELD)
end
function MerlinTarget(cards)
  return Add(cards,PRIO_TOFIELD)
end
function LadyTarget(cards)
  return {math.random(#cards)}
end


function HighSallyTarget(cards)
  if Duel.GetCurrentPhase() == PHASE_BATTLE then
    return Add(cards)
  else
    local result = ArmsByAtk(cards,2100)
    if result then
      return result
    end
    return Add(cards,PRIO_TOFIELD)
  end
  return {math.random(#cards)}
end
function DrystanTarget(cards)
  OPTSet(53550467)
  return BestTargets(cards,1,TARGET_DESTROY)
end
function BrothersTarget(cards,min)
  if min == 3 then
    return Add(cards,PRIO_TODECK,3)
  else
    return Add(cards,PRIO_TOFIELD,math.min(min,2))
  end
end
function ArmsTargets(cards,max)
  local result = {}
  for i=1,#cards do
    if cards[i].owner == 1 and cards[i]:get_equip_target()
    and (cards[i].id == 23562407 and OPTCheck(23562407) 
    or cards[i].id == 14745409 and OPTCheck(14745409) 
    and GlobalGallatinTurn[cards[i].cardid]<Duel.GetTurnCount()
    or cards[i]:get_equip_target() and CurrentMonOwner(cards[i]:get_equip_target().cardid)==2)
    then
      result[#result+1]=i
      if #result >= max then break end
    end
  end
  return result
end 

function R4torigusTarget(cards,max)
  if ArmsFilter(cards[1]) and FilterLocation(cards[1],LOCATION_GRAVE) then
    local result = ArmsByAtk(cards,2000)
    if result ~= nil then
      return result
    end 
    return Add(cards,PRIO_TOFIELD)
  end
  if FilterLocation(cards[1],LOCATION_OVERLAY) then
    return Add(cards,PRIO_TOGRAVE)
  end
  local count = DestroyCheck(OppST(),true)
  local targets = {} 
  if count >= max then
    count = max
  end
  if count < max then
    targets = ArmsTargets(cards,max-count)
  end
  return UseLists({BestTargets(cards,count,TARGET_DESTROY),targets})
end
function R5torigusTarget(cards,c)
  if ArmsFilter(cards[1]) and FilterLocation(cards[1],LOCATION_GRAVE) then
    local result = ArmsByAtk(cards,2000)
    if result ~= nil then
      return result
    end 
    return Add(cards,PRIO_TOFIELD)
  end
  if FilterLocation(cards[1],LOCATION_OVERLAY) then
    return Add(cards,PRIO_TOGRAVE)
  end
  if NobleMonsterFilter(cards[1]) and FilterLocation(cards[1],LOCATION_GRAVE) then
    return Add(cards,PRIO_TOFIELD)
  end
  return BestTargets(cards,1,TARGET_DESTROY)
end
function TableTarget(cards)
  if FilterLocation(cards[1],LOCATION_DECK) then
    return Add(cards,PRIO_TOGRAVE)
  elseif FilterLocation(cards[1],LOCATION_GRAVE) then
    return Add(cards)
  elseif FilterLocation(cards[1],LOCATION_HAND) then
    return Add(cards,PRIO_TOFIELD)
  end
  if result == nil then result = {math.random(#cards)} end
  return result
end
function ChadTarget(cards)
  if GlobalCardMode == 1 then
    GlobalCardMode = nil
    return Add(cards,PRIO_TOHAND)
  end
  return Add(cards,PRIO_TOGRAVE)
end
function BedwyrTarget(cards)
  if GlobalCardMode == 1 then
    GlobalCardMode = nil
    return Add(cards,PRIO_TOHAND)
  end
  return Add(cards,PRIO_TOGRAVE)
end
function BlackSallyTarget(cards,c)
  if GlobalCardMode == 1 then
    GlobalCardMode = nil
    return Add(cards,PRIO_TOGRAVE)
  end
  return Add(cards,PRIO_TOHAND)
end
function ChapterTarget(cards)
  if NobleMonsterFilter(cards[1]) then
    if HasID(cards,83519853,true) then
      return {IndexByID(cards,83519853)}
    end
    if HasID(cards,59057152,true) and UseMedraut(true,true) then
      return {IndexByID(cards,59057152)}
    end
    if HasID(cards,00000999,true) and UseBedwyr(true) then
      return {IndexByID(cards,00000999)}
    end
    if HasID(cards,13391185,true) and UseChad(true) then
      return {IndexByID(cards,13391185)}
    end
    if HasID(cards,47120245,true) and ArmsCount(AIDeck(),false,false,true)>3 then
      return {IndexByID(cards,47120245)}
    end
    return Add(cards,PRIO_TOFIELD)
  else
    return Add(cards,PRIO_TOFIELD)
  end
end
function EachtarTarget(cards)
  return Add(cards,PRIO_BANISH,2)
end
function PeredurTarget(cards)
  Add(cards,PRIO_TOHAND)
end
function NobleCard(cards,min,max,id,c)
  if c then
    id = c.id
  end
  if id == 47120245 then -- Borz
    return BorzTarget(cards,min)
  end
  if id == 59057152 then 
    return MedrautTarget(cards)
  end
  if id == 23562407 or id == 19748583 or id == 07452945 
  or id == 14745409 
  then
    return EquipTarget(cards,id)
  end
  if id == 83438826 then
    return ArfTarget(cards,c)
  end
  if id == 46008667 then
    return ExcaliburnTarget(cards,c)
  end
  if id == 00000997 then
    return MerlinTarget(cards)
  end
  if id == 10736540 then
    return LadyTarget(cards)
  end
  if id == 83519853 then
    return HighSallyTarget(cards)
  end
  if id == 53550467 then
    return DrystanTarget(cards)
  end
  if id == 57690191 then
    return BrothersTarget(cards,min)
  end
  if id == 21223277 then
    return R4torigusTarget(cards,max)
  end
  if id == 10613952 then
    return R5torigusTarget(cards,c)
  end
  if id == 55742055 then
    return TableTarget(cards)
  end
  if id == 13391185 then
    return ChadTarget(cards)
  end
  if id == 00000999 then
    return BedwyrTarget(cards)
  end
  if id == 95772051 then
    return BlackSallyTarget(cards,c)
  end
  if id == 00000998 then
    return ChapterTarget(cards)
  end
  if id == 93085839 then
    return EachtarTarget(cards)
  end
  if id == 73359475 then
    return PeredurTarget(cards)
  end
  return nil
end
function ChainCaliburn()
  OPTSet(23562407)
  SetMultiple(23562407)
  return true
end
function ChainArf()
  OPTSet(83438826)
  SetMultiple(83438826)
  return true
end
function ChainDestiny()
  OPTSet(07452945)
  SetMultiple(07452945)
  return true
end
function ChainGallatin(c)
  OPTSet(14745409)
  SetMultiple(14745409)
  GlobalGallatinTurn[c.cardid]=Duel.GetTurnCount()
  return true
end
function TableSummon()
  return OverExtendCheck() or HasID(AIHand(),95772051,true) or HasID(AIHand(),93085839,true)
  or HasID(AIHand(),57690191,true) or HasID(AIHand(),92125819,true)
end
function NobleChain(cards)
  if HasID(cards,23562407) and ChainCaliburn() then
    return {1,CurrentIndex}
  end
  if HasID(cards,83438826) and ChainArf() then
    return {1,CurrentIndex}
  end
  if HasID(cards,07452945) and ChainDestiny() then
    return {1,CurrentIndex}
  end
  if HasID(cards,14745409) and ChainGallatin(cards[CurrentIndex]) then
    return {1,CurrentIndex}
  end
  if HasID(cards,10736540) then -- Lady
    return {1,CurrentIndex}
  end 
  if HasID(cards,83519853) then -- High Sally
    return {1,CurrentIndex}
  end 
  if HasID(cards,21223277) then -- R4torigus
    return {1,CurrentIndex}
  end
  if HasID(cards,10613952) then -- R5torigus
    return {1,CurrentIndex}
  end
  --print("check")
  for i=1,#cards do
    --print("Card: "..cards[i].id)
    if cards[i].id == 55742055 then
      --print(cards[i].description)
    end
  end
  if HasID(cards,55742055,false,891872883) then -- Table draw
    print("OnSelectChain: Table draw, Description: "..cards[CurrentIndex].description)
    return {1,CurrentIndex}
  end
  if HasID(cards,55742055,false,891872880) then -- Table dump
    print("OnSelectChain: Table dump, Description: "..cards[CurrentIndex].description)
    GlobalTableDump=Duel.GetTurnCount()
    return {1,CurrentIndex}
  end
  if HasID(cards,55742055,false,891872882) then -- Table recover
    print("OnSelectChain: Table recover, Description: "..cards[CurrentIndex].description)
    return {1,CurrentIndex}
  end
  if HasID(cards,55742055,false,891872881) and TableSummon() then -- Table summon
    print("OnSelectChain: Table summon, Description: "..cards[CurrentIndex].description)
    return {1,CurrentIndex}
  end
  if HasID(cards,57690191) and ChainBrothers() then
    GlobalNobleSS = Duel.GetTurnCount()
    return {1,CurrentIndex}
  end
  if HasID(cards,19748583) and ChainGwen() then
    return {1,CurrentIndex}
  end
  return nil
end
function GwenFilter(c) -- for attack boosts
  return c:is_affected_by(EFFECT_IMMUNE_EFFECT)==0
  and c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0
  and c:is_affected_by(EFFECT_INDESTRUCTABLE_COUNT)==0
end
function ChainGwen()
  local source = Duel.GetAttacker()
	local target = Duel.GetAttackTarget()
  if source and target then
    if source:IsControler(player_ai) then
      target = Duel.GetAttacker()
      source = Duel.GetAttackTarget()
    else
    end
    if (target:IsPosition(POS_ATTACK) and source:IsPosition(POS_ATTACK) and source:GetAttack() >= target:GetAttack()
    or target:IsPosition(POS_ATTACK) and source:IsPosition(POS_DEFENCE) and source:GetDefence() >= target:GetAttack()
    or target:IsPosition(POS_DEFENCE) and source:IsPosition(POS_ATTACK) and source:GetAttack() >= target:GetDefence()
    or source:IsPosition(POS_FACEDOWN)
    or source:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE)
    or source:IsHasEffect(EFFECT_INDESTRUCTABLE_COUNT))
    and not source:IsHasEffect(EFFECT_IMMUNE_EFFECT) 
    and not source:IsHasEffect(EFFECT_INDESTRUCTABLE_EFFECT)
    then
      return true
    end
  end
  return false
end
function NobleEffectYesNo(id,card)
  local result = nil
  if id==23562407 and ChainCaliburn() then
    result = 1
  end
  if id==83438826 and ChainArf() then
    result = 1
  end
  if id==07452945 and ChainDestiny() then
    result = 1
  end
  if id==14745409 and ChainGallatin(card) then
    result = 1
  end
  if id == 10736540 or id == 83519853 -- Lady, High Sally
  then 
    result = 1
  end
  if id == 21223277 or id == 10613952 then -- R4torigus, R5torigus
    result = 1
  end
  if id == 55742055 then
    print("OnSelectEffectYesNo: Table, Description: "..card.description)
  end
  --[[if id == 55742055 and card.description == 891872883 then -- Table Draw
    print("Table draw")
    result = 1
  end
  if id == 55742055 and card.description == 891872880 then -- Table Dump
    print("Table dump")
    GlobalTable = 1
    result = 1
  end
  if id == 55742055 and card.description == 891872882 then -- Table Recover
    print("Table recover")
    GlobalTable = 2
    result = 1
  end
  if id == 55742055 and card.description == 891872881 and TableSummon() then -- Table Summon
    print("Table summon")
    GlobalTable = 3
    result = 1
  end]]
  if id == 55742055 and TableCount()>8 then
    result = 1
  end
  if id == 55742055 and GlobalTableDump~=Duel.GetTurnCount() then -- Table
    result = 1
  end
  if id == 57690191 and ChainBrothers() then
    result = 1
  end
  if id == 19748583 and ChainGwen() then
    result = 1
  end
  return result
end
NobleAtt={
95772051, -- Black Sally
19680539, -- Gawayn
53550467, -- Drystan
59057152, -- Medraut
47120245, -- Borz

92125819, -- Artorigus
73359475, -- Peredur
00000997, -- Merlin
00000999, -- Bedwyr

48009503, -- Gandiva
82944432, -- Blade Armor Ninja
60645181, -- Excalibur
21223277, -- R4torigus
10613952, -- R5torigus
83519853, -- High Sally
}
NobleDef={
93085839, -- Eachtar
13391185, -- Chad
57690191, -- Brothers
19748583, -- Gwen
10736540, -- Lady
}
function NoblePosition(id,available)
  result = nil
  for i=1,#NobleAtt do
    if NobleAtt[i]==id then result=POS_FACEUP_ATTACK end
  end
  for i=1,#NobleDef do
    if NobleDef[i]==id then result=POS_FACEUP_DEFENCE end
  end
  if id == 93085839 and GwenCheck() then
    result=POS_FACEUP_ATTACK
  end
  return result
end
