# Rosha

App de gestão eficiente e sustentável de energia, desenvolvido em um desafio acadêmico. A proposta é permitir que o usuário monitore, controle e otimize o consumo de energia em tempo real, com recomendações personalizadas.

A API (Node.js + MySQL) está em [lucax011/Api_Rosha](https://github.com/lucax011/Api_Rosha).

## Funcionalidades propostas

- **Monitoramento de consumo:** gráficos por dispositivo e período
- **Controle de dispositivos:** ligar e desligar remotamente
- **Recomendações personalizadas:** sugestões com base no padrão de consumo

O app tem hoje as telas de login e cadastro. O cálculo de recomendações roda no banco, pelas rotinas abaixo.

## Stack

- Flutter (Dart) + `flutter_svg`
- API REST em Node.js ([Api_Rosha](https://github.com/lucax011/Api_Rosha))
- MySQL com stored procedures

## Como rodar

Pré-requisitos: Flutter SDK e um emulador ou dispositivo.

```bash
flutter pub get
flutter run
```

## Modelagem de dados

Entidades `users`, `devices`, `energy_usage` e `recommendations`. O script de criação está em [Api_Rosha/schema.sql](https://github.com/lucax011/Api_Rosha/blob/main/schema.sql).

## Rotinas no banco

**Consumo diário simulado:** gera leituras fictícias para cada dispositivo de cada usuário.

```sql
DELIMITER $$
CREATE PROCEDURE InsertDailyEnergyUsage()
BEGIN
  INSERT INTO energy_usage (user_id, device_id, consumption)
  SELECT u.id, d.id, ROUND(RAND() * 5, 2)
  FROM users u
  JOIN devices d ON d.user_id = u.id;
END $$
DELIMITER ;
```

**Geração de recomendações:** calcula o consumo médio de cada usuário e grava uma recomendação conforme a faixa.

```sql
DELIMITER $$
CREATE PROCEDURE GenerateRecommendations()
BEGIN
  DECLARE avg_consumption FLOAT;
  DECLARE v_user_id INT;
  DECLARE done BOOLEAN DEFAULT FALSE;
  DECLARE user_cursor CURSOR FOR SELECT id FROM users;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN user_cursor;
  read_loop: LOOP
    FETCH user_cursor INTO v_user_id;
    IF done THEN LEAVE read_loop; END IF;

    SELECT AVG(consumption) INTO avg_consumption
    FROM energy_usage WHERE user_id = v_user_id;

    IF avg_consumption < 1.5 THEN
      INSERT INTO recommendations (user_id, recommendation, created_at)
      VALUES (v_user_id, 'Consider investing in energy-saving appliances.', CURRENT_TIMESTAMP);
    ELSEIF avg_consumption BETWEEN 1.5 AND 3.0 THEN
      INSERT INTO recommendations (user_id, recommendation, created_at)
      VALUES (v_user_id, 'You are using a moderate amount of energy. Consider optimizing your usage.', CURRENT_TIMESTAMP);
    ELSE
      INSERT INTO recommendations (user_id, recommendation, created_at)
      VALUES (v_user_id, 'You are consuming a high amount of energy. We recommend evaluating your energy sources and consumption patterns.', CURRENT_TIMESTAMP);
    END IF;
  END LOOP;
  CLOSE user_cursor;
END $$
DELIMITER ;
```
