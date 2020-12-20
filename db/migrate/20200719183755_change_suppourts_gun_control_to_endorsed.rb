class ChangeSuppourtsGunControlToEndorsed < ActiveRecord::Migration[6.0]
  def change
    rename_column :bills, :suppourts_gun_control, :endorsed
  end
end
