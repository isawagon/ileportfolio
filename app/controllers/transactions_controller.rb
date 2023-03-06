class TransactionsController < ApplicationController
  def index
    @transactions = @Transaction.all.where(portfolio_id: params[:portfolio_id])
  end

  def new
    @portfolio = Portfolio.find(params[:portfolio_id])
    #@coins = Coin.all.where(portfolio_id: params[:portfolio_id])
    # ajouter les prix actuels
    coins = Coin.all.where(portfolio_id: params[:portfolio_id])
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
    coins.each do |coin|
      coin.price = prices[coin.gecko_coin]['eur']
    end

    @coins = coins
    @registered = Transaction.all.where(portfolio_id: params[:portfolio_id]).sort.reverse
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @coins = Coin.where(portfolio_id: params[:portfolio_id])
    @transaction.portfolio_id = params[:portfolio_id]

    coin_in = Coin.find(params[:transaction][:coin_in_id].to_s)
    coin_in.stock = coin_in.stock + params[:transaction][:amount_in].to_f
    coin_out = Coin.find(params[:transaction][:coin_out_id].to_s)
    coin_out.stock = coin_out.stock - params[:transaction][:amount_out].to_f
    if params[:transaction][:coin_fees_id] > ""
      coin_fees = Coin.find(params[:transaction][:coin_fees_id].to_s)
      if coin_fees == coin_in
        coin_in.stock = coin_in.stock - params[:transaction][:amount_fees].to_f
        coin_fees.stock = coin_in.stock
      elsif coin_fees == coin_out
        coin_out.stock = coin_out.stock - params[:transaction][:amount_fees].to_f
        coin_fees.stock = coin_out.stock
      else
        coin_fees.stock = coin_fees.stock - params[:transaction][:amount_fees].to_f
      end
    else
      coin_fees = coin_out
    end
   
    if @transaction.save && coin_in.save && coin_out.save && coin_fees.save
      redirect_to new_portfolio_transaction_path, notice: "transaction ajoutée"
    else
      # ActiveRecord::Rollback
      redirect_to new_portfolio_transaction_path, notice: "pb ajout transaction"
    end

  end

  private

  def transaction_params
    params.require(:transaction).permit(:coin_in_id,   :amount_in,
                                        :coin_out_id,  :amount_out,
                                        :coin_fees_id, :amount_fees,
                                        :date)
  end

  def search_price(list)
    price_url = "https://api.coingecko.com/api/v3/simple/price?ids=#{list}&vs_currencies=EUR&include_24hr_change=true"
    price_serialized = URI.open(price_url).read
    JSON.parse(price_serialized)
  end

end
