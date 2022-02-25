module "vpc_peering" {
  source = "cloudposse/vpc-peering/aws"
  # Cloud Posse recommends pinning every module to a specific version
  version          = "0.9.2"
  namespace        = "muledemo"
  stage            = "bmdev"
  name             = "muledemo"
  requestor_vpc_id = module.vpc[0].vpc_id
  acceptor_vpc_id  = module.vpc[1].vpc_id

}