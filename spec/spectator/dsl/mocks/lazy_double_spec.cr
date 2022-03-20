require "../../../spec_helper"

Spectator.describe "Lazy double DSL" do
  context "specifying methods as keyword args" do
    subject(dbl) { double(:test, foo: "foobar", bar: 42) }

    it "defines a double with methods" do
      aggregate_failures do
        expect(dbl.foo).to eq("foobar")
        expect(dbl.bar).to eq(42)
      end
    end

    context "with an unexpected message" do
      it "raises an error" do
        expect { dbl.baz }.to raise_error(Spectator::UnexpectedMessage, /baz/)
      end

      it "reports the double name" do
        expect { dbl.baz }.to raise_error(Spectator::UnexpectedMessage, /:test/)
      end

      it "reports the arguments" do
        expect { dbl.baz(:xyz, 123, a: "XYZ") }.to raise_error(Spectator::UnexpectedMessage, /\(:xyz, 123, a: "XYZ"\)/)
      end
    end

    context "blocks" do
      it "supports blocks" do
        aggregate_failures do
          expect(dbl.foo { nil }).to eq("foobar")
          expect(dbl.bar { nil }).to eq(42)
        end
      end

      it "fails on undefined messages" do
        expect do
          dbl.baz { nil }
        end.to raise_error(Spectator::UnexpectedMessage, /baz/)
      end
    end
  end

  describe "double naming" do
    it "accepts a symbolic double name" do
      dbl = double(:name)
      expect { dbl.oops }.to raise_error(Spectator::UnexpectedMessage, /:name/)
    end

    it "accepts a string double name" do
      dbl = double("Name")
      expect { dbl.oops }.to raise_error(Spectator::UnexpectedMessage, /"Name"/)
    end

    it "accepts no name" do
      dbl = double
      expect { dbl.oops }.to raise_error(Spectator::UnexpectedMessage, /anonymous/i)
    end
  end
end
