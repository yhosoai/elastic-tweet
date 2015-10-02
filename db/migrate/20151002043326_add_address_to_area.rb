class AddAddressToArea < ActiveRecord::Migration
  def change
    add_column :areas, :address, :string
  end
end
