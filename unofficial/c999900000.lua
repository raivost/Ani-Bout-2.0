--[FTV] Factivis Duel 
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
    --Avatar Level
    c:EnableCounterPermit(0x890)
    --Essence Counter
    c:EnableCounterPermit(0x892)
    --(0) Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    --(1) Auto-Activate From Hand Or Deck
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_PREDRAW)
    e1:SetRange(LOCATION_HAND+LOCATION_DECK)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
    e1:SetCondition(s.auto_activate_condition)
    e1:SetOperation(s.auto_activate_operation)
    c:RegisterEffect(e1)
    --(2) Field Protection
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetRange(LOCATION_FZONE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e3)
    local e4=e2:Clone()
    e4:SetCode(EFFECT_CANNOT_REMOVE)
    c:RegisterEffect(e4)
    --(3) Draw 2 Cards For Draw Phase
    local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_DRAW_COUNT)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(1,0)
	e5:SetValue(2)
    e5:SetCondition(s.draw_condition)
	c:RegisterEffect(e5)
    --(4) Avatar Level = Level Counters
    local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CHANGE_LEVEL)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(s.avatar_level_value)
	c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e7:SetRange(LOCATION_FZONE)
    e7:SetTargetRange(LOCATION_MZONE,0)
    e7:SetTarget(s.avatar_target)
    e7:SetLabelObject(e6)
    c:RegisterEffect(e7)
    --(5) Avatar Gain ATK
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_UPDATE_ATTACK)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetValue(s.avatar_status_value)
	c:RegisterEffect(e8)
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e9:SetRange(LOCATION_FZONE)
    e9:SetTargetRange(LOCATION_MZONE,0)
    e9:SetTarget(s.avatar_target)
    e9:SetLabelObject(e8)
    c:RegisterEffect(e9)
    --(6) Avatar Gain DEF
    local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_UPDATE_DEFENSE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetValue(s.avatar_status_value)
	c:RegisterEffect(e10)
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e11:SetRange(LOCATION_FZONE)
    e11:SetTargetRange(LOCATION_MZONE,0)
    e11:SetTarget(s.avatar_target)
    e11:SetLabelObject(e10)
    c:RegisterEffect(e11)
    --(7) Leave Field -> Suffle In Deck
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_SINGLE)
    e12:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
    e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e12:SetReset(RESET_EVENT+RESETS_REDIRECT)
    e12:SetValue(LOCATION_DECKSHF)
    c:RegisterEffect(e12)
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e13:SetRange(LOCATION_FZONE)
    e13:SetTargetRange(LOCATION_MZONE,0)
    e13:SetTarget(s.avatar_target)
    e13:SetLabelObject(e12)
    c:RegisterEffect(e13)
    --(4) Increase Avatar Level + Reset Essence Counters
    local e14=Effect.CreateEffect(c)
    e14:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e14:SetTargetRange(1,0)
    e14:SetCode(EVENT_PREDRAW)
    e14:SetRange(LOCATION_FZONE)
    e14:SetCountLimit(1)
    e14:SetCondition(s.add_counter_condition)
    e14:SetOperation(s.add_counter_operation)
    c:RegisterEffect(e14)
    --(5) Level Limit
    local e15=Effect.CreateEffect(c)
    e15:SetType(EFFECT_TYPE_FIELD)
    e15:SetRange(LOCATION_FZONE)
    e15:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e15:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e15:SetTargetRange(1,0)
    e15:SetTarget(s.level_limit_target)
    c:RegisterEffect(e15)
    --(6) Cannot Normal Summon/Set Monsters
    local e16=Effect.CreateEffect(c)
    e16:SetType(EFFECT_TYPE_FIELD)
    e16:SetRange(LOCATION_FZONE)
    e16:SetCode(EFFECT_CANNOT_SUMMON)
    e16:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e16:SetTargetRange(1,0)
    c:RegisterEffect(e16)
    local e17=e16:Clone()
    e17:SetCode(EFFECT_CANNOT_MSET)
    c:RegisterEffect(e17)
    --(7) Special Summon From Hand
    local e18=Effect.CreateEffect(c)
    e18:SetType(EFFECT_TYPE_FIELD)
    e18:SetCode(EFFECT_SPSUMMON_PROC)
    e18:SetProperty(EFFECT_FLAG_SPSUM_PARAM)
    e18:SetTargetRange(POS_FACEUP,0)
    e18:SetRange(LOCATION_HAND)
    e18:SetCondition(s.special_summon_condition)
    c:RegisterEffect(e18)
    local e19=Effect.CreateEffect(c)
    e19:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e19:SetRange(LOCATION_FZONE)
    e19:SetTargetRange(LOCATION_HAND,0)
    e19:SetTarget(s.special_summon_target)
    e19:SetLabelObject(e18)
    c:RegisterEffect(e19)
    --(8) Disarmed Cannot Attack
    local e20=Effect.CreateEffect(c)
    e20:SetType(EFFECT_TYPE_FIELD)
    e20:SetCode(EFFECT_CANNOT_ATTACK)
    e20:SetRange(LOCATION_FZONE)
    e20:SetTargetRange(LOCATION_MZONE,0)
    e20:SetTarget(s.disarm_target)
    c:RegisterEffect(e20)
    --(9) Anguish Reflect Damage To Controller
    local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(id,0))
	e21:SetCategory(CATEGORY_DESTROY)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e21:SetCode(EVENT_DAMAGE_STEP_END)
	e21:SetTarget(s.anguish_effect_target)
	e21:SetOperation(s.anguish_effect_operation)
	c:RegisterEffect(e21)
    local e22=Effect.CreateEffect(c)
    e22:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e22:SetRange(LOCATION_FZONE)
    e22:SetTargetRange(LOCATION_MZONE,0)
    e22:SetTarget(s.anguish_target)
    e22:SetLabelObject(e21)
    c:RegisterEffect(e22)
    --(10) Cannot Set Spells
    local e23=Effect.CreateEffect(c)
    e23:SetType(EFFECT_TYPE_FIELD)
    e23:SetCode(EFFECT_CANNOT_SSET)
    e23:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e23:SetRange(LOCATION_FZONE)
    e23:SetTargetRange(1,0)
    e23:SetTarget(aux.TRUE)
    c:RegisterEffect(e23)
    --(11) Activate Spell
    local e24=Effect.CreateEffect(c)
    e24:SetType(EFFECT_TYPE_FIELD)
    e24:SetCode(EFFECT_CANNOT_ACTIVATE)
    e24:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e24:SetRange(LOCATION_FZONE)
    e24:SetTargetRange(1,0)
    e24:SetValue(s.activate_spell_value)
    c:RegisterEffect(e24)
    --(12) Haste Spells
    local e25=Effect.CreateEffect(c)
    e25:SetType(EFFECT_TYPE_FIELD)
    e25:SetCode(EFFECT_ADD_TYPE)
    e25:SetRange(LOCATION_FZONE)
    e25:SetTargetRange(LOCATION_HAND,0)
    e25:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x897))
    e25:SetValue(TYPE_QUICKPLAY)
    c:RegisterEffect(e25)
    local e26=e25:Clone()
    e26:SetCode(EFFECT_BECOME_QUICK)
    c:RegisterEffect(e26)
    --(13) Activate Haste Spells During Both Turns
    local e27=Effect.CreateEffect(c)
    e27:SetType(EFFECT_TYPE_FIELD)
    e27:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    e27:SetRange(LOCATION_FZONE)
    e27:SetTarget(s.haste_target)
    e27:SetTargetRange(LOCATION_HAND,0)
    c:RegisterEffect(e27)
