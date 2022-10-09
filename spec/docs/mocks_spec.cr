require "../spec_helper"

# https://gitlab.com/arctic-fox/spectator/-/wikis/Mocks
Spectator.describe "Mocks Docs" do
  context "Abstract Types" do
    abstract class MyClass
      abstract def something : String
    end

    mock MyClass

    it "does something" do
      mock = mock(MyClass)
      allow(mock).to receive(:something).and_return("test") # Uncomment this line to fix.
      mock.something
    end
  end

  abstract class MyClass
    abstract def answer : Int32
    abstract def answer(arg1, arg2) : Int32
  end

  mock MyClass, answer: 5 do
    def answer(arg1, arg2) : Int32
      arg1 + arg2
    end
  end

  let(answer) { 42 }

  it "does something" do
    mock = mock(MyClass, answer: answer)
    expect(mock.answer).to eq(42)
    expect(mock.answer(1, 2)).to eq(3)
  end

  context "Instance Variables and Initializers" do
    class MyClass
      def initialize(@value : Int32)
      end
    end

    mock MyClass do
      def initialize(@value : Int32 = 0) # Note the lack of `stub` here.
      end
    end

    it "can create a mock" do
      mock = mock(MyClass)
      expect(mock).to_not be_nil
    end
  end

  context "Expecting Behavior" do
    abstract class Target
      abstract def call(value) : Nil
    end

    class Emitter
      def initialize(@value : Int32)
      end

      def emit(target : Target)
        target.call(@value)
      end
    end

    describe Emitter do
      subject { Emitter.new(42) }

      mock Target, call: nil

      describe "#emit" do
        it "invokes #call on the target" do
          target = mock(Target)
          subject.emit(target)
          expect(target).to have_received(:call).with(42)
        end
      end
    end

    it "does something" do
      mock = mock(MyClass)
      allow(mock).to receive(:answer).and_return(42) # Merge this line...
      mock.answer
      expect(mock).to have_received(:answer) # and this line.
    end

    it "does something" do
      mock = mock(MyClass)
      expect(mock).to receive(:answer).and_return(42)
      mock.answer
    end
  end

  context "Class Mocks" do
    class MyClass
      def self.something
        0
      end
    end

    mock MyClass do
      # Define class methods with `self.` prefix.
      stub def self.something
        42
      end
    end

    it "does something" do
      # Default stubs can be defined with key-value pairs (keyword arguments).
      mock = class_mock(MyClass, something: 3)
      expect(mock.something).to eq(3)

      # Stubs can be changed with `allow`.
      allow(mock).to receive(:something).and_return(5)
      expect(mock.something).to eq(5)

      # Even the expect-receive syntax works.
      expect(mock).to receive(:something).and_return(7)
      mock.something
    end
  end

  context "Injecting Mocks" do
    struct MyStruct
      def something
        42
      end

      def something_else(arg1, arg2)
        "#{arg1} #{arg2}"
      end
    end

    inject_mock MyStruct, something: 5 do
      stub def something_else(arg1, arg2)
        "foo bar"
      end
    end

    specify "creating a mocked type without `mock`" do
      inst = MyStruct.new
      expect(inst).to receive(:something).and_return(7)
      inst.something
    end

    it "reverts to default stub for other examples" do
      inst = mock(MyStruct)
      expect(inst.something).to eq(5) # Default stub used instead of original behavior.
    end
  end
end
