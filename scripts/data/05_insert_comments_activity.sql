INSERT INTO comments (id, content, task_id, author_id) VALUES
(gen_random_uuid(), 'Начал работу над компонентами. Создал базовую структуру кнопок и форм. Ожидаю завершить основные компоненты к среде.',
 (SELECT id FROM tasks WHERE title = 'Разработать UI компоненты'),
 (SELECT id FROM users WHERE email = 'maria.petrova@company.com')),

(gen_random_uuid(), 'Отлично! Не забудь добавить тесты для компонентов и проверить accessibility.',
 (SELECT id FROM tasks WHERE title = 'Разработать UI компоненты'),
 (SELECT id FROM users WHERE email = 'alex.ivanov@company.com')),

(gen_random_uuid(), 'Добавил тесты для всех основных компонентов. Проверил accessibility - все соответствует WCAG 2.1.',
 (SELECT id FROM tasks WHERE title = 'Разработать UI компоненты'),
 (SELECT id FROM users WHERE email = 'maria.petrova@company.com')),

(gen_random_uuid(), 'Приступил к настройке сервера. Нужны доступы к production среде для развертывания.',
 (SELECT id FROM tasks WHERE title = 'Настроить API сервер'),
 (SELECT id FROM users WHERE email = 'dmitry.sidorov@company.com')),

(gen_random_uuid(), 'Доступы предоставлены. Проверь подключение к базе данных.',
 (SELECT id FROM tasks WHERE title = 'Настроить API сервер'),
 (SELECT id FROM users WHERE email = 'alex.ivanov@company.com')),

(gen_random_uuid(), 'Обнаружил причину ошибки - проблема с индексами в базе данных. Исправляю.',
 (SELECT id FROM tasks WHERE title = 'Исправить критическую ошибку в отчетах'),
 (SELECT id FROM users WHERE email = 'dmitry.sidorov@company.com')),

(gen_random_uuid(), 'Ошибка исправлена. Система стабильно работает. Рекомендую провести дополнительное тестирование.',
 (SELECT id FROM tasks WHERE title = 'Исправить критическую ошибку в отчетах'),
 (SELECT id FROM users WHERE email = 'dmitry.sidorov@company.com'));

INSERT INTO activity_log (id, event_type, description, user_id, board_id, task_id, old_value, new_value) VALUES
(gen_random_uuid(), 'task_created', 'Создана новая задача', 
 (SELECT id FROM users WHERE email = 'alex.ivanov@company.com'),
 (SELECT id FROM boards WHERE name = 'Разработка мобильного приложения'),
 (SELECT id FROM tasks WHERE title = 'Разработать UI компоненты'),
 NULL, '{"title": "Разработать UI компоненты", "status": "Новая"}'),

(gen_random_uuid(), 'task_created', 'Создана новая задача', 
 (SELECT id FROM users WHERE email = 'alex.ivanov@company.com'),
 (SELECT id FROM boards WHERE name = 'Разработка мобильного приложения'),
 (SELECT id FROM tasks WHERE title = 'Настроить API сервер'),
 NULL, '{"title": "Настроить API сервер", "status": "Новая"}'),

(gen_random_uuid(), 'task_status_changed', 'Изменен статус задачи', 
 (SELECT id FROM users WHERE email = 'maria.petrova@company.com'),
 (SELECT id FROM boards WHERE name = 'Разработка мобильного приложения'),
 (SELECT id FROM tasks WHERE title = 'Разработать UI компоненты'),
 '{"status": "Новая"}', '{"status": "В работе"}'),

(gen_random_uuid(), 'task_status_changed', 'Изменен статус задачи', 
 (SELECT id FROM users WHERE email = 'olga.volkova@company.com'),
 (SELECT id FROM boards WHERE name = 'Разработка мобильного приложения'),
 (SELECT id FROM tasks WHERE title = 'Создать дизайн иконок'),
 '{"status": "В работе"}', '{"status": "Выполнена"}'),

(gen_random_uuid(), 'task_assigned', 'Назначен исполнитель задачи', 
 (SELECT id FROM users WHERE email = 'alex.ivanov@company.com'),
 (SELECT id FROM boards WHERE name = 'Разработка мобильного приложения'),
 (SELECT id FROM tasks WHERE title = 'Разработать UI компоненты'),
 NULL, '{"assignee": "Мария Петрова"}'),

(gen_random_uuid(), 'task_assigned', 'Назначен исполнитель задачи', 
 (SELECT id FROM users WHERE email = 'alex.ivanov@company.com'),
 (SELECT id FROM boards WHERE name = 'Разработка мобильного приложения'),
 (SELECT id FROM tasks WHERE title = 'Настроить API сервер'),
 NULL, '{"assignee": "Дмитрий Сидоров"}'),

(gen_random_uuid(), 'comment_added', 'Добавлен комментарий к задаче', 
 (SELECT id FROM users WHERE email = 'maria.petrova@company.com'),
 (SELECT id FROM boards WHERE name = 'Разработка мобильного приложения'),
 (SELECT id FROM tasks WHERE title = 'Разработать UI компоненты'),
 NULL, '{"comment_length": 125}'),

(gen_random_uuid(), 'project_member_added', 'Добавлен участник проекта', 
 (SELECT id FROM users WHERE email = 'alex.ivanov@company.com'),
 (SELECT id FROM boards WHERE name = 'Разработка мобильного приложения'),
 NULL,
 NULL, '{"member": "Сергей Смирнов", "role": "member"}'),

(gen_random_uuid(), 'project_member_added', 'Добавлен участник проекта', 
 (SELECT id FROM users WHERE email = 'alex.ivanov@company.com'),
 (SELECT id FROM boards WHERE name = 'Разработка мобильного приложения'),
 NULL,
 NULL, '{"member": "Ольга Волкова", "role": "viewer"}');

INSERT INTO project_invitations (id, board_id, inviter_id, invitee_email, token, status_id, created_at, expires_at) VALUES
(gen_random_uuid(), 
 (SELECT id FROM boards WHERE name = 'Разработка мобильного приложения'),
 (SELECT id FROM users WHERE email = 'alex.ivanov@company.com'),
 'new.developer@company.com',
 'invite_token_abc123',
 (SELECT id FROM invitation_statuses WHERE name = 'pending'),
 now(),
 now() + interval '7 days'),

(gen_random_uuid(), 
 (SELECT id FROM boards WHERE name = 'Веб-сайт компании'),
 (SELECT id FROM users WHERE email = 'elena.kozlova@company.com'),
 'maria.petrova@company.com',
 'invite_token_def456',
 (SELECT id FROM invitation_statuses WHERE name = 'accepted'),
 now() - interval '2 days',
 now() + interval '5 days'),

(gen_random_uuid(), 
 (SELECT id FROM boards WHERE name = 'Внутренняя система отчетности'),
 (SELECT id FROM users WHERE email = 'alex.ivanov@company.com'),
 'expired.user@company.com',
 'invite_token_ghi789',
 (SELECT id FROM invitation_statuses WHERE name = 'expired'),
 now() - interval '10 days',
 now() - interval '3 days');
