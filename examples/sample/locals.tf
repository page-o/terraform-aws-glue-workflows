locals {
  env     = "sample"
  project = "example"

  object_key = {
    hoge      = "hoge.parquet"
    fuga      = "fuga.parquet"
    hoge_code = "scripts/hoge.py"
    fuga_code = "scripts/fuga.py"
  }
  object_source = {
    hoge = "templates/bucket/hoge.parquet"
    fuga = "templates/bucket/fuga.parquet"
  }
  job_script_object_key = {
    hoge = "scripts/hoge.py"
    fuga = "scripts/fuga.py"
  }
}
