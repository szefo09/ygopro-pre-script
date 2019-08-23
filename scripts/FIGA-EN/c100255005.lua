--Powerhold the Moving Battery

--Scripted by nekrozar
function c100255005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100255005.target)
	e1:SetOperation(c100255005.activate)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c100255005.atkcon)
	e2:SetValue(c100255005.atkval)
	c:RegisterEffect(e2)
end
function c100255005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,100255005,0,0x21,0,2000,4,RACE_MACHINE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100255005.eqfilter(c,tp)
	return c:IsRace(RACE_MACHINE) and c:IsLevel(4) and c:IsSetCard(0x51) and c:CheckUniqueOnField(tp)
end
function c100255005.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,100255005,0,0x21,0,0,4,RACE_MACHINE,ATTRIBUTE_EARTH) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	if Duel.SpecialSummon(c,1,tp,tp,true,false,POS_FACEUP)==0 then return end
	local g=Duel.GetMatchingGroup(c100255005.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(100255005,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.Equip(tp,tc,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c100255005.eqlimit)
		tc:RegisterEffect(e1,true)
		tc:RegisterFlagEffect(100255005,RESET_EVENT+RESETS_STANDARD,0,0)
	end
end
function c100255005.eqlimit(e,c)
	return e:GetOwner()==c
end

function c100255005.atkcon(e)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c100255005.atkval(e,c)
	local atk=0
	local g=c:GetEquipGroup()
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(100255005)~=0 and tc:GetAttack()>=0 then
			atk=atk+tc:GetAttack()*2
		end
		tc=g:GetNext()
	end
	return atk
end