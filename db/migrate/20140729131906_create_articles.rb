class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.float :rating
      t.text :article_description
      t.integer :user_id

      t.timestamps
    end
  end
end
