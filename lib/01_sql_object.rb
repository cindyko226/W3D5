require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    
     @column ||= DBConnection.execute2(<<-SQL)
       SELECT 
         *
       FROM 
         "#{self.table_name}"
     SQL
     @column.first.map(&:to_sym) 

  end

  def self.finalize!
    self.columns.each do |column|
      define_method(column) do 
        self.attributes[column]
      end 
      
      define_method("#{column}=") do |val|
        self.attributes[column] =  val
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= "#{self.to_s.tableize}"
  end

  def self.all
  end

  def self.parse_all(results)
  end

  def self.find(id)
  end

  def initialize(params = {})
     params.each do |k, v|
      raise "unknown attribute '#{k}'" unless self.class.columns.include?(k.to_sym)
      self.send("#{k}=", v)
     end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
  end

  def insert
  end

  def update
  end

  def save
  end
end
