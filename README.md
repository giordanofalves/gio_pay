# GioPay

A merchants payments process system

## Getting Started

```sh
./bin/setup
```

### Prerequisites

What things you need to install the software and how to install them:

- Ruby version: 3.2.3

You can find the installation instructions for Ruby [here](https://www.ruby-lang.org/en/documentation/installation/).

### Import data

How to import the initial data and print a report with the data.

* Import and print report(Could take some time):
  ```sh
  ./bin/prepare_report
  ```

## Running the tests

Explain how to run the automated tests for this system:

```sh
rspec spec
```

## Initial report data

| Year | Number of disbursements | Amount disbursed to merchants | Amount of order fees | Number of monthly fees charged (From minimum monthly fee) | Amount of monthly fee charged (From minimum monthly fee) |
|------|-------------------------|-------------------------------|----------------------|-----------------------------------------------------------|----------------------------------------------------------|
| 2022 | 1548                    | €38,822,965.06                | €350,774.67          | 19                                                        | €340.64                                                  |
| 2023 | 10352                   | €186,670,954.85               | €1,692,163.33        | 116                                                       | €1,941.67                                                |


## My approach

It was a great challenge to work with, I'll describe how I work during this process

1. Generated a new rails project with a newsest version;
2. Start to create the Merchant and Order structure, also setup a basic rspec build to test;
3. Import Merchant and Orders
  3.1. Work in the rake task import of the initial Merchant and Orders, the trickiest part here was how to handle this number of orders that I've on csv file;
  3.2. First I did a basic loop and saving each record parsing the line from csv, but when I run it to orders it took really long time;
  3.3. So I change it to return all data parsed and use insert_all as command, this had some impact on the disbursements work I ddid later;
4. Processes disbursements
  4.1. Create the disbursement model and associations;
  4.2. Created a payment model that I removed later;
  4.3 The trickiest part here were to group the orders by merchant disbursement_frequency, the daily was ok, but the week by the same day as live_on took me some time to find a solution;
5. Long time since I did some frontend work, as I saw some videos about hotwire, I did a very basic implementation of a chart updated by date period.
  It was just to me to understand how hotwire works, so you can ignore the visual of the views;
6. Monthly fee calculation, it was ok to get the logic ready, I added a report task to show the same table I wrote in the initial report data above.

As I said, a very good challenge to work on, I did some work to add sidekiq to handle the importer of orders, but I did remove it when I implement the monthly fee check, I had some problems on the concorrent threads looking for the same check at same time and creating wrong monthly_fees records;
