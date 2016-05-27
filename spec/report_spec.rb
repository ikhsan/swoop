require 'spec_helper'

describe Swoop::Report do
  subject { described_class.new(entities) }

  let(:entities) {[
    double(Swoop::Entity, { 'swift?' => true, 'objc?' => false, 'class?' => false, 'struct?' => true, 'extension?' => false }),
    double(Swoop::Entity, { 'swift?' => true, 'objc?' => false, 'class?' => false, 'struct?' => true, 'extension?' => false }),
    double(Swoop::Entity, { 'swift?' => true, 'objc?' => false, 'class?' => true, 'struct?' => false, 'extension?' => false }),
    double(Swoop::Entity, { 'swift?' => true, 'objc?' => false, 'class?' => true, 'struct?' => false, 'extension?' => false }),
    double(Swoop::Entity, { 'swift?' => true, 'objc?' => false, 'class?' => true, 'struct?' => false, 'extension?' => false }),
    double(Swoop::Entity, { 'swift?' => true, 'objc?' => false, 'class?' => false, 'struct?' => false, 'extension?' => true }),
    double(Swoop::Entity, { 'swift?' => true, 'objc?' => false, 'class?' => false, 'struct?' => false, 'extension?' => true }),
    double(Swoop::Entity, { 'swift?' => true, 'objc?' => false, 'class?' => false, 'struct?' => false, 'extension?' => true }),

    double(Swoop::Entity, { 'swift?' => false, 'objc?' => true, 'class?' => false, 'struct?' => true, 'extension?' => false }),
    double(Swoop::Entity, { 'swift?' => false, 'objc?' => true, 'class?' => true, 'struct?' => false, 'extension?' => false }),
    double(Swoop::Entity, { 'swift?' => false, 'objc?' => true, 'class?' => true, 'struct?' => false, 'extension?' => false }),
    double(Swoop::Entity, { 'swift?' => false, 'objc?' => true, 'class?' => true, 'struct?' => false, 'extension?' => false }),
    double(Swoop::Entity, { 'swift?' => false, 'objc?' => true, 'class?' => false, 'struct?' => false, 'extension?' => true }),
    double(Swoop::Entity, { 'swift?' => false, 'objc?' => true, 'class?' => false, 'struct?' => false, 'extension?' => true }),
  ]}

  context "Stats" do
    context "for classes" do
      it "should have correct total of classes" do
        expect(subject.classes_count).to eq(6)
      end

      it "should have correct swift class percentage" do
        expect(subject.swift_classes_percentage).to eq(50)
      end

      it "should have correct objc class percentage" do
        expect(subject.objc_classes_percentage).to eq(50)
      end
    end

    context "for structs" do
      it "should have correct total of structs" do
        expect(subject.structs_count).to eq(3)
      end

      it "should have correct swift structs percentage" do
        expect(subject.swift_structs_percentage).to be_within(0.01).of(66.66)
      end

      it "should have correct objc structs percentage" do
        expect(subject.objc_structs_percentage).to be_within(0.01).of(33.33)
      end
    end

    context "for extensions" do
      it "should have correct total of extensions" do
        expect(subject.extensions_count).to eq(5)
      end

      it "should have correct swift extensions percentage" do
        expect(subject.swift_extensions_percentage).to eq(60.0)
      end

      it "should have correct objc extensions percentage" do
        expect(subject.objc_extensions_percentage).to eq(40.0)
      end
    end
  end

  context "Entities counter" do
    context "Swift entities" do
      it "should have correct count for swift classes" do
        expect(subject.swift_classes_count).to eq(3)
      end

      it "should have correct count for swift struct" do
        expect(subject.swift_structs_count).to eq(2)
      end

      it "should have correct count for swift extension" do
        expect(subject.swift_extensions_count).to eq(3)
      end
    end

    context "Objective-C entities" do
      it "should have correct count for objective-c classes" do
        expect(subject.objc_classes_count).to eq(3)
      end

      it "should have correct count for objective-c struct" do
        expect(subject.objc_structs_count).to eq(1)
      end

      it "should have correct count for objective-c extension" do
        expect(subject.objc_extensions_count).to eq(2)
      end
    end
  end

end
