--[AB] Yatogami Tohka - Spacequakes Level 3
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
    --(1) Conjure -> Destroy 1 Enemy Monster
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1)
	e1:SetCondition(s.conjure_condition)
	e1:SetTarget(s.conjure_target)
	e1:SetOperation(s.conjure_operation)
	c:RegisterEffect(e1)
    --Conjure Global
    if not s.global_check then
      s.global_check=true
      s[0]=0
      s[1]=0
      local ge1=Effect.CreateEffect(c)
      ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
      ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
      ge1:SetOperation(s.checkop)
      Duel.RegisterEffect(ge1,0)
      local ge4=Effect.CreateEffect(c)
      ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
      ge4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
      ge4:SetOperation(s.clearop)
      Duel.RegisterEffect(ge4,0)
    end
  end
--(1) Conjure -> Destroy 1 Enemy Monster
function s.conjure_condition_filter(c,e,tp)
    local hero_rank=e:GetHandler():GetRank()
	return c:IsSummonPlayer(tp) and c:IsLevel(hero_rank) and s[tp]==1
end
function s.conjure_condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.conjure_condition_filter,1,nil,e,tp)
end
function s.destroy_filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function s.conjure_target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(s.destroy_filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.destroy_filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.conjure_operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
--Conjure Global
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    local hero_rank=e:GetHandler():GetRank()
    while tc do
    if tc:IsType(TYPE_MONSTER) and tc:IsLevel(hero_rank) then
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