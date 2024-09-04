# Rails\portfolio\app\models\investment_portfolio.rb

class InvestmentPortfolio < ApplicationRecord
  has_many :investment_portfolios_stocks, dependent: :destroy # Añadir dependent: :destroy
  has_many :stocks, through: :investment_portfolios_stocks

  class Portfolio
    def initialize(stocks)
      @stocks = stocks
    end

    def profit(start_date, end_date)
      start_value = total_value_on(start_date)
      end_value = total_value_on(end_date)

      return 0 if start_value.zero? # Evitar división por cero

      end_value - start_value
    end

    def annualized_return(start_date, end_date)
      profit_value = profit(start_date, end_date)
      start_value = total_value_on(start_date)
      
      return 0 if start_value.zero? # Evitar división por cero

      years = (end_date - start_date).to_f / 365.25
      return 0 if years.zero? # Evitar división por cero

      (1 + profit_value / start_value) ** (1 / years) - 1
    end

    private

    def total_value_on(date)
      @stocks.sum { |stock| stock.price(date) || 0 }
    end
  end
end
