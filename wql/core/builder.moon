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
        error("No fields to insert")

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

Builder.build = (entity, where_conditions) ->
    mode = entity.mode or Builder.MODES.INSERT_ONLY
    queries = {}

    if mode == Builder.MODES.INSERT_ONLY
        table.insert queries, Builder.generate_insert entity
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