#!/usr/bin/env bash
# require "terminal-table"
# usage e.g.: rake report:by_year
namespace :report do
  desc 'Report the numbers/amount of disbursements and monthly fees per year'
  task :by_year => :environment do
    monthly_fees  = MonthlyFee.all.group_by_year { |u| u.month }.to_h { |k, v| [k.strftime("%Y"), { total: v.count, amount: format_currency(v.pluck(:amount).sum) } ] }
    disbursements = Disbursement.all.group_by_year { |u| u.created_at }
    rows =
      disbursements.map do |k, v|
        [k.strftime("%Y"),
         v.count,
         format_currency(v.pluck(:amount).sum),
         format_currency(v.pluck(:fee).sum),
         monthly_fees[k.strftime("%Y")][:total],
         monthly_fees[k.strftime("%Y")][:amount]]
      end

    headings = ['Year',	'Number of disbursements',	'Amount disbursed to merchants',	'Amount of order fees',	'Number of monthly fees charged (From minimum monthly fee)', 'Amount of monthly fee charged (From minimum monthly fee)']
    table    = Terminal::Table.new(headings: headings, rows: rows)
    puts table

  end

  private

  def format_currency(value)
    ActionController::Base.helpers.number_to_currency(value, unit: "€")
  end
end
