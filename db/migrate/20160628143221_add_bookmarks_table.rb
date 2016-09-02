class AddBookmarksTable < ActiveRecord::Migration
  def change

    create_table :bookmarks do |t|
      t.belongs_to :user, index: true
      t.belongs_to :page, index: true
      t.timestamps
    end

  end
end
