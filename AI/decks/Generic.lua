-----
-- Staple cards, or cards used in multiple AI Extra Decks
-----
function XYZSummon(index)
  if index == nil then
    index = CurrentIndex
  end
  GlobalMaterial = true
  return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
end
function SummonExtraDeck(cards,prio)
  local Act = cards.activatable_cards
  local Sum = cards.summonable_cards
  local SpSum = cards.spsummonable_cards
  local Rep = cards.repositionable_cards
  local SetMon = cards.monster_setable_cards
  local SetST = cards.st_setable_cards
---- 
-- use certain effects before doing anything else
---- 
 if prio then 
   if HasIDNotNegated(SpSum,07409792) then 
    --return {COMMAND_SPECIAL_SUMMON,CurrentIndex}                                -- test
  end
  if HasIDNotNegated(Act,12014404,false,nil,nil,POS_DEFENCE) and UseCowboyDef() then 
    return {COMMAND_ACTIVATE,CurrentIndex}                                -- Gagaga Cowboy finish
  end
  if HasIDNotNegated(Act,29669359) and UseVolcasaurus() then                -- Volcasaurus finish
    return {COMMAND_ACTIVATE,CurrentIndex}
  end  
  if HasIDNotNegated(Act,46772449) and UseFieldNuke(1) then       -- Evilswarm Exciton Knight
    return {COMMAND_ACTIVATE,CurrentIndex}
  end  
  if HasIDNotNegated(Act,57774843) and UseFieldNuke(1) then       -- Judgment Dragon
    return {COMMAND_ACTIVATE,CurrentIndex}
  end  
  if HasIDNotNegated(Act,39765958) and UseJeweledRDA(Act[CurrentIndex],0) then 
    return {COMMAND_ACTIVATE,CurrentIndex}                                -- Hot Red Dragon Archfiend
  end
  if HasIDNotNegated(Act,53129443) and UseDarkHole() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,12580477) and UseRaigeki() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end  
  if HasIDNotNegated(Act,45986603) and UseSnatchSteal() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,89882100) then  -- Night Beam
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,05133471,nil,nil,LOCATION_GRAVE) 
  and UseGalaxyCyclone(2) 
  then  
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,05133471,nil,nil,LOCATION_HAND+LOCATION_ONFIELD) 
  and UseGalaxyCyclone(1) 
  then  
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
---- 
-- summon certain monsters before anything else
----   
  if HasIDNotNegated(SpSum,12014404) and SummonCowboyDef() then          
    return XYZSummon()
  end
  if HasIDNotNegated(SpSum,29669359) and SummonVolcasaurusFinish() then  
    return XYZSummon()
  end
  if HasIDNotNegated(SpSum,29669359) and SummonVolcaGaiaFinish(1) then  
    return XYZSummon()
  end
  if HasIDNotNegated(SpSum,91949988) and SummonVolcaGaiaFinish(2) then  
    return XYZSummon()
  end
  if HasIDNotNegated(SpSum,88120966) and SummonGiantGrinderFinish(SpSum[CurrentIndex]) then
    return XYZSummon()
  end
  if HasIDNotNegated(SpSum,46772449) and SummonBelzebuth() then          
    return XYZSummon()
  end
  if HasID(SpSum,57774843) and SummonJD() then                 
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(SpSum,73580471) and UseFieldNuke(-2) then             -- Black Rose
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(SpSum,16195942) and SummonRebellionFinish() then 
    return XYZSummon()
  end
  if HasIDNotNegated(SpSum,31320433) and SummonNightmareSharkFinish() then
    return XYZSummon()
  end
  if HasIDNotNegated(SpSum,66547759) and SummonLancelotFinish() then
    return XYZSummon()
  end
  if HasIDNotNegated(SpSum,85909450,SummonHPPDFinish) then
    return XYZSummon()
  end
  if HasIDNotNegated(SpSum,31437713) and SummonHeartlanddracoFinish() then
    return XYZSummon()
  end
  if HasIDNotNegated(SpSum,00005509) and SummonUtopiaLightningFinish(SpSum[CurrentIndex],2) then
    return XYZSummon()
  end
  if HasIDNotNegated(SpSum,84013237) and SummonUtopiaLightningFinish(SpSum[CurrentIndex],1) then
    return XYZSummon()
  end
---- 
-- activate removal effects before progressing
---- 
  if HasIDNotNegated(Act,04779823) and UseMichael() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end 
  if HasIDNotNegated(Act,31924889) and UseArcanite() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,80117527) and UseBigEye() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,88120966) and UseGiantGrinder(Act[CurrentIndex]) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,22110647,false,353770352) and UseDracossack1(Act[CurrentIndex]) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,22110647,false,353770353) and UseDracossack2(Act[CurrentIndex]) then
    GlobalCardMode=2
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,38495396) and UsePtolemy() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,15561463) and UseGauntletLauncher() then
    GlobalCardMode = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,94380860) then -- Ragnazero                         
    GlobalCardMode = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
    if HasIDNotNegated(Act,22653490) then -- Chidori                         
    GlobalCardMode = 2
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,48739166) then -- Silent Honors ARK
    OPTSet(48739166)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,82633039,false,1322128625) and UseSkyblaster() then
    OPTSet(82633039)
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,10406322) and UseAlsei(Act[CurrentIndex]) then
    GlobalActivatedCardID = 10406322
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,73964868,nil,nil,nil,nil,ChainPleiades)  then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,61344030) then -- Paladynamo
    GlobalCardMode = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,50321796,UseBrionac) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,16195942) and UseRebellion() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,31320433) and UseNightmareShark() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(Act,31437713) and UseHeartlanddraco() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  return nil
 end
 
 -- summon Gaia Dragon after removal effects
   if HasIDNotNegated(SpSum,91949988) and SummonGaiaDragonFinish(SpSum[CurrentIndex]) then
    return XYZSummon()
  end
  
---- 
-- Generic extra deck monster summons
---- 

-- Synchro
  if HasID(SpSum,08561192) and SummonLeoh(SpSum[CurrentIndex]) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,39765958) and SummonJeweledRDA(SpSum[CurrentIndex]) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end

  if HasID(SpSum,83994433) and SummonStardustSpark(SpSum[CurrentIndex]) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,44508094,SummonStardust) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,23693634,SummonColossal) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,04779823) and SummonMichael(SpSum[CurrentIndex]) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,82044279) and SummonClearWing(SpSum[CurrentIndex]) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end

  if HasIDNotNegated(SpSum,31924889) and SummonArcanite() then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(SpSum,33698022,SummonMoonlightRose) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasIDNotNegated(SpSum,98012938,SummonVulcan) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,50321796,SummonBrionac) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,33198837) and SummonNaturiaBeast(SpSum[CurrentIndex]) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,88033975) and SummonArmades(SpSum[CurrentIndex]) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,90953320,SummonLibrarian) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end
  if HasID(SpSum,26593852,SummonCatastor) then
    return {COMMAND_SPECIAL_SUMMON,CurrentIndex}
  end

-- XYZ

-- Rank 8
  if HasIDNotNegated(SpSum,01639384) and SummonFelgrand(SpSum[CurrentIndex]) then
    return XYZSummon()
  end
  if HasIDNotNegated(SpSum,88120966) and SummonGiantGrinder(SpSum[CurrentIndex]) then
    return XYZSummon()
  end
  if HasIDNotNegated(SpSum,10406322) and SummonAlsei(SpSum[CurrentIndex]) then
    return XYZSummon()
  end
  if HasID(SpSum,73445448) and SummonZombiestein(SpSum[CurrentIndex]) then
    return XYZSummon()
  end
  
