require 'spec_helper'

describe Swoop::EntityParser do
  subject { described_class.new(path) }

  context "Swift" do
    let(:path) { 'spec/fixture/Swoop/Swoop/User.swift' }
    let(:entities) {[
      double(Swoop::Entity, { 'name' => 'User', 'language' => 'swift', 'type' => 'class' })
    ]}

    before do
      expect(Swoop::SourceKitten).to receive(:run).and_return(["mocked_json"])
      expect(Swoop::Entity).to receive(:new_from_json).with("mocked_json").and_return(entities)
    end

    it "should be able to parse swift file" do
      expect(subject.entities).to eq(entities)
    end
  end

  context "Objective-C" do
    let(:path) { 'spec/fixture/Swoop/Swoop/ViewController.h' }

    it "should be able to parse objc file" do
      # TODO: don't know how to use sourcekitten for objective c file yet :(
    end
  end
end
