function TrapHoleFilter(c)
  return bit32.band(c.type,TYPE_TRAP)>0 
  and (IsSetCode(c.setcode,0x4c) or IsSetCode(c.setcode,0x89))
end
function TraptrixFilter(c)
  return bit32.band(c.type,TYPE_MONSTER)>0 and IsSetCode(c.setcode,0x108a)
end
function HandCount(cards)
  local result = 0
  for i=1,#cards do
    if cards[i].id == 68535320 or cards[i].id == 95929069 then
      result = result+1
    end
  end
  return result
end
function MyrmeleoCond(loc,c)
  if loc == PRIO_HAND then
    return CardsMatchingFilter(AIDeck(),TrapholeFilter)>0
  end
  if loc == PRIO_TOFIELD then
    return CardsMatchingFilter(OppST(),DestroyFilter)>0
  end
  return true
end
function DionaeaCond(loc,c)
  if loc == PRIO_TOHAND then
    return CardsMatchingFilter(AIGrave(),TraptrixFilter)>0
    or HasID(AIHand(),91812341,true)
  end
  if loc == PRIO_TOFIELD then
    return CardsMatchingFilter(AIGrave(),TrapHoleFilter)>0
  end
  return true
end
function FireHandCond(loc,c)
  if loc == LOCATION_TOHAND then
    return HandCount(AICards())==0 and HasID(AIDeck(),95929069,true)
  end
  return true
end
function IceHandCond(loc,c)
  if loc == LOCATION_TOHAND then
    return HandCount(AICards())==0 and HasID(AIDeck(),68535320,true)
  end
  return true
end
function MoralltachFilter(c)
  return bit32.band(c.position,POS_FACEUP)>0 
  and c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0
  and bit32.band(c.status,STATUS_LEAVE_CONFIRMED)==0
  and not DestroyBlacklist(c)
end
function MoralltachCond(loc)
  if loc == PRIO_TOHAND then
    local cards = UseLists({AIHand(),AIST()})
    return HasID(cards,12444060,true) and HasID(AIDeck(),12697630,true)
    or HasID(card,29223325,true)
  end
  if loc == PRIO_TOFIELD then 
    return CardsMatchingFilter(UseLists({OppMon(),OppST()}),MoralltachFilter)>0 
    and Duel.GetTurnPlayer()==1-player_ai
  end
  return true
end
function BeagalltachCond(loc)
  if loc == PRIO_TOHAND then
    local cards = UseLists({AIHand(),AIST()})
    return HasID(card,29223325,true) and HasID(AIDeck(),85103922,true)
  end
  if loc == PRIO_TOFIELD then 
    return MidrashCheck() and HasID(AIST(),85103922,true) and MoralltachCond(PRIO_TOFIELD)
    and Duel.GetTurnPlayer()==1-player_ai
  end
  return true
end
function SanctumCond(loc,c)
  if loc == LOCATION_TOHAND then
    local cards = UseLists({AIHand(),AIST()})
    return (HasID(AIDeck(),85103922,true) 
    or HasID(UseLists({AIHand(),AIST()}),85103922,true) 
    and HasID(AIDeck(),12697630,true))
    and not HasID(cards,12444060,true)
  end
  return true
end
function IgnitionCond(loc,c)
  if loc == LOCATION_TOHAND then
    local cards = UseLists({AIHand(),AIST()})
    return (HasID(cards,85103922,true) 
    or HasID(cards,12697630,true) 
    and HasID(AIDeck(),85103922,true))
    and not HasID(cards,29223325,true)
  end
  return true
end
function CanUseHand()
  return ((HasID(AIMon(),68535320,true) or HasID(AIHand(),68535320,true) 
  and not Duel.CheckNormalSummonActivity(player_ai)) and FireHandCheck() 
  or (HasID(AIMon(),95929069,true) or HasID(AIHand(),95929069,true) 
  and not Duel.CheckNormalSummonActivity(player_ai)) and IceHandCheck())
  and Duel.GetCurrentPhase()==PHASE_MAIN1 and GlobalBPAllowed
end
GlobalDuality = 0
function DualityCheck()
  return Duel.GetTurnCount()~=GlobalDuality
