--星痕の機界騎士
--Mekk-Knight of the World Remains
--Scripted by Eerie Code
function c101003047.initial_effect(c)
  c:EnableReviveLimit()
  aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x20c),2)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(c101003047.dircon)
	c:RegisterEffect(e1)
	--cannot be target/effect indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101003047.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101003047,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,101003047)
	e4:SetCost(c101003047.spcost)
	e4:SetTarget(c101003047.sptg)
	e4:SetOperation(c101003047.spop)
	c:RegisterEffect(e4)
end
function c101003047.dircon(e)
	return Duel.GetFieldGroupCount(Card.IsOnSameColumn,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e:GetHandler(),true)==0
end
function c101003047.indcon(e)
	local c=e:GetHandler()
	return c:GetSequence()>4 and c:GetLinkedGroupCount()==0
end
function c101003047.spcfilter(c,hc)
	return c:IsOnSameColumn(hc) and c:IsAbleToGraveAsCost()
end
function c101003047.spfilter(c,e,tp)
	return c:IsSetCard(0x20c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c101003047.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local loc=LOCATION_ONFIELD
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then loc=LOCATION_MZONE end
	if chk==0 then return Duel.IsExistingMatchingCard(c101003047.spcfilter,tp,loc,0,1,c,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101003047.spcfilter,tp,loc,0,1,1,c,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c101003047.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101003047.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101003047.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101003047.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
