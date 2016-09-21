------------------------
-------- FILTER --------
------------------------
-- FluffalM Filter
function FluffalFilter(c)
  return IsSetCode(c.setcode,0xa9)
end
-- EdgeImp Filter
function EdgeImpFilter(c)
  return IsSetCode(c.setcode,0xc3)
end
-- Other Filter
-- FluffalS Filter
function ToyVendorCheckFilter(c,canUse)
  if canUse then
    return c.id == 70245411 and OPTCheck(c.cardid)
  else
    return c.id == 70245411 and not OPTCheck(c.cardid)
  end
end
-- Spell Filter
-- Trap Filter
-- Frightfur Filter
function FrightfurMonFilter(c)
  return IsSetCode(c.setcode,0xad) and FilterType(c,TYPE_MONSTER)
end
function FLeoFinishFilter(c,source)
  return
    AI.GetPlayerLP(2)<= c.base_attack -- Origian Attack
	and Targetable(c,TYPE_MONSTER)
	and FluffalDestroyFilter(c)
    and Affected(c,TYPE_MONSTER)
end
function FTigerDestroyFilter(c)
  return (
    Targetable(c,TYPE_MONSTER)
    and Affected(c,TYPE_MONSTER)
	and FluffalDestroyFilter(c)
	and not IgnoreList(c)
  )
end
function FKrakenSendFilter(c)
  return (
    Targetable(c,TYPE_MONSTER)
    and Affected(c,TYPE_MONSTER)
	and FluffalSendFilter(c)
  )
end

-- Other
function FluffalDestroyFilter(c,nontarget)
  return not FilterAffected(c,EFFECT_INDESTRUCTABLE_EFFECT)
  and not FilterStatus(c,STATUS_LEAVE_CONFIRMED)
  and (nontarget==true or not FilterAffected(c,EFFECT_CANNOT_BE_EFFECT_TARGET))
  and not (DestroyBlacklist(c) and FilterPublic(c))
  and not BypassDestroyFilter(c)
end
function FluffalSendFilter(c,nontarget)
  return not FilterStatus(c,STATUS_LEAVE_CONFIRMED)
  and (nontarget==true or not FilterAffected(c,EFFECT_CANNOT_BE_EFFECT_TARGET))
end

function BypassDestroyFilter(c) --Indexes cards that the AI fails to check with DestroyFilter normally. Sins, C-Lancer, ArchSeraph, eartH, Kagutsuchi, Sentry, Beetle, Yoke, SHARK, Full Lancer, Maestroke, Zenmaines, Gantetsu, U-Future, Angineer, Winda, Wickedwitch
  return (((c.id==62541668
  or c.id==99469936
  or c.id==67173574
  or c.id==23998625
  or c.id==01855932
  or c.id==49678559
  or c.id==76067258
  or c.id==23232295
  or c.id==48739166
  or c.id==25853045
  or c.id==25341652
  or c.id==78156759
  or c.id==10002346
  or c.id==65305468
  or c.id==15914410)
  and c.xyz_material_count>0)
  or c.id==94977269
  or c.id==93302695)
  and NotNegated(c)
end



------------------------
-------- COUNT ---------
------------------------
-- General Count
function CountPrioTarget(cards,loc,minPrio,Type,filter,opt,debugMode)
  local result = 0
  if minPrio == nil then
    minPrio = 1
  end
  for i=1, #cards do
    local c = cards[i]
	c.prio = GetPriority(c,loc)
	if not FilterCheck(c,filter,opt)
    or not (Type == nil or bit32.band(c.type,Type) > 0)	then
      c.prio = -1
    end
	if debugMode ~= nil then
	  print(debugMode.." - id: "..c.id.." - Prio: "..c.prio.." - Type: "..c.type)
	end
	if c.prio > minPrio then
	  result = result + 1
	end
  end
  if debugMode ~= nil then
	print(debugMode.." - Count: "..result)
  end
  return result
end
-- FluffalM Count
function CountWingsTarget()
  local result = 0
  --result = CountPrioTarget(AIGrave(),PRIO_BANISH,1,TYPE_MONSTER,FluffalFilter,nil,"CountWingsTarget")
  result = CountPrioTarget(AIGrave(),PRIO_BANISH,1,TYPE_MONSTER,FluffalFilter)
  return result
end
function CountFluffal(cards)
  return CardsMatchingFilter(cards,FluffalFilter)
