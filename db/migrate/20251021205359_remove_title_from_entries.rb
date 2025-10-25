class RemoveTitleFromEntries < ActiveRecord::Migration[8.0]
  def change
    remove_column :entries, :title, :string
  end
end
