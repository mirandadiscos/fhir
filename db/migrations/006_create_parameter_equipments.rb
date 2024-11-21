Sequel.migration do
  change do
    create_table :parameter_equipments do
      primary_key :id
      foreign_key :parameter_id, :parameters, on_delete: :cascade
      foreign_key :equipment_id, :equipments, on_delete: :cascade
      String :equipment_code, size: 255
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
