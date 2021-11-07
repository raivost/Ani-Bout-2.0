--[AB] Zombie Nr.3, Ai
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
	--(1) Conjure (opponent) -> Reduce The Level Of 1 Monster In Hand By 1
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.conjure_condition)
	e1:SetTarget(s.conjure_target)
	e1:SetOperation(s.conjure_operation)
	c:RegisterEffect(e1)
end
--(1) Conjure (opponent) -> Reduce The Level Of 1 Monster In Hand By 1
function s.conjure_condition_filter(c,e,tp)
	return c:IsSummonPlayer(1-tp) and c:IsLevelAbove(1)
end
function s.conjure_condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.conjure_condition_filter,1,nil,e,tp)
end
function s.reduce_level_filter(c)
	return c:IsLevelAbove(2)
end
function s.conjure_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.reduce_level_filter,tp,LOCATION_HAND,0,1,nil) end
end
function s.conjure_operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local g=Duel.SelectMatchingCard(tp,s.reduce_level_filter,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_LEVEL)
        e1:SetValue(-1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
        g:GetFirst():RegisterEffect(e1)
	end
end