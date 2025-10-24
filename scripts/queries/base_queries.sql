-- =============================================
-- ПУЛ SQL ЗАПРОСОВ ДЛЯ ОПЕРАЦИЙ С БАЗОЙ ДАННЫХ
-- Task Manager System
-- Лабораторная работа №3
-- =============================================

-- =============================================
-- 1. БАЗОВЫЕ SELECT ЗАПРОСЫ
-- =============================================

-- Назначение: Получение всех пользователей с профилями
-- Использование: Просмотр списка пользователей системы
SELECT 
    u.id,
    u.email,
    u.username,
    u.is_active,
    up.first_name,
    up.last_name,
    up.position
FROM users u
JOIN user_profiles up ON u.id = up.user_id
ORDER BY up.first_name, up.last_name;

-- =============================================
-- Назначение: Получение всех проектов с создателями
-- Использование: Обзор всех проектов в системе
SELECT 
    b.id,
    b.name,
    b.description,
    bs.name as status,
    u.email as creator_email,
    up.first_name || ' ' || up.last_name as creator_name,
    b.created_at
FROM boards b
JOIN board_statuses bs ON b.status_id = bs.id
JOIN users u ON b.creator_id = u.id
JOIN user_profiles up ON u.id = up.user_id
ORDER BY b.created_at DESC;

-- =============================================
-- Назначение: Получение всех задач с полной информацией
-- Использование: Общий обзор задач системы
SELECT 
    t.id,
    t.title,
    t.description,
    b.name as project_name,
    ts.name as status,
    tp.name as priority,
    creator_up.first_name || ' ' || creator_up.last_name as creator,
    assignee_up.first_name || ' ' || assignee_up.last_name as assignee,
    t.due_date,
    t.estimate_hours,
    t.created_at
FROM tasks t
JOIN boards b ON t.board_id = b.id
JOIN task_statuses ts ON t.status_id = ts.id
JOIN task_priorities tp ON t.priority_id = tp.id
JOIN users creator ON t.creator_id = creator.id
JOIN user_profiles creator_up ON creator.id = creator_up.user_id
LEFT JOIN users assignee ON t.assignee_id = assignee.id
LEFT JOIN user_profiles assignee_up ON assignee.id = assignee_up.user_id
ORDER BY t.created_at DESC;

-- =============================================
-- 2. ЗАПРОСЫ С ФИЛЬТРАЦИЕЙ
-- =============================================

-- Назначение: Задачи по конкретному статусу
-- Использование: Фильтрация задач по статусу выполнения
SELECT 
    t.title,
    b.name as project_name,
    ts.name as status,
    t.due_date
FROM tasks t
JOIN boards b ON t.board_id = b.id
JOIN task_statuses ts ON t.status_id = ts.id
WHERE ts.name = 'В работе'
ORDER BY t.due_date;

-- =============================================
-- Назначение: Задачи с высоким приоритетом
-- Использование: Поиск срочных задач для приоритизации
SELECT 
    t.title,
    tp.name as priority,
    b.name as project_name,
    t.due_date
FROM tasks t
JOIN task_priorities tp ON t.priority_id = tp.id
JOIN boards b ON t.board_id = b.id
WHERE tp.name IN ('high', 'critical')
ORDER BY tp.order_index DESC, t.due_date;

-- =============================================
-- Назначение: Просроченные задачи
-- Использование: Контроль сроков выполнения задач
SELECT 
    t.title,
    b.name as project_name,
    t.due_date,
    assignee_up.first_name || ' ' || assignee_up.last_name as assignee
FROM tasks t
JOIN boards b ON t.board_id = b.id
JOIN task_statuses ts ON t.status_id = ts.id
LEFT JOIN users assignee ON t.assignee_id = assignee.id
LEFT JOIN user_profiles assignee_up ON assignee.id = assignee_up.user_id
WHERE t.due_date < CURRENT_DATE 
AND ts.is_completed = false
ORDER BY t.due_date;

-- =============================================
-- Назначение: Участники конкретного проекта
-- Использование: Управление командой проекта
SELECT 
    up.first_name,
    up.last_name,
    up.position,
    br.name as role,
    bm.joined_at
