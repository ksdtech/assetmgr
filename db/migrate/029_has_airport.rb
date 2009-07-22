class HasAirport < ActiveRecord::Migration
  def self.up
    add_column :assets, :has_airport, :boolean
  end

  def self.down
    remove_column :assets, :has_airport, :boolean
  end
end
