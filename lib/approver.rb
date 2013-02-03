class Zucchini::Approver < Zucchini::Detector
  parameter "PATH", "a path to feature or a directory"
  
  option %W(-p --pending), :flag, "update pending screenshots instead"

  def run_command
    reference_type = pending? ? "pending" : "reference"
    features.each do |f|
      f.device = @device
      f.approve reference_type
    end
    features.inject(true){ |result, feature| result &= feature.succeeded }
  end
end