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

  context "Swift" do
    subject { described_class.new_from_json(fixture) }
    let(:fixture) {
      content = File.open(path, 'rb') { |f| f.read }
      return JSON.parse(content)
    }

    context "when file has a struct" do
      let(:path) { 'spec/fixture/entities/struct.position.json' }
      let(:position) { double(Swoop::Entity, { 'name' => 'Position', 'language' => 'swift', 'type' => 'struct' }) }

      it "should extract position struct" do
        expect(subject).to eq(position)
      end


    end

    context "when file has classes" do
      context "named user" do
        let(:user) { double(Swoop::Entity, { 'name' => 'User', 'language' => 'swift', 'type' => 'class' }) }
        let(:path) { 'spec/fixture/entities/class.user.json' }

        it "should extract user class correctly" do
          expect(subject).to eq(user)
          expect(subject.class?).to be true
        end
      end

      context "named admin" do
        let(:admin) { double(Swoop::Entity, { 'name' => 'Admin', 'language' => 'swift', 'type' => 'class' }) }
        let(:path) { 'spec/fixture/entities/class.admin.json' }

        it "should extract admin class correctly" do
          expect(subject).to eq(admin)
        end
      end
    end

    context "when file has an extension" do
      let(:user) { double(Swoop::Entity, { 'name' => 'User', 'language' => 'swift', 'type' => 'extension' }) }
      let(:path) { 'spec/fixture/entities/extension.user.json' }

      it "should extract user extension correctly" do
        expect(subject).to eq(user)
      end
    end
  end

  context "Objective-C" do
    # TODO: how to get information out of objective-c classes
  end

end
