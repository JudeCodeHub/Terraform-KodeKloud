# Subscribe Amazon SQS Queue to SNS Topic Using Terraform

## 📌 Task Description

The **Nautilus DevOps team** is implementing a messaging system in AWS to decouple application components. They want to create an Amazon SNS topic and an Amazon SQS queue. The team needs to subscribe the SQS queue to the SNS topic so that messages published to the SNS topic are automatically delivered to the SQS queue for downstream consumption.

**Requirements:**

- Create an SNS topic named **`nautilus-sns-topic`**.
- Create an SQS queue named **`nautilus-sqs-queue`**.
- Subscribe the SQS queue to the SNS topic (`protocol = "sqs"`).
- Configure an SQS queue policy allowing the SNS topic to send messages (`SQS:SendMessage`) to the queue.
- Use the **`main.tf`** file (do not create a separate `.tf` file) to provision the SNS topic, SQS queue, subscription, and queue policy.
- Create the **`outputs.tf`** file with:
  - **`kke_sns_topic_arn`**: The ARN of the SNS topic.
  - **`kke_sqs_queue_url`**: The URL of the SQS queue.
- The Terraform working directory is **`/home/bob/terraform`**.

👉 **Your task:** Define `aws_sns_topic`, `aws_sqs_queue`, `aws_sns_topic_subscription`, and `aws_sqs_queue_policy` in `main.tf`, and export the topic ARN and queue URL in `outputs.tf`.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud  
**Provider:** AWS (Amazon Web Services)  
**Configuration Files & Structure:**

- **`main.tf`**:
  - `aws_sns_topic.nautilus_sns_topic`: Creates SNS topic named `nautilus-sns-topic`.
  - `aws_sqs_queue.nautilus_sqs_queue`: Creates SQS queue named `nautilus-sqs-queue`.
  - `aws_sns_topic_subscription.sns_to_sqs`: Subscribes the SQS queue (`endpoint = aws_sqs_queue.nautilus_sqs_queue.arn`) to the SNS topic (`topic_arn = aws_sns_topic.nautilus_sns_topic.arn`).
  - `aws_sqs_queue_policy.sqs_policy`: Configures access permissions allowing `SQS:SendMessage` when `aws:SourceArn` matches the SNS topic ARN.
- **`outputs.tf`**:
  - `kke_sns_topic_arn`: Exports `aws_sns_topic.nautilus_sns_topic.arn`.
  - `kke_sqs_queue_url`: Exports `aws_sqs_queue.nautilus_sqs_queue.url`.

**Working Directory:** `/home/bob/terraform`

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**

   ```bash
   cd /home/bob/terraform
   ```

2. **Configure SNS, SQS, Subscription, and Policy in `main.tf`:**

   Define the SNS topic, SQS queue, topic subscription, and SQS queue policy:

   ```hcl
   resource "aws_sns_topic" "nautilus_sns_topic" {
     name = "nautilus-sns-topic"
   }

   resource "aws_sqs_queue" "nautilus_sqs_queue" {
     name = "nautilus-sqs-queue"
   }

   resource "aws_sns_topic_subscription" "sns_to_sqs" {
     topic_arn = aws_sns_topic.nautilus_sns_topic.arn
     protocol  = "sqs"
     endpoint  = aws_sqs_queue.nautilus_sqs_queue.arn
   }

   resource "aws_sqs_queue_policy" "sqs_policy" {
     queue_url = aws_sqs_queue.nautilus_sqs_queue.id

     policy = jsonencode({
       Version = "2012-10-17"
       Statement = [
         {
           Sid       = "AllowSNSPublish"
           Effect    = "Allow"
           Principal = "*"
           Action    = "SQS:SendMessage"
           Resource  = aws_sqs_queue.nautilus_sqs_queue.arn
           Condition = {
             ArnEquals = {
               "aws:SourceArn" = aws_sns_topic.nautilus_sns_topic.arn
             }
           }
         }
       ]
     })
   }
   ```

3. **Define Outputs in `outputs.tf`:**

   Create `outputs.tf` to export the topic ARN and queue URL:

   ```hcl
   output "kke_sns_topic_arn" {
     value       = aws_sns_topic.nautilus_sns_topic.arn
     description = "The ARN of the SNS topic"
   }

   output "kke_sqs_queue_url" {
     value       = aws_sqs_queue.nautilus_sqs_queue.url
     description = "The URL of the SQS queue"
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

   Provision the messaging resources:

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
   aws sns get-topic-attributes --topic-arn $(terraform output -raw kke_sns_topic_arn)
   ```

   Verify the SQS queue and its attributes via AWS CLI:

   ```bash
   aws sqs get-queue-attributes \
     --queue-url $(terraform output -raw kke_sqs_queue_url) \
     --attribute-names All \
     --output json
   ```

   Verify the SNS topic subscription:

   ```bash
   aws sns list-subscriptions-by-topic \
     --topic-arn $(terraform output -raw kke_sns_topic_arn) \
     --output table
   ```

8. **(Optional) Test Message Fan-out from SNS to SQS:**

   Publish a test message to the SNS topic:

   ```bash
   aws sns publish \
     --topic-arn $(terraform output -raw kke_sns_topic_arn) \
     --message "Hello from SNS to SQS"
   ```

   Receive and inspect the message from the SQS queue:

   ```bash
   aws sqs receive-message \
     --queue-url $(terraform output -raw kke_sqs_queue_url) \
     --max-number-of-messages 1
   ```
