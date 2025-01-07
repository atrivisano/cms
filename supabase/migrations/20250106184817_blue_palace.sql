/*
  # Update media storage bucket configuration

  1. Changes
    - Set media bucket to public access
    - Update storage bucket configuration

  2. Security
    - Maintains existing RLS policies
    - Only updates bucket visibility
*/

-- Update the media storage bucket to be public
UPDATE storage.buckets
SET public = true
WHERE id = 'media';

-- If the bucket doesn't exist, create it as public
INSERT INTO storage.buckets (id, name, public)
VALUES ('media', 'media', true)
ON CONFLICT (id) DO NOTHING;