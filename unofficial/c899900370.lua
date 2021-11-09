--[AB] Golden Faith Black Heart
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
    --(1) Advance Summon This Card
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCost(s.advance_summon_cost)
	e1:SetTarget(s.advance_summon_target)
	e1:SetOperation(s.advance_summon_operation)
	c:RegisterEffect(e1)
    --(2) Play -> Reduce The Level Of All Advanced Monster From Your Hand Or Field By 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_LVCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(s.play_condition)
	e2:SetTarget(s.play_target)
	e2:SetOperation(s.play_operation)
	c:RegisterEffect(e2)
    --(3) Warcry -> Reduce The ATK/DEF Of Enemy Monsters By 1 For Each Advanced Monster You Control
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
	e3:SetCondition(s.warcry_condition)
	e3:SetTarget(s.warcry_target)
	e3:SetOperation(s.warcry_operation)
	c:RegisterEffect(e3)
end
--(1) Advance Summon This Card
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
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.advance_summon_operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
        local e1=Effect.CreateEffect(c)
        e1:SetDescription(aux.Stringid(id,3))
        e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_ADD_SETCODE)
        e1:SetValue(0x88E)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e1)
    end
end
--(2) Play -> Reduce The Level Of All Advanced Monster From Your Hand Or Field By 2
function s.play_condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function s.reduce_level_filter(c)
	return c:IsLevelAbove(2) and c:IsSetCard(0x88E)
end
function s.play_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.reduce_level_filter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end
end
function s.play_operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.reduce_level_filter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
    local tc=g:GetFirst()
	for tc in aux.Next(g) do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_LEVEL)
        e1:SetValue(-2)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
        tc:RegisterEffect(e1)
	end
end
--(3) Warcry -> Reduce The ATK/DEF Of Enemy Monsters By 1 For Each Advanced Monster You Control
function s.warcry_condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.advanced_filter(c)
	return c:IsFaceup() and c:IsSetCard(0x88E)
end
function s.reduce_status_filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and (c:IsAttackAbove(1) or c:IsDefenseAbove(1))
end
function s.warcry_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.advanced_filter,tp,LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingMatchingCard(s.reduce_status_filter,tp,0,LOCATION_MZONE,1,nil) end
end
function s.warcry_operation(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetMatchingGroupCount(s.advanced_filter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(s.reduce_status_filter,tp,0,LOCATION_MZONE,nil)
	if #g>0 and ct>0 then
        local tc=g:GetFirst()
        for tc in aux.Next(g) do
            if tc and tc:IsFaceup() then
                local reduce_value=ct
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