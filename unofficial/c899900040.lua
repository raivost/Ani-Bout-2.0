--[AB] Twoearle
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
	--(1) Play -> Forge 1 Spell (From Hand)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCondition(s.play_condition)
	e1:SetTarget(s.play_target)
	e1:SetOperation(s.play_operation)
	c:RegisterEffect(e1)
end
--(1) Play -> Forge 1 Spell (From Hand)
function s.play_condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function s.forge_target_filter(c)
	return c:IsType(TYPE_SPELL)
end
function s.advanced_filter(c)
	return c:IsFaceup() and c:IsSetCard(0x88E)
end
function s.play_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.forge_target_filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0)
end
function s.play_operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local tc=Duel.SelectMatchingCard(tp,s.forge_target_filter,tp,LOCATION_HAND,0,1,1,nil)
	if #tc>0 then
		local forge_group=Group.CreateGroup()
        local card1=Duel.CreateToken(tp,tc:GetFirst():GetCode())
		forge_group:AddCard(card1)
		--If Advanced Monster On Field -> Force 2 Instead
        if Duel.IsExistingMatchingCard(s.advanced_filter,tp,LOCATION_MZONE,0,1,nil) then
            local card2=Duel.CreateToken(tp,tc:GetFirst():GetCode())
			forge_group:AddCard(card2)
        end
        Duel.SendtoHand(forge_group,nil,REASON_EFFECT)
		forge_group:DeleteGroup()
	end
end