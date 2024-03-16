#!/usr/bin/env bash
require 'csv'

# usage e.g.: rake 'import:merchants[lib/fixtures/merchants.csv]'
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
  desc 'Process daily disbursements'
  task :process_daily_disbursements => :environment do |t|
    puts 'Starting to process daily disbursements....'

    # Get all pending orders
    pending_orders = Order.joins(:merchant).pending
    merchants      = pending_orders.group_by(&:merchant_reference)
    progress_bar   = ProgressBar.new(merchants.count)

    merchants.each do |merchant_reference, orders|
      merchant = Merchant.find_by(reference: merchant_reference)

      merchant.daily? ? perform_daily_disbursement(merchant, orders) : perform_weekly_disbursement(merchant, orders)

      progress_bar.increment!
    end

    puts 'Disbursements processed successfully!'
  end

  private

  def perform_daily_disbursement(merchant, orders)
    orders.group_by(&:created_at).each do |date, orders|
      process_disbursements(merchant, date, orders)
    end
  end

  def perform_weekly_disbursement(merchant, orders)
    start_week_day = merchant.live_on.strftime("%A").downcase.to_sym

    orders.group_by { |order| order.created_at.beginning_of_week(start_day = start_week_day) }.each do |date, orders|
      process_disbursements(merchant, date, orders)
    end
  end

  def process_disbursements(merchant, date, orders)
    merchant.disbursements.create(amount: orders.sum(&:amount), created_at: date)
  end
end
