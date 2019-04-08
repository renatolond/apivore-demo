class CreatePets < ActiveRecord::Migration[5.2]
  def change
    create_table :pets do |t|
      t.string :name
      t.string :photo_urls, array: true
      t.string :status

      t.timestamps
    end
  end
end
