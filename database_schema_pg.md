
# Banco de Dados - Estrutura do Sistema de Análises Clínicas

Este documento descreve a estrutura do banco de dados para o sistema de análises clínicas, incluindo as tabelas de pacientes, exames, equipamentos, parâmetros e resultados.

## 1. Tabela de Pacientes (patients)

Esta tabela armazena as informações dos pacientes.

```sql
CREATE TABLE patients (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,  -- Nome do paciente
    dob DATE,  -- Data de nascimento
    gender VARCHAR(10),  -- Gênero do paciente
    contact_info TEXT,  -- Informações de contato
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 2. Tabela de Exames (tests)

Esta tabela armazena os exames disponíveis no sistema.

```sql
CREATE TABLE tests (
    id SERIAL PRIMARY KEY,
    code VARCHAR(255) UNIQUE NOT NULL,  -- Código (mnemônico) do exame, como HEMOGRAMA, VLDL, etc
    name VARCHAR(255) NOT NULL,  -- Nome do exame (ex: Hemograma, VLDL)
    description TEXT,  -- Descrição do exame
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 3. Tabela de Equipamentos (equipments)

Esta tabela armazena os equipamentos disponíveis no laboratório.

```sql
CREATE TABLE equipments (
    id SERIAL PRIMARY KEY,
    code VARCHAR(255) UNIQUE NOT NULL,  -- Código único do equipamento
    name VARCHAR(255) NOT NULL,  -- Nome do equipamento (ex: Analisador X, Máq. Hemograma)
    manufacturer VARCHAR(255),
    model VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 4. Tabela de Exames por Equipamento (test_equipments)

Esta tabela mapeia os exames que cada equipamento pode realizar.

```sql
CREATE TABLE test_equipments (
    id SERIAL PRIMARY KEY,
    test_id INTEGER REFERENCES tests(id) ON DELETE CASCADE,  -- Exame
    equipment_id INTEGER REFERENCES equipments(id) ON DELETE CASCADE,  -- Equipamento
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 5. Tabela de Parâmetros (parameters)

Esta tabela armazena os parâmetros de cada exame.

```sql
CREATE TABLE parameters (
    id SERIAL PRIMARY KEY,
    test_id INTEGER REFERENCES tests(id) ON DELETE CASCADE,  -- Exame ao qual o parâmetro pertence
    name VARCHAR(255) NOT NULL,  -- Nome do parâmetro (ex: Hemoglobina)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 6. Tabela de Parâmetros por Equipamento (parameter_equipments)

Aqui associamos os parâmetros aos equipamentos, com o código específico de cada equipamento.

```sql
CREATE TABLE parameter_equipments (
    id SERIAL PRIMARY KEY,
    parameter_id INTEGER REFERENCES parameters(id) ON DELETE CASCADE,  -- Parâmetro
    equipment_id INTEGER REFERENCES equipments(id) ON DELETE CASCADE,  -- Equipamento
    equipment_code VARCHAR(255),  -- Código específico do equipamento para este parâmetro
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 7. Tabela de Exames Solicitados (exam_requests)

Esta tabela armazena os exames solicitados para cada paciente.

```sql
CREATE TABLE exam_requests (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(id) ON DELETE CASCADE,  -- Referência ao paciente
    test_id INTEGER REFERENCES tests(id) ON DELETE CASCADE,  -- Exame solicitado
    requestor_code VARCHAR(255),  -- Código do solicitante (ex: código do médico, clínica, etc.)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 8. Tabela de Resultados de Exames (observations)

A tabela de resultados agora está relacionada ao paciente, exame, equipamento e parâmetros.

```sql
CREATE TABLE observations (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(id) ON DELETE CASCADE,  -- Referência ao paciente
    exam_request_id INTEGER REFERENCES exam_requests(id) ON DELETE CASCADE,  -- Exame solicitado
    equipment_id INTEGER REFERENCES equipments(id) ON DELETE CASCADE,  -- Equipamento que fez o exame
    fhir_id VARCHAR(255) UNIQUE NOT NULL,  -- ID único FHIR para o resultado
    value VARCHAR(255),  -- Valor do resultado (pode ser numérico ou texto)
    unit VARCHAR(50),  -- Unidade do resultado (ex: mg/dL, mmHg)
    reference_range VARCHAR(255),  -- Intervalo de referência
    status VARCHAR(50),  -- Status do resultado (ex: final, em andamento, etc)
    effective_date TIMESTAMP,  -- Data de realização do exame
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Fluxo Completo de Uso:

### 1. Cadastrar Pacientes
```sql
INSERT INTO patients (name, dob, gender, contact_info)
VALUES ('João da Silva', '1985-06-15', 'Masculino', 'joao.silva@email.com');
```

### 2. Cadastrar Exames
```sql
INSERT INTO tests (code, name) VALUES ('HEMOGRAMA', 'Hemograma');
INSERT INTO tests (code, name) VALUES ('VLDL', 'VLDL');
```

### 3. Cadastrar Equipamentos
```sql
INSERT INTO equipments (code, name) VALUES ('EQ12345', 'Analisador de Hemograma');
INSERT INTO equipments (code, name) VALUES ('EQ67890', 'Analisador de VLDL');
```

### 4. Associar Exames a Equipamentos
```sql
INSERT INTO test_equipments (test_id, equipment_id) VALUES (1, 1);  -- Hemograma -> Analisador de Hemograma
INSERT INTO test_equipments (test_id, equipment_id) VALUES (2, 2);  -- VLDL -> Analisador de VLDL
```

### 5. Cadastrar Parâmetros de Exame
```sql
INSERT INTO parameters (test_id, name) VALUES (1, 'Hemoglobina');
INSERT INTO parameters (test_id, name) VALUES (2, 'Triacilgliceróis');
INSERT INTO parameters (test_id, name) VALUES (2, 'Glucose');
```

### 6. Associar Parâmetros a Equipamentos
```sql
INSERT INTO parameter_equipments (parameter_id, equipment_id, equipment_code) 
VALUES (1, 1, 'HEMO001');  -- Hemoglobina com código específico do equipamento
INSERT INTO parameter_equipments (parameter_id, equipment_id, equipment_code) 
VALUES (2, 2, 'TRI001');  -- Triacilgliceróis com código específico do equipamento
INSERT INTO parameter_equipments (parameter_id, equipment_id, equipment_code) 
VALUES (3, 2, 'GLU001');  -- Glucose com código específico do equipamento
```

### 7. Registrar Solicitação de Exame
```sql
INSERT INTO exam_requests (patient_id, test_id, requestor_code)
VALUES (1, 1, 'MED123');  -- João solicitou o exame HEMOGRAMA com código MED123
```

### 8. Registrar Resultado do Exame
```sql
INSERT INTO observations (patient_id, exam_request_id, equipment_id, fhir_id, value, unit, reference_range, status, effective_date)
VALUES (1, 1, 1, 'FHIR_OBS_001', '12.5', 'g/dL', '12-16 g/dL', 'final', CURRENT_TIMESTAMP);
```
