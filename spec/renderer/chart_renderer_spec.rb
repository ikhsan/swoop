require 'spec_helper'

describe Swoop::ChartRenderer do
  let(:report) {
    # rather make an actual report from .xcodeproj rather than mock one
    project = Swoop::Project.new(PROJECT_FIXTURE_PATH, "Swoop/Model")
    entities = Swoop::EntityParser.parse_files(project.filepaths)
    Swoop::Report.new(entities, 'master', Time.new("2016-08-16 00:00:00"))
  }
  subject { described_class.new([report], 'Faux Report') }

  it "should count class data" do
    expect(subject.class_count_data).to eq([
      ["Date", "Swift Class", "Objective-C Class"],
      ["master\n(01-01-2016)", 3, 2]
    ].to_s)
  end

  it "should count class data" do
    expect(subject.class_percentage_data).to eq([
      ["Date", "Swift Class (%)", "Objective-C Class (%)"],
      ["master\n(01-01-2016)", 60.0, 40.0]
    ].to_s)
  end

end
