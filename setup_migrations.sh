#!/bin/bash

# Variáveis
PROJECT_DIR=$(pwd)
DB_DIR="$PROJECT_DIR/db"
MIGRATIONS_DIR="$DB_DIR/migrations"
DB_NAME="lab_clinico"
DB_USER="postgres"
DB_HOST="localhost"

# Criação dos diretórios
echo "Criando estrutura de diretórios..."
mkdir -p "$MIGRATIONS_DIR"

# Criação das migrations
echo "Criando migrations..."

# Migration 001 - Criação da tabela patients
cat <<EOL > "$MIGRATIONS_DIR/001_create_patients.rb"
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
EOL

# Migration 002 - Criação da tabela tests
cat <<EOL > "$MIGRATIONS_DIR/002_create_tests.rb"
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
EOL

# Migration 003 - Criação da tabela equipments
cat <<EOL > "$MIGRATIONS_DIR/003_create_equipments.rb"
Sequel.migration do
  change do
    create_table :equipments do
      primary_key :id
      String :code, size: 255, unique: true, null: false
      String :name, size: 255, null: false
      String :manufacturer, size: 255
      String :model, size: 255
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
EOL

# Migration 004 - Criação da tabela test_equipments
cat <<EOL > "$MIGRATIONS_DIR/004_create_test_equipments.rb"
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
EOL

# Migration 005 - Criação da tabela parameters
cat <<EOL > "$MIGRATIONS_DIR/005_create_parameters.rb"
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
EOL

# Migration 006 - Criação da tabela parameter_equipments
cat <<EOL > "$MIGRATIONS_DIR/006_create_parameter_equipments.rb"
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
EOL

# Migration 007 - Criação da tabela exam_requests
cat <<EOL > "$MIGRATIONS_DIR/007_create_exam_requests.rb"
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
EOL

# Migration 008 - Criação da tabela observations
cat <<EOL > "$MIGRATIONS_DIR/008_create_observations.rb"
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
EOL

# Confirmação
echo "Estrutura de diretórios e migrations criadas com sucesso!"
