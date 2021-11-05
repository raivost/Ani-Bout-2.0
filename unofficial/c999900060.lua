--[FTV] Mindclaw Shaman
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
    --(1) Conquer -> Inflict 1 Damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.conquer_condition)
	e1:SetTarget(s.conquer_target)
	e1:SetOperation(s.conquer_operation)
	c:RegisterEffect(e1)
end
--(1) Conquer -> Inflict 1 Damage
function s.conquer_condition_filter(c,tp)
	return c:IsReason(REASON_BATTLE) and c:IsPreviousControler(1-tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function s.conquer_condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.conquer_condition_filter,1,nil,tp)
end
function s.conquer_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1)
end
function s.conquer_operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
