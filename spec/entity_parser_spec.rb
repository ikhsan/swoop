require 'spec_helper'

describe Swoop::EntityParser do
  subject { described_class.new(filepath) }

  context "Swift" do
    let(:filepath) { 'spec/fixture/Swoop/Swoop/User.swift' }
    let(:entities) {[
      double(Swoop::Entity, { 'name' => 'User', 'language' => 'swift', 'type' => 'class' }),
      double(Swoop::Entity, { 'name' => 'Admin', 'language' => 'swift', 'type' => 'class' }),
      double(Swoop::Entity, { 'name' => 'Position', 'language' => 'swift', 'type' => 'struct' }),
      double(Swoop::Entity, { 'name' => 'User', 'language' => 'swift', 'type' => 'extension' })
    ]}

    it "should parse every file to entities" do
      expect(subject.entities).to eq(entities)
    end
  end

  context "Objective-C" do
    let(:filepath) { 'spec/fixture/Swoop/Swoop/ViewController.h' }
  end

end