end
function UseDuality()
  return not (CanUseHand() or FieldCheck(4)>1 or FieldCheck(5)>1
  or HandCheck(4)>0 and FieldCheck(4)>0 and not Duel.CheckNormalSummonActivity(player_ai) 
  or HasID(AIHand(),45803070,true) and SummonDionaea() and not Duel.CheckNormalSummonActivity(player_ai)) 
end
function SummonDionaea()
  return DualityCheck() and OverExtendCheck() 
  and (CardsMatchingFilter(AIGrave(),TraptrixFilter)>0
  or FieldCheck(4)==1)
end
function SummonMyrmeleo()
  return OverExtendCheck and (MyrmeleoCond(PRIO_TOHAND) or DualityCheck() and FieldCheck(4)==1)
end
function HandFilter(c,atk)
  return bit32.band(c.position,POS_FACEUP_ATTACK)>0 
  and c.attack > atk and AI.GetPlayerLP(1)+atk-c.attack>800
  and c:is_affected_by(EFFECT_CANNOT_BE_BATTLE_TARGET)==0
end
-- function to determine the lowest attack monster the hands can attack to get their effects
function HandAtt(cards,att)
  local lowest = 999999
  for j=1,#cards do
    if HandFilter(cards[j],att) and cards[j].attack < lowest and lowest > att then
      lowest = cards[j].attack
    end
  end
  return lowest+1
end
function FireHandCheck()
  return DualityCheck() and (CardsMatchingFilter(OppMon(),HandFilter,1600)>0 
  and CardsMatchingFilter(OppMon(),DestroyFilter)>0 and HasID(AIDeck(),95929069,true))
end
function IceHandCheck()
  return DualityCheck() and (CardsMatchingFilter(OppMon(),HandFilter,1400)>0 
  and CardsMatchingFilter(OppST(),DestroyFilter)>0 and HasID(AIDeck(),68535320,true))
end
function SummonFireHand()
  return OverExtendCheck() and DualityCheck() 
  and (FireHandCheck() or FieldCheck(4)==1)
end
function SummonIceHand()
  return OverExtendCheck() and DualityCheck() 
  and (IceHandCheck() or FieldCheck(4)==1)
end
function SetFireHand()
  return OverExtendCheck()
end
function SetIceHand()
  return OverExtendCheck()
end
function UseCotH()
  if Duel.GetTurnPlayer()==player_ai then
    if FieldCheck(4)==1 and GraveCheck(4)>0 and ExtraDeckCheck(TYPE_XYZ,4)>0 and OverExtendCheck() then
      GlobalCardMode = 4
      return true
    end
    if FieldCheck(5)==1 and GraveCheck(5)>0 and ExtraDeckCheck(TYPE_XYZ,5)>0 and OverExtendCheck() then
      GlobalCardMode = 5
      return true
    end
    if Duel.GetCurrentPhase() == PHASE_MAIN1 and GlobalBPAllowed and OverExtendCheck() then
      if HasID(AIGrave(),68535320,true) and FireHandCheck() then
        GlobalCardMode = 1
        GlobalTargetID = 68535320
        return true
      end
      if HasID(AIGrave(),95929069,true) and FireHandCheck() then
        GlobalCardMode = 1
        GlobalTargetID = 95929069
        return true
      end
    end
    if OverExtendCheck() and PriorityCheck(AIGrave(),PRIO_TOFIELD,1,CotHFilter)>3 then
      return true
    end
  end
