package test

import (
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func Test(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	gitlabURL := terraform.Output(t, terraformOptions, "gitlab_url")
	maxRetries := 50
	timeBetweenRetries := 5 * time.Second

	http_helper.HttpGetWithRetryWithCustomValidation(t, gitlabURL, maxRetries, timeBetweenRetries, validate)
}

func validate(status int, _ string) bool {
	return status == 200
}
