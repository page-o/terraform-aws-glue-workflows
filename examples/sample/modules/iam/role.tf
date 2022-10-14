resource "aws_iam_role" "main" {
  name               = var.role.name
  assume_role_policy = var.role.assume_role_policy

  dynamic "inline_policy" {
    for_each = var.policies

    content {
      name   = inline_policy.value.name
      policy = inline_policy.value.content
    }
  }
}

resource "aws_iam_role_policy_attachment" "main" {
  count = length(var.managed_policies)

  role       = aws_iam_role.main.name
  policy_arn = element(var.managed_policies.*, count.index)
}
