--[CEDO] Gust
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
    --(1) Play -> Forge 1 Random Spell (From Deck) With Level = Hero's Rank
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
 --(1) Play -> Forge 1 Random Spell (From Deck) With Level = Hero's Rank
function s.play_condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function s.forge_target_filter(c,hero_rank)
    local spell_level=nil
    if hero_rank==1 then spell_level = 0x891
    elseif  hero_rank==2 then spell_level = 0x892
    elseif  hero_rank==3 then spell_level = 0x893
    elseif  hero_rank==4 then spell_level = 0x894
    elseif  hero_rank==5 then spell_level = 0x895
    elseif  hero_rank==6 then spell_level = 0x896 end  
	return c:IsType(TYPE_SPELL) and c:IsSetCard(spell_level)
end
function s.hero_filter(c)
	return c:GetSequence()>=5
end
function s.play_target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local tc=Duel.GetMatchingGroup(s.hero_filter,tp,LOCATION_MZONE,0,nil):GetFirst()
    if not tc then return end
    local hero_rank=tc:GetRank()
	if chk==0 then return Duel.IsExistingMatchingCard(s.forge_target_filter,tp,LOCATION_DECK,0,1,nil,hero_rank) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0)
end
function s.play_operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetMatchingGroup(s.hero_filter,tp,LOCATION_MZONE,0,nil):GetFirst()
    if not tc then return end
    local hero_rank=tc:GetRank()
    if Duel.IsExistingMatchingCard(s.forge_target_filter,tp,LOCATION_DECK,0,1,nil,hero_rank) then
        local g=Duel.GetMatchingGroup(s.forge_target_filter,tp,LOCATION_DECK,0,nil,hero_rank)
        local n=Duel.GetRandomNumber(0,#g)-1
        local tc=g:GetFirst()
        for i=1,n do tc=g:GetNext() end
        local card=Duel.CreateToken(tp,tc:GetCode())
        Duel.SendtoHand(card,nil,REASON_EFFECT)
    end
end