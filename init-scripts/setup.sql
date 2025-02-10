-- schema.sql
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

CREATE PUBLICATION powersync FOR TABLE public.lists, public.todos;
