require 'rake'
require 'sequel'
require 'pg'

# Configuração do banco de dados
DB_CONFIG = {
  adapter: 'postgres',
  host: 'localhost',
  database: 'lab_clinico',
  user: 'postgres',
  password: 'password'
}

# Conectar ao banco de dados 'postgres' para criar o banco de dados inicial
def create_database
  conn = PG.connect(host: DB_CONFIG[:host], dbname: 'postgres', user: DB_CONFIG[:user], password: DB_CONFIG[:password])
  begin
    conn.exec("CREATE DATABASE #{DB_CONFIG[:database]}")
    puts "Banco de dados '#{DB_CONFIG[:database]}' criado com sucesso."
  rescue PG::Error => e
    if e.message.include?("already exists")
      puts "Banco de dados '#{DB_CONFIG[:database]}' já existe."
    else
      raise e
    end
  ensure
    conn.close if conn
  end
end

# Conexão ao banco de dados do projeto
def connect_to_db
  Sequel.connect(DB_CONFIG)
end

# Namespace de banco de dados
namespace :db do
  # Tarefa de setup para criar o banco de dados
  task :setup do
    # Criar o banco de dados se não existir
    create_database
  end

  # Tarefa de migração para ler e executar as migrations
  task :migrate => :setup do
    # Conectar ao banco de dados após ser criado
    DB = connect_to_db

    # Caminho para as migrations
    migrations_dir = 'db/migrations'

    # Executando as migrations
    Sequel.extension :migration
    Sequel::Migrator.run(DB, migrations_dir)

    puts "Migrations executadas com sucesso."
  end
end
