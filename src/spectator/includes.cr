# This file includes all source files *except* `should.cr`.
# The `should.cr` file contains the optional feature for using should-syntax.
# Since this is disabled by default, we don't include all files.
# Including all files with a wildcard would accidentally enable should-syntax.
# Unfortunately, that leads to the existence of this file to include everything but that file.

require "./abstract_expression"
require "./anything"
require "./block"
require "./composite_example_filter"
require "./config"
require "./context"
require "./context_delegate"
require "./context_method"
require "./dsl"
require "./error_result"
require "./events"
require "./example_context_delegate"
require "./example_context_method"
require "./example"
require "./example_filter"
require "./example_group"
require "./example_group_hook"
require "./example_hook"
require "./example_iterator"
require "./example_procsy_hook"
require "./expectation"
require "./expectation_failed"
require "./expression"
require "./fail_result"
require "./formatting"
require "./harness"
require "./label"
require "./lazy"
require "./lazy_wrapper"
require "./line_example_filter"
require "./location"
require "./location_example_filter"
require "./matchers"
require "./metadata"
require "./mocks"
require "./name_example_filter"
require "./null_context"
require "./null_example_filter"
require "./pass_result"
require "./pending_result"
require "./profile"
require "./report"
require "./result"
require "./runner_events"
require "./runner"
require "./spec_builder"
require "./spec"
require "./test_context"
require "./value"
require "./wrapper"
