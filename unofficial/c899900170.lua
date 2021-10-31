--[CEDO] Compile
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
	--(1) Play -> Exhaust And Forge 1 Card (From Hand)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(s.play_condition)
	e1:SetTarget(s.play_target)
	e1:SetOperation(s.play_operation)
	c:RegisterEffect(e1)
end
--(1) Play -> Exhaust And Forge 1 Card (From Hand)
function s.play_condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function s.exhaust_filter(c,tp)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL) and Duel.IsExistingMatchingCard(s.forge_target_filter,tp,LOCATION_HAND,0,1,c)
end
function s.forge_target_filter(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL)
end
function s.play_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.exhaust_filter,tp,LOCATION_HAND,0,1,nil,tp) end
	--Exhaust Card
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
    local g1=Duel.SelectMatchingCard(tp,s.exhaust_filter,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.SetTargetCard(g1)
	--Forge Card
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
    local g2=Duel.SelectMatchingCard(tp,s.forge_target_filter,tp,LOCATION_HAND,0,1,1,g1:GetFirst())
    e:SetLabelObject(g2:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0)
end
function s.play_operation(e,tp,eg,ep,ev,re,r,rp)
    local tc1=Duel.GetFirstTarget()
    local tc2=e:GetLabelObject()
	if tc1 and tc2 then
		--Exhaust
        Duel.SendtoDeck(tc1,nil,-2,REASON_RULE)
		--Forge
        local card=Duel.CreateToken(tp,tc2:GetCode())
        Duel.SendtoHand(card,nil,REASON_EFFECT)
	end
end