--[AB] Shana - Shinku Level 3
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
    --(1) Warcry -> Inflict Damage = Nr. Of Monsters Summoned
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
	e1:SetCondition(s.warcry_condition)
	e1:SetTarget(s.warcry_target)
	e1:SetOperation(s.warcry_operation)
	c:RegisterEffect(e1)
    --Each Time A Monster Is Summoned
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
--(1) Warcry -> Inflict Damage = Nr. Of Monsters Summoned
function s.warcry_condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.warcry_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(s[tp])
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,s[tp])
end
function s.warcry_operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
--Each Time A Monster Is Summoned
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    while tc do
        if tc:IsType(TYPE_MONSTER) and not tc:IsType(TYPE_XYZ) then
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