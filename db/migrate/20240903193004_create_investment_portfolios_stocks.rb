# Rails\portfolio\db\migrate\20240903193004_create_investment_portfolios_stocks.rb

class CreateInvestmentPortfoliosStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :investment_portfolios_stocks do |t|
      t.references :investment_portfolio, null: false, foreign_key: true
      t.references :stock, null: false, foreign_key: true
      t.decimal :added_price, precision: 10, scale: 2 # Precisión y escala especificadas

      t.timestamps
    end
  end
end
