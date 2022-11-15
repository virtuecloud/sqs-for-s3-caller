# Terraform Reusable workflow

This a Reusable workflow designed to carry out differnt command for terraform. In this workflow we have automated commands like 'init', 'plan', 'apply' etc. to simplify the creation and deletion of infrastucture and its resources. It is designed in a chronological order i.e. init->plan->apply or init->plan-delete.

The way this workflow works is as following:

1. First the workflow sets up the version terraform installed on the runner.
1. Then by `actions/checkout@v3` action it clones the repository from source to the runner.
1. Then by configuring the aws credentials by `aws-actions/configure-aws-credentials` action it proceeds to terraform init action.
1. After these steps are completed workflow moves to the terraform composite actions in order of Init->Plan->'user input action'.
1. The `Apply` action provisions the infrastructure from the code provided in the 2 step.
1. The `Plan-destroy` action will display the resources that will be destroyed by the `destroy` command.

## inputs

```yaml

inputs:
      INFRASTRUCTURE_TO_BUILD:
        type: string
        required: true
      ENVIRONMENT_NAME:
        type: string
        required: true
      TERRAFORM_COMMAND:
        type:string
        required: true

```

## secrets

```yaml

secrets:
  AWS_ACCESS_KEY:
    required: true
  AWS_SECRET_ACCESS_KEY:
    required: true

```

## Usage

```yaml
steps: 
      - name: Terraform Setup
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.3.0
      - name: Checkout
        uses: actions/checkout@v3
      - name: Configure AWS Creds
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY}}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      - name: Init
        uses: sparshbaurasi/github-shared-cp/TerraformInit@main
        with:
             DIRECTORY: ${{github.event.inputs.DIRECTORY_NAME}}
             ENVIRONMENT: ${{github.event.inputs.ENVIRONMENT_NAME}}
      - name: Plan
        if: ${{ github.event.inputs.TERRAFORM_COMMAND == 'Plan' }}
        uses: sparshbaurasi/github-shared-cp/TerraformPlan@main
        with:
             DIRECTORY: ${{github.event.inputs.DIRECTORY_NAME}}
      - name : Approval
        if: ${{ github.event.inputs.TERRAFORM_COMMAND == 'Apply' || github.event.inputs.TERRAFORM_COMMAND == 'Destroy' }}
        uses: sparshbaurasi/man-approv@main
        with:
            secret: ${{ github.TOKEN }}
            approvers: sparshbaurasi
            minimum-approvals: 1
            issue-title: "Approval for ${{ inputs.TERRAFORM_COMMAND }}"
      - name: Apply
        if: ${{ github.event.inputs.TERRAFORM_COMMAND == 'Apply'}}
        uses: sparshbaurasi/github-shared-cp/TerraformApply@main
        with:
             DIRECTORY: ${{github.event.inputs.DIRECTORY_NAME}}
      - name: Plan-destroy
        if: ${{ github.event.inputs.TERRAFORM_COMMAND == 'Plan-Destroy' || github.event.inputs.TERRAFORM_COMMAND == 'Destroy' }}
        uses: sparshbaurasi/github-shared-cp/TerraformPlanDestroy@main
        with:
             DIRECTORY: ${{github.event.inputs.DIRECTORY_NAME}}
      - name: Destroy
        if: ${{ github.event.inputs.TERRAFORM_COMMAND == 'Destroy' }}
        uses: sparshbaurasi/github-shared-cp/TerraformDestroy@main
        with:
             DIRECTORY: ${{github.event.inputs.DIRECTORY_NAME}}        
```

## Limitations

