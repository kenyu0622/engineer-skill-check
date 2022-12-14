class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.references :employee, null: false
      t.string :title
      t.text :content
      t.datetime :deleted_at, null: true, default: nil

      t.timestamps
    end
  end
end
