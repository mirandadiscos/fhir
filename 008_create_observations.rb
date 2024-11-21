Sequel.migration do
  change do
    create_table :observations do
      primary_key :id
      foreign_key :patient_id, :patients, on_delete: :cascade
      foreign_key :exam_request_id, :exam_requests, on_delete: :cascade
      foreign_key :equipment_id, :equipments, on_delete: :cascade
      String :fhir_id, size: 255, unique: true, null: false
      String :value, size: 255
      String :unit, size: 50
      String :reference_range, size: 255
      String :status, size: 50
      DateTime :effective_date
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
