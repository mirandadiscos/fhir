Sequel.migration do
  change do
    create_table :patients do
      primary_key :id
      String :name, null: false
      Date :dob
      String :gender, size: 10
      Text :contact_info
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
