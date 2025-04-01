CREATE TABLE "users" (
  "id" SERIAL PRIMARY KEY,
  "username" varchar(30) not null,
  "bio" varchar(400) not null default '', ---- ensures some value is returned 
  "avatar" varchar(200),
  "phone" varchar(20),---- no contraints applied as user can either use a phone or email
  "email" varchar(40),---- no contraints applied as user can either use a phone or email
  "password" varchar(50),
  "status" varchar(15),
  "created_at" timestamp with time zone default current_timestamp,
  "updated_at" timestamp with time zone default current_timestamp
  check (coalesce(phone,email)is not null)---- check if either of the fields hold a not null value
);

CREATE TABLE "posts" (
  "id" SERIAL PRIMARY KEY,
  "url" varchar(200) not null,
  "caption" varchar(240) default '',
  "lat" real check(lat is null or (lat>=-90 and lat<=90)),
  "lon" real check (lon is null or (lon >=-180 and lon <= 180)),
  "user_id" integer not null references users(id) on delete cascade,
  "created_at" timestamp with time zone default current_timestamp,
  "updated_at" timestamp with time zone default current_timestamp
);

CREATE TABLE "comments" (
  "id" SERIAL PRIMARY KEY,
  "contents" varchar(240) not null,
  "created_at" timestamp with time zone default current_timestamp,
  "updated_at" timestamp with time zone default current_timestamp,
  "user_id" integer not null references users(id) on delete cascade,
  "post_id" integer not null references posts(id) on delete cascade
);

CREATE TABLE "likes" (
  "id" SERIAL PRIMARY KEY,
  "user_id" integer not null references users(id) on delete cascade,
  "post_id" integer  references posts(id) on delete cascade,
  "comment_id" integer references "comments"(id) on delete cascade,
  "created_at" timestamp with time zone default current_timestamp,
  check(coalesce((post_id)::boolean::integer,0)+coalesce((comment_id)::boolean::integer,0)=1),
  unique(user_id,post_id,comment_id)
);

CREATE TABLE "photo_tags" (
  "id" SERIAL PRIMARY KEY,
  "user_id" integer not null references users(id) on delete cascade,
  "post_id" integer not null references posts(id) on delete cascade,
  "x_axis" integer not null,
  "y_axis" integer not null,
  "created_at" timestamp with time zone default current_timestamp,
  "updated_at" timestamp with time zone default current_timestamp,
  unique(user_id,post_id)
);

CREATE TABLE "caption_tags" (
  "id" SERIAL PRIMARY KEY,
  "user_id" integer not null references users(id) on delete cascade,
  "post_id" integer not null references posts(id) on delete cascade,
  "created_at" timestamp with time zone default current_timestamp,
  unique(user_id,post_id)
);

CREATE TABLE "hashtags" (
  "id" SERIAL PRIMARY KEY,
  "title" varchar(20) not null unique,
  "created_at" timestamp with time zone default current_timestamp
);

CREATE TABLE "hashtags_post" (
  "id" SERIAL PRIMARY KEY,
  "hashtag_id" integer not null references hashtags(id) on delete cascade,
  "post_id" integer not null references posts(id) on delete cascade,
  unique(hashtag_id,post_id)
);

CREATE TABLE "followers" (
  "id" SERIAL PRIMARY KEY,
  "leader_id" integer not null references users(id) on delete cascade,
  "follower_id" integer not null references users(id) on delete cascade,
  unique(leader_id,follower_id)
);
