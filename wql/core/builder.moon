Builder = {
    MODES: {
        INSERT_ONLY:            "INSERT_ONLY"
        UPDATE_ONLY:            "UPDATE_ONLY"
        INSERT_OR_UPDATE:       "INSERT_OR_UPDATE"
        DELETE_BEFORE_INSERT:   "DELETE_BEFORE_INSERT"
        REPLACE:                "REPLACE"
    }
}

Builder.generate_insert = (entity) ->
    columns = {}
    values = {}
    placeholders = {}

    for field_name, field_data in pairs entity.fields
        value = field_data.value
        if value
            table.insert columns, field_name

            if type(value) == "string"
                table.insert values, "'#{value\gsub("'", "''")}'"
            else
                table.insert values, tostring value

            table.insert placeholders, "?"

    if #columns == 0
        error "No fields to insert"

    query = string.format(
        "INSERT INTO %s (%s) VALUES(%s);",
        entity.table_name,
        table.concat(columns, ", "),
        table.concat(values, ", ")
    )

    prepared_query = string.format(
        "INSERT INTO %s (%s) VALUES(%s);",
        entity.table_name,
        table.concat(columns, ", "),
        table.concat(placeholders, ", ")
    )

    return {
        query: query,
        prepared: prepared_query,
        values: values
    }

Builder.generate_update = (entity, where_conditions) ->
    sets = {}
    where_clause = ""

    for field_name, field_data in pairs entity.fields
        value = field_data.value
        if value
            if type(value) == "string"
                table.insert sets, "#{field_name} = '#{value\gsub("'", "''")}'"
            else
                table.insert sets, "#{field_name} = #{tostring value}"
    
    if #sets == 0
        error "No fields to update"

    if where_conditions
        where_parts = {}
        for field, value in pairs where_conditions
            if type(value) == "string"
                table.insert where_parts, "#{field} = '#{value\gsub("'", "''")}'"
            else
                table.insert where_parts, "#{field} = #{tostring value}"

        if #where_parts > 0
            where_clause = " WHERE #{table.concat(where_parts, " AND ")}"
    else
        primary_key = entity.primary_key or "entry"
        primary_value = entity.fields[primary_key] and entity.fields[primary_key].value

        if primary_value
            where_clause = " WHERE #{primary_key} = #{tostring(primary_value)}"
        else
            error "No WHERE condition specified and no primary key value found"
    
    query = string.format(
        "UPDATE %s SET %s%s;",
        entity.table_name,
        table.concat(sets, ", "),
        where_clause
    )

    return {
        query: query
    }

Builder.build = (entity, where_conditions) ->
    mode = entity.mode or Builder.MODES.INSERT_ONLY
    queries = {}

    if mode == Builder.MODES.INSERT_ONLY
        table.insert queries, Builder.generate_insert entity
    elseif mode == Builder.MODES.UPDATE_ONLY
        table.insert queries, Builder.generate_update entity, where_conditions
    else
        error("Unknow mode: #{mode}")

    return queries

Builder.to_sql = (entity, where_conditions) ->
    queries = Builder.build entity, where_conditions
    sql_strings = {}

    for _, query_data in ipairs queries
        table.insert sql_strings, query_data.query

    table.concat sql_strings, "\n"
return Builder