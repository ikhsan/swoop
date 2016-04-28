require 'spec_helper'

describe Swoop::SourceKitten do
  let(:subject) { Swoop::SourceKitten.run(path) }

  context "Swift" do
    context "files with multiple classes" do
      let(:path) { 'spec/fixture/Swoop/Swoop/User.swift' }

      it "should extracting all entities" do
        expect(subject.count).to eq(4)
      end

      it "should all be entities" do
        subject.each { |s| expect(s).to be_a(Swoop::Entity) }
      end
    end
  end

end
