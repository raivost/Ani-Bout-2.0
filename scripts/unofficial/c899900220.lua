--[CEDO] Meteora Osterreich
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
    --(1) Play -> Forge 1 Random Spell/3 (From Deck). Repeat For Each Enemy Monster
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
--(1) Play -> Forge 1 Random Spell/3 (From Deck) For Each Enemy Monster
function s.play_condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function s.forge_target_filter(c)
	return c:IsType(TYPE_SPELL)
end
function s.daunt_condition_filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function s.play_target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local ct=Duel.GetMatchingGroupCount(s.daunt_condition_filter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(s.forge_target_filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,ct+1,tp,0)
end
function s.play_operation(e,tp,eg,ep,ev,re,r,rp)
    local repeat_count=Duel.GetMatchingGroupCount(s.daunt_condition_filter,tp,0,LOCATION_MZONE,nil)
    local g=Duel.GetMatchingGroup(s.forge_target_filter,tp,LOCATION_DECK,0,nil)
    local numbers=g:GetClassCount(Card.GetCode)
    if numbers>3 then numbers=3 end
    local add_group   = Group.CreateGroup() -- Group Of Cards To Add
    local tc          = nil  -- Current Card From Group
    local n           = nil  -- Random Number
    local code        = nil  -- Code Of Current Card From Group
    local cond_while  = true -- Condition To Stop While
    local cond_code   = true -- Condition That Current Code Is Different From Existing Ones
    while repeat_count+1>0 and Duel.IsExistingMatchingCard(s.forge_target_filter,tp,LOCATION_DECK,0,1,nil) do
        local teste_codes = {}   -- Table Containing The Code Of Generate Cards
        local cards_group = Group.CreateGroup() -- Group Of Cards To Choose From
		for i=1,numbers do
			if #teste_codes>0 then
				cond_while=true
				while cond_while do
					cond_code=true
					n=Duel.GetRandomNumber(0,#g)-1
					tc=g:GetFirst()
					for i=1,n do tc=g:GetNext() end
					code=tc:GetCode()
					for _,value in ipairs(teste_codes) do
						--IF Code Already Exist cond_code = False
						if code == value then
							cond_code = false
						end
					end
					--If cond_code = True -> Add Value + Exit While Loop
					if cond_code then
                        table.insert(teste_codes, code)
						cond_while=false
					end
				end
			else
				n=Duel.GetRandomNumber(0,#g)-1
				tc=g:GetFirst()
				for i=1,n do tc=g:GetNext() end
				code=tc:GetCode()
				table.insert(teste_codes, code)
			end
		end
		local card=nil -- Spell To Add
		for _,value in ipairs(teste_codes) do
			card=Duel.CreateToken(tp,value)
			cards_group:AddCard(card)
		end
        --If Only 1 Target
		if numbers == 1 then
			add_group:AddCard(card)
            cards_group:DeleteGroup()
		else
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
			tc=cards_group:FilterSelect(tp,s.forge_target_filter,1,1,nil):GetFirst()
            add_group:AddCard(tc)
            cards_group:DeleteGroup()
		end
        repeat_count=repeat_count-1
    end
    Duel.SendtoHand(add_group,nil,REASON_EFFECT)
    add_group:DeleteGroup()
end