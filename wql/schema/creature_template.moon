BaseEntity = require "wql.schema.base_entity"

class CreatureTemplate extends BaseEntity
    new: (id) =>
        @table_name = "creature_template"
        @fields = {
            entry:                     { default: 0,           value: id  }
            difficulty_entry_1:        { default: 0,           value: nil }
            difficulty_entry_2:        { default: 0,           value: nil }
            difficulty_entry_3:        { default: 0,           value: nil }
            KillCredit1:               { default: 0,           value: nil }
            KillCredit2:               { default: 0,           value: nil }
            modelid1:                  { default: 0,           value: nil }
            modelid2:                  { default: 0,           value: nil }
            modelid3:                  { default: 0,           value: nil }
            modelid4:                  { default: 0,           value: nil }
            name:                      { default: 0,           value: nil }
            subname:                   { default: "'(NULL)'",  value: nil }
            IconName:                  { default: "'(NULL)'",  value: nil }
            gossip_menu_id:            { default: 0,           value: nil }
            minlevel:                  { default: 1,           value: nil }
            maxlevel:                  { default: 1,           value: nil }
            exp:                       { default: 0,           value: nil }
            faction:                   { default: 0,           value: nil }
            npcflag:                   { default: 0,           value: nil }
            speed_walk:                { default: 1,           value: nil }
            speed_run:                 { default: 1.14286,     value: nil }
            scale:                     { default: 1,           value: nil }
            rank:                      { default: 0,           value: nil }
            dmgschool:                 { default: 0,           value: nil }
            BaseAttackTime:            { default: 0,           value: nil }
            RangeAttackTime:           { default: 0,           value: nil }
            BaseVariance:              { default: 1,           value: nil }
            RangeVariance:             { default: 1,           value: nil }
            unit_class:                { default: 0,           value: nil }
            unit_flags:                { default: 0,           value: nil }
            unit_flags2:               { default: 0,           value: nil }
            dynamicflags:              { default: 0,           value: nil }
            family:                    { default: 0,           value: nil }
            type:                      { default: 0,           value: nil }
            type_flags:                { default: 0,           value: nil }
            lootid:                    { default: 0,           value: nil }
            pickpocketloot:            { default: 0,           value: nil }
            skinloot:                  { default: 0,           value: nil }
            PetSpellDataId:            { default: 0,           value: nil }
            VehicleId:                 { default: 0,           value: nil }
            mingold:                   { default: 0,           value: nil }
            maxgold:                   { default: 0,           value: nil }
            AIName:                    { default: "",          value: nil }
            MovementType:              { default: 0,           value: nil }
            HoverHeight:               { default: 1,           value: nil }
            HealthModifier:            { default: 1,           value: nil }
            ManaModifier:              { default: 1,           value: nil }
            ArmorModifier:             { default: 1,           value: nil }
            DamageModifier:            { default: 1,           value: nil }
            ExperienceModifier:        { default: 1,           value: nil }
            RacialLeader:              { default: 0,           value: nil }
            movementID:                { default: 0,           value: nil }
            RegenHealth:               { default: 1,           value: nil }
            mechanic_immune_mask:      { default: 0,           value: nil }
            spell_school_immune_mask:  { default: 0,           value: nil }
            flags_extra:               { default: 0,           value: nil }
            ScriptName:                { default: "",          value: nil }
            VerifiedBuild:             { default: 0,           value: nil }
        }

        for column_name, column_data in pairs(@fields)
            name = column_data.override or column_name

            @["get_#{string.lower(name)}"] = ->
                return @get column_name

            @["set_#{string.lower(name)}"] = (self, value) -> 
                @set column_name, value
                return @

    set_difficulty_entry: (id, entry) =>
        if id > 0 and id < 4
            @["set_difficulty_entry_#{id}"]
        return @

    set_modelid: (id, model) =>
        if id > 0 and id < 5
            @["set_modelid_#{id}"](@, model)
        return @

    set_killcredit: (id, entry) =>
        if id > 0 and id < 3
            @["set_killcredit#{id}"](@, entry)
        return @

    set_level: (minlevel, maxlevel) =>
        @\set_minlevel minlevel
        @\set_maxlevel maxlevel or minlevel
        return @

    set_speed: (speed_type, speed_value) =>
        switch speed_type
            when CT_SPEED_TYPE.WALK
                @\SetSpeedWalk speed_value
            when CT_SPEED_TYPE.RUN
                @\SetSpeedRun speed_value
        return @

return CreatureTemplate