end
function HATInit(cards)
  local Activatable = cards.activatable_cards
  local Summonable = cards.summonable_cards
  local SpSummonable = cards.spsummonable_cards
  local Repositionable = cards.repositionable_cards
  local SetableMon = cards.monster_setable_cards
  local SetableST = cards.st_setable_cards
  if HasID(Activatable,97077563) and UseCotH() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Activatable,98645731) and UseDuality() then
    GlobalDuality = Duel.GetTurnCount()
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Summonable,68535320) and SummonFireHand() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Summonable,95929069) and SummonIceHand() then
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Summonable,45803070) and SummonDionaea() then
    GlobalCardMode = 1
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(Summonable,91812341) and SummonMyrmeleo() then
    GlobalCardMode = 1
    return {COMMAND_SUMMON,CurrentIndex}
  end
  if HasID(SetableMon,68535320) and SetFireHand() then
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  if HasID(SetableMon,95929069) and SetIceHand() then
    return {COMMAND_SET_MONSTER,CurrentIndex}
  end
  if HasID(SetableST,85103922) and SetArtifacts() then
    return {COMMAND_SET_ST,CurrentIndex}
  end
  if HasID(SetableST,12697630) and SetArtifacts() then
    return {COMMAND_SET_ST,CurrentIndex}
  end
  if HasID(SetableST,12444060) and SetArtifacts() then
    return {COMMAND_SET_ST,CurrentIndex}
  end
  if HasID(SetableST,29223325) and SetArtifacts() then
    return {COMMAND_SET_ST,CurrentIndex}
  end
  return nil
end
function MyrmeleoTarget(cards)
  if GlobalCardMode == 1 then
    GlobalCardMode = nil
    return Add(cards)
  else
    return BestTargets(cards,TARGET_DESTROY)
  end
end
function DionaeaTarget(cards)
  if GlobalCardMode == 1 then
    GlobalCardMode = nil
    return Add(cards,PRIO_TOFIELD)
  else
    return Add(cards,PRIO_TOHAND)
  end
end
function CotHTarget(cards)
  print("CotH target")
  if GlobalCardMode and GlobalCardMode>2 then
    local level = GlobalCardMode
    print("by level: "..level)
    GlobalCardMode = nil
    return Add(cards,PRIO_TOFIELD,1,FilterLevel,level)
  elseif GlobalCardMode == 2 then
    GlobalCardMode = nil
    print("by attack: "..AI.GetPlayerLP(2))
    return Add(cards,PRIO_TOFIELD,1,FilterAttack,AI.GetPlayerLP(2)-ExpectedDamage(2))
  elseif GlobalCardMode == 1 then
    local id = GlobalTargetID
    GlobalCardMode = nil
    GlobalTargetID = nil
    print("by id: "..id) 
    return {IndexByID(cards,id)}
  else
    print("by priority") 
    return Add(cards,PRIO_TOFIELD)
  end
end
function HATCard(cards,min,max,id,c)
  if c then
    id = c.id
  end
  if id == 68535320 or id == 95929069 then -- Fire Hand, Ice Hand
    return BestTargets(cards,TARGET_DESTROY)
  end
  if id == 91812341 then
    return MyrmeleoTarget(cards)
  end
  if id == 45803070 then
    return DionaeaTarget(cards)
  end
  if id == 97077563 then
    return CotHTarget(cards)
  end
  if ID == 98645731 then -- Duality
    return Add(cards)
  end
  return nil
end
function CotHFilter(c)
  return bit32.band(c.type,TYPE_MONSTER)>0 and c:is_affected_by(EFFECT_SPSUMMON_CONDITION)==0 
end
function FinishFilter(c)
  return CotHFilter(c) and ExpectedDamage(2)+c.attack>=AI.GetPlayerLP(2) --and c.attack>=AI.GetPlayerLP(2)
end
function ArtifactCheckGrave(sanctum)
  local MoralltachCheck = HasID(AIGrave(),85103922,true) and Duel.GetTurnPlayer()==1-player_ai
  local BeagalltachCheck = HasID(AIGrave(),12697630,true) and HasID(AIST(),85103922,true) 
  and Duel.GetTurnPlayer()==1-player_ai and MidrashCheck()
  if BeagalltachCheck then
    GlobalCardMode = 1
    GlobalTargetID = 12697630
    GlobalPlayer = 1
    return true
  end
  if MoralltachCheck then
    GlobalCardMode = 1
    GlobalTargetID = 85103922
    GlobalPlayer = 1
    return true
  end
  return false
