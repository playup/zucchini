require 'time'

class Zucchini::ReportView
  
  def initialize(features, ci)
    @features    = features
    @device      = features[0].device
    @time        = Time.now.strftime("%T, %e %B %Y")
    @assets_path = File.expand_path(File.dirname(__FILE__))
    @ci          = ci ? 'ci' : ''
  end
  
  def get_binding
    binding
  end
end