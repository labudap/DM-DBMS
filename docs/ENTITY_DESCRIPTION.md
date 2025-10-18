# Описание таблиц базы данных

## Users
**Назначение:** Хранение учетных записей пользователей системы

1. **id** (UUID, PRIMARY KEY, DEFAULT gen_random_uuid()) [Уникальный идентификатор пользователя]
2. **email** (VARCHAR(255), UNIQUE, NOT NULL) [Электронная почта для входа и уведомлений]
3. **password_hash** (VARCHAR(255), NOT NULL) [Захешированный пароль для безопасности]
4. **username** (VARCHAR(100), UNIQUE) [Уникальное имя для отображения в системе]
5. **created_at** (TIMESTAMPTZ, DEFAULT now()) [Дата и время регистрации]
6. **is_active** (BOOLEAN, DEFAULT true) [Флаг активности учетной записи]

## UserProfiles
**Назначение:** Дополнительная информация о пользователях

1. **user_id** (UUID, PRIMARY KEY, FOREIGN KEY REFERENCES users.id) [Связь с основной таблицей пользователей, один-к-одному]
2. **first_name** (VARCHAR(100)) [Имя пользователя]
3. **last_name** (VARCHAR(100)) [Фамилия пользователя]
4. **avatar_url** (TEXT) [Ссылка на аватар пользователя]
5. **position** (VARCHAR(200)) [Должность или роль в организации]
6. **bio** (TEXT) [Биография или дополнительная информация]
7. **updated_at** (TIMESTAMPTZ, DEFAULT now()) [Дата последнего обновления профиля]

## BoardStatuses
**Назначение:** Справочник статусов досок проектов

1. **id** (UUID, PRIMARY KEY, DEFAULT gen_random_uuid()) [Уникальный идентификатор статуса]
2. **name** (VARCHAR(50), UNIQUE, NOT NULL) [Название статуса: active, archived, deleted]
3. **description** (TEXT) [Описание значения статуса]
4. **order_index** (INT) [Порядковый номер для сортировки]

## BoardRoles
**Назначение:** Справочник ролей участников досок

1. **id** (UUID, PRIMARY KEY, DEFAULT gen_random_uuid()) [Уникальный идентификатор роли]
2. **name** (VARCHAR(50), UNIQUE, NOT NULL) [Название роли: owner, admin, member, viewer]
3. **description** (TEXT) [Описание роли и её возможностей]
4. **permission_level** (INT, NOT NULL) [Числовой уровень прав для сравнения]

## InvitationStatuses
**Назначение:** Справочник статусов приглашений

1. **id** (UUID, PRIMARY KEY, DEFAULT gen_random_uuid()) [Уникальный идентификатор статуса]
2. **name** (VARCHAR(50), UNIQUE, NOT NULL) [Название статуса: pending, accepted, rejected, expired]
3. **description** (TEXT) [Описание значения статуса]

## Boards
**Назначение:** Основные сущности - доски проектов

1. **id** (UUID, PRIMARY KEY, DEFAULT gen_random_uuid()) [Уникальный идентификатор доски]
2. **name** (VARCHAR(200), NOT NULL) [Название доски проекта]
3. **description** (TEXT) [Описание назначения доски]
4. **creator_id** (UUID, FOREIGN KEY REFERENCES users.id, NOT NULL) [Создатель доски, связь многие-к-одному с Users]
5. **status_id** (UUID, FOREIGN KEY REFERENCES board_statuses.id, NOT NULL) [Текущий статус доски, связь многие-к-одному с BoardStatuses]
6. **created_at** (TIMESTAMPTZ, DEFAULT now()) [Дата и время создания доски]

## BoardMembers
**Назначение:** Участники досок и их роли

