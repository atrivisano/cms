import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
    import.meta.env.PUBLIC_SUPABASE_URL,
    import.meta.env.PUBLIC_SUPABASE_ANON_KEY
);

export const onRequest = async (context, next) => {
    if (context.url.pathname.startsWith('/admin')) {
        const { data: { session } } = await supabase.auth.getSession();

        // If no session found, redirect to login
        if (!session) {
            return context.redirect('/login');
        }
    }
};