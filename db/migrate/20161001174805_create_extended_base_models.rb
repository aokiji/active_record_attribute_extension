class CreateExtendedBaseModels < ActiveRecord::Migration
  def change
    create_table :extended_base_models do |t|
      t.string "extra_field"
      t.references :base_model
      t.timestamps
    end
  end
end
