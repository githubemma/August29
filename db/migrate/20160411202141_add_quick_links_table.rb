class AddQuickLinksTable < ActiveRecord::Migration
  def change

    create_table :quick_links do |t|
      t.belongs_to :page, index: true
      t.string :text
      t.string :link
      t.integer :status, limit: 2, :default => 1
    end

  end
end
