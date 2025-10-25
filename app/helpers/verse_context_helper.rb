require "yaml"

module VerseContextHelper
  def verse_context(reference)
    # Reload YAML on each request in development, cache in production
    if Rails.env.development?
      verse_data = YAML.load_file(Rails.root.join("config/verse_context.yml"))
    else
      @verse_data ||= YAML.load_file(Rails.root.join("config/verse_context.yml"))
    end

    verse_data[reference] || {
      "author" => "Unknown",
      "audience" => "General believers",
      "setting" => "Context unavailable for this verse."
    }
  end
end