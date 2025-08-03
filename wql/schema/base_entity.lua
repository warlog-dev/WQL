local Builder = require("wql.core.builder")
local BaseEntity
do
  local _class_0
  local _base_0 = {
    set = function(self, field, value)
      if not self.fields[field] then
        error("Field " .. tostring(field) .. " not exist")
      end
      self.fields[field].value = value
      return self
    end,
    get = function(self, field)
      if not self.fields[field] then
        error("Field " .. tostring(field) .. " not exist")
      end
      return self.fields[field].value
    end,
    set_mode = function(self, mode)
      if not (Builder.MODES[mode]) then
        error("Invalide mode: " .. tostring(mode))
      end
      self.mode = mode
      return self
    end,
    get_mode = function(self, mode)
      return self.mode or Builder.MODES.INSERT_ONLY
    end,
    build = function(self, where_conditions)
      return Builder.build(self, where_conditions)
    end,
    to_sql = function(self, where_conditions)
      return Builder.to_sql(self, where_conditions)
    end,
    insert_only = function(self)
      return self:set_mode("INSERT_ONLY")
    end,
    update_only = function(self)
      return self:set_mode("UPDATE_ONLY")
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.fields = { }
      self.table_name = nil
      self.mode = nil
    end,
    __base = _base_0,
    __name = "BaseEntity"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  BaseEntity = _class_0
end
return BaseEntity
