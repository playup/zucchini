require 'spec_helper'

describe Zucchini::Report do
  let (:device) { { :name => "iPad 2", :screen => "ipad_ios5", :udid => "rspec012345" } }
  let (:feature) do
    fake_screenshots = (1..7).to_a.map do |num|
      screenshot = Zucchini::Screenshot.new("#{num}.screen_#{num}.png", device)
      screenshot.diff = (num > 3) ? [:passed, nil] : [:failed, "120\n"]
      screenshot
    end

    feature = Zucchini::Feature.new("/my/sample/feature")
    feature.device = device
    feature.stub!(:screenshots).and_return(fake_screenshots)
    feature
  end

  let(:html_path) { '/tmp/zucchini_rspec_report.html' }
  after           { FileUtils.rm(html_path) }

  subject { Zucchini::Report.new([feature], false, html_path) }
  before  { Zucchini::Report.any_instance.stub(:log) }

  its(:text) { should eq "feature:\n4 passed, 3 failed, 0 pending\n\nFailed:\n   1.screen_1.png: 120\n   2.screen_2.png: 120\n   3.screen_3.png: 120\n" }

  it "should produce a a correct HTML report" do
    report = subject.html
    report.scan(/<dl class="passed.*screen/).length.should eq 4
    report.scan(/<dl class="failed.*screen/).length.should eq 3
  end
end
