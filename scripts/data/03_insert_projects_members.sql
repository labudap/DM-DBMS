INSERT INTO boards (id, name, description, creator_id, status_id) VALUES
(gen_random_uuid(), 'Разработка мобильного приложения', 'Создание кроссплатформенного мобильного приложения для iOS и Android с использованием React Native', 
 (SELECT id FROM users WHERE email = 'alex.ivanov@company.com'),
 (SELECT id FROM board_statuses WHERE name = 'active')),

(gen_random_uuid(), 'Веб-сайт компании', 'Полный редизайн и разработка нового корпоративного сайта с системой управления контентом', 
 (SELECT id FROM users WHERE email = 'elena.kozlova@company.com'),
 (SELECT id FROM board_statuses WHERE name = 'active')),

(gen_random_uuid(), 'Внутренняя система отчетности', 'Автоматизация процессов отчетности для отдела продаж и аналитики', 
 (SELECT id FROM users WHERE email = 'alex.ivanov@company.com'),
 (SELECT id FROM board_statuses WHERE name = 'active')),

(gen_random_uuid(), 'Маркетинговая кампания Q3', 'Проведение маркетинговой кампании для продвижения новых продуктов', 
 (SELECT id FROM users WHERE email = 'elena.kozlova@company.com'),
 (SELECT id FROM board_statuses WHERE name = 'completed')),

(gen_random_uuid(), 'Обновление CRM системы', 'Миграция на новую версию CRM системы с доработкой функционала', 
 (SELECT id FROM users WHERE email = 'alex.ivanov@company.com'),
 (SELECT id FROM board_statuses WHERE name = 'paused'));

INSERT INTO board_members (id, user_id, board_id, role_id) VALUES
(gen_random_uuid(), (SELECT id FROM users WHERE email = 'alex.ivanov@company.com'), 
 (SELECT id FROM boards WHERE name = 'Разработка мобильного приложения'),
 (SELECT id FROM board_roles WHERE name = 'owner')),

(gen_random_uuid(), (SELECT id FROM users WHERE email = 'maria.petrova@company.com'), 
 (SELECT id FROM boards WHERE name = 'Разработка мобильного приложения'),
 (SELECT id FROM board_roles WHERE name = 'admin')),

(gen_random_uuid(), (SELECT id FROM users WHERE email = 'dmitry.sidorov@company.com'), 
 (SELECT id FROM boards WHERE name = 'Разработка мобильного приложения'),
 (SELECT id FROM board_roles WHERE name = 'member')),

(gen_random_uuid(), (SELECT id FROM users WHERE email = 'sergey.smirnov@company.com'), 
 (SELECT id FROM boards WHERE name = 'Разработка мобильного приложения'),
 (SELECT id FROM board_roles WHERE name = 'member')),

(gen_random_uuid(), (SELECT id FROM users WHERE email = 'olga.volkova@company.com'), 
 (SELECT id FROM boards WHERE name = 'Разработка мобильного приложения'),
 (SELECT id FROM board_roles WHERE name = 'viewer')),

(gen_random_uuid(), (SELECT id FROM users WHERE email = 'elena.kozlova@company.com'), 
 (SELECT id FROM boards WHERE name = 'Веб-сайт компании'),
 (SELECT id FROM board_roles WHERE name = 'owner')),

(gen_random_uuid(), (SELECT id FROM users WHERE email = 'maria.petrova@company.com'), 
 (SELECT id FROM boards WHERE name = 'Веб-сайт компании'),
 (SELECT id FROM board_roles WHERE name = 'admin')),

(gen_random_uuid(), (SELECT id FROM users WHERE email = 'olga.volkova@company.com'), 
 (SELECT id FROM boards WHERE name = 'Веб-сайт компании'),
 (SELECT id FROM board_roles WHERE name = 'member')),

(gen_random_uuid(), (SELECT id FROM users WHERE email = 'alex.ivanov@company.com'), 
 (SELECT id FROM boards WHERE name = 'Внутренняя система отчетности'),
 (SELECT id FROM board_roles WHERE name = 'owner')),

(gen_random_uuid(), (SELECT id FROM users WHERE email = 'dmitry.sidorov@company.com'), 
 (SELECT id FROM boards WHERE name = 'Внутренняя система отчетности'),
 (SELECT id FROM board_roles WHERE name = 'member')),

(gen_random_uuid(), (SELECT id FROM users WHERE email = 'elena.kozlova@company.com'), 
 (SELECT id FROM boards WHERE name = 'Маркетинговая кампания Q3'),
 (SELECT id FROM board_roles WHERE name = 'owner')),

(gen_random_uuid(), (SELECT id FROM users WHERE email = 'alex.ivanov@company.com'), 
 (SELECT id FROM boards WHERE name = 'Обновление CRM системы'),
 (SELECT id FROM board_roles WHERE name = 'owner'));
