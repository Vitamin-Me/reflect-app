class AddVerseTextToEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :entries, :verse_text, :text
  end
end
