local BaseEntity = require("wql.schema.base_entity")
local CreatureTemplate
do
  local _class_0
  local _parent_0 = BaseEntity
  local _base_0 = {
    set_difficulty_entry = function(self, id, entry)
      if id > 0 and id < 4 then
        local _ = self["set_difficulty_entry_" .. tostring(id)]
      end
      return self
    end,
    set_modelid = function(self, id, model)
      if id > 0 and id < 5 then
        self["set_modelid_" .. tostring(id)](self, model)
      end
      return self
    end,
    set_killcredit = function(self, id, entry)
      if id > 0 and id < 3 then
        self["set_killcredit" .. tostring(id)](self, entry)
      end
      return self
    end,
    set_level = function(self, minlevel, maxlevel)
      self:set_minlevel(minlevel)
      self:set_maxlevel(maxlevel or minlevel)
      return self
    end,
    set_speed = function(self, speed_type, speed_value)
      local _exp_0 = speed_type
      if CT_SPEED_TYPE.WALK == _exp_0 then
        self:SetSpeedWalk(speed_value)
      elseif CT_SPEED_TYPE.RUN == _exp_0 then
        self:SetSpeedRun(speed_value)
      end
      return self
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, id)
      self.table_name = "creature_template"
      self.fields = {
        entry = {
          default = 0,
          value = id
        },
        difficulty_entry_1 = {
          default = 0,
          value = nil
        },
        difficulty_entry_2 = {
          default = 0,
          value = nil
        },
        difficulty_entry_3 = {
          default = 0,
          value = nil
        },
        KillCredit1 = {
          default = 0,
          value = nil
        },
        KillCredit2 = {
          default = 0,
          value = nil
        },
        modelid1 = {
          default = 0,
          value = nil
        },
        modelid2 = {
          default = 0,
          value = nil
        },
        modelid3 = {
          default = 0,
          value = nil
        },
        modelid4 = {
          default = 0,
          value = nil
        },
        name = {
          default = 0,
          value = nil
        },
        subname = {
          default = "'(NULL)'",
          value = nil
        },
        IconName = {
          default = "'(NULL)'",
          value = nil
        },
        gossip_menu_id = {
          default = 0,
          value = nil
        },
        minlevel = {
          default = 1,
          value = nil
        },
        maxlevel = {
          default = 1,
          value = nil
        },
        exp = {
          default = 0,
          value = nil
        },
        faction = {
          default = 0,
          value = nil
        },
        npcflag = {
          default = 0,
          value = nil
        },
        speed_walk = {
          default = 1,
          value = nil
        },
        speed_run = {
          default = 1.14286,
          value = nil
        },
        scale = {
          default = 1,
          value = nil
        },
        rank = {
          default = 0,
          value = nil
        },
        dmgschool = {
          default = 0,
          value = nil
        },
        BaseAttackTime = {
          default = 0,
          value = nil
        },
        RangeAttackTime = {
          default = 0,
          value = nil
        },
        BaseVariance = {
          default = 1,
          value = nil
        },
        RangeVariance = {
          default = 1,
          value = nil
        },
        unit_class = {
          default = 0,
          value = nil
        },
        unit_flags = {
          default = 0,
          value = nil
        },
        unit_flags2 = {
          default = 0,
          value = nil
        },
        dynamicflags = {
          default = 0,
          value = nil
        },
        family = {
          default = 0,
          value = nil
        },
        type = {
          default = 0,
          value = nil
        },
        type_flags = {
          default = 0,
          value = nil
        },
        lootid = {
          default = 0,
          value = nil
        },
        pickpocketloot = {
          default = 0,
          value = nil
        },
        skinloot = {
          default = 0,
          value = nil
        },
        PetSpellDataId = {
          default = 0,
          value = nil
        },
        VehicleId = {
          default = 0,
          value = nil
        },
        mingold = {
          default = 0,
          value = nil
        },
        maxgold = {
          default = 0,
          value = nil
        },
        AIName = {
          default = "",
          value = nil
        },
        MovementType = {
          default = 0,
          value = nil
        },
        HoverHeight = {
          default = 1,
          value = nil
        },
        HealthModifier = {
          default = 1,
          value = nil
        },
        ManaModifier = {
          default = 1,
          value = nil
        },
        ArmorModifier = {
          default = 1,
          value = nil
        },
        DamageModifier = {
          default = 1,
          value = nil
        },
        ExperienceModifier = {
          default = 1,
          value = nil
        },
        RacialLeader = {
          default = 0,
          value = nil
        },
        movementID = {
          default = 0,
          value = nil
        },
        RegenHealth = {
          default = 1,
          value = nil
        },
        mechanic_immune_mask = {
          default = 0,
          value = nil
        },
        spell_school_immune_mask = {
          default = 0,
          value = nil
        },
        flags_extra = {
          default = 0,
          value = nil
        },
        ScriptName = {
          default = "",
          value = nil
        },
        VerifiedBuild = {
          default = 0,
          value = nil
        }
      }
      for column_name, column_data in pairs(self.fields) do
        local name = column_data.override or column_name
        self["get_" .. tostring(string.lower(name))] = function()
          return self:get(column_name)
        end
        self["set_" .. tostring(string.lower(name))] = function(self, value)
          self:set(column_name, value)
          return self
        end
      end
    end,
    __base = _base_0,
    __name = "CreatureTemplate",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  CreatureTemplate = _class_0
end
return CreatureTemplate
