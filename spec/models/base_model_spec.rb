require 'rails_helper'

describe BaseModel do
    context 'no precondition' do
        it 'created a new base model with extra attributes' do
            resource = nil
            expect{resource = BaseModel.create! string_field: 'cadena', ext_extra_field: 'extras'}.not_to raise_error
            db_resource = BaseModel.find(resource.id)
            expect(db_resource.string_field).to eq('cadena')
            expect(db_resource.ext_extra_field).to eq('extras')
        end

        it '4' do
            expect(BaseModel.new.cuatro).to eq(4)
        end
    end

    context 'new object' do
        let(:resource) { BaseModel.new string_field: 'cadena', integer_field: 14 }

        it 'doesnt fails on extended attributes call' do
            expect {resource.ext_extra_field}.not_to raise_error
        end

        it 'to be saved without extra attributes' do
            expect {resource.save!}.not_to raise_error
            expect(resource.errors).to be_empty
        end

        it 'save new record with extra record' do
            expect {resource.ext_extra_field = 'extra'; resource.save!}.not_to raise_error
            expect(resource.ext_extra_field).to eq('extra')
            expect(resource.errors).to be_empty
            expect(resource.extended_base_model).to be_persisted

            expect(BaseModel.find(resource.id).ext_extra_field).to eq('extra')
        end
    end

    context 'persisted base object without extra attributes' do
        let(:resource) { BaseModel.create! string_field: 'cadena', integer_field: 14 }

        it 'can access the extra attributes without failing' do
            expect{resource.ext_extra_field}.not_to raise_error
            expect(resource.ext_extra_field).to be_nil
        end

        it 'can set the extra attributes and be saved' do
            expect{resource.update! ext_extra_field: 'extra_value'}.not_to raise_error
            expect(BaseModel.find(resource.id).ext_extra_field).to eq('extra_value')
        end
    end

    context 'persisted base object with extra attributes' do
        let(:resource) { BaseModel.create!(string_field: 'cadena', integer_field: 14).tap{ |b| b.update!(ext_extra_field: 'extra') } }

        it 'updates the extra and normal fields' do
            expect{resource.update! string_field: 'cadena_changed', ext_extra_field: 'extra_value'}.not_to raise_error
            db_resource = BaseModel.find(resource.id)
            expect(db_resource.string_field).to eq('cadena_changed')
            expect(db_resource.ext_extra_field).to eq('extra_value')
        end

        it 'to remove extra object when base object removed' do
            ext_id = resource.extended_base_model.id
            expect{resource.destroy!}.not_to raise_error
            expect(ExtendedBaseModel.exists?(ext_id)).to be false
        end
    end
end
