require 'spec_helper'

PROJECT_FIXTURE_PATH = '/Users/ikhsanassaat/Songkick/ios-app/Songkick/Songkick.xcodeproj'

describe Swoop::Project do

  let(:project_path) { PROJECT_FIXTURE_PATH }
  let(:directory) { 'Classes/Models' }
  subject { Swoop::Project.new(project_path, directory) }

  describe "initialization" do
    context "with project path and directory" do
      it "should have correct path" do
        expect(subject.path).to eq(PROJECT_FIXTURE_PATH)
      end

      it "should have correct directory from default param" do
        expect(subject.directory).to eq('Classes/Models')
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
          expect { subject.files }.to raise_error("Error: Project path is empty :(")
        end
      end

      context "missing file" do
        let(:project_path) { '/Users/ikhsanassaat/Songkick/ios-app/Songkick/Songkick__.xcodeproj' }

        it 'should raise can\'t find project message' do
          expect { subject.files }.to raise_error("Error: Can't find .xcodeproj project :(")
        end
      end

      context "invalid project from specified path" do
        let(:project_path) { '/Users/ikhsanassaat/Songkick/ios-app/Songkick/main.m' }

        it 'should raise invalid project message' do
          expect { subject.files }.to raise_error("Error: Invalid .xcodeproj file :(")
        end
      end

      context "directory inside xcode project does not have files" do
        let(:directory) { 'classes' }

        it 'should raise files not found' do
          expect { subject.files }.to raise_error("Error: No files are found :(")
        end
      end
    end

    context "when projects are valid" do
      it "should have correct file's paths" do

        puts subject.files.count

      end
    end

  end

end
