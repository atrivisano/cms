/*
  # Create posts table and related schemas

  1. New Tables
    - `posts`
      - `id` (uuid, primary key)
      - `title` (text, required)
      - `slug` (text, unique, required)
      - `content` (jsonb, required) - Stores structured content
      - `featured_image` (text) - URL of featured image
      - `excerpt` (text) - Short description
      - `author_id` (uuid, references profiles)
      - `status` (text) - draft/published
      - `meta_title` (text)
      - `meta_description` (text)
      - `published_at` (timestamptz)
      - `created_at` (timestamptz)
      - `updated_at` (timestamptz)

  2. Security
    - Enable RLS on posts table
    - Add policies for authenticated users to manage their posts
    - Allow public access to published posts
*/

-- Create posts table
CREATE TABLE IF NOT EXISTS posts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  slug text NOT NULL UNIQUE,
  content jsonb NOT NULL DEFAULT '{}',
  featured_image text,
  excerpt text,
  author_id uuid REFERENCES profiles(id) NOT NULL,
  status text NOT NULL DEFAULT 'draft',
  meta_title text,
  meta_description text,
  published_at timestamptz,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Public can view published posts"
  ON posts
  FOR SELECT
  USING (status = 'published');

CREATE POLICY "Authors can manage their own posts"
  ON posts
  FOR ALL
  TO authenticated
  USING (author_id = auth.uid())
  WITH CHECK (author_id = auth.uid());

-- Create function to update updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger for updated_at
CREATE TRIGGER update_posts_updated_at
  BEFORE UPDATE ON posts
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();