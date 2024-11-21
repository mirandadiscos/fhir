Sequel.migration do
  change do
    create_table :parameters do
      primary_key :id
      foreign_key :test_id, :tests, on_delete: :cascade
      String :name, size: 255, null: false
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
