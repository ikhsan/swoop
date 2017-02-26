require 'spec_helper'

describe Swoop::FileInfo do
  subject { described_class.new(filepath, line_count, classes, structs, extensions) }

  context "Objective-C file" do
    let(:filepath) { 'spec/fixture/Swoop/Swoop/ViewController.h' }
    let(:line_count) { 30 }
    let(:classes) {[
      double(Swoop::Entity, { 'swift?' => false, 'objc?' => true, 'class?' => true, 'struct?' => false, 'extension?' => false }),
      double(Swoop::Entity, { 'swift?' => false, 'objc?' => true, 'class?' => true, 'struct?' => false, 'extension?' => false }),
      double(Swoop::Entity, { 'swift?' => false, 'objc?' => true, 'class?' => true, 'struct?' => false, 'extension?' => false }),
    ]}
    let(:structs) {[
      double(Swoop::Entity, { 'swift?' => false, 'objc?' => true, 'class?' => false, 'struct?' => true, 'extension?' => false }),
    ]}
    let(:extensions) {[
      double(Swoop::Entity, { 'swift?' => false, 'objc?' => true, 'class?' => false, 'struct?' => false, 'extension?' => true }),
      double(Swoop::Entity, { 'swift?' => false, 'objc?' => true, 'class?' => false, 'struct?' => false, 'extension?' => true }),
    ]}

    it "should detect its language" do
      expect(subject.swift?).to be false
      expect(subject.objc?).to be true
    end

    it "should have 6 entities" do
      expect(subject.entities.count).to equal(6)
    end
  end

  context "Swift file" do
    let(:filepath) { 'spec/fixture/Swoop/Swoop/User.swift' }
    let(:line_count) { 30 }
    let(:classes) {[
      double(Swoop::Entity, { 'swift?' => true, 'objc?' => false, 'class?' => true, 'struct?' => false, 'extension?' => false }),
      double(Swoop::Entity, { 'swift?' => true, 'objc?' => false, 'class?' => true, 'struct?' => false, 'extension?' => false }),
      double(Swoop::Entity, { 'swift?' => true, 'objc?' => false, 'class?' => true, 'struct?' => false, 'extension?' => false }),
    ]}
    let(:structs) {[
      double(Swoop::Entity, { 'swift?' => true, 'objc?' => false, 'class?' => false, 'struct?' => true, 'extension?' => false }),
      double(Swoop::Entity, { 'swift?' => true, 'objc?' => false, 'class?' => false, 'struct?' => true, 'extension?' => false }),
    ]}
    let(:extensions) {[
      double(Swoop::Entity, { 'swift?' => true, 'objc?' => false, 'class?' => false, 'struct?' => false, 'extension?' => true }),
      double(Swoop::Entity, { 'swift?' => true, 'objc?' => false, 'class?' => false, 'struct?' => false, 'extension?' => true }),
      double(Swoop::Entity, { 'swift?' => true, 'objc?' => false, 'class?' => false, 'struct?' => false, 'extension?' => true }),
    ]}

    it "should detect its language" do
      expect(subject.swift?).to be true
      expect(subject.objc?).to be false
    end

    it "should have 8 entities" do
      expect(subject.entities.count).to equal(8)
    end
  end


end
