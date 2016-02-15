# ChatOps service
[Rocketchat]: https://rocket.chat/
[Hubot]: https://hubot.github.com/

This service composed of two services, [RocketChat] and [Hubot], deployed into Docker containers on a host on AWS inside of a VPC. Mean to be used with a VPC.

Once the terraform module deploys RocketChat and Hubot, you'll need to create a User in Rocketchat and then create a user for Hubot with the credentials that you put into the module.

#### Inputs

* `aws_key` AWS key used for accessing the Chat instance.
* `domain` Domain used to access both the RocketChat and Hubot service.
* `ssh-private-key` SSH private key location that matches `aws_key`.
* `vpc_id`  VPC in which to create the security groups.
* `vpc_subnet_id` VPC Subnet in which to launch the instance.

**Optional Inputs**

* `ami`  AMI used to build the chat service. _default: [ami-7b386c11]()_
* `region`  deploy to this AWS Region.  _default: us-east-1_
* `instance-type` size of the instance. _default: m3.medium_
* `rocketchat_user` username for the rocketchat bot. _default: hubot_
* `rocketchat_password` password for the rocketchat_bot. _default:hubot_

#### Outputs

* `host` The IP address of the system hosting RocketChat and Hubot
* `domain` The Domain at which both of these are available (from the input `domain`)

#### Example

```
module "chat" {
  source = "github.com/azizshamim/terraform-chatops"
  vpc_id = "xxxxxx"
  vpc_subnet_id = "xxxxxx"
  aws_key = "my-key"
  ssh-private-key="~/.ssh/my-key"
  domain = "chat.yourchat.com"
  rocketchat_user = "yourbot"
  rocketchat_password = "yourbotisawesome"
}
```
