```ruby
# app/controllers/revendas_controller.rb

class RevendasController < ApplicationController
  # ...existing code...

  def create
    revenda = Revenda.find_by(cnpj: params[:cnpj])
    if revenda && revenda.authenticate(params[:password])
      # ...login logic...
    else
      flash[:alert] = "CNPJ ou senha inválidos."
      render :new
    end
  end

  # ...existing code...
end
```