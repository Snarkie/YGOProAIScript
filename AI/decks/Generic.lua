-----
-- Staple cards, or cards used in multiple AI Extra Decks
-----

function SummonExtraDeck(cards,prio)
  local Activatable = cards.activatable_cards
  local Summonable = cards.summonable_cards
  local SpSummonable = cards.spsummonable_cards
  local Repositionable = cards.repositionable_cards
  local SetableMon = cards.monster_setable_cards
  local SetableST = cards.st_setable_cards
---- 
-- use certain effects before doing anything else
---- 
 if prio then 
  
  if HasID(Activatable,12014404,false,nil,nil,POS_DEFENCE) and UseCowboyDef() then 
    return {COMMAND_ACTIVATE,CurrentIndex}                                -- Gagaga Cowboy finish
  end
  if HasID(Activatable,29669359) and UseVolcasaurus() then                -- Volcasaurus finish
    return {COMMAND_ACTIVATE,CurrentIndex}
  end  
  if HasIDNotNegated(Activatable,46772449) and UseFieldNuke(1) then       -- Evilswarm Exciton Knight
    return {COMMAND_ACTIVATE,CurrentIndex}
  end  
  if HasIDNotNegated(Activatable,57774843) and UseFieldNuke(1) then       -- Judgment Dragon
    return {COMMAND_ACTIVATE,CurrentIndex}
  end  
  if HasIDNotNegated(Activatable,39765958) and UseJeweledRDA(Activatable[CurrentIndex],0) then 
    return {COMMAND_ACTIVATE,CurrentIndex}                                -- Hot Red Dragon Archfiend
  end
    
---- 
-- summon certain monsters before anything else
----   
 
  if HasID(SpSummonable,12014404) and SummonCowboyDef() then          
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,29669359) and SummonVolcasaurusFinish() then  
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,46772449) and SummonBelzebuth() then          
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,57774843) and SummonJD() then                 
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,73580471) and UseFieldNuke(-2) then             -- Black Rose
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end

---- 
-- activate removal effects before progressing
---- 
  if HasID(Activatable,04779823) and UseMichael() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end 
  if HasID(Activatable,31924889) and UseArcanite() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,80117527) and UseBigEye() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,22110647,false,353770352) and UseDracossack1(Activatable[CurrentIndex]) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,22110647,false,353770353) and UseDracossack2(Activatable[CurrentIndex]) then
    GlobalCardMode=2
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,38495396) and UsePtolemy() then
    GlobalCardMode = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,15561463) and UseGauntletLauncher() then
    GlobalCardMode = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,94380860) then -- Ragnazero                         
    GlobalCardMode = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
    if HasIDNotNegated(Activatable,22653490) then -- Chidori                         
    GlobalCardMode = 2
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,48739166) then -- Silent Honors ARK
    OPTSet(48739166)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Activatable,82633039,false,1322128625) and UseSkyblaster() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,61344030) then -- Paladynamo
    GlobalCardMode = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  return nil
  
 end
  
---- 
-- Generic extra deck monster summons
---- 

-- Synchro

  if HasID(SpSummonable,08561192) and SummonLeoh() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,39765958) and SummonJeweledRDA(SpSummonable[CurrentIndex]) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end

  if HasID(SpSummonable,83994433) and SummonStardustSpark() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,04779823) and SummonMichael() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end

  if HasID(SpSummonable,31924889) and SummonArcanite() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,33198837) and SummonNaturiaBeast() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,88033975) and SummonArmades() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end



-- XYZ

-- Rank 7

  if HasID(SpSummonable,80117527) and SummonBigEye() then
    return {COMMAND_SPECIAL_SUMMON,IndexByID(SpSummonable,80117527)}
  end

  if HasID(SpSummonable,22110647) and SummonDracossack() then
    return {COMMAND_SPECIAL_SUMMON,IndexByID(SpSummonable,22110647)}
  end
  
-- Rank 6

  if HasID(SpSummonable,38495396) and SummonPtolemy() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end

  if HasID(SpSummonable,15561463) and SummonGauntletLauncher() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end


-- Rank 5

  if HasID(SpSummonable,29669359) and SummonVolcasaurus() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end

