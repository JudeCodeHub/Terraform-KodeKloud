# Provision EC2 Instance with CloudWatch CPU Utilization Alarm Using Terraform

## 📌 Task Description

The **Nautilus DevOps team** has been tasked with setting up an EC2 instance for their application. To ensure optimal performance and operational visibility, they need to create a CloudWatch alarm that monitors the instance's CPU utilization. The alarm triggers when CPU utilization meets or exceeds 90% over a 5-minute period, sending immediate alert notifications to a designated Amazon SNS topic.

**Requirements:**

- Launch an EC2 instance named **`nautilus-ec2`** using an Ubuntu AMI (`ami-0c02fb55956c7d316`) and instance type **`t2.micro`**.
- Configure a CloudWatch alarm named **`nautilus-alarm`** with the following specifications:
  - **Metric**: `CPUUtilization`
  - **Namespace**: `AWS/EC2`
  - **Statistic**: `Average`
  - **Period**: 300 seconds (5 minutes)
  - **Evaluation Periods**: `1`
  - **Threshold**: `>= 90%` (`GreaterThanOrEqualToThreshold`)
  - **Dimensions**: `InstanceId = aws_instance.nautilus_ec2.id`
  - **Alarm Actions**: Send notification to the **`nautilus-sns-topic`** SNS topic.
- Update the **`main.tf`** file (do not create a separate `.tf` file) to provision the SNS topic, EC2 instance, and CloudWatch alarm.
- Create an **`outputs.tf`** file to output:
  - **`KKE_instance_name`**: The EC2 instance name.
  - **`KKE_alarm_name`**: The CloudWatch alarm name.
- The Terraform working directory is **`/home/bob/terraform`**.

👉 **Your task:** Configure `aws_sns_topic`, `aws_instance`, and `aws_cloudwatch_metric_alarm` in `main.tf`, and export the instance name and alarm name in `outputs.tf`.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud  
**Provider:** AWS (Amazon Web Services)  
**Configuration Files & Structure:**

- **`main.tf`**:
  - `aws_sns_topic.sns_topic`: Manages or references the `nautilus-sns-topic` SNS topic used for alert dispatch.
  - `aws_instance.nautilus_ec2`: Provisions the `t2.micro` Ubuntu EC2 instance tagged `Name = "nautilus-ec2"`.
  - `aws_cloudwatch_metric_alarm.nautilus_alarm`: Monitors `CPUUtilization` for `InstanceId = aws_instance.nautilus_ec2.id` with `threshold = 90`, `period = 300`, `evaluation_periods = 1`, and triggers `alarm_actions = [aws_sns_topic.sns_topic.arn]`.
- **`outputs.tf`**:
  - `KKE_instance_name`: Exposes `aws_instance.nautilus_ec2.tags["Name"]`.
  - `KKE_alarm_name`: Exposes `aws_cloudwatch_metric_alarm.nautilus_alarm.alarm_name`.

**Working Directory:** `/home/bob/terraform`

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**

   ```bash
   cd /home/bob/terraform
   ```

2. **Configure SNS Topic, EC2 Instance, and CloudWatch Alarm in `main.tf`:**

   Define the SNS topic, EC2 instance, and the CloudWatch metric alarm:

   ```hcl
   resource "aws_sns_topic" "sns_topic" {
     name = "nautilus-sns-topic"
   }

   resource "aws_instance" "nautilus_ec2" {
     ami           = "ami-0c02fb55956c7d316"
     instance_type = "t2.micro"

     tags = {
       Name = "nautilus-ec2"
     }
   }

   resource "aws_cloudwatch_metric_alarm" "nautilus_alarm" {
     alarm_name          = "nautilus-alarm"
     comparison_operator = "GreaterThanOrEqualToThreshold"
     evaluation_periods  = 1
     metric_name         = "CPUUtilization"
     namespace           = "AWS/EC2"
     period              = 300
     statistic           = "Average"
     threshold           = 90
     alarm_actions       = [aws_sns_topic.sns_topic.arn]

     dimensions = {
       InstanceId = aws_instance.nautilus_ec2.id
     }
   }
   ```

3. **Define Outputs in `outputs.tf`:**

   Configure outputs to expose the instance and alarm names:

   ```hcl
   output "KKE_instance_name" {
     value       = aws_instance.nautilus_ec2.tags["Name"]
     description = "The EC2 instance name"
   }

   output "KKE_alarm_name" {
     value       = aws_cloudwatch_metric_alarm.nautilus_alarm.alarm_name
     description = "The CloudWatch alarm name"
   }
   ```

4. **Initialize Terraform:**

   Initialize the working directory to download the AWS provider plugins:

   ```bash
   terraform init
   ```

5. **Validate Configuration & Review Execution Plan:**

   Validate syntax and inspect the planned resources:

   ```bash
   terraform validate
   terraform plan
   ```

6. **Apply the Configuration:**

   Provision the resources:

   ```bash
   terraform apply -auto-approve
   ```

7. **Verify Outputs & Resources:**

   Check the Terraform output values:

   ```bash
   terraform output
   ```

   Verify the EC2 instance via AWS CLI:

   ```bash
   aws ec2 describe-instances \
     --filters "Name=tag:Name,Values=nautilus-ec2" "Name=instance-state-name,Values=pending,running" \
     --query "Reservations[].Instances[*].[InstanceId,InstanceType,State.Name,Tags[?Key=='Name'].Value | [0]]" \
     --output table
   ```

   Verify the CloudWatch metric alarm:

   ```bash
   aws cloudwatch describe-alarms \
     --alarm-names nautilus-alarm \
     --query "MetricAlarms[*].[AlarmName,MetricName,Namespace,Threshold,ComparisonOperator,Period,EvaluationPeriods,StateValue]" \
     --output table
   ```

   Verify the SNS topic attributes:

   ```bash
   aws sns get-topic-attributes \
     --topic-arn $(aws sns list-topics --query "Topics[?contains(TopicArn, 'nautilus-sns-topic')].TopicArn | [0]" --output text)
   ```

