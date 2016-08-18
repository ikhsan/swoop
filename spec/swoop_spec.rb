require 'spec_helper'

describe Swoop do
  it 'has a version number' do
    expect(Swoop::VERSION).not_to be nil
  end
end

describe Swoop::Reporter do
  before do
    allow($stdout).to receive(:write)
  end

  context "Renderer" do
    let(:report) { [ double(Swoop::Report) ] }
    let(:renderer) { double(Swoop::Renderer, { 'render' => '' }) }

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