FROM board_members bm
JOIN users u ON bm.user_id = u.id
JOIN user_profiles up ON u.id = up.user_id
JOIN board_roles br ON bm.role_id = br.id
WHERE bm.board_id = (SELECT id FROM boards WHERE name = 'Разработка мобильного приложения')
ORDER BY br.permission_level DESC, up.first_name;

-- =============================================
-- 3. АГРЕГИРУЮЩИЕ ЗАПРОСЫ
-- =============================================

-- Назначение: Статистика по задачам в проектах
-- Использование: Анализ загрузки проектов
SELECT 
    b.name as project_name,
    COUNT(t.id) as total_tasks,
    COUNT(t.id) FILTER (WHERE ts.is_completed = true) as completed_tasks,
    COUNT(t.id) FILTER (WHERE ts.is_completed = false) as active_tasks,
    AVG(t.estimate_hours) as avg_estimate_hours
FROM boards b
LEFT JOIN tasks t ON b.id = t.board_id
LEFT JOIN task_statuses ts ON t.status_id = ts.id
GROUP BY b.id, b.name
ORDER BY total_tasks DESC;

-- =============================================
-- Назначение: Количество задач по статусам
-- Использование: Анализ workflow системы
SELECT 
    ts.name as status,
    COUNT(t.id) as task_count
FROM tasks t
JOIN task_statuses ts ON t.status_id = ts.id
GROUP BY ts.name, ts.order_index
ORDER BY ts.order_index;

-- =============================================
-- Назначение: Активность пользователей по комментариям
-- Использование: Оценка вовлеченности участников
SELECT 
    up.first_name || ' ' || up.last_name as user_name,
    COUNT(c.id) as comment_count,
    COUNT(DISTINCT c.task_id) as tasks_commented
FROM comments c
JOIN users u ON c.author_id = u.id
JOIN user_profiles up ON u.id = up.user_id
GROUP BY u.id, up.first_name, up.last_name
ORDER BY comment_count DESC;

-- =============================================
-- 4. JOIN ЗАПРОСЫ ДЛЯ СЛОЖНЫХ СВЯЗЕЙ
-- =============================================

-- Назначение: Полная информация о задаче с тегами и комментариями
-- Использование: Детальный просмотр задачи
SELECT 
    t.title,
    t.description,
    b.name as project_name,
    ts.name as status,
    tp.name as priority,
    creator_up.first_name || ' ' || creator_up.last_name as creator,
    assignee_up.first_name || ' ' || assignee_up.last_name as assignee,
    tt.name as tag_name,
    tt.color as tag_color,
    COUNT(c.id) as comment_count
FROM tasks t
JOIN boards b ON t.board_id = b.id
JOIN task_statuses ts ON t.status_id = ts.id
JOIN task_priorities tp ON t.priority_id = tp.id
JOIN users creator ON t.creator_id = creator.id
JOIN user_profiles creator_up ON creator.id = creator_up.user_id
LEFT JOIN users assignee ON t.assignee_id = assignee.id
LEFT JOIN user_profiles assignee_up ON assignee.id = assignee_up.user_id
LEFT JOIN task_tags tt ON t.task_tag_id = tt.id
LEFT JOIN comments c ON t.id = c.task_id
GROUP BY t.id, t.title, t.description, b.name, ts.name, tp.name, 
         creator_up.first_name, creator_up.last_name, 
         assignee_up.first_name, assignee_up.last_name,
         tt.name, tt.color;

-- =============================================
-- Назначение: Комментарии с информацией об авторах и задачах
-- Использование: Просмотр обсуждений по задачам
SELECT 
    c.content,
    c.created_at,
    up.first_name || ' ' || up.last_name as author,
    t.title as task_title,
    b.name as project_name
FROM comments c
JOIN users u ON c.author_id = u.id
JOIN user_profiles up ON u.id = up.user_id
JOIN tasks t ON c.task_id = t.id
JOIN boards b ON t.board_id = b.id
ORDER BY c.created_at DESC;

-- =============================================
-- 5. INSERT ОПЕРАЦИИ (ДОБАВЛЕНИЕ ДАННЫХ)
-- =============================================

-- Назначение: Добавление нового пользователя
-- Использование: Регистрация новых пользователей в системе
WITH new_user AS (
    INSERT INTO users (id, email, password_hash, username)
    VALUES (gen_random_uuid(), 'new.user@company.com', '$2a$10$newuserhash123456789', 'new_user')
    RETURNING id
)
INSERT INTO user_profiles (user_id, first_name, last_name, position)
SELECT id, 'Новый', 'Пользователь', 'Developer'
FROM new_user;

