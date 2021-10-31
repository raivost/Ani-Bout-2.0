--[CEDO] MAGES.
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
    --(1) Play -> Summon 1 Random/3 Level 2 Or Lower (From Deck)
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
    --(2) Chant -> Inflict 1 Damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(aux.chainreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.chant_condition)
	e3:SetOperation(s.chant_operation)
	c:RegisterEffect(e3)
end
--(1) Play -> Summon 1 Random/3 Level 2 Or Lower (From Deck)
function s.play_condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function s.summon_filter(c,e,tp)
	return c:IsLevelBelow(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.play_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
        and Duel.IsExistingMatchingCard(s.summon_filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.play_operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.summon_filter,tp,LOCATION_DECK,0,1,nil,e,tp) then
        local g=Duel.GetMatchingGroup(s.summon_filter,tp,LOCATION_DECK,0,nil,e,tp)
		local numbers=g:GetClassCount(Card.GetCode)
		if numbers>3 then numbers=3 end
		local tc          = nil  -- Current Card From Group
		local n           = nil  -- Random Number
		local code        = nil  -- Code Of Current Card From Group
		local cond_while  = true -- Condition To Stop While
		local cond_code   = true -- Condition That Current Code Is Different From Existing Ones
		local teste_codes = {}   -- Table Containing The Code Of Generate Cards
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
		local cards_group=Group.CreateGroup() -- Group Of Cards To Choose From
		local card=nil -- Card To Summon
		for _,value in ipairs(teste_codes) do
			card=Duel.CreateToken(tp,value)
			cards_group:AddCard(card)
		end
		--If Only 1 Target
		if numbers == 1 then
			Duel.SpecialSummon(card,0,tp,tp,false,false,POS_FACEUP)
			cards_group:DeleteGroup()
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			tc=cards_group:FilterSelect(tp,s.summon_filter,1,1,nil,e,tp):GetFirst()
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			cards_group:DeleteGroup()
		end
	end
end
--(2) Chant -> Inflict 1 Damage
function s.chant_condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and rp==tp and e:GetHandler():GetFlagEffect(1)>0
end
function s.chant_operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,id)
	Duel.Damage(1-tp,1,REASON_EFFECT)
end