class Zucchini::Screenshot
  ORIENTATION = /^\d\d_(?<orientation>(Unknown|Portrait|PortraitUpsideDown|LandscapeLeft|LandscapeRight|FaceUp|FaceDown))_.*$/

  attr_reader   :file_path, :file_name
  attr_accessor :diff, :masks_paths, :masked_paths, :test_path, :diff_path

  def initialize(file_path, device, unmatched_pending = false)
    file_name = File.basename(file_path)
    @device    = device

    @orientation = (match = ORIENTATION.match(file_name)) ? match[:orientation] : nil
    if @orientation
      @original_file_path = file_path
      @file_name = file_name.gsub("_#{@orientation}", '')
      @file_path = File.join(File.dirname(file_path),@file_name)
    else
      @file_name = file_name
      @file_path = file_path
    end

    unless unmatched_pending
      file_base_path = File.dirname(@file_path)

      @masks_paths = {
        :global   => "#{file_base_path}/../../../support/masks/#{@device[:screen]}.png",
        :specific => "#{file_base_path}/../../masks/#{@device[:screen]}/#{@file_name}"
      }

      masked_path   = "#{file_base_path}/../Masked/actual/#{@file_name}"
      @masked_paths = { :globally => masked_path, :specifically => masked_path }

      @diff_path = "#{file_base_path}/../Diff/#{@file_name}"
    end
  end

  def rotate
    return unless @orientation
    degrees = case @orientation
    when 'LandscapeRight' then 90
    when 'LandscapeLeft' then 270
    when 'PortraitUpsideDown' then 180
    else
      0
    end
    `convert \"#{@original_file_path}\" -rotate \"#{degrees}\" \"#{@file_path}\"`
    FileUtils.rm @original_file_path
  end

  def mask
    @masked_paths.each { |name, path| FileUtils.mkdir_p(File.dirname(path)) }
    `convert -page +0+0 \"#{@file_path}\" -page +0+0 \"#{@masks_paths[:global]}\" -flatten \"#{@masked_paths[:globally]}\"`

    if File.exists?(@masks_paths[:specific])
      `convert -page +0+0 \"#{@masked_paths[:globally]}\" -page +0+0 \"#{@masks_paths[:specific]}\" -flatten \"#{@masked_paths[:specifically]}\"`
    end
  end

  def compare
    mask_reference

    if @test_path
      FileUtils.mkdir_p(File.dirname(@diff_path))

      compare_command = "compare -metric AE -fuzz 2% -dissimilarity-threshold 1 -subimage-search"
      out = `#{compare_command} \"#{@masked_paths[:specifically]}\" \"#{@test_path}\" \"#{@diff_path}\" 2>&1`
      @diff = (out == "0\n") ? [:passed, nil] : [:failed, out]
      @diff = [:pending, @diff[1]] if @pending
    else
      @diff = [:failed, "no reference or pending screenshot for #{@device[:screen]}\n"]
    end
  end

  def result_images
    @result_images ||= {
      :actual     => @masked_paths && File.exists?(@masked_paths[:specifically]) ? @masked_paths[:specifically] : nil,
      :expected   => @test_path    && File.exists?(@test_path) ? @test_path : nil,
      :difference => @diff_path    && File.exists?(@diff_path) ? @diff_path : nil
    }
  end

  def mask_reference
    file_base_path = File.dirname(@file_path)
    %W(reference pending).each do |reference_type|
      reference_file_path = "#{file_base_path}/../../#{reference_type}/#{@device[:screen]}/#{@file_name}"
      output_path         = "#{file_base_path}/../Masked/#{reference_type}/#{@file_name}"

      if File.exists?(reference_file_path)
        @test_path = output_path
        @pending   = (reference_type == "pending")
        FileUtils.mkdir_p(File.dirname(output_path))

        reference = Zucchini::Screenshot.new(reference_file_path, @device)
        reference.masks_paths  = @masks_paths
        reference.masked_paths = { :globally => output_path, :specifically => output_path }
        reference.mask
      end
    end
  end

end
