--[AB] Beautiful Flash Asuna
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
	--(1) Flash Strike
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
    --(2) Speed Summon As Level 1
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1)
    e2:SetCondition(s.speed_summon_condition)
	e2:SetTarget(s.speed_summon_target)
	e2:SetOperation(s.speed_summon_operation)
	c:RegisterEffect(e2)
end
--(2) Speed Summon As Level 1
function s.hero_filter(c)
	return c:GetSequence()>=5
end
function s.influence_counter(c)
	return c:IsFaceup() and c:IsCode(899900000)
end
function s.current_monsters_filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function s.speed_summon_condition(e,tp,eg,ep,ev,re,r,rp)
    local tc1=Duel.GetMatchingGroup(s.hero_filter,tp,LOCATION_MZONE,0,nil):GetFirst() if not tc1 then return end
	if chk==0 then return Duel.IsExistingMatchingCard(s.influence_counter,tp,LOCATION_FZONE,0,1,nil) end
	local tc2=Duel.GetMatchingGroup(s.essence_counter_cost,tp,LOCATION_FZONE,0,nil,tp,level):GetFirst()
    local g=Duel.GetMatchingGroup(s.current_monsters_filter,tp,LOCATION_MZONE,0,nil)
    local hero_rank             = tc1:GetRank()
	local influence_counter     = tc2:GetCounter(0x891)
    local speed_summon_level    = 1
    local total_levels_on_field = 0
    if #g > 0 then
        total_levels_on_field = g:GetSum(Card.GetLevel)
    end
    return hero_rank >= speed_summon_level and total_levels_on_field + speed_summon_level <= influence_counter
        and Duel.GetMatchingGroupCount(s.current_monsters_filter,tp,0,LOCATION_MZONE,nil)>Duel.GetMatchingGroupCount(s.current_monsters_filter,tp,LOCATION_MZONE,0,nil)
end
function s.speed_summon_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.speed_summon_operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CHANGE_LEVEL)
    e1:SetValue(1)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
    c:RegisterEffect(e1)
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
        local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(3)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
    end
end