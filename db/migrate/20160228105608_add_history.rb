class AddHistory < ActiveRecord::Migration
  def change

    add_column :pages, :slug, :string
    add_index :pages, :slug

    create_table :report_histories do |t|
      t.string :history
      t.timestamps
    end

    create_table :suggest_histories do |t|
      t.string :history
      t.timestamps
    end

  end
end
