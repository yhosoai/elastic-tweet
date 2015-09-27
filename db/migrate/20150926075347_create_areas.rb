class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.float :latitude
      t.float :longitude
      t.float :radius

      t.timestamps null: false
    end
  end
end
