resource "aws_ebs_volume" "this" {
  #checkov:skip=CKV2_AWS_9:EBS volume is being passed to backup module
  availability_zone = data.aws_subnet.this.availability_zone
  size              = var.data_volume_size
  encrypted         = true
  kms_key_id        = local.kms_key_arn
  tags              = var.tags
}

data "aws_iam_policy_document" "attach_data_volume_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:AttachVolume",
      "ec2:DetachVolume"
    ]
    resources = [
      "arn:aws:ec2:*:*:volume/*",
      "arn:aws:ec2:*:*:instance/*"
    ]
  }
}

resource "aws_iam_policy" "attach_data_volume_policy" {
  name_prefix = "cardano-node-attach-data-volume-"
  policy      = data.aws_iam_policy_document.attach_data_volume_policy.json
  tags        = var.tags
}
