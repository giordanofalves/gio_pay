#!/usr/bin/env bash
require 'csv'

# usage e.g.: rake 'import:merchants[lib/fixtures/merchants.csv]'
namespace :import do
  desc 'Import Merchants from a CSV file'
  task :merchants, [:file] => :environment do |t, args|
    puts 'Starting to import merchants....'
    merchants    = []
    csv_data     = CSV.foreach(args[:file], col_sep: ';', headers: true)
    progress_bar = ProgressBar.new(csv_data.count)

    csv_data.each do |row|
      merchants << parse_merchant_data(row.to_hash)
      progress_bar.increment!
    end

    puts "Inserting #{merchants.count} merchants into the database...."
    Merchant.insert_all(merchants)

    puts 'Merchants imported successfully!'
  end

  # usage e.g.: rake 'import:orders[lib/fixtures/orders.csv]'
  desc 'Import Orders from a CSV file'
  task :orders, [:file] => :environment do |t, args|
    puts 'Starting to process orders....'

    orders       = []
    csv_data     = CSV.foreach(args[:file], col_sep: ';', headers: true)
    progress_bar = ProgressBar.new(csv_data.count)

    csv_data.each do |row|
      orders << parse_order_data(row.to_hash)
      progress_bar.increment!
    end

    progress_bar = ProgressBar.new(orders.count)
    puts "Inserting #{orders.count} orders into the database...."

    orders.each_slice(1000) do |batch|
      Order.insert_all(batch)
      progress_bar.increment!(batch.count)
    end

    puts 'Orders imported successfully!'
  end

  private

  def parse_merchant_data(row)
    row["guid"]                   = row.delete("id")
    row["disbursement_frequency"] = row["disbursement_frequency"].downcase

    row
  end

  def parse_order_data(row)
    row["guid"] = row.delete("id")
    row
  end
end
