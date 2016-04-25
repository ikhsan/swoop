require 'spec_helper'

describe Swoop::Entity do

  context "Swift" do
    let(:entities) { Swoop::SourceKitten.run(path) }

    context "files with multiple classes" do
      let(:path) { 'spec/fixture/Swoop/Swoop/User.swift' }
      let(:admin) { double(Swoop::Entity, { 'name' => 'Admin', 'language' => 'swift', 'type' => 'class' }) }
      let(:user) { double(Swoop::Entity, { 'name' => 'User', 'language' => 'swift', 'type' => 'class' }) }
      let(:position) { double(Swoop::Entity, { 'name' => 'Position', 'language' => 'swift', 'type' => 'struct' }) }

      it "should extract admin class" do
        expect(entities.last).to eq(admin)
      end

      it "should extract user class" do
        expect(entities[1]).to eq(user)
      end

      it "should extract struct" do
        expect(entities.first).to eq(position)
      end
    end

    context "subclasses" do
      let(:path) { 'spec/fixture/Swoop/Swoop/Tester.swift' }
      let(:tester) { double(Swoop::Entity, { 'name' => 'Tester', 'language' => 'swift', 'type' => 'class' }) }

      it "should extract subclasses" do
        expect(entities.first).to eq(tester)
      end
    end

    context "extensions" do
      let(:path) { 'spec/fixture/Swoop/Swoop/User+Utility.swift' }
      let(:user) { double(Swoop::Entity, { 'name' => 'User', 'language' => 'swift', 'type' => 'extension' }) }

      it "should extract extension" do
        expect(entities.first).to eq(user)
      end
    end
  end

  context "Objective-C" do

    context "files with multiple classes" do

    end

    context "subclasses" do

    end

    context "extension" do

    end

  end

end
