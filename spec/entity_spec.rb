require 'spec_helper'

describe Swoop::Entity do
  let(:fixtures) {
    json = File.open(path, 'rb') { |f| f.read }
    substructures = JSON.parse(json)
    substructures['key.substructure']
  }

  context "Swift" do
    let(:path) { 'spec/fixture/user.swift.json' }

    context "when file has a struct" do
      let(:subject) { Swoop::Entity.new fixtures[0] }
      let(:position) { double(Swoop::Entity, { 'name' => 'Position', 'language' => 'swift', 'type' => 'struct' }) }

      it "should extract position struct" do
        expect(subject).to eq(position)
      end
    end

    context "when file has classes" do
      let(:admin) { double(Swoop::Entity, { 'name' => 'Admin', 'language' => 'swift', 'type' => 'class' }) }
      let(:user) { double(Swoop::Entity, { 'name' => 'User', 'language' => 'swift', 'type' => 'class' }) }

      it "should extract user class correctly" do
        subject = Swoop::Entity.new fixtures[1]
        expect(subject).to eq(user)
      end

      it "should extract admin class correctly" do
        subject = Swoop::Entity.new fixtures[2]
        expect(subject).to eq(admin)
      end
    end

    context "when file has an extension" do
      let(:user) { double(Swoop::Entity, { 'name' => 'User', 'language' => 'swift', 'type' => 'extension' }) }

      it "should extract admin extension correctly" do
        subject = Swoop::Entity.new fixtures[3]
        expect(subject).to eq(user)
      end
    end
  end

  context "Objective-C" do
    # TODO: how to get information out of objective-c classes
  end

end
