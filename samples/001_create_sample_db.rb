#Este arquivo proporciona uma Rápida referência para que possamos testar
#As Funcionalidades existentes no Gerador Getna, retirado de caso real de uso
#ela possui diversos casos em que nosso gerador deve atuar.
#Caso encontre algum bug ou melhoria que pode ser feita, contate o desenvolvedor
#
# e-mail: maximusmano@gmail.com
# blog: http://www.maxonrails.wordpress.com
#
# Luiz Arão Araújo Carvalho
# Desenvolvedor RubyOnRails - Tocantins
#



class CreateSampleDb < ActiveRecord::Migration
  def self.up
    
    #-------------------------------------------------------------------------
    #Cria Tabela de Usuarios
    create_table :usuarios, :force => true do |t|
      t.string :login, :limit => 40
      t.string :email, :limit => 100
      t.string :nome, :limit => 100
      t.string :crypted_password, :limit => 40
      t.string :salt, :limit => 40
      t.string :remember_token
      t.datetime :remember_token_expires_at
      t.boolean :active, :default=> true
      t.timestamps 
    end
    
    
    #-------------------------------------------------------------------------
    #Cria Tabela de Grupos
    create_table :grupos, :force => true do |t|
      t.string :nome, :null=> false, :limit=> 100
      t.text :descricao
      t.timestamps

    end

    #-------------------------------------------------------------------------
    #Cria Tabela de Grupo-Usuarios
    create_table :grupo_usuarios do |t|
      t.belongs_to :grupo, :null=> false
      t.belongs_to :usuario, :null=> false
      t.timestamps
    end
    

    #-------------------------------------------------------------------------
    #Cria Tabela de Menus
    create_table :menus, :force => true do |t|
      t.string :label,:limit=> 60 , :null=>false
      t.string :url,:limit => 100, :null=>false
      t.integer :pai
      t.integer :ordem, :null=>false

      t.timestamps
    end 



    #-------------------------------------------------------------------------
    #Cria Tabela de Dominios
    create_table :dominios, :force => true do |t|
      t.string :domain, :null=> false
      t.text :description
      t.integer :maxaliases, :null=> false, :default=> 250
      t.integer :maxmailboxes, :null=> false, :default=> 250
      t.integer :maxquota, :null=> false, :default=> 10240000
      t.string :transport, :null=> false, :default=> 'maildrop'
      t.boolean :backupmx, :null=> false, :default=> false
      t.boolean :active, :null=> false, :default=> true

      t.timestamps
    end

    #-------------------------------------------------------------------------
    #Cria Tabela de Mailboxes
    create_table :mailboxes, :force => true do |t|
      t.belongs_to :usuario, :null=> false
      t.string :maildir
      t.string :homedir, :null=> false, :default=> '/postfix/'
      t.integer :quota, :null=> false, :default=> 25000
      t.belongs_to :dominio, :null=> false
      t.boolean :active, :null=> false, :default=> true

      t.timestamps
    end  

    create_table :equipamentos, :force => true do |t|
      t.string :marca, :limit => 100, :null=> false
      t.string :modelo, :limit => 100, :null=> false
      t.string :patrimonio, :limit => 10, :null=> false
      t.text :descricao, :limit => 255
      t.boolean :status
      
      t.references :equipamento
      t.references :localidade
      t.references :departamento

      t.timestamps
    end    
    
    create_table :localidades, :force => true do |t|
      t.string :localidade
      t.string :coordenada
      t.references :cidade
      t.string :status

      t.timestamps
    end
    
    create_table :contatos, :force => true do |t|
      t.string :nome, :limit => 40
      t.string :fone, :limit => 12
      t.string :endereco, :limit => 200
      t.string :celular, :limit => 12

      t.timestamps
    end
    
    create_table :cidades, :force => true do |t|
      t.string :nome, :limit => 50, :null => false
      t.string :populacao, :limit => 20
      t.string :uf, :limit => 2, :null => false
      t.string :eleitorado, :limit => 20
      t.string :canal, :limit => 20
      t.belongs_to :contato, :null => true
      t.timestamps
    end
    
     create_table :ordem_servicos, :force => true do |t|
      t.string :responsavel, :limit => 60, :null => false
      t.string :possivel_problema, :limit => 255, :null => false
      t.references :usuario, :null => false
      t.string :status, :limit => 25
      t.references :equipamento, :null => false

      t.timestamps
    end
    
    create_table :rotas, :force => true do |t|
      t.integer :numero, :null => false
      t.datetime :data_saida, :null => false
      t.datetime :data_retorno, :null => false
      t.string :transporte
      t.string :previsao_km
      t.string :tecnico, :null => false
      t.references :usuario, :null => false

      t.timestamps
    end
    
    create_table :localidade_rotas do |t|
      t.references :rota, :null => false
      t.references :localidade, :null => false
      
      t.timestamps
    end
    
    create_table :departamentos, :force => true do |t|
      t.string :nome, :limit => 50, :null => false

      t.timestamps
    end
    
    end

  
  
  
    #SELF DONWs =============================================================
  
  
  
  
    def self.down
      #---------------------------------------------------------------------
      #Deleta Usuarios
      drop_table :usuarios

      drop_table :grupos

      #---------------------------------------------------------------------
      #Deleta Grupo_Usuario
      drop_table :grupo_usuarios

      #---------------------------------------------------------------------
      #Deleta Menus
      drop_table :menus
      #---------------------------------------------------------------------
      #Deleta Dominios
      drop_table :dominios
 
      #---------------------------------------------------------------------
      #Deleta Mailboxes
      drop_table :mailboxes  
    
       #---------------------------------------------------------------------
      #Deleta Equipamentos
      drop_table :equipamentos

      #---------------------------------------------------------------------
      #Deleta Localidades
      drop_table :localidades
    
      #---------------------------------------------------------------------
      #Deleta Contatos
      drop_table :contatos
      
      #---------------------------------------------------------------------
      #Deleta Cidades
      drop_table :cidades
      
      #---------------------------------------------------------------------
      #Deleta Ordem Servicos
      drop_table :ordem_servicos
      
      #---------------------------------------------------------------------
      #Deleta Rotas
      drop_table :rotas
      
      #---------------------------------------------------------------------
      #Deleta localidade Rotas
      drop_table :localidade_rotas
      
      #---------------------------------------------------------------------
      #Deleta Departamentos
      drop_table :departamentos
    end
  end

