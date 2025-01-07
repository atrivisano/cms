/*
  # Update media storage configuration
  
  1. Changes
    - Set media bucket to public
    - Configure storage policies
  
  2. Security
    - Enable public access to media bucket
    - Maintain user-specific upload restrictions
*/

-- Create or update the media storage bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('media', 'media', true)
ON CONFLICT (id) DO UPDATE
SET public = true;

-- Ensure proper RLS policies for media bucket
CREATE POLICY "Allow public viewing of media"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'media');

-- Update existing upload policy to ensure proper path structure
CREATE POLICY "Authenticated users can upload to own folder"
ON storage.objects FOR INSERT 
TO authenticated
WITH CHECK (
  bucket_id = 'media' AND
  auth.uid()::text = (storage.foldername(name))[1]
);