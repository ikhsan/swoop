require 'spec_helper'

describe Swoop::Entity do

  context "Type checking" do
    subject { described_class.new("Name", "swift", type) }

    context "class" do
      let(:type) { "class" }

      it "should have correct type" do
        expect(subject.struct?).to be false
        expect(subject.extension?).to be false
        expect(subject.class?).to be true
      end
    end

    context "struct" do
      let(:type) { "struct" }

      it "should have correct type" do
        expect(subject.struct?).to be true
        expect(subject.extension?).to be false
        expect(subject.class?).to be false
      end
    end

    context "extension" do
      let(:type) { "extension" }

      it "should have correct type" do
        expect(subject.struct?).to be false
        expect(subject.extension?).to be true
        expect(subject.class?).to be false
      end
    end

    context "category" do
      let(:type) { "category" }

      it "should have correct type" do
        expect(subject.struct?).to be false
        expect(subject.extension?).to be true
        expect(subject.class?).to be false
      end
    end

    context "unknown" do
      let(:type) { "xxx" }

      it "should have correct type" do
        expect(subject.struct?).to be false
        expect(subject.extension?).to be false
        expect(subject.class?).to be false
      end
    end
  end
  
end
