# Rails\portfolio\app\models\stock.rb

class Stock < ApplicationRecord
  has_many :investment_portfolios_stocks
  has_many :investment_portfolios, through: :investment_portfolios_stocks

  # Método para simular el precio de una acción en una fecha dada
  def price(date)
    base_prices = {
      'AAPL' => 150.0,
      'GOOGL' => 2800.0,
      'AMZN' => 3400.0,
      'MSFT' => 300.0,
      'SSNLF' => 70.0,
      'XIAOMI' => 25.0,
      'SONY' => 100.0,
      'HUAWEI' => 50.0
    }
  
    base_price = base_prices[name] || 100.0
    random_factor = rand(-0.05..0.05) # Fluctuación simulada del -5% al +5%
    simulated_price = (base_price * (1 + random_factor)).round(2)
  
    puts "Simulated price for #{name} on #{date}: #{simulated_price}" # Debugging
    
    simulated_price
  end  
end