-- Rank 7
  if HasIDNotNegated(SpSum,80117527) and SummonBigEye() then
    return {COMMAND_SPECIAL_SUMMON,IndexByID(SpSum,80117527)}
  end

  if HasIDNotNegated(SpSum,22110647) and SummonDracossack(SpSum[CurrentIndex]) then
    return {COMMAND_SPECIAL_SUMMON,IndexByID(SpSum,22110647)}
  end
  
-- Rank 6
  if HasID(SpSum,38495396) and SummonPtolemy(SpSum[CurrentIndex]) then
    return XYZSummon()
  end
  if HasIDNotNegated(SpSum,15561463) and SummonGauntletLauncher() then
    return XYZSummon()
  end
  if HasID(SpSum,91949988) and SummonGaiaDragon(SpSum[CurrentIndex]) then
    return XYZSummon()
  end

-- Rank 5
  if HasID(SpSum,73964868) and SummonPleiades(SpSum[CurrentIndex]) then
    return XYZSummon()
  end
  if HasID(SpSum,29669359) and SummonVolcasaurus(SpSum[CurrentIndex]) then
    return XYZSummon()
  end

-- Rank 4
  if HasID(SpSum,94380860) and SummonRagnaZero(SpSum[CurrentIndex]) then            -- Ragna Zero
    return XYZSummon()
  end  
  if HasIDNotNegated(SpSum,22653490,SummonChidori,1) then              -- Chidori
    return XYZSummon()
  end
  if HasIDNotNegated(SpSum,48739166) and SummonSharkKnight() then          -- SHArk Knight
    return XYZSummon()
  end
  if HasIDNotNegated(SpSum,82633039) and SummonSkyblaster() then           -- Skyblaster
    return XYZSummon()
  end
  if HasID(SpSum,26329679) and SummonOmega(SpSum[CurrentIndex]) then 
    return XYZSummon()
  end
  if HasID(SpSum,16195942) and SummonRebellion(SpSum[CurrentIndex]) then 
    return XYZSummon()
  end
  if HasIDNotNegated(SpSum,61344030) and SummonPaladynamo() then
    return XYZSummon()
  end
  if HasIDNotNegated(SpSum,22653490,SummonChidori,2) then              -- Chidori
    return XYZSummon()
  end
  if HasIDNotNegated(SpSum,63746411) and SummonGiantHand() then
    return XYZSummon()
  end
  if HasIDNotNegated(SpSum,91499077) and SummonGagagaSamurai() then
    return XYZSummon()
  end
  if HasIDNotNegated(Act,91499077) and UseGagagaSamurai() then
    Global1PTGunman = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(SpSum,34086406) and SummonLavalvalChain() then -- Lavalval Chain
    return XYZSummon()
  end
  if HasIDNotNegated(Act,34086406,false,545382497) and UseLavalvalChain() then   
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(SpSum,11398059) and SummonImpKing(SpSum[CurrentIndex]) then
    return XYZSummon()
  end
  if HasIDNotNegated(Act,11398059) then
    GlobalCardMode = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(SpSum,21044178) and SummonDweller() then
    return XYZSummon()
  end
  if HasIDNotNegated(SpSum,00581014) and SummonEmeral() then
    return XYZSummon()
  end
  if HasIDNotNegated(Act,00581014,false,9296225) and UseEmeral() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasID(SpSum,21501505) and SummonCairngorgon(SpSum[CurrentIndex]) then
    return XYZSummon()
  end
  if HasIDNotNegated(SpSum,93568288) and SummonRhapsody() then
    return XYZSummon()
  end
  if HasIDNotNegated(SpSum,12014404) and SummonCowboyAtt() then -- Cowboy
    return XYZSummon()
  end
  if HasIDNotNegated(Act,12014404) and UseCowboyAtt() then
    Global1PTGunman = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  
-- Rank 3
  if HasIDNotNegated(SpSum,78156759) and SummonZenmaines(SpSum[CurrentIndex]) then
    GlobalDWSS=2
    return XYZSummon()
  end
  if HasID(Rep,78156759) and RepoZenmaines(Rep[CurrentIndex]) then
    return {COMMAND_CHANGE_POS,CurrentIndex}
  end
  if HasIDNotNegated(SpSum,15914410) and SummonMechquipped() then
    return XYZSummon()
  end
  if HasIDNotNegated(SpSum,95992081) and SummonLeviair() then
    return XYZSummon()
  end
  if HasIDNotNegated(Act,95992081) and UseLeviair() then
    GlobalCardMode = 1
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  

  
-- if the opponent still has stronger monsters, use Raigeki  
  if HasID(Act,12580477) and UseRaigeki2() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end 
-- use Soul Charge when other plays have been exhausted
  if HasID(Act,54447022) and UseSoulCharge() then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,01845204) and UseInstantFusion(2) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,01845204) and UseInstantFusion(1) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  if HasIDNotNegated(Act,01845204) and UseInstantFusion(3) then
    return {COMMAND_ACTIVATE,CurrentIndex}
  end
  return nil
end
function SummonStardust(c)
  return OppGetStrongestAttDef()<2500 and MP2Check()
end
function SummonColossal(c)
  return BattlePhaseCheck() and (OppGetStrongestAttack()==c.attack
  or Negated(c) and OppHasStrongestMonster() 
  and OppGetStrongestAttDef()<=c.attack)
end
function BrionacFilter(c)
  return PriorityTarget(c)
  and not ToHandBlacklist(c.id)
  and Affected(c,TYPE_MONSTER,6)
  and Targetable(c,TYPE_MONSTER)
end
function UseBrionac(c)
  return NotNegated(c) 
  and CardsMatchingFilter(OppField(),BrionacFilter)>0
  and PriorityCheck(AIHand(),PRIO_TOGRAVE)>2
end
function SummonBrionac(c)
  return NotNegated(c) 
  and CardsMatchingFilter(OppMon(),BrionacFilter)>0
  and PriorityCheck(AIHand(),PRIO_TOGRAVE)>2
end
function SummonCatastor(c)
  return NotNegated(c) and OppHasStrongestMonster()
  and CardsMatchingFilter(OppMon(),CatastorFilter)>0
  or Negated(c) and OppHasStrongestMonster() 
  and OppGetStrongestAttDef()<=c.attack
end
function SummonLibrarian(c)
  return NotNegated(c) and CardsMatchingFilter(AIMon(),FilterType,TYPE_TUNER)>1
  or Negated(c) and OppHasStrongestMonster() 
  and OppGetStrongestAttDef()<=c.attack
end
function SummonZombiestein(c)
  return MP2Check() and OppHasStrongestMonster() --and OppGetStrongestAttack()>2800
  and OppGetStrongestAttack()<4500
end
function SummonFelgrand()
  return MP2Check() and OppGetStrongestAttack()<2800
  and not SkillDrainCheck()
end
function UseFieldNuke(exclude)
  return (DestroyCheck(OppField())+exclude)-DestroyCheck(AIField())>0 
end
function SummonBelzebuth()
  if DeckCheck(DECK_CONSTELLAR) and HasIDNotNegated(AIMon(),70908596,true)
  and CardsMatchingFilter(AIMon(),ConstellarNonXYZFilter)>1
  and (SummonVolcasaurusFinish() or SummonVolcaGaiaFinish(1))
  then
    return false
  end
  local AICards=UseLists({AIHand(),AIField()})
  local OppCards=UseLists({OppHand(),OppField()})
  return #AICards<=#OppCards and UseFieldNuke(-1)
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
      return MP2Check()
    end 
  end
  return false
end
function SummonLavalvalChain()
  if DeckCheck(DECK_HAT) or DeckCheck(DECK_HERALDIC) 
  or DeckCheck(DECK_QLIPHORT) or DeckCheck(DECK_DARKWORLD)
  or DeckCheck(DECK_CONSTELLAR) or DeckCheck(DECK_HARPIE)
  then
    return false
  else
    return MP2Check() and OppGetStrongestAttDef()<1800 and #AIGrave()<10
  end
