require 'spec_helper'

describe Swoop::TableRenderer do
  let(:report) {
    # rather make an actual report from .xcodeproj rather than mock one
    project = Swoop::Project.new(PROJECT_FIXTURE_PATH, "Swoop/Model")
    entities = Swoop::EntityParser.parse_files(project.filepaths)
    Swoop::Report.new(entities, 'master', Time.new("2016-08-16 00:00:00"))
  }
  subject { described_class.new([report], 'Faux Report') }

  it "should print table to console" do
    expect{ subject.render }.to output(
    "+--------+------------+-------+-----------+-------+-----------+-------+--------+-----------+--------+-----------+--------+-------+--------+------+--------+-------+\n" +
    "|                                                                           Faux Report                                                                           |\n" +
    "+--------+------------+-------+-----------+-------+-----------+-------+--------+-----------+--------+-----------+--------+-------+--------+------+--------+-------+\n" +
    "| name   | date       | swift | swift     | objc  | objc      | total | swift  | swift     | objc   | objc      | total  | swift | swift  | objc | objc   | total |\n" +
    "|        |            | class | class (%) | class | class (%) | class | struct | struct(%) | struct | struct(%) | struct | ext   | ext(%) | ext  | ext(%) | ext   |\n" +
    "+--------+------------+-------+-----------+-------+-----------+-------+--------+-----------+--------+-----------+--------+-------+--------+------+--------+-------+\n" +
    "| master | 01-01-2016 | 3     | 60.00     | 2     | 40.00     | 5     | 1      | 25.00     | 3      | 75.00     | 4      | 1     | 25.00  | 3    | 75.00  | 4     |\n" +
    "+--------+------------+-------+-----------+-------+-----------+-------+--------+-----------+--------+-----------+--------+-------+--------+------+--------+-------+\n"
    ).to_stdout
  end

end
