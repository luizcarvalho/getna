
--
-- Create schema getna
--

-- CREATE DATABASE IF NOT EXISTS getna;
-- USE getna;

--
-- Definition of table `getna`.`aliases`
--

DROP TABLE IF EXISTS `getna`.`aliases`;
CREATE TABLE  `getna`.`aliases` (
  `id` int(11) NOT NULL auto_increment,
  `address` varchar(255) NOT NULL,
  `goto` text NOT NULL,
  `dominio_id` int(11) NOT NULL,
  `active` tinyint(1) NOT NULL default '1',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Definition of table `getna`.`cidades`
--

DROP TABLE IF EXISTS `getna`.`cidades`;
CREATE TABLE  `getna`.`cidades` (
  `id` int(11) NOT NULL auto_increment,
  `nome` varchar(50) NOT NULL,
  `populacao` varchar(20) default NULL,
  `uf` varchar(2) NOT NULL,
  `eleitorado` varchar(20) default NULL,
  `canal` varchar(20) default NULL,
  `contato_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Definition of table `getna`.`contatos`
--

DROP TABLE IF EXISTS `getna`.`contatos`;
CREATE TABLE  `getna`.`contatos` (
  `id` int(11) NOT NULL auto_increment,
  `nome` varchar(40) default NULL,
  `fone` varchar(12) default NULL,
  `endereco` varchar(200) default NULL,
  `celular` varchar(12) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Definition of table `getna`.`departamentos`
--

DROP TABLE IF EXISTS `getna`.`departamentos`;
CREATE TABLE  `getna`.`departamentos` (
  `id` int(11) NOT NULL auto_increment,
  `nome` varchar(50) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Definition of table `getna`.`dominios`
--

DROP TABLE IF EXISTS `getna`.`dominios`;
CREATE TABLE  `getna`.`dominios` (
  `id` int(11) NOT NULL auto_increment,
  `domain` varchar(255) NOT NULL,
  `description` text,
  `maxaliases` int(11) NOT NULL default '250',
  `maxmailboxes` int(11) NOT NULL default '250',
  `maxquota` int(11) NOT NULL default '10240000',
  `transport` varchar(255) NOT NULL default 'maildrop',
  `backupmx` tinyint(1) NOT NULL default '0',
  `active` tinyint(1) NOT NULL default '1',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Definition of table `getna`.`equipamento_manutencoes`
--

DROP TABLE IF EXISTS `getna`.`equipamento_manutencoes`;
CREATE TABLE  `getna`.`equipamento_manutencoes` (
  `id` int(11) NOT NULL auto_increment,
  `manutencao_id` int(11) NOT NULL,
  `equipamento_id` int(11) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Definition of table `getna`.`equipamentos`
--

DROP TABLE IF EXISTS `getna`.`equipamentos`;
CREATE TABLE  `getna`.`equipamentos` (
  `id` int(11) NOT NULL auto_increment,
  `marca` varchar(100) NOT NULL,
  `modelo` varchar(100) NOT NULL,
  `patrimonio` varchar(10) NOT NULL,
  `descricao` varchar(255) default NULL,
  `status` tinyint(1) default NULL,
  `equipamento_id` int(11) default NULL,
  `localidade_id` int(11) default NULL,
  `departamento_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Definition of table `getna`.`grupo_permissoes`
--

DROP TABLE IF EXISTS `getna`.`grupo_permissoes`;
CREATE TABLE  `getna`.`grupo_permissoes` (
  `id` int(11) NOT NULL auto_increment,
  `permissao_id` int(11) default NULL,
  `grupo_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Definition of table `getna`.`grupo_usuarios`
--

DROP TABLE IF EXISTS `getna`.`grupo_usuarios`;
CREATE TABLE  `getna`.`grupo_usuarios` (
  `id` int(11) NOT NULL auto_increment,
  `grupo_id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Definition of table `getna`.`grupos`
--

DROP TABLE IF EXISTS `getna`.`grupos`;
CREATE TABLE  `getna`.`grupos` (
  `id` int(11) NOT NULL auto_increment,
  `nome` varchar(100) NOT NULL,
  `descricao` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Definition of table `getna`.`localidade_rotas`
--

DROP TABLE IF EXISTS `getna`.`localidade_rotas`;
CREATE TABLE  `getna`.`localidade_rotas` (
  `id` int(11) NOT NULL auto_increment,
  `rota_id` int(11) NOT NULL,
  `manutencao_id` int(11) default NULL,
  `localidade_id` int(11) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Definition of table `getna`.`localidades`
--

DROP TABLE IF EXISTS `getna`.`localidades`;
CREATE TABLE  `getna`.`localidades` (
  `id` int(11) NOT NULL auto_increment,
  `localidade` varchar(255) default NULL,
  `coordenada` varchar(255) default NULL,
  `cidade_id` int(11) default NULL,
  `status` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Definition of table `getna`.`mailboxes`
--

DROP TABLE IF EXISTS `getna`.`mailboxes`;
CREATE TABLE  `getna`.`mailboxes` (
  `id` int(11) NOT NULL auto_increment,
  `usuario_id` int(11) NOT NULL,
  `maildir` varchar(255) default NULL,
  `homedir` varchar(255) NOT NULL default '/postfix/',
  `quota` int(11) NOT NULL default '25000',
  `dominio_id` int(11) NOT NULL,
  `active` tinyint(1) NOT NULL default '1',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Definition of table `getna`.`manutencoes`
--

DROP TABLE IF EXISTS `getna`.`manutencoes`;
CREATE TABLE  `getna`.`manutencoes` (
  `id` int(11) NOT NULL auto_increment,
  `tipo_manutencao` varchar(255) default NULL,
  `descricao` varchar(255) default NULL,
  `retorno` tinyint(1) default NULL,
  `data` datetime default NULL,
  `observacao` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Definition of table `getna`.`materiais`
--

DROP TABLE IF EXISTS `getna`.`materiais`;
CREATE TABLE  `getna`.`materiais` (
  `id` int(11) NOT NULL auto_increment,
  `nome` varchar(255) default NULL,
  `descricao` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Definition of table `getna`.`material_requisicoes`
--

DROP TABLE IF EXISTS `getna`.`material_requisicoes`;
CREATE TABLE  `getna`.`material_requisicoes` (
  `id` int(11) NOT NULL auto_increment,
  `material_id` int(11) default NULL,
  `requisicao_id` int(11) default NULL,
  `quantidade_solicitada` int(11) default NULL,
  `quantidade_atendida` int(11) default NULL,
  `observacao` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


--
-- Definition of table `getna`.`menus`
--

DROP TABLE IF EXISTS `getna`.`menus`;
CREATE TABLE  `getna`.`menus` (
  `id` int(11) NOT NULL auto_increment,
  `label` varchar(60) NOT NULL,
  `url` varchar(100) NOT NULL,
  `pai` int(11) default NULL,
  `ordem` int(11) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Definition of table `getna`.`ordem_servicos`
--

DROP TABLE IF EXISTS `getna`.`ordem_servicos`;
CREATE TABLE  `getna`.`ordem_servicos` (
  `id` int(11) NOT NULL auto_increment,
  `responsavel` varchar(60) NOT NULL,
  `possivel_problema` varchar(255) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `status` varchar(25) default NULL,
  `equipamento_id` int(11) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Definition of table `getna`.`permissoes`
--

DROP TABLE IF EXISTS `getna`.`permissoes`;
CREATE TABLE  `getna`.`permissoes` (
  `id` int(11) NOT NULL auto_increment,
  `nome` varchar(100) NOT NULL,
  `recurso` varchar(100) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Definition of table `getna`.`requisicoes`
--

DROP TABLE IF EXISTS `getna`.`requisicoes`;
CREATE TABLE  `getna`.`requisicoes` (
  `id` int(11) NOT NULL auto_increment,
  `usuario_id` int(11) default NULL,
  `justificativa` varchar(255) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Definition of table `getna`.`rotas`
--

DROP TABLE IF EXISTS `getna`.`rotas`;
CREATE TABLE  `getna`.`rotas` (
  `id` int(11) NOT NULL auto_increment,
  `numero` int(11) NOT NULL,
  `data_saida` datetime NOT NULL,
  `data_retorno` datetime NOT NULL,
  `localidade_id` int(11) NOT NULL,
  `transporte` varchar(255) default NULL,
  `previsao_km` varchar(255) default NULL,
  `tecnico` varchar(255) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



--
-- Definition of table `getna`.`schema_migrations`
--

DROP TABLE IF EXISTS `getna`.`schema_migrations`;
CREATE TABLE  `getna`.`schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Definition of table `getna`.`usuarios`
--

DROP TABLE IF EXISTS `getna`.`usuarios`;
CREATE TABLE  `getna`.`usuarios` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(40) default NULL,
  `email` varchar(100) default NULL,
  `nome` varchar(100) default NULL,
  `crypted_password` varchar(40) default NULL,
  `salt` varchar(40) default NULL,
  `remember_token` varchar(255) default NULL,
  `remember_token_expires_at` datetime default NULL,
  `active` tinyint(1) default '1',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;