-- Rank 4

  if HasID(SpSummonable,94380860) and SummonRagnaZero() then            -- Ragna Zero
    return {COMMAND_SPECIAL_SUMMON,IndexByID(SpSummonable,94380860)}
  end  
  if HasID(SpSummonable,22653490) and SummonChidori() then              -- Chidori
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,48739166) and SummonSharkKnight() then          -- SHArk Knight
    return {COMMAND_SPECIAL_SUMMON,IndexByID(SpSummonable,48739166)}
  end
  if HasID(SpSummonable,82633039) and SummonSkyblaster() then           -- Skyblaster
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,61344030) and SummonPaladynamo() then
    return {COMMAND_SPECIAL_SUMMON,IndexByID(SpSummonable,61344030)}
  end
  if HasID(SpSummonable,34086406) and SummonLavalvalChain() then -- Lavalval Chain
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,34086406,false,545382497) then   
    GlobalCardMode = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(SpSummonable,11398059) and SummonImpKing() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,11398059) then
    GlobalCardMode = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(SpSummonable,21044178) and SummonDweller() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,00581014) and SummonEmeral() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(Activatable,00581014,false,9296225) and UseEmeral() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(SpSummonable,12014404) and SummonCowboyAtt() then -- Cowboy
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(Activatable,12014404) and UseCowboyAtt() then
    Global1PTGunman = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  
-- Rank 3

  if HasID(SpSummonable,15914410) and SummonMechquipped() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSummonable,73964868) and SummonPleiades() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
    if HasID(SpSummonable,95992081) and SummonLeviair() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(Activatable,95992081) and UseLeviair() then
    GlobalCardMode = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  return nil
end


function UseFieldNuke(exclude)
  return DestroyCheck(OppField())-DestroyCheck(AIField())-exclude>0  
end
function SummonBelzebuth()
  local AICards=UseLists({AIHand(),AIField()})
  local OppCards=UseLists({OppHand(),OppField()})
  return #AICards<#OppCards and UseFieldNuke(0)
end
function SummonCowboyDef()
  return AI.GetPlayerLP(2)<=800 
end
function SummonPaladynamo()
  local cards = OppMon()
  local c
  for i=1,#cards do
    c=cards[i]
    if c.attack>=2000 and bit32.band(c.position,POS_FACEUP_ATTACK)>0
    and c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0
    then
      return true
    end 
  end
  return false
end
function SummonLavalvalChain() 
  return (HasID(AIDeck(),82293134,true) or HasID(AIDeck(),90411554,true) and not (HasID(UseLists({AIGrave(),AIHand(),AIMon()}),82293134,true) or not OPTCheck(82293134)))
  and (Duel.GetCurrentPhase() == PHASE_MAIN2 or Duel.GetTurnCount()==1)
end
function SummonChidori()
  local cards = UseLists({OppMon(),OppST()})
  local result={0,0}
  for i=1,#cards do
    if bit32.band(cards[i].position,POS_FACEUP)>0 then result[1]=1 end
    if bit32.band(cards[i].position,POS_FACEDOWN)>0 then result[2]=1 end
  end
  return result[1]+result[2]>=2 
  or Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP_ATTACK,"attack") >= 2300 --for now
  or Get_Card_Att_Def(OppMon(),"defense",">",POS_FACEUP_DEFENCE,"defense") >= 2300
end
function SummonRagnaZero()
  local cards = OppMon()
  for i=1,#cards do
    local c=cards[i]
    if c.attack~=c.base_attack
    and bit32.band(c.position,POS_FACEUP_ATTACK)>0    
    and c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0
    and c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0
    then
      return true
    end 
  end
  return false
end
function SummonImpKing()
  return (HasID(AIDeck(),94656263,true) or HasID(AIDeck(),53573406,true)) and (Chance(30) 
  or HasID(AIMon(),23649496,true) or Chance(70) and HasID(AIGrave(),42940404,true)
  and MP2Check())
end
function SummonDracossack()
  return MP2Check() and not DeckCheck(DECK_MERMAIL)
end
function SummonBigEye()
  return OppHasStrongestMonster() 
  and (Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP_ATTACK,"attack") > 2300
  or Get_Card_Att_Def(OppMon(),"defense",">",POS_FACEUP_DEFENSE,"defense") > 2300)
end
function SummonNaturiaBeast()
  return Chance(50) and Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP_ATTACK,"attack") < 2200
end
function SummonArmades()
  return Duel.GetCurrentPhase() == PHASE_MAIN1 and Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP_ATTACK,"attack") < 2300 
  and Duel.GetTurnCount()>1 and not DeckCheck(DECK_MERMAIL)
end
function SummonStardustSpark()
  return true
end
function JeweledRDAFilter(card,id)
  return card.cardid~=id and bit32.band(card.position,POS_FACEUP_ATTACK)>0 
  and card:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0 and card:is_affected_by(EFFECT_IMMUNE)==0
