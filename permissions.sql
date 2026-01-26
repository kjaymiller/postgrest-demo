-- Ensure the anonymous role exists
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'web_anon') THEN
    CREATE ROLE web_anon NOLOGIN;
  END IF;
END
$$;

-- Grant usage on the schema
GRANT USAGE ON SCHEMA public TO web_anon;

-- Grant SELECT permissions on specific tables
GRANT SELECT ON TABLE public.blog TO web_anon;
GRANT SELECT ON TABLE public.blog_tags TO web_anon;
GRANT SELECT ON TABLE public.conferences TO web_anon;
GRANT SELECT ON TABLE public.microblog TO web_anon;
GRANT SELECT ON TABLE public.microblog_tags TO web_anon;
GRANT SELECT ON TABLE public.notes TO web_anon;
GRANT SELECT ON TABLE public.notes_tags TO web_anon;
GRANT SELECT ON TABLE public.tags TO web_anon;

-- Grant SELECT on sequences (useful if you need to read current values)
-- Note: For INSERT privileges, you would typically need GRANT USAGE on sequences
GRANT SELECT ON SEQUENCE public.blog_id_seq TO web_anon;
GRANT SELECT ON SEQUENCE public.conferences_id_seq TO web_anon;
GRANT SELECT ON SEQUENCE public.microblog_id_seq TO web_anon;
GRANT SELECT ON SEQUENCE public.notes_id_seq TO web_anon;
GRANT SELECT ON SEQUENCE public.tags_id_seq TO web_anon;

-- Note: System views (pg_stat_statements) were excluded for security reasons.
-- Uncomment the following if you strictly intended to expose them:
-- GRANT SELECT ON TABLE public.pg_stat_statements TO web_anon;
-- GRANT SELECT ON TABLE public.pg_stat_statements_info TO web_anon;
