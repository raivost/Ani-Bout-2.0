--[AB] Yoshino, Hermit Spirit
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
    --(1) Clash -> Change 1 Monster's ATK/DEF To 0
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(s.clash_condition)
    e1:SetTarget(s.clash_target)
	e1:SetOperation(s.clash_operation)
	c:RegisterEffect(e1)
end
function s.clash_condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()~=nil
end
function s.change_status_filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and (c:IsAttackAbove(1) or c:IsDefenseAbove(1))
end
function s.clash_target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(s.change_status_filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.change_status_filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.clash_operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
        tc:RegisterEffect(e2)
	end
end