class Tenant < ApplicationRecord
  include OmniAccount::Accountable
end
