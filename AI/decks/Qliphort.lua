function QliphortFilter(c)
  return IsSetCode(c.setcode,0xaa)
end
function ToolCond(loc,c)
  return true
end
function KillerCond(loc,c)
  return true
end
function ShellCond(loc,c)
  return true
end
function DiskCond(loc,c)
  return true
end
function GenomeCond(loc,c)
  return true
end
function ArchiveCond(loc,c)
  return true
end
function OddEyesCond(loc,c)
  return true
end
function LynxCond(loc,c)
  return true
end
function SacrificeCond(loc,c)
  return true
end
function ApoCond(loc,c)
  return true
end
function QliphortInit(cards)
  local Activatable = cards.activatable_cards
  local Summonable = cards.summonable_cards
  local SpSummonable = cards.spsummonable_cards
  local Repositionable = cards.repositionable_cards
  local SetableMon = cards.monster_setable_cards
  local SetableST = cards.st_setable_cards
  return nil
end
function QliphortCard(cards,min,max,id,c)
  if c then
    id = c.id
  end
  return nil
end
function QliphortChain(cards)
  return nil
end
function QliphortEffectYesNo(id,card)
  local result = nil
  return result
end
QliphortAtt={
}
QliphortDef={
}
function QliphortPosition(id,available)
  result = nil
  for i=1,#QliphortAtt do
    if QliphortAtt[i]==id then result=POS_FACEUP_ATTACK end
  end
  for i=1,#QliphortDef do
    if QliphortDef[i]==id then result=POS_FACEUP_DEFENCE end
  end
  return result
end