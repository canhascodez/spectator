require "../spec_helper"

describe Spectator::Matchers::PredicateMatcher do
  describe "#match" do
    context "returned MatchData" do
      describe "#match?" do
        context "with a true predicate" do
          it "is true" do
            value = "foobar"
            partial = new_partial(value)
            matcher = Spectator::Matchers::PredicateMatcher.new({ascii_only: Tuple.new}, "ascii_only")
            match_data = matcher.match(partial)
            match_data.matched?.should be_true
          end
        end

        context "with a false predicate" do
          it "is false" do
            value = "foobar"
            partial = new_partial(value)
            matcher = Spectator::Matchers::PredicateMatcher.new({empty: Tuple.new}, "empty")
            match_data = matcher.match(partial)
            match_data.matched?.should be_false
          end
        end
      end

      describe "#values" do
        it "contains a key for each expected attribute" do
          value = "foobar"
          partial = new_partial(value)
          matcher = Spectator::Matchers::PredicateMatcher.new({empty: Tuple.new, ascii_only: Tuple.new}, "empty, ascii_only")
          match_data = matcher.match(partial)
          match_data_has_key?(match_data.values, :empty).should be_true
          match_data_has_key?(match_data.values, :ascii_only).should be_true
        end

        it "has the actual values" do
          value = "foobar"
          partial = new_partial(value)
          matcher = Spectator::Matchers::PredicateMatcher.new({empty: Tuple.new, ascii_only: Tuple.new}, "empty, ascii_only")
          match_data = matcher.match(partial)
          match_data_value_sans_prefix(match_data.values, :empty)[:value].should eq(value.empty?)
          match_data_value_sans_prefix(match_data.values, :ascii_only)[:value].should eq(value.ascii_only?)
        end
      end

      describe "#message" do
        it "contains the actual label" do
          value = "foobar"
          label = "blah"
          partial = new_partial(value, label)
          matcher = Spectator::Matchers::PredicateMatcher.new({ascii_only: Tuple.new}, "ascii_only")
          match_data = matcher.match(partial)
          match_data.message.should contain(label)
        end

        it "contains the expected label" do
          value = "foobar"
          label = "blah"
          partial = new_partial(value)
          matcher = Spectator::Matchers::PredicateMatcher.new({ascii_only: Tuple.new}, label)
          match_data = matcher.match(partial)
          match_data.message.should contain(label)
        end
      end

      describe "#negated_message" do
        it "contains the actual label" do
          value = "foobar"
          label = "blah"
          partial = new_partial(value, label)
          matcher = Spectator::Matchers::PredicateMatcher.new({ascii_only: Tuple.new}, "ascii_only")
          match_data = matcher.match(partial)
          match_data.negated_message.should contain(label)
        end

        it "contains the expected label" do
          value = "foobar"
          label = "blah"
          partial = new_partial(value)
          matcher = Spectator::Matchers::PredicateMatcher.new({ascii_only: Tuple.new}, label)
          match_data = matcher.match(partial)
          match_data.negated_message.should contain(label)
        end
      end
    end
  end
end
