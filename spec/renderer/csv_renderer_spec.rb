require 'spec_helper'

describe Swoop::CSVRenderer do
  let(:report) {
    # rather make an actual report from .xcodeproj rather than mock one
    project = Swoop::Project.new(PROJECT_FIXTURE_PATH, "Swoop/Model")
    entities = Swoop::EntityParser.parse_files(project.filepaths)
    Swoop::Report.new(entities, 'master', Time.new("2016-08-16 00:00:00"))
  }
  subject { described_class.new([report], 'Faux Report') }

  it "should write csv to filepath" do
    expected_csv =
    "name,date,swift class,swift class %,objc class,objc class %,total class,swift struct,swift struct %,objc struct,objc struct %,total struct,swift extension,swift extension %,objc extension,objc extension %,total extension\n" \
    "master,01-01-2016,3,60.00,2,40.00,5,1,25.00,3,75.00,4,1,25.00,3,75.00,4"
    expected_path = "28d06b2b6a43bfddaf3f932753858ccf3bb6880f.csv"

    expect(File).to receive(:write).with(expected_path, expected_csv)
    expect(File).to receive(:file?).with(expected_path).and_return(true)
    expect{ subject.render }.to output("CSV file successfully created at '28d06b2b6a43bfddaf3f932753858ccf3bb6880f.csv'\n").to_stdout
  end
end
