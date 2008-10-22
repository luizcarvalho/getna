
module Getna  
  class Base
    attr_reader :connection,:table_names,:tag
    $VERSION = "0.0.4"

    def initialize (env)
    
      #TODO Realize Connections for all DataBases
      
      #Mensagen de inicialização do sistema de geração de codigo.
      start_messenger(env)
      
      
      #Abre Arquivo de Configuração de banco de dados do Rails
      conf = YAML::load(File.open("#{RAILS_ROOT}/config/database.yml")) 
     
      #Estabelece Conheção de acordo com o tipo de Enviroment(production,development,teste ou outo)
      ActiveRecord::Base.establish_connection(conf[env])
      

      #Realiza uma conexção com as configurações encontradas do database.yml
      #Busca toda a estrutura da base de dados
      #Entre elas:
      # * Nome do banco, usuario, senha, endereço, 
      # * adaptador(mysql, postgresql...), codificação, linguagem e S.O.
      #
      @con = ActiveRecord::Base.connection
       
      #Busca todos os nomes de tabelas daquele banco de dados
      @table_names = @con.tables
      #Deletamos tabelas que não devem ser geradas(schema_migrations) 
      @table_names.delete("schema_migrations")  
       
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
    #   @user_tag_view = to_view('usuarios')
    #
    # == Retorno
    # Retorna um Hash com a seguinte estrutura para um exemplo de Usuario.
    #[{:type=>"text_field", :name=>"id"}, {:type=>"text_field", :name=>"nome"}, {:type=>"text_field", :name=>"endereco"}, {:type=>"text_field", :name=>"grupo_id"}, {:type=>"date_select", :name=>"created_at"}, {:type=>"date_select", :name=>"updated_at"}]
    def to_view(table_name)
      attr_view = []
      #Exceções, são campos da tabela que não necessitam ser gerados
      exceptions = ["id","created_at","updated_at"]
      
      #Método que busca os atributos de cada tabela
      attrs = get_attributes(table_name)  
      #Inicia o processo de criação da estrutura formando pares de nome do atributo e tipo do atributo
      # caso este não esteja na lista de exceções
      attrs.each do |att| 
        attr_view.push({:name =>att.name,:type=>type_for_tag(att.type.to_s)}) if !exceptions.include?(att.name)  
      end     
      attr_view
    end
       
        
        
    #=================================================== 
    #Retorna os atributos de cada tabela dentro de um array, nesse array contém 
    # todas as informações sobre esse atributo, como: nome, tipo e tamanho
  
    def get_attributes(table_name)
      @con.columns(table_name)      
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
    
    
    #===============  MESSAGES ==========================
    #
    #mensagem de inicialização do gerador
    def start_messenger(env)
      $stdout.print("\n\n-----------  GEtna Generator #{$VERSION}  ---------\n")
      $stdout.print("_______________________________________________\n")
      $stdout.print("\n Conexão para: #{env} \n")
      $stdout.print("\nCarregando Informações do Banco de Dados... \n\n")
    end
  
  end

  
  
  
  
  
  class Structure
    attr_accessor :hash_options_for 
    def initialize
      
    end
    
    # +________________________________________
    def hash_options_for(actions)
      hash = {}   

      actions.each do|i| 
        k,v = i.split(':')
        hash.store(k,v)
      end

      hash
    end #END:: hash_options_for

  end
  
  

  
end
