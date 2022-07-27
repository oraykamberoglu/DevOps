resource "aws_iam_user" "myfirst-user" {
  name = "oray"

  tags = {
    tag-key = "DevOpsOray"
    enviroment = "Dev"
  }
}