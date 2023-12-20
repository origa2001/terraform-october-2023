resource "aws_iam_user" "user1" {
  name = "Origa"
}

resource "aws_iam_user" "user2" {
  name = "kaizen"
}

resource "aws_iam_user" "user3" {
  name = "hello"
}

resource "aws_iam_user" "user4" {
  name = "world"
}

resource "aws_iam_group" "developers" {
  name = "devops"
}

resource "aws_iam_group" "Test" {
  name = "QA"
}

resource "aws_iam_group_membership" "team" {
  name = "tf-testing-group-membership"

  users = [
    aws_iam_user.user1.name,
    aws_iam_user.user2.name,
  ]

  group = aws_iam_group.developers.name
}

resource "aws_iam_group_membership" "team2" {
  name = "tf-testing-group-membership"

  users = [
    aws_iam_user.user3.name,
    aws_iam_user.user4.name,
  ]

  group = aws_iam_group.Test.name
}

resource "aws_iam_user" "user5" {
  name = "admin1"
}

    # output user {
    #     value = aws_iam_user.user1
    # }

output user2 {
        value = aws_iam_user.user2.unique_id
    }

 resource "aws_s3_bucket" "korzina" {
  bucket = "origa-kaizen"
}   

resource "aws_s3_bucket" "korzina1" {
  bucket = "origa-kaizen1"
}   