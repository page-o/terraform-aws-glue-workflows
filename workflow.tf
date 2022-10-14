resource "aws_glue_workflow" "main" {
  name        = var.workflow.name
  description = var.workflow.description
}

resource "aws_glue_trigger" "event" {
  workflow_name = aws_glue_workflow.main.name
  name          = var.event_trigger.name
  description   = var.event_trigger.description
  type          = "EVENT"

  event_batching_condition {
    batch_size   = 1
    batch_window = 900
  }

  actions {
    crawler_name = aws_glue_crawler.main.name
  }
}

resource "aws_glue_trigger" "crawler" {
  workflow_name = aws_glue_workflow.main.name
  name          = var.crawler_trigger.name
  description   = var.crawler_trigger.description
  type          = "CONDITIONAL"

  predicate {
    logical = "ANY"
    conditions {
      crawler_name     = aws_glue_crawler.main.name
      crawl_state      = "SUCCEEDED"
      logical_operator = "EQUALS"
    }
  }

  dynamic "actions" {
    for_each = aws_glue_job.main

    content {
      job_name = actions.value.id
    }
  }
}