-- =============================================
-- Назначение: Создание новой задачи
-- Использование: Добавление задач в проекты
INSERT INTO tasks (
    id, title, description, board_id, creator_id, 
    priority_id, status_id, due_date, estimate_hours
)
VALUES (
    gen_random_uuid(),
    'Новая задача',
    'Описание новой задачи',
    (SELECT id FROM boards WHERE name = 'Разработка мобильного приложения'),
    (SELECT id FROM users WHERE email = 'alex.ivanov@company.com'),
    (SELECT id FROM task_priorities WHERE name = 'medium'),
    (SELECT id FROM task_statuses WHERE name = 'Новая'),
    '2024-03-15 18:00:00+03',
    8.0
);

-- =============================================
-- Назначение: Добавление комментария к задаче
-- Использование: Обсуждение задач между участниками
INSERT INTO comments (id, content, task_id, author_id)
VALUES (
    gen_random_uuid(),
    'Новый комментарий к задаче',
    (SELECT id FROM tasks WHERE title = 'Разработать UI компоненты'),
    (SELECT id FROM users WHERE email = 'maria.petrova@company.com')
);

-- =============================================
-- 6. UPDATE ОПЕРАЦИИ (ИЗМЕНЕНИЕ ДАННЫХ)
-- =============================================

-- Назначение: Изменение статуса задачи
-- Использование: Обновление прогресса выполнения задачи
UPDATE tasks 
SET 
    status_id = (SELECT id FROM task_statuses WHERE name = 'В работе'),
    updated_at = CURRENT_TIMESTAMP
WHERE title = 'Настроить API сервер';

-- =============================================
-- Назначение: Назначение исполнителя задачи
-- Использование: Распределение задач между участниками
UPDATE tasks 
SET 
    assignee_id = (SELECT id FROM users WHERE email = 'dmitry.sidorov@company.com'),
    updated_at = CURRENT_TIMESTAMP
WHERE title = 'Новая задача';

-- =============================================
-- Назначение: Обновление профиля пользователя
-- Использование: Редактирование информации о пользователе
UPDATE user_profiles 
SET 
    position = 'Senior Developer',
    updated_at = CURRENT_TIMESTAMP
WHERE user_id = (SELECT id FROM users WHERE email = 'maria.petrova@company.com');

-- =============================================
-- Назначение: Изменение срока выполнения задачи
-- Использование: Корректировка дедлайнов
UPDATE tasks 
SET 
    due_date = '2024-03-20 18:00:00+03',
    updated_at = CURRENT_TIMESTAMP
WHERE title = 'Реализовать адаптивную верстку';

-- =============================================
-- 7. DELETE ОПЕРАЦИИ (УДАЛЕНИЕ ДАННЫХ)
-- =============================================

-- Назначение: Удаление комментария
-- Использование: Модерация контента
DELETE FROM comments 
WHERE id = (
    SELECT c.id 
    FROM comments c 
    JOIN users u ON c.author_id = u.id 
    WHERE c.content LIKE '%тесты%' 
    AND u.email = 'maria.petrova@company.com'
    LIMIT 1
);

-- =============================================
-- Назначение: Удаление участника из проекта
-- Использование: Управление составом команды
DELETE FROM board_members 
WHERE user_id = (SELECT id FROM users WHERE email = 'olga.volkova@company.com')
AND board_id = (SELECT id FROM boards WHERE name = 'Разработка мобильного приложения');

-- =============================================
-- Назначение: Удаление тега из задачи
-- Использование: Изменение категоризации задачи
UPDATE tasks 
SET task_tag_id = NULL 
WHERE title = 'Написать документацию API';

-- =============================================
-- 8. СЛУЖЕБНЫЕ ЗАПРОСЫ ДЛЯ ПРОВЕРКИ ДАННЫХ
-- =============================================

-- Назначение: Проверка целостности данных
-- Использование: Валидация состояния базы данных
SELECT 
    'users' as table_name, COUNT(*) as records FROM users
