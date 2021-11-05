--[AB] Kaname Madoka - Prayer of Salvation Level 3
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
    --(1) Conclude -> Add 1 Random Monster From GY To Hand -> Reduce Its Level By 2
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
	e1:SetCondition(s.conclude_condition)
	e1:SetTarget(s.conclude_target)
	e1:SetOperation(s.conclude_operation)
	c:RegisterEffect(e1)
end
--(1) Conclude -> Add 1 Random Monster From GY To Hand -> Reduce Its Level By 2
function s.conclude_condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.add_hand_filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.conclude_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.add_hand_filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.conclude_operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsExistingMatchingCard(s.add_hand_filter,tp,LOCATION_GRAVE,0,1,nil) then
        local g=Duel.GetMatchingGroup(s.add_hand_filter,tp,LOCATION_GRAVE,0,nil)
        local n=Duel.GetRandomNumber(0,#g)-1
        local tc=g:GetFirst()
        for i=1,n do tc=g:GetNext() end
        if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
            local monster_level = tc:GetLevel()
            local level_reduce  = 2
            if monster_level>1 then
                if monster_level>level_reduce then
                    local e1=Effect.CreateEffect(e:GetHandler())
                    e1:SetType(EFFECT_TYPE_SINGLE)
                    e1:SetCode(EFFECT_UPDATE_LEVEL)
                    e1:SetValue(-level_reduce)
                    e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
                    tc:RegisterEffect(e1)
                else
                    local e1=Effect.CreateEffect(e:GetHandler())
                    e1:SetType(EFFECT_TYPE_SINGLE)
                    e1:SetCode(EFFECT_CHANGE_LEVEL)
                    e1:SetValue(1)
                    e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
                    tc:RegisterEffect(e1)
                end
            end
        end
    end
end