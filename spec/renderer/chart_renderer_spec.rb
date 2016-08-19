require 'spec_helper'

describe Swoop::ChartRenderer do
  let(:report) {
    # rather make an actual report from .xcodeproj rather than mock one
    project = Swoop::Project.new(PROJECT_FIXTURE_PATH, "Swoop/Model")
    entities = Swoop::EntityParser.parse_files(project.filepaths)
    Swoop::Report.new(entities, 'master', Time.new("2016-08-16 00:00:00"))
  }
  subject { described_class.new([report, report], 'Faux Report') }

  it "should have index.html as default filename" do
    expect(subject.filename).to eq('index.html')
  end

  it "should count class data" do
    expect(subject.class_count_data).to eq([
      ["Date", "Swift Class", "Objective-C Class"],
      ["master\n(01-01-2016)", 3, 2],
      ["master\n(01-01-2016)", 3, 2]
    ].to_s)
  end

  it "should count class data" do
    expect(subject.class_percentage_data).to eq([
      ["Date", "Swift Class (%)", "Objective-C Class (%)"],
      ["master\n(01-01-2016)", 60.0, 40.0],
      ["master\n(01-01-2016)", 60.0, 40.0]
    ].to_s)
  end

  it "create index.html file" do
    path = File.join(File.expand_path("."), "html/index.html")
    expect(subject).to receive(:`).with("open #{path}")

    subject.render

    expect(File.exist?(path)).to be true
  end

end
