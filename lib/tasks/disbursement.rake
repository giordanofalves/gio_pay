#!/usr/bin/env bash
# usage e.g.: rake disbursement:process
namespace :disbursement do
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
