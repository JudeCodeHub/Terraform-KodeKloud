# Provision Amazon Kinesis Stream and CloudWatch Alarm Using Terraform

## 📌 Task Description

The **monitoring team** wants to improve observability into the streaming infrastructure. Your task is to implement a solution using Amazon Kinesis and Amazon CloudWatch. The team wants to ensure that if write throughput exceeds provisioned limits, an alert is triggered immediately.

As a member of the **Nautilus DevOps Team**, perform the following tasks using Terraform:

**Requirements:**

- Create a Kinesis Data Stream named **`xfusion-kinesis-stream`** with a shard count of **`1`**.
- Enable shard-level metrics for the stream to track ingestion and throughput errors.
- Create a CloudWatch Alarm named **`xfusion-kinesis-alarm`** to monitor the **`WriteProvisionedThroughputExceeded`** metric. The alarm should trigger if the metric exceeds a threshold of **`1`**.
- Configure the CloudWatch alarm to detect write throughput issues exceeding provisioned limits.
- Create the **`main.tf`** file (do not create a separate `.tf` file) to provision the Kinesis stream, CloudWatch alarm, and ensure alerting.
- Create the **`outputs.tf`** file with the following variable names to output:
  - **`kke_kinesis_stream_name`**: Name of the Kinesis Data Stream.
  - **`kke_kinesis_alarm_name`**: Name of the CloudWatch alarm.
- The Terraform working directory is **`/home/bob/terraform`**.

👉 **Your task:** Define `aws_kinesis_stream` with shard-level metrics enabled and configure `aws_cloudwatch_metric_alarm` for write throughput monitoring in `main.tf`, then expose their names in `outputs.tf`.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud  
**Provider:** AWS (Amazon Web Services)  
**Configuration Files & Structure:**

- **`main.tf`**:
  - `aws_kinesis_stream.xfusion_stream`: Creates a Kinesis stream named `xfusion-kinesis-stream` with `shard_count = 1` and comprehensive `shard_level_metrics` enabled (`IncomingBytes`, `IncomingRecords`, `OutgoingBytes`, `OutgoingRecords`, `WriteProvisionedThroughputExceeded`, `ReadProvisionedThroughputExceeded`, `IteratorAgeMilliseconds`).
  - `aws_cloudwatch_metric_alarm.xfusion_kinesis_alarm`: Creates a CloudWatch alarm `xfusion-kinesis-alarm` monitoring `AWS/Kinesis` metric `WriteProvisionedThroughputExceeded` for dimension `StreamName = xfusion-kinesis-stream`, evaluated over a 60-second period with `comparison_operator = "GreaterThanThreshold"` and `threshold = 1`.
- **`outputs.tf`**:
  - `kke_kinesis_stream_name`: Exports `aws_kinesis_stream.xfusion_stream.name`.
  - `kke_kinesis_alarm_name`: Exports `aws_cloudwatch_metric_alarm.xfusion_kinesis_alarm.alarm_name`.

**Working Directory:** `/home/bob/terraform`

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**

   ```bash
   cd /home/bob/terraform
   ```

2. **Configure Kinesis Stream and CloudWatch Alarm in `main.tf`:**

   Define the Kinesis data stream with shard-level metrics and the associated CloudWatch metric alarm:

   ```hcl
   resource "aws_kinesis_stream" "xfusion_stream" {
     name        = "xfusion-kinesis-stream"
     shard_count = 1

     shard_level_metrics = [
       "IncomingBytes",
       "IncomingRecords",
       "OutgoingBytes",
       "OutgoingRecords",
       "WriteProvisionedThroughputExceeded",
       "ReadProvisionedThroughputExceeded",
       "IteratorAgeMilliseconds"
     ]
   }

   resource "aws_cloudwatch_metric_alarm" "xfusion_kinesis_alarm" {
     alarm_name          = "xfusion-kinesis-alarm"
     alarm_description   = "Alerts when Kinesis write throughput exceeds provisioned capacity."
     namespace           = "AWS/Kinesis"
     metric_name         = "WriteProvisionedThroughputExceeded"
     dimensions = {
       StreamName = aws_kinesis_stream.xfusion_stream.name
     }

     statistic           = "Sum"
     period              = 60
     evaluation_periods  = 1
     threshold           = 1
     comparison_operator = "GreaterThanThreshold"

     treat_missing_data = "notBreaching"
   }
   ```

3. **Define Outputs in `outputs.tf`:**

   Create `outputs.tf` to export the stream and alarm names:

   ```hcl
   output "kke_kinesis_stream_name" {
     description = "Name of the Kinesis Data Stream"
     value       = aws_kinesis_stream.xfusion_stream.name
   }

   output "kke_kinesis_alarm_name" {
     description = "Name of the CloudWatch alarm"
     value       = aws_cloudwatch_metric_alarm.xfusion_kinesis_alarm.alarm_name
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

   Provision the Kinesis stream and CloudWatch alarm:

   ```bash
   terraform apply -auto-approve
   ```

7. **Verify Outputs & Resources:**

   Check the Terraform output values:

   ```bash
   terraform output
   ```

   Verify the Kinesis stream and enhanced shard metrics via AWS CLI:

   ```bash
   aws kinesis describe-stream \
     --stream-name xfusion-kinesis-stream \
     --query "StreamDescription.[StreamName,StreamStatus,Shards[0].ShardId,EnhancedMonitoring[0].ShardLevelMetrics]" \
     --output json
   ```

   Verify the CloudWatch metric alarm configuration:

   ```bash
   aws cloudwatch describe-alarms \
     --alarm-names xfusion-kinesis-alarm \
     --query "MetricAlarms[*].[AlarmName,MetricName,Namespace,Threshold,ComparisonOperator,StateValue]" \
     --output table
   ```

