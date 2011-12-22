class Zucchini::Generator < Clamp::Command
  option %W(-p --project), :flag, "Generate a project"
  option %W(-f --feature), :flag, "Generate a feature"
  
  parameter "PATH", "Path"
  
  def templates_path
    File.expand_path("#{File.dirname(__FILE__)}/../templates") 
  end
  
  def execute
    if project?
      FileUtils.mkdir_p(path)
      FileUtils.cp_r("#{templates_path}/project/.", path)
    elsif feature? then FileUtils.cp_r("#{templates_path}/feature", path)
    end
  end
end