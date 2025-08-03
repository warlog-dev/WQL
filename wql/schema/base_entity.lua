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
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.fields = { }
      self.table_name = ""
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
