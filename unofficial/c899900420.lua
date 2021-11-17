--[AB] Heaven's Death Lament
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
    --(1) Draw 1 Card For Each 2 Essences 
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(s.draw_cost)
	e1:SetTarget(s.draw_target)
	e1:SetOperation(s.draw_operation)
	c:RegisterEffect(e1)
    --(2) Grim -> Change to Level 2
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(s.grim_condition)
	e2:SetOperation(s.grim_operation)
	c:RegisterEffect(e2)
end
--(1) Draw 1 Card For Each 2 Essences
function s.essence_counter_cost(c,tp,card)
	local remove_counters=nil
	if card:IsSetCard(0x891) then remove_counters=1
	elseif card:IsSetCard(0x892) then remove_counters=2
	elseif card:IsSetCard(0x893) then remove_counters=3 
    elseif card:IsSetCard(0x894) then remove_counters=4 end
	return c:IsFaceup() and c:IsCode(899900000) and c:IsCanRemoveCounter(tp,0x892,remove_counters+2,REASON_COST)
end
function s.draw_cost(e,tp,eg,ep,ev,re,r,rp,chk)
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
function s.draw_filter(c)
	return c:IsFaceup() and c:IsCode(899900000)
end
function s.draw_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(s.draw_filter,tp,LOCATION_FZONE,0,1,nil) end
    local tc=Duel.GetMatchingGroup(s.draw_filter,tp,LOCATION_FZONE,0,nil):GetFirst()
    local draw_number=math.floor(tc:GetCounter(0x892)/2)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(draw_number)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,draw_number)
end
function s.draw_operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--(2) Grim -> Change to Level 2
function s.grim_condition_filter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
end
function s.grim_condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	return eg:IsExists(s.grim_condition_filter,1,nil,tp) and not (c:IsSetCard(0x892) or c:IsSetCard(0x891))
end
function s.grim_operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsSetCard(0x892) or c:IsSetCard(0x891) or not c:IsLocation(LOCATION_HAND) then return end
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,2))
    e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_ADD_SETCODE)
    e1:SetValue(0x892)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
    c:RegisterEffect(e1)
end