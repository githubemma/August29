class CreateArticlesTable < ActiveRecord::Migration
  def change

    create_table :articles do |t|
      t.string :header
      t.string :text
      t.integer :status, limit: 2, :default => 1
    end

  end
end
