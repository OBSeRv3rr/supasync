-- Создаём базу данных, если её нет
CREATE DATABASE powersync_storage;

-- 1. Создать схему для хранения PowerSync (если ещё не создана)
CREATE SCHEMA IF NOT EXISTS powersync_storage AUTHORIZATION postgres;

-- 2. Создать таблицы, если PowerSync не создаст их автоматически
-- (PowerSync сам создаст нужные структуры при первом запуске, но можно задать вручную)

-- 3. Создать публикацию для логической репликации
CREATE PUBLICATION powersync FOR ALL TABLES;

-- 4. Назначить привилегии пользователю PowerSync
GRANT USAGE ON SCHEMA powersync_storage TO postgres;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA powersync_storage TO postgres;
ALTER DEFAULT PRIVILEGES IN SCHEMA powersync_storage GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO postgres;

\c powersync_storage;

CREATE TABLE public.lists (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  name text NOT NULL,
  owner_id uuid NOT NULL,
  CONSTRAINT lists_pkey PRIMARY KEY (id)
);

CREATE TABLE public.todos (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  completed_at timestamp with time zone,
  description text NOT NULL,
  completed boolean NOT NULL DEFAULT false,
  created_by uuid,
  completed_by uuid,
  list_id uuid NOT NULL,
  CONSTRAINT todos_pkey PRIMARY KEY (id),
  CONSTRAINT todos_list_id_fkey FOREIGN KEY (list_id) REFERENCES public.lists (id) ON DELETE CASCADE
);