end
function UseLavalvalChain()
  return not (DeckCheck(DECK_NEKROZ) or DeckCheck(DECK_DARKWORLD)
  or DeckCheck(DECK_CONSTELLAR) or DeckCheck(DECK_HARPIE))
end
function ChidoriFilter(c,pos)
  return Targetable(c,TYPE_MONSTER)
  and Affected(c,TYPE_MONSTER,4)
  and (pos == nil or FilterPosition(c,pos))
end
function SummonChidori(c,mode)
  if mode == 1 
  and CardsMatchingFilter(OppField(),ChidoriFilter,POS_FACEUP)>0
  and CardsMatchingFilter(OppField(),ChidoriFilter,POS_FACEDOWN)>0
  then
    return true
  end
  if mode == 2 
  and HasPriorityTarget(OppField(),ChidoriFilter,POS_FACEUP)
  then
    return true
  end
  return false
end
function SummonRagnaZero(card)
  local cards = OppMon()
  for i=1,#cards do
    local c=cards[i]
    if c.attack~=c.base_attack
    and bit32.band(c.position,POS_FACEUP_ATTACK)>0    
    and c:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0
    and c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0
    and NotNegated(card)
    then
      return true
    end 
  end
  if Negated(card) then
    return OppGetStrongestAttDef() < 2400
    and OppHasStrongestMonster()
  end
  return false
end
function SummonImpKing(c)
  return MP2Check() 
  and (CardsMatchingFilter(AIDeck(),FilterRace,RACE_REPTILE)>0
  and NotNegated(c)
  or Negated(c) and OppGetStrongestAttDef() < 2300
  and OppHasStrongestMonster())
end
function SummonDracossack()
  return MP2Check() and Duel.GetLocationCount(player_ai,LOCATION_MZONE)>0
end
function BigEyeFilter(c)
  return c.attack>=2600 and c:is_affected_by(EFFECT_CANNOT_BE_EFFECT_TARGET)==0 
end
function SummonBigEye()
  return CardsMatchingFilter(OppMon(),BigEyeFilter)>0 and MP2Check()
end
function SummonNaturiaBeast(c)
  return OppGetStrongestAttDef()<2200 and MP2Check()
end
function SummonArmades()
  return Duel.GetCurrentPhase() == PHASE_MAIN1 and OppGetStrongestAttDef()<2300 
  and GlobalBPAllowed
end
function SummonStardustSpark(c)
  return NotNegated(c) and MP2Check() 
  or Negated(c) and OppGetStrongestAttDef()<2500
end
function JeweledRDAFilter(card,id)
  return card.cardid~=id and bit32.band(card.position,POS_FACEUP_ATTACK)>0 
  and card:is_affected_by(EFFECT_INDESTRUCTABLE_EFFECT)==0 and card:is_affected_by(EFFECT_IMMUNE_EFFECT)==0
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
function SummonJeweledRDA(c)
  return (UseJeweledRDA(c,1) or OppGetStrongestAttDef() > 2500) and NotNegated(c)
  or Negated(c) and OppGetStrongestAttDef() < c.attack
end

function SummonClearWing(c)
  return OppGetStrongestAttDef() < c.attack 
  and MP2Check()
end
function UseBigEye()
  return true
end
function UseDarkHole()
  local aimon=AIMon()
  local AITargets=DestroyCheck(AIMon(),true)
  local OppTargets=DestroyCheck(OppMon(),true)
  local diff=OppTargets-AITargets
  if HasIDNotNegated(aimon,83994433,true) and GlobalStardustSparkActivation[aimon[CurrentIndex].cardid]~=Duel.GetTurnCount() then
    diff = diff+1
  end
  if HasIDNotNegated(AIST(),27243130,true) or HasID(AIHand(),27243130,true) then
    diff = diff+1
  end
  local AIAtt=AIGetStrongestAttack()
  local OppAtt=OppGetStrongestAttDef()
  return (AITargets==0 and OppAtt >= 2000) or diff>1 or (OppAtt >= 2000 and diff<=1 and AIAtt-OppAtt < diff*500)
end
function UseRaigeki()
  local OppTargets=DestroyCheck(OppMon(),true)
  local OppAtt=OppGetStrongestAttDef()
  return OppTargets>2 or OppTargets>1 and OppAtt >=2000 or OppTargets>0 and OppAtt>=2500
end
function UseRaigeki2()
  local OppTargets=DestroyCheck(OppMon(),true)
  return OppTargets>0 and OppHasStrongestMonster()
end
function UseSnatchSteal()
  return true
end
function UseEmeral()
  return true
end
function EmeralFilter(c)
  return bit32.band(c.type,TYPE_MONSTER)>0
end
function SummonEmeral()
  return HasID(AIExtra(),00581014,true) and MP2Check() 
  and CardsMatchingFilter(AIGrave(),EmeralFilter)>10 
  and (OppGetStrongestAttDef()<1800 
  or not OppHasStrongestMonster())
end
function UseCowboyDef()
  return AI.GetPlayerLP(2) < 1600
end
function UseVolcasaurus()
  return DestroyCheck(OppMon())>0
end
function VolcasaurusFilter(c,lp)
  return FilterType(c,TYPE_MONSTER)
  --and not FilterType(c,TYPE_PENDULUM+TYPE_TOKEN)
  and Targetable(c,TYPE_MONSTER)
  and Affected(c,TYPE_MONSTER,5)
  and DestroyFilter(c)
  and DestroyCountCheck(c,TYPE_MONSTER,false)
  and bit32.band(c.position,POS_FACEUP)>0
  and (lp==nil or c.text_attack and c.text_attack>=AI.GetPlayerLP(2))
end
function SummonVolcasaurus(c)
  return NotNegated(c) and (WindaCheck() or FieldCheck(5)>2) and HasID(AIExtra(),29669359,true)
  and CardsMatchingFilter(OppMon(),VolcasaurusFilter)>0 and MP2Check()
  or Negated(c) and OppHasStrongestMonster() and OppGetStrongestAttack()<c.attack
end
function SummonVolcasaurusFinish()
  return HasID(AIExtra(),29669359,true) and CardsMatchingFilter(OppMon(),VolcasaurusFilter,true)>0
end
function SummonVolcaGaiaFinish(mode)
  local cards = OppMon()
  if not BattlePhaseCheck() then return false end
  if mode == 1 and HasID(AIExtra(),29669359,true) and HasID(AIExtra(),91949988,true) 
  then
    local result = 0
    local index = 0
    for i=1,#cards do
      local c = cards[i]
      if VolcasaurusFilter(c) and c.text_attack>result then
        result=c.text_attack
        index = i
      end
    end
    table.remove(cards,index)
    local result2 = 0
    if #cards == 0 then
      result2 = 2600
    else 
      for i=1,#cards do
        local dmg = BattleDamage(cards[i],FindID(91949988,AIExtra()),nil,nil,nil,true)
        if dmg>result2 then
          result2 = dmg
        end
      end
    end
    return result>0 and result + result2 >= AI.GetPlayerLP(2)
  elseif mode == 2 and HasID(AIMon(),29669359,true) and HasID(AIExtra(),91949988,true) 
  then
    local result = 0
    local result2 = 0
    if #cards == 0 then
      result = 2600
    else 
      for i=1,#cards do
        local dmg = BattleDamage(cards[i],FindID(91949988,AIExtra()),nil,nil,nil,true)
        if dmg>result then
          result = dmg
        end
        dmg = BattleDamage(cards[i],FindID(29669359,AIMon()))
        if dmg>result2 then
          result2 = dmg
        end
      end
    end
    return result >= AI.GetPlayerLP(2) and result2 < AI.GetPlayerLP(2)
  end
