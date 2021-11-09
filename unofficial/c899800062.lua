--[AB] Shana - Nietono no Shana Level 3
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
    --(1) Frenzy -> Use 2 Essences - Give All Allied Monsters 1 ATK
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(s.frenzy_condition)
    e1:SetCost(s.frenzy_cost)
	e1:SetTarget(s.frenzy_target)
	e1:SetOperation(s.frenzy_operation)
	c:RegisterEffect(e1)
end
--(1) Frenzy -> Use 2 Essences - Give All Allied Monsters 1 ATK
function s.frenzy_condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function s.essence_counter_cost(c,tp)
	return c:IsFaceup() and c:IsCode(899900000) and c:IsCanRemoveCounter(tp,0x892,2,REASON_COST)
end
function s.frenzy_cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.essence_counter_cost,tp,LOCATION_FZONE,0,1,nil,tp) end
	local tc=Duel.GetMatchingGroup(s.essence_counter_cost,tp,LOCATION_FZONE,0,nil,tp):GetFirst()
	tc:RemoveCounter(tp,0x892,2,REASON_COST)
end
function s.increase_status_filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function s.frenzy_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.increase_status_filter,tp,LOCATION_MZONE,0,1,nil) end
end
function s.frenzy_operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.increase_status_filter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end