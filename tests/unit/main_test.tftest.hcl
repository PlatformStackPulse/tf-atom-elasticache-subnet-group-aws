# Unit Tests for tf-atom-elasticache-subnet-group-aws
#
# These tests use a mock provider — no real AWS calls are made.
# Run with:  terraform test -test-directory=tests/unit
# Verbose:   terraform test -test-directory=tests/unit -verbose

mock_provider "aws" {}

variables {
  # tf-label context (required for a deterministic, plan-known id)
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  # module's own required inputs
  subnet_ids = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
}

# ---------------------------------------------------------------------------
# Test: module creates the subnet group when enabled
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = aws_elasticache_subnet_group.this[0].name == "eg-test-thing"
    error_message = "Subnet group name should equal the tf-label id 'eg-test-thing'."
  }

  assert {
    condition     = length(aws_elasticache_subnet_group.this) == 1
    error_message = "Exactly one subnet group should be planned when enabled."
  }

  assert {
    condition     = aws_elasticache_subnet_group.this[0].subnet_ids == toset(["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"])
    error_message = "subnet_ids should be passed through unchanged."
  }
}

# ---------------------------------------------------------------------------
# Test: default description is derived from the tf-label id
# ---------------------------------------------------------------------------
run "default_description_derived_from_id" {
  command = plan

  assert {
    condition     = aws_elasticache_subnet_group.this[0].description == "ElastiCache subnet group for eg-test-thing"
    error_message = "Default description should be derived from the tf-label id."
  }
}

# ---------------------------------------------------------------------------
# Test: nothing is created when disabled
# ---------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = length(aws_elasticache_subnet_group.this) == 0
    error_message = "No subnet group should be planned when enabled = false."
  }

  assert {
    condition     = output.id == null
    error_message = "The id output should be null when the module is disabled."
  }

  assert {
    condition     = output.name == null
    error_message = "The name output should be null when the module is disabled."
  }
}