end
function SummonJD()
  return UseFieldNuke(-1) and not HasID(AIMon(),57774843,true) 
  or #OppField()==0 and Duel.GetCurrentPhase()==PHASE_MAIN1 and GlobalBPAllowed
end
function LeviairFilter(c)
  return bit32.band(c.type,TYPE_MONSTER)>0 and c.level<5 
  and c:is_affected_by(EFFECT_SPSUMMON_CONDITION)==0
end
function SummonLeviair()
  if DeckCheck(DECK_DARKWORLD) then
    return false
  end
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
  or c.defense<2500 and bit32.band(c.position,POS_DEFENCE)>0
  and (bit32.band(c.position,POS_FACEUP)>0 or bit32.band(c.status,STATUS_IS_PUBLIC)>0))
  and c:is_affected_by(EFFECT_INDESTRUCTABLE_BATTLE)==0 
  and c:is_affected_by(EFFECT_CANNOT_BE_BATTLE_TARGET)==0)
end
function UseCowboyAtt()
  return CardsMatchingFilter(OppMon(),CowboyFilter)>0 
  and Duel.GetCurrentPhase()==PHASE_MAIN1 and GlobalBPAllowed
end
function SummonCowboyAtt()
  return OppHasStrongestMonster() and UseCowboyAtt() and MP2Check()
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
function SummonLeoh(c)
  return c and OppGetStrongestAttDef() < c.attack and MP2Check() and HasID(AIExtra(),08561192,true)
end
function SummonMechquipped()
  return Duel.GetCurrentPhase() == PHASE_MAIN2 or Duel.GetTurnCount()==1
end
function DwellerFilter(c)
  return FilterAttribute(c,ATTRIBUTE_WATER) and FilterLevel(c,4)
end
function SummonDweller()
  return false--MP2Check() and CardsMatchingFilter(AIMon(),DwellerFilter)>0 and OppGetStrongestAttDef()<2200
end
function PleiadesFilter(c)
  return Targetable(c,TYPE_MONSTER)
  and Affected(c,TYPE_MONSTER,5)
end
function PleiadesFilter2(c)
  return PleiadesFilter(c) and not ToHandBlacklist(c.id) 
  and PriorityTarget(c)
end
function PleiadesRemovalFilter(c)
  return not ((c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_RITUAL+TYPE_XYZ) 
  or c:IsHasEffect(EFFECT_SPSUMMON_CONDITION))
  or ToHandBlacklist(c:GetCode()))
  and not c:IsHasEffect(EFFECT_CANNOT_BE_EFFECT_TARGET)
end
function ChainPleiades(c)
  local targets = CardsMatchingFilter(OppMon(),PleiadesFilter)
  local targets2 = CardsMatchingFilter(OppMon(),PleiadesFilter2)
  if RemovalCheckCard(c) then
    if (Duel.GetOperationInfo(Duel.GetCurrentChain(),CATEGORY_TOHAND) 
    or Duel.GetOperationInfo(Duel.GetCurrentChain(),CATEGORY_TODECK))
    and targets>0 or targets2>0
    then
      return true
    else
      GlobalCardMode = 2
      GlobalTargetSet(FindID(73964868,AIMon()),AIMon())
      return true
    end
  end
  if not UnchainableCheck(73964868) then
    return false
  end
  if targets2 and targets2 > 0 and (AIGetStrongestAttack()<=OppGetStrongestAttDef(PleiadesFilter2) 
  or TurnEndCheck() or Duel.GetTurnPlayer()==1-player_ai)
  then
    return true
  end
  if targets and targets == 1 and #OppMon()==1 and BattlePhaseCheck()
  and Duel.GetTurnPlayer()==player_ai
  and ExpectedDamage(2)>=AI.GetPlayerLP(2) then
    return true
  end
  cg = RemovalCheck()
  if cg and not Duel.GetOperationInfo(Duel.GetCurrentChain(),CATEGORY_TOHAND) then
		if cg:IsExists(function(c) return c:IsControler(player_ai) end, 1, nil) then
      local g=cg:Filter(PleiadesRemovalFilter,nil,player_ai):GetMaxGroup(Card.GetAttack)
      if g then
        GlobalCardMode = 2
        GlobalTargetSet(g:GetFirst(),AIField())
        return true
      end
    end	
  end
  cg = NegateCheck()
  if cg and Duel.GetCurrentChain()>1 then
		if cg:IsExists(function(c) return c:IsControler(player_ai) end, 1, nil) then
      local g=cg:Filter(PleiadesRemovalFilter,nil,player_ai):GetMaxGroup(Card.GetAttack)
      if g then
        GlobalCardMode = 2
        GlobalTargetSet(g:GetFirst(),AIField())
        return true
      end
    end	
  end
  if Duel.GetCurrentPhase()==PHASE_BATTLE and Duel.GetTurnPlayer()~=player_ai and targets>0 then
    local source=Duel.GetAttacker()
    local target=Duel.GetAttackTarget()
    if source and target 
    and (WinsBattle(source,target) or source:GetCode()==68535320 or source:GetCode()==95929069)
    and target:IsControler(player_ai) and Targetable(source,TYPE_MONSTER) and Affected(source,TYPE_MONSTER,5)
    then
      GlobalCardMode = 2
      GlobalTargetSet(source,OppMon())
      return true
    end
  end
  if (Duel.GetCurrentPhase()==PHASE_END and Duel.GetTurnPlayer()~=player_ai 
  or (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) 
  and Duel.GetTurnPlayer()==player_ai) and Duel.GetCurrentChain()==0
  then
    if HasID(AIST(),57103969,true,nil,nil,POS_FACEUP) 
    and CardsMatchingFilter(AIDeck(),FilterRace,RACE_BEASTWARRIOR)>0 
    and NeedsCard(70908596,AIDeck(),AIHand(),true)
    and OPTCheck(57103969) and not HasID(AIHand(),57103969,true)
    then
      GlobalCardMode = 2
      GlobalTargetSet(FindID(57103969,AIST(),nil,FilterPosition,POS_FACEUP),AIST())
      return true
    end
    if HasID(AIST(),05851097,true,nil,nil,POS_FACEUP) 
    and OppHasStrongestMonster()
    then
      GlobalCardMode = 2
      GlobalTargetSet(FindID(05851097,AIST(),nil,FilterPosition,POS_FACEUP),AIST())
      return true
    end
    if HasID(AIST(),50078509,true,nil,nil,POS_FACEUP) 
    then
      GlobalCardMode = 2
      GlobalTargetSet(FindID(50078509,AIST(),nil,FilterPosition,POS_FACEUP),AIST())
      return true
    end
    if HasID(AIST(),57103969,true,nil,nil,POS_FACEUP) 
    and CardsMatchingFilter(AIDeck(),FilterRace,RACE_BEASTWARRIOR)>0 
    and OPTCheck(57103969) and not HasID(AIHand(),57103969,true)
    then
      GlobalCardMode = 2
      GlobalTargetSet(FindID(57103969,AIST(),nil,FilterPosition,POS_FACEUP),AIST())
      return true
    end
  end
  return false
end
function SummonPleiades()
  return HasID(AIExtra(),73964868,true) and (MP2Check()
  or HasPriorityTarget(OppField()) or #OppMon()==1
  and CardsMatchingFilter(OppMon(),PleiadesFilter)==1
  and AI.GetPlayerLP(2)<=2500 and BattlePhaseCheck())
end
function SummonGiantHand()
  return MP2Check() and OppGetStrongestAttDef()<2000
end
function SummonCairngorgon(c)
  return OppGetStrongestAttDef()<c.attack and MP2Check()
  and (NotNegated(c) or OppHasStrongestMonster())
end
function SummonRhapsody()
  local cards=AIMon()
  for i=1,#cards do
    if bit32.band(cards[i].type,TYPE_XYZ)>0 and cards[i].attack+1200 > OppGetStrongestAttack() and  #OppGrave()>=2 then
      return MP2Check()
    end
  end
  return false
