--[[
20292186, -- Artifact Scythe
85103922, -- Artifact Moralltach
71007216, -- Wind Witch Glass Bell
86120751, -- Aleister
43722862, -- Wind Witch Ice Bell
23434538, -- Maxx "C"
70117860, -- Wind Witch Snow Bell

01845204, -- Instant Fusion
73628505, -- Terraforming
74063034, -- Eidolon Summoning Magic
67775894, -- Wonder Wand
47679935, -- Reckless Magic Circle

12444060, -- Artifact Sanctum
05851097, -- Vanity
40605147, -- Strike
84749824, -- Warning
43898403, -- Twin Twister

11270236, -- Elysion
75286621, -- Merkabah
48791583, -- Magallanica
12307878, -- Purgatorio
85908279, -- Cocytus
49513164, -- Raideen
13529466, -- Caligula
50954680, -- Crystal Wing
82044280, -- Clear Wing
14577226, -- Wind Witch Winter Bell
56832966, -- Utopia Lightning
84013237, -- Utopia
]]

function EidolonStartup(deck)
  deck.Init                 = EidolonInit
  deck.Card                 = EidolonCard
  deck.Chain                = EidolonChain
  deck.EffectYesNo          = EidolonEffectYesNo
  deck.Position             = EidolonPosition
  deck.YesNo                = EidolonYesNo
  deck.BattleCommand        = EidolonBattleCommand
  deck.AttackTarget         = EidolonAttackTarget
  deck.AttackBoost          = EidolonAttackBoost
  deck.Tribute              = EidolonTribute
  deck.Option               = EidolonOption
  deck.ChainOrder           = EidolonChainOrder
  deck.Sum                  = EidolonSum
  --[[
  
  deck.DeclareCard
  deck.Number
  deck.Attribute
  deck.MonsterType
  ]]
  deck.ActivateBlacklist    = EidolonActivateBlacklist
  deck.SummonBlacklist      = EidolonSummonBlacklist
  deck.RepositionBlacklist  = EidolonRepoBlacklist
  deck.SetBlacklist         = EidolonSetBlacklist
  deck.Unchainable          = EidolonUnchainable
  --[[
  
  ]]
  deck.PriorityList         = EidolonPriorityList
end
EidolonIdentifier = 86120751 -- Aleister
DECK_Eidolon = NewDeck("Eidolon Beast",EidolonIdentifier,EidolonStartup) 
EidolonActivateBlacklist={
71007216, -- Wind Witch Glass Bell
86120751, -- Aleister
43722862, -- Wind Witch Ice Bell
70117860, -- Wind Witch Snow Bell

01845204, -- Instant Fusion
73628505, -- Terraforming
74063034, -- Eidolon Summoning Magic
67775894, -- Wonder Wand
47679935, -- Reckless Magic Circle

12444060, -- Artifact Sanctum

11270236, -- Elysion
75286621, -- Merkabah
48791583, -- Magallanica
12307878, -- Purgatorio
85908279, -- Cocytus
49513164, -- Raideen
13529466, -- Caligula
50954680, -- Crystal Wing
82044280, -- Clear Wing
14577226, -- Wind Witch Winter Bell
}
EidolonSummonBlacklist={
20292186, -- Artifact Scythe
85103922, -- Artifact Moralltach
71007216, -- Wind Witch Glass Bell
86120751, -- Aleister
43722862, -- Wind Witch Ice Bell
23434538, -- Maxx "C"
70117860, -- Wind Witch Snow Bell

11270236, -- Elysion
75286621, -- Merkabah
48791583, -- Magallanica
12307878, -- Purgatorio
85908279, -- Cocytus
49513164, -- Raideen
13529466, -- Caligula
50954680, -- Crystal Wing
82044280, -- Clear Wing
14577226, -- Wind Witch Winter Bell
56832966, -- Utopia Lightning
84013237, -- Utopia
}
EidolonSetBlacklist={
20292186, -- Artifact Scythe
85103922, -- Artifact Moralltach
74063034, -- Eidolon Summoning Magic
}
EidolonRepoBlacklist={
}
EidolonUnchainable={
86120751, -- Aleister
}
function EidolonFilter(c,exclude)
  local check = true
  if exclude then
    if type(exclude)=="table" then
      check = not CardsEqual(c,exclude)
    elseif type(exclude)=="number" then
      check = (c.id ~= exclude)
    end
  end
  return FilterSet(c,0xf4) and check
end
function WindWitchFilter(c,exclude)
  local check = true
  if exclude then
    if type(exclude)=="table" then
      check = not CardsEqual(c,exclude)
    elseif type(exclude)=="number" then
      check = (c.id ~= exclude)
    end
  end
  return FilterSet(c,0xf0) and check
