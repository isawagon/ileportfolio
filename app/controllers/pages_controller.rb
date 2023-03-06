class PagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: [ :home ]
  require "open-uri"

  def about
  end

  def home
  # appeler l'API
  # associer le price à chaque coin
  # a faire optional:
    # supprimer les données prix, change et rank de la DB,
    # mettre les données ptf dans @dashboard et ne plus envoyer @portfolios à la vue
    # appel à une method pour constituer les hash des coins

    # préparer la liste des gecko_coin et appel API pour récupérer les cours
    @portfolios = current_user.portfolios.all
    coins = current_user.coins.all
    if coins.first
      list = "#{coins.first.gecko_coin}"
      coins.each do |coin|
        list = "#{list},#{coin.gecko_coin}"
      end
      prices = search_price(list)
      prices['euro_fiat'] =
        { "eur" => 1,
          "eur_24h_change" => 0 }
    end
    # constituer les données dashboard
    @dashboard = {}
    current_user.portfolios.all.each do |portfolio|
      c3 = {}
      total = 0
      @dashboard["#{portfolio.id}"] = {}
      c2 = current_user.coins.all.select do |c|
        c.portfolio_id == portfolio.id
      end

      c2.each do |coin|
        c3["#{coin.id}"] =
          { id: coin.id,
            symbol: coin.symbol,
            name: coin.name,
            image_url: coin.image_url,
            portfolio_id: coin.portfolio_id,
            stock: coin.stock,
            price: prices[coin.gecko_coin]['eur'],
            value: coin.stock * prices[coin.gecko_coin]['eur'] }
        total += coin.stock * prices[coin.gecko_coin]['eur']
      end

      # trier c3 par value DESC
      c3 = c3.sort_by { |_k, v| v[:value].to_f }.reverse.to_h

      @dashboard["#{portfolio.id}"]["assets"] = c3
      @dashboard["#{portfolio.id}"]["total_ptf"] = total
    end
    # fin constituer les données dashboard
  end

  private

  def search_price(list)
    price_url = "https://api.coingecko.com/api/v3/simple/price?ids=#{list}&vs_currencies=EUR&include_24hr_change=true"
    price_serialized = URI.open(price_url).read
    JSON.parse(price_serialized)
  end
end
