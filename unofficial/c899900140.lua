--[CEDO] Charlotte
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
    --(1) Play -> Destroy 1 Monster On Both Sides
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCondition(s.play_condition)
	e1:SetTarget(s.play_target)
	e1:SetOperation(s.play_operation)
	c:RegisterEffect(e1)
	--(2) Demise -> Forge 1 Random Level 1 Monster (From GY)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
    e2:SetCondition(s.demise_condition)
	e2:SetTarget(s.demise_target)
	e2:SetOperation(s.demise_operation)
	c:RegisterEffect(e2)
end
--(1) Play -> Destroy 1 Monster On Both Sides
function s.play_condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function s.destroy_target_filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function s.play_target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(s.destroy_target_filter,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.IsExistingTarget(s.destroy_target_filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,s.destroy_target_filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,s.destroy_target_filter,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function s.play_operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #tg>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
--(2) Demise -> Forge 1 Random Level 1 Monster (From GY)
function s.demise_condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function s.forge_target_filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevel(1)
end
function s.demise_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.forge_target_filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0)
end
function s.demise_operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.forge_target_filter,tp,LOCATION_GRAVE,0,nil)
	if #g==0 then return end
    local n=Duel.GetRandomNumber(0,#g)-1
    local tc=g:GetFirst()
    for i=1,n do tc=g:GetNext() end
	local card=Duel.CreateToken(tp,tc:GetCode())
	Duel.SendtoHand(card,nil,REASON_EFFECT)
end