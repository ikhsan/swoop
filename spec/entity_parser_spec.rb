require 'spec_helper'

describe Swoop::EntityParser do
  subject { described_class.new(filepath) }

  context "Parsing swift file" do
    let(:filepath) { 'spec/fixture/Swoop/Swoop/User.swift' }

    it "should parse every class" do
      user = double(Swoop::Entity, { 'name' => 'User', 'language' => 'swift', 'type' => 'class' })
      expect(subject.entities).to include(user)

      admin = double(Swoop::Entity, { 'name' => 'Admin', 'language' => 'swift', 'type' => 'class' })
      expect(subject.entities).to include(admin)
    end

    it "should parse every struct" do
      position = double(Swoop::Entity, { 'name' => 'Position', 'language' => 'swift', 'type' => 'struct' })
      expect(subject.entities).to include(position)
    end

    it "should parse every extension" do
      user = double(Swoop::Entity, { 'name' => 'User', 'language' => 'swift', 'type' => 'extension' })
      expect(subject.entities).to include(user)
    end

    context "when commented" do
      it "should ignore commented classes" do
        class_names = subject.entities.select { |e| e.type == 'class' }.map { |e| e.name }
        expect(class_names).not_to include("_User")
        expect(class_names).not_to include("_Admin")
      end

      it "should ignore commented structs" do
        struct_names = subject.entities.select { |e| e.type == 'struct' }.map { |e| e.name }
        expect(struct_names).not_to include("_Position")
      end

      it "should ignore commented extension" do
        ext_names = subject.entities.select { |e| e.type == 'extension' }.map { |e| e.name }
        expect(ext_names).not_to include("_User")
      end
    end
  end

  context "Parsing Objective-C file" do
    let(:filepath) { 'spec/fixture/Swoop/Swoop/ViewController.h' }

    it "should parse class " do
      vc = double(Swoop::Entity, { 'name' => 'ViewController', 'language' => 'objc', 'type' => 'class' })
      expect(subject.entities).to include(vc)

      svc = double(Swoop::Entity, { 'name' => 'SpecialViewController', 'language' => 'objc', 'type' => 'class' })
      expect(subject.entities).to include(svc)
    end

    it "should parse categories" do
      cat = double(Swoop::Entity, { 'name' => 'SpecialViewController+Extension', 'language' => 'objc', 'type' => 'category' })
      expect(subject.entities).to include(cat)
    end

    it "should parse extension" do
      ext = double(Swoop::Entity, { 'name' => 'SpecialViewController', 'language' => 'objc', 'type' => 'extension' })
      expect(subject.entities).to include(ext)
    end

    it "should parse structs" do
      struct1 = double(Swoop::Entity, { 'name' => 'Color', 'language' => 'objc', 'type' => 'struct' })
      expect(subject.entities).to include(struct1)

      struct2 = double(Swoop::Entity, { 'name' => 'Coordinate', 'language' => 'objc', 'type' => 'struct' })
      expect(subject.entities).to include(struct2)

      struct3 = double(Swoop::Entity, { 'name' => 'Book', 'language' => 'objc', 'type' => 'struct' })
      expect(subject.entities).to include(struct3)
    end

    context "when commented" do
      it "should ignore commented classes" do
        class_names = subject.entities.select { |e| e.type == 'class' }.map { |e| e.name }
        expect(class_names).not_to include("_ViewController")
        expect(class_names).not_to include("_SpecialViewController")
      end

      it "should ignore commented categories" do
        ext_names = subject.entities.select { |e| e.type == 'extension' }.map { |e| e.name }
        expect(ext_names).not_to include("_SpecialViewController")
      end

      it "should ignore commented structs" do
        struct_names = subject.entities.select { |e| e.type == 'struct' }.map { |e| e.name }
        expect(struct_names).not_to include("_Book")
        expect(struct_names).not_to include("_Cooordinate")
      end
    end
  end

  context "Parsing multiple files" do
    let(:filepaths) {[
      'spec/fixture/Swoop/Swoop/ViewController.h',
      'spec/fixture/Swoop/Swoop/ViewController.h'
    ]}

    it "should parse all entities without duplicates" do
      entities = described_class.parse_files(filepaths)
      dupes = entities.select { |e| entities.count(e) > 1 }

      expect(dupes).to be_empty
    end

  end

end
