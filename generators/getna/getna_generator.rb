class GetnaGenerator < Rails::Generator::NamedBase
  attr_reader   :dados,:objects,:budega

  
  def initialize(runtime_args, runtime_options = {})
    super

   @geobject = Getna::DBAdapter.new
     #$stdout.print "ARGS"
    # runtime_args.each { |i|  $stdout.print"#{i}\n" }
     #$stdout.print "ARGS"
    # runtime_options.each { |i|  $stdout.print"#{i}\n" }
    
    #con = ActiveRecord::Base.connection
    #$stdout.print con.connection 
      
#    $stdout.print "\n\nANTES DO NEW  1\n\n"
 #   @a = Getna::DBAdapter.new({:host=>"localhost",:db=>"imput",:user=>"root",:port=>"root"})
  #  $stdout.print "\n\nDEPOIS  DO NEW 4 \n\n"
#    $stdout.print "A = #{@a}"
    
    @objects = []
    @dados = [{:nome=>"usuario",:atributos=>[:id=>"Integer",:nome=>"String",:endereco=>"String"]}, { :nome=>"grupo",:atributos=>[:id=>"Integer",:nome=>"String",:descricao=>"String"]} ]
    # $stdout.print "DADOS #{@dados}\n"
   @dados.each{|obj| @objects.push(obj[:nome])}
   # $stdout.print  "OBJECT#{@objects}\n\n"
  
  end


  
  def manifest
    record do |m|
      # Controller, helper, views, and test directories.
      #{} $stdout.print "Class Path #{class_path}\n"
      name = Hash.new
          #------------------------------------------------------------- OK ----------------------------------------------------------------------
     # m.file("config/getna_config.yml","config/getna_config.yml")
      @geobject.table_names.each do |table_name|
        name = Hash.new
        name[:single] = table_name.singularize
        name[:plural] = table_name
        name[:class] = table_name.singularize.camelize
        name[:class_plural] = table_name.camelize
        attrs = @geobject.to_view(table_name)
        
        
        #CREATE Controllers
        m.template("controller.rb","app/controllers/#{name[:plural]}_controller.rb",:assigns=>{:object_name=>name})         

        #CREATE Models
        m.template("model.rb","app/models/#{name[:single]}.rb",:assigns=>{:object_name=>name})         
       #Create Views Directory
        m.directory("app/views/#{name[:plural]}")
        
        #Create  Views Files

        m.template("view_edit.html.erb","app/views/#{name[:plural]}/edit.html.erb",:assigns=>{:attributes=>attrs,:object_name=>name})     
        m.template("view_index.html.erb","app/views/#{name[:plural]}/index.html.erb",:assigns=>{:attributes=>attrs,:object_name=>name})    
        m.template("view_show.html.erb","app/views/#{name[:plural]}/show.html.erb",:assigns=>{:attributes=>attrs,:object_name=>name})               
        m.template("view_new.html.erb","app/views/#{name[:plural]}/new.html.erb",:assigns=>{:attributes=>attrs,:object_name=>name})         
        
      end

      
#      m.directory(File.join('app/controllers', controller_class_path))
#      m.directory(File.join('app/helpers', controller_class_path))
#      m.directory(File.join('app/views', controller_class_path, controller_file_name))
#      m.directory(File.join('test/functional', controller_class_path))
#      m.directory(File.join('test/unit', class_path))   
  end

  end

end

