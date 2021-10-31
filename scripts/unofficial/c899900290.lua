--[CEDO] The Lucky Draw
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
    --(1) Draw 1 Card -> If Level > Hero's Rank -> Reduce Level By 1
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(s.draw_cost)
	e1:SetTarget(s.draw_target)
	e1:SetOperation(s.draw_operation)
	c:RegisterEffect(e1)
end
function s.essence_counter_cost(c,tp,card)
	local remove_counters=nil
	if card:IsSetCard(0x891) then remove_counters=1 end
	return c:IsFaceup() and c:IsCode(899900000) and c:IsCanRemoveCounter(tp,0x892,remove_counters,REASON_COST)
end
function s.draw_cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local card=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.essence_counter_cost,tp,LOCATION_FZONE,0,1,nil,tp,card) end
	local remove_counters=nil
	if card:IsSetCard(0x891) then remove_counters=1 end
	local tc=Duel.GetMatchingGroup(s.essence_counter_cost,tp,LOCATION_FZONE,0,nil,tp,card):GetFirst()
	tc:RemoveCounter(tp,0x892,remove_counters,REASON_COST)
end
function s.hero_filter(c)
	return c:GetSequence()>=5
end
function s.draw_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.draw_operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    local tc=g:GetFirst()
    if tc:IsLevel(1) or tc:IsSetCard(0x891) then return end
    local tc1=Duel.GetMatchingGroup(s.hero_filter,tp,LOCATION_MZONE,0,nil):GetFirst()
    if not tc1 then return end
    local hero_rank   = tc1:GetRank()
    local spell_level = nil
    if tc:GetType() == TYPE_SPELL then
        if tc:IsSetCard(0x896) then spell_level = 6
        elseif tc:IsSetCard(0x895) then spell_level = 5
        elseif tc:IsSetCard(0x894) then spell_level = 4
        elseif tc:IsSetCard(0x893) then spell_level = 3
        elseif tc:IsSetCard(0x892) then spell_level = 2 end
        if spell_level > hero_rank then
            if tc:IsSetCard(0x892) then
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetDescription(aux.Stringid(id,1))
                e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_ADD_SETCODE)
                e1:SetValue(0x891)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
                tc:RegisterEffect(e1)
            elseif tc:IsSetCard(0x893) then
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetDescription(aux.Stringid(id,2))
                e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_ADD_SETCODE)
                e1:SetValue(0x892)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
                tc:RegisterEffect(e1)
            elseif tc:IsSetCard(0x894) then
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetDescription(aux.Stringid(id,3))
                e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_ADD_SETCODE)
                e1:SetValue(0x893)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
                tc:RegisterEffect(e1)
            elseif tc:IsSetCard(0x895) then
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetDescription(aux.Stringid(id,4))
                e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_ADD_SETCODE)
                e1:SetValue(0x894)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
                tc:RegisterEffect(e1)
            elseif tc:IsSetCard(0x896) then
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetDescription(aux.Stringid(id,5))
                e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_ADD_SETCODE)
                e1:SetValue(0x895)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
                tc:RegisterEffect(e1)
            end
        end
    else
        if tc:GetLevel() > hero_rank then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_LEVEL)
            e1:SetValue(-1)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
            tc:RegisterEffect(e1)
        end
    end 
end