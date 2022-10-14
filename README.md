![Terraform](https://www.datocms-assets.com/2885/1620155113-brandhcterraformprimaryattributedcolor.svg)
# terraform-aws-glue-workflows
Terraform module to create Glue resources such as Glue Workflows/Triggers/Jobs/Crawlers/Data Catalog

Creates the following resources:

- **Glue Workflows**
- **Glue Triggers**
- **Glue Jobs**
- **Glue Clawlers**
- **Glue Data Catalog**


## Examples

Check the [examples](/examples/) folder.

## Usage

```
module "glue_workflows" {
  source = "page-o/glue-workflows/aws"

  workflow = {
    name        = "${local.env}-${local.project}-glue-workflow"
    description = "Sample"
  }
  event_trigger = {
    name        = "${local.env}-${local.project}-event-trigger"
    description = "Sample"
  }
  crawler_trigger = {
    name        = "${local.env}-${local.project}-crawler-trigger"
    description = "Sample"
  }
  catalog = {
    database_name        = "${local.env}-${local.project}-database"
    database_description = "Sample"
    tables = [
      {
        name             = "hoges"
        description      = "Sample"
        storage_location = "s3://${module.source_bucket.name}/hoges/"
        ser_de_name      = "hoges"
      },
      {
        name             = "fugas"
        description      = "Sample"
        storage_location = "s3://${module.source_bucket.name}/fugas/"
        ser_de_name      = "fugas"
      }
    ]
  }
  crawler = {
    name                  = "${local.env}-${local.project}-crawler"
    description           = "Sample"
    role_arn              = module.workflow_role.arn
    catalog_target_tables = ["hoges", "fugas"]
  }
  jobs = [
    {
      name              = "${local.env}-${local.project}-hoges-job"
      description       = "Sample"
      script_object_key = local.job_script_object_key.hoge
      default_arguments = local.default_arguments
    },
    {
      name              = "${local.env}-${local.project}-fugas-job"
      description       = "Sample"
      script_object_key = local.job_script_object_key.fuga
      default_arguments = local.default_arguments
    }
  ]
  job_role_arn        = module.workflow_role.arn
  job_tmp_bucket_name = module.scripts_bucket.name
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| workflow | Workflow | `object` | - | yes |
| workflow.name | Workflow Name | `string` | - | yes |
| workflow.description | Workflow Description | `string` | - | yes |
| event_trigger | EventBridge Trigger | `object` | - | yes |
| event_trigger.name | Trigger Name | `string` | - | yes |
| event_trigger.description | Trigger Description | `string` | - | yes |
| crawler_trigger | Crawler Trigger | `object` | - | yes |
| crawler_trigger.name | Trigger Name | `string` | - | yes |
| crawler_trigger.description | Trigger Description | `string` | - | yes |
| catalog | Catalog | `object` | - | yes |
| catalog.database_name | Catalog Database Name | `string` | - | yes |
| catalog.database_description | Catalog Database Description | `string` | - | yes |
| catalog.tables | Catalog Tables | `list(object)` | - | yes |
| catalog.tables.*.name | Catalog Table Name | `string` | - | yes |
| catalog.tables.*.description | Catalog Table Description | `string` | - | yes |
| catalog.tables.*.table_type | Catalog Table Type | `string` | `"EXTERNAL_TABLE"` | no |
| catalog.tables.*.storage_location | Catalog Table Storage Location | `string` | - | yes |
| catalog.tables.*.input_format | Catalog Input Format | `string` | `"org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"` | no |
| catalog.tables.*.output_format | Catalog Output Format | `string` | `"org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"` | no |
| catalog.tables.*.ser_de_name | Catalog Table ser_de_name | `string` | - | yes |
| catalog.tables.*.serialization_library | Catalog Serialization Library | `string` | `"org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"` | no |
| crawler | Catalog | `object` | - | yes |
| crawler.name | Crawler Name | `string` | - | yes |
| crawler.description | Crawler Description | `string` | - | yes |
| crawler.role_arn | Crawler Role ARN | `string` | - | yes |
| crawler.catalog_target_tables | Crawler Catalog Target Tables | `list(string)` | - | yes |
| jobs | Jobs | `list(object)` | - | yes |
| jobs.*.name | Jobs Name | `string` | - | yes |
| jobs.*.description | Jobs Description | `string` | - | yes |
| jobs.*.glue_version | Jobs Glue Version | `string` | `"3.0"` | no |
| jobs.*.execution_class | Jobs Execution Class | `string` | `"STANDARD"` | no |
| jobs.*.max_retries | Jobs Max Retries | `number` | `3` | no |
| jobs.*.timeout | Jobs Timeout | `number` | `2880` | no |
| jobs.*.worker_type | Jobs Worker Type | `string` | `"G.1X"` | no |
| jobs.*.number_of_workers | Jobs Number of Workers | `number` | `10` | no |
| jobs.*.max_concurrent_runs | Jobs Max Concurrent Runs | `number` | `1` | no |
| jobs.*.script_object_key | Jobs Script Object Key | `string` | - | yes |
| jobs.*.default_arguments | Jobs Default Arguments | `map(string)` | - | yes |
| job_role_arn | Job Role ARN | `string` | - | yes |
| job_tmp_bucket_name | Job Temporary Bucket Name | `string` | - | yes |

## Outputs

| Name | Description | Type |
|------|-------------|------|
| workflow_arn | Glue Workflow ARN | `string` |
