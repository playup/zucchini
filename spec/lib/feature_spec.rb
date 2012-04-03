require 'spec_helper'

describe Zucchini::Feature do
  let(:path)    { './spec/sample_setup/feature_one' }
  let(:feature) { Zucchini::Feature.new(path) }
  
  after(:all) { FileUtils.rm_rf Dir.glob("#{path}/run_data/feature.*") }
  
  describe "#compile_js" do
    before { feature.compile_js }
    
    it "should strip comments from the feature file" do
      File.read("#{feature.run_data_path}/feature.coffee").index('#').should be_nil
    end
    
    describe "feature.js output" do
      subject { File.read("#{feature.run_data_path}/feature.js") }
    
      it "should include screen definitions" do
        should match /SplashScreen = \(function/
      end
      
      it "should include Zucchini runtime" do
        should match /Zucchini.run = /
      end
      
      it "should include custom libraries from support/lib" do
        should match /Helpers.example = /
      end
    end
  end
end
