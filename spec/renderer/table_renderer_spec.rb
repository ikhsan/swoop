require 'spec_helper'

describe Swoop::TableRenderer do
  let(:report) {
    # rather make an actual report from .xcodeproj rather than mock one
    project = Swoop::Project.new(PROJECT_FIXTURE_PATH, "Swoop/Model")
    entities = Swoop::FileParser.parse(project.filepaths)
    Swoop::Report.new(entities, 'master', Time.new("2016-08-16 00:00:00"))
  }
  subject { described_class.new([report], 'Faux Report') }

  it "should print table to console" do
    expect{ subject.render }.to output(
    "+--------+------------+-------------+-------------+-------------+-------------+-------------+-------------+\n" +
    "|                                               Faux Report                                               |\n" +
    "+--------+------------+-------------+-------------+-------------+-------------+-------------+-------------+\n" +
    "| name   | date       | swift       | objc        | swift       | objc        | swift       | objc        |\n" +
    "|        |            | class (%)   | class (%)   | struct(%)   | struct(%)   | ext(%)      | ext(%)      |\n" +
    "+--------+------------+-------------+-------------+-------------+-------------+-------------+-------------+\n" +
    "| master | 01-01-2016 | 60.00 (3/5) | 40.00 (2/5) | 25.00 (1/4) | 75.00 (3/4) | 25.00 (1/4) | 75.00 (3/4) |\n" +
    "+--------+------------+-------------+-------------+-------------+-------------+-------------+-------------+\n"
    ).to_stdout
  end

end
