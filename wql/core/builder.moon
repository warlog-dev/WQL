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

Builder.generate_delete = (entity, where_conditions) ->
    where_clause = ""

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
        "DELETE FROM %s%s;",
        entity.table_name,
        where_clause
    )

    return {
        query: query
    }

Builder.generate_replace = (entity) ->
    columns = {}
    values = {}

    for field_name, field_data in pairs entity.fields
        value = field_data.value
        if value
            table.insert columns, field_name

            if type(value) == "string"
                table.insert values, "'#{value\gsub("'", "''")}'"
            else
                table.insert values, tostring value

    if #columns == 0
        error "No fields to replace"

    query = string.format(
        "REPLACE INTO %s (%s) VALUES (%s);",
        entity.table_name,
        table.concat(columns, ", "),
        table.concat(values, ", ")
    )

    return {
        query: query
    }

Builder.generate_insert_or_update = (entity) ->
    insert_result = Builder.generate_insert entity
    updates = {}

    for field_name, field_data in pairs entity.fields
        value = field_data.value
        if value and field_name != (entity.primary_key or "entry")
            if type(value) == "string"
                table.insert updates, "#{field_name} = '#{value\gsub("'", "''")}'"
            else
                table.insert updates, "#{field_name} = #{tostring value}"
    
    if #updates == 0
        return insert_result

    query = "#{insert_result.query\gsub(";$", "")} ON DUPLICATE KEY UPDATE #{table.concat(updates, ", ")};"

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
    elseif mode == Builder.MODES.INSERT_OR_UPDATE
        table.insert queries, Builder.generate_insert_or_update entity
    elseif mode == Builder.MODES.DELETE_BEFORE_INSERT
        table.insert queries, Builder.generate_delete entity, where_conditions
        table.insert queries, Builder.generate_insert entity
    elseif mode == Builder.MODES.REPLACE
        table.insert queries, Builder.generate_replace entity
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