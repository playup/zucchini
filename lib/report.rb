require 'erb'
require 'lib/report/view'

class Zucchini::Report

  def initialize(features, ci = false, html_path = '/tmp/zucchini_report.html')
    @features, @ci, @html_path = [features, ci, html_path]
    generate!
  end

  def text
    @features.map do |f|
      failed_list = f.stats[:failed].empty? ? "" : "\n\nFailed:\n" + f.stats[:failed].map { |s| "   #{s.file_name}: #{s.diff[1]}" }.join
      summary     = f.stats.map { |key, set| "#{set.length.to_s} #{key}" }.join(", ")

      "#{f.name}:\n#{summary}#{failed_list}"
    end.join("\n\n")
  end

  def html
    @html ||= begin
      template_path = File.expand_path("#{File.dirname(__FILE__)}/report/template.erb")

      view = Zucchini::ReportView.new(@features, @ci)
      compiled = (ERB.new(File.open(template_path).read)).result(view.get_binding)

      File.open(@html_path, 'w+') { |f| f.write(compiled) }
      compiled
    end
  end

  def generate!
    log text
    html
  end

  def open; system "open #{@html_path}"; end

  def log(buf); puts buf; end

end
