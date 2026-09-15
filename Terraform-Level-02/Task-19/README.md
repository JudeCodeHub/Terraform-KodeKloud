# Configure CloudWatch Alarm with SNS Integration for EC2 Monitoring Using Terraform

## 📌 Task Description

The **Nautilus DevOps team** is expanding their AWS infrastructure and requires the setup of Amazon CloudWatch alarms integrated with Amazon SNS for proactive EC2 monitoring. The team needs to configure an SNS topic for CloudWatch to publish notifications whenever EC2 instance CPU utilization exceeds 80%, ensuring immediate alerts are dispatched to the DevOps team.

**Requirements:**

- Create an SNS topic named **`devops-sns-topic`**.
- Create a CloudWatch alarm named **`devops-cpu-alarm`** to monitor EC2 CPU utilization with the following specifications:
  - **Metric**: `CPUUtilization`
  - **Namespace**: `AWS/EC2`
  - **Statistic**: `Average`
  - **Period**: 300 seconds (5 minutes)
  - **Evaluation Periods**: `1`
  - **Threshold**: `80%` (`GreaterThanOrEqualToThreshold`)
  - **Actions Enabled**: `true`
  - **Alarm Actions**: Send alert notifications to **`devops-sns-topic`**.
- Update the **`main.tf`** file (do not create a separate `.tf` file) to provision the SNS topic and CloudWatch alarm.
- Create an **`outputs.tf`** file to output:
  - **`KKE_sns_topic_name`**: The SNS topic name.
  - **`KKE_cloudwatch_alarm_name`**: The CloudWatch alarm name.
- The Terraform working directory is **`/home/bob/terraform`**.

👉 **Your task:** Define `aws_sns_topic` and `aws_cloudwatch_metric_alarm` in `main.tf`, ensure alarm actions are configured with the topic ARN, and export the resource names in `outputs.tf`.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud  
**Provider:** AWS (Amazon Web Services)  
**Configuration Files & Structure:**

- **`main.tf`**:
  - `aws_sns_topic.devops_sns`: Creates the SNS topic named `devops-sns-topic`.
  - `aws_cloudwatch_metric_alarm.devops_cpu_alarm`: Creates the metric alarm named `devops-cpu-alarm` monitoring EC2 `CPUUtilization` with `threshold = 80`, `period = 300`, `evaluation_periods = 1`, `actions_enabled = true`, and `alarm_actions = [aws_sns_topic.devops_sns.arn]`.
- **`outputs.tf`**:
  - `KKE_sns_topic_name`: Exposes `aws_sns_topic.devops_sns.name`.
  - `KKE_cloudwatch_alarm_name`: Exposes `aws_cloudwatch_metric_alarm.devops_cpu_alarm.alarm_name`.

**Working Directory:** `/home/bob/terraform`

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**

   ```bash
   cd /home/bob/terraform
   ```

2. **Configure SNS Topic and CloudWatch Alarm in `main.tf`:**

   Define the SNS topic and the metric alarm triggering alert actions on the topic:

   ```hcl
   resource "aws_sns_topic" "devops_sns" {
     name = "devops-sns-topic"
   }

   resource "aws_cloudwatch_metric_alarm" "devops_cpu_alarm" {
     alarm_name          = "devops-cpu-alarm"
     comparison_operator = "GreaterThanOrEqualToThreshold"
     evaluation_periods  = 1
     metric_name         = "CPUUtilization"
     namespace           = "AWS/EC2"
     period              = 300
     statistic           = "Average"
     threshold           = 80
     actions_enabled     = true
     alarm_actions       = [aws_sns_topic.devops_sns.arn]
   }
   ```

3. **Define Outputs in `outputs.tf`:**

   Configure outputs to expose the SNS topic and CloudWatch alarm names:

   ```hcl
   output "KKE_sns_topic_name" {
     value       = aws_sns_topic.devops_sns.name
     description = "The name of the SNS topic"
   }

   output "KKE_cloudwatch_alarm_name" {
     value       = aws_cloudwatch_metric_alarm.devops_cpu_alarm.alarm_name
     description = "The name of the CloudWatch alarm"
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

   Provision the SNS topic and CloudWatch alarm:

   ```bash
   terraform apply -auto-approve
   ```

7. **Verify Outputs & Resources:**

   Check the Terraform output values:

   ```bash
   terraform output
   ```

   Verify the SNS topic via AWS CLI:

   ```bash
   aws sns get-topic-attributes \
     --topic-arn $(aws sns list-topics --query "Topics[?contains(TopicArn, 'devops-sns-topic')].TopicArn | [0]" --output text)
   ```

   Verify the CloudWatch metric alarm configuration and actions:

   ```bash
   aws cloudwatch describe-alarms \
     --alarm-names devops-cpu-alarm \
     --query "MetricAlarms[*].[AlarmName,MetricName,Namespace,Threshold,ComparisonOperator,ActionsEnabled,AlarmActions,StateValue]" \
     --output table
   ```
