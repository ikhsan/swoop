require 'spec_helper'

describe Swoop::SourceKitten do
  subject { Swoop::SourceKitten.run(path) }

  context "Swift" do
    context "files with multiple classes" do
      let(:path) { 'spec/fixture/Swoop/Swoop/User.swift' }

      it "should extracting all entities" do
        puts "£" * 100
        puts subject
        
        expect(subject.count).to eq(4)
      end
    end
  end

end
