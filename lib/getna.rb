# Copyright (c) 2008  Luiz Arão Araújo Carvalho
# 
# Esse arquivo é regido pela licença MIT
# Leia o Arquivo MIT-LICENSE encontrado
# na raiz desse Plugin para mais infomações
# Sobre sua Cópia. 
#

module Getna  
  class Base
    attr_reader :interrel, :table_names,:relationship
    $VERSION = "0.1.1"

    def initialize (env)
      #Mensagen de inicialização do sistema de geração de codigo.

      start_messenger(env)
      
                       
     
      #Abre Arquivo de Configuração de banco de dados do Rails
      conf = YAML::load(File.open("#{RAILS_ROOT}/config/database.yml")) 
     
      if conf[env].nil?
        puts "#{red("\n\nErro de atributos: o Environment #{env} não  foi encontrado.")} \n"
        puts  "Utilizando development como fonte de dados para geração!\n"
        env = 'development'
      end
      
      #Estabelece Conheção de acordo com o tipo de Enviroment(production,development,teste ou outo)
      $stdout.print("\nEstabelecendo conexão com Banco#{conf[env]['database']}: ")
      ActiveRecord::Base.establish_connection(conf[env])
      $stdout.print("#{green('OK')} ")

      #Realiza uma conexção com as configurações encontradas do database.yml
      #Busca toda a estrutura da base de dados
      #Entre elas:
      # * Nome do banco, usuario, senha, endereço, 
      # * adaptador(mysql, postgresql...), codificação, linguagem e S.O.
      #
      $stdout.print("\nCarregando Informações do Banco de Dados : ")
      @con = ActiveRecord::Base.connection
      $stdout.print("#{green('OK')} ")
      
      
      $stdout.print("\nBuscando Tableas: ")
      #Busca todos os nomes de tabelas daquele banco de dados
      @table_names = @con.tables
      $stdout.print("#{green('OK')} \n")
      #Deletamos tabelas que não devem ser geradas(schema_migrations) 
      @table_names.delete("schema_migrations")
      
      #Sessão Estatística
      ents = @table_names.size
      $stdout.print("\nExecutando ação para #{yellow(ents.to_s)} Tabelas.")
      $stdout.print("\nAproximadamente  #{yellow((ents*9+3).to_s)} Arquivos e #{yellow((ents*1+1).to_s)} Diretórios serão Gerados/Deletados.  \n\n\n")


        
       
      @interrel = Hash.new 
      @relationship  = Hash.new
      
      @table_names.each do |table|   
        @relationship.store(table,[])
        @interrel.store(table,[false])
      end

      #Iniciando identificação de relacionamentos
      has_many_through
      has_many
      # @interrel.each_pair {|key, value| $stdout.print("#{key} => #{value}\n") }
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
      attrs.each do |att| 
        attr_view.push({:name =>att.name,:type=>type_for_tag(att.type.to_s)}) if !exceptions.include?(att.name)  
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
    def test(table)
      decomp_tables = decompounds(table)
      puts "Composto: #{table}"
      tables_exist?(decomp_tables) ? (puts "Tabelas Existem") : (puts "Tabelas Não Existem")
      has_nxn_keys?(decomp_tables, table) ? (puts "Chaves OK"):(puts "Chaves FAIL")
      (tables_exist?(decomp_tables) and has_nxn_keys?(decomp_tables, table)) ? (puts "GRAVAR") : (puts "OPS")
    end
    
    def has_many_through
      @table_names.each do |table| 
        if (decomp_tables = decompounds(table))
          # test(table)
          if  (tables_exist?(decomp_tables)) 
            if (has_nxn_keys?(decomp_tables, table))
              create_relation_nxn_for(decomp_tables,table)
              create_interface_nxn_for(decomp_tables,table)
            end
          end 
        end   #END:: if Decomp_tables
      end #END Table Names Each
        
    end #END Has Many Throught
      
    
    def decompounds(word)
      is_compounds = word.match(/(.*)_+(.*)/)
      decompoundeds = word.split('_').collect{|table| table.pluralize} if is_compounds
      decompoundeds || false
    end
    
    #FIXME Fazendo com tabelas formadas de nomes compostos EX: Line_Itens 
    def tables_exist?(tables)
      tables.each do |table|
        @table_names.include?(table)
      end
    end
    
    def has_nxn_keys?(rel_tables, thr_table)
      table_w_keys = []
      rtables = rel_tables.dclone
      table_w_keys = has_keys?(thr_table)
      table_w_keys.each{|table| rtables.delete(table)}  
      rtables.empty? 
    end
  
    #Cria Relacionamento(REL_TABLE NAUM VEM)
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
                if (rel_tables = has_keys?(table))
                  create_relation_nxone_for(table, rel_tables)
                  create_interface_nxone_for(table, rel_tables)
            end   #END:: if has_keys?
          end #END Table Names Each
        end #END Has Many Throught
    
    
     def create_relation_nxone_for(table, rel_tables)
      rel_tables
      rel_tables.each do |rtable|        
        @relationship[table] << "has_many :#{rtable}" 
        @relationship[rtable].push("belongs_to :#{table.singularize}")
       end
      @relationship
     end  

     
     def create_interface_nxone_for(table, rel_tables)
      @interrel[table]= rel_tables
      @interrel
     end

    
    
    #== Fim Da Sessão de Identificação de Relacionamento Nx1 ======================#
    
    
    
    
    
    
    
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
        if(attr.name.match(/\A(.*_id)\z/))
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
    
    
    #===============  MESSAGES ==========================
    #
    #mensagem de inicialização do gerador
    def start_messenger(env)
      $stdout.print("________________________________________________\n")
      $stdout.print("\n\n-----------  #{light("GEtna Generator #{$VERSION}")}  ---------\n")
      $stdout.print("_______________________________________________\n")
    end

    # Meétodos Responsáveis pela colorização 
    def colorize(text, color_code)
      "#{color_code}#{text}\e[0m"
    end
    def light(text); colorize(text, "\e[1m"); end
    def red(text); colorize(text, "\e[1;31m"); end
    def green(text); colorize(text, "\e[1;32m"); end
    def yellow(text); colorize(text, "\e[1;33m"); end

    
    
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

  end
  
end