end
function UseJeweledRDA(card,mod)
  local aimon=AIMon()
  local AITargets=SubGroup(aimon,JeweledRDAFilter,card.cardid)
  local OppTargets=SubGroup(OppMon(),JeweledRDAFilter,card.cardid)
  local diff=(#OppTargets+mod)-#AITargets
  if HasIDNotNegated(aimon,83994433,true) and GlobalStardustSparkActivation[aimon[CurrentIndex].cardid]~=Duel.GetTurnCount() then
    diff = diff+1
  end
  AITargets[#AITargets+1]=card
  ApplyATKBoosts(AITargets)
  ApplyATKBoosts(OppTargets)
  local AIAtt=Get_Card_Att_Def(AITargets,"attack",">",nil,"attack")
  local OppAtt=Get_Card_Att_Def(OppTargets,"attack",">",nil,"attack")
  return #AITargets==1 or diff>1 or (diff<=1 and AIAtt-OppAtt < diff*500)
end
function SummonJeweledRDA(card)
  local OppAtt=Get_Card_Att_Def(OppMon(),"attack",">",POS_FACEUP_ATTACK,"attack")
  return UseJeweledRDA(card,1) or OppAtt > 2500
end
function UseBigEye()
  return true
end
function DarkHoleFilter(card)
  return card:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0 and card:is_affected_by(EFFECT_IMMUNE)==0
end
function UseDarkHole(card)
  local aimon=AIMon()
  local AITargets=SubGroup(aimon,DarkHoleFilter)
  local OppTargets=SubGroup(OppMon(),DarkHoleFilter)
  local diff=#OppTargets-#AITargets
  if HasIDNotNegated(aimon,83994433,true) and GlobalStardustSparkActivation[aimon[CurrentIndex].cardid]~=Duel.GetTurnCount() then
    diff = diff+1
  end
  if HasIDNotNegated(AIST(),27243130,true) or HasID(AIHand(),27243130,true) then
    diff = diff+1
  end
  ApplyATKBoosts(AITargets)
  ApplyATKBoosts(OppTargets)
  local AIAtt=Get_Card_Att_Def(AITargets,"attack",">",nil,"attack")
  local OppAtt=Get_Card_Att_Def(OppTargets,"attack",">",nil,"attack")
  return (#AITargets==0 and OppAtt >= 2000) or diff>1 or (OppAtt >= 2000 and diff<=1 and AIAtt-OppAtt < diff*500)
end
function UseEmeral()
  return true
end
function UseCowboyDef()
  return AI.GetPlayerLP(2) < 1600
end
function UseVolcasaurus()
  return DestroyCheck(OppMon())>0
end
function SummonJD()
  return UseFieldNuke(0) and not HasID(AIMon(),57774843,true) 
  or #OppField()==0 and Duel.GetCurrentPhase()==PHASE_MAIN1 and GlobalBPAllowed
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
function SharkKnightFilter(c)
  return bit32.band(c.position,POS_FACEUP_ATTACK)>0 
  and bit32.band(c.type,TYPE_TOKEN)==0
  and (bit32.band(c.type,TYPE_XYZ+TYPE_SYNCHRO+TYPE_RITUAL+TYPE_FUSION)>0 or c.level>4)
  and bit32.band(c.summon_type,SUMMON_TYPE_SPECIAL)>0 
  and c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0 
end
function SummonSharkKnight(cards)
  return CardsMatchingFilter(OppMon(),SharkKnightFilter)>0 and OppHasStrongestMonster()
  and HasID(AIExtra(),48739166,true) and MP2Check()
end
function CowboyFilter(c)
  return ((c.attack<3000 and bit32.band(c.position,POS_ATTACK)>0
  or c.defense<2500 and bit32.band(c.position,POS_DEFENSE)>0
  and (bit32.band(c.position,POS_FACEUP)>0 or bit32.band(c.status,STATUS_IS_PUBLIC)>0))
  and c:is_affected_by(EFFECT_INDESTRUCTABLE_BATTLE)==0 
  and c:is_affected_by(EFFECT_CANNOT_BE_BATTLE_TARGET)==0)
end
function UseCowboyAtt()
  return CardsMatchingFilter(OppMon(),CowboyFilter)>0 
  and Duel.GetCurrentPhase()==PHASE_MAIN1 and GlobalBPAllowed
end
function SummonCowboyAtt()
  return OppHasStrongestMonster() and UseCowboyAtt()
end
function SkyblasterFilter(c)
  return bit32.band(c.position,POS_FACEUP)>0 and c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0
end
function SummonSkyblaster()
  return OppHasStrongestMonster() and CardsMatchingFilter(OppMon(),SkyblasterFilter)>0 
  and HasID(AIExtra(),82633039,true) and MP2Check()
end
function UseSkyblaster()
  return CardsMatchingFilter(OppField(),SkyblasterFilter)>0
end