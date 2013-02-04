require 'spec_helper'

describe Zucchini::Config do
  before(:all) { Zucchini::Config.base_path = "spec/sample_setup" }
  
  describe "device" do
    context "device present in config.yml" do
      it "should return the device hash" do
        Zucchini::Config.device("My iDevice").should eq({:name =>"My iDevice", :udid =>"lolffb28d74a6fraj2156090784avasc50725dd0", :screen =>"ipad_ios5"})
      end
    end
   
    context "device not present in config.yml" do
      it "should raise an error" do
        expect { Zucchini::Config.device("My Android Phone")}.to raise_error "Device not listed in config.yml"
      end
    end

    context "default device" do
      it "should use default device if device name argument is nil" do
        Zucchini::Config.device(nil).should eq({:name =>"Default Device", :screen =>"low_ios5", :udid => nil})
      end

      it "should raise error if no default device provided" do
        Zucchini::Config.base_path = "spec/sample_setup_2"
        expect { Zucchini::Config.device(nil) }.to raise_error "Neither default device nor ZUCCHINI_DEVICE environment variable was set"
      end
    end
  end
  
  describe "url" do
    it "should return a full URL string for a given server name" do
      Zucchini::Config.url('backend', '/api').should eq "http://192.168.1.2:8080/api"
    end
  end
end