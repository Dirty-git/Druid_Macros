function FBExecute()
    -- Check shapeshift form
    local currentForm = nil
    for i = 1, GetNumShapeshiftForms() do
        local _, _, active = GetShapeshiftFormInfo(i)
        if active then
            currentForm = i
            break
        end
    end

    if currentForm ~= 3 then
        return
    end

    if not UnitExists("target") or UnitIsDead("target") then
        return
    end

    if not UnitAffectingCombat("target") then
        return
    end

    local combo, energy = GetComboPoints(), UnitMana("player")

    if combo == 0 then
        return
    end

    -- Check for Clearcasting buff (makes next spell free)
    local hasClearcasting = false
    local i = 1
    while UnitBuff("player", i) do
        local buffTexture = UnitBuff("player", i)
        if buffTexture and string.find(buffTexture, "Spell_Shadow_ManaBurn") then
            hasClearcasting = true
            break
        end
        i = i + 1
    end

    if not hasClearcasting and energy < 35 then
        return
    end

    -- Determine Ferocious Bite rank by player level (no rank in spell name)
    local level = UnitLevel("player")
    local rank = 1
    if level >= 60 then
        rank = 6
    elseif level >= 56 then
        rank = 5
    elseif level >= 48 then
        rank = 4
    elseif level >= 40 then
        rank = 3
    elseif level >= 32 then
        rank = 2
    elseif level >= 24 then
        rank = 1
    else
        return
    end

    -- Damage lookup table (max damage values by rank and combo points)
    local dmg = {
        [1] = { 51, 82, 113, 144, 175 },
        [2] = { 66, 102, 138, 174, 210 },
        [3] = { 103, 162, 221, 280, 339 },
        [4] = { 162, 254, 346, 438, 530 },
        [5] = { 223, 351, 479, 607, 735 },
        [6] = { 259, 406, 553, 700, 847 }
    }

    local baseDmg = dmg[rank][combo]
    if not baseDmg then
        return
    end

    -- Calculate extra energy for damage bonus
    -- With Clearcasting: can use up to 100 energy for bonus (no base cost)
    -- Without Clearcasting: can use up to 65 extra energy (100 total - 35 base cost)
    local extraEnergy
    if hasClearcasting then
        extraEnergy = math.min(energy, 100)
    else
        extraEnergy = math.min(energy - 35, 65)
    end

    local energyBonus = extraEnergy * 0.005
    local maxDmg = math.floor(baseDmg * (1 + energyBonus))

    -- Get Feral Aggression talent rank (Feral Combat tree)
    local feralAggressionRank = 0
    local feralTabIndex = 2 -- Feral Combat tree
    local numTalents = GetNumTalents(feralTabIndex)

    for talentIndex = 1, numTalents do
        local name, _, _, _, rank = GetTalentInfo(feralTabIndex, talentIndex)
        if name and string.find(name, "Feral Aggression") then
            feralAggressionRank = rank
            break
        end
    end

    -- Apply Feral Aggression bonus (3% per rank) to max damage
    local feralAggressionBonus = feralAggressionRank * 0.03
    maxDmg = math.floor(maxDmg * (1 + feralAggressionBonus))

    local targetHealth = UnitHealth("target")

    if targetHealth <= maxDmg then
        CastSpellByName("Ferocious Bite")
        return true
    else
        return false
    end
end

-- TODO: get current crit% and multiply maxDmg with its value -> maxDmg = maxDmg * (1 + critpct)