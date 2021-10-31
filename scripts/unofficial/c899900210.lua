--[CEDO] God Of Ink
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
    --(1) Discard 1 Card -> Draw 2 cards
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(s.draw_cost)
    e1:SetTarget(s.draw_target)
    e1:SetOperation(s.draw_operation)
    c:RegisterEffect(e1)
    --(2) Scrap -> Reduce The Level Of 1 Card In Hand By 1
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(s.scrap_condition)
	e2:SetTarget(s.scrap_target)
	e2:SetOperation(s.scrap_operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end
--(1) Discard 1 Card -> Draw 2 cards
function s.essence_counter_cost(c,tp,card)
	local remove_counters=nil
	if card:IsSetCard(0x891) then remove_counters=1
	elseif card:IsSetCard(0x892) then remove_counters=2 
    elseif card:IsSetCard(0x893) then remove_counters=3 end
	return c:IsFaceup() and c:IsCode(899900000) and c:IsCanRemoveCounter(tp,0x892,remove_counters,REASON_COST)
end
function s.draw_cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local card=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.essence_counter_cost,tp,LOCATION_FZONE,0,1,nil,tp,card) end
	local remove_counters=nil
	if card:IsSetCard(0x891) then remove_counters=1
	elseif card:IsSetCard(0x892) then remove_counters=2 
    elseif card:IsSetCard(0x893) then remove_counters=3 end
	local tc=Duel.GetMatchingGroup(s.essence_counter_cost,tp,LOCATION_FZONE,0,nil,tp,card):GetFirst()
	tc:RemoveCounter(tp,0x892,remove_counters,REASON_COST)
end
function s.draw_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.draw_operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)==0 then return end
	Duel.Draw(p,d,REASON_EFFECT)
end
--(2) Scrap -> Reduce The Level Of 1 Card In Hand By 1
function s.scrap_condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_HAND and (r&REASON_DISCARD)~=0
end
function s.reduce_level_filter(c)
	return (c:IsType(TYPE_MONSTER) and c:IsLevelAbove(2)) or (c:IsType(TYPE_SPELL) and not c:IsSetCard(0x891)) 
end
function s.scrap_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.reduce_level_filter,tp,LOCATION_HAND,0,1,nil) end
end
function s.scrap_operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local g=Duel.SelectMatchingCard(tp,s.reduce_level_filter,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
        local tc=g:GetFirst()
        if tc:IsType(TYPE_MONSTER) then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_LEVEL)
            e1:SetValue(-1)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
            tc:RegisterEffect(e1)
        elseif tc:IsSetCard(0x892) then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetDescription(aux.Stringid(id,2))
            e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_ADD_SETCODE)
            e1:SetValue(0x891)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
            tc:RegisterEffect(e1)
        elseif tc:IsSetCard(0x893) then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetDescription(aux.Stringid(id,3))
            e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_ADD_SETCODE)
            e1:SetValue(0x892)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
            tc:RegisterEffect(e1)
        elseif tc:IsSetCard(0x894) then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetDescription(aux.Stringid(id,4))
            e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_ADD_SETCODE)
            e1:SetValue(0x893)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
            tc:RegisterEffect(e1)
        elseif tc:IsSetCard(0x895) then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetDescription(aux.Stringid(id,5))
            e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_ADD_SETCODE)
            e1:SetValue(0x894)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
            tc:RegisterEffect(e1)
        elseif tc:IsSetCard(0x896) then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetDescription(aux.Stringid(id,6))
            e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_ADD_SETCODE)
            e1:SetValue(0x895)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
            tc:RegisterEffect(e1)
        end
	end
end