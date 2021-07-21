require "sinatra"

class Office < Sinatra::Base
  helpers do
    def current_user
      "tlwr"
    end

    def csrf_token_hidden_input
      %(<input type="hidden" name="authenticity_token" value="#{env["rack.session"][:csrf]}">)
    end
  end
end
