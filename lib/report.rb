require 'erb'
require 'lib/report/view'

class Zucchini::Report

  def initialize(features, ci = false)
    @features, @ci = [features, ci]
    log text
  end

  def text
    @features.map do |f|
      failed_list = f.stats[:failed].empty? ? "" : "\n\nFailed:\n" + f.stats[:failed].map { |s| "   #{s.file_name}: #{s.diff[1]}" }.join
      summary     = f.stats.map { |key, set| "#{set.length.to_s} #{key}" }.join(", ")

      "#{f.name}:\n#{summary}#{failed_list}"
    end.join("\n\n")
  end

  def html(report_html_path = "/tmp/zucchini_report.html")
    template_path = File.expand_path("#{File.dirname(__FILE__)}/report/template.erb")

    view = Zucchini::ReportView.new(@features, @ci)
    html = (ERB.new(File.open(template_path).read)).result(view.get_binding)

    File.open(report_html_path, 'w+') { |f| f.write(html) }
    report_html_path
  end

  def open; system "open #{html}"; end
  def log(buf); puts buf; end

end
