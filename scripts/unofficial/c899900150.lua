--[CEDO] Rain Of Vain
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
	--(1) Reduce Status - ATK/DEF
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.reduce_status_cost)
	e1:SetTarget(s.reduce_status_target)
	e1:SetOperation(s.reduce_status_operation)
	c:RegisterEffect(e1)
end
function s.essence_counter_cost(c,tp,card)
	local remove_counters=nil
	if card:IsSetCard(0x891) then remove_counters=1
	elseif card:IsSetCard(0x892) then remove_counters=2
	elseif card:IsSetCard(0x893) then remove_counters=3 end
	return c:IsFaceup() and c:IsCode(899900000) and c:IsCanRemoveCounter(tp,0x892,remove_counters,REASON_COST)
end
function s.exhaust_filter(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL)
end
function s.hero_filter(c)
	return c:GetSequence()>=5
end
function s.reduce_status_cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local card=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.essence_counter_cost,tp,LOCATION_FZONE,0,1,nil,tp,card) end
	local remove_counters=nil
	if card:IsSetCard(0x891) then remove_counters=1
	elseif card:IsSetCard(0x892) then remove_counters=2
	elseif card:IsSetCard(0x893) then remove_counters=3 end
	local tc=Duel.GetMatchingGroup(s.essence_counter_cost,tp,LOCATION_FZONE,0,nil,tp,card):GetFirst()
	tc:RemoveCounter(tp,0x892,remove_counters,REASON_COST)
end
function s.reduce_status_filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and (c:IsAttackAbove(1) or c:IsDefenseAbove(1))
end
function s.reduce_status_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.reduce_status_filter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(s.exhaust_filter,tp,LOCATION_GRAVE,0,2,nil) end
end
function s.reduce_status_operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetMatchingGroup(s.hero_filter,tp,LOCATION_MZONE,0,nil):GetFirst()
    if not tc then return end
	local hero_rank=tc:GetRank()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local g1=Duel.SelectMatchingCard(tp,s.exhaust_filter,tp,LOCATION_GRAVE,0,2,hero_rank*2,nil)
	if #g1>0 and Duel.SendtoDeck(g1,nil,-2,REASON_RULE)~=0 then
		local g2=Duel.GetMatchingGroup(s.reduce_status_filter,tp,0,LOCATION_MZONE,nil)
		local reduce_value=math.floor(#g1/2)
		if #g2>0 and reduce_value>0 then
			for tc in aux.Next(g2) do
				if tc:IsAttackAbove(reduce_value) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_UPDATE_ATTACK)
					e1:SetValue(-reduce_value)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				else
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_UPDATE_ATTACK)
					e1:SetValue(-tc:GetAttack())
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
				if tc:IsDefenseAbove(reduce_value) then
					local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_UPDATE_DEFENSE)
					e2:SetValue(-reduce_value)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e2)
				else
					local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_UPDATE_DEFENSE)
					e2:SetValue(-tc:GetDefense())
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e2)
				end
			end
		end
	end
end