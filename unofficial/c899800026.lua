--[AB] Kaname Madoka - Lamination of Cause & Effect Level 6
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
    --(1) Resolution (opponent) -> Enemy Monsters Lose 3 ATK/DEF -> Mill 2 Cards For Each
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.resolution_condition)
	e1:SetTarget(s.resolution_target)
	e1:SetOperation(s.resolution_operation)
	c:RegisterEffect(e1)
end
--(1) Resolution (opponent) -> Enemy Monsters Lose 3 ATK/DEF -> Mill 2 Cards For Each
function s.resolution_condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function s.reduce_status_filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and (c:IsAttackAbove(1) or c:IsDefenseAbove(1))
end
function s.resolution_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2)
        and Duel.IsExistingMatchingCard(s.reduce_status_filter,tp,0,LOCATION_MZONE,1,nil) end
end
function s.resolution_operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.reduce_status_filter,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
        local tc=g:GetFirst()
        for tc in aux.Next(g) do
            if tc and tc:IsFaceup() then
                local reduce_value=3
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
        Duel.DiscardDeck(tp,#g*2,REASON_EFFECT)
    end
end