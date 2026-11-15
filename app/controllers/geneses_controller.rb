class GenesesController < ApplicationController
  def show
    render json: {
      alloc: {},
      config: {
        chainId: 89428
      }
    }
  end
end
