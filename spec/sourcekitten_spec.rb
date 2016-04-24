require 'spec_helper'

describe Swoop::SourceKitten do

  # User.swift, User+Utility.swift, Tester.swift
  describe "Extracting information" do
    context "Swift files" do
      let(:path) { 'spec/fixture/Swoop/Swoop/User.swift' }

      it "should able to extract classes" do
        file_analysis = Swoop::SourceKitten.run path
        puts file_analysis
      end
    end
  end

end
