module "scripts_bucket" {
  source = "./modules/s3"

  bucket = {
    name = "${local.env}-${local.project}-scripts-bucket"
  }
  objects = [
    {
      key    = local.object_key.hoge
      source = local.object_source.hoge
    },
    {
      key    = local.object_key.fuga
      source = local.object_source.fuga
    }
  ]
}

module "source_bucket" {
  source = "./modules/s3"

  bucket = {
    name = "${local.env}-${local.project}-source-bucket"
  }
  objects = [
    {
      key    = local.object_key.hoge
      source = local.object_source.hoge
    },
    {
      key    = local.object_key.fuga
      source = local.object_source.fuga
    }
  ]
}

module "target_bucket" {
  source = "./modules/s3"

  bucket = {
    name = "${local.env}-${local.project}-target-bucket"
  }
}

module "workflow_role" {
  source = "./modules/iam"

  role = {
    name = "${local.env}-${local.project}-workflow-role"
    assume_role_policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Sid    = ""
          Principal = {
            Service = "glue.amazonaws.com"
          }
        },
      ]
    })
  }
  policies = []
  managed_policies = [
    "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
  ]
}

locals {
  default_arguments = {
    "--class"                            = "GlueApp"
    "--job-language"                     = "python"
    "--job-bookmark-option"              = "job-bookmark-enable"
    "--TempDir"                          = "s3://${module.scripts_bucket.name}/temporary/"
    "--enable-metrics"                   = true
    "--enable-continuous-cloudwatch-log" = true
    "--enable-spark-ui"                  = true
    "--spark-event-logs-path"            = "s3://${module.scripts_bucket.name}/sparkHistoryLogs/"
    "--enable-glue-datacatalog"          = true
    "--enable-job-insights"              = true
    "--catalog_database"                 = "${local.env}-${local.project}-database"
    "--target_bucket"                    = module.target_bucket.name
  }
}

module "glue_workflows" {
  source = "../../"

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
