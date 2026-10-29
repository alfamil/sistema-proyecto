import { createClient } from '@supabase/supabase-js';

// Get credentials from localStorage or environment variables
const storedUrl = typeof window !== 'undefined' ? localStorage.getItem('sgaf_supabase_url') : null;
const storedKey = typeof window !== 'undefined' ? localStorage.getItem('sgaf_supabase_anon_key') : null;

const rawUrl = storedUrl || (import.meta as any).env?.VITE_SUPABASE_URL || '';
// Clean trailing slashes and /rest/v1 if included
export const supabaseUrl = rawUrl.replace(/\/rest\/v1\/?$/, '').replace(/\/+$/, '').trim();
export const supabaseAnonKey = (storedKey || (import.meta as any).env?.VITE_SUPABASE_ANON_KEY || '').trim();

export const isSupabaseConfigured = Boolean(supabaseUrl && supabaseAnonKey && supabaseUrl.startsWith('http'));

export const supabase = isSupabaseConfigured
  ? createClient(supabaseUrl, supabaseAnonKey)
  : null;

export function saveSupabaseConfig(url: string, anonKey: string) {
  if (typeof window !== 'undefined') {
    const clean = url.replace(/\/rest\/v1\/?$/, '').replace(/\/+$/, '').trim();
    localStorage.setItem('sgaf_supabase_url', clean);
    localStorage.setItem('sgaf_supabase_anon_key', anonKey.trim());
    window.location.reload();
  }
}

export function clearSupabaseConfig() {
  if (typeof window !== 'undefined') {
    localStorage.removeItem('sgaf_supabase_url');
    localStorage.removeItem('sgaf_supabase_anon_key');
    window.location.reload();
  }
}
