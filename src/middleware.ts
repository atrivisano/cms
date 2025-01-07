import { defineMiddleware } from 'astro:middleware';
import { createClient } from '@supabase/supabase-js';
import type { MiddlewareResponseHandler } from 'astro';

const supabase = createClient(
  import.meta.env.PUBLIC_SUPABASE_URL,
  import.meta.env.PUBLIC_SUPABASE_ANON_KEY
);

export const onRequest: MiddlewareResponseHandler = defineMiddleware(async (context, next) => {
  const { locals, url, redirect } = context;

  // Check if the route is under /admin
  if (url.pathname.startsWith('/admin')) {
    const { data: { session }, error } = await supabase.auth.getSession();
    
    if (error || !session) {
      console.error('Auth error:', error);
      return redirect('/login');
    }
    
    // Add session to locals so it's available throughout the request
    locals.session = session;
    locals.user = session.user;

    // Continue with the request since user is authenticated
    return next();
  }

  // For non-admin routes, continue without authentication check
  return next();
});