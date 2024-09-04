# app/models/investment_portfolios_stock.rb

class InvestmentPortfoliosStock < ApplicationRecord
    belongs_to :investment_portfolio
    belongs_to :stock
  
    # Validaciones
    validates :added_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :quantity, presence: true, numericality: { greater_than: 0 }
  
    # Callbacks para depuración
    after_initialize :log_initialization
    before_save :log_before_save
    after_save :log_after_save
  
    private
  
    # Log cuando se inicializa el objeto
    def log_initialization
      puts "Initialized InvestmentPortfoliosStock: Stock ID: #{stock_id}, Added Price: #{added_price}, Quantity: #{quantity}"
      Rails.logger.info "Initialized InvestmentPortfoliosStock: Stock ID: #{stock_id}, Added Price: #{added_price}, Quantity: #{quantity}"
    end
  
    # Log antes de guardar el objeto
    def log_before_save
      puts "Before Saving InvestmentPortfoliosStock: Stock ID: #{stock_id}, Added Price: #{added_price}, Quantity: #{quantity}"
      Rails.logger.info "Before Saving InvestmentPortfoliosStock: Stock ID: #{stock_id}, Added Price: #{added_price}, Quantity: #{quantity}"
    end
  
    # Log después de guardar el objeto
    def log_after_save
      puts "Saved InvestmentPortfoliosStock: Stock ID: #{stock_id}, Added Price: #{added_price}, Quantity: #{quantity}"
      Rails.logger.info "Saved InvestmentPortfoliosStock: Stock ID: #{stock_id}, Added Price: #{added_price}, Quantity: #{quantity}"
    end
  end
  