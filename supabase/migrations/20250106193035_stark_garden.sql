/*
  # Add Categories Support
  
  1. New Tables
    - `categories`
      - `id` (uuid, primary key)
      - `name` (text, unique)
      - `slug` (text, unique)
      - `description` (text)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)
    - `posts_categories` (junction table)
      - `post_id` (uuid, foreign key)
      - `category_id` (uuid, foreign key)
  
  2. Security
    - Enable RLS on both tables
    - Add policies for viewing and managing categories
*/

-- Create categories table
CREATE TABLE IF NOT EXISTS categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  slug text NOT NULL UNIQUE,
  description text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create posts_categories junction table
CREATE TABLE IF NOT EXISTS posts_categories (
  post_id uuid REFERENCES posts(id) ON DELETE CASCADE,
  category_id uuid REFERENCES categories(id) ON DELETE CASCADE,
  PRIMARY KEY (post_id, category_id)
);

-- Enable RLS
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE posts_categories ENABLE ROW LEVEL SECURITY;

-- Categories policies
CREATE POLICY "Categories are viewable by everyone"
  ON categories FOR SELECT
  USING (true);

CREATE POLICY "Only authenticated users can manage categories"
  ON categories
  FOR ALL
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Posts categories policies
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
CREATE TRIGGER update_categories_updated_at
  BEFORE UPDATE ON categories
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();