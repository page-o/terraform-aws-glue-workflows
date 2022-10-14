## Example

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
