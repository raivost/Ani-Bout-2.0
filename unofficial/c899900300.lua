--[CEDO] Neptune
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
     --(1) Clash -> Draw 1 Card
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(s.clash_condition)
    e1:SetTarget(s.clash_target)
	e1:SetOperation(s.clash_operation)
	c:RegisterEffect(e1)
    --(2) Kickoff -> Advance Forge -> Purple Heart
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(s.kickoff_condition)
    e2:SetCost(s.kickoff_cost)
	e2:SetOperation(s.kickoff_operation)
	c:RegisterEffect(e2)
    --Kickoff Effect
    if not s.global_check then
        s.global_check=true
        s[0]=0
        s[1]=0
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
        ge1:SetOperation(s.checkop)
        Duel.RegisterEffect(ge1,0)
        local ge2=Effect.CreateEffect(c)
        ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
        ge2:SetOperation(s.clearop)
        Duel.RegisterEffect(ge2,0)
    end
end

s.advanced_code  = 899900310

--(1) Clash -> Draw 1 Card
function s.clash_condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()~=nil
end
function s.clash_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.clash_operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--(2) Kickoff -> Advance Forge -> Purple Heart
function s.essence_counter_cost(c,tp,level)
	return c:IsFaceup() and c:IsCode(899900000) and c:IsCanRemoveCounter(tp,0x892,level,REASON_COST)
end
function s.kickoff_cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local level=e:GetHandler():GetLevel()
	if chk==0 then return Duel.IsExistingMatchingCard(s.essence_counter_cost,tp,LOCATION_FZONE,0,1,nil,tp,level) end
	local tc=Duel.GetMatchingGroup(s.essence_counter_cost,tp,LOCATION_FZONE,0,nil,tp,level):GetFirst()
	tc:RemoveCounter(tp,0x892,level,REASON_COST)
end
function s.kickoff_condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND) and s[tp]==0
end
function s.kickoff_operation(e,tp,eg,ep,ev,re,r,rp)
    if Duel.SendtoDeck(e:GetHandler(),nil,-2,REASON_RULE)~=0 then
        local card=Duel.CreateToken(tp,s.advanced_code)
		Duel.SendtoHand(card,nil,REASON_EFFECT)
    end
end
--Kickoff Effect
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    while tc do
      if tc:IsType(TYPE_MONSTER) and not tc:IsType(TYPE_XYZ) and tc:IsPreviousLocation(LOCATION_HAND) then
        local p=tc:GetSummonPlayer()
        s[p]=s[p]+1
      end
      tc=eg:GetNext()
    end
  end
  function s.clearop(e,tp,eg,ep,ev,re,r,rp)
    s[0]=0
    s[1]=0
  end