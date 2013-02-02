require "spec_helper"

describe EntriesHelper do
  describe "#decorate(args)" do
    subject do
      helper.decorate(args)
    end

    context "when given an Enumerable object" do
      let(:args) do
        ["object"]
      end

      it "returns an Array of decorated objects" do
        should be_a Array
        subject.first.should be_a EntryDecorator
      end
    end

    context "when given an object" do
      let(:args) do
        "object"
      end

      it "returns a decorated object" do
        should be_a EntryDecorator
      end
    end
  end
end
