class CreateInvestmentPortfolios < ActiveRecord::Migration[7.1]
  def change
    create_table :investment_portfolios do |t|
      t.string :name

      t.timestamps
    end
  end
end
