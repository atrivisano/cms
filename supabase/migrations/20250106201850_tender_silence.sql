/*
  # Update Categories Schema and Policies
  
  1. Tables
    - Creates categories table if not exists
    - Creates posts_categories junction table if not exists
  2. Security
    - Enables RLS
    - Updates policies with proper error handling
*/

-- Drop existing policies if they exist
DO $$ BEGIN
  -- Categories policies
  IF EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'public' 
    AND tablename = 'categories' 
    AND policyname = 'Categories are viewable by everyone'
  ) THEN
    DROP POLICY "Categories are viewable by everyone" ON categories;
  END IF;

  IF EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'public' 
    AND tablename = 'categories' 
    AND policyname = 'Only authenticated users can manage categories'
  ) THEN
    DROP POLICY "Only authenticated users can manage categories" ON categories;
  END IF;

  -- Posts categories policies
  IF EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'public' 
    AND tablename = 'posts_categories' 
    AND policyname = 'Posts categories are viewable by everyone'
  ) THEN
    DROP POLICY "Posts categories are viewable by everyone" ON posts_categories;
  END IF;

  IF EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'public' 
    AND tablename = 'posts_categories' 
    AND policyname = 'Authors can manage their posts categories'
  ) THEN
    DROP POLICY "Authors can manage their posts categories" ON posts_categories;
  END IF;
END $$;

-- Create tables if they don't exist
CREATE TABLE IF NOT EXISTS categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  slug text NOT NULL UNIQUE,
  description text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS posts_categories (
  post_id uuid REFERENCES posts(id) ON DELETE CASCADE,
  category_id uuid REFERENCES categories(id) ON DELETE CASCADE,
  PRIMARY KEY (post_id, category_id)
);

-- Enable RLS
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE posts_categories ENABLE ROW LEVEL SECURITY;

-- Recreate policies
CREATE POLICY "Categories are viewable by everyone"
  ON categories FOR SELECT
  USING (true);

CREATE POLICY "Only authenticated users can manage categories"
  ON categories
  FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Posts categories are viewable by everyone"
  ON posts_categories FOR SELECT
  USING (true);

CREATE POLICY "Authors can manage their posts categories"
  ON posts_categories
  FOR ALL
  TO authenticated
  USING (EXISTS (
    SELECT 1 FROM posts 
    WHERE posts.id = post_id 
    AND posts.author_id = auth.uid()
  ))
  WITH CHECK (EXISTS (
    SELECT 1 FROM posts 
    WHERE posts.id = post_id 
    AND posts.author_id = auth.uid()
  ));

-- Add updated_at trigger for categories
CREATE OR REPLACE TRIGGER update_categories_updated_at
  BEFORE UPDATE ON categories
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();