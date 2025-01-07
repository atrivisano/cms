/*
  # Add profile creation policy

  1. Changes
    - Add RLS policy to allow users to create their own profile
    
  2. Security
    - Users can only create a profile with their own user ID
    - Maintains existing RLS policies
*/

CREATE POLICY "Users can create their own profile"
  ON profiles
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);