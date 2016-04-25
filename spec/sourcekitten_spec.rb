require 'spec_helper'

describe Swoop::SourceKitten do
  let(:subject) { Swoop::SourceKitten.run(path) }

  context "Swift" do
    context "files with multiple classes" do
      let(:path) { 'spec/fixture/Swoop/Swoop/User.swift' }

      it "should extracting all entities" do
        expect(subject.count).to eq(3)
      end
    end
  end

end
