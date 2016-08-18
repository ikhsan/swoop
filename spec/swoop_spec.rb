require 'spec_helper'

describe Swoop do
  it 'has a version number' do
    expect(Swoop::VERSION).not_to be nil
  end
end

describe Swoop::Reporter do
  before do
    allow($stdout).to receive(:write)
    allow_any_instance_of(described_class).to receive(:summary_report).and_return(report)
  end

  context "Renderer" do
    let(:report) { [ double(Swoop::Report) ] }
    let(:renderer) { double(Swoop::Renderer, { 'render' => '' }) }

    it "should use TableRenderer when not specified" do
      expect(Swoop::TableRenderer).to receive(:new).with(report, "Swoop Report : 'Classes'").and_return(renderer)

      args = ["--path",  PROJECT_FIXTURE_PATH,  "--dir", "Classes"]
      described_class.start(args)
    end

    it "should use CSVRenderer for csv render option" do
      expect(Swoop::CSVRenderer).to receive(:new).with(report, "Swoop Report : 'Classes'").and_return(renderer)

      args = ["--path",  PROJECT_FIXTURE_PATH,  "--dir", "Classes", "--render", "csv" ]
      described_class.start(args)
    end

    it "should use ChartRenderer for csv render option" do
      expect(Swoop::ChartRenderer).to receive(:new).with(report, "Swoop Report : 'Classes'").and_return(renderer)

      args = ["--path",  PROJECT_FIXTURE_PATH,  "--dir", "Classes", "--render", "chart" ]
      described_class.start(args)
    end

  end
end
