CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    username VARCHAR(100) UNIQUE,
    created_at TIMESTAMPTZ DEFAULT now(),
    is_active BOOLEAN DEFAULT true
);

CREATE TABLE user_profiles (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    avatar_url TEXT,
    position VARCHAR(200),
    bio TEXT,
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE board_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    order_index INT
);

CREATE TABLE board_roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    permission_level INT NOT NULL
);

CREATE TABLE invitation_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT
);

CREATE TABLE boards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(200) NOT NULL,
    description TEXT,
    creator_id UUID REFERENCES users(id) NOT NULL,
    status_id UUID REFERENCES board_statuses(id) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE board_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) NOT NULL,
    board_id UUID REFERENCES boards(id) NOT NULL,
    role_id UUID REFERENCES board_roles(id) NOT NULL,
    joined_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    category VARCHAR(50),
    order_index INT
);

CREATE TABLE role_permissions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    board_role_id UUID REFERENCES board_roles(id) NOT NULL,
    permission_id UUID REFERENCES permissions(id) NOT NULL
);

CREATE TABLE task_priorities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) UNIQUE NOT NULL,
    order_index INT NOT NULL,
    color VARCHAR(7),
    icon VARCHAR(50)
);

CREATE TABLE task_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(50) UNIQUE NOT NULL,
    order_index INT NOT NULL,
    color VARCHAR(7),
    is_completed BOOLEAN DEFAULT false
);

CREATE TABLE task_tags (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(20) NOT NULL,
    color VARCHAR(7),
    board_id UUID REFERENCES boards(id) NOT NULL
);

CREATE TABLE tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(500) NOT NULL,
    description TEXT,
    board_id UUID REFERENCES boards(id) NOT NULL,
    creator_id UUID REFERENCES users(id) NOT NULL,
    assignee_id UUID REFERENCES users(id),
    priority_id UUID REFERENCES task_priorities(id),
    status_id UUID REFERENCES task_statuses(id),
    due_date TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    estimate_hours NUMERIC(5,2),
    position INT DEFAULT 0,
    task_tag_id UUID REFERENCES task_tags(id)
);

CREATE TABLE comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    content TEXT NOT NULL,
    task_id UUID REFERENCES tasks(id) NOT NULL,
    author_id UUID REFERENCES users(id) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE project_invitations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    board_id UUID REFERENCES boards(id) NOT NULL,
    inviter_id UUID REFERENCES users(id) NOT NULL,
    invitee_email VARCHAR(255) NOT NULL,
    token VARCHAR(100) UNIQUE NOT NULL,
    status_id UUID REFERENCES invitation_statuses(id) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now(),
    expires_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE activity_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_type VARCHAR(100) NOT NULL,
    description TEXT,
    user_id UUID REFERENCES users(id),
    board_id UUID REFERENCES boards(id),
    task_id UUID REFERENCES tasks(id),
    old_value TEXT,
    new_value TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

