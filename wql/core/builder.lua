local Builder = {
  MODES = {
    INSERT_ONLY = "INSERT_ONLY",
    UPDATE_ONLY = "UPDATE_ONLY",
    INSERT_OR_UPDATE = "INSERT_OR_UPDATE",
    DELETE_BEFORE_INSERT = "DELETE_BEFORE_INSERT",
    REPLACE = "REPLACE"
  }
}
Builder.generate_insert = function(entity)
  local columns = { }
  local values = { }
  local placeholders = { }
  for field_name, field_data in pairs(entity.fields) do
    local value = field_data.value
    if value then
      table.insert(columns, field_name)
      if type(value) == "string" then
        table.insert(values, "'" .. tostring(value:gsub("'", "''")) .. "'")
      else
        table.insert(values, tostring(value))
      end
      table.insert(placeholders, "?")
    end
  end
  if #columns == 0 then
    error("No fields to insert")
  end
  local query = string.format("INSERT INTO %s (%s) VALUES(%s);", entity.table_name, table.concat(columns, ", "), table.concat(values, ", "))
  local prepared_query = string.format("INSERT INTO %s (%s) VALUES(%s);", entity.table_name, table.concat(columns, ", "), table.concat(placeholders, ", "))
  return {
    query = query,
    prepared = prepared_query,
    values = values
  }
end
Builder.build = function(entity, where_conditions)
  local mode = entity.mode or Builder.MODES.INSERT_ONLY
  local queries = { }
  if mode == Builder.MODES.INSERT_ONLY then
    table.insert(queries, Builder.generate_insert(entity))
  else
    error("Unknow mode: " .. tostring(mode))
  end
  return queries
end
Builder.to_sql = function(entity, where_conditions)
  local queries = Builder.build(entity, where_conditions)
  local sql_strings = { }
  for _, query_data in ipairs(queries) do
    table.insert(sql_strings, query_data.query)
  end
  return table.concat(sql_strings, "\n")
end
return Builder
