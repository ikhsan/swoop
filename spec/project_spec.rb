require 'spec_helper'

describe Swoop::Project do

  let(:project_path) { PROJECT_FIXTURE_PATH }
  let(:directory) { 'Swoop/Model' }
  subject { Swoop::Project.new(project_path, directory) }

  describe "initialization" do
    context "with project path and directory" do
      it "should have correct path" do
        expect(subject.path).to eq(PROJECT_FIXTURE_PATH)
      end

      it "should have correct directory" do
        expect(subject.directory).to eq('Swoop/Model')
      end
    end

    context "with only project path" do
      it "should have correct directory from default param" do
        proj = Swoop::Project.new(project_path)
        expect(proj.directory).to eq('Classes')
      end
    end
  end

  describe "getting files" do
    context "when parameters are faulty" do
      context "invalid project path" do
        let(:project_path) { '' }

        it 'should raise empty project message' do
          expect { subject.filepaths }.to raise_error("Error: Project path is empty :(")
        end
      end

      context "missing file" do
        let(:project_path) { 'spec/fixture/Swoop/Swoop__.xcodeproj' }

        it 'should raise can\'t find project message' do
          expect { subject.filepaths }.to raise_error("Error: Can't find .xcodeproj project :(")
        end
      end

      context "invalid project from specified path" do
        let(:project_path) { 'spec/fixture/Swoop/Swoop/main.m' }

        it 'should raise invalid project message' do
          expect { subject.filepaths }.to raise_error("Error: Invalid .xcodeproj file :(")
        end
      end

      context "directory inside xcode project does not have files" do
        let(:directory) { 'classes' }

        it 'should raise files not found' do
          expect { subject.filepaths }.to raise_error("Error: Can't find directory :(")
        end
      end
    end

    context "when projects are valid" do
      it "should have correct filepaths" do
        fixture_files = [
          'ViewController.h',
          'ViewController.m',
          'ViewController+Utility.h',
          'ViewController+Utility.m',
          'User.swift',
          'User+Utility.swift',
          'Tester.swift'
        ]

        files = subject.filepaths.map { |e| File.basename e }
        expect(files).to eq(fixture_files)
      end
    end

  end

end
