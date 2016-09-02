class AddFolderTable < ActiveRecord::Migration
  def change

    create_table :folders do |t|
      t.string :name
    end

    create_table :page_to_folders do |t|
      t.belongs_to :page, index: true
      t.belongs_to :folder, index: true
    end
  end
end