end
function SummonGagagaSamurai()
  return Duel.GetCurrentPhase()==PHASE_MAIN1 and GlobalBPAllowed and #OppMon()==0 and ExpectedDamage(2)<2000
end
function UseGagagaSamurai()
  return Duel.GetCurrentPhase()==PHASE_MAIN1 and GlobalBPAllowed and not OppHasStrongestMonster()
end
function RebellionFilter(c)
  return FilterPosition(c,POS_FACEUP) and c.attack>0
  and Targetable(c,TYPE_MONSTER) and Affected(c,TYPE_MONSTER,4) 
end
function RebellionFilter2(c)
  return FilterPosition(c,POS_FACEUP_ATTACK)
  and Targetable(c,TYPE_MONSTER) and Affected(c,TYPE_MONSTER,4) 
end
function SummonRebellion(c)
  local OppAttDef=OppGetStrongestAttDef()
  return OppHasStrongestMonster() and OppAttDef>2500
  and 2500+OppGetStrongestAttack(RebellionFilter)*0.5 > OppAttDef
  and Duel.GetCurrentPhase()==PHASE_MAIN1 and GlobalBPAllowed
  and NotNegated(c)
  or Negated(c) and OppHasStrongestMonster() and OppAttDef<2500
end
function SummonRebellionFinish()
  return CardsMatchingFilter(OppMon(),RebellionFilter2)>0 and AI.GetPlayerLP(2)<=2500
  and Duel.GetCurrentPhase()==PHASE_MAIN1 and GlobalBPAllowed
end
function UseRebellion()
  return CardsMatchingFilter(OppMon(),RebellionFilter)>0
end
function ZenmainesFilter(c,source)
  return (c.attack>source.attack and DestroyFilterIgnore(c) 
  and AI.GetPlayerLP(1)>(c.attack-source.attack)+800
  or c.attack==source.attack and DestroyCheck(OppField())>1)
  and AttackBlacklistCheck(c)
  and FilterPosition(c,POS_FACEUP_ATTACK)
  and not FilterAffected(c,EFFECT_CANNOT_BE_BATTLE_TARGET)
end
function ZenmainesCheck(card,targets)
  return CardsMatchingFilter(OppMon(),ZenmainesFilter,card)>0 
  and NotNegated(card)
  and (FilterLocation(card,LOCATION_EXTRA) 
  or card.xyz_material_count>0)
end
function SummonZenmaines(card)
  return (ZenmainesCheck(card,OppMon()) or MP2Check())
  and not DeckCheck(DECK_BA)
