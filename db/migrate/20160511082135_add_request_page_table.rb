class AddRequestPageTable < ActiveRecord::Migration
  def change
    create_table :suggest_pages do |t|
      t.string :name
    end
  end
end
