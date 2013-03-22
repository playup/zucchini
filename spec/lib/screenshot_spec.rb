require 'spec_helper'
require 'digest/md5'

def md5(blob)
  Digest::MD5.hexdigest(blob)
end

describe Zucchini::Screenshot do
  let (:device)        { { :name => "iPhone 4S", :screen => "retina_ios5", :udid => "rspec987654" } }
  let (:base_path)     { "spec/sample_setup/feature_one" }
  let (:original_path) { "#{base_path}/run_data/Run\ 1/06_sign\ up_spinner.png" }
  
  let (:screenshot) do
    screenshot = Zucchini::Screenshot.new(original_path, device)
    screenshot.masked_paths = { :globally => "#{base_path}/globally_masked.png", :specifically => "#{base_path}/specifically_masked.png" }
    screenshot.mask
    screenshot
  end
  
  after(:all) do
    screenshot.masked_paths.each { |k, path| FileUtils.rm(path) }
    FileUtils.rm_rf("#{base_path}/run_data/Masked")
    FileUtils.rm_rf(screenshot.diff_path)
  end
  
  describe "mask" do
    before do
      @md5 = {
        :original            => md5(File.read(original_path)),
        :globally_masked     => md5(File.read(screenshot.masked_paths[:globally])),
        :specifically_masked => md5(File.read(screenshot.masked_paths[:specifically]))
      }
    end
    
    it "should apply a standard global mask based on the screen" do
      File.exists?(screenshot.masked_paths[:globally]).should be true
      @md5[:globally_masked].should_not be_equal @md5[:original]
    end
    
    it "should apply a screenshot-specific mask if it exists" do
      File.exists?(screenshot.masked_paths[:specifically]).should be true
      @md5[:specifically_masked].should_not be_equal @md5[:original]
      @md5[:specifically_masked].should_not be_equal @md5[:globally_masked]
    end
  end                                                        
  
  describe "compare" do
    context "images are identical" do
      it "should have a passed indicator in the diff" do
        screenshot.compare
        screenshot.diff.should eq [:passed, nil]
      end
    end
    
    context "images are different" do
      it "should have a failed indicator in the diff" do
        screenshot.stub!(:mask_reference)
        screenshot.test_path = "#{base_path}/reference/#{device[:screen]}/06_sign\ up_spinner_error.png"
        screenshot.compare
        screenshot.diff.should eq [:failed, "3017\n"]
      end
    end
  end
  
  describe "mask reference" do
    it "should create masked versions of reference screenshots" do
      screenshot.mask_reference
      
      File.exists?(screenshot.test_path).should be_true
      md5(File.read(screenshot.test_path)).should_not be_equal md5(File.read("#{base_path}/reference/#{device[:screen]}/06_sign\ up_spinner.png"))
    end
  end
end