end

s.avatars = {999800010, 999800020}

 --(1) Auto-Activate From Hand Or Deck
function s.auto_activate_condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnCount()==1 and Duel.GetFieldCard(tp,LOCATION_SZONE,5)==nil
end
function s.avatar_add_filter(c)
	return c:IsSetCard(0x890) and c:IsAbleToHand()
end
function s.mullifan_filter(c)
	return c:IsAbleToDeck() and not c:IsSetCard(0x890)
end
function s.auto_activate_operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c and Duel.GetFieldCard(tp,LOCATION_SZONE,5)==nil and aux.PlayFieldSpell(c,e,tp,eg,ep,ev,re,r,rp) then
    --If Activated From Hand -> Draw 1 Card
        if c:IsPreviousLocation(LOCATION_HAND) then
            Duel.Draw(tp,1,REASON_EFFECT)
        end
    end
    --Generate And Avatar To Hand
    local avatars_group=Group.CreateGroup()
    local avatar=nil
    for i=1,#s.avatars do
        avatar=Duel.CreateToken(tp,s.avatars[i])
        avatars_group:AddCard(avatar)
    end
    --Select Avatar
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
    local tc1=avatars_group:FilterSelect(tp,s.avatar_add_filter,1,1,nil):GetFirst()
    Duel.SendtoHand(tc1,nil,REASON_RULE)
    avatars_group:DeleteGroup()
    Duel.ShuffleHand(tp)
    --Set LP
    Duel.SetLP(tp,30)
    --Starting Counter Limit
    local counter_limit=1
    --Add Avatar Level Counter
    c:AddCounter(0x890,counter_limit)
    --Add Essence Counter
    c:AddCounter(0x892,counter_limit*2)
    --Mulligan
    if Duel.IsPlayerCanDraw(tp) and Duel.IsExistingMatchingCard(s.mullifan_filter,tp,LOCATION_HAND,0,1,nil) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local g=Duel.SelectMatchingCard(tp,s.mullifan_filter,tp,LOCATION_HAND,0,0,63,nil)
        if g:GetCount()>0 then
            Duel.SendtoDeck(g,nil,2,REASON_RULE)
            Duel.ShuffleDeck(tp)
            Duel.Draw(tp,#g,REASON_EFFECT)
        end
    end
end
--(3) Draw 2 Cards For Draw Phase
function s.draw_condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnCount()>2
end
--(4) Avatar Level = Level Counters
function s.avatar_target(e,c)
    return c:IsSetCard(0x890) and c:IsFaceup()
end
function s.avatar_level_filter(c)
	return c:IsFaceup() and c:IsCode(999900000)
end
function s.avatar_level_value(e,c)
    local tc=Duel.GetMatchingGroup(s.avatar_level_filter,e:GetHandler():GetControler(),LOCATION_FZONE,0,nil):GetFirst()
	return tc:GetCounter(0x890)
end
--(5) Avatar Gain ATK
function s.avatar_status_value(e,c)
	return c:GetLevel()-1
end
--(4) Increase Level + Reset Essence Counters
function s.add_counter_condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnCount()>2 and Duel.GetTurnPlayer()==tp
  end
function s.add_counter_operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c or not c:IsFaceup() then return end
    --Rank Up Hero And Add Influence Counters
    local level_counter = c:GetCounter(0x890)
    if level_counter<6 then
        c:AddCounter(0x890,1)
        level_counter=c:GetCounter(0x890)
    end
    --Reset Essence
    local essence_counters = c:GetCounter(0x892)
    if essence_counters < level_counter*2 then
        add_counters=level_counter*2 - essence_counters
        c:AddCounter(0x892,add_counters)
    end
end
--(5) Level Limit
function s.level_limit_target(e,c,tp,sumtp,sumpos)
    local level_counter = e:GetHandler():GetCounter(0x890)
    return c:GetLevel()>level_counter
end
--(7) Special Summon From Hand
function s.special_summon_condition(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.special_summon_target(e,c)
    return c:IsType(TYPE_MONSTER)
end
--(8) Disarmed Cannot Attack
function s.disarm_target(e,c)
    return c:IsSetCard(0x886)
end
--(9) Anguish Reflect Damage To Controller
function s.anguish_effect_target(e,tp,eg,ep,ev,re,r,rp,chk)
	local damage=Duel.GetBattleDamage(1-tp)
	if chk==0 then return damage>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(damage)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,damage)
end
function s.anguish_effect_operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_BATTLE)
end
function s.anguish_target(e,c)
    return c:IsSetCard(0x884)