UNION ALL SELECT 'user_profiles', COUNT(*) FROM user_profiles
UNION ALL SELECT 'boards', COUNT(*) FROM boards
UNION ALL SELECT 'board_members', COUNT(*) FROM board_members
UNION ALL SELECT 'tasks', COUNT(*) FROM tasks
UNION ALL SELECT 'comments', COUNT(*) FROM comments
UNION ALL SELECT 'activity_log', COUNT(*) FROM activity_log
ORDER BY table_name;

-- =============================================
-- Назначение: Поиск дубликатов email
-- Использование: Проверка уникальности пользователей
SELECT email, COUNT(*) as duplicate_count
FROM users
GROUP BY email
HAVING COUNT(*) > 1;

-- =============================================
-- Назначение: Задачи без исполнителя
-- Использование: Выявление неназначенных задач
SELECT 
    t.title,
    b.name as project_name,
    t.created_at
FROM tasks t
JOIN boards b ON t.board_id = b.id
WHERE t.assignee_id IS NULL
ORDER BY t.created_at DESC;

-- =============================================
-- 9. ЗАПРОСЫ ДЛЯ ОТЧЕТНОСТИ
-- =============================================

-- Назначение: Еженедельная активность по проектам
-- Использование: Анализ активности в системе
SELECT 
    b.name as project_name,
    DATE_TRUNC('week', al.created_at) as week,
    COUNT(al.id) as activity_count
FROM activity_log al
JOIN boards b ON al.board_id = b.id
WHERE al.created_at >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY b.name, DATE_TRUNC('week', al.created_at)
ORDER BY week DESC, activity_count DESC;

-- =============================================
-- Назначение: Распределение задач по приоритетам
-- Использование: Анализ приоритизации задач
SELECT 
    tp.name as priority,
    COUNT(t.id) as task_count,
    ROUND(COUNT(t.id) * 100.0 / (SELECT COUNT(*) FROM tasks), 2) as percentage
FROM tasks t
RIGHT JOIN task_priorities tp ON t.priority_id = tp.id
GROUP BY tp.name, tp.order_index
ORDER BY tp.order_index DESC;

-- =============================================
-- Назначение: Среднее время выполнения задач
-- Использование: Анализ эффективности workflow
SELECT 
    ts.name as status,
    AVG(EXTRACT(EPOCH FROM (t.updated_at - t.created_at)) / 3600) as avg_hours_to_status
FROM tasks t
JOIN task_statuses ts ON t.status_id = ts.id
WHERE ts.is_completed = true
GROUP BY ts.name, ts.order_index
ORDER BY ts.order_index;

-- =============================================
-- 10. ПРИМЕРЫ СЛОЖНЫХ ЗАПРОСОВ ДЛЯ ДЕМОНСТРАЦИИ
-- =============================================

-- Назначение: Полная статистика по пользователю
-- Использование: Профиль пользователя с аналитикой
SELECT 
    up.first_name || ' ' || up.last_name as user_name,
    up.position,
    COUNT(DISTINCT bm.board_id) as projects_count,
    COUNT(DISTINCT t.id) as created_tasks,
    COUNT(DISTINCT t2.id) as assigned_tasks,
    COUNT(DISTINCT c.id) as comments_written
FROM users u
JOIN user_profiles up ON u.id = up.user_id
LEFT JOIN board_members bm ON u.id = bm.user_id
LEFT JOIN tasks t ON u.id = t.creator_id
LEFT JOIN tasks t2 ON u.id = t2.assignee_id
LEFT JOIN comments c ON u.id = c.author_id
WHERE u.email = 'alex.ivanov@company.com'
GROUP BY up.first_name, up.last_name, up.position;

-- =============================================
-- Назначение: Детальная история изменений задачи
-- Использование: Аудит изменений по задаче
SELECT 
    al.event_type,
    al.description,
    up.first_name || ' ' || up.last_name as user_name,
    al.created_at,
    al.old_value,
    al.new_value
FROM activity_log al
JOIN users u ON al.user_id = u.id
JOIN user_profiles up ON u.id = up.user_id
WHERE al.task_id = (SELECT id FROM tasks WHERE title = 'Разработать UI компоненты')
ORDER BY al.created_at DESC;

-- =============================================
-- КОНЕЦ ФАЙЛА SQL ЗАПРОСОВ
-- =============================================
