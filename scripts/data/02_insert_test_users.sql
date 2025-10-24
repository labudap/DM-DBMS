INSERT INTO users (id, email, password_hash, username, is_active) VALUES
(gen_random_uuid(), 'alex.ivanov@company.com', '$2a$10$ABC123def456ghi789jkl0', 'alex_ivanov', true),
(gen_random_uuid(), 'maria.petrova@company.com', '$2a$10$XYZ789abc012def345ghi6', 'maria_petrova', true),
(gen_random_uuid(), 'dmitry.sidorov@company.com', '$2a$10$LMN012ghi345jkl678mno9', 'dmitry_sidorov', true),
(gen_random_uuid(), 'elena.kozlova@company.com', '$2a$10$PQR345jkl678mno901pqr2', 'elena_kozlova', true),
(gen_random_uuid(), 'sergey.smirnov@company.com', '$2a$10$STU678mno901pqr234stu5', 'sergey_smirnov', true),
(gen_random_uuid(), 'olga.volkova@company.com', '$2a$10$VWX901pqr234stu567vwx8', 'olga_volkova', true);

INSERT INTO user_profiles (user_id, first_name, last_name, avatar_url, position, bio) VALUES
((SELECT id FROM users WHERE email = 'alex.ivanov@company.com'), 'Александр', 'Иванов', '/avatars/alex.jpg', 'Team Lead', 'Опытный руководитель проектов с 8-летним опытом'),
((SELECT id FROM users WHERE email = 'maria.petrova@company.com'), 'Мария', 'Петрова', '/avatars/maria.jpg', 'Frontend Developer', 'Специалист по React, Vue и TypeScript'),
((SELECT id FROM users WHERE email = 'dmitry.sidorov@company.com'), 'Дмитрий', 'Сидоров', '/avatars/dmitry.jpg', 'Backend Developer', 'Разработчик на Python, Node.js и PostgreSQL'),
((SELECT id FROM users WHERE email = 'elena.kozlova@company.com'), 'Елена', 'Козлова', '/avatars/elena.jpg', 'Project Manager', 'Менеджер проектов с 5-летним опытом в IT'),
((SELECT id FROM users WHERE email = 'sergey.smirnov@company.com'), 'Сергей', 'Смирнов', '/avatars/sergey.jpg', 'QA Engineer', 'Инженер по тестированию, автоматизация тестов'),
((SELECT id FROM users WHERE email = 'olga.volkova@company.com'), 'Ольга', 'Волкова', '/avatars/olga.jpg', 'UI/UX Designer', 'Дизайнер интерфейсов, проектирование UX');

INSERT INTO users (id, email, password_hash, username, is_active) VALUES
(gen_random_uuid(), 'blocked.user@company.com', '$2a$10$BLK001blockeduserhash', 'blocked_user', false);