end
function CountFluffalGraveTarget(cards)
  local result = 0
  result = CountPrioTarget(cards,PRIO_TOGRAVE,1,TYPE_MONSTER,FluffalFilter)
  return result
end
function CountFluffalBanishTarget(cards)
  local result = 0
  --result = CountPrioTarget(cards,PRIO_BANISH,1,TYPE_MONSTER,FluffalFilter,nil,"CountFluffalBanishTarget")
  result = CountPrioTarget(cards,PRIO_BANISH,1,TYPE_MONSTER,FluffalFilter)
  return result
end
-- EdgeImp Count
function CountEgdeImp(cards)
  return CardsMatchingFilter(cards,EdgeImpFilter)
end
-- Other
-- FluffalS Count
function CountToyVendorDiscardTarget()
  local result = 0
  local minPrio = 2
  if AI.GetPlayerLP(1) <= 4000
  or OppGetStrongestAttack() >= AI.GetPlayerLP(1)
  then
    minPrio = 1
  end
  if AI.GetPlayerLP(1) <= 2000
  or OppGetStrongestAttack() >= AI.GetPlayerLP(1)
  then
    minPrio = 0
  end
  --result = CountPrioTarget(AIHand(),PRIO_DISCARD,minPrio,nil,nil,nil,"CountToyVendorDiscardTarget")
  result = CountPrioTarget(AIHand(),PRIO_DISCARD,minPrio)
  --print("CountToyVendorDiscardTarget: "..result)
  return result
end
-- Spell Count
-- Trap Count
-- Frightfur Count
function CountFrightfurMon(cards)
  return CardsMatchingFilter(cards,FrightfurMonFilter)
end
function CountFusionTarget()
  local result = 0
  --result = CountPrioTarget(AIExtra(),PRIO_TOFIELD,1,nil,nil,nil,"CountFusionTarget")
  result = CountPrioTarget(AIExtra(),PRIO_TOFIELD,1)
  return result
end
function CountMaterialFTarget(cards)
  local result = 0
  local minPrio = 2
  if(
    AI.GetPlayerLP(1) <= 2500
	or OppGetStrongestAttack() >= AI.GetPlayerLP(1)
  ) then
    minPrio = 0
  end
  --result = CountPrioTarget(cards,PRIO_TOGRAVE,minPrio,TYPE_MONSTER,FluffalFilter,nil,"CountMaterialFTarget")
  result = CountPrioTarget(cards,PRIO_TOGRAVE,minPrio,TYPE_MONSTER,FluffalFilter)
  --print("CountMaterialFTarget: "..result)
  return result
end
function CountMaterialETarget(cards)
  local result = 0
  --result = CountPrioTarget(cards,PRIO_TOGRAVE,1,TYPE_MONSTER,EdgeImpFilter,nil,"CountMaterialETarget")
  result = CountPrioTarget(cards,PRIO_TOGRAVE,1,TYPE_MONSTER,EdgeImpFilter)
  --print("CountMaterialETarget: "..result)
  return result
end

--39246582, -- Fluffal Dog
--03841833, -- Fluffal Bear
--65331686, -- Fluffal Owl
--98280324, -- Fluffal Sheep
--02729285, -- Fluffal Cat
--38124994, -- Fluffal Rabit
--06142488, -- Fluffal Mouse
--72413000, -- Fluffal Wings
--00006131, -- Fluffal Patchwork (BETA)
--00007614, -- Fluffal Octo (BETA)
--97567736, -- Edge Imp Tomahawk
--61173621, -- Edge Imp Chain
--30068120, -- Edge Imp Sabres
--10802915, -- Tour Guide from the Underworld
--79109599, -- King of the Swamp
--67441435, -- Glow-Up Bulb

--70245411, -- Toy Vendor
--06077601, -- Frightfur Fusion
--43698897, -- Frightfur Factory
--01845204, -- Instant Fusion
--24094653, -- Polymerization
--94820406, -- Dark Fusion
--05133471, -- Galaxy Cyclone
--43898403, -- Twin Twister

--66127916, -- Fusion Reserve

--80889750, -- Frightfur Sabre-Tooth
--00007620, -- Frightfur Kraken (BETA)
--10383554, -- Frightfur Leo
--85545073, -- Frightfur Bear
--11039171, -- Frightfur Wolf
--00464362, -- Frightfur Tiger
--57477163, -- Frightfur Sheep
--41209827, -- Starve Venom Fusion Dragon
--33198837, -- Naturia Beast
--42110604, -- Hi-Speedroid Chanbara
--82633039, -- Castel
--83531441, -- Dante