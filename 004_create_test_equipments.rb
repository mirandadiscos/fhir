Sequel.migration do
  change do
    create_table :test_equipments do
      primary_key :id
      foreign_key :test_id, :tests, on_delete: :cascade
      foreign_key :equipment_id, :equipments, on_delete: :cascade
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
