class CreateTips < ActiveRecord::Migration
  def up
    create_table :tips do |t|
      t.string :name
      t.text :content
      t.string :category

      t.timestamps null: false
    end
  end

  def down
    drop_table :tips
  end
end
