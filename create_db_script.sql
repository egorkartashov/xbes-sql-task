CREATE TABLE "game" (
	"id" integer NOT NULL,
	"name" varchar(127) NOT NULL,
	"description" varchar(255) NOT NULL,
	CONSTRAINT "game_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "user" (
	"id" varchar(12) NOT NULL,
	"name" varchar(100) NOT NULL,
	CONSTRAINT "user_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "payment_account" (
	"token" varchar(12) NOT NULL,
	"payment_system_type_id" integer NOT NULL,
	CONSTRAINT "payment_account_pk" PRIMARY KEY ("token")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "payment_system_type" (
	"id" serial NOT NULL,
	"payment_system_type" serial NOT NULL,
	CONSTRAINT "payment_system_type_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "payment" (
	"id" integer NOT NULL,
	"date" timestamp NOT NULL,
	"user_id" varchar(12) NOT NULL,
	"payment_account_token" varchar(12) NOT NULL,
	CONSTRAINT "payment_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "payment_entry" (
	"id" integer NOT NULL,
	"payment_id" integer NOT NULL,
	"game_price_id" integer NOT NULL,
	"game_price_when_paying" FLOAT NOT NULL,
	"payment_currency_id" integer NOT NULL,
	"payment_amount_no_vat" FLOAT NOT NULL,
	"vat" integer NOT NULL,
	"canceled" BOOLEAN NOT NULL,
	CONSTRAINT "payment_entry_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "game_price" (
	"id" serial NOT NULL,
	"game_id" integer NOT NULL,
	"currency_id" integer NOT NULL,
	"price" FLOAT NOT NULL,
	CONSTRAINT "game_price_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "currency" (
	"id" integer NOT NULL,
	"short_name" varchar(10) NOT NULL,
	CONSTRAINT "currency_pk" PRIMARY KEY ("id")
) WITH (
  OIDS=FALSE
);





ALTER TABLE "payment_account" ADD CONSTRAINT "payment_account_fk0" FOREIGN KEY ("payment_system_type_id") REFERENCES "payment_system_type"("id");


ALTER TABLE "payment" ADD CONSTRAINT "payment_fk0" FOREIGN KEY ("user_id") REFERENCES "user"("id");
ALTER TABLE "payment" ADD CONSTRAINT "payment_fk1" FOREIGN KEY ("payment_account_token") REFERENCES "payment_account"("token");

ALTER TABLE "payment_entry" ADD CONSTRAINT "payment_entry_fk0" FOREIGN KEY ("payment_id") REFERENCES "payment"("id");
ALTER TABLE "payment_entry" ADD CONSTRAINT "payment_entry_fk1" FOREIGN KEY ("game_price_id") REFERENCES "game_price"("id");
ALTER TABLE "payment_entry" ADD CONSTRAINT "payment_entry_fk2" FOREIGN KEY ("payment_currency_id") REFERENCES "currency"("id");

ALTER TABLE "game_price" ADD CONSTRAINT "game_price_fk0" FOREIGN KEY ("game_id") REFERENCES "game"("id");
ALTER TABLE "game_price" ADD CONSTRAINT "game_price_fk1" FOREIGN KEY ("currency_id") REFERENCES "currency"("id");


-- Создаем индекс на дату, т.к. нужны запросы за заданный период
CREATE INDEX "ix_payment_date" ON "payment" ("date")

-- Была мысль сделать индкекс на payment_entry.canceled, но в этом особо не будет смысла, поскольку:
-- * лишь малая часть покупок отменяется
-- * при выборке успешных покупок и так придется пройти почти по всей таблице
-- * вряд ли потребуется запрос на только отмененные покупки
