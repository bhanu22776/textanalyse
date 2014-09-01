class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :emotion
      t.text :message
      t.string :polarity
      t.string :probability
      t.string :sentiment

      t.timestamps
    end
  end
end
