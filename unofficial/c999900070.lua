--[FTV] Sharp Conjuration
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
    --(1) Summon 2 Spectral Wolves -> If Daunt -> Increase Status - ATK 
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
--(1) Exhaust 1 Monster -> Draw 2 cards
function s.exhaust_filter(c)
	return c:IsType(TYPE_MONSTER)
end
function s.essence_counter_cost(c,tp,card)
	local remove_counters=nil
	if card:IsSetCard(0x891) then remove_counters=1
	elseif card:IsSetCard(0x892) then remove_counters=2 end
	return c:IsFaceup() and c:IsCode(999900000) and c:IsCanRemoveCounter(tp,0x892,remove_counters,REASON_COST)
end
function s.summon_cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local card=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.essence_counter_cost,tp,LOCATION_FZONE,0,1,nil,tp,card) end
	local remove_counters=nil
	if card:IsSetCard(0x891) then remove_counters=1
	elseif card:IsSetCard(0x892) then remove_counters=2 end
	local tc=Duel.GetMatchingGroup(s.essence_counter_cost,tp,LOCATION_FZONE,0,nil,tp,card):GetFirst()
	tc:RemoveCounter(tp,0x892,remove_counters,REASON_COST)
end
function s.summon_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,id+5,0,TYPES_MONSTER,1,1,1,RACE_BEAST,ATTRIBUTE_EARTH,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.summon_operation(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    if ft>1 then ft=2 else ft=1 end
    local card=nil
    local daunt_test=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
    while ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,id+5,0,TYPES_MONSTER,1,1,1,RACE_BEAST,ATTRIBUTE_EARTH,POS_FACEUP) do
        card=Duel.CreateToken(tp,id+5)
        Duel.SpecialSummon(card,0,tp,tp,false,false,POS_FACEUP)
        if daunt_test>2 then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            e1:SetValue(1)
            card:RegisterEffect(e1)
        end
        ft=ft-1
    end
end