end
function RepoZenmaines(c)
  if (ZenmainesCheck(c,OppMon())
  or not OppHasStrongestMonster()
  or #OppMon()==0)
  and Duel.GetTurnPlayer()==player_ai
  and Duel.GetCurrentPhase()==PHASE_MAIN1
  and GlobalBPAllowed
  then
    return FilterPosition(c,POS_DEFENCE)
  else
    return FilterPosition(c,POS_ATTACK)
  end
end
function SummonNightmareSharkFinish()
  return GlobalBPAllowed 
  and Duel.GetCurrentPhase() == PHASE_MAIN1 
  and AI.GetPlayerLP(2)<=2000
end
function UseNightmareShark()
  return GlobalBPAllowed and Duel.GetCurrentPhase() == PHASE_MAIN1
end
function SummonLancelotFinish()
  return GlobalBPAllowed and Duel.GetCurrentPhase() == PHASE_MAIN1 and AI.GetPlayerLP(2)<=2000
end
function AlseiFilter(c,source)
  return Affected(c,TYPE_MONSTER,source.level)
  and Targetable(c,TYPE_MONSTER)
end
function SummonAlsei(c)
  return MP2Check() and UseAlsei(c)
  and HasPriorityTarget(OppField(),false,nil,AlseiFilter,c)
end
function UseAlsei(c)
  return OPTCheck(10406322) 
  and CardsMatchingFilter(OppField(),AlseiFilter,c)>0
end
function GiantGrinderFilter(c,source)
  return FilterSummon(c,SUMMON_TYPE_SPECIAL)
  and DestroyFilter(c)
  and Affected(c,TYPE_MONSTER,source.level)
  and Targetable(c,TYPE_MONSTER)
  and DestroyCountCheck(c,TYPE_MONSTER,false)
end
function GiantGrinderFilter2(c,source)
  return GiantGrinderFilter(c,source)
  and FilterType(c,TYPE_XYZ)
end
function SummonGiantGrinder(c)
  return UseGiantGrinder(c)
  and HasPriorityTarget(OppMon(),true,nil,GiantGrinderFilter,c)
  and CardsMatchingFilter(OppMon(),GiantGrinderFilter,c)>1
  and OppHasStrongestMonster()
end
function SummonGiantGrinderFinish(source)
  local cards = SubGroup(OppMon(),GiantGrinderFilter2,source)
  if cards and #cards>1 then
    table.sort(cards,function(a,b)return a.base_attack>b.base_attack end)
  end
  local result = 0
  for i=1,math.min(#cards,2) do 
    result = result + cards[i].base_attack
  end
  if result >= AI.GetPlayerLP(2) then
    GlobalGrinderFinish = true
    return true
  end
  return false
end
function UseGiantGrinder(c)
  return Duel.GetCurrentPhase()==PHASE_MAIN1
  and CardsMatchingFilter(OppMon(),GiantGrinderFilter,c)>0
end
function PtolemyFilter(c)
  return FilterType(c,TYPE_XYZ) and ConstellarMonsterFilter(c,38495396) 
  and c.xyz_material_count==0
end
function SummonPtolemy(c)
  return (NotNegated(c) 
  and (FieldCheck(6)>1 and MP2Check()
  or CardsMatchingFilter(AIMon(),PtolemyFilter)>0))
  or OppHasStrongestMonster() and OppGetStrongestAttack()<c.attack
end
function UsePtolemy()
  return true
end
function SummonHPPDFinish()
  return BattlePhaseCheck()
  and AI.GetPlayerLP(2)<=2000
end
function SummonHeartlanddracoFinish()
  return BattlePhaseCheck()
  and AI.GetPlayerLP(2)<=2000
end
function UseHeartlanddraco()
  return BattlePhaseCheck()
end
function LightningFinishFilter(c,source)
  return FilterPosition(c,POS_FACEUP_ATTACK) and AttackBlacklistCheck(c,source) 
  and BattleDamageCheck(c,source) and AI.GetPlayerLP(2)<=5000-c.attack
end
function SummonUtopiaLightningFinish(c,mode)
  --if true then return true end
  if GlobalBPAllowed 
  and Duel.GetCurrentPhase() == PHASE_MAIN1 
  then
    if mode == 1 then 
      c = FindID(00005509,AIExtra()) 
      if HasID(AIExtra(),00005509,true)
      and HasID(AIExtra(),84013237,true)
      and CardsMatchingFilter(OppMon(),LightningFinishFilter,c)>0 
      then
        return true
      end
    else
      if HasID(AIExtra(),00005509,true)
      and HasID(AIMon(),84013237,true)
      and CardsMatchingFilter(OppMon(),LightningFinishFilter,c)>0 
      then
        return true
      end
    end
  end
  return false
end
function GaiaFilter(c)
  return (FilterRank(c,5) or FilterRank(c,6))
  and c.attack<2600 and c.xyz_material_count==0
end
function SummonGaiaDragon(c)
  return CardsMatchingFilter(AIMon(),GaiaFilter)>0
end
function SummonGaiaDragonFinish(source)
  local result = false
  if not (BattlePhaseCheck() and HasID(AIExtra(),91949988,true)) then return false end
  for i=1,#OppMon() do
    for j=1,#AIMon() do
    local target = OppMon()[i]
    local c = AIMon()[j]
      if BattleDamage(target,source,nil,nil,nil,true) >= AI.GetPlayerLP(2) then
        result = true
      end
      if BattleDamage(c,source,nil,nil,nil,true) > AI.GetPlayerLP(2) then
        result = false
      end
    end
  end
  return result
end
function ChainOmega(source)
  local cards = RemovalCheckList(AIMon(),nil,TYPE_SPELL+TYPE_TRAP,nil,ConstellarMonsterFilter)
  if cards and #cards>0 then
    return true
  end
  return false
end
function SummonOmega(c)
  return NotNegated(c) and (not OppHasStrongestMonster() or OppGetStrongestAttDef()<c.attack)
  and CardsMatchingFilter(OppST(),FilterPosition,POS_FACEDOWN)>2
  or Negated(c) and OppHasStrongestMonster() and OppGetStrongestAttDef()<c.attack
end
function InstantFusionFilter(c)
  return bit32.band(c.attribute,ATTRIBUTE_LIGHT)>0 and c.level==5
  or c.id==70908596 and NotNegated(c)
end
function NodenFilter(c)
  return c.level==4 and c.id~=17412721
end
function UseInstantFusion(mode)
  if not (WindaCheck() and DualityCheck) then return false end
  if mode == 1 
  and CardsMatchingFilter(AIGrave(),NodenFilter)>0 
  and HasIDNotNegated(AIExtra(),17412721,true)
  and (FieldCheck(4)==1 and OverExtendCheck(2,6) 
  or #AIMon()==0 and #OppMon()>0
  or DeckCheck(DECK_TELLARKNIGHT) and FieldCheck(1) and DestroyCheck(OppField())>0) 
  then
    GlobalCardMode = nil
    return true
  elseif mode == 2 and CardsMatchingFilter(AIMon(),InstantFusionFilter)==1 
  and HasID(AIExtra(),73964868,true)
  then
    GlobalCardMode = 1
    return true
  elseif mode == 3 and HasPriorityTarget(OppField(),true)
  and HasID(AIExtra(),73964868,true) and TurnEndCheck()
  and MacroCheck()
  then
    GlobalCardMode = 1
    return true
  end
  return false
end

function MoonlightRoseFilter(c)
  return FilterSummon(c,SUMMON_TYPE_SPECIAL)
  and Affected(c,TYPE_MONSTER,7)
  and Targetable(c,TYPE_MONSTER)
  and not ToHandBlacklist(c.id)
  and PriorityTarget(c)
end
function SummonMoonlightRose(c)
  return (WindaCheck() or FieldCheck(5)>1 
  or not DeckCheck(DECK_SHADDOLL))
  and HasID(AIExtra(),33698022,true)
  and CardsMatchingFilter(OppMon(),MoonlightRoseFilter)>0
  and MP2Check()
end
function VulcanFilter(c)
  return Affected(c,TYPE_MONSTER,6)
  and Targetable(c,TYPE_MONSTER)
  and not ToHandBlacklist(c.id)
  and PriorityTarget(c)
end
function SummonVulcan(c)
  return HasID(AIExtra(),98012938,true)
  and CardsMatchingFilter(OppMon(),VulcanFilter)>0
  and CardsMatchingFilter(AIST(),FilterPosition,POS_FACEUP)>0
end
function UseGalaxyCyclone(mode)
  if mode == 1 then
    return DestroyCheck(OppST(),false,false,FilterPosition,POS_FACEDOWN)
  end
  return DestroyCheck(OppST(),false,false,FilterPosition,POS_FACEUP)
end
----

function SummonNegateFilter(c)
  return (c.attack>1500 and AIGetStrongestAttack(true)<=c.attack) or FilterType(c,TYPE_FUSION+TYPE_RITUAL+TYPE_SYNCHRO+TYPE_XYZ) --or c.level>4
end
function EffectNegateFilter(c,card)
  local id = c:GetCode()
  if RemovalCheck(card.id) then
    local cg = RemovalCheck()
    if cg:GetCount()>1 then
      return true
    else
      if FilterType(card,TYPE_MONSTER) then
        return true
      else
        return false
      end
    end
  end
  if RemovalCheck() then
    --WIP, don't negate stuff that destroys re-equipables
  end
  for i=1,#EffNegBL do
    if id == EffNegBL[i] then
      return false
    end
  end
  if c:IsType(TYPE_EQUIP+TYPE_FIELD) then
    return false
  end
  if (id == 53804307 or id == 26400609 -- Dragon Rulers
  or id == 89399912 or id == 90411554)
  and c:IsLocation(LOCATION_MZONE)
  then
    return false
  end
  if  id == 00423585 -- Summoner Monk
  and not Duel.GetOperationInfo(Duel.GetCurrentChain(), CATEGORY_SPECIAL_SUMMON) 
  then
    return false
  end
  return true
end
function CardNegateFilter(c,card,targeted,filter,opt)
  return c and card and c:IsControler(1-player_ai) 
  and c:IsLocation(LOCATION_ONFIELD) 
  and c:IsPosition(POS_FACEUP)
  and not NegateBlacklist(c:GetCode()) 
  and (not targeted or Targetable(c,card.type))
  and Affected(c,card.type,card.level)
  and NotNegated(c) 
  and FilterCheck(c,filter,opt)
end

GlobalNegatedChainLinks = {}
function CheckNegated(ChainLink)
  return not GlobalNegatedChainLinks[ChainLink]
end
function SetNegated(ChainLink)
  if ChainLink == nil then
    ChainLink = Duel.GetCurrentChain()
  end
  GlobalNegatedChainLinks[ChainLink] = true
end
function ChainNegation(card)
-- for negating the last chain link via trigger effect
  local e,c,id 
  if EffectCheck(1-player_ai)~=nil then
    e,c,id = EffectCheck()
    if EffectNegateFilter(c,card) then
      SetNegated()
      return true
    end
  else
    local cards = SubGroup(OppMon(),FilterStatus,STATUS_SUMMONING)
    if #cards > 1 and Duel.GetCurrentChain()<1 then
      return true
    end
    if #cards == 1 and Duel.GetCurrentChain()<1 then
      c=cards[1]
      return SummonNegateFilter(c)
    end
  end
  return false
end
function ChainCardNegation(card,targeted,removalonly,filter,opt,skipnegate)
-- for negating cards on the field that activated
-- an effect anywhere in the current chain
  for i=1,Duel.GetCurrentChain() do
    if CheckNegated(i) then
      local e = Duel.GetChainInfo(i, CHAININFO_TRIGGERING_EFFECT)
      if e then
        c=e:GetHandler()
        if player_ai==nil then -- Effect Veiler can be activated 
          player_ai=1          -- before player setup is complete      
        end                    -- which means the AI is player 2
        if CardNegateFilter(c,card,targeted,filter,opt) 
        and (not removalonly or RemovalCheckList(AIField(),nil,i))
        then
          if not skipnegate then
            SetNegated(i)
          end
          return c,i
        end
      end
    end
  end
  return false,nil
end
function ChainChalice(card)
  local c = ChainCardNegation(card,true,false,FilterType,TYPE_MONSTER)
  if c then
    GlobalTargetSet(c,OppMon())
    return true
  end
  return false
end
function ChainVeiler(card)
  local c = ChainCardNegation(card,true,false,FilterType,TYPE_MONSTER)
  if c then
    GlobalTargetSet(c,OppMon())
    return true
  end
  return false
end
function ChainBTS(card)
  local c = ChainCardNegation(card,true,false,FilterType,TYPE_MONSTER)
  if c then
    GlobalTargetSet(c,OppMon())
    return true
  end
  if Duel.GetCurrentPhase() == PHASE_BATTLE then --for Breakthrough Skill
    if Duel.GetTurnPlayer()==player_ai then
      local cards=OppMon()
      for i=1,#cards do
        if VeilerTarget(cards[i]) then
          GlobalTargetSet(cards[i],OppMon())
          return true
        end
      end
    end
    local source = Duel.GetAttacker()
		local target = Duel.GetAttackTarget()
    if source and target then
      if source:IsControler(player_ai) then
        target = Duel.GetAttacker()
        source = Duel.GetAttackTarget()
      end
      if source:GetAttack() <= target:GetAttack() and target:IsControler(player_ai) 
      and target:IsPosition(POS_FACEUP_ATTACK) and source:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE)
      then
        --GlobalTargetSet(source)
        --return true
      end
    end
  end
  return false
end
function ChainFiendish(card)
  local c = ChainCardNegation(card,true,false,FilterType,TYPE_MONSTER)
  if c then
    GlobalTargetSet(c,OppMon())
    return true
  end
  if Duel.GetCurrentPhase() == PHASE_BATTLE and Duel.GetTurnPlayer()~=player_ai then
		local source = Duel.GetAttacker()
		local target = Duel.GetAttackTarget()
    if source and target and WinsBattle(source,target) 
    and Targetable(source,TYPE_TRAP) and Affected(source,TYPE_TRAP)
    and UnchainableCheck(50078509)
    and not FilterAffected(source,EFFECT_DISABLE)
    and not FilterType(source,TYPE_NORMAL)
    then
      GlobalTargetSet(source)
      return true
    end
    if source and CanFinishGame(source) and #AIMon()==0 
    and Targetable(source,TYPE_TRAP) and Affected(source,TYPE_TRAP)
    and UnchainableCheck(50078509)
    and not FilterAffected(source,EFFECT_DISABLE)
    and not FilterType(source,TYPE_NORMAL)
    then
      GlobalTargetSet(source)
      return true
    end
  end
  return false
end
function ChainSkillDrain(card)
  local c = ChainCardNegation(card,false,false,FilterType,TYPE_MONSTER)
  if c then
    GlobalTargetSet(c,OppMon())
    return true
  end
  if Duel.GetCurrentPhase() == PHASE_BATTLE then
    if Duel.GetTurnPlayer()==player_ai 
    and not OppHasStrongestMonster() 
    and CardsMatchingFilter(OppMon(),NegateBPCheck)>0 
    then
      return true
    end
    local source = Duel.GetAttacker()
		local target = Duel.GetAttackTarget()
    if source and target then
      if source:IsControler(player_ai) then
        target = Duel.GetAttacker()
        source = Duel.GetAttackTarget()
      end
      if target:IsControler(player_ai)
      and (source:IsPosition(POS_FACEUP_ATTACK) 
      and source:GetAttack() >= target:GetAttack() 
      and source:GetAttack() <= target:GetAttack()+QliphortAttackBonus(target:GetCode(),target:GetLevel())
      and not (source:GetAttack() == target:GetAttack() 
      and QliphortAttackBonus(target:GetCode(),target:GetLevel())==0)
      or source:IsPosition(POS_FACEUP_DEFENCE)
      and source:GetDefence() >= target:GetAttack() 
      and source:GetDefence() < target:GetAttack()+QliphortAttackBonus(target:GetCode(),target:GetLevel()))
      and target:IsPosition(POS_FACEUP_ATTACK) 
      then
        return true
      end
    end
  end
  return false
end
function ChainGiantHand(card)
  local c = ChainCardNegation(card,true,false,FilterType,TYPE_MONSTER)
  if c then
    GlobalTargetSet(c,OppMon())
    return true
  end
  return false
end
function ChainFelgrand(card)
  local c=nil
  local targets={}
  for i=1,#AIMon() do
    c=AIMon()[i]
    if RemovalCheckCard(c) or NegateCheckCard(c) then
      targets[#targets+1]=c
    end
  end
  if #targets == 1 then
    GlobalTargetSet(targets[1],AIMon())
    return true
  end
  c=nil
  c = ChainCardNegation(card,true,true,FilterType,TYPE_MONSTER)
  if c then
    GlobalTargetSet(c,OppMon())
    return true
  end
  c=nil
  if #targets>1 then
    BestTargets(targets,1,TARGET_PROTECT)
    c=targets[1]
    GlobalTargetSet(c,AIMon())
    return true
  end
  return false
end
function ChainZombiestein(card)
  local targets=RemovalCheckCard(AIField())
  local c,cl = ChainCardNegation(card,true,true,FilterLocation,LOCATION_ONFIELD,true)
  if c and (PriorityCheck(AIHand(),PRIO_TOGRAVE)>2 
  or targets and #targets>1) 
  then
    GlobalTargetSet(c,OppField())
    SetNegated(cl)
    return true
  end
  return false
end
function ChainUtopiaLightning(c)
  local aimon,oppmon=GetBattlingMons() 
  if AttackBoostCheck(5000-c.attack) 
  or CanFinishGame(aimon,oppmon,5000)
  then
    return true
  end
end
function ChainShrink(c)
  if RemovalCheckCard(c) 
  and CardsMatchingFilter(OppMon(),Targetable,TYPE_SPELL)>0
  then
    return true
  end
  local aimon,oppmon=GetBattlingMons() 
  if aimon and oppmon
  and Duel.GetCurrentPhase()==PHASE_DAMAGE
  and AttackBoostCheck(0,oppmon:GetBaseAttack()*0.5) 
  and Targetable(oppmon,TYPE_SPELL)
  and Affected(oppmon,TYPE_SPELL)
  and UnchainableCheck(55713623)
  then
    GlobalCardMode=1
    GlobalTargetSet(oppmon)
    return true
  end
  return false
end
function TrapStunFilter(c)
  return FilterLocation(c,LOCATION_SZONE)
  and FilterType(c,TYPE_TRAP)
  and c.id~=51452091
  and c.id~=59616123
end
function TrapStunFilter2(c)
  return FilterLocation(c,LOCATION_SZONE)
  and (FilterType(c,TYPE_TRAP) and FilterPublic(c)
  or FilterPrivate(c))
end
function ChainTrapStun(source)
  if RemovalCheckCard(source)
  and CardsMatchingFilter(AIST(),TrapStunFilter)<2 
  then
    return true
  end
  local c,cl = ChainCardNegation(source,false,false,TrapStunFilter,nil,true)
  if c 
  --and CardsMatchingFilter(AIST(),TrapStunFilter)<3 
  and UnchainableCheck(59616123)
  then
    SetNegated(cl)
    return true
  end
  if Duel.GetTurnPlayer()==player_ai 
  and Duel.GetCurrentPhase()==PHASE_MAIN1
  and Duel.GetCurrentChain()==0
  and (HasIDNotNegated(Field(),05851097,nil,nil,POS_FACEUP)
  or HasIDNotNegated(Field(),82732705,nil,nil,POS_FACEUP))
  then
    return true
  end
  return false
end
function ChainDecree(source)
  if RemovalCheckCard(source)
  and CardsMatchingFilter(AIST(),TrapStunFilter)<2 
  then
    return true
  end
  local c,cl = ChainCardNegation(source,false,false,TrapStunFilter,nil,true)
  if c 
  --and CardsMatchingFilter(AIST(),TrapStunFilter)<3 
  and UnchainableCheck(51452091)
  then
    SetNegated(cl)
    return true
  end
  if Duel.GetTurnPlayer()==player_ai 
  and Duel.GetCurrentPhase()==PHASE_MAIN1
  and Duel.GetCurrentChain()==0
  and (HasIDNotNegated(Field(),05851097,nil,nil,POS_FACEUP)
  or HasIDNotNegated(Field(),82732705,nil,nil,POS_FACEUP))
  then
    return true
  end
  return false
end
function PriorityChain(cards) -- chain these before anything else
  if HasIDNotNegated(cards,58120309,ChainNegation) then -- Starlight Road
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,02956282,ChainNegation) then -- Naturia Barkion
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,33198837,ChainNegation) then -- Naturia Beast
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,99916754,ChainNegation) then -- Naturia Exterio
    return {1,CurrentIndex}
  end
  if HasID(cards,44508094,false,nil,LOCATION_MZONE,ChainNegation) then -- Stardust
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,82044279,ChainNegation) then -- Clear Wing Synchro Dragon
    return {1,CurrentIndex}
  end
  if HasID(cards,61257789,false,nil,LOCATION_MZONE,ChainNegation) then -- Stardust AM
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,35952884,false,nil,LOCATION_MZONE,ChainNegation) then -- Quasar
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,24696097,ChainNegation) then -- Shooting Star
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,99188141,ChainNegation) then -- THRIO
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,29616929,ChainNegation) then -- Traptrix Trap Hole Nighmare
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,74294676,ChainNegation) then -- Laggia
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,42752141,ChainNegation) then -- Dolkka
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,71068247,ChainNegation) then -- Totem Bird
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,41510920,ChainNegation) then -- Stellarnova Alpha
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,34507039,ChainNegation) then -- Wiretap
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,03819470,ChainNegation) then -- Seven Tools
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,49010598,ChainNegation) then -- Divine Wrath
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,77414722,ChainNegation) then -- Magic Jammer
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,77538567,ChainNegation) then -- Dark Bribe
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,93016201,ChainNegation) then -- Royal Oppression
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,50323155,ChainNegation) then -- Black Horn of Heaven
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,84749824,ChainNegation) then -- Solemn Warning
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,41420027,ChainNegation) then -- Solemn Judgment
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,92512625,ChainNegation) then -- Solemn Advice
    return {1,CurrentIndex}
  end

  if HasIDNotNegated(cards,78474168,ChainBTS) then
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,50078509,ChainFiendish) then
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,63746411,ChainGiantHand) then
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,01639384,ChainFelgrand) then
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,25789292,ChainChalice) then
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,73445448,ChainZombiestein) then
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,97268402,ChainVeiler) then
    return {1,CurrentIndex}
  end
  
  if HasIDNotNegated(cards,26329679,ChainOmega) then
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,51452091,ChainDecree) then
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,59616123,ChainTrapStun) then
    GlobalTrapStun = Duel.GetTurnCount()
    return {1,CurrentIndex}
  end

  return nil
