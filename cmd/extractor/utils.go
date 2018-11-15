package main

import "regexp"

var skipPaths = []*regexp.Regexp{
	regexp.MustCompile(`.*\.generation$`),
	regexp.MustCompile(`.*\.creation_timestamp$`),
	regexp.MustCompile(`.*\.deletion_timestamp$`),
	regexp.MustCompile(`.*\.owner_references$`),
	regexp.MustCompile(`.*\.paused$`),
	regexp.MustCompile(`.*\.resource_version$`),
	regexp.MustCompile(`.*\.result$`),
	regexp.MustCompile(`.*\.revision_history_limit$`),
	regexp.MustCompile(`.*\.self_link$`),
	regexp.MustCompile(`.*\.template_generation$`),
	regexp.MustCompile(`.*\.uid$`),
	regexp.MustCompile(`.*\.metadata\.finalizers$`),
	regexp.MustCompile(`.*\.spec\.finalizers$`),
	regexp.MustCompile(`.*\.spec\.claim_ref$`),
	regexp.MustCompile(`.*\.secrets$`),
	regexp.MustCompile(`.*_job\..*labels\.controller-uid$`),
	regexp.MustCompile(`.*_job\..*labels\.job-name$`),
}

// path format <resource key>.<object path> e.g. k8s_core_v1_service.metadata.name
func IsSkipPrintPath(path string) bool {
	for _, pattern := range skipPaths {
		//log.Println("isSkipPath:", path)
		if pattern.MatchString(path) {
			//log.Println("SkipPath:", path)
			return true
		}
	}
	return false
}
