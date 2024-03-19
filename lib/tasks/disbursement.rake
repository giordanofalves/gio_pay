#!/usr/bin/env bash
# usage e.g.: rake disbursement:process
namespace :disbursement do
  desc 'Process  disbursements'
  task :process => :environment do |t|
    puts 'Starting to process daily disbursements....'
    merchants    = Merchant.all
    progress_bar = ProgressBar.new(merchants.count)

    merchants.each do |merchant|
      progress_bar.increment!
      merchant.perform_disbursements
    end

    puts 'Disbursements Processed successfully!'
  end
end
