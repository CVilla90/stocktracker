class AddQuantityToInvestmentPortfoliosStocks < ActiveRecord::Migration[7.1]
  def change
    add_column :investment_portfolios_stocks, :quantity, :integer, default: 1, null: false
  end
end
