require 'spec_helper'

describe Swoop do
  it 'has a version number' do
    expect(Swoop::VERSION).not_to be nil
  end
end

describe Swoop::Reporter do
  let(:renderer) { double(Swoop::Renderer, { 'render' => '' }) }

  before do
    allow($stdout).to receive(:write)
  end

  context "Summary Report" do
    let(:project) { double(Swoop::Project, { :filepaths => "..." }) }
    let(:delorean) { double(Swoop::TimeMachine, { :travel => "" })}
    let(:report) { double(Swoop::Report) }
    let(:entities) { [ double(Swoop::Entity) ] }

    before do
      allow(Swoop::Project).to receive(:new).and_return(project)
      allow(Swoop::TimeMachine).to receive(:new).and_return(delorean)
    end

    it "should send summarised reports to the renderer" do
      expected_summary_report = [ report ]

      allow(delorean).to receive(:travel).and_yield(project, "master", Time.new("2016-08-16 00:00:00"))
      expect(Swoop::EntityParser).to receive(:parse_files).and_return(entities)
      expect(Swoop::Report).to receive(:new).with(entities, "master", Time.new("2016-08-16 00:00:00")).and_return(report)
      expect(Swoop::TableRenderer).to receive(:new).with(expected_summary_report, any_args).and_return(renderer)

      args = ["--path",  PROJECT_FIXTURE_PATH,  "--dir", "Classes"]
      described_class.start(args)
    end
  end

  context "Time machine options" do
    let(:project) { [ double(Swoop::Project) ] }
    let(:delorean) { double(Swoop::TimeMachine, { :travel => "" })}

    before do
      allow(Swoop::Project).to receive(:new).and_return(project)
      allow(Swoop::TableRenderer).to receive(:new).and_return(renderer)
    end

    it "should be empty if no flags are specified" do
      expected_options = {}
      expect(Swoop::TimeMachine).to receive(:new).with(project, expected_options).and_return(delorean)

      args = ["--path",  PROJECT_FIXTURE_PATH,  "--dir", "Classes"]
      described_class.start(args)
    end

    it "should have a number of last tags when specified" do
      expected_options = { :tags => 15 }
      expect(Swoop::TimeMachine).to receive(:new).with(project, expected_options).and_return(delorean)

      args = ["--path",  PROJECT_FIXTURE_PATH,  "--dir", "Classes", "--tags", "15"]
      described_class.start(args)
    end

    it "should have a tag filter when specified" do
      expected_options = { :tags => 15, :filter => "v\d+.\d+" }
      expect(Swoop::TimeMachine).to receive(:new).with(project, expected_options).and_return(delorean)

      args = ["--path",  PROJECT_FIXTURE_PATH,  "--dir", "Classes", "--tags", "15", "--filter_tag", "v\d+.\d+"]
      described_class.start(args)
    end

    it "should have a number of weeks when specified" do
      expected_options = { :weeks => 20 }
      expect(Swoop::TimeMachine).to receive(:new).with(project, expected_options).and_return(delorean)

      args = ["--path",  PROJECT_FIXTURE_PATH,  "--dir", "Classes", "--weeks", "20"]
      described_class.start(args)
    end
  end

  context "Renderer" do
    let(:report) { [ double(Swoop::Report) ] }

    before do
      allow_any_instance_of(described_class).to receive(:summary_report).and_return(report)
    end

    it "should have correct title report" do
      dir = "folder"
      expected_title = "Swoop Report : '#{dir}'"
      expect(Swoop::TableRenderer).to receive(:new).with(report, expected_title).and_return(renderer)

      args = ["--path",  PROJECT_FIXTURE_PATH,  "--dir", dir]
      described_class.start(args)
    end

    it "should use TableRenderer when not specified" do
      expect(Swoop::TableRenderer).to receive(:new).and_return(renderer)

      args = ["--path",  PROJECT_FIXTURE_PATH,  "--dir", "Classes"]
      described_class.start(args)
    end

    it "should use CSVRenderer for csv render option" do
      expect(Swoop::CSVRenderer).to receive(:new).and_return(renderer)

      args = ["--path",  PROJECT_FIXTURE_PATH,  "--dir", "Classes", "--render", "csv" ]
      described_class.start(args)
    end

    it "should use ChartRenderer for csv render option" do
      expect(Swoop::ChartRenderer).to receive(:new).and_return(renderer)

      args = ["--path",  PROJECT_FIXTURE_PATH,  "--dir", "Classes", "--render", "chart" ]
      described_class.start(args)
    end

  end
end
