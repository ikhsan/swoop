require 'spec_helper'

describe Swoop::Report do
  subject { described_class.new(entities) }
  let(:entities) {[
    # double(Swoop::Entity, { 'name' => 'Position', 'language' => 'swift', 'type' => 'struct' }),
    # double(Swoop::Entity, { 'name' => 'User', 'language' => 'swift', 'type' => 'class' }),
    # double(Swoop::Entity, { 'name' => 'User', 'language' => 'swift', 'type' => 'extension' }),
    # double(Swoop::Entity, { 'name' => 'Admin', 'language' => 'swift', 'type' => 'class' }),
    # double(Swoop::Entity, { 'name' => 'Tester', 'language' => 'swift', 'type' => 'class' }),
    # double(Swoop::Entity, { 'name' => 'ViewController', 'language' => 'objc', 'type' => 'class' }),
    # double(Swoop::Entity, { 'name' => 'ViewController+Utility', 'language' => 'objc', 'type' => 'category' }),

    double(Swoop::Entity, { 'swift?' => true, 'class?' => false, 'struct?' => true }),
    double(Swoop::Entity, { 'swift?' => true, 'class?' => true, 'struct?' => false }),
    double(Swoop::Entity, { 'swift?' => true, 'class?' => true, 'struct?' => false }),
    double(Swoop::Entity, { 'swift?' => true, 'class?' => true, 'struct?' => false }),

  ]}

  context "Report" do
    it "should have correct count for swift classes" do
      expect(subject.swift_classes_count).to eq(3)
    end

    it "should have correct count for swift struct" do
      expect(subject.swift_structs_count).to eq(1)
    end
  end

end
