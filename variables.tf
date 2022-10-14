variable "workflow" {
  description = "Workflow"
  type = object({
    name        = string
    description = string
  })
}

variable "event_trigger" {
  type = object({
    name        = string
    description = string
  })
}

variable "crawler_trigger" {
  type = object({
    name        = string
    description = string
  })
}

variable "catalog" {
  type = object({
    database_name        = string
    database_description = string
    tables = list(object({
      name                  = string
      description           = string
      table_type            = optional(string, "EXTERNAL_TABLE")
      storage_location      = string
      input_format          = optional(string, "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat")
      output_format         = optional(string, "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat")
      ser_de_name           = string
      serialization_library = optional(string, "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe")
    }))
  })
}

variable "crawler" {
  type = object({
    name                  = string
    description           = string
    role_arn              = string
    catalog_target_tables = list(string)
  })
}

variable "jobs" {
  type = list(object({
    name                = string
    description         = string
    glue_version        = optional(string, "3.0")
    execution_class     = optional(string, "STANDARD")
    max_retries         = optional(number, 3)
    timeout             = optional(number, 2880)
    worker_type         = optional(string, "G.1X")
    number_of_workers   = optional(number, 10)
    max_concurrent_runs = optional(number, 1)
    script_object_key   = string
    default_arguments   = map(string)
  }))
}

variable "job_role_arn" {
  type = string
}

variable "job_tmp_bucket_name" {
  type = string
}
