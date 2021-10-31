--[CEDO] Candidate's Training
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
	--(1) Increase Status - ATK/DEF
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.increase_status_cost)
	e1:SetTarget(s.increase_status_target)
	e1:SetOperation(s.increase_status_operation)
	c:RegisterEffect(e1)
end
--(1) Increase Status - ATK
function s.essence_counter_cost(c,tp,card)
	local remove_counters=nil
	if card:IsSetCard(0x891) then remove_counters=1
	elseif card:IsSetCard(0x892) then remove_counters=2 end
	return c:IsFaceup() and c:IsCode(899900000) and c:IsCanRemoveCounter(tp,0x892,remove_counters,REASON_COST)
end
function s.increase_status_cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local card=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.essence_counter_cost,tp,LOCATION_FZONE,0,1,nil,tp,card) end
	local remove_counters=nil
	if card:IsSetCard(0x891) then remove_counters=1
	elseif card:IsSetCard(0x892) then remove_counters=2 end
	local tc=Duel.GetMatchingGroup(s.essence_counter_cost,tp,LOCATION_FZONE,0,nil,tp,card):GetFirst()
	tc:RemoveCounter(tp,0x892,remove_counters,REASON_COST)
end
function s.increase_status_filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function s.increase_status_target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(s.increase_status_filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.increase_status_filter,tp,LOCATION_MZONE,0,1,2,nil)
end
function s.increase_status_operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	local tc=g:GetFirst()
    for tc in aux.Next(g) do
        if tc and tc:IsFaceup() then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(1)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_UPDATE_DEFENSE)
            tc:RegisterEffect(e2)
        end
	end
end