end
function GenericChain(cards)
  if HasIDNotNegated(cards,10406322,UseAlsei) then
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,00005509,ChainUtopiaLightning) then
    return {1,CurrentIndex}
  end
  if HasIDNotNegated(cards,55713623,ChainShrink) then
    return {1,CurrentIndex}
  end
  return nil
end

function FelgrandTarget(cards,c)
  if LocCheck(cards,LOCATION_OVERLAY) then
    return Add(cards,PRIO_TOGRAVE)
  end
  return GlobalTargetGet(cards,true)
end
function ZombiesteinTarget(cards,c)
  if LocCheck(cards,LOCATION_OVERLAY) then
    return Add(cards,PRIO_TOGRAVE)
  end
  if LocCheck(cards,LOCATION_HAND) then
    return Add(cards,PRIO_TOGRAVE)
  end
  return GlobalTargetGet(cards,true)
end
function ZenmainesTarget(cards)
  if LocCheck(cards,LOCATION_OVERLAY) then
    return Add(cards,PRIO_TOGRAVE)
  end
  return BestTargets(cards)
end
function LancelotTarget(cards,c)
  if LocCheck(cards,LOCATION_OVERLAY) then
    OPTSet(c.cardid)
    return Add(cards,PRIO_TOGRAVE)
  end
  return BestTargets(cards)