end
function EidolonMonsterFilter(c,exclude)
  return FilterType(c,TYPE_MONSTER) 
  and EidolonFilter(c,exclude)
end

function UseIceBell(c,mode)
  if mode == 1 -- synchro climb for Crystal Wing 
  and CanSpecialSummon()
  and SpaceCheck()>2
  and HasIDNotNegated(AIDeck(),71007216,true) -- Glass Bell
  and HasID(Merge(AIDeck(),AIHand()),70117860,true) -- Snow Bell
  and HasIDNotNegated(AIExtra(),50954680,true) -- Crystal Wing
  and CardsMatchingFilter(AIExtra(),function(c) return FilterType(c,TYPE_SYNCHRO) and FilterLevel(c,7) end)
  then
    SetSummonLimit(function(c) 
      return (FilterLevelMin(c,5) 
      and FilterAttribute(c,ATTRIBUTE_WIND))
      or not FilterLocation(c,LOCATION_EXTRA)
    end)
    return true
  end
end
function UseWinterBell(c,mode)
  if mode == 1 
  then
    SetSummonLimit(function(c) 
      return FilterAttribute(c,ATTRIBUTE_WIND) 
    end)
    return true
  end
end
function SummonWinterBell(c,mode)
  if mode == 1 -- synchro climb for Crystal Wing 
  and CanSpecialSummon()
  and HasID(AIMon(),70117860,true) -- Snow Bell
  and HasIDNotNegated(AIExtra(),50954680,true) -- Crystal Wing
  then
    return true
  end
end
function UseSnowBell(c,mode)
  if mode == 1 -- synchro climb for Crystal Wing 
  and CanSpecialSummon()
  and HasIDNotNegated(AIExtra(),50954680,true) -- Crystal Wing
  then
    return true
  end
end
function UseMagicCircle(c,mode)
  if mode == 1 
  and HasID(AIDeck(),86120751,true) -- Aleister
  then
    return true
  end
end
function SummonAleister(c,mode)
	return true
end
function UseWonderWand(c,mode)
  if mode == 1
  and FilterLocation(c,LOCATION_SZONE)
  and FilterPosition(c,POS_FACEUP)
  and #AIDeck()>5
  then
    return true
  end
  if mode == 2
  and HasID(AIMon(),86120751,true,FilterPosition,POS_FACEUP)
  then
    return true
  end
end
function UseEidolonSummon(c,mode)
  if mode == 1 -- from grave
  and  FilterLocation(c,LOCATION_GRAVE)
  then
    return true
  end
  if mode == 2 
  and FilterLocation(c,LOCATION_HAND+LOCATION_SZONE)
  then
    return true
  end
end
function EidolonMaterialFilter(c,mode)
  if mode == 2 then
    return FilterLocation(c,LOCATION_GRAVE)
    or FilterLocation(c,LOCATION_HAND) --and FilterID(c,86120751,true) -- Aleister
    or FilterLocation(c,LOCATION_MZONE) 
    and not (FilterType(c,TYPE_FUSION+TYPE_SYNCHO+TYPE_XYZ)
    or FilterCrippled(c) or FilterOwner(c,2))
  end
end
function EidolonMaterialFilter2(c,attribute)
  return c.attribute == attribute
  and ExcludeID(c,86120751,true) -- Aleister
end
function ElysionMaterialFilter(c,args)
  local mode = args[1]
  local cards = args[2]
  return FilterPreviousLocation(c,LOCATION_EXTRA)
  and (mode == 1 or FilterID(c,13529466) or FilterCrippled(c)) -- Caligula
  and CardsMatchingFilter(cards,EidolonFilter,c)>0
end
function CanSummonEidolon(c,mode)
  print("checking eidolon summon: "..GetName(c))
  print("mode: "..mode)
  if not (CanSpecialSummon()
  and CheckSummonLimit(c)
  and FilterLocation(c,LOCATION_EXTRA)
  and EidolonFilter(c))
  then
    print("immediate cancel")
    return false
  end
  local cards = {}
  if mode == 1 then -- can summon at all, regardless of materials
    cards = Merge(AIHand(),AIField(),AIGrave(),OppGrave())
  elseif mode == 2 then -- can summon using favourable materials only
    cards = Merge(AIGrave(),OppGrave(),SubGroup(Merge(AIField(),AIHand()),EidolonMaterialFilter,2))
  end
  if c.id == 11270236 then -- Elysion
    print("Elysion?")
    return CardsMatchingFilter(AIMon(),ElysionMaterialFilter,{mode,cards})>0
  end
  if not HasID(cards,86120751,true) then -- Aleister
    print("no Aleister, cancel")
    return false
  end
  print("so far so good..")
  return CardsMatchingFilter(cards,EidolonMaterialFilter2,c.attribute)>0
