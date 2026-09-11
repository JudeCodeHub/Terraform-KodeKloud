# Recreate EC2 Instance Using Terraform Replace Option

## 📌 Task Description

To test resilience and recreation behavior in Terraform, the **DevOps team** needs to demonstrate the use of the `-replace` option to forcefully recreate an EC2 instance without changing its configuration.

**Requirements:**
- Use the Terraform CLI **`-replace`** option to destroy and recreate the EC2 instance **`devops-ec2`**, even though the configuration remains unchanged.
- Ensure that the instance is recreated successfully.
- The Terraform working directory is **`/home/bob/terraform`**.

👉 **Your task:** Execute a targeted replacement of the `aws_instance.devops_ec2` resource using `terraform apply -replace="aws_instance.devops_ec2"`.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud  
**Provider:** AWS (Amazon Web Services)  
**Resources:**
- AWS EC2 Instance (`devops-ec2` / `aws_instance.devops_ec2`) — pre-existing, targeted for replacement

**Working Directory:** `/home/bob/terraform`

---

## 💡 Background: `-replace` vs Legacy `taint`

Starting in Terraform **v0.15.2+**, the `-replace` flag is the recommended and safer alternative to the legacy `terraform taint` command:
- `terraform taint` directly modified the state file, marking the resource as degraded immediately.
- `-replace="resource_address"` allows planning and applying the replacement within a single step (`terraform plan -replace=...` or `terraform apply -replace=...`), making it safer and non-destructive to state until applied.

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**
   ```bash
   cd /home/bob/terraform
   ```

2. **Initialize Terraform (if required):**
   Ensure provider plugins are initialized in the working directory:
   ```bash
   terraform init
   ```

3. **(Optional) Preview the Replacement Plan:**
   Run `terraform plan` with the `-replace` flag to verify that Terraform will destroy and recreate the instance (indicated by `-/+`):
   ```bash
   terraform plan -replace="aws_instance.devops_ec2"
   ```

4. **Apply the Replacement:**
   Execute `terraform apply` with the `-replace` option targeting the EC2 instance resource:
   ```bash
   terraform apply -replace="aws_instance.devops_ec2" -auto-approve
   ```

5. **Verify the Recreated Instance:**
   Confirm the replacement in Terraform state:
   ```bash
   terraform state show aws_instance.devops_ec2
   ```

   Or verify the running EC2 instance via the AWS CLI:
   ```bash
   aws ec2 describe-instances \
     --filters "Name=tag:Name,Values=devops-ec2" "Name=instance-state-name,Values=running" \
     --query "Reservations[].Instances[*].[InstanceId,InstanceType,State.Name,LaunchTime]" \
     --output table
   ```

