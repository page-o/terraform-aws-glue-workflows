resource "aws_glue_crawler" "main" {
  database_name = aws_glue_catalog_database.main.name
  name          = var.crawler.name
  description   = var.crawler.description
  role          = var.crawler.role_arn

  catalog_target {
    database_name = aws_glue_catalog_database.main.name
    tables        = var.crawler.catalog_target_tables
  }

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }

  lifecycle {
    ignore_changes = [configuration]
  }
}
