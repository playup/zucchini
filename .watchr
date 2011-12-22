def run_spec(file)
  unless File.exist?(file)
    puts "#{file} does not exist"
    return
  end

  puts "Running #{file}"
  system "rspec #{file}"
  puts
end

watch("spec/.*/*.rb") do |match|
  run_spec match[0]
end

watch("^lib/(.*).rb") do |match|
  run_spec %{spec/lib/#{match[1]}_spec.rb}
end  