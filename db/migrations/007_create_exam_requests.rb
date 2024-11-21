Sequel.migration do
  change do
    create_table :exam_requests do
      primary_key :id
      foreign_key :patient_id, :patients, on_delete: :cascade
      foreign_key :test_id, :tests, on_delete: :cascade
      String :requestor_code, size: 255
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
