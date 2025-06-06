# Creating the ECFS Table in Supabase

The app requires an `ecfs` table in the Supabase database to function properly. This table is used for storing error correction feedback in the feedback workflow.

## Error Message

If you see the following error in your app logs:

```
PostgrestException(message: relation "public.ecfs" does not exist, code: 42P01, details: Not Found, hint: null)
```

It means the `ecfs` table doesn't exist in your Supabase database.

## Solution

To create the table, execute the SQL script provided in the `ecfs_table_creation.sql` file in your Supabase SQL editor.

### Steps:

1. Log in to your Supabase dashboard
2. Navigate to the SQL Editor
3. Create a new query
4. Copy and paste the contents of the `ecfs_table_creation.sql` file into the query editor
5. Run the query

The script will:
- Create the `ecfs` table if it doesn't exist
- Set up appropriate Row Level Security (RLS) policies
- Create a function `ensure_ecfs_table_exists()` that can be called from the app

## Table Structure

The `ecfs` table has the following structure:

```sql
CREATE TABLE IF NOT EXISTS public.ecfs (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at timestamp with time zone DEFAULT now(),
    correction_message jsonb,
    feedback_id uuid REFERENCES public.feedbacks(id) ON DELETE CASCADE
);
```

## Important Note on Column Names

In the database:
- Table column names follow snake_case convention (e.g., `correction_message`, `feedback_id`)
- However, in the Feedbacks table, some column names use camelCase (e.g., `ownerId`, `providerId`)

**PostgreSQL Case Sensitivity**: When referencing columns with mixed case in PostgreSQL:
- You must enclose them in double quotes: `f."ownerId"` instead of `f.ownerId`
- Without quotes, PostgreSQL treats them as case-insensitive (e.g., `f.ownerid`)
- With quotes, the exact case must match

Make sure the SQL queries you write match the exact column names used in each table and use double quotes around case-sensitive identifiers.

## App Behavior

The app has been updated to handle the missing table gracefully:
- It will attempt to create the table if it doesn't exist (requires admin privileges)
- If it cannot create the table, it will log an error but continue to function
- Any features that depend on the `ecfs` table will show empty data if the table is missing

After creating the table, restart your app to ensure all features work correctly. 