1. **id** (UUID, PRIMARY KEY, DEFAULT gen_random_uuid()) [Уникальный идентификатор членства]
2. **user_id** (UUID, FOREIGN KEY REFERENCES users.id, NOT NULL) [Пользователь-участник, связь многие-к-одному с Users]
3. **board_id** (UUID, FOREIGN KEY REFERENCES boards.id, NOT NULL) [Доска участника, связь многие-к-одному с Boards]
4. **role_id** (UUID, FOREIGN KEY REFERENCES board_roles.id, NOT NULL) [Роль пользователя на доске, связь многие-к-одному с BoardRoles]
5. **joined_at** (TIMESTAMPTZ, DEFAULT now()) [Дата и время присоединения к доске]

## Permissions
**Назначение:** Справочник всех возможных разрешений в системе

1. **id** (UUID, PRIMARY KEY, DEFAULT gen_random_uuid()) [Уникальный идентификатор разрешения]
2. **name** (VARCHAR(100), UNIQUE, NOT NULL) [Название разрешения: create_task, delete_task, manage_members]
3. **description** (TEXT) [Описание действия, которое разрешает]
4. **category** (VARCHAR(50)) [Категория для группировки: tasks, board, members]
5. **order_index** (INT) [Порядковый номер для сортировки]

## RolePermissions
**Назначение:** Связь ролей с разрешениями

1. **id** (UUID, PRIMARY KEY, DEFAULT gen_random_uuid()) [Уникальный идентификатор связи]
2. **board_role_id** (UUID, FOREIGN KEY REFERENCES board_roles.id, NOT NULL) [Роль, связь многие-к-одному с BoardRoles]
3. **permission_id** (UUID, FOREIGN KEY REFERENCES permissions.id, NOT NULL) [Разрешение, связь многие-к-одному с Permissions]

## TaskPriorities
**Назначение:** Справочник приоритетов задач

1. **id** (UUID, PRIMARY KEY, DEFAULT gen_random_uuid()) [Уникальный идентификатор приоритета]
2. **name** (VARCHAR(50), UNIQUE, NOT NULL) [Название приоритета: low, medium, high, critical]
3. **order_index** (INT, NOT NULL) [Порядковый номер для сортировки]
4. **color** (VARCHAR(7)) [Цвет для визуального отображения в HEX]
5. **icon** (VARCHAR(50)) [Название иконки для отображения]

## TaskStatuses
**Назначение:** Справочник статусов задач workflow

1. **id** (UUID, PRIMARY KEY, DEFAULT gen_random_uuid()) [Уникальный идентификатор статуса]
2. **name** (VARCHAR(50), UNIQUE, NOT NULL) [Название статуса: todo, in_progress, review, done]
3. **order_index** (INT, NOT NULL) [Порядковый номер в workflow]
4. **color** (VARCHAR(7)) [Цвет для визуального отображения в HEX]
5. **is_completed** (BOOLEAN, DEFAULT false) [Флаг завершенности статуса]

## Tasks
**Назначение:** Основные сущности - задачи на досках

1. **id** (UUID, PRIMARY KEY, DEFAULT gen_random_uuid()) [Уникальный идентификатор задачи]
2. **title** (VARCHAR(500), NOT NULL) [Заголовок задачи]
3. **description** (TEXT) [Подробное описание задачи]
4. **board_id** (UUID, FOREIGN KEY REFERENCES boards.id, NOT NULL) [Родительская доска, связь многие-к-одному с Boards]
5. **creator_id** (UUID, FOREIGN KEY REFERENCES users.id, NOT NULL) [Создатель задачи, связь многие-к-одному с Users]
6. **assignee_id** (UUID, FOREIGN KEY REFERENCES users.id) [Исполнитель задачи, связь многие-к-одному с Users]
7. **priority_id** (UUID, FOREIGN KEY REFERENCES task_priorities.id) [Приоритет задачи, связь многие-к-одному с TaskPriorities]
8. **status_id** (UUID, FOREIGN KEY REFERENCES task_statuses.id) [Текущий статус, связь многие-к-одному с TaskStatuses]
9. **due_date** (TIMESTAMPTZ) [Срок выполнения задачи]
10. **created_at** (TIMESTAMPTZ, DEFAULT now()) [Дата и время создания]
11. **updated_at** (TIMESTAMPTZ, DEFAULT now()) [Дата и время последнего обновления]
12. **estimate_hours** (NUMERIC(5,2)) [Оценка трудозатрат в часах]
13. **position** (INT, DEFAULT 0) [Позиция для сортировки внутри колонки]
14. **task_tag_id** (UUID, FOREIGN KEY REFERENCES task_tags.id) [Связанный тег, связь многие-к-одному с TaskTags]

