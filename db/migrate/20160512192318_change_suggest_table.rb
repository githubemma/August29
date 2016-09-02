class ChangeSuggestTable < ActiveRecord::Migration
  def change
    drop_table :suggest_pages if ActiveRecord::Base.connection.table_exists? :suggest_pages

    create_table :request_pages do |t|
      t.string  :text, limit: 255
      t.integer :status, limit: 1, :default => 0
      t.timestamps
    end
  end
end
