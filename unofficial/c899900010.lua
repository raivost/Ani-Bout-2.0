--[CEDO] Aika Tsube
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
	--(1) Play And Daunt -> Change Battle Position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(s.play_condition)
	e1:SetTarget(s.play_target)
	e1:SetOperation(s.play_operation)
	c:RegisterEffect(e1)
    --(2) Advance Summon -> Tail Blue
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1)
	e2:SetCost(s.advance_summon_cost)
	e2:SetTarget(s.advance_summon_target)
	e2:SetOperation(s.advance_summon_operation)
	c:RegisterEffect(e2)
end

s.advanced_code  = 899900020
s.advanced_ATK   = 4
s.advanced_DEF   = 2
s.advanced_level = 4
s.advanced_race  = RACE_WARRIOR
s.advanced_attr  = ATTRIBUTE_WATER

--(1) Play And Daunt -> Change Battle Position
function s.daunt_position_filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function s.play_condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
		and Duel.GetMatchingGroupCount(s.daunt_position_filter,tp,0,LOCATION_MZONE,nil)>Duel.GetMatchingGroupCount(s.daunt_position_filter,tp,LOCATION_MZONE,0,nil)
end
function s.play_target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(s.daunt_position_filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,s.daunt_position_filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function s.play_operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
	end
end
--(2) Advance Summon -> Tail Blue
function s.essence_counter_cost(c,tp,level)
	return c:IsFaceup() and c:IsCode(899900000) and c:IsCanRemoveCounter(tp,0x892,level,REASON_COST)
end
function s.advance_summon_cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local level=e:GetHandler():GetLevel()
	if chk==0 then return Duel.IsExistingMatchingCard(s.essence_counter_cost,tp,LOCATION_FZONE,0,1,nil,tp,level) end
	local tc=Duel.GetMatchingGroup(s.essence_counter_cost,tp,LOCATION_FZONE,0,nil,tp,level):GetFirst()
	tc:RemoveCounter(tp,0x892,level,REASON_COST)
end
function s.advance_summon_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,s.advanced_code,0,TYPES_MONSTER,s.advanced_ATK,s.advanced_DEF,s.advanced_level,s.advanced_race,s.advanced_attr,POS_FACEUP)
	 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.advance_summon_operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,s.advanced_code,0,TYPES_MONSTER,s.advanced_ATK,s.advanced_DEF,s.advanced_level,s.advanced_race,s.advanced_attr,POS_FACEUP) then
        Duel.SendtoDeck(c,nil,-2,REASON_RULE)
		Duel.ShuffleHand(tp)
		local card=Duel.CreateToken(tp,s.advanced_code)
		Duel.SpecialSummon(card,0,tp,tp,false,false,POS_FACEUP)
	end
end