end
function ChainCotH()
  local targets=CardsMatchingFilter(OppST(),DestroyFilter)
  local targets2=CardsMatchingFilter(OppField(),MoralltachFilter)
  local targets3=CardsMatchingFilter(OppField(),SanctumFilter)
  local targets4=CardsMatchingFilter(OppST(),MSTEndPhaseFilter)
  local e = Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TRIGGERING_EFFECT)
  local c = nil
  if e then
    c = e:GetHandler()
  end
  local MyrmeleoCheck = DestroyCheck(OppST())>0 and HasID(AIGrave(),91812341,true) 
  --local DionaeaCheck = CardsMatchingFilter(AIGrave(),TrapHoleFilter)>0 and Duel.GetCurrentChain()==0
  if RemovalCheck(97077563) and not c:IsCode(12697630) then
    if targets2 > 0 and ArtifactCheckGrave()
    then
      return true
    end
    if MyrmeleoCheck then
      GlobalCardMode = 1
      GlobalTargetID = 91812341
      return true
    end
    return true -- return true anyways to avoid destruction effects that only destroy face-down cards
  end
  if not UnchainableCheck(97077563) then
    return false
  end
  if CardsMatchingFilter(OppField(),SanctumFilter)>0 then
    if targets3 > 0 and ArtifactCheckGrave()
    then
      return true
    end
  end
  if Duel.GetCurrentPhase()==PHASE_BATTLE then
    local source=Duel.GetAttacker()
    local target=Duel.GetAttackTarget()
    if source and source:IsControler(1-player_ai) then
      if targets2 > 0 and ArtifactCheckGrave() then
        return true
      end
    end
    if Duel.GetTurnPlayer() == player_ai and #OppMon()==0 
    and CardsMatchingFilter(AIGrave(),FinishFilter)>0 
    and ExpectedDamage(2)<AI.GetPlayerLP(2)
    then
      GlobalCardMode = 2
      return true
    end
  end
  if Duel.GetCurrentPhase()==PHASE_END and Duel.CheckTiming(TIMING_END_PHASE) and Duel.GetTurnPlayer() == 1-player_ai then
    if targets2 > 0 and ArtifactCheckGrave() then
      return true
    end
    if MyrmeleoCheck and CardsMatchingFilter(OppST(),MSTEndPhaseFilter)>0 then
      GlobalCardMode = 1
      GlobalTargetID = 91812341
      return true
    end
  end
  return false
end
function HATChain(cards)
  if HasID(cards,91812341) then -- Traptrix Myrmeleo
    return {1,CurrentIndex}
  end
  if HasID(cards,45803070) then -- Traptrix Dionaea
    return {1,CurrentIndex}
  end
  if HasID(cards,68535320) then -- Fire Hand
    return {1,CurrentIndex}
  end
  if HasID(cards,95929069) then -- Ice Hand
    return {1,CurrentIndex}
  end
  if HasID(cards,29616929) then -- Traptrix Trap Hole Nightmare
    return {1,CurrentIndex}
  end
  if HasID(cards,63746411) then -- Giant Hand
    return {1,CurrentIndex}
  end
  if HasID(cards,97077563) and ChainCotH() then
    return {1,CurrentIndex}
  end
end
function HATEffectYesNo(id,card)
  local result = nil
  if id == 68535320 or id == 95929069 -- Fire Hand, Ice Hand
  or id == 91812341 or id == 45803070 -- Traptrix Myrmeleo, Dionaea
  or id == 29616929 or id == 63746411 -- Traptrix Trap Hole Nightmare, Giant Hand
  then
    result = 1
  end
  return result
end
HATAtt={
  91812341,45803070,91499077 -- Traptrix Myrmeleo, Dionaea, Gagaga Samurai
}
HATDef={
}
function HATPosition(id,available)
  result = nil
  for i=1,#HATAtt do
    if HATAtt[i]==id then result=POS_FACEUP_ATTACK end
  end
  for i=1,#HATDef do
    if HATDef[i]==id then result=POS_FACEUP_DEFENCE end
  end
  if id == 68535320 or id == 95929069 -- Fire Hand, Ice Hand 
  or id == 63746411 -- Giant Hand
  then
    if Duel.GetTurnPlayer()==player_ai and (Duel.GetCurrentPhase()==PHASE_MAIN1
    and GlobalBPAllowed or bit32.band(Duel.GetCurrentPhase(),PHASE_BATTLE+PHASE_DAMAGE)>0)
    then
      result = POS_FACEUP_ATTACK 
    else
      result = POS_FACEUP_DEFENCE
    end
  end
  return result
end