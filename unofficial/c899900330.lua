--[AB] Spacequake
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
    --(1) Summon 1 Random Spirit Monster
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(s.summon_cost)
	e1:SetTarget(s.summon_target)
	e1:SetOperation(s.summon_operation)
	c:RegisterEffect(e1)
end

s.spirits = {899900340,899900350}

--(1) Summon 1 Random Spirit Monster
function s.essence_counter_cost(c,tp,card)
	local remove_counters=nil
	if card:IsSetCard(0x891) then remove_counters=1
	elseif card:IsSetCard(0x892) then remove_counters=2
	elseif card:IsSetCard(0x893) then remove_counters=3 
    elseif card:IsSetCard(0x894) then remove_counters=4 end
	return c:IsFaceup() and c:IsCode(899900000) and c:IsCanRemoveCounter(tp,0x892,remove_counters,REASON_COST)
end
function s.summon_cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local card=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.essence_counter_cost,tp,LOCATION_FZONE,0,1,nil,tp,card) end
	local remove_counters=nil
	if card:IsSetCard(0x891) then remove_counters=1
	elseif card:IsSetCard(0x892) then remove_counters=2
	elseif card:IsSetCard(0x893) then remove_counters=3
    elseif card:IsSetCard(0x894) then remove_counters=4 end
	local tc=Duel.GetMatchingGroup(s.essence_counter_cost,tp,LOCATION_FZONE,0,nil,tp,card):GetFirst()
	tc:RemoveCounter(tp,0x892,remove_counters,REASON_COST)
end
function s.summon_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,899900340,0,TYPES_MONSTER,2,4,4,RACE_SPELLCASTER,ATTRIBUTE_WATER,POS_FACEUP) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.summon_operation(e,tp,eg,ep,ev,re,r,rp)
    local code=s.spirits[math.random(#s.spirits)]
    local card=Duel.CreateToken(tp,code)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,card:GetCode(),0,TYPES_MONSTER,card:GetAttack(),card:GetDefense(),card:GetLevel(),card:GetRace(),card:GetAttribute(),POS_FACEUP) then
		if Duel.SpecialSummon(card,0,tp,tp,false,false,POS_FACEUP)~=0 then
            --Shuffle Spacequake Into The Deck
            local card2=Duel.CreateToken(tp,id)
            Duel.SendtoDeck(card2,nil,2,REASON_EFFECT)
        end
	end
end
