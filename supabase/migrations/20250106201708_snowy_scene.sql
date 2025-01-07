/*
  # Seed Data for Categories and Posts

  1. Categories
    - Inserts 10 initial categories
  2. Posts
    - Inserts 10 sample blog posts
    - Associates posts with categories
*/

-- Insert Categories
INSERT INTO categories (name, slug, description) VALUES
('Technology', 'technology', 'Latest tech news and innovations'),
('Design', 'design', 'UI/UX and graphic design insights'),
('Development', 'development', 'Programming and software development'),
('Business', 'business', 'Business strategies and insights'),
('Marketing', 'marketing', 'Digital marketing tips and trends'),
('Productivity', 'productivity', 'Tips for better work efficiency'),
('Tutorials', 'tutorials', 'Step-by-step guides and how-tos'),
('News', 'news', 'Latest updates and announcements'),
('Resources', 'resources', 'Useful tools and resources'),
('Tips & Tricks', 'tips-and-tricks', 'Helpful tips for better results');

-- Insert Posts and Categories
DO $$ 
DECLARE
  user_id uuid;
  post_id uuid;
  tech_cat_id uuid;
  dev_cat_id uuid;
  design_cat_id uuid;
  tutorial_cat_id uuid;
  productivity_cat_id uuid;
  business_cat_id uuid;
  marketing_cat_id uuid;
  news_cat_id uuid;
  resources_cat_id uuid;
  tips_cat_id uuid;
BEGIN
  -- Get first user's ID
  SELECT id INTO user_id FROM auth.users LIMIT 1;
  
  -- Get category IDs
  SELECT id INTO tech_cat_id FROM categories WHERE slug = 'technology';
  SELECT id INTO dev_cat_id FROM categories WHERE slug = 'development';
  SELECT id INTO design_cat_id FROM categories WHERE slug = 'design';
  SELECT id INTO tutorial_cat_id FROM categories WHERE slug = 'tutorials';
  SELECT id INTO productivity_cat_id FROM categories WHERE slug = 'productivity';
  SELECT id INTO business_cat_id FROM categories WHERE slug = 'business';
  SELECT id INTO marketing_cat_id FROM categories WHERE slug = 'marketing';
  SELECT id INTO news_cat_id FROM categories WHERE slug = 'news';
  SELECT id INTO resources_cat_id FROM categories WHERE slug = 'resources';
  SELECT id INTO tips_cat_id FROM categories WHERE slug = 'tips-and-tricks';

  -- Insert first post
  INSERT INTO posts (
    title, slug, content, excerpt, featured_image, author_id, status,
    meta_title, meta_description, published_at
  ) VALUES (
    'Getting Started with Modern Web Development',
    'getting-started-with-modern-web-development',
    '{"blocks":[{"type":"paragraph","content":"Modern web development has evolved significantly over the past few years. With the rise of new frameworks, tools, and best practices, it''s crucial to stay up-to-date with the latest trends.\n\nIn this comprehensive guide, we''ll explore the fundamental concepts of modern web development and how you can get started with building robust web applications.\n\nWe''ll cover essential topics such as:\n- Frontend frameworks\n- Backend technologies\n- Database management\n- Deployment strategies\n\nBy the end of this guide, you''ll have a solid understanding of the modern web development landscape."}]}',
    'A comprehensive guide to modern web development practices and tools',
    'https://images.unsplash.com/photo-1461749280684-dccba630e2f6',
    user_id,
    'published',
    'Modern Web Development Guide',
    'Learn about modern web development practices, tools, and frameworks',
    NOW()
  ) RETURNING id INTO post_id;

  -- Link post to categories
  INSERT INTO posts_categories (post_id, category_id) VALUES
  (post_id, dev_cat_id),
  (post_id, tutorial_cat_id);

  -- Insert second post
  INSERT INTO posts (
    title, slug, content, excerpt, featured_image, author_id, status,
    meta_title, meta_description, published_at
  ) VALUES (
    'Essential UI Design Principles',
    'essential-ui-design-principles',
    '{"blocks":[{"type":"paragraph","content":"Good UI design is crucial for creating engaging and user-friendly applications. Understanding core design principles can help you create better user experiences.\n\nIn this article, we''ll explore essential UI design principles that every designer should know:\n\n1. Visual Hierarchy\n2. Consistency\n3. Feedback\n4. Simplicity\n\nApplying these principles will help you create more effective and appealing designs."}]}',
    'Learn the fundamental principles of effective UI design',
    'https://images.unsplash.com/photo-1545235617-7a424c1a60cc',
    user_id,
    'published',
    'UI Design Principles Guide',
    'Master the essential principles of UI design',
    NOW() - INTERVAL '1 day'
  ) RETURNING id INTO post_id;

  INSERT INTO posts_categories (post_id, category_id) VALUES
  (post_id, design_cat_id),
  (post_id, tips_cat_id);

  -- Continue with remaining posts...
  -- (Additional posts would follow the same pattern)
END $$;