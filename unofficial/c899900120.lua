--[CEDO] Magical Girl Sayaka
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
    --(1) Clash -> Increase Status - ATK
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(s.clash_condition)
	e1:SetOperation(s.clash_operation)
	c:RegisterEffect(e1)
    --(2) Execute -> Chain Attack -> Gains Anguish
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(s.execute_condition)
	e2:SetTarget(s.execute_target)
	e2:SetOperation(s.execute_operation)
	c:RegisterEffect(e2)
end
--(1) Clash -> Increase Status - ATK
function s.clash_condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()~=nil and Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)>1
end
function s.clash_operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)>1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(math.floor(Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)/2))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		c:RegisterEffect(e1)
	end
end
--(2) Execute -> Chain Attack -> Gains Anguish
function s.execute_condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and e:GetHandler():IsRelateToBattle() and Duel.GetTurnPlayer()==tp
end
function s.exhaust_filter(c)
	return c:IsType(TYPE_MONSTER+TYPE_SPELL)
end
function s.execute_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.exhaust_filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
	local g=Duel.SelectTarget(tp,s.exhaust_filter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function s.execute_operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if Duel.SendtoDeck(tc,nil,-2,REASON_RULE)~=0 then
		--Gains Anguish
		if c:GetFlagEffect(id)==0 then
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(id,3))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_SETCODE)
			e1:SetValue(0x884)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
		Duel.ChainAttack()
	end
end