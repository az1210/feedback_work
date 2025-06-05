-- Drop existing table if needed (comment this out if you don't want to reset the table)
DROP TABLE IF EXISTS categories CASCADE;

-- Create categories table
CREATE TABLE categories (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    category_title TEXT NOT NULL UNIQUE,
    category_icon TEXT DEFAULT '',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW())
);

-- Enable Row Level Security
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

-- Create policy to allow all users to read categories
CREATE POLICY "Allow all users to read categories" ON categories
    FOR SELECT
    USING (true);

-- Insert predefined categories
INSERT INTO categories (category_title) VALUES
    ('Social Media'),
    ('Automotive & Mechanics'),
    ('Accounting, Consulting & Finance'),
    ('Education & Tutoring'),
    ('Arts & Creative'),
    ('IT, Data & Analytics'),
    ('Engineering & Architecture'),
    ('Web, Mobile & Software Development'),
    ('Business Support & Admin'),
    ('Sales & Marketing'),
    ('Legal Services'),
    ('Writing & Translation'),
    ('Health & Beauty'),
    ('Home & Real Estate'),
    ('Lifestyle'),
    ('Sports & Outdoors');

-- Verify the data was inserted
SELECT * FROM categories; 