class DepositsController < ApplicationController
  def new
    asset = Asset.find(params[:asset_id])
    wallet = current_user.wallets.asset(asset).first_or_create!
    @wallet = wallet.as_json
    @asset = asset.as_json
  end

  def show
    deposit = current_user.deposits.find(params[:id])
    @deposit = deposit.as_json(Deposit::PRIVATE_JSON)
  end
end