end
--(11) Activate Spell
function s.activate_spell_value(e,te,tp)
    local level_counter = e:GetHandler():GetCounter(0x890)
    --Level 1 Spells
    if level_counter==1 then
        return te:IsHasType(EFFECT_TYPE_ACTIVATE) and not te:GetHandler():IsSetCard(0x891)
    --Level 1+2 Spells
    elseif level_counter==2 then
        return te:IsHasType(EFFECT_TYPE_ACTIVATE) and not (te:GetHandler():IsSetCard(0x891) or te:GetHandler():IsSetCard(0x892))
    --Level 1+2+3 Spells
    elseif level_counter==3 then
        return te:IsHasType(EFFECT_TYPE_ACTIVATE) 
          and not (te:GetHandler():IsSetCard(0x891) or te:GetHandler():IsSetCard(0x892) or te:GetHandler():IsSetCard(0x893))
    --Level 1+2+3+4 Spells
    elseif level_counter==4 then
        return te:IsHasType(EFFECT_TYPE_ACTIVATE) 
          and not (te:GetHandler():IsSetCard(0x891) or te:GetHandler():IsSetCard(0x892) or te:GetHandler():IsSetCard(0x893) 
          or te:GetHandler():IsSetCard(0x894))
    --Level 1+2+3+4+5 Spells
    elseif level_counter==5 then
        return te:IsHasType(EFFECT_TYPE_ACTIVATE) 
          and not (te:GetHandler():IsSetCard(0x891) or te:GetHandler():IsSetCard(0x892) or te:GetHandler():IsSetCard(0x893) 
          or te:GetHandler():IsSetCard(0x894) or te:GetHandler():IsSetCard(0x895))
    --Level 1+2+3+4+5+6 Spells
    elseif level_counter==6 then
        return te:IsHasType(EFFECT_TYPE_ACTIVATE) 
          and not (te:GetHandler():IsSetCard(0x891) or te:GetHandler():IsSetCard(0x892) or te:GetHandler():IsSetCard(0x893) 
          or te:GetHandler():IsSetCard(0x894) or te:GetHandler():IsSetCard(0x895) or te:GetHandler():IsSetCard(0x896)) 
    end
end
--(13) Activate Haste Spells During Both Turns
function s.haste_target(e,c)
    return c:IsType(TYPE_QUICKPLAY)
end