resource "aws_iam_policy" "iam_policy_s3" {
  name        = "${var.env_code}_iam_policy"
  description = "My S3 policy"
  policy      = <<EOF
{
   "Version": "2012-10-17",
      "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                    "s3:ListBucket",
                    "s3:GetObject",
                    "s3:PutObject",
                    "s3:DeleteObject"
                    ],
            "Resource": [
                "arn:aws:s3:::israel-terraform",
                "arn:aws:s3:::israel-terraform/*"
            ]
        }
  ]
}
 EOF
}

resource "aws_iam_role" "ec2_s3_access_iam_role" {
  name               = "${var.env_code}_profile_role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
            "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}

  EOF
}

resource "aws_iam_role_policy_attachment" "assign-policy-to-role-attach" {
  role       = aws_iam_role.ec2_s3_access_iam_role.name
  policy_arn = aws_iam_policy.iam_policy_s3.arn

  depends_on = [aws_iam_policy.iam_policy_s3]
}

resource "aws_iam_role_policy_attachment" "assign-policy-SessionManager" {
  role       = aws_iam_role.ec2_s3_access_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

  depends_on = [aws_iam_role.ec2_s3_access_iam_role]
}

resource "aws_iam_instance_profile" "lc_profile" {
  name = "${var.env_code}_profile_role"
  role = aws_iam_role.ec2_s3_access_iam_role.name
}
