Spectator
=========

Spectator is a fully-featured spec-based test framework for Crystal.
It provides more functionality from [RSpec](http://rspec.info/)
than the built-in Crystal [Spec](https://crystal-lang.org/api/latest/Spec.html) utility.
Additionally, Spectator provides extra features to make testing easier and more fluent.

**Goal:**

Spectator is designed to:

- Reduce complexity of test code.
- Remove boilerplate from tests.
- Lower the difficulty of writing non-trivial tests.
- Provide an elegant syntax that is easy to read and understand.
- Provide common utilities that the end-user would otherwise need to write.

Installation
------------

Add this to your application's `shard.yml`:

```yaml
development_dependencies:
  spectator:
    gitlab: arctic-fox/spectator
```

Usage
-----

If it doesn't exist already, create a `spec/spec_helper.cr` file.
In it, place the following:

```crystal
require "spectator"
require "../src/*"
```

This will include Spectator and the source code for your shard.
Now you can start writing your specs.
The syntax is the same as what you would expect from modern RSpec.
The "expect" syntax is recommended and the default, however the "should" syntax is also available.
Your specs must be wrapped in a `Spectator.describe` block.
All other blocks inside the top-level block may use `describe` and `context` without the `Spectator.` prefix.

Here's a minimal spec to demonstrate:

```crystal
require "./spec_helper"

Spectator.describe String do
  subject { "foo" }

  describe "#==" do
    context "with the same value" do
      let(value) { subject.dup }

      it "is true" do
        is_expected.to eq(value)
      end
    end

    context "with a different value" do
      let(value) { "bar" }

      it "is false" do
        is_expected.to_not eq(value)
      end
    end
  end
end
```

If you find yourself trying to shoehorn in functionality
or unsure how to write a test, please create an [issue](https://gitlab.com/arctic-fox/spectator/issues/new) for it.
The goal is to make it as easy as possible to write specs and keep your code clean.
We may come up with a solution or even introduce a feature to support your needs.

NOTE: Due to the way this shard uses macros,
you may find that some code you would expect to work, or works in other spec libraries, creates syntax errors.
If you run into this, please create an issue so that we may try to resolve it.

Features
--------

Spectator has all of the basic functionality for BDD.

### Contexts

The DSL supports arbitrarily nested contexts.
Contexts can have values defined for multiple tests (`let` and `subject`).
Additionally, hooks can be used to ensure any initialization or cleanup is done (`before`, `after`, and `around`).
Pre- and post-conditions can be used to ensure code contracts are kept.

Spectator has different types of contexts to reduce boilerplate.
One is the `sample` context.
This context type repeats all tests (and contexts within) for a set of values.
For instance, some feature should behave the same for different input.
However, some inputs might cause problems, but should behave the same.
An example is various strings (empty strings, quoted strings, strings with non-ASCII, etc),
and numbers (positive, negative, zero, NaN, infinity).

Another context type is `given`.
This context drastically reduces the amount of code needed in some scenarios.
It can be used where one (or more inputs) changes the output of multiple methods.
The `given` context gives a concise syntax for this use case.

### Assertions

Spectator supports two formats for assertions (expectations).
The preferred format is the "expect syntax".
This takes the form:

```crystal
expect(THIS).to eq(THAT)
```

The other format, "should syntax" is used by Crystal's default Spec.

```
THIS.should eq(THAT)
```

The first format doesn't monkey-patch the `Object` type.
And as a bonus, it captures the expression or variable passed to `expect()`.
For instance, compare these two tests:

```crystal
foo = "Hello world"
foo.size.should eq(12) # Wrong on purpose!
```

Produces this error output:

```text
Failure: 11 does not equal 12

  expected: 11
    actual: 12
```

Which is reasonable, but where did 11 come from?
Alternatively, with the "expect syntax":

```crystal
foo = "Hello world"
expect(foo.size).to eq(12) # Wrong on purpose!
```

Produces this error output:

```text
Failure: foo.size does not equal 12

  expected: 12
    actual: 11
```

This makes it clearer what was being tested and failed.

### Matchers

Spectator has a variety of matchers for assertions.
These are named in such a way to help tests read as plain English.
Matchers can be used on any value or block.

There are typical matchers for testing equality: `eq` and `ne`.
And matchers for comparison: `<`, `<=`, `>`, `>=`, `be_within`.
There are matchers for checking contents of collections:
`contain`, `have`, `start_with`, `end_with`, `be_empty`, `have_key`, and more.
See the full documentation for a full list of matchers.

### Running

Spectator supports multiple options for running tests.
"Fail fast" aborts on the first test failure.
"Fail blank" fails if there are no tests.
Tests can be filtered by their location and name.
Additionally, tests can be randomized.
Spectator can be configured with command-line arguments, a config block in a `spec_helper.cr` file, and `.spectator` config file.

### Output

Spectator matches Crystal's default Spec output with some minor changes.
JUnit and TAP are also supported output formats.
There is also a highly detailed JSON output.

Development
-----------

This shard is still under development and is not recommended for production use (same as Crystal).
However, feel free to play around with it and use it for non-critical projects.

### Feature Progress

In no particular order, features that have been implemented and are planned.
Items not marked as completed may have partial implementations.

- [ ] DSL
    - [X] `describe` and `context` blocks
    - [X] Contextual values with `let`, `let!`, `subject`, `described_class`
    - [X] Test multiple and generated values - `sample`, `random_sample`
    - [X] Concise syntax - `given`
    - [X] Before and after hooks - `before_each`, `before_all`, `after_each`, `after_all`, `around_each`
    - [X] Pre- and post-conditions - `pre_condition`, `post_condition`
    - [ ] Other hooks - `on_success`, `on_failure`, `on_error`
    - [X] One-liner syntax
    - [X] Should syntax - `should`, `should_not`
    - [X] Helper methods and modules
    - [ ] Aliasing - custom example group types with preset attributes
    - [X] Pending tests - `pending`
    - [ ] Shared examples - `behaves_like`, `include_examples`
- [ ] Matchers
    - [X] Equality matchers - `eq`, `ne`, `be ==`, `be !=`
    - [X] Comparison matchers - `be <`, `be <=`, `be >`, `be >=`, `be_within[.of]`, `be_close`
    - [X] Type matchers - `be_a`
    - [ ] Collection matchers - `contain`, `have`, `contain_exactly[.in_order|.in_any_order]`, `match_array[.in_order|.in_any_order]`, `start_with`, `end_with`, `be_empty`, `have_key`, `have_value`, `all`, `all_satisfy`
    - [X] Truthy matchers - `be`, `be_true`, `be_truthy`, `be_false`, `be_falsey`, `be_nil`
    - [X] Error matchers - `raise_error`
    - [ ] Yield matchers - `yield_control[.times]`, `yield_with_args[.times]`, `yield_with_no_args[.times]`, `yield_successive_args`
    - [ ] Output matchers - `output[.to_stdout|.to_stderr]`
    - [ ] Misc. matchers - `exist`, `match`, `satisfy`, `change[.by|.from[.to]|.to|.by_at_least|.by_at_most]`, `have_attributes`
    - [ ] Expectation combining - `and`, `or`
- [ ] Runner
    - [X] Fail fast
    - [ ] Test filtering - by name, context, and tags
    - [X] Fail on no tests
    - [X] Randomize test order
    - [X] Dry run - for validation and checking formatted output
    - [X] Config block in `spec_helper.cr`
    - [X] Config file - `.spectator`
- [X] Reporter and formatting
    - [X] RSpec/Crystal Spec default
    - [X] JSON
    - [X] JUnit
    - [X] TAP

### How it Works (in a nutshell)

This shard makes extensive use of the Crystal macro system to build classes and modules.
Each `describe` and `context` block creates a new module nested in its parent.
The `it` block creates an example class.
An instance of the example class is created to run the test.
Each example class includes a context module, which contains all test values and hooks.

Contributing
------------

1. Fork it (<https://gitlab.com/arctic-fox/spectator/fork/new>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Merge Request

Please make sure to run `crystal tool format` before submitting.
The CI build checks for properly formatted code.

Tests must be written for any new functionality.
Macros that create types are not as easy to test,
so they are exempt for the current time.
However, please test all code locally with an example spec file.

Contributors
------------

- [arctic-fox](https://gitlab.com/arctic-fox) Michael Miller - creator, maintainer
