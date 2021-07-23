RSpec.describe "db" do
  DB.tables.each do |table|
    next if table == :schema_info

    describe "#{table} table" do
      let(:schema) { DB.schema table }
      let(:fields) { schema.map(&:first) }

      it "has created_at field" do
        expect(fields).to include(:created_at)
      end

      it "has updated_at field" do
        expect(fields).to include(:updated_at)
      end
    end
  end
end
