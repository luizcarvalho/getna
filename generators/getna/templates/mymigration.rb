class Create_name_class_plural < ActiveRecord::Migration
  def self.up
    create_table name_plural, :force => true do |t|
      attrs.each do |attr|
      t.attr_type :attr_nome, (:limit => attr_limit) if attr_limit , (:null=> attr_null) if attr_null
      end
      
      t.timestamps
    end
  end

  def self.down
    drop_table :equipamentos
  end
end
