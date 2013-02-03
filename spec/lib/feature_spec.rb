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

  describe "approve" do
    subject { lambda { feature.approve "reference" } }

    context "no previous run data" do
      before { feature.path = './spec/sample_setup/feature_three' }
      it { should raise_error "Directory ./spec/sample_setup/feature_three doesn't contain previous run data" }
    end

    context "copies screenshots to reference directory" do
      before do
        feature.path = './spec/sample_setup/feature_three'
        feature.device = {screen: 'retina_ios5'}

        # Copying some random image to run screenshots.
        @screenshot_path = "#{feature.path}/run_data/Run\ 1/screenshot.png"
        FileUtils.mkdir_p(File.dirname(@screenshot_path))
        FileUtils.copy_file("./spec/sample_setup/feature_one/reference/retina_ios5/06_sign up_spinner.png", @screenshot_path)
      end

      it "should copy screenshot to reference directory" do
        feature.approve "reference"
        (File.exists? "#{feature.path}/reference/retina_ios5/screenshot.png").should eq true
      end

      it "should copy screenshot to pending directory" do
        feature.approve "pending"
        (File.exists? "#{feature.path}/pending/retina_ios5/screenshot.png").should eq true
      end

      after do
        FileUtils.rm_rf("#{feature.path}/run_data")
        FileUtils.rm_rf("#{feature.path}/reference")
        FileUtils.rm_rf("#{feature.path}/pending")
      end
    end
  end
end
