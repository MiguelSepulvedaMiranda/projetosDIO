-- Criação do Banco de Dados
CREATE DATABASE oficina;
USE oficina;

-- Tabela Clientes
CREATE TABLE Clientes (
    idClientes INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45),
    endereco VARCHAR(45),
    telefone VARCHAR(45)
);

-- Tabela Veículos
CREATE TABLE Veiculos (
    idVeiculo INT AUTO_INCREMENT PRIMARY KEY,
    placa VARCHAR(45),
    modelo VARCHAR(45),
    marca VARCHAR(45),
    ano INT,
    Clientes_idClientes INT,
    FOREIGN KEY (Clientes_idClientes) REFERENCES Clientes(idClientes)
);

-- Tabela Mecânicos
CREATE TABLE Mecanicos (
    idMecanicos INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45),
    endereco VARCHAR(45),
    especialidade VARCHAR(45)
);

-- Tabela Equipes
CREATE TABLE Equipes (
    idEquipes INT AUTO_INCREMENT PRIMARY KEY,
    nome_equipe VARCHAR(45)
);

-- Tabela Mecânicos_Equipes
CREATE TABLE Mecanicos_Equipes (
    Mecanicos_idMecanicos INT,
    Equipes_idEquipes INT,
    PRIMARY KEY (Mecanicos_idMecanicos, Equipes_idEquipes),
    FOREIGN KEY (Mecanicos_idMecanicos) REFERENCES Mecanicos(idMecanicos),
    FOREIGN KEY (Equipes_idEquipes) REFERENCES Equipes(idEquipes)
);

-- Tabela Serviços
CREATE TABLE Servicos (
    idServicos INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(45),
    valor_mao_obra FLOAT
);

-- Tabela Ordens_Serviço
CREATE TABLE Ordens_Servico (
    idOS INT AUTO_INCREMENT PRIMARY KEY,
    numero_os VARCHAR(45),
    data_emissao DATE,
    valor_total FLOAT,
    status VARCHAR(45),
    data_conclusao DATE,
    Veiculos_idVeiculo INT,
    Equipes_idEquipes INT,
    Clientes_idClientes INT,
    FOREIGN KEY (Veiculos_idVeiculo) REFERENCES Veiculos(idVeiculo),
    FOREIGN KEY (Equipes_idEquipes) REFERENCES Equipes(idEquipes),
    FOREIGN KEY (Clientes_idClientes) REFERENCES Clientes(idClientes)
);

-- Tabela Itens_OS
CREATE TABLE Itens_OS (
    idItem INT AUTO_INCREMENT PRIMARY KEY,
    descricao_peca VARCHAR(45),
    valor_item FLOAT,
    quantidade INT,
    Ordens_Serviço_idOS INT,
    Servicos_idServicos INT,
    FOREIGN KEY (Ordens_Serviço_idOS) REFERENCES Ordens_Servico(idOS),
    FOREIGN KEY (Servicos_idServicos) REFERENCES Servicos(idServicos)
);

-- Inserindo Dados nas Tabelas

-- Inserir Clientes
INSERT INTO Clientes (nome, endereco, telefone) VALUES 
('João Silva', 'Rua A, 100', '123456789'),
('Maria Oliveira', 'Rua B, 200', '987654321');

-- Inserir Veículos
INSERT INTO Veiculos (placa, modelo, marca, ano, Clientes_idClientes) VALUES 
('ABC1234', 'Fusca', 'Volkswagen', 1985, 1),
('XYZ5678', 'Civic', 'Honda', 2020, 2);

-- Inserir Mecânicos
INSERT INTO Mecanicos (nome, endereco, especialidade) VALUES 
('Carlos Souza', 'Rua C, 50', 'Motorista'),
('Ana Lima', 'Rua D, 75', 'Eletricista');

-- Inserir Equipes
INSERT INTO Equipes (nome_equipe) VALUES 
('Equipe 1'),
('Equipe 2');

-- Inserir Mecânicos_Equipes
INSERT INTO Mecanicos_Equipes (Mecanicos_idMecanicos, Equipes_idEquipes) VALUES 
(1, 1),
(2, 2);

-- Inserir Serviços
INSERT INTO Servicos (descricao, valor_mao_obra) VALUES 
('Troca de óleo', 50.0),
('Alinhamento', 80.0);

-- Inserir Ordens de Serviço
INSERT INTO Ordens_Servico (numero_os, data_emissao, valor_total, status, data_conclusao, Veiculos_idVeiculo, Equipes_idEquipes, Clientes_idClientes) VALUES 
('OS001', '2024-12-01', 150.0, 'Em andamento', NULL, 1, 1, 1),
('OS002', '2024-12-02', 120.0, 'Concluído', '2024-12-05', 2, 2, 2);

-- Inserir Itens de Ordem de Serviço
INSERT INTO Itens_OS (descricao_peca, valor_item, quantidade, Ordens_Serviço_idOS, Servicos_idServicos) VALUES 
('Óleo', 30.0, 1, 1, 1),
('Pneu', 60.0, 2, 2, 2);

-- Consultas SQL

-- Recuperação simples com SELECT Statement
SELECT nome, endereco, telefone FROM Clientes;

-- Filtros com WHERE Statement
SELECT placa, modelo, ano FROM Veiculos WHERE marca = 'Volkswagen';

-- Expressões para gerar atributos derivados
SELECT nome, especialidade, 
       CASE 
           WHEN especialidade = 'Motorista' THEN 'Prioridade Alta'
           ELSE 'Prioridade Baixa'
       END AS prioridade
FROM Mecanicos;

-- Ordenação dos dados com ORDER BY
SELECT nome, telefone FROM Clientes
ORDER BY nome ASC;

-- Condições de filtros aos grupos – HAVING Statement
SELECT nome_equipe, COUNT(*) AS total_mecanicos
FROM Equipes
JOIN Mecanicos_Equipes ON Equipes.idEquipes = Mecanicos_Equipes.Equipes_idEquipes
GROUP BY nome_equipe
HAVING COUNT(*) > 1;

-- Junções entre tabelas
SELECT o.numero_os, c.nome, v.placa, e.nome_equipe, s.descricao, i.quantidade
FROM Ordens_Servico o
JOIN Clientes c ON o.Clientes_idClientes = c.idClientes
JOIN Veiculos v ON o.Veiculos_idVeiculo = v.idVeiculo
JOIN Equipes e ON o.Equipes_idEquipes = e.idEquipes
JOIN Itens_OS i ON o.idOS = i.Ordens_Serviço_idOS
JOIN Servicos s ON i.Servicos_idServicos = s.idServicos
WHERE o.status = 'Em andamento';
