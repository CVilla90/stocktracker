# Rails\portfolio\app\controllers\api\investment_portfolios_controller.rb

module Api
  class InvestmentPortfoliosController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

    def index
      @investment_portfolios = InvestmentPortfolio.all
      render json: @investment_portfolios
    end

    def show
      # Encuentra el portafolio por ID
      @investment_portfolio = InvestmentPortfolio.find(params[:id])

      # Mapea los detalles de las acciones incluidas en el portafolio
      stocks = @investment_portfolio.investment_portfolios_stocks.map do |ips|
        {
          id: ips.stock.id,
          name: ips.stock.name,
          added_price: ips.added_price,
          current_price: ips.stock.price(Date.today),
          quantity: ips.quantity,
          profit_or_loss: (ips.stock.price(Date.today) * ips.quantity - ips.added_price * ips.quantity).round(2)
        }
      end

      # Devuelve el JSON con la información del portafolio y sus acciones
      render json: {
        id: @investment_portfolio.id,
        name: @investment_portfolio.name,
        stocks: stocks
      }
    end

    def create
      @investment_portfolio = InvestmentPortfolio.new(name: params[:name])

      stock_entries = params[:stocks] || []
      stock_entries.each do |stock_entry|
        stock = Stock.find(stock_entry[:stock_id])
        
        # Asegúrate de que quantity tenga un valor válido, predeterminado a 1 si está ausente
        quantity = stock_entry[:quantity].to_i
        quantity = 1 if quantity <= 0

        added_price = stock.price(Date.today)
        
        # Log para depuración
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

    # Método para eliminar un portafolio
    def destroy
      @investment_portfolio = InvestmentPortfolio.find(params[:id])
      @investment_portfolio.destroy
      render json: { message: 'Portfolio deleted successfully' }, status: :ok
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
