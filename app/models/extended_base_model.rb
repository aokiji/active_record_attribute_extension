class ExtendedBaseModel < ActiveRecord::Base
    belongs_to :base_model, inverse_of: :extended_base_model
end
