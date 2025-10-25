class AddTitleToEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :entries, :title, :string
  end
end
