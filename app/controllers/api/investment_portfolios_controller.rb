# Rails\portfolio\app\controllers\api\investment_portfolios_controller.rb

module Api
  class InvestmentPortfoliosController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

    def index
      @investment_portfolios = InvestmentPortfolio.all
      render json: @investment_portfolios
    end

    def show
      # Find the portfolio by ID
      @investment_portfolio = InvestmentPortfolio.find(params[:id])

      # Simulate start and end dates for the calculation of annualized return
      start_date = Date.today - 365 # 1 year ago
      end_date = Date.today

      # Map the details of stocks included in the portfolio
      stocks = @investment_portfolio.investment_portfolios_stocks.map do |ips|
        start_price = ips.stock.price(start_date)
        end_price = ips.stock.price(end_date)
        profit_or_loss = ((end_price - ips.added_price) * ips.quantity).round(2)

        # Calculate annualized return
        annualized_return = if start_price > 0
                              ((end_price / start_price) ** (1.0 / ((end_date - start_date).to_f / 365.25)) - 1).round(4)
                            else
                              0
                            end

        {
          id: ips.stock.id,
          name: ips.stock.name,
          quantity: ips.quantity,
          added_price: ips.added_price,
          current_price: end_price,
          profit_or_loss: profit_or_loss,
          annualized_return: annualized_return * 100 # As a percentage
        }
      end

      # Calculate totals
      total_quantity = stocks.sum { |s| s[:quantity] }
      total_added_price = stocks.sum { |s| s[:added_price] * s[:quantity] }
      total_current_price = stocks.sum { |s| s[:current_price] * s[:quantity] }
      total_profit_or_loss = stocks.sum { |s| s[:profit_or_loss] }

      # Render the JSON with portfolio and stock information, including totals
      render json: {
        id: @investment_portfolio.id,
        name: @investment_portfolio.name,
        stocks: stocks,
        totals: {
          quantity: total_quantity,
          added_price: total_added_price.round(2),
          current_price: total_current_price.round(2),
          profit_or_loss: total_profit_or_loss.round(2)
        }
      }
    end

    def create
      @investment_portfolio = InvestmentPortfolio.new(name: params[:name])

      stock_entries = params[:stocks] || []
      stock_entries.each do |stock_entry|
        stock = Stock.find(stock_entry[:stock_id])
        
        # Ensure quantity is valid, default to 1 if absent
        quantity = stock_entry[:quantity].to_i
        quantity = 1 if quantity <= 0

        added_price = stock.price(Date.today)

        # Log for debugging
        puts "Adding Stock: #{stock.name}, Quantity: #{quantity}, Added Price: #{added_price}"
        Rails.logger.info "Adding Stock: #{stock.name}, Quantity: #{quantity}, Added Price: #{added_price}"

        @investment_portfolio.investment_portfolios_stocks.build(
          stock: stock,
          added_price: added_price,
          quantity: quantity
        )
      end

      if @investment_portfolio.save
        render json: @investment_portfolio, status: :created
      else
        render json: @investment_portfolio.errors, status: :unprocessable_entity
      end
    end

    # Method to delete a portfolio
    def destroy
      @investment_portfolio = InvestmentPortfolio.find(params[:id])
      @investment_portfolio.destroy
      render json: { message: 'Portfolio deleted successfully' }, status: :ok
    rescue ActiveRecord::InvalidForeignKey => e
      render json: { error: 'Cannot delete portfolio due to associated records.' }, status: :unprocessable_entity
    end

    private

    def investment_portfolio_params
      params.require(:investment_portfolio).permit(:name, stocks: [:stock_id, :quantity])
    end

    def render_not_found
      render json: { error: 'InvestmentPortfolio not found' }, status: :not_found
    end
  end
end
