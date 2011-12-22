require 'spec_helper'

describe Zucchini::Runner do
  before (:each) do
    runner.path = "spec/sample_setup/feature_one"
    ENV['ZUCCHINI_DEVICE'] = 'My iDevice'
  end 
   
  let (:runner) { Zucchini::Runner.new(nil) }
  
  describe "execute" do
    subject { lambda { runner.execute } }
    
    context "feature directory doesn't exist" do
      before { runner.path = "spec/sample_setup/erroneous_feature" }
      it     { should raise_error "Directory spec/sample_setup/erroneous_feature does not exist" }
    end
    
    context "device hasn't been found" do
      before { ENV['ZUCCHINI_DEVICE'] = 'My Android Phone' }
      it     { should raise_error "Device not listed in config.yml" }
    end
  end
  
  describe "detect features" do
    subject { lambda { runner.detect_features(@path) } }
    
    context "path to a single feature" do
      before { @path = "spec/sample_setup/feature_one" }
      it "should detect it" do
        subject.call[0].path.should eq @path
      end
    end
    
    context "path to a directory with features" do
      before { @path = File.expand_path("spec/sample_setup") }
      it "should detect all features in it" do
        subject.call.length.should eq 2
      end
    end
    
    context "path to a non-feature directory" do
      before do
        @path = File.expand_path("spec/sample_setup/bad_feature")
        FileUtils.mkdir(@path)
      end
      
      it    { should raise_error }
      after { FileUtils.rmdir(@path) }
    end
  end
end