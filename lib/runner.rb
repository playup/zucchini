class Zucchini::Runner < Clamp::Command
  attr_reader :features
  
  parameter "PATH", "a path to feature or a directory to run"
  
  option %W(-c --collect), :flag, "only collect the screenshots from the device"
  option %W(-p --compare), :flag, "perform screenshots comparison based on the last collection"
  option "--ci",           :flag, "produce a CI version of the report after comparison"

  def execute
    raise "Directory #{path} does not exist" unless File.exists?(path)
    
    @path = File.expand_path(path)
    Zucchini::Config.base_path = File.exists?("#{path}/feature.zucchini") ? File.dirname(path) : path
      
    raise "ZUCCHINI_DEVICE environment variable not set" unless ENV['ZUCCHINI_DEVICE']
    @device = Zucchini::Config.device(ENV['ZUCCHINI_DEVICE'])   
    
    @template = detect_template
    
    exit run 
  end
  
  def run
    compare_threads = {}
    
    features.each do |f|
      f.device   = @device
      f.template = @template
      
      if    collect? then f.collect
      elsif compare? then f.compare
      else  f.collect; compare_threads[f.name] = Thread.new { f.compare }
      end
    end
    
    compare_threads.each { |name, t| t.abort_on_exception = true; t.join }
    
    Zucchini::Report.present(features, ci?) unless (collect? && !compare?)
    features.inject(true){ |result, feature| result &= feature.succeeded }
  end
  
  def features
    @features ||= detect_features(@path)
  end
  
  def detect_features(path)
    features = []
    if File.exists?("#{path}/feature.zucchini")
      features << Zucchini::Feature.new(path)
    else
      raise detection_error(path) if Dir["#{path}/*"].empty?
      
      Dir.glob("#{path}/*").each do |dir|
          unless dir.match /support/
          if File.exists?("#{dir}/feature.zucchini")
            features << Zucchini::Feature.new(dir)
          else
            raise detection_error(dir)
          end
        end
      end
    end
    features
  end
  
  def detection_error(path)
    "#{path} is not a feature directory"
  end
  
  def detect_template
    path  = `xcode-select -print-path`.gsub(/\n/, '')
    path += "/Platforms/iPhoneOS.platform/Developer/Library/Instruments/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate"
    raise "Instruments template at #{path} does not exist" unless File.exists? path
    path
  end
end
