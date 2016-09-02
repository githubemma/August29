class Item < ActiveRecord::Base
  belongs_to :page
  has_many :columns, through: :item_to_columns
  has_many :item_to_columns, dependent: :destroy
  has_many :report_items, dependent: :destroy

  # upload image for item
  mount_uploader :img, ImageUploader

  # export items to CSV
  def self.to_csv(ids = {})
    require 'open-uri'

    CSV.generate do |csv|
      items = Item.joins('LEFT JOIN pages p ON p.id = items.page_id')
                  .joins('LEFT JOIN item_to_columns i2c ON p.id = i2c.page_id AND i2c.item_id = items.id')
                  .joins('LEFT JOIN columns c ON c.id = i2c.column_id')
                  .select('items.*, p.id AS pid, p.title AS page_title, c.name as column_name, c.id AS cid')
                  .where('items.id IN (?)', ids.split(",").map(&:to_i))
                  .order('pid ASC, c.name ASC, items.id ASC')

      csv << ['id', 'page', 'column', 'title', 'description', 'image', 'link']

      items.each do |item|
        csv << [item.id, item.page_title, item.column_name, item.title, item.description, item.img, item.link]

        # Download image
        # if download && item.img.url != ''
        #   image = open(item.img.url)
        #   IO.copy_stream(image, './' + item.img.file.filename)
        # end

      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      item = find_by_id(row["id"])
      page = Page.find_by(title: row['page'])
      column = Column.find_by(name: row['column'])

      puts item.inspect
      puts page.inspect
      puts column.inspect

      if page
        if item
          ItemToColumn.destroy_all(page_id: item.page_id, item_id: item.id)
        else
          item = Item.new
        end

        item.attributes = {
            page_id: page.id,
            title: (row['title'].present?) ? row['title'] : '',
            description: (row['description'].present?) ? row['description'] : '',
            link: (row['link'].present?) ? row['link'] : ''
        }

        item.save!

        if column
          col_page = ColumnToPage.find_by(column_id: column.id, page_id: page.id)

          if !col_page
            col_page = ColumnToPage.new
          end

          col_page.page_id = page.id
          col_page.column_id = column.id
          col_page.save!

          #####################

          col_item = ItemToColumn.find_by(page_id: item.page_id, item_id: item.id)

          if !col_item
            col_item = ItemToColumn.new
          end

          col_item.page_id = item.page_id
          col_item.column_id = column.id
          col_item.item_id = item.id
          col_item.save!
        end
      end

      # puts item.inspect

    end
  end

end
