class Adminful::Properties::MongoidAdapter < Adminful::Properties

  def self.can_process?(model)
    model.ancestors.include?(Mongoid::Document)
  end

  def initialize(model)
    @model = model
  end

  TypesMap = {
    Array => :array,
    BigDecimal => :big_decimal,
    Boolean => :boolean,
    Date => :date,
    DateTime => :date_time,
    Float => :float,
    Hash => :hash,
    Integer => :integer,
    String => :string,
    Symbol => :symbol,
    Time => :time
  }

  def to_hash
    @model.fields.map do |field_name, field|
      type = TypesMap[field.type]

      next if type.nil? or field.name =~ /^_/

      {
        :required => @model.validators_on(field.name).any? {|validator| validator.is_a?(ActiveModel::Validations::PresenceValidator) },
        :name => field.name,
        :label => @model.human_attribute_name(field.name),
        :type => type
      }
    end.compact
  end

end
