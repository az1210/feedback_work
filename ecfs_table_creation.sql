-- First, create the ecfs table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.ecfs (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at timestamp with time zone DEFAULT now(),
    correction_message jsonb,
    feedback_id uuid REFERENCES public.feedbacks(id) ON DELETE CASCADE
);

-- Add RLS policies for the ecfs table
ALTER TABLE public.ecfs ENABLE ROW LEVEL SECURITY;

-- Allow anyone to select ecfs that are associated with a feedback they're involved in
CREATE POLICY "Anyone can view ecfs for feedbacks they're involved in" ON public.ecfs
    FOR SELECT
    USING (feedback_id IN (
        SELECT f.id FROM feedbacks f
        WHERE f."ownerId" = auth.uid() OR f."providerId" = auth.uid()
    ));

-- Allow anyone to insert ecfs for feedbacks they're involved in
CREATE POLICY "Anyone can insert ecfs for feedbacks they're involved in" ON public.ecfs
    FOR INSERT
    WITH CHECK (feedback_id IN (
        SELECT f.id FROM feedbacks f
        WHERE f."ownerId" = auth.uid() OR f."providerId" = auth.uid()
    ));

-- Create the function to ensure the ecfs table exists
CREATE OR REPLACE FUNCTION public.ensure_ecfs_table_exists()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Check if the table exists
    IF NOT EXISTS (
        SELECT FROM pg_tables
        WHERE schemaname = 'public'
        AND tablename = 'ecfs'
    ) THEN
        -- Create the table if it doesn't exist
        CREATE TABLE public.ecfs (
            id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
            created_at timestamp with time zone DEFAULT now(),
            correction_message jsonb,
            feedback_id uuid REFERENCES public.feedbacks(id) ON DELETE CASCADE
        );

        -- Add RLS policies
        ALTER TABLE public.ecfs ENABLE ROW LEVEL SECURITY;

        -- Allow anyone to select ecfs that are associated with a feedback they're involved in
        CREATE POLICY "Anyone can view ecfs for feedbacks they're involved in" ON public.ecfs
            FOR SELECT
            USING (feedback_id IN (
                SELECT f.id FROM feedbacks f
                WHERE f."ownerId" = auth.uid() OR f."providerId" = auth.uid()
            ));

        -- Allow anyone to insert ecfs for feedbacks they're involved in
        CREATE POLICY "Anyone can insert ecfs for feedbacks they're involved in" ON public.ecfs
            FOR INSERT
            WITH CHECK (feedback_id IN (
                SELECT f.id FROM feedbacks f
                WHERE f."ownerId" = auth.uid() OR f."providerId" = auth.uid()
            ));
    END IF;
END;
$$;

-- Grant execute permission on the function
GRANT EXECUTE ON FUNCTION public.ensure_ecfs_table_exists() TO authenticated;
GRANT EXECUTE ON FUNCTION public.ensure_ecfs_table_exists() TO service_role; 