class CoinsController < ApplicationController
  before_action :set_portfolio, only: %i[new create search]

  require "open-uri"

  def index
  end

  def show
    @coin = Coin.find(params[:id])
  end

  def new
    @coin = Coin.new
    foundcoins = []
    if params[:searched_coin]
      result = search_coingecko(params[:searched_coin])["coins"]
      result.each do |r|
        coin = Coin.new
        coin.gecko_coin = r["id"]
        coin.symbol = r["symbol"]
        coin.name = r["name"]
        coin.image_url = r["large"]
        coin.portfolio_id = params["portfolio_id"].to_i
        # on ne propose pas les rank à null
        if r["market_cap_rank"]
          coin.market_cap_rank = r["market_cap_rank"]
          foundcoins << coin
        end
      end
      if foundcoins.count.zero?
        redirect_to new_portfolio_coin_path, notice: "#{params[:searched_coin]} aucun résultat trouvé"
      end
    end
    @coins = foundcoins
  end

  def create
    @coin = Coin.new
    @coin.gecko_coin = params["gecko_coin"]
    @coin.portfolio = @portfolio
    main_data = search_main_data(@coin.gecko_coin)
    @coin.name = main_data["name"].capitalize
    @coin.symbol = main_data["symbol"].upcase
    @coin.image_url = (main_data["image"])["large"]
    @coin.market_cap_rank = main_data["market_cap_rank"]
    @coin.stock = 0

    # empêcher la création d'une crypto déjà en portefeuille
    if @coin.save
      redirect_to root_path, notice: "nouvelle crypto ajoutée"
    else
      redirect_to new_portfolio_coin_path, notice: "#{@coin.name} est déjà en portefeuille"
    end
  end

  private

  def set_portfolio
    @portfolio = Portfolio.find(params[:portfolio_id])
  end

  def coin_params
    params.require(:coin).permit(:gecko_coin, :portfolio_id)
  end

  def search_main_data(gecko_id)
    main_data_url = "https://api.coingecko.com/api/v3/coins/#{gecko_id}?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
    main_data_serialized = URI.open(main_data_url).read
    JSON.parse(main_data_serialized)
  end

  def search_coingecko(xxx)
    search_data_url = "https://api.coingecko.com/api/v3/search?query=#{xxx}"
    search_data_serialized = URI.open(search_data_url).read
    JSON.parse(search_data_serialized)
  end
end
