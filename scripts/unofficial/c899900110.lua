--[CEDO] Bits Of Sorrow
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
    --(1) Grim -> Summon 1 Level 3 Or Lower -> Give It Enduring
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_GRAVE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(s.grim_condition)
	e1:SetCost(s.grim_cost)
	e1:SetTarget(s.grim_target)
	e1:SetOperation(s.grim_operation)
	c:RegisterEffect(e1)
end
--(1) Grim -> Summon 1 Level 3 Or Lower -> Give It Enduring
function s.essence_counter_cost(c,tp,card)
	local remove_counters=nil
	if card:IsSetCard(0x891) then remove_counters=1
	elseif card:IsSetCard(0x892) then remove_counters=2
	elseif card:IsSetCard(0x893) then remove_counters=3 end
	return c:IsFaceup() and c:IsCode(899900000) and c:IsCanRemoveCounter(tp,0x892,remove_counters,REASON_COST)
end
function s.grim_cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local card=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.essence_counter_cost,tp,LOCATION_FZONE,0,1,nil,tp,card) end
	local remove_counters=nil
	if card:IsSetCard(0x891) then remove_counters=1
	elseif card:IsSetCard(0x892) then remove_counters=2
	elseif card:IsSetCard(0x893) then remove_counters=3 end
	local tc=Duel.GetMatchingGroup(s.essence_counter_cost,tp,LOCATION_FZONE,0,nil,tp,card):GetFirst()
	tc:RemoveCounter(tp,0x892,remove_counters,REASON_COST)
end
function s.grim_condition_filter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
end
function s.grim_condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.grim_condition_filter,1,nil,tp)
end
function s.special_summon_filter(c,e,tp)
	return c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.grim_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.special_summon_filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.grim_operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.special_summon_filter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		--Enduring
        local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetCountLimit(1)
		e1:SetValue(s.enduring_value)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
--Enduring
function s.enduring_value(e,re,r,rp)
	return (r&REASON_BATTLE)~=0
end