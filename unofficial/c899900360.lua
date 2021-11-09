--[AB] Shido
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
    --(1) Play -> Exhaust 1 Monster Level 4+ -> Forge 2 Spacequake - 1 In Hand And 1 In Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(s.play_condition)
	e1:SetTarget(s.play_target)
	e1:SetOperation(s.play_operation)
	c:RegisterEffect(e1)
end
--(1) Play -> Exhaust 1 Monster Level 4+ -> Forge 2 Spacequake - 1 In Hand And 1 In Deck
function s.play_condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function s.exhaust_filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevelAbove(4)
end
function s.play_target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.exhaust_filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0)
end
function s.play_operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local tc=Duel.SelectMatchingCard(tp,s.exhaust_filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil):GetFirst()
    if Duel.SendtoDeck(tc,nil,-2,REASON_RULE)~=0 then
        local card1=Duel.CreateToken(tp,899900330)
        local card2=Duel.CreateToken(tp,899900330)
        Duel.SendtoHand(card1,nil,REASON_EFFECT)
        Duel.SendtoDeck(card2,nil,2,REASON_EFFECT)
    end
end