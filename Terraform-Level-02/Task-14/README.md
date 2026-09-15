# Provision IAM User with local-exec Provisioner Using Terraform

## 📌 Task Description

The **Nautilus DevOps team** is experimenting with Terraform provisioners to automate post-provisioning tasks. The objective is to create an IAM user and invoke a `local-exec` provisioner to log a confirmation message to a log file on the local system upon successful creation.

**Requirements:**

- Create an IAM user named **`iamuser_anita`**.
- Use a **`local-exec`** provisioner within the IAM user resource to log the exact message:
  ```text
  KKE iamuser_anita has been created successfully!
  ```
  to a file named **`KKE_user_created.log`** under **`/home/bob/terraform`**.
- Create the **`main.tf`** file (do not create a separate `.tf` file) to provision the IAM user and execute the provisioner.
- Use the **`variables.tf`** file with the variable:
  - **`KKE_USER_NAME`**: Name of the IAM user.
- Use the **`terraform.tfvars`** file to supply the IAM user name.
- Use the **`outputs.tf`** file to output:
  - **`kke_iam_user_name`**: Name of the created IAM user.
- The Terraform working directory is **`/home/bob/terraform`**.

👉 **Your task:** Declare `KKE_USER_NAME` in `variables.tf`, assign its value in `terraform.tfvars`, configure `aws_iam_user` with a `local-exec` provisioner in `main.tf`, and export `kke_iam_user_name` in `outputs.tf`.

---

## 🔧 Infrastructure Overview

**Target Environment:** AWS Cloud  
**Provider:** AWS (Amazon Web Services)  
**Configuration Files & Structure:**

- **`variables.tf`**:
  - `KKE_USER_NAME` (string): Variable storing the IAM username.
- **`terraform.tfvars`**:
  - Sets `KKE_USER_NAME = "iamuser_anita"`.
- **`main.tf`**:
  - `aws_iam_user.anita`: Provisions the IAM user with `name = var.KKE_USER_NAME` and contains a `local-exec` provisioner that writes the confirmation message to `/home/bob/terraform/KKE_user_created.log`.
- **`outputs.tf`**:
  - `kke_iam_user_name`: Exposes `aws_iam_user.anita.name`.

**Working Directory:** `/home/bob/terraform`

---

## 💡 Background: `local-exec` Provisioners in Terraform

A **`local-exec`** provisioner invokes a local executable or shell command on the machine running Terraform (not on the remote resource):

- By default, provisioners run when a resource is created.
- If a provisioner fails, Terraform marks the resource as tainted (or flags an error).
- Here, `local-exec` writes an audit confirmation entry into a local log file right after the IAM user is created in AWS.

---

## 🚀 Implementation Steps

To execute this task on the target system, follow these steps:

1. **Navigate to the Working Directory:**

   ```bash
   cd /home/bob/terraform
   ```

2. **Define Variables in `variables.tf`:**

   Declare the IAM username variable:

   ```hcl
   variable "KKE_USER_NAME" {
     type        = string
     description = "The name of the IAM user"
   }
   ```

3. **Assign Variable Values in `terraform.tfvars`:**

   Assign the required IAM user name:

   ```hcl
   KKE_USER_NAME = "iamuser_anita"
   ```

4. **Configure IAM User and `local-exec` Provisioner in `main.tf`:**

   Define the IAM user resource and the `local-exec` provisioner to write to `/home/bob/terraform/KKE_user_created.log`:

   ```hcl
   resource "aws_iam_user" "anita" {
     name = var.KKE_USER_NAME

     provisioner "local-exec" {
       command = "mkdir -p /home/bob/terraform && echo 'KKE ${var.KKE_USER_NAME} has been created successfully!' > /home/bob/terraform/KKE_user_created.log"
     }
   }
   ```

5. **Define Outputs in `outputs.tf`:**

   Configure outputs to expose the created IAM user name:

   ```hcl
   output "kke_iam_user_name" {
     value       = aws_iam_user.anita.name
     description = "The name of the IAM user"
   }
   ```

6. **Initialize Terraform:**

   Initialize the working directory to download the AWS provider plugins:

   ```bash
   terraform init
   ```

7. **Validate Configuration & Review Execution Plan:**

   Validate syntax and inspect the planned resources:

   ```bash
   terraform validate
   terraform plan
   ```

8. **Apply the Configuration:**

   Provision the IAM user and trigger the `local-exec` provisioner:

   ```bash
   terraform apply -auto-approve
   ```

9. **Verify Outputs & Resources:**

   Check the Terraform output values:

   ```bash
   terraform output
   ```

   Verify the IAM user via AWS CLI:

   ```bash
   aws iam get-user --user-name iamuser_anita
   ```

   Verify that the log file was created and contains the expected message:

   ```bash
   cat /home/bob/terraform/KKE_user_created.log
   ```

   _Expected Output:_

   ```text
   KKE iamuser_anita has been created successfully!
   ```
