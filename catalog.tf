resource "aws_glue_catalog_database" "main" {
  name        = var.catalog.database_name
  description = var.catalog.database_description
}

resource "aws_glue_catalog_table" "main" {
  count = length(var.catalog.tables)

  database_name = aws_glue_catalog_database.main.name
  name          = element(var.catalog.tables.*.name, count.index)
  description   = element(var.catalog.tables.*.description, count.index)
  table_type    = element(var.catalog.tables.*.table_type, count.index)

  storage_descriptor {
    location      = element(var.catalog.tables.*.storage_location, count.index)
    input_format  = element(var.catalog.tables.*.input_format, count.index)
    output_format = element(var.catalog.tables.*.output_format, count.index)

    ser_de_info {
      name                  = element(var.catalog.tables.*.ser_de_name, count.index)
      serialization_library = element(var.catalog.tables.*.serialization_library, count.index)

      parameters = {
        "serialization.format" = 1
      }
    }
  }

  lifecycle {
    ignore_changes = [parameters, storage_descriptor, owner]
  }
}
