INSERT INTO board_statuses (id, name, description, order_index) VALUES
(gen_random_uuid(), 'active', 'Активный проект', 1),
(gen_random_uuid(), 'completed', 'Завершенный проект', 2),
(gen_random_uuid(), 'paused', 'Приостановленный проект', 3),
(gen_random_uuid(), 'archived', 'Архивированный проект', 4);

INSERT INTO board_roles (id, name, description, permission_level) VALUES
(gen_random_uuid(), 'owner', 'Владелец проекта - полные права', 100),
(gen_random_uuid(), 'admin', 'Администратор - расширенные права', 80),
(gen_random_uuid(), 'member', 'Участник - базовые права', 50),
(gen_random_uuid(), 'viewer', 'Наблюдатель - только просмотр', 10);

INSERT INTO invitation_statuses (id, name, description) VALUES
(gen_random_uuid(), 'pending', 'Ожидает ответа'),
(gen_random_uuid(), 'accepted', 'Принято'),
(gen_random_uuid(), 'rejected', 'Отклонено'),
(gen_random_uuid(), 'expired', 'Истек срок действия');

INSERT INTO task_priorities (id, name, order_index, color, icon) VALUES
(gen_random_uuid(), 'low', 1, '#4CAF50', 'priority_low'),
(gen_random_uuid(), 'medium', 2, '#FFC107', 'priority_medium'),
(gen_random_uuid(), 'high', 3, '#FF9800', 'priority_high'),
(gen_random_uuid(), 'critical', 4, '#F44336', 'priority_critical');

INSERT INTO task_statuses (id, name, order_index, color, is_completed) VALUES
(gen_random_uuid(), 'Новая', 1, '#9E9E9E', false),
(gen_random_uuid(), 'В работе', 2, '#2196F3', false),
(gen_random_uuid(), 'На проверке', 3, '#FFC107', false),
(gen_random_uuid(), 'Выполнена', 4, '#4CAF50', true),
(gen_random_uuid(), 'Отложена', 5, '#FF9800', false),
(gen_random_uuid(), 'Отменена', 6, '#F44336', true);

INSERT INTO permissions (id, name, description, category, order_index) VALUES
(gen_random_uuid(), 'edit_project', 'Редактирование проекта', 'project', 1),
(gen_random_uuid(), 'delete_project', 'Удаление проекта', 'project', 2),
(gen_random_uuid(), 'change_project_status', 'Изменение статуса проекта', 'project', 3),
(gen_random_uuid(), 'invite_members', 'Приглашение участников', 'members', 10),
(gen_random_uuid(), 'remove_members', 'Удаление участников', 'members', 11),
(gen_random_uuid(), 'change_member_roles', 'Изменение ролей участников', 'members', 12),
(gen_random_uuid(), 'create_tasks', 'Создание задач', 'tasks', 20),
(gen_random_uuid(), 'edit_any_tasks', 'Редактирование любых задач', 'tasks', 21),
(gen_random_uuid(), 'edit_own_tasks', 'Редактирование своих задач', 'tasks', 22),
(gen_random_uuid(), 'edit_assigned_tasks', 'Редактирование назначенных задач', 'tasks', 23),
(gen_random_uuid(), 'delete_tasks', 'Удаление задач', 'tasks', 24),
(gen_random_uuid(), 'manage_tags', 'Управление тегами', 'tags', 30),
(gen_random_uuid(), 'use_tags', 'Использование существующих тегов', 'tags', 31),
(gen_random_uuid(), 'add_comments', 'Добавление комментариев', 'comments', 40),
(gen_random_uuid(), 'edit_comments', 'Редактирование комментариев', 'comments', 41),
(gen_random_uuid(), 'delete_comments', 'Удаление комментариев', 'comments', 42),
(gen_random_uuid(), 'view_tasks', 'Просмотр задач', 'view', 50),
(gen_random_uuid(), 'view_activity', 'Просмотр истории изменений', 'view', 51),
(gen_random_uuid(), 'search_tasks', 'Поиск по задачам', 'view', 52),
(gen_random_uuid(), 'filter_tasks', 'Фильтрация задач', 'view', 53);

INSERT INTO role_permissions (id, board_role_id, permission_id)
SELECT 
    gen_random_uuid(),
    br.id,
    p.id
FROM board_roles br
CROSS JOIN permissions p
WHERE 
    (br.name = 'owner') OR
    (br.name = 'admin' AND p.name != 'delete_project') OR
    (br.name = 'member' AND p.name IN (
        'create_tasks', 'edit_own_tasks', 'edit_assigned_tasks', 
        'use_tags', 'add_comments', 'view_tasks', 'view_activity',
        'search_tasks', 'filter_tasks'
    )) OR
    (br.name = 'viewer' AND p.name IN (
        'view_tasks', 'view_activity', 'search_tasks', 'filter_tasks'
    ));