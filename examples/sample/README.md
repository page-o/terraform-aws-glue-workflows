## Example

```
module "hoge" {
  source = "page-o/network/aws"

  vpc = {
    cidr_block = "172.16.0.0/16"
    name       = "vpc"
  }
  public_subnets = [
    {
      cidr = "172.16.0.0/24"
      az   = "ap-northeast-1a"
      name = "public-1a"
    },
    {
      cidr = "172.16.4.0/24"
      az   = "ap-northeast-1c"
      name = "public-1c"
    }
  ]
  public_subnets_route_table_name = "public-route-table"
  private_subnets = [
    {
      cidr             = "172.16.32.0/24"
      az               = "ap-northeast-1a"
      name             = "private-1a"
      route_table_name = "private-route-table-1a"
    },
    {
      cidr             ="172.16.36.0/24"
      az               = "ap-northeast-1c"
      name             = "private-1c"
      route_table_name = "private-route-table-1c"
    }
  ]
  private_secondary_subnets = [
    {
      cidr = "172.16.64.0/24"
      az   = "ap-northeast-1a"
      name = "private-db-1a"
    },
    {
      cidr = "172.16.68.0/24"
      az   = "ap-northeast-1c"
      name = "private-db-1c"
    }
  ]
  private_secondary_subnets_route_table_name = "private-db-route-table"
  gateway = {
    igw_name = "internet-gateway"
    ngw_names = [
      "nat-gateway-1a",
      "nat-gateway-1c"
    ]
  }
}
```
