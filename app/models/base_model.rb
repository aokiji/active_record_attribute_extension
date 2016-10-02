module Extensions
    module BaseModel
        def initialize(attributes=nil, options={})
            if attributes.present?
                extended_attributes = attributes.select {|key, value| key.to_s.start_with?('ext_')}
                extended_attributes.each {|key, value| attributes.delete(key)}
                attributes[:extended_base_model_attributes] = Hash[extended_attributes.map do |key, value| 
                    [key.to_s.gsub(/^ext_/, ''), value]
                end]
            end
            super
        end

        def cuatro
            4
        end
    end
end

class BaseModel < ActiveRecord::Base
    has_one :extended_base_model, inverse_of: :base_model, autosave: true, dependent: :destroy

    after_initialize :ensure_extended_base_model
    accepts_nested_attributes_for :extended_base_model

    prepend Extensions::BaseModel

    def method_missing(method, *args, &block)
		if method.to_s =~ /^ext_(.*)$/
		  extended_base_model.send($1, *args)
		else
		  super
		end
    end

    private
    def ensure_extended_base_model
        self.extended_base_model ||= self.build_extended_base_model
    end
end
