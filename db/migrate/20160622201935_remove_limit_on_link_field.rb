class RemoveLimitOnLinkField < ActiveRecord::Migration
  def change
    change_column :items, :link, :string, :limit => nil
  end
end
