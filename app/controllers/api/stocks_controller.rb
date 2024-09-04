# Rails\portfolio\app\controllers\api\stocks_controller.rb

module Api
  class StocksController < ApplicationController
    def index
      # Mapear los stocks para incluir el precio simulado usando el método price
      stocks = Stock.all.map do |stock|
        {
          id: stock.id,
          name: stock.name,
          price: stock.price(Date.today) # Usando el precio simulado para la fecha de hoy
        }
      end
      render json: stocks
    end
  
    def show
      stock = Stock.find(params[:id])
      render json: {
        id: stock.id,
        name: stock.name,
        price: stock.price(Date.today) # Mostrando también el precio simulado
      }
    end
  
    def create
      stock = Stock.new(stock_params)
      if stock.save
        render json: stock, status: :created
      else
        render json: stock.errors, status: :unprocessable_entity
      end
    end
  
    private
  
    def stock_params
      params.require(:stock).permit(:name)
    end
  end
end
