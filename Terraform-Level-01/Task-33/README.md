# Delete VPC While Keeping Terraform Code

## 📌 Task Description

The **Nautilus DevOps team** is strategically planning the migration of a portion of their infrastructure to the AWS cloud. Acknowledging the magnitude of this endeavor, they have chosen to tackle the migration incrementally rather than as a single, massive transition. They created some services in different regions and later found that some of those can be deleted now.

**Requirements:**
- Delete a VPC named **`nautilus-vpc`** present in the **`us-east-1`** region using Terraform.
- Make sure to keep the provisioning code, as we might need to provision this VPC again later.

👉 **Your task:** Delete the VPC via Terraform without removing its resource block, so it can be re-provisioned later.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud
**Provider:** AWS (Amazon Web Services)
**Region:** `us-east-1`
**Resources:**
- AWS VPC (`nautilus-vpc`) — to be deleted, code retained in `main.tf`

**Working Directory:** `/home/bob/terraform`

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**
   ```bash
   cd /home/bob/terraform
   ```

2. **Keep the Configuration File As-Is:**
   The `aws_vpc` resource block stays untouched so it can be reused later:
   ```hcl
   resource "aws_vpc" "this" {
     cidr_block = "10.0.0.0/16"

     tags = {
       Name = "nautilus-vpc"
     }
   }
   ```

3. **Initialize Terraform:**
   ```bash
   terraform init
   ```

4. **Destroy Only the VPC:**
   Use a targeted destroy so only this resource is removed, leaving the code in place for later reuse.
   ```bash
   terraform destroy -target=aws_vpc.this -auto-approve
   ```

5. **Verify the VPC is Deleted:**
   ```bash
   aws ec2 describe-vpcs \
     --region us-east-1 \
     --filters "Name=tag:Name,Values=nautilus-vpc" \
     --query "Vpcs[*].[VpcId,State]" \
     --output table
   ```
   This should return an empty result, confirming the VPC no longer exists.
</content>
