-- Adotei a verificação do "if not exists" para garantir que posso 
-- ir adicionando mais scripts sem perder o historico do que já fiz
-- Cria o DB, caso não exista
CREATE DATABASE IF NOT EXISTS Livraria;

-- Usa o banco de dados criado
USE Livraria;

-- Criar da tabela Editora, se não existir
CREATE TABLE IF NOT EXISTS Editora (
    idEditora INT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(50),
    endereco VARCHAR(100)
);

-- Criar a tabela Livro, se não existir
CREATE TABLE IF NOT EXISTS Livro (
    idLivro INT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    autor VARCHAR(50) NOT NULL,
    ano INT,
    ISBN VARCHAR(20),
    preco DECIMAL(5, 2) NOT NULL,
    idEditora INT NOT NULL,
    FOREIGN KEY (idEditora) REFERENCES Editora(idEditora)
);

-- Criar a tabela Cliente, se não existir
CREATE TABLE IF NOT EXISTS Cliente (
    idCliente INT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(50),
    endereco VARCHAR(100)
);

-- Criar a tabela Pedido, se não existir
CREATE TABLE IF NOT EXISTS Pedido (
    idPedido INT PRIMARY KEY,
    idCliente INT NOT NULL,
    dataPedido DATE NOT NULL,
    valorPedido DECIMAL(5, 2) NOT NULL,
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);

-- Criar a tabela ItemPedido, se não existir
CREATE TABLE IF NOT EXISTS ItemPedido (
    idPedido INT,
    idLivro INT,
    quantidade INT NOT NULL,
    valorItemPedido DECIMAL(5, 2) NOT NULL,
    PRIMARY KEY (idPedido, idLivro),
    FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido),
    FOREIGN KEY (idLivro) REFERENCES Livro(idLivro)
);

-- Criar a tabela Estoque, se não existir
CREATE TABLE IF NOT EXISTS Estoque (
    idLivro INT PRIMARY KEY,
    quantidade INT NOT NULL,
    FOREIGN KEY (idLivro) REFERENCES Livro(idLivro)
);

-- CONSULTAS 

-- Query para contar o total de livros cadastrados
SELECT COUNT(*) AS TotalOfBooks FROM Livro;

-- Query para listar os nomes dos clientes em ordem crescente
SELECT nome FROM Cliente ORDER BY nome ASC;

-- Query para listar as editoras e seus respectivos livros em ordem decrescente pelo nome da editora
SELECT e.nome AS Editora, l.titulo AS Livro
FROM Editora e
JOIN Livro l ON e.idEditora = l.idEditora
ORDER BY e.nome DESC;

-- query para listar o nome das editoras e a média de preço dos livros
SELECT e.nome AS Editora, AVG(l.preco) AS MediaPreco
FROM Editora e
JOIN Livro l ON e.idEditora = l.idEditora
GROUP BY e.nome;

-- queryy para listar o nome dos clientes e a quantidade de livros comprados
SELECT c.nome AS Cliente, COUNT(ip.idLivro) AS LivrosComprados
FROM Cliente c
JOIN Pedido p ON c.idCliente = p.idCliente
JOIN ItemPedido ip ON p.idPedido = ip.idPedido
GROUP BY c.nome;