end
function SummonElysion(c,mode)
end
function SummonMerkabah(c,mode)
end
function SummonCocytus(c,mode)
end
function SummonMagallanica(c,mode)
end
function RummonRaideen(c,mode)
end
function SummonCaligula(c,mode)
end
function SummonPurgatorio(c,mode)
end
function EidolonInit(cards)
  local Act = cards.activatable_cards
  local Sum = cards.summonable_cards
  local SpSum = cards.spsummonable_cards
  local Rep = cards.repositionable_cards
  local SetMon = cards.monster_setable_cards
  local SetST = cards.st_setable_cards
  for i,c in pairs(AIExtra()) do
    --print(CanSummonEidolon(c,1))
  end
	if HasIDNotNegated(Act,73628505) then -- Terraforming
		return Activate()
	end
	if HasIDNotNegated(Act,74063034,UseEidolonSummon,1) then
	  return Activate()
  end
 if HasIDNotNegated(Act,47679935,UseMagicCircle,1) then
	  return Activate()
  end
  if HasIDNotNegated(Act,43722862,UseIceBell,1) then
    return Activate()
  end
  if HasIDNotNegated(Act,70117860,UseSnowBell,1) then
    return Activate()
  end
  if HasID(Act,14577226,UseWinterBell,1) then
    return Activate()
  end
  if HasID(SpSum,14577226,SummonWinterBell,1) then
    return SynchroSummon()
  end
  if HasID(SpSum,82044280,SummonClearWing,1) then
    return SynchroSummon()
  end
  if HasID(SpSum,50954680,SummonCrystalWing,1) then
    return SynchroSummon()
  end
	if HasIDNotNegated(Sum,86120751,SummonAleister,1) then
    return Summon()
  end
  if HasIDNotNegated(Act,67775894,UseWonderWand,1) then
    return Activate()
  end
  if HasIDNotNegated(Act,67775894,UseWonderWand,2) then
    return Activate()
  end
	if HasIDNotNegated(Act,74063034,UseEidolonSummon,2) then
		return Activate()
	end
  return nil
end


function IceBellTarget(cards)
  return Add(cards,PRIO_TOFIELD)
end
function GlassBellTarget(cards)
  return Add(cards)
end
function WinterBellTarget(cards)
  local result = {0,0}
  for i,c in pairs(cards) do
    if c.level > result[1] then
      result[1]=c.level
      result[2]=i
    end
  end
  return {result[2]}
end
function AleisterTarget(cards)
  return Add(cards)
end
function EidolonSummonTarget(cards)
  if LocCheck(cards,LOCATION_EXTRA) then
    if GlobalCardMode == 1 then
      GlobalCardMode = nil
      return Add(cards,PRIO_TOFIELD,1,FilterGlobalTarget,cards)
    end
    return Add(cards,PRIO_TOFIELD)
  end
  return Add(cards,PRIO_BANISH,1,FilterLocation,LOCATION_GRAVE)
end
EidolonTargetFunctions={
[43722862] = IceBellTarget,
[71007216] = GlassBellTarget,
[14577226] = WinterBellTarget,
[86120751] = AleisterTarget,
[74063034] = EidolonSummonTarget,
}
function EidolonCard(cards,min,max,id,c)
  for i,v in pairs(EidolonTargetFunctions) do
    if id == i then
      return v(cards,c,min,max)
    end
  end
end
function ChainIceBell(c)
  return true
end
function ChainGlassBell(c)
  return true
end
function ChainAleister(c)
	if c.description == c.id*16+1 then
		return true
	end
	if c.description == c.id*16
	then
		local aimon,oppmon = GetBattlingMons()
		local count = CardsMatchingFilter(AIHand(),FilterID,c.id)
    if aimon and oppmon then
    end
		if aimon and oppmon
    and EidolonMonsterFilter(aimon)
    and (AttackBoostCheck(1000*count) 
		or CanFinishGame(aimon,oppmon,aimon:GetAttack()+1000*count))
		and UnchainableCheck(c.id)
		then
			return true
		end
	end
end
EidolonChainFunctions={
[43722862] = ChainIceBell,
[71007216] = ChainGlassBell,
[86120751] = ChainAleister,
}
function EidolonChain(cards)
  for id,v in pairs(EidolonChainFunctions) do
    if HasID(cards,id,v) then
      return Chain()
    end
  end
