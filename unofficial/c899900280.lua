--[AB] Fragment Reactions
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
    --(1) Exhaust 1 Card -> Forge 1 Card Same Type/Level
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(s.forge_cost)
	e1:SetTarget(s.forge_target)
	e1:SetOperation(s.forge_operation)
	c:RegisterEffect(e1)
end
--(1) Exhaust 1 Card -> Forge 1 Card Same Type/Level
function s.exhaust_filter(c,e,tp)
    local type  = c:GetType()
    local level = nil
    local card = c:GetOriginalCode()
    if type == TYPE_SPELL then
        if c:IsSetCard(0x896) then level = 0x896
        elseif c:IsSetCard(0x895) then level = 0x895
        elseif c:IsSetCard(0x894) then level = 0x894
        elseif c:IsSetCard(0x893) then level = 0x893
        elseif c:IsSetCard(0x892) then level = 0x892
        elseif c:IsSetCard(0x891) then level = 0x891 end
    else 
        level = c:GetOriginalLevel()
    end
	return c:IsType(TYPE_MONSTER+TYPE_SPELL) and c~=e:GetHandler() and Duel.IsExistingMatchingCard(s.forge_target_filter,tp,LOCATION_DECK,0,1,nil,type,level,card)
end
function s.forge_target_filter(c,type,level,card)
    if type == TYPE_SPELL then
	    return c:IsAbleToHand() and c:IsSetCard(level) and c:IsType(TYPE_SPELL) and not c:IsCode(card)
    else 
        return c:IsAbleToHand() and c:IsLevel(level) and c:IsType(TYPE_MONSTER) and not c:IsCode(card)
    end
end
function s.essence_counter_cost(c,tp,card)
	local remove_counters=nil
	if card:IsSetCard(0x891) then remove_counters=1 end
	return c:IsFaceup() and c:IsCode(899900000) and c:IsCanRemoveCounter(tp,0x892,remove_counters,REASON_COST)
end
function s.forge_cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local card=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.essence_counter_cost,tp,LOCATION_FZONE,0,1,nil,tp,card) end
	local remove_counters=nil
	if card:IsSetCard(0x891) then remove_counters=1 end
	local tc=Duel.GetMatchingGroup(s.essence_counter_cost,tp,LOCATION_FZONE,0,nil,tp,card):GetFirst()
	tc:RemoveCounter(tp,0x892,remove_counters,REASON_COST)
end
function s.forge_target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.exhaust_filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0)
end
function s.forge_operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local tc=Duel.SelectMatchingCard(tp,s.exhaust_filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,e,tp):GetFirst()
    local type  = tc:GetType()
    local level = nil
    local card = tc:GetOriginalCode()
    if type == TYPE_SPELL then
        if tc:IsSetCard(0x896) then level = 0x896
        elseif tc:IsSetCard(0x895) then level = 0x895
        elseif tc:IsSetCard(0x894) then level = 0x894
        elseif tc:IsSetCard(0x893) then level = 0x893
        elseif tc:IsSetCard(0x892) then level = 0x892
        elseif tc:IsSetCard(0x891) then level = 0x891 end
    else 
        level = tc:GetOriginalLevel()
    end
    if Duel.IsExistingMatchingCard(s.forge_target_filter,tp,LOCATION_DECK,0,1,nil,type,level,card) and Duel.SendtoDeck(tc,nil,-2,REASON_RULE)~=0 then
        local g=Duel.GetMatchingGroup(s.forge_target_filter,tp,LOCATION_DECK,0,nil,type,level,card)
        local n=Duel.GetRandomNumber(0,#g)-1
        local tc=g:GetFirst()
        for i=1,n do tc=g:GetNext() end
        local card=Duel.CreateToken(tp,tc:GetCode())
        Duel.SendtoHand(card,nil,REASON_EFFECT)
    end
end