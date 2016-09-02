class AddTwitterFeedTable < ActiveRecord::Migration
  def change

    create_table :twitter_feeds do |t|
      t.belongs_to :page, index: true
      t.string :hashtag
      t.string :widget
      t.string :title
    end

  end
end
