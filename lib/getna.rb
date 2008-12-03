# Copyright (c) 2008  Luiz Arão Araújo Carvalho
# 
# Esse arquivo é regido pela licença MIT
# Leia o Arquivo MIT-LICENSE encontrado
# na raiz desse Plugin para mais infomações
# Sobre sua Cópia. 
#

module Getna  
  class Base

    attr_reader :interrel, :table_names,:relationship, :validations, :table_id
    $VERSION = "0.6.4"


    def initialize (env)
      #Mensagen de inicialização do sistema de geração de codigo.

      start_messenger(env)
      
                       
     
      #Abre Arquivo de Configuração de banco de dados do Rails
      conf = YAML::load(File.open("#{RAILS_ROOT}/config/database.yml")) 
      ignore_tables = File.open("vendor/plugins/getna/config/ignore.yml").collect { |e| e.chomp }
     
      if conf[env].nil?
        puts "#{red("\n\nErro de atributos: o Environment #{env} não  foi encontrado.")} \n"
        puts  "Utilizando development como fonte de dados para geração!\n"
        env = 'development'
      end
      
      #Estabelece Conheção de acordo com o tipo de Enviroment(production,development,teste ou outo)
      $stdout.print("\nEstabelecendo conexão com Banco  #{conf[env]['database']}: ")
      ActiveRecord::Base.establish_connection(conf[env])
      $stdout.print("OK ")

      #Realiza uma conexção com as configurações encontradas do database.yml
      #Busca toda a estrutura da base de dados
      #Entre elas:
      # * Nome do banco, usuario, senha, endereço, 
      # * adaptador(mysql, postgresql...), codificação, linguagem e S.O.
      #
      $stdout.print("\nCarregando Informações do Banco de Dados : ")
      @con = ActiveRecord::Base.connection
      $stdout.print("OK ")
      
      
      $stdout.print("\nBuscando Tabelas: ")
      @table_names = Array.new
      #Busca todos os nomes de tabelas daquele banco de dados
      @con.tables.each { |e| @table_names.push(e) if !ignore_tables.include?(e) }
      
      $stdout.print("OK \n")
      #Deletamos tabelas que não devem ser geradas
      
      #Sessão Estatística
      ents = @table_names.size
      $stdout.print("\nExecutando ação para #{ents.to_s} Tabelas.")
      $stdout.print("\nAproximadamente  #{(ents*13+3).to_s} Arquivos e #{(ents*1+2).to_s} Diretórios serão Gerados/Deletados.  \n\n\n")


        
      #Guarda informações sobre Relacionamentos para ser utilizada nas Views
      @interrel = Hash.new 
      #Guarda Informações sobre relacionamentos para ser utilizados nos Models
      @relationship  = Hash.new
      #Guarda informações sobre Atributos de tabelas. Utilizado em Validações nos Models
      @validations = Hash.new
      #Guarda um identificador para cada tabela
      @table_id = Hash.new
      

      next_id = 0
      #inicia Variáveis com a estrutura Necessária 
      @table_names.each do |table|   
        @relationship.store(table,[])
        @interrel.store(table,[false])
        @validations.store(table,[])
        @table_id.store(table,(next_id+=1).to_s.rjust(3, '0'))
      end

      #Iniciando identificação de relacionamentos
      has_many_through
      has_many            
      create_validations

    end
    
    
    
    #===================================================
    # == Metodo to_view
    # Transforma tipos de dados encontrados em determinada tabela em tipo de dados
    # de view, ou seja, para cada tipo de dados no banco ele transforma de modo que este 
    # possa ser convertido em tag html para criação do formulario na view.
    # 
    #  == Exemplo 
    # Tabela Usuario
    # nome: varchar
    # status: boolean
    #--
    #  O que nosso método realiza neste ponto é pegar varchar e converter para text_field
    #  e boolean em check_box.
    # 
    # == Parametros
    #  É necessário passar apenas o nome da tabela para que seja feito o processo.
    #   to_view('nome_da_tabela')
    #   ==== Ex
    #   @user.tag_view = to_view('usuarios')
    #
    # == Retorno
    # Retorna um Hash com a seguinte estrutura para um exemplo de Usuario.
    #[{:type=>"text_field", :name=>"id"}, {:type=>"text_field", :name=>"nome"}, {:type=>"text_field", :name=>"endereco"}, {:type=>"text_field", :name=>"grupo_id"}, {:type=>"date_select", :name=>"created_at"}, {:type=>"date_select", :name=>"updated_at"}]
    def to_view(table_name)
      attr_view = []
      #Exceções, são campos da tabela que não necessitam ser gerados
      exceptions = ["id","created_at","updated_at"]
      
      #Método que busca os atributos de cada tabela
      attrs = columns(table_name)  
      #Inicia o processo de criação da estrutura formando pares de nome do atributo e tipo do atributo
      # caso este não esteja na lista de exceções
      #Adicionado variavel :fixture para ser usada na criacao dos Tests Fixtures. (by Silvio)
      attrs.each do |att|
        attr_view.push({:name =>att.name,:type=>type_for_tag(att.type.to_s),:fixture=>default_for_value_fixture(att.default,att.type.to_s)}) if !exceptions.include?(att.name)
      end     
      attr_view
    end
       
        
        
    #=================================================== 
    #Retorna os atributos de cada tabela dentro de um array, nesse array contém 
    # todas as informações sobre esse atributo, como: nome, tipo e tamanho  
    def columns(table_name)
      @con.columns(table_name)      
    end
    
    #=======================================================#
    #Sessão De Identificação de Relacionamentos NxN    
 
    #Método que seta todas as variáveis com os Relacionamentos encontrados
    def has_many_through
      @table_names.each do |table| 
        if (decomp_tables = decompounds(table))
           #test(table)
          if  (tables_exist?(decomp_tables)) 
            if (has_nxn_keys?(decomp_tables, table))
              create_relation_nxn_for(decomp_tables,table)
              create_interface_nxn_for(decomp_tables,table)
            end
          end 
        end   #END:: if Decomp_tables
      end #END Table Names Each
        
    end #END Has Many Throught
      
    
    #Decompõe o nome de uma tabela composta retornando um array
    # com os nomes das tabelas que formaram o nome de entrada.
    def decompounds(word)
      is_compounds = word.match(/(.*)_+(.*)/)
      decompoundeds = word.split('_').collect{|table| table.pluralize} if is_compounds
      decompoundeds || false
    end
    
    #FIXME Fazendo com tabelas formadas de nomes compostos EX: Line_Itens 
    #ENTRADA: Array com nome das tabelas
    #Retorna true se todas existirem e false se não
    def tables_exist?(tables)
      #$stdout.ptinf("TABELAS: #{tables}\n")
      exist = tables.blank? ? false : true
      tables.each do |table|
        exist = (exist and @table_names.include?(table))
      end
      exist
    end
    
    
    
    #
    #== Descricão
    # Verifica, uma tabela composta, se ela possui as chaves estrangeiras 
    # referêntes a elas.
    #
    #== Entrada
    #- array com nomes da tabela
    #- nome da tabela composta
    #
    #== Retorna
    #true se sim, e false caso contrário
    #
    #    
    def has_nxn_keys?(rel_tables, thr_table)
      table_w_keys = []
      rtables = rel_tables.dclone
      table_w_keys = has_keys?(thr_table)
      table_w_keys.each{|table| rtables.delete(table)}  
      rtables.empty? 
    end
  
    
    
    #Cria Relacionamento NxN
    #
    #== Entrada
    #informa-se um array com as tabelas relacionadas e o nome da tabela interrelacional
    #EX:
    # create_relation_nxn_for(['users','groups'],'group_users')
    # 
    #== Saida
    #
    # Esse metodo seta automaticamente a variável de instância @relationship e
    #a retorna.
    #
    def create_relation_nxn_for(rel_tables,thr_table)
      my_tables = rel_tables
      rel_tables.each do |rtable|
        my_tables.each do |table|
          @relationship[rtable] << "has_many :#{table}, :through=> :#{thr_table} "<< "has_many :#{thr_table} " if table !=rtable
        end
        # puts "THR: #{thr_table}"
        @relationship[thr_table].push("belongs_to :#{rtable.singularize}")
        # puts "REL_THR: #{rtable}"
      end
      @relationship
    end
    
    
    
    #Seta informações sobre tabelas para serem usadas na View.
    # Informa-se quais tabelas possuem relacionamento com a atual tabela.
    #possibilitando assim a identificação de chaves estrangeiras nas Views
    #
    def create_interface_nxn_for(rtables, thr_table)
      @interrel[thr_table]= rtables
      @interrel
    end
    
    
    #==  Fim Da Sessão De Identificação de Relacionamentos NxN  ====================#
    
    
    
    
    #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
    # == Inicio Da Sessão de Identificação de Relacionamentos Nx1 ====================#
    #:: Para cada tabela
    #- Buscamos campos com sufixo _id
    #- Verificamos se existe uma tabela com aquele nome
    #- adicionamos, para aquela tabela, o relacionamento Nx1
    
    def has_many
      @table_names.each do |table| 
        if ((rel_tables = has_keys?(table)) and (!tables_exist?(decompounds(table) || [])))
          create_relation_nxone_for(table, rel_tables)
          create_interface_nxone_for(table, rel_tables)
        end   #END:: if has_keys?
      end #END Table Names Each
    end #END Has Many Throught
    
    
    def create_relation_nxone_for(table, rel_tables)
      rel_tables
      rel_tables.each do |rtable|        
        @relationship[table] << "has_many :#{rtable}" 
        $stdout.print("\nrtable:#{rtable}\nrel_tables#{rel_tables} \n")
        @relationship[rtable].push("belongs_to :#{table.singularize}")
      end
      @relationship
    end  
    
    def create_interface_nxone_for(table, rel_tables)
      @interrel[table]= rel_tables
      @interrel
    end

    
    #== Fim Da Sessão de Identificação de Relacionamento Nx1 ======================#
    
    def create_validations
      @table_names.each do |name|
        columns(name).each do |attr|
          @validations[name].concat(build_validations(attr.name,attr))
        end
      end
    end
    
    def build_validations(name,attr)
      validations = []
      unnesscesary = (name=='id' or attr.type.to_s == 'boolean')
      
      unless unnesscesary
        
        if attr.null != true
          validations.push("validates_presence_of :#{name}, :message=>\"não pode ficar em branco!\"")
        end #fim null
        
        if !is_key?(name)
          
          if attr.limit != nil
            validations.push("validates_length_of  :#{name}, :maximum=>#{attr.limit}, :message=>\"não pode exeder os #{attr.limit} caracteres!\"")
          end #fim IF limit
    
          if attr.type.to_s == "integer"
            validations.push("validates_numericality_of  :#{name}, :message=>\"deve ser numérico!\"")
          end# Fim IF Type
        end#fim IF isKEY
      end #Unnesses
      validations
    end #FIM METODO
    
    def is_key?(key)
      res = key.match(/\A(.*_id)\z/)
      !res.nil?
    end
    
    
    
    
    
