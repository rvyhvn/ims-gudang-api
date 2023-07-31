require 'sinatra'
require 'sequel'
require 'json'

# Konfigurasi koneksi ke database PostgreSQL
DB = Sequel.connect(adapter: :postgres, host: 'localhost', user: 'postgres', password: '', database: 'ims_db')

# Model untuk tabel kategori
class Kategori < Sequel::Model(:kategori)
  one_to_many :produks, key: :kategori_id
end

# Model untuk tabel pemasok
class Pemasok < Sequel::Model(:pemasok)
  one_to_many :produks, key: :pemasok_id
end

# Model untuk tabel produk
class Produk < Sequel::Model(:produk)
  many_to_one :kategori, key: :kategori_id
  many_to_one :pemasok, key: :pemasok_id
end

# Menampilkan daftar kategori
get '/api/kategori' do
  content_type :json
  kategori = Kategori.all.map(&:values)
  kategori.to_json
end

# Menampilkan daftar pemasok
get '/api/pemasok' do
  content_type :json
  pemasok = Pemasok.all.map(&:values)
  pemasok.to_json
end

# Menampilkan daftar produk
get '/api/produk' do
  content_type :json
  produk = Produk.all.map(&:values)
  produk.to_json
end

# Menampilkan detail produk berdasarkan ID
get '/api/produk/:id' do
  content_type :json
  produk = Produk[params[:id]]
  if produk
    produk.to_json
  else
    status 404
    { message: 'Produk not found' }.to_json
  end
end

# Menampilkan daftar produk berdasarkan kategori ID
get '/api/produk/kategori/:kategori_id' do
  content_type :json
  kategori = Kategori[params[:kategori_id]]
  if kategori
    produk = kategori.produks
    produk.to_json
  else
    status 404
    { message: 'Kategori not found' }.to_json
  end
end

# Menampilkan daftar produk berdasarkan pemasok ID
get '/api/produk/pemasok/:pemasok_id' do
  content_type :json
  pemasok = Pemasok[params[:pemasok_id]]
  if pemasok
    produk = pemasok.produks
    produk.to_json
  else
    status 404
    { message: 'Pemasok not found' }.to_json
  end
end
