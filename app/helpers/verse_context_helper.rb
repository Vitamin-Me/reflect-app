require "yaml"

module VerseContextHelper
  def verse_context(reference)
    data =
      if Rails.env.development?
        YAML.safe_load_file(Rails.root.join("config/verse_context.yml")) || {}
      else
        @verse_context_data ||= YAML.safe_load_file(Rails.root.join("config/verse_context.yml")) || {}
      end

    # Make lookups reliable
    data = data.transform_keys(&:to_s)
    data[reference.to_s] || {
      "author"   => "Unknown",
      "audience" => "General believers",
      "setting"  => "Context unavailable for this verse."
    }
  rescue Errno::ENOENT => e
    Rails.logger.error("Missing verse_context.yml: #{e.message}")
    { "author"=>"Unknown", "audience"=>"General believers", "setting"=>"Context unavailable." }
  end
end