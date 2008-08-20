module Getna  
  class DBAdapter
    attr_reader :connection,:table_names,:tag
    

    def initialize
      #@host = args[:host]
     # @db = args[:db]
      #@adapter = args[:adapter]
      #@user = args[:user]
      #@pass = args[:pass]
     # @port =args[:port]
#            $stdout.print "\n\nDENTRO DO ADAPTER 2\n\n"
     
      #TODO Realize Connections for all DataBases
      start_messenger
       @con = ActiveRecord::Base.connection
       
       @table_names = @con.tables
       @table_names.delete("schema_migrations")  

      @con.active? ? $stdout.print("\n\nData Loaded!\n\n") : $stdout.print("\n\n Load Failed! \n No Connected! \n\n")

    end

    #[{:type=>"text_field", :name=>"id"}, {:type=>"text_field", :name=>"nome"}, {:type=>"text_field", :name=>"endereco"}, {:type=>"text_field", :name=>"grupo_id"}, {:type=>"date_select", :name=>"created_at"}, {:type=>"date_select", :name=>"updated_at"}]
   
    def to_view(table_name)
      attr_view = []
      attrs = get_attributes(table_name)  
      
          attrs.each do |att| 
             attr_view.push({:name =>att.name,:type=>type_for_tag(att.type.to_s)})
          end
     
      attr_view
    end
       
    

    def get_attributes(table_name)
      @con.columns(table_name)      
    end
    
  private
  
    def type_for_tag(type)
      tag ={
        "string"=>"text_field",
        "boolean"=>"check_box",   
        "integer"=>"text_field",
        "text"=>"text_area",
         "references"=>"text_area",
         "datetime"=>"date_select"
      }      
      tag[type]      
    end
    
    
    def start_messenger
    $stdout.print("\n\n-----------  GEtna Generator 0.0.1  ---------\n")
    $stdout.print("_______________________________________________\n")
    $stdout.print("\nLoading Database... \n\n")
    end
    
    
  end
  
  
  
  
  
  
  
  
  
  
  
  
  
end
