# rosha

O projeto Rosha foi desenvolvido como parte de um desafio acadêmico com foco na criação de soluções tecnológicas que promovam a gestão eficiente e sustentável de energia. O aplicativo permite que usuários monitorem, controlem e otimizem o uso de energia em tempo real, integrando dados de consumo, geração de energia renovável e eficiência.

## Funcionalidades Principais

Monitoramento de Consumo Energético
Exibe gráficos detalhados sobre o consumo de energia, separados por dispositivos e períodos.
Controle de Dispositivos
Permite ligar e desligar dispositivos remotamente para otimizar o uso de energia.
Recomendações Personalizadas
Oferece sugestões baseadas no padrão de consumo de cada usuário, incentivando o uso eficiente da energia.

## Tecnologias Utilizadas
Frontend: Flutter (Dart)
Backend: MySQL para banco de dados com rotinas PL/SQL automatizadas
Linguagem de Programação: Dart (Flutter)
API: RESTful, implementada com suporte ao gerenciamento de consumo e dispositivos
Outros: Boas práticas de gerenciamento de memória e modelagem de dados eficiente


## Modelagem de Dados
DER (Diagrama de Entidade-Relacionamento): Inclui as entidades users, devices, energy_usage, e recommendations, com relações claras para permitir o gerenciamento eficiente de dados.
MER (Modelo Entidade-Relacionamento): Utilizado para representar graficamente os dados estruturados e as conexões entre as tabelas.

## Rotinas Implementadas
Inserção de Consumo Diário
Gera automaticamente dados fictícios de consumo para simular cenários reais.
DELIMITER $$
CREATE PROCEDURE InsertDailyEnergyUsage()
BEGIN
INSERT INTO energy_usage (user_id, device_id, consumption)
SELECT u.id AS user_id, d.id AS device_id, ROUND(RAND() * 5, 2) AS consumption
FROM users u
JOIN devices d ON d.user_id = u.id;
END $$
DELIMITER ;

Geração de Recomendações
Analisa o consumo médio de energia e insere recomendações personalizadas para cada usuário.
DELIMITER $$
CREATE PROCEDURE GenerateRecommendations()
BEGIN
DECLARE avg_consumption FLOAT;
DECLARE user_id INT;
DECLARE done BOOLEAN DEFAULT FALSE;
DECLARE user_cursor CURSOR FOR SELECT u.id FROM users u;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
OPEN user_cursor;
read_loop: LOOP
FETCH user_cursor INTO user_id;
IF done THEN LEAVE read_loop; END IF;
SELECT AVG(consumption) INTO avg_consumption FROM energy_usage WHERE user_id = user_id;
IF avg_consumption < 1.5 THEN
INSERT INTO recommendations (user_id, recommendation, created_at)
VALUES (user_id, 'Consider investing in energy-saving appliances.', CURRENT_TIMESTAMP);
ELSEIF avg_consumption BETWEEN 1.5 AND 3.0 THEN
INSERT INTO recommendations (user_id, recommendation, created_at)
VALUES (user_id, 'You are using a moderate amount of energy. Consider optimizing your usage.', CURRENT_TIMESTAMP);
ELSE
INSERT INTO recommendations (user_id, recommendation, created_at)
VALUES (user_id, 'You are consuming a high amount of energy. We recommend evaluating your energy sources and consumption patterns.', CURRENT_TIMESTAMP);
END IF;
END LOOP;
CLOSE user_cursor;
END $$
DELIMITER ;


