require 'spec_helper'

describe Swoop::TimeMachine do
  let(:project) { double(Swoop::Project, { :path => "some/path" }) }
  let(:options) { {} }
  subject { described_class.new(project, options) }

  it "should have project path" do
    expect(subject.project_path).to eq("some/path")
  end

  # TODO: test travel blocks
end
