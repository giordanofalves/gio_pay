#!/usr/bin/env bash
require 'csv'

# usage e.g.: rake disbursement:process
namespace :disbursement do
  # desc 'Import Merchants from a CSV file'
  # task :daily => :environment do |t|
  #   puts 'Starting to import merchants....'
  #   merchants    = []
  #   csv_data     = CSV.foreach(args[:file], col_sep: ';', headers: true)
  #   progress_bar = ProgressBar.new(csv_data.count)

  #   csv_data.each do |row|
  #     merchants << parse_merchant_data(row.to_hash)
  #     progress_bar.increment!
  #   end

  #   puts "Inserting #{merchants.count} merchants into the database...."
  #   Merchant.insert_all(merchants)

  #   puts 'Merchants imported successfully!'
  # end
  desc 'Process  disbursements'
  task :process => :environment do |t|
    puts 'Starting to process daily disbursements....'

    # Get all pending orders
    merchants    = Merchant.all
    progress_bar = ProgressBar.new(merchants.count)

    # move it to a background job
    merchants.each do |merchant|
      progress_bar.increment!
      merchant.perform_disbursements
    end

    puts 'All disbursements are queued to process now'
  end
end
