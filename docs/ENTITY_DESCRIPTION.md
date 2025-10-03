# Описание таблиц базы данных

## User
1. **id** (INT, PRIMARY KEY, AUTO_INCREMENT) []
2. **email** (VARCHAR(255), UNIQUE, NOT NULL) []
3. **password_hash** (VARCHAR(255), NOT NULL) []
4. **username** (VARCHAR(50), UNIQUE) []
5. **created_at** (DATETIME, DEFAULT CURRENT_TIMESTAMP) []

## UserProfile
1. **user_id** (INT, PRIMARY KEY, FOREIGN KEY REFERENCES User(id) ON DELETE CASCADE) [1:1 с User]
2. **first_name** (VARCHAR(100)) []
3. **last_name** (VARCHAR(100)) []
4. **avatar_url** (VARCHAR(255)) []
5. **position** (VARCHAR(100)) []
6. **bio** (TEXT) []
7. **updated_at** (DATETIME, ON UPDATE CURRENT_TIMESTAMP) []

## Board
1. **id** (INT, PRIMARY KEY, AUTO_INCREMENT) []
2. **name** (VARCHAR(255), NOT NULL) []
3. **description** (TEXT) []
4. **creator_id** (INT, FOREIGN KEY REFERENCES User(id)) [M:1 с User]
5. **status** (TEXT, DEFAULT 'active') []
6. **created_at** (DATETIME, DEFAULT CURRENT_TIMESTAMP) []

## BoardMember
1. **id** (INT, PRIMARY KEY, AUTO_INCREMENT) []
2. **user_id** (INT, FOREIGN KEY REFERENCES User(id) ON DELETE CASCADE) [M:1 с User]
3. **board_id** (INT, FOREIGN KEY REFERENCES Board(id) ON DELETE CASCADE) [M:1 с Board]
4. **joined_at** (DATETIME, DEFAULT CURRENT_TIMESTAMP) []

## Permission
1. **id** (INT, PRIMARY KEY, AUTO_INCREMENT) []
2. **name** (VARCHAR(50), NOT NULL) []
3. **description** (TEXT) []

## MemberPermissions
1. **id** (INT, PRIMARY KEY, AUTO_INCREMENT) []
2. **board_member_id** (INT, FOREIGN KEY REFERENCES BoardMember(id) ON DELETE CASCADE) [M:1 с BoardMember]
3. **permission_id** (INT, FOREIGN KEY REFERENCES Permission(id) ON DELETE CASCADE) [M:1 с Permission]
4. **granted_at** (DATETIME, DEFAULT CURRENT_TIMESTAMP) []
5. **granted_by** (INT, FOREIGN KEY REFERENCES User(id) ON DELETE SET NULL) [M:1 с User]

## Task
1. **id** (INT, PRIMARY KEY, AUTO_INCREMENT) []
2. **title** (VARCHAR(255), NOT NULL) []
3. **description** (TEXT) []
4. **board_id** (INT, FOREIGN KEY REFERENCES Board(id) ON DELETE CASCADE) [M:1 с Board]
5. **creator_id** (INT, FOREIGN KEY REFERENCES User(id) ON DELETE CASCADE) [M:1 с User]
6. **assignee_id** (INT, FOREIGN KEY REFERENCES User(id) ON DELETE SET NULL) [M:1 с User]
7. **priority_id** (INT, FOREIGN KEY REFERENCES TaskPriority(id) ON DELETE SET NULL) [M:1 с TaskPriority]
8. **status_id** (INT, FOREIGN KEY REFERENCES TaskStatus(id) ON DELETE SET NULL) [M:1 с TaskStatus]
9. **due_date** (DATETIME) []
10. **created_at** (DATETIME, DEFAULT CURRENT_TIMESTAMP) []
11. **updated_at** (DATETIME, ON UPDATE CURRENT_TIMESTAMP) []

## TaskPriority
1. **id** (INT, PRIMARY KEY, AUTO_INCREMENT) []
2. **name** (VARCHAR(50), NOT NULL) []
3. **order_index** (INT) []

## TaskStatus
1. **id** (INT, PRIMARY KEY, AUTO_INCREMENT) []
2. **name** (VARCHAR(50), NOT NULL) []
3. **order_index** (INT) []

## TaskTag
1. **id** (INT, PRIMARY KEY, AUTO_INCREMENT) []
2. **name** (VARCHAR(50), NOT NULL) []
3. **color** (VARCHAR(7)) []
4. **board_id** (INT, FOREIGN KEY REFERENCES Board(id) ON DELETE CASCADE) [M:1 с Board]

## TaskTagAssignments
1. **id** (INT, PRIMARY KEY, AUTO_INCREMENT) []
2. **task_id** (INT, FOREIGN KEY REFERENCES Task(id) ON DELETE CASCADE) [M:1 с Task]
3. **tag_id** (INT, FOREIGN KEY REFERENCES TaskTag(id) ON DELETE CASCADE) [M:1 с TaskTag]
4. **assigned_at** (DATETIME, DEFAULT CURRENT_TIMESTAMP) []
5. **assigned_by** (INT, FOREIGN KEY REFERENCES User(id) ON DELETE SET NULL) []

## Comment
1. **id** (INT, PRIMARY KEY, AUTO_INCREMENT) []
2. **content** (TEXT, NOT NULL) []
3. **task_id** (INT, FOREIGN KEY REFERENCES Task(id) ON DELETE CASCADE) [M:1 с Task]
4. **author_id** (INT, FOREIGN KEY REFERENCES User(id) ON DELETE CASCADE) [M:1 с User]
5. **created_at** (DATETIME, DEFAULT CURRENT_TIMESTAMP) []
6. **updated_at** (DATETIME, ON UPDATE CURRENT_TIMESTAMP) []

## ProjectInvitation
1. **id** (INT, PRIMARY KEY, AUTO_INCREMENT) []
2. **board_id** (INT, FOREIGN KEY REFERENCES Board(id) ON DELETE CASCADE) [M:1 с Board]
3. **inviter_id** (INT, FOREIGN KEY REFERENCES User(id) ON DELETE CASCADE) [M:1 с User]
4. **invitee_email** (VARCHAR(255), NOT NULL) []
5. **token** (VARCHAR(255), UNIQUE, NOT NULL) []
6. **status** (ENUM, DEFAULT 'pending') []
7. **created_at** (DATETIME, DEFAULT CURRENT_TIMESTAMP) []
8. **expires_at** (DATETIME) []

## ActivityLog
1. **id** (INT, PRIMARY KEY, AUTO_INCREMENT) []
2. **event_type** (VARCHAR(50), NOT NULL) []
3. **description** (TEXT) []
4. **user_id** (INT, FOREIGN KEY REFERENCES User(id) ON DELETE SET NULL) [M:1 с User]
5. **board_id** (INT, FOREIGN KEY REFERENCES Board(id) ON DELETE CASCADE) [M:1 с Board]
6. **task_id** (INT, FOREIGN KEY REFERENCES Task(id) ON DELETE CASCADE) [M:1 с Task]
7. **old_value** (TEXT) []
8. **new_value** (TEXT) []
9. **created_at** (DATETIME, DEFAULT CURRENT_TIMESTAMP) []