--[AB] Yatogami Tohka - Spacequakes Level 6
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
    --(1) Conjure -> Destroy 1 Enemy Monster
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1)
	e1:SetCondition(s.conjure_condition)
	e1:SetTarget(s.conjure_target)
	e1:SetOperation(s.conjure_operation)
	c:RegisterEffect(e1)
  end
--(1) Conjure -> Destroy 1 Enemy Monster
function s.conjure_condition_filter(c,e,tp)
    local hero_rank=e:GetHandler():GetRank()
	return c:IsSummonPlayer(tp) and c:IsLevel(hero_rank)
end
function s.conjure_condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.conjure_condition_filter,1,nil,e,tp)
end
function s.destroy_filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function s.conjure_target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(s.destroy_filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.destroy_filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.conjure_operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end