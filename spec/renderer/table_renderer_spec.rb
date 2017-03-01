require 'spec_helper'

describe Swoop::TableRenderer do
  let(:report) {
    project = Swoop::Project.new(PROJECT_FIXTURE_PATH, "Swoop/Model")
    file_infos = Swoop::FileParser.parse(project.filepaths)
    Swoop::Report.new(file_infos, 'master', Time.new("2016-08-16 00:00:00"))
  }
  subject { described_class.new([report], 'Faux Report') }

  it "should print table to console" do
    table = <<-EOS
+--------+------------+-------------+-------------+----------------+-----------------+-------------+-------------+-------------+-------------+-------------+-------------+
|                                                                              Faux Report                                                                               |
+--------+------------+-------------+-------------+----------------+-----------------+-------------+-------------+-------------+-------------+-------------+-------------+
| name   | date       | swift       | objc        | swift          | objc            | swift       | objc        | swift       | objc        | swift       | objc        |
|        |            | files (%)   | files (%)   | lines (%)      | lines (%)       | class (%)   | class (%)   | struct(%)   | struct(%)   | ext(%)      | ext(%)      |
+--------+------------+-------------+-------------+----------------+-----------------+-------------+-------------+-------------+-------------+-------------+-------------+
| master | 01-01-2016 | 42.86 (3/7) | 57.14 (4/7) | 33.87 (63/186) | 66.13 (123/186) | 60.00 (3/5) | 40.00 (2/5) | 25.00 (1/4) | 75.00 (3/4) | 25.00 (1/4) | 75.00 (3/4) |
+--------+------------+-------------+-------------+----------------+-----------------+-------------+-------------+-------------+-------------+-------------+-------------+
    EOS

    expect{ subject.render }.to output(table).to_stdout
  end

end
