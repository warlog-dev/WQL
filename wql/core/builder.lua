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
Builder.generate_update = function(entity, where_conditions)
  local sets = { }
  local where_clause = ""
  for field_name, field_data in pairs(entity.fields) do
    local value = field_data.value
    if value then
      if type(value) == "string" then
        table.insert(sets, tostring(field_name) .. " = '" .. tostring(value:gsub("'", "''")) .. "'")
      else
        table.insert(sets, tostring(field_name) .. " = " .. tostring(tostring(value)))
      end
    end
  end
  if #sets == 0 then
    error("No fields to update")
  end
  if where_conditions then
    local where_parts = { }
    for field, value in pairs(where_conditions) do
      if type(value) == "string" then
        table.insert(where_parts, tostring(field) .. " = '" .. tostring(value:gsub("'", "''")) .. "'")
      else
        table.insert(where_parts, tostring(field) .. " = " .. tostring(tostring(value)))
      end
    end
    if #where_parts > 0 then
      where_clause = " WHERE " .. tostring(table.concat(where_parts, " AND "))
    end
  else
    local primary_key = entity.primary_key or "entry"
    local primary_value = entity.fields[primary_key] and entity.fields[primary_key].value
    if primary_value then
      where_clause = " WHERE " .. tostring(primary_key) .. " = " .. tostring(tostring(primary_value))
    else
      error("No WHERE condition specified and no primary key value found")
    end
  end
  local query = string.format("UPDATE %s SET %s%s;", entity.table_name, table.concat(sets, ", "), where_clause)
  return {
    query = query
  }
end
Builder.build = function(entity, where_conditions)
  local mode = entity.mode or Builder.MODES.INSERT_ONLY
  local queries = { }
  if mode == Builder.MODES.INSERT_ONLY then
    table.insert(queries, Builder.generate_insert(entity))
  elseif mode == Builder.MODES.UPDATE_ONLY then
    table.insert(queries, Builder.generate_update(entity, where_conditions))
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
