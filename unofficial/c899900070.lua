--[AB] Counter Star
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
    --(1) Destroy Enemy Monster With Level < Hero's Rank
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.destroy_cost)
	e1:SetTarget(s.destroy_target)
	e1:SetOperation(s.destroy_operation)
	c:RegisterEffect(e1)
end
--(1) Destroy Enemy Monster With Level < Hero's Rank
function s.essence_counter_cost(c,tp,card)
	local remove_counters=nil
	if card:IsSetCard(0x891) then remove_counters=1
	elseif card:IsSetCard(0x892) then remove_counters=2 end
	return c:IsFaceup() and c:IsCode(899900000) and c:IsCanRemoveCounter(tp,0x892,remove_counters,REASON_COST)
end
function s.destroy_cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local card=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.essence_counter_cost,tp,LOCATION_FZONE,0,1,nil,tp,card) end
	local remove_counters=nil
	if card:IsSetCard(0x891) then remove_counters=1
	elseif card:IsSetCard(0x892) then remove_counters=2 end
	local tc=Duel.GetMatchingGroup(s.essence_counter_cost,tp,LOCATION_FZONE,0,nil,tp,card):GetFirst()
	tc:RemoveCounter(tp,0x892,remove_counters,REASON_COST)
end
function s.hero_filter(c)
	return c:GetSequence()>=5
end
function s.destroy_target_filter(c,hero_rank)
	return c:IsFaceup() and c:IsLevelBelow(hero_rank-1)
end
function s.destroy_target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=Duel.GetMatchingGroup(s.hero_filter,tp,LOCATION_MZONE,0,nil):GetFirst() if not tc then return end
	local hero_rank=tc:GetRank()
	if chk==0 then return Duel.IsExistingTarget(s.destroy_target_filter,tp,0,LOCATION_MZONE,1,nil,hero_rank) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.destroy_target_filter,tp,0,LOCATION_MZONE,1,1,nil,hero_rank)
	local dmg=g:GetFirst():GetOriginalLevel()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(dmg)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,dmg)
end
function s.destroy_operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Damage(p,d,REASON_EFFECT)
	end
end