end
function AlseiTarget(cards,c)
  if LocCheck(cards,LOCATION_OVERLAY) then
    OPTSet(10406322)
    return Add(cards,PRIO_TOGRAVE)
  end
  return BestTargets(cards,1,TARGET_TODECK)
end
function GiantGrinderTarget(cards,c)
  if LocCheck(cards,LOCATION_OVERLAY) then
    return Add(cards,PRIO_TOGRAVE)
  end
  if GlobalGrinderFinish then
    return BestTargets(cards,1,TARGET_DESTROY,GiantGrinderFilter2,c,true,c)
  end
  return BestTargets(cards,1,TARGET_DESTROY,GiantGrinderFilter,c,true,c)
end
function InstantFusionTarget(cards)
  if GlobalCardMode == 1 then
    GlobalCardMode = nil
    result = FindID(72959823,cards,true)
  else
    result = FindID(17412721,cards,true)
  end
  if result==nil then result={math.random(#cards)} end
  return result
end
function BrionacTarget(cards,c)
  if LocCheck(cards,LOCATION_HAND) then
    return Add(cards,PRIO_TOGRAVE)
  end
  return BestTargets(cards,1,PRIO_TOHAND)
end
function ShrinkTarget(cards)
  if GlobalCardMode==1 then
    return GlobalTargetGet(cards,true)
  end
  return BestTargets(cards,1,TARGET_OTHER)
end
function VulcanTarget(cards)
  local result = nil
  if CurrentOwner(cards[1])==1 then
    if DeckCheck(DECK_FIREFIST) then
      result=FireFormationCost(cards,1)
    elseif BounceTargets(AIField())>0 then
      result=BestTargets(cards,1,PRIO_TOHAND,BounceFilter)
    end
  end
  if result == nil then 
    result=BestTargets(cards,1,PRIO_TOHAND) 
  end
  return result
end
function ChidoriTarget(cards)
  if LocCheck(cards,LOCATION_OVERLAY) then
    return Add(cards,PRIO_TOGRAVE)
  end
  return BestTargets(cards,1,TARGET_TODECK)
end
function GenericCard(cards,min,max,id,c)
  if c then
    id = c.id
  end 
  if id == 22653490 then
    return ChidoriTarget(cards)
  end 
  if id == 98012938 then
    return VulcanTarget(cards)
  end 
  if id == 55713623 then
    return ShrinkTarget(cards,c)
  end
  if id == 50321796 then
    return BrionacTarget(cards,c)
  end
  if id == 01639384 then
    return FelgrandTarget(cards,c)
  end
  if id == 78156759 then
    return ZenmainesTarget(cards)
  end
  if id == 73445448 then
    return ZombiesteinTarget(cards)
  end
  if id == 66547759 then
    return LancelotTarget(cards,c)
  end
  if id == 10406322 then
    return AlseiTarget(cards,c)
  end
  if id == 88120966 then
    return GiantGrinderTarget(cards,c)
  end
  if id == 01845204 then
    return InstantFusionTarget(cards)
  end
  if id == 33698022 then  -- Moonlight Rose
    return BestTargets(cards,1,TARGET_TOHAND)
  end
  if id == 05133471 then -- Galaxy Cyclone
    return BestTargets(cards)
  end
  return nil
end

function GenericEffectYesNo(id,card)
  local result = nil
  if card then 
    id = card.id
  end
  if id == 66547759 then -- Lancelot
    result = 1
  end
  if id == 10406322 and UseAlsei(card) then
    result = 1
  end
  if id == 00005509 and ChainUtopiaLightning(card) then
    result = 1
  end
  return result
end

function GenericPosition(id,available)
  result = nil
  if id == 78156759 then
    local c = FindID(78156759,AIExtra())
    if ZenmainesCheck(c,OppMon())
    and Duel.GetTurnPlayer()==player_ai
    and Duel.GetCurrentPhase()==PHASE_MAIN1
    and GlobalBPAllowed
    then
      result = POS_FACEUP_ATTACK
    else
      result = POS_FACEUP_DEFENCE
    end
  end
  return result
end


