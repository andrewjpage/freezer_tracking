# only checks into storage area not into container
class Reception::Base
  include ActiveModel::Validations
  include Reception::User
end

