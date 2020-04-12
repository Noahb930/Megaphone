class UpdateRepresentatives < ActiveRecord::Migration[6.0]
  def change
    add_column :representatives, :email, :string
    add_column :representatives, :party, :string
    add_column :representatives, :rating, :string
    add_column :representatives, :img, :string
    add_column :representatives, :profession, :string
    add_column :representatives, :url, :string
  end
end
