require 'spec_helper'

describe Zucchini::Generator do
  let(:project_path) { "/tmp/z_test_project" }
  let(:feature_path) { "#{project_path}/features/rspec_feature" }
  let(:generator)    { Zucchini::Generator.new(nil) }
  
  after(:all) { FileUtils.rm_rf(project_path) }
  
  context "generate a project" do
    before { generator.path = project_path }
    it "should create a project directory" do
      generator.stub!(:project?).and_return(true)
      generator.execute
      File.exists?("#{project_path}/features/support/config.yml").should be_true
    end
  end
  
  context "generate a feature" do
    before { generator.path = feature_path }
    it "should create a feature directory" do
      generator.stub!(:feature?).and_return(true)
      generator.execute
      File.exists?("#{feature_path}/feature.zucchini").should be_true
    end
  end
end