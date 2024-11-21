Sequel.migration do
  change do
    create_table :tests do
      primary_key :id
      String :code, size: 255, unique: true, null: false
      String :name, size: 255, null: false
      Text :description
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
