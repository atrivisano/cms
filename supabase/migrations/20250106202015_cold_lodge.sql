/*
  # Insert Sample Posts
  
  1. Data
    - Creates sample blog posts with proper content
    - Links posts to existing categories
  2. Structure
    - Uses DO block for transaction safety
    - Handles user ID lookup
    - Proper error handling
*/

DO $$ 
DECLARE
  user_id uuid;
  post_id uuid;
  tech_cat_id uuid;
  dev_cat_id uuid;
  design_cat_id uuid;
  tutorial_cat_id uuid;
  productivity_cat_id uuid;
BEGIN
  -- Get first user's ID
  SELECT id INTO user_id FROM auth.users LIMIT 1;
  
  -- Get category IDs
  SELECT id INTO tech_cat_id FROM categories WHERE slug = 'technology';
  SELECT id INTO dev_cat_id FROM categories WHERE slug = 'development';
  SELECT id INTO design_cat_id FROM categories WHERE slug = 'design';
  SELECT id INTO tutorial_cat_id FROM categories WHERE slug = 'tutorials';
  SELECT id INTO productivity_cat_id FROM categories WHERE slug = 'productivity';

  -- Only proceed if we have a user and categories
  IF user_id IS NOT NULL AND tech_cat_id IS NOT NULL THEN
    -- Insert sample posts
    INSERT INTO posts (
      title, slug, content, excerpt, featured_image, author_id, status,
      meta_title, meta_description, published_at
    ) VALUES (
      'Building Modern Web Applications',
      'building-modern-web-applications',
      '{"blocks":[{"type":"paragraph","content":"Modern web development requires a solid understanding of various technologies and best practices. In this comprehensive guide, we''ll explore the essential concepts and tools needed to build robust web applications.\n\nKey topics covered:\n- Frontend frameworks and libraries\n- State management patterns\n- API integration strategies\n- Performance optimization techniques\n\nBy following these principles, you''ll be well-equipped to create scalable and maintainable web applications."}]}',
      'Learn how to build scalable and maintainable web applications using modern technologies',
      'https://images.unsplash.com/photo-1517694712202-14dd9538aa97',
      user_id,
      'published',
      'Modern Web Application Development Guide',
      'Comprehensive guide to building modern web applications',
      NOW()
    ) RETURNING id INTO post_id;

    -- Link post to categories
    IF post_id IS NOT NULL THEN
      INSERT INTO posts_categories (post_id, category_id) VALUES
      (post_id, dev_cat_id),
      (post_id, tech_cat_id);
    END IF;

    -- Insert another post
    INSERT INTO posts (
      title, slug, content, excerpt, featured_image, author_id, status,
      meta_title, meta_description, published_at
    ) VALUES (
      'Mastering Web Design Principles',
      'mastering-web-design-principles',
      '{"blocks":[{"type":"paragraph","content":"Creating effective web designs requires understanding fundamental principles and user experience concepts. This guide covers essential aspects of modern web design.\n\nKey principles discussed:\n- Visual hierarchy and layout\n- Color theory and typography\n- Responsive design patterns\n- User interface components\n\nMaster these concepts to create engaging and user-friendly websites."}]}',
      'Essential principles for creating effective and user-friendly web designs',
      'https://images.unsplash.com/photo-1507238691740-187a5b1d37b8',
      user_id,
      'published',
      'Web Design Principles Guide',
      'Learn essential web design principles and best practices',
      NOW() - INTERVAL '1 day'
    ) RETURNING id INTO post_id;

    -- Link post to categories
    IF post_id IS NOT NULL THEN
      INSERT INTO posts_categories (post_id, category_id) VALUES
      (post_id, design_cat_id),
      (post_id, tutorial_cat_id);
    END IF;
  END IF;
END $$;