# Copyright (c) 2008  Luiz Arão Araújo Carvalho
# 
# Esse arquivo é regido pela licença MIT
# Leia o Arquivo MIT-LICENSE encontrado
# na raiz desse Plugin para mais infomações
# Sobre sua Cópia. 
#


class GetnaGenerator < Rails::Generator::NamedBase
  #
  #  Classe GetnaGenerator é responsável pelo processo de coleta de dados via linha de comando
  #   Apartir de dados encontrados em uma base de dados como Mysql, PostgreSQL e SQLite,
  # gera-se então toda a estrutura de uma aplicação Rails como um Scaffold, mas em um unico commado.
  #   Das tabelas são buscados nome das tabelas(para classes), nome dos campos (para Atributos) e seus 
  #atributos(para validações) e ainda chaves estrangeiras (para relacionamentos), 

  def initialize(runtime_args, runtime_options = {})
    super
   # Instânciamos o Objeto GEtna com as infomações do Banco de dados
   @geobject = Getna::Base.new(@name)
   #instâncimamos Objeto Getna::Utilities para tratarmos a entrada
   @utility = Getna::Utilities.new

    
#   $stdout.print "STYLE: #{runtime_options[:style] }\n\n"
#   $stdout.print "OPTIONS: #{runtime_options}\n\n"
 #  $stdout.print "ARGS:  #{ }\n\n"
#   $stdout.print "ACTIONS:  #{actions[1] }\n\n"

#TODO fazer teste se as Opções estão corretas
  options =   @utility.hash_options_for(actions)
  @style =  options['style'] || 'default'
  end




  def manifest
    record do |m|

      # == GENERATE Diretorio de Layouts
      m.directory("app/views/layouts")
      # == GENERATE Stilo 
      m.file("/styles/#{@style}.css","public/stylesheets/getna.css")   
     # == COPY getna logo 
      m.file("/images/getna.png","public/images/getna.png")     
      
      # == GENERATE Pagina inicial do GEtna
      #TODO colocar imagem do GEtna
      m.template("index.html.erb","public/index.html",:assigns=>{:entities =>@geobject} ,:collision => :force)   

      #
      #Para Cada tabela do banco colocamos em nosso Hash 
      # * Name:Singular: Nome do Tabela no Singular
      # * Name:Plural: Nome do Tabela no Plural(Nome da Tabela)
      # * Name:Class: Nome da Tabela no Singular e "Camelizado"
      # * Name:Class Plural: recebe o Nome da Tabela "Camelizado"
      # e Attrs: Recebe os Atributos daquela tabela transformados em Atributos 
      # de de View como : String = Text Field, Text = Text Area
      #
      @geobject.table_names.each do |table_name|
        name = Hash.new
        name[:single] = table_name.singularize
        name[:plural] = table_name
        name[:class] = table_name.singularize.camelize
        name[:class_plural] = table_name.camelize
        attrs = @geobject.to_view(table_name)
        
        
        # ==GENERATE Controllers
        # Para cada Tabela é então copiado o template controller.rb para  a pasta do projeto
        #app/controllers/ com o nome no Plural, passamos tambem as variáveis que devem ser mudadas
        #dentro dos Templates( Todos os NAMES acima.S ).
        #
        m.template("controller.rb","app/controllers/#{name[:plural]}_controller.rb",:assigns=>{:object_name=>name})         

        # == GENERATE Models
         # Para cada Tabela é então copiado o template model.rb para  a pasta do projeto
        #app/models/ com o nome no Plural, passamos tambem as variáveis que devem ser mudadas
        #dentro dos Templates( Todos os NAMES acima.S ).
        #
        m.template("model.html.erb","app/models/#{name[:single]}.rb",:assigns=>{:object_name=>name, :relationship=>@geobject.relationship['usuarios']})#["PORRA","VSF","CARAI"]})
     
        # == GENERATE Views Directory
        # Criamos o Diretorio que vai conter as Views com o nome da tabela no plural
        m.directory("app/views/#{name[:plural]}")
        
        # == GENERATE Views Files
        #Criamos então para cada tabela os 4 arquivos de CRUD: edit.html.erb, index.html.erb, show.html.erb, new.html.erb.
        #na Pasta que acabamos de gerar, utilizando seus respectivos templates view_edit.html.erb, view_index.html.erb,
        # view_show.html.erb, view_new.html.erb
        #
        m.template("view_edit.html.erb","app/views/#{name[:plural]}/edit.html.erb",:assigns=>{:attributes=>attrs,:object_name=>name})     
        m.template("view_index.html.erb","app/views/#{name[:plural]}/index.html.erb",:assigns=>{:attributes=>attrs,:object_name=>name})    
        m.template("view_show.html.erb","app/views/#{name[:plural]}/show.html.erb",:assigns=>{:attributes=>attrs,:object_name=>name})               
        m.template("view_new.html.erb","app/views/#{name[:plural]}/new.html.erb",:assigns=>{:attributes=>attrs,:object_name=>name})         
        
        # == GENERATE Routes
        # Geramos a rota para cada objeto gerado.
        #
        m.route_resources name[:plural]
      
        # == GENERATE Layout
        # Geramos a layouts para cada objeto gerado.
        #
        m.template("layouts/#{@style}_layout.html.erb","app/views/layouts/#{name[:plural]}.html.erb",:assigns=>{:object_name=>name}) 
        
        #CREATE Helpers
        m.template("helper.rb","app/helpers/#{name[:plural]}_helper.rb",:assigns=>{:object_name=>name})    

        #CREATE Testes Unitários
        m.template("unit_test.rb","test/unit/#{name[:single]}_test.rb",:assigns=>{:object_name=>name})

      
      end #END:: Each Table Name

  end # END:: do-record(m)

 end #END:: Manifest

end #END:: Class

