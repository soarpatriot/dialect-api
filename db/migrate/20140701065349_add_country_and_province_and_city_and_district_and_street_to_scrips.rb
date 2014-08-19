class AddCountryAndProvinceAndCityAndDistrictAndStreetToScrips < ActiveRecord::Migration
  def change
    add_column :scrips, :country, :string
    add_column :scrips, :province, :string
    add_column :scrips, :city, :string
    add_column :scrips, :district, :string
    add_column :scrips, :street, :string
  end
end
