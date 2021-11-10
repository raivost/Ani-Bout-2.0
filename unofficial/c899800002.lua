--[AB] Yatogami Tohka - Sandalphon Level 3
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
    --(1) Innate -> Forge Sandalphon Level 2
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
	e1:SetCondition(s.innate_condition)
	e1:SetOperation(s.innate_operation)
	c:RegisterEffect(e1)
end
--(1) Innate -> Forge Sandalphon Level 2
function s.innate_condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.innate_operation(e,tp,eg,ep,ev,re,r,rp)
    local card=Duel.CreateToken(tp,899700001)
    Duel.SendtoHand(card,nil,REASON_EFFECT)
end