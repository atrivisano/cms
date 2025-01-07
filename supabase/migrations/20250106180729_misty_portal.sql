/*
  # Additional profile policies

  1. Security
    - Add policy for public profile viewing
*/

-- Create policy for public profile viewing
CREATE POLICY "Public profiles are viewable by everyone"
  ON profiles FOR SELECT
  USING (true);