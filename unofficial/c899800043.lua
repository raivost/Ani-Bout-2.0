--[AB] Kirito - Beater Level 6
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
    --(1) Reduce Level In Hand By 1 - For 3 Monster
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND,0)
    e1:SetCondition(s.reduce_level_condition)
	e1:SetTarget(s.reduce_level_target)
	e1:SetValue(-1)
	c:RegisterEffect(e1)
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
--(1) Reduce Level In Hand By 1 - For 3 Monster
function s.reduce_level_condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==e:GetHandler():GetControler() and s[e:GetHandler():GetControler()]<3
end
function s.reduce_level_target(e,c)
    return c:IsLevelAbove(2)
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