-- Drop existing table if needed
DROP TABLE IF EXISTS projects CASCADE;
DROP TABLE IF EXISTS project_timelines CASCADE;
DROP VIEW IF EXISTS projects_with_users;

-- Create projects table
CREATE TABLE projects (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    owner_id UUID NOT NULL REFERENCES auth.users(id),
    status TEXT DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    start_date_time TIMESTAMP WITH TIME ZONE,
    finish_date_time TIMESTAMP WITH TIME ZONE,
    completion_percentage TEXT,
    project_name TEXT,
    problem_name TEXT,
    solution_name TEXT,
    solution_function_name TEXT
);

-- Create project_timelines table
CREATE TABLE project_timelines (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    modified_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW())
);

-- Create a view that joins projects with users
CREATE VIEW projects_with_users AS
SELECT 
    p.*,
    u.id as user_id,
    u.email,
    u.raw_user_meta_data->>'first_name' as first_name,
    u.raw_user_meta_data->>'last_name' as last_name,
    u.raw_user_meta_data->>'phone_number' as phone_number,
    u.raw_user_meta_data->>'username' as username,
    u.raw_user_meta_data->>'avatar_url' as avatar_url,
    u.raw_user_meta_data->>'title' as user_title,
    u.raw_user_meta_data->>'expertise' as expertise,
    u.raw_user_meta_data->>'account_type' as account_type,
    u.created_at as user_created_at,
    u.raw_user_meta_data->>'minimum_rate' as minimum_rate
FROM projects p
LEFT JOIN auth.users u ON p.owner_id = u.id;

-- Enable Row Level Security
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE project_timelines ENABLE ROW LEVEL SECURITY;

-- Create policies for projects
-- Users can view their own projects
CREATE POLICY "Users can view own projects" ON projects
    FOR SELECT
    USING (auth.uid() = owner_id);

-- Users can insert their own projects
CREATE POLICY "Users can create own projects" ON projects
    FOR INSERT
    WITH CHECK (auth.uid() = owner_id);

-- Users can update their own projects
CREATE POLICY "Users can update own projects" ON projects
    FOR UPDATE
    USING (auth.uid() = owner_id);

-- Users can delete their own projects
CREATE POLICY "Users can delete own projects" ON projects
    FOR DELETE
    USING (auth.uid() = owner_id);

-- Create policies for project_timelines
-- Users can view timelines of their own projects
CREATE POLICY "Users can view own project timelines" ON project_timelines
    FOR SELECT
    USING (auth.uid() = (SELECT owner_id FROM projects WHERE id = project_id));

-- Users can insert timelines for their own projects
CREATE POLICY "Users can create own project timelines" ON project_timelines
    FOR INSERT
    WITH CHECK (auth.uid() = (SELECT owner_id FROM projects WHERE id = project_id));

-- Users can update timelines of their own projects
CREATE POLICY "Users can update own project timelines" ON project_timelines
    FOR UPDATE
    USING (auth.uid() = (SELECT owner_id FROM projects WHERE id = project_id));

-- Users can delete timelines of their own projects
CREATE POLICY "Users can delete own project timelines" ON project_timelines
    FOR DELETE
    USING (auth.uid() = (SELECT owner_id FROM projects WHERE id = project_id));

-- Enable RLS on the view
ALTER VIEW projects_with_users SET (security_invoker = on);

-- Create policy for the view
CREATE POLICY "Users can view own projects with users" ON projects_with_users
    FOR SELECT
    USING (auth.uid() = owner_id); 