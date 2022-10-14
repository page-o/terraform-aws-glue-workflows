variable "role" {
  type = object({
    name               = string
    assume_role_policy = string
  })
}

variable "policies" {
  type = list(object({
    name    = string
    content = string
  }))
  default = []
}

variable "managed_policies" {
  type    = list(string)
  default = []
}