end
function EidolonEffectYesNo(id,card)
  for i,v in pairs(EidolonChainFunctions) do
    if id == i then
      return v(card)
    end
  end
  return result
end
function EidolonSum(cards,sum,card)
end
function EidolonYesNo(desc)
end
function EidolonTribute(cards,min, max)
end
function EidolonBattleCommand(cards,targets,act)
end
function EidolonAttackTarget(cards,attacker)
end
function EidolonAttackBoost(cards)
end
function EidolonOption(options)
end
function EidolonChainOrder(cards)
end
EidolonAtt={
}
EidolonVary={
}
EidolonDef={
}
function EidolonPosition(id,available)
  result = nil
  for i=1,#EidolonAtt do
    if EidolonAtt[i]==id 
    then 
      result=POS_FACEUP_ATTACK
    end
  end
  for i=1,#EidolonVary do
    if EidolonVary[i]==id 
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
  for i=1,#EidolonDef do
    if EidolonDef[i]==id 
    then 
      result=POS_FACEUP_DEFENSE 
    end
  end
  return result
end

EidolonPriorityList={                      
--[12345678] = {1,1,1,1,1,1,1,1,1,1,XXXCond},  -- Format

-- Eidolon

[20292186] = {1,1,1,1,1,1,1,1,1,1,ScytheCond}, -- Artifact Scythe
[85103922] = {1,1,1,1,1,1,1,1,1,1,MoralltachCond},  -- Artifact Moralltach
[71007216] = {2,1,4,1,1,1,1,1,1,1,GlassBellCond},  -- Wind Witch Glass Bell
[86120751] = {1,1,1,1,1,1,1,1,1,1,AleisterCond},  -- Aleister
[43722862] = {5,1,2,1,1,1,1,1,1,1,IceBellCond},  -- Wind Witch Ice Bell
[23434538] = {1,1,1,1,1,1,1,1,1,1,MaxxCond},  -- Maxx "C"
[70117860] = {7,1,3,1,1,1,1,1,1,1,WinterBellCond},  -- Wind Witch Snow Bell

[01845204] = {1,1,1,1,1,1,1,1,1,1,IFCond},  -- Instant Fusion
[73628505] = {1,1,1,1,1,1,1,1,1,1,TerraformingCond},  -- Terraforming
[74063034] = {1,1,1,1,1,1,1,1,1,1,SummoningMagicCond},  -- Eidolon Summoning Magic
[67775894] = {1,1,1,1,1,1,1,1,1,1,WonderWandCond},  -- Wonder Wand
[47679935] = {1,1,1,1,1,1,1,1,1,1,RecklessCircleCond},  -- Reckless Magic Circle

[12444060] = {1,1,1,1,1,1,1,1,1,1,SanctumCond},  -- Artifact Sanctum
[05851097] = {1,1,1,1,1,1,1,1,1,1,VanityCond},  -- Vanity
[40605147] = {1,1,1,1,1,1,1,1,1,1,StrikeCond},  -- Strike
[84749824] = {1,1,1,1,1,1,1,1,1,1,WarningCond},  -- Warning
[43898403] = {1,1,1,1,1,1,1,1,1,1,TwiTwiCond},  -- Twin Twister

[11270236] = {1,1,1,1,1,1,1,1,1,1,ElysionCond},  -- Elysion
[75286621] = {1,1,1,1,1,1,1,1,1,1,MerkabahCond},  -- Merkabah
[48791583] = {1,1,1,1,1,1,1,1,1,1,MagallanicaCond},  -- Magallanica
[12307878] = {1,1,1,1,1,1,1,1,1,1,PurgatorioCond},  -- Purgatorio
[85908279] = {1,1,1,1,1,1,1,1,1,1,CocytusCond},  -- Cocytus
[49513164] = {1,1,1,1,1,1,1,1,1,1,RaideenCond},  -- Raideen
[13529466] = {1,1,1,1,1,1,1,1,1,1,CaligulaCond},  -- Caligula
[50954680] = {1,1,1,1,1,1,1,1,1,1,CrystalWingCond},  -- Crystal Wing
[82044280] = {1,1,1,1,1,1,1,1,1,1,ClearWingCond},  -- Clear Wing
[14577226] = {1,1,1,1,1,1,1,1,1,1,WinterBellCond},  -- Wind Witch Winter Bell
[56832966] = {1,1,1,1,1,1,1,1,1,1,LightningCond},  -- Utopia Lightning
[84013237] = {1,1,1,1,1,1,1,1,1,1,UtopiaCondCond},  -- Utopia
} 