#==============================  MIGRAÇÕES ==========================================
#====================================================================================
#attr_migrate = [{:name=>"idade",:typo=>"integer",:null=>false, limit=>2,:default=>false},{:name=>false, type=>"timestamps",:null=>false,:limit=>false,:default=false}]
#
#template do objeto
#{:name=>false,:type=>false,:limit=>false, :null=>false, :default=>false}
#
# Cria-se duas Migrações Defaults
#* References (para chaves estrangeiras- sufixo "_id")
#{:name=>attr_name,:type=>references,:limit=>false, :null=>false, :default=>false}
#
#* Time Stamps (caso ache created_at e updated_at)
#{:name=>false, type=>"timestamps",:null=>false,:limit=>false,:default=false}
#    
    def to_migrate(table_name)
      attr_migrate = []
      #Exceções, são campos da tabela que não necessitam ser gerados
      exceptions = ["id","created_at","updated_at"]
      
      #Método que busca os atributos de cada tabela
      attrs = columns(table_name)  
      timestamps = []
      
      attrs.each do |att|         
        attr_migrate.push({
            :name =>att.name,
            :type=>att.type.to_s,
            :limit=>(att.limit.nil? ? nil : att.limit.to_s),
            :null=>(att.null ? nil : "false"),
            :default=>(att.default.nil? ? nil : ((att.type.to_s == "boolean")? att.default : ( "\"#{att.default}\"")))
         }) if !exceptions.include?(att.name) and !is_key?(att.name)

        if is_key?(att.name)
          attr_migrate.push({:name=>att.name.chomp('_id'),:type=>"references",:limit=>nil, :null=>nil, :default=>nil})
        end        
        
        timestamps.push(att.name) if ["created_at","updated_at"].include?(att.name)   
        
      end     
    
      if timestamps.size == 2
        attr_migrate.push({:name=>nil, :type=>"timestamps",:null=>nil,:limit=>nil,:default=>nil})
      end
      
      
    attr_migrate
    end
    
    
    
    
    
    #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
    #=== Métodos Comuns aos Relacionamentos ===============================#
    
    #== Descrição
    #Método busca todos os atributos que são chaves estrangeiras 
    #na tabela
    #
    #== Retorno
    #Retorna um Array com os nomes das tabelas que possuem chaves estrangeiras 
    #na tabela.
    #
    def has_keys?(table)
      table_w_keys =[]
      columns(table).each do |attr|
        if(is_key?(attr.name))
          table_w_keys.push(attr.name.chomp('_id').pluralize)
        end        
      end   
      table_w_keys
    end

    
    
    
    
    #===================================================  
    #+++++++++++++++++++++++++++++++++++++++++++++++++++   
 
    private
    #=================================================== 
    #Retorna tipos de dados de banco para tipo de dados de views
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

    #===========================================================
    #Retorna tipos de dados para Text Fixtures com base nos
    #valores default e type column. Recebe esses dois parametros
    #e verifica se default for nil, usa o type column como valor
    #convertido para valores que seguem o padrao scaffold,
    #caso contrario o default e usado como valor. (by Silvio)
    def default_for_value_fixture(default_value,type)
      tag ={
        "string"=>"MyString",
        "integer"=>"MyInteger",
        "boolean"=>"MyBoolean",
        "text"=>"MyText",
        "references"=>"MyText",
        "datetime"=>DateTime.now.strftime(fmt="%Y-%m-%d %H:%M:%S")
      }
      default_value.nil? ? tag[type] : default_value
    end
    
    
    #===============  MESSAGES ==========================
    #
    #mensagem de inicialização do gerador
    def start_messenger(env)
      $stdout.print("________________________________________________\n")
      $stdout.print("\n\n-----------  #{"GEtna Generator #{$VERSION}"}  ---------\n")
      $stdout.print("_______________________________________________\n")
    end

  
    
  end

  
  
  
  
  
  class Utilities
    attr_accessor :hash_options_for 
    def initialize      
    end
    
    # == Descrição
    # Método de Tratamento da entrada do usuario
    # 
    # == Exemplo
    # script/generate getna development style:depot
    # recebemos então o seguinte array:
    # ['style:depot'], nosso método então converte em
    # {'style'=>'depot'}
    # 
    # == Retorno
    # Retorna um Array com os pares de entrada do console 
    # do usuário.
    # 
    # {"chave"=>"valor","chave"=>"valor"} 
    #    
    def hash_options_for(actions)
      hash = {}   

      actions.each do|i| 
        k,v = i.split(':')
        hash.store(k,v)
      end

      hash
    end #END:: hash_options_for

    
        # Meétodos Responsáveis pela colorização 
    def colorize(text, color_code)
      "#{color_code}#{text}\e[0m"
    end
    
    def light(text); colorize(text, "\e[1m"); end
    def red(text); colorize(text, "\e[1;31m"); end
    def green(text); colorize(text, "\e[1;32m"); end
    def yellow(text); colorize(text, "\e[1;33m"); end

    
    
    
  end #Class Utilities
  
  
  
  
end
