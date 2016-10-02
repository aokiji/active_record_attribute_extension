class CreateBaseModels < ActiveRecord::Migration
  def change
    create_table :base_models do |t|
      t.string  "string_field"
      t.integer "integer_field"
      t.timestamps
    end
  end
end
