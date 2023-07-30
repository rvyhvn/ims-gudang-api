require 'sequel'
require 'faker'

DB = Sequel.connect(adapter: :postgres, host: 'localhost', user: 'postgres', password: '', database: 'ims_db')

DB.create_table?(:kategori) do
  primary_key :id_kategori
  String :nama_kategori, null: false
end

DB.create_table?(:pemasok) do
  primary_key :id_pemasok
  String :nama_pemasok, null: false
  String :domisili, null: false
end

DB.create_table?(:produk) do
  primary_key :id_produk
  foreign_key :kategori_id, :kategori, null: false
  foreign_key :pemasok_id, :pemasok, null: false
  String :nama_produk, null: false, size: 260
  String :kategori, null: false, size: 260
  Integer :quantity
  Float :harga_per_pcs
end

def seed_data
  10.times do
    nama_kategori = Faker::Commerce.department
    DB[:kategori].insert(nama_kategori: nama_kategori)
  end

  10.times do
    nama_pemasok = Faker::Company.name
    domisili = Faker::Address.city
    DB[:pemasok].insert(nama_pemasok: nama_pemasok, domisili: domisili)
  end

  10.times do
    kategori_id = rand(1..10) 
    pemasok_id = rand(1..10) 
    nama_produk = Faker::Commerce.product_name
    kategori = Faker::Commerce.department
    quantity = rand(1..100)
    harga_per_pcs = Faker::Commerce.price(range: 10.0..100.0)
    DB[:produk].insert(kategori_id: kategori_id, pemasok_id: pemasok_id, nama_produk: nama_produk, kategori: kategori, quantity: quantity, harga_per_pcs: harga_per_pcs)
  end
end

if ARGV.empty?
  puts "Usage: ruby seed.rb <command>"
  puts "Available commands: migrate, seed"
  exit
end

command = ARGV[0]

case command
when "migrate"
  DB.run "DROP TABLE IF EXISTS kategori, pemasok, produk"
  DB.run "DROP SEQUENCE IF EXISTS kategori_id_kategori_seq, pemasok_id_pemasok_seq, produk_id_produk_seq"
  puts "Database tables dropped (if existed)"
  puts "Running migrations..."
  DB.transaction do
    DB.create_table?(:kategori) do
      primary_key :id_kategori
      String :nama_kategori, null: false
    end

    DB.create_table?(:pemasok) do
      primary_key :id_pemasok
      String :nama_pemasok, null: false
      String :domisili, null: false
    end

    DB.create_table?(:produk) do
      primary_key :id_produk
      foreign_key :kategori_id, :kategori, null: false
      foreign_key :pemasok_id, :pemasok, null: false
      String :nama_produk, null: false, size: 260
      String :kategori, null: false, size: 260
      Integer :quantity
      Float :harga_per_pcs
    end
  end

  puts "Migrations completed!"
when "seed"
  puts "Seeding data..."
  seed_data
  puts "Seeding completed!"
else
  puts "Invalid command. Available commands: migrate, seed"
end
