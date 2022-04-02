require "../../spec_helper"

Spectator.describe Spectator::ValueStub do
  let(method_call) { Spectator::MethodCall.capture(:foo) }
  let(location) { Spectator::Location.new(__FILE__, __LINE__) }
  subject(stub) { described_class.new(:foo, 42, location: location) }

  it "stores the method name" do
    expect(stub.method).to eq(:foo)
  end

  it "stores the location" do
    expect(stub.location).to eq(location)
  end

  it "stores the return value" do
    expect(stub.call(method_call)).to eq(42)
  end

  describe "#===" do
    subject { stub === call }

    context "with a matching method name" do
      let(call) { Spectator::MethodCall.capture(:foo, "foobar") }

      it "returns true" do
        is_expected.to be_true
      end
    end

    context "with a different method name" do
      let(call) { Spectator::MethodCall.capture(:bar, "foobar") }

      it "returns false" do
        is_expected.to be_false
      end
    end

    context "with a constraint" do
      let(constraint) { Spectator::Arguments.capture(/foo/) }
      let(stub) { Spectator::ValueStub.new(:foo, 42, constraint) }

      context "with a matching method name" do
        let(call) { Spectator::MethodCall.capture(:foo, "foobar") }

        it "returns true" do
          is_expected.to be_true
        end

        context "with a non-matching arguments" do
          let(call) { Spectator::MethodCall.capture(:foo, "baz") }

          it "returns false" do
            is_expected.to be_false
          end
        end
      end

      context "with a different method name" do
        let(call) { Spectator::MethodCall.capture(:bar, "foobar") }

        it "returns false" do
          is_expected.to be_false
        end
      end
    end
  end
end