## TaskTags
**Назначение:** Метки для категоризации задач

1. **id** (UUID, PRIMARY KEY, DEFAULT gen_random_uuid()) [Уникальный идентификатор тега]
2. **name** (VARCHAR(20), NOT NULL) [Название тега]
3. **color** (VARCHAR(7)) [Цвет тега в HEX формате]
4. **board_id** (UUID, FOREIGN KEY REFERENCES boards.id, NOT NULL) [Родительская доска, связь многие-к-одному с Boards]

## Comments
**Назначение:** Комментарии и обсуждения к задачам

1. **id** (UUID, PRIMARY KEY, DEFAULT gen_random_uuid()) [Уникальный идентификатор комментария]
2. **content** (TEXT, NOT NULL) [Текст комментария]
3. **task_id** (UUID, FOREIGN KEY REFERENCES tasks.id, NOT NULL) [Родительская задача, связь многие-к-одному с Tasks]
4. **author_id** (UUID, FOREIGN KEY REFERENCES users.id, NOT NULL) [Автор комментария, связь многие-к-одному с Users]
5. **created_at** (TIMESTAMPTZ, DEFAULT now()) [Дата и время создания]
6. **updated_at** (TIMESTAMPTZ, DEFAULT now()) [Дата и время последнего редактирования]

## ProjectInvitations
**Назначение:** Управление приглашениями в проекты

1. **id** (UUID, PRIMARY KEY, DEFAULT gen_random_uuid()) [Уникальный идентификатор приглашения]
2. **board_id** (UUID, FOREIGN KEY REFERENCES boards.id, NOT NULL) [Целевая доска, связь многие-к-одному с Boards]
3. **inviter_id** (UUID, FOREIGN KEY REFERENCES users.id, NOT NULL) [Отправитель приглашения, связь многие-к-одному с Users]
4. **invitee_email** (VARCHAR(255), NOT NULL) [Email приглашаемого пользователя]
5. **token** (VARCHAR(100), UNIQUE, NOT NULL) [Уникальный токен для верификации]
6. **status_id** (UUID, FOREIGN KEY REFERENCES invitation_statuses.id, NOT NULL) [Статус приглашения, связь многие-к-одному с InvitationStatuses]
7. **created_at** (TIMESTAMPTZ, DEFAULT now()) [Дата и время отправки]
8. **expires_at** (TIMESTAMPTZ, NOT NULL) [Дата и время истечения срока действия]

## ActivityLog
**Назначение:** Журналирование действий в системе

1. **id** (UUID, PRIMARY KEY, DEFAULT gen_random_uuid()) [Уникальный идентификатор записи]
2. **event_type** (VARCHAR(100), NOT NULL) [Тип события: task_created, task_updated, comment_added]
3. **description** (TEXT) [Текстовое описание события]
4. **user_id** (UUID, FOREIGN KEY REFERENCES users.id) [Пользователь, выполнивший действие, связь многие-к-одному с Users]
5. **board_id** (UUID, FOREIGN KEY REFERENCES boards.id) [Доска, где произошло событие, связь многие-к-одному с Boards]
6. **task_id** (UUID, FOREIGN KEY REFERENCES tasks.id) [Задача, связанная с событием, связь многие-к-одному с Tasks]
7. **old_value** (TEXT) [Предыдущее значение измененного поля]
8. **new_value** (TEXT) [Новое значение измененного поля]
9. **created_at** (TIMESTAMPTZ, DEFAULT now()) [Дата и время события]
