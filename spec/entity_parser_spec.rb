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
  end

  context "Objective-C" do
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
  end

end
