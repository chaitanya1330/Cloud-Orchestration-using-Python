import sys
import subprocess

def apply_terraform():
    try:
        # Run terraform apply command
        subprocess.run(["terraform", "apply", "-auto-approve"], check=True)
        print("Terraform apply completed successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Error: Terraform apply failed - {e}")

def destroy_terraform():
    try:
        # Run terraform destroy command
        subprocess.run(["terraform", "destroy", "-auto-approve"], check=True)
        print("Terraform destroy completed successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Error: Terraform destroy failed - {e}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script.py [apply/destroy]")
        sys.exit(1)

    action = sys.argv[1]

    if action == "apply":
        apply_terraform()
    elif action == "destroy":
        destroy_terraform()
    else:
        print("Invalid action. Please specify either 'apply' or 'destroy'.")
        sys.exit(1)

