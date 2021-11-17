--[AB] Nazarick Guardian, Aura
--Scripted by Raivost (Ravi)
local s,id=GetID()
function s.initial_effect(c)
    --(1) Play -> Inflict 2 Damage - If 4 Essences -> Inflict 4 Damage instead
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(s.play_condition)
    e1:SetCost(s.play_cost)
	e1:SetTarget(s.play_target)
	e1:SetOperation(s.play_operation)
	c:RegisterEffect(e1)
end
--(1) Play -> Inflict 2 Damage - If 4 Essences -> Inflict 4 Damage instead
function s.play_condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function s.essence_counter_cost(c,tp)
	return c:IsFaceup() and c:IsCode(899900000) and c:IsCanRemoveCounter(tp,0x892,6,REASON_COST)
end
function s.play_cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.essence_counter_cost,tp,LOCATION_FZONE,0,1,nil,tp) end
	local tc=Duel.GetMatchingGroup(s.essence_counter_cost,tp,LOCATION_FZONE,0,nil,tp):GetFirst()
	tc:RemoveCounter(tp,0x892,6,REASON_COST)
end
function s.summon_filter(c,e,tp)
	return c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
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
			if Duel.SpecialSummonStep(card,0,tp,tp,false,false,POS_FACEUP)~=0 then
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                e1:SetValue(2)
                card:RegisterEffect(e1)
                local e2=e1:Clone()
                e2:SetCode(EFFECT_UPDATE_DEFENSE)
                card:RegisterEffect(e2)
            end
            Duel.SpecialSummonComplete()
			cards_group:DeleteGroup()
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			tc=cards_group:FilterSelect(tp,s.summon_filter,1,1,nil,e,tp):GetFirst()
			if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                e1:SetValue(2)
                tc:RegisterEffect(e1)
                local e2=e1:Clone()
                e2:SetCode(EFFECT_UPDATE_DEFENSE)
                tc:RegisterEffect(e2)
            end
            Duel.SpecialSummonComplete()
			cards_group:DeleteGroup()
		end
	end
end