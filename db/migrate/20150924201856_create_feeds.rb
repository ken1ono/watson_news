class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :title
      t.text :url
      t.text :desc
      t.date :created

      t.timestamps null: false
    end
  end
end
