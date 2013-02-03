class Zucchini::Approver < Clamp::Command
  attr_reader :features
  
  parameter "PATH", "a path to feature or a directory"
  option %W(-p --pending), :flag, "update pending screenshots instead"

  def execute
    raise "Directory #{path} does not exist" unless File.exists?(path)

    @path = File.expand_path(path)
    Zucchini::Config.base_path = File.exists?("#{path}/feature.zucchini") ? File.dirname(path) : path

    raise "ZUCCHINI_DEVICE environment variable not set" unless ENV['ZUCCHINI_DEVICE']
    @device = Zucchini::Config.device(ENV['ZUCCHINI_DEVICE'])

    exit approve_features pending? ? "pending" : "reference"
  end

  def approve_features(reference_type)
  	features.each do |f|
      f.device = @device
      f.approve reference_type
    end
    features.inject(true){ |result, feature| result &= feature.succeeded }
  end

  def features
    @features ||= detect_features(@path)
  end

  def detect_features(path)
  	runner = Zucchini::Runner.new(nil)
  	runner.path = path
  	runner.features
  end
end
