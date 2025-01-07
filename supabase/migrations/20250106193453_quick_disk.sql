/*
  # Fix Categories Migration

  This migration ensures policies are created only if they don